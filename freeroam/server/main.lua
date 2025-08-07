Event.Add("OnPlayerKilled", function(player, damager, loss, hitBone, weapon, position)
	Timer.Set(function(player, pos)
        player:Respawn(pos)
    end, 5000, 1, player, position)

    print(position)
end)

Event.Add("OnPlayerTeleport", function(player)
    print("player " .. tostring(player) .. " teleported")
end)