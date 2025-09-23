Event.Add("OnPlayerKilled", function(player, damager, loss, hitBone, weapon, position)
	Timer.Set(function(player, pos)
        player:Respawn(pos)
    end, 5000, 1, player, position)

    print(position)
end)

Event.Add("OnPlayerTeleport", function(player)
    print("player " .. tostring(player) .. " teleported")
end)

Net.AddEvent("lmao1", function(position)
    for i = 1, 200 do
        local veh = World.SpawnVehicle("v401_plane_cargotransport_military_01", position + vec3(0, i * 10, 0))
    end
end)

Event.Add("OnVehicleDamage", function(vehicle, damager, loss, hitbone, weaponHash, hitposition)
	--Event.Cancel()
end)

Event.Add("OnPlayerDamage", function(vehicle, damager, loss, hitbone, weaponHash, hitposition)
	--Event.Cancel()
end)