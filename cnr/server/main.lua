local DeathMessages =
{
    Cops =
    {
        "%s dropped the badge faster than expected.",
        "%s got outplayed by street trash.",
        "%s will not be writing any more tickets today.",
        "We lost our beloved cop %s.",
        "%s is requesting backup... from heaven."
    },
    Robbers =
    {
        "%s failed the heist like an amateur.",
        "%s got clapped by the law.",
        "%s misplaced their loot... and their life.",
        "%s just proved crime does pay... in respawns.",
        "%s got escorted to the afterlife by the cops."
    }
}

local Vehicles =
{
    Cops =
    {
        "v000_car_atv_civilian_01",
        "v021_car_sportsmuscle_civilian_01",
        "v303_bike_modernsuper_civilian_01",
    },
    Robbers =
    {
        "v023_car_racingsuper_racing_01",
        "v025_car_vintagesuper_civilian_01",
        "v000_car_atv_civilian_01",
    }
}

local Weapons =
{
    Cops =
    {
        "wpn_001_assault_rifle",
        "wpn_022_shotgun",
        "wpn_032_sniper_rifle",
    },
    Robbers =
    {
        "wpn_050_smg",
        "wpn_021_shotgun",
    }
}

local GLOBAL = vec3(9666.298, 517.0919, 8122.316)
local MIN_PLAYERS = 2

local roundRunning = false
local roundVehicles = {}

Event.Add("OnPlayerKilled", function(player, damager, loss, weapon, position)
	if player:GetData("robber") then
		Chat.Broadcast(string.format(DeathMessages.Robbers[math.random(1, #DeathMessages.Robbers)], player:GetClient():GetName()))
	else
		Chat.Broadcast(string.format(DeathMessages.Cops[math.random(1, #DeathMessages.Cops)], player:GetClient():GetName()))
	end
end)

function startRound()
    local robberClient = World.GetRandomClient()
    if not robberClient then return end

    for _, vehicle in ipairs(roundVehicles) do
        World.Destroy(vehicle)
    end

    roundVehicles = {}

    for _, client in ipairs(World.GetPlayers()) do
        client:GetPlayer():SetData("robber", nil, false)
    end

    roundRunning = true

    local robber = robberClient:GetPlayer():AsPlayer()
    local robberCar = World.SpawnVehicle(Vehicles.Robbers[math.random(1, #Vehicles.Robbers)], GLOBAL + vec3(math.random(-200, 200), 1.0, math.random(-200, 200)), vec3(0, 0, 0))

    table.insert(roundVehicles, robberCar)

    robber:WarpIntoVehicle(robberCar, VehicleSeat.DriverSeat)
    robber:SetData("robber", true, false)
    robber:GiveWeapon(Weapons.Robbers[math.random(1, #Weapons.Robbers)], 500, WeaponSlot.Primary)

    Chat.Broadcast("[Robber] " .. robberClient:GetName() .. " is the robber!")

    spawnCops(robberClient)
end

function spawnCops(robberClient)
    local allClients = World.GetPlayers()
    local heliSpawned = false

    for _, client in ipairs(allClients) do
        if client ~= robberClient then
            local cop = client:GetPlayer():AsPlayer()
            local copVehicle = nil

            if not heliSpawned then
                copVehicle = World.SpawnVehicle("v203_helicopter_lightattack_military_01", cop:GetPosition() + vec3(0, 10, 0), vec3(0, 0, 0))
                heliSpawned = true
            else
                copVehicle = World.SpawnVehicle(Vehicles.Cops[math.random(1, #Vehicles.Cops)], GLOBAL + vec3(math.random(-200, 200), 1.0, math.random(-200, 200)), vec3(0, 0, 0))
            end

            table.insert(roundVehicles, copVehicle)

            cop:WarpIntoVehicle(copVehicle, VehicleSeat.DriverSeat)
            cop:GiveWeapon(Weapons.Cops[math.random(1, #Weapons.Cops)], 500, WeaponSlot.Primary)
            cop:SetData("robber", false, false)
        end
    end

    Chat.Broadcast("[Cops] All other players are now cops!")
end

function tryStartRound()
    if not roundRunning and #World.GetPlayers() >= MIN_PLAYERS then
        startRound()
    end
end

-- the round starts a moment after the join (1 s, the delay the old load-time round had)
Event.Add("OnPlayerJoin", function(client)
    Timer.Set(tryStartRound, 1000, 1)
end)

-- the round ends when too few players are left, the next "enough players" moment starts a new one
Event.Add("OnPlayerQuit", function(client)
    local left = 0

    for _, other in ipairs(World.GetPlayers()) do
        if other ~= client then left = left + 1 end
    end

    if left < MIN_PLAYERS then
        roundRunning = false
    end
end)

tryStartRound()