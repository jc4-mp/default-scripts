Event.Add("KeyDown", function(key)
    if Chat.IsTyping() then return end

    if key == Key.M then
		Net.Send("spawnTornado", Players.Local():GetGamePlayer():GetAimPosition())
    end
	
    if key == Key.N then
		Net.Send("setTornadoPos", Players.Local():GetGamePlayer():GetAimPosition())
    end
end)