local categories = require("animations")

local open_key = Key.Y

local webview = WebView.Create("animation-menu", {
	url = "resource://animation-menu/client/ui.html",
	size = Render.GetSize(),
	visible = false,
})

local open = false

-- path of the animation playing, the page marks it in the list
local current = nil

local function sendCurrent()
	local player = World.LocalPlayer()
	local animation = player and player:AsPlayer():GetAnimation() or ""

	if animation ~= current then
		current = animation
		WebView.SendMessage(webview, "current", { path = current })
	end
end

local function setOpen(value)
	open = value
	Input.SetEnabled(not open)
	UI.SetCursorVisible(open)
	WebView.SetVisible(webview, open)
	WebView.SetInputEnabled(webview, open)

	if open then
		WebView.BringToFront(webview)
		WebView.Focus(webview)
		sendCurrent()
	else
		WebView.BlurAll()
	end
end

Event.Add("OnKeyUp", function(key)
	if key == open_key and not open then
		setOpen(true)
	end
end)

Timer.Set(function()
	if open then sendCurrent() end
end, 250, -1)

WebView.SetMessageHandler(webview, function(event, data)
	if event == "close" then
		setOpen(false)
	elseif event == "play" then
		Local.PlayAnimation(data.path, true)
	elseif event == "stop" then
		Local.StopAnimation()
	end
end)

WebView.SendMessage(webview, "init", { close_key = open_key, categories = categories })