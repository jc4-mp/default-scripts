Net.AddEvent("registerLoginResult", function(msg)
	Chat.Print(msg)
end)

Net.AddEvent("loadPlayerInfo", function(position)
	Local.Teleport(position)
end)