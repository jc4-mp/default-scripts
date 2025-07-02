Event.Add("PlayerKilled", function(player)
    print("player " .. player:GetNetId() .. " has been killed.")
end)

Event.Add("PlayerDamage", function(player, loss)
    print("player " .. player:GetNetId() .. " damaged " .. loss .. " hp.")
end)