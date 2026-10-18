-- relays a player's message to everyone as "name: text"

Net.AddEvent("SimpleChat", function(text)
	local player = Net.Sender()

	if player and type(text) == "string" and text:find("%S") then
		Chat.Broadcast(player:GetName() .. ": " .. text:sub(1, 200))
	end
end)