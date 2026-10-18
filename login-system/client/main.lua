Net.AddEvent("registerLoginResult", function(msg)
	Event.Fire("AddChatMessage", { parts = { { text = msg } } })
end)