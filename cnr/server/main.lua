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

Event.Add("OnPlayerKilled", function(player, damager, loss, hitBone, weapon, position)
	if player:GetData("robber", false) then
		Chat.Broadcast(string.format(DeathMessages.Robbers[math.random(1, #DeathMessages.Robbers)], player:GetNick()))
	else
		Chat.Broadcast(string.format(DeathMessages.Cops[math.random(1, #DeathMessages.Cops)], player:GetNick()))
	end
end)

function startRound()
    local robberClient = Players.GetRandom()
    if not robberClient then return end

    local robber = robberClient:GetNetPlayer()
    local robberCar = World.SpawnVehicle(Vehicles.Robbers[math.random(1, #Vehicles.Robbers)], robber:GetPosition() + vec3(3, 0.2, 0), vec3(0, 0, 0))

    robberCar:SetMaxHealth(5000)
    robberCar:SetHealth(5000)

    robber:WarpIntoVehicle(robberCar, VehicleSeat.DriverSeat)
    robber:SetData("robber", true, false)
    robber:GiveWeapon(Weapons.Robbers[math.random(1, #Weapons.Robbers)], 500, WeaponSlot.Primary)

    Chat.Broadcast("[Robber] " .. robber:GetNick() .. " is the robber!")

    spawnCops(robberClient)
end

function spawnCops(robberClient)
    local allClients = Players.GetJoined()
    local heliSpawned = false

    for _, client in ipairs(allClients) do
        if client ~= robberClient then
            local cop = client:GetNetPlayer()
            local copVehicle = nil

            if not heliSpawned then
                copVehicle = World.SpawnVehicle("v203_helicopter_lightattack_military_01", cop:GetPosition() + vec3(0, 10, 0), vec3(0, 0, 0))
                heliSpawned = true
            else
                copVehicle = World.SpawnVehicle(Vehicles.Cops[math.random(1, #Vehicles.Cops)], cop:GetPosition() + vec3(0, 1, 0), vec3(0, 0, 0))
            end

            cop:WarpIntoVehicle(copVehicle, VehicleSeat.DriverSeat)
            cop:GiveWeapon(Weapons.Cops[math.random(1, #Weapons.Cops)], 500, WeaponSlot.Primary)
            cop:SetData("robber", false, false)
        end
    end

    Chat.Broadcast("[Cops] All other players are now cops!")
end

Timer.Set(function()
    startRound()
end, 1000, 1)