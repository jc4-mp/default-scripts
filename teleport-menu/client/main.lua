local locations = require("teleport_locations")

-- held down to show the menu, a location is picked by clicking its slice
local open_key = Key.G

local webview = WebView.Create("teleport-menu", {
	url = "resource://teleport-menu/client/ui.html",
	size = Render.GetSize(),
	visible = false,
})

local open = false

local function setOpen(value)
	open = value
	Input.SetEnabled(not open)
	UI.SetCursorVisible(open)
	WebView.SetVisible(webview, open)
	WebView.SetInputEnabled(webview, open)

	if open then
		WebView.BringToFront(webview)
		WebView.Focus(webview)
	else
		WebView.BlurAll()
	end
end

Event.Add("OnKeyDown", function(key)
	if key == open_key and not open then
		setOpen(true)
	end
end)

WebView.SetMessageHandler(webview, function(event, data)
	if event == "close" then
		setOpen(false)
	elseif event == "teleport" then
		local location = locations[data.index]

		if location then
			Net.Send("requestTeleport", location.position)
			setOpen(false)
		end
	end
end)

local names = {}

for i, location in ipairs(locations) do
	names[i] = location.name
end

WebView.SendMessage(webview, "init", { close_key = open_key, names = names })