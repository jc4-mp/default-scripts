Net.AddEvent("spawn", function(id, position)
    local veh = World.SpawnVehicle(id, position)

    veh:SetPrimaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetSecondaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetTertiaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetMetallic(math.random(0.0, 100.0) / 100.0)
end)

Net.AddEvent("spawnMg", function(id, position)
    World.SpawnMountedGun(id, position)
end)

Net.AddEvent("weapon", function(weapon_id, player)
    player:GetNetPlayer():GiveWeapon(weapon_id, 500, WeaponSlot.Primary)
end)