Net.AddEvent("spawn", function(id, position)
    World.SpawnVehicle(id, position)
end)

Net.AddEvent("weapon", function(weapon_id, player)
    player:GetNetPlayer():GiveWeapon(weapon_id, 500, true, WeaponSlot.Primary)
end)