Net.AddEvent("requestTeleport", function(position)
    local sender = Net.Sender()

    if sender then sender:GetNetPlayer():Teleport(position) end
end)