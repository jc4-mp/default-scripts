-- relays a player's message to everyone as "name: text", and the dashboard's announcements

Net.AddEvent("chat:send", function(text)
	local player = Net.Sender()

	if player and type(text) == "string" and text:find("%S") then
		Chat.Broadcast(player:GetName() .. ": " .. text:sub(1, 200))
	end
end)

Net.AddEvent("ClientAnnounceRequest", function(data)
	local text = type(data) == "table" and data.text

	if type(text) == "string" and text:find("%S") then
		Chat.Broadcast("[Announcement] " .. text:sub(1, 200))
	end
end)