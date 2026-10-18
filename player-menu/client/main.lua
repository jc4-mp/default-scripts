local open_key = Key.P

local webview = WebView.Create("player-menu", {
	url = "resource://player-menu/client/ui.html",
	size = Render.GetSize(),
	visible = false,
})

local open = false

-- clients have no pings (only the server keeps them), the server sends them every second while the menu is open:
-- net id -> ping
local pings = {}

local function sendPlayers()
	local players = {}

	for _, client in ipairs(World.GetPlayers()) do
		local ping = pings[client:GetNetId()]

		players[#players + 1] = {
			id = client:GetNetId(),
			ping = ping and tostring(math.floor(ping)) or "-",
			name = client:GetName() or "Loading...",
			can_warp = client:GetPlayer() ~= nil,
		}
	end

	WebView.SendMessage(webview, "players", players)
end

local function setOpen(value)
	open = value
	Input.SetEnabled(not open)
	UI.SetCursorVisible(open)
	WebView.SetVisible(webview, open)
	WebView.SetInputEnabled(webview, open)

	pings = {}
	Net.Send("playerMenu:open", open)

	if open then
		WebView.BringToFront(webview)
		WebView.Focus(webview)
		sendPlayers()
	else
		WebView.BlurAll()
	end
end

Event.Add("OnKeyUp", function(key)
	if key == open_key and not open then
		setOpen(true)
	end
end)

Net.AddEvent("playerMenu:pings", function(list)
	pings = {}

	for _, entry in ipairs(list) do
		pings[entry[1]] = entry[2]
	end

	sendPlayers()
end)

WebView.SetMessageHandler(webview, function(event, data)
	if event == "close" then
		setOpen(false)
	elseif event == "warp" then
		-- the server teleports this player to where it has the target
		Net.Send("playerMenu:warp", data.id)
		setOpen(false)
	end
end)

WebView.SendMessage(webview, "init", { close_key = open_key })