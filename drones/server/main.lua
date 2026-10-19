-- every player commands a squad of drones (client/main.lua has the keys). the squad follows the player in a ring over
-- their head, holds where it is or flies to where the player aims. it fires at the player's aim while they hold the fire
-- key, or hunts the closest other player: aims at them and fires

local TYPES = {
	{ id = "v254_helicopter_guarddrone_rebel", name = "Guard drone" },
	{ id = "v250_helicopter_mediumattackdrone_rebel", name = "Attack drone" },
	{ id = "v251_helicopter_rocketdrone_rebel", name = "Rocket drone" },
}

local MAX_DRONES = 6
local SPAWN_HEIGHT = 8
local FOLLOW_RADIUS = 5 -- the ring over the player's head
local FOLLOW_HEIGHT = 6
local SPOT_RADIUS = 4 -- the ring over a spot the squad flies to
local SPOT_HEIGHT = 8
local CHEST = vec3(0, 1.2, 0)
local HUNT_RANGE = 200
local WRECK_SECONDS = 10 -- a destroyed drone's wreck stays this long

local MODE_FOLLOW = "follow"
local MODE_HOLD = "hold"
local MODE_SPOT = "spot"

local squads = {} -- user id -> { drones, next_type, mode, spot, firing, aim, prey }

local function squad_of(client)
	local id = client:GetUserId()

	squads[id] = squads[id] or { drones = {}, next_type = 1, mode = MODE_FOLLOW, firing = false }

	return squads[id]
end

-- drone i of n's place on a ring of that radius at that height, around the ring's center
local function ring(i, n, radius, height)
	local angle = 2 * math.pi * (i - 1) / n

	return vec3(math.cos(angle) * radius, height, math.sin(angle) * radius)
end

local function send_state(client, squad)
	Net.SendToPlayer(client, "drones_state", #squad.drones, MAX_DRONES, TYPES[squad.next_type].name, squad.mode, squad.firing,
		squad.prey and squad.prey:GetName() or "")
end

-- sends every drone where the squad's mode puts it
local function apply_mode(client, squad)
	local player = client:GetPlayer()
	local n = #squad.drones

	for i, drone in ipairs(squad.drones) do
		if squad.mode == MODE_FOLLOW and player then
			drone:DroneFollow(player, ring(i, n, FOLLOW_RADIUS, FOLLOW_HEIGHT))
		elseif squad.mode == MODE_HOLD then
			drone:DroneFlyTo(drone:GetPosition())
		elseif squad.mode == MODE_SPOT and squad.spot then
			drone:DroneFlyTo(squad.spot + ring(i, n, SPOT_RADIUS, SPOT_HEIGHT))
		end
	end
end

-- aims every drone at the prey's chest, or the player's aim, and fires while there's either. they stop aiming when
-- there's neither
local function apply_aim(squad)
	for _, drone in ipairs(squad.drones) do
		if squad.prey and squad.prey:GetPlayer() then
			drone:DroneAimAt(squad.prey:GetPlayer(), CHEST)
		elseif squad.firing and squad.aim then
			drone:DroneAimAt(squad.aim)
		else
			drone:DroneStopAiming()
		end

		drone:DroneSetFiring(squad.prey ~= nil or (squad.firing and squad.aim ~= nil))
	end
end

local function remove_squad(client)
	local squad = squads[client:GetUserId()]
	if not squad then return end

	for _, drone in ipairs(squad.drones) do
		World.Destroy(drone)
	end

	squads[client:GetUserId()] = nil
end

Net.AddEvent("drones_state", function()
	local client = Net.Sender()

	send_state(client, squad_of(client))
end)

Net.AddEvent("drones_spawn", function()
	local client = Net.Sender()
	local player = client:GetPlayer()
	local squad = squad_of(client)

	if not player or #squad.drones >= MAX_DRONES then return end

	local drone = World.SpawnVehicle(TYPES[squad.next_type].id, player:GetPosition() + vec3(0, SPAWN_HEIGHT, 0))

	squad.drones[#squad.drones + 1] = drone
	squad.next_type = squad.next_type % #TYPES + 1

	apply_mode(client, squad)
	apply_aim(squad)
	send_state(client, squad)
end)

Net.AddEvent("drones_follow", function()
	local client = Net.Sender()
	local squad = squad_of(client)

	squad.mode = MODE_FOLLOW

	apply_mode(client, squad)
	send_state(client, squad)
end)

Net.AddEvent("drones_hold", function()
	local client = Net.Sender()
	local squad = squad_of(client)

	squad.mode = MODE_HOLD

	apply_mode(client, squad)
	send_state(client, squad)
end)

Net.AddEvent("drones_spot", function(position)
	local client = Net.Sender()
	local squad = squad_of(client)

	squad.mode = MODE_SPOT
	squad.spot = position

	apply_mode(client, squad)
	send_state(client, squad)
end)

-- the client sends its aim when the fire key goes down and while it's held, then nil when it's released
Net.AddEvent("drones_fire", function(aim)
	local client = Net.Sender()
	local squad = squad_of(client)
	local was_firing = squad.firing

	squad.firing = aim ~= nil
	squad.aim = aim

	apply_aim(squad)

	if squad.firing ~= was_firing then
		send_state(client, squad)
	end
end)

-- hunts the closest other player in range, a second press calls the hunt off
Net.AddEvent("drones_hunt", function()
	local client = Net.Sender()
	local player = client:GetPlayer()
	local squad = squad_of(client)

	if squad.prey or not player then
		squad.prey = nil
	else
		local closest = HUNT_RANGE

		for _, other in ipairs(World.GetPlayers()) do
			local other_player = other:GetPlayer()

			if other ~= client and other_player then
				local distance = other_player:GetPosition():distance(player:GetPosition())

				if distance < closest then
					closest = distance
					squad.prey = other
				end
			end
		end
	end

	apply_aim(squad)
	send_state(client, squad)
end)

Net.AddEvent("drones_remove", function()
	local client = Net.Sender()

	remove_squad(client)
	send_state(client, squad_of(client))
end)

Event.Add("OnPlayerQuit", function(client)
	remove_squad(client)

	-- a squad hunting the player that left calls the hunt off

	for _, other in ipairs(World.GetPlayers()) do
		local squad = squads[other:GetUserId()]

		if squad and squad.prey == client then
			squad.prey = nil

			apply_aim(squad)
			send_state(other, squad)
		end
	end
end)

-- a destroyed drone leaves its squad, which closes the ring, and its wreck goes after a while

Event.Add("OnVehicleDestroy", function(vehicle)
	for _, client in ipairs(World.GetPlayers()) do
		local squad = squads[client:GetUserId()]

		if squad then
			for i, drone in ipairs(squad.drones) do
				if drone == vehicle then
					table.remove(squad.drones, i)

					Timer.Set(function() World.Destroy(drone) end, WRECK_SECONDS * 1000, 1)

					apply_mode(client, squad)
					send_state(client, squad)

					return
				end
			end
		end
	end
end)