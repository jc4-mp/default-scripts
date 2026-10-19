-- spawns the civilians a player asks for (client/main.lua picks where) and walks each one to the target its player's
-- client picked, asking for the next target when it gets there: the server has no navigation data, the clients do

local CIVILIANS = {
	"civ_business_female_001", "civ_athletic_male_001", "civ_beachgoer_male_01",
	"civ_beachgoer_female_01", "civ_art_vendor_male_01", "civ_bartender_female_01",
}

local ARRIVE_DISTANCE = 1.5

local peds = {} -- user id -> { { npc, target, waiting } }

local function flat_distance(a, b)
	local x, z = a.x - b.x, a.z - b.z
	return math.sqrt(x * x + z * z)
end

local function despawn_peds(client)
	for _, ped in ipairs(peds[client:GetUserId()] or {}) do
		World.Destroy(ped.npc)
	end

	peds[client:GetUserId()] = nil
end

Net.AddEvent("navigation_spawn_peds", function(positions)
	local client = Net.Sender()

	despawn_peds(client)

	local list = {}

	for i, position in ipairs(positions) do
		list[i] = { npc = World.SpawnNPC(CIVILIANS[math.random(#CIVILIANS)], position), target = position, waiting = false }
	end

	peds[client:GetUserId()] = list
end)

Net.AddEvent("navigation_despawn_peds", function()
	despawn_peds(Net.Sender())
end)

-- the next target of a ped, nil when its client found none (it waits and asks again)

Net.AddEvent("navigation_ped_target", function(index, target)
	local ped = (peds[Net.Sender():GetUserId()] or {})[index]
	if not ped then return end

	ped.waiting = false

	if target then
		ped.target = target
	else
		ped.npc:Move(vec3(0, 0, 0), MoveType.Idle, MoveStyle.Normal)
	end
end)

Event.Add("OnPlayerQuit", despawn_peds)

-- steer each ped towards its target, and ask its client for the next one once it's there

Timer.Set(function()
	for _, client in ipairs(World.GetPlayers()) do
		for index, ped in ipairs(peds[client:GetUserId()] or {}) do
			local position = ped.npc:GetPosition()

			if ped.waiting then
				-- the client is picking the next target
			elseif flat_distance(position, ped.target) < ARRIVE_DISTANCE then
				ped.waiting = true

				Net.SendToPlayer(client, "navigation_ped_arrived", index, position)
			else
				ped.npc:Move(vec3(ped.target.x - position.x, 0, ped.target.z - position.z):normalize(), MoveType.Walk, MoveStyle.Normal)
			end
		end
	end
end, 250, -1)