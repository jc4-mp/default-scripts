Net.AddEvent("requestTeleport", function(position)
    local sender = Net.Sender()

    if sender then sender:GetPlayer():AsPlayer():Teleport(position) end
end)