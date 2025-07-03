Event.Add("PlayerKilled", function(player)
    print("player " .. player:GetNetId() .. " has been killed.")
end)

Event.Add("PlayerDamage", function(player, damager, loss, hitBone, weaponHash, position)
    print(damager:GetNetId() .. " damaged player " .. player:GetNetId() .. " with " .. loss .. " hp using weapon " .. weaponHash .. " at " .. tostring(position) .. " (bone: " .. hitBone .. ")")
end)