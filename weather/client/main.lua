Event.Add("KeyDown", function(key)
    if Chat.IsTyping() then return end

    if key == Key.M then
		Net.Send("spawnTornado", Players.Local():GI():GetAimPosition())
    end
	
    if key == Key.K then
		Net.Send("despawnTornado")
    end
	
    if key == Key.N then
		Net.Send("setTornadoPos", Players.Local():GI():GetAimPosition())
    end
end)