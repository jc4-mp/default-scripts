local vehicles = {}

Net.AddEvent("spawn", function(id, position, rotation, player)
    local pId = player:GetNetPlayer():GetNetId()

    if vehicles[pId] then
        World.Destroy(vehicles[pId])
        vehicles[pId] = nil
    end

    local veh = World.SpawnVehicle(id, position)

    veh:SetPrimaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetSecondaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetTertiaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetMetallic(math.random(0.0, 100.0) / 100.0)
    veh:SetRotation(rotation)

    vehicles[pId] = veh

    player:GetNetPlayer():WarpIntoVehicle(veh, VehicleSeat.DriverSeat)
end)

Net.AddEvent("spawnMg", function(id, position)
    World.SpawnMountedGun(id, position)
end)

Net.AddEvent("weapon", function(weapon_id, player)
    player:GetNetPlayer():GiveWeapon(weapon_id, 500, WeaponSlot.Primary)
end)