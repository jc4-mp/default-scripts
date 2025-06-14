Net.AddEvent("registerLoginResult", function(msg)
	Chat.Print(msg)
end)

Net.AddEvent("loadPlayerInfo", function(x, y, z)
	Local.Teleport(vec3(x, y, z))
end)