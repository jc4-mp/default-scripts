-- remote C4s: a client's /c4 (client/main.lua) asks to plant one in front of the player. they crouch down, put it on
-- the ground and stand back up, then the C4 stays there until they set it off or disarm it, from any distance

-- sent to each client when it joins
local config = {
	MODEL = "models/environments/locale_global/anim_props_b/anim_props_b_briefcase", -- a briefcase bomb, 37 x 29 x 12 cm
	PLANT_MS = 7000, -- from the player crouching down to standing up again
	MAX = 8, -- C4s a player can have planted at once
}

local MODEL_HEIGHT = 0.321 -- the briefcase hangs below its origin (the top of the handle), so it's raised this much

local EXPLOSION = "editor/entities/weapons/06_special/illapa_defence_weapon.epe" -- the biggest blast, 17 m

-- a one-off that starts and ends standing: down in about 2 s, crouched with the hands at the ground until about 5 s,
-- standing again at about 6.7 s (the clip is 8.13 s, the rest is standing still)
local PLANT_ANIMATION = "animations/characters/contextact/civilian/staged/investigate/ca_civ_staged_standinvestigate_oneoff_crouchdown.ban"
local DROP_MS = 3000 -- when the C4 is on the ground, the planting ends at config.PLANT_MS
local REACH = 3 -- how far from the player the spot they plant at can be

local owners = {} -- user id -> { c4s = { { object, id, position } }, planting }

local function owner_of(client)
	local id = client:GetUserId()

	owners[id] = owners[id] or { c4s = {}, planting = false }

	return owners[id]
end

local function character_of(client)
	local obj = client:GetPlayer()

	return obj and obj:AsPlayer()
end

local function send_state(client, owner)
	local c4s = {}

	for i, c4 in ipairs(owner.c4s) do
		c4s[i] = { id = c4.id, position = c4.position }
	end

	Net.SendToPlayer(client, "c4_state", c4s, owner.planting)
end

-- takes the C4 with that net id out of the owner's list, or all of them when id is nil
local function take(owner, id)
	local taken = {}

	for i = #owner.c4s, 1, -1 do
		if id == nil or owner.c4s[i].id == id then
			taken[#taken + 1] = table.remove(owner.c4s, i)
		end
	end

	return taken
end

Net.AddEvent("c4_state", function()
	local client = Net.Sender()

	Net.SendToPlayer(client, "c4_config", config)
	send_state(client, owner_of(client))
end)

-- the client sends the ground spot in front of the player and the player's heading in degrees, so the C4 faces the
-- way they do
Net.AddEvent("c4_plant", function(spot, yaw)
	local client = Net.Sender()
	local id = client:GetUserId()
	local player = character_of(client)
	local owner = owner_of(client)

	if type(yaw) ~= "number" or not player or player:GetVehicle() or owner.planting or #owner.c4s >= config.MAX then return end
	if player:GetPosition():distance(spot) > REACH then return end

	owner.planting = true

	player:PlayAnimation(PLANT_ANIMATION)
	send_state(client, owner)

	Timer.Set(function()
		if owners[id] ~= owner then return end -- they left while planting

		player = character_of(client)

		if player and player:GetHealth() > 0 then
			local object = World.SpawnRigidObject(spot + vec3(0, MODEL_HEIGHT, 0), config.MODEL .. ".modelc", config.MODEL .. "_col.pfxc",
				RigidObjectMotionType.Static, vec3(0, yaw, 0))

			owner.c4s[#owner.c4s + 1] = { object = object, id = object:GetNetId(), position = spot }

			send_state(client, owner)
		end
	end, DROP_MS, 1)

	-- they're standing again, the clip only has them standing still from here
	Timer.Set(function()
		if owners[id] ~= owner then return end

		owner.planting = false
		player = character_of(client)

		if player and player:GetAnimation() == PLANT_ANIMATION then
			player:StopAnimation()
		end

		send_state(client, owner)
	end, config.PLANT_MS, 1)
end)

-- id is the C4's net id, nil sets off all of them
Net.AddEvent("c4_detonate", function(id)
	local client = Net.Sender()
	local owner = owner_of(client)

	if id ~= nil and type(id) ~= "number" then return end

	for _, c4 in ipairs(take(owner, id)) do
		World.Destroy(c4.object)
		World.SpawnExplosion(c4.position, EXPLOSION)
	end

	send_state(client, owner)
end)

Net.AddEvent("c4_disarm", function(id)
	local client = Net.Sender()
	local owner = owner_of(client)

	if type(id) ~= "number" then return end

	for _, c4 in ipairs(take(owner, id)) do
		World.Destroy(c4.object)
	end

	send_state(client, owner)
end)

Event.Add("OnPlayerQuit", function(client)
	local owner = owners[client:GetUserId()]
	if not owner then return end

	for _, c4 in ipairs(owner.c4s) do
		World.Destroy(c4.object)
	end

	owners[client:GetUserId()] = nil
end)