Net.AddEvent("spawn", function(id, position)
    local veh = World.SpawnVehicle(id, position)

    --[[Timer.Set(function(vehicle)
        --vehicle:SetDirt(math.random(0.0, 1.0))
        vehicle:SetPrimaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
        vehicle:SetSecondaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
        vehicle:SetTertiaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
        vehicle:SetMetallic(math.random(0.0, 100.0) / 100.0)
    end, 500, 10000, veh)]]
end)

Net.AddEvent("spawnMg", function(id, position)
    World.SpawnMountedGun(id, position)
end)

Net.AddEvent("weapon", function(weapon_id, player)
    player:GetNetPlayer():GiveWeapon(weapon_id, 500, WeaponSlot.Primary)
end)