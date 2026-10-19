-- every player gets an armed NPC that aims at them, runs after them while they're over STOP_DISTANCE
-- away, fires while they hold the fire key, throws a grenade at their feet when they press the grenade key and
-- runs at them and hits them when they press the melee key (client/main.lua)

local NPC = "ghost_enemy_001"
local WEAPON = "wpn_000_assault_rifle"
local SPAWN_DISTANCE = 15
local STOP_DISTANCE = 10
local MELEE_DISTANCE = 1.5 -- the swing reaches 1.25 m
local AIM_OFFSET = vec3(0, 1.2, 0) -- the chest, from the player's feet

local shooters = {} -- user id -> { npc, running, melee }

local function spawn_shooter(client)
	local player = client:GetPlayer()
	if not player or shooters[client:GetUserId()] then return end

	local npc = World.SpawnNPC(NPC, player:GetPosition() + vec3(SPAWN_DISTANCE, 0, 0))

	npc:GiveWeapon(WEAPON)
	npc:AimAt(player, AIM_OFFSET)

	shooters[client:GetUserId()] = { npc = npc, running = false, melee = false }
end

local function remove_shooter(client)
	local shooter = shooters[client:GetUserId()]
	if not shooter then return end

	World.Destroy(shooter.npc)

	shooters[client:GetUserId()] = nil
end

Event.Add("OnResourceStart", function()
	for _, client in ipairs(World.GetPlayers()) do
		spawn_shooter(client)
	end
end)

Event.Add("OnPlayerJoin", spawn_shooter)
Event.Add("OnPlayerQuit", remove_shooter)

-- run after the player while too far without aiming, stop and aim again once close enough. a shooter running at
-- its player to hit them is left to the melee timer

Timer.Set(function()
	for _, client in ipairs(World.GetPlayers()) do
		local shooter = shooters[client:GetUserId()]
		local player = client:GetPlayer()

		if shooter and player and not shooter.melee then
			local far = player:GetPosition():distance(shooter.npc:GetPosition()) > STOP_DISTANCE

			if far and not shooter.running then
				shooter.npc:StopAiming()
				shooter.npc:Follow(player, MoveType.Sprint, MoveStyle.Normal)
			elseif not far and shooter.running then
				shooter.npc:Move(vec3(0, 0, 0), MoveType.Idle, MoveStyle.Normal)
				shooter.npc:AimAt(player, AIM_OFFSET)
			end

			shooter.running = far
		end
	end
end, 250, -1)

-- hit the player once in reach, checked often since a sprinting shooter covers over a meter in 250 ms

Timer.Set(function()
	for _, client in ipairs(World.GetPlayers()) do
		local shooter = shooters[client:GetUserId()]
		local player = client:GetPlayer()

		if shooter and player and shooter.melee and player:GetPosition():distance(shooter.npc:GetPosition()) <= MELEE_DISTANCE then
			shooter.npc:Melee(player)
			shooter.melee = false
		end
	end
end, 50, -1)

Net.AddEvent("npc_shooter_fire", function(enable)
	local shooter = shooters[Net.Sender():GetUserId()]

	if shooter then
		shooter.npc:SetFiring(enable == true)
	end
end)

Net.AddEvent("npc_shooter_grenade", function()
	local shooter = shooters[Net.Sender():GetUserId()]
	local player = Net.Sender():GetPlayer()

	if shooter and player then
		shooter.npc:ThrowGrenade(player:GetPosition())
	end
end)

-- the shooter stops aiming and runs at the player, the melee timer hits them once in reach. it's running then, so the
-- follow timer stops it and aims again once it's done

Net.AddEvent("npc_shooter_melee", function()
	local shooter = shooters[Net.Sender():GetUserId()]
	local player = Net.Sender():GetPlayer()

	if shooter and player and not shooter.melee then
		shooter.melee = true
		shooter.running = true

		shooter.npc:StopAiming()
		shooter.npc:Follow(player, MoveType.Sprint, MoveStyle.Normal)
	end
end)