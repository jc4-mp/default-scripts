-- a minimal chat: T opens it, Enter sends, Escape closes. /name args runs a Cmd.Add command

local webview = WebView.Create("simple-chat", {
	url = "resource://simple-chat/client/ui.html",
	position = vec2(10, Render.GetSize().y - 380),
	size = vec2(520, 300),
})

local open = false

local function set_open(state)
	open = state
	Input.SetEnabled(not state)
	UI.SetCursorVisible(state)
	WebView.SetInputEnabled(webview, state)
	WebView.SendMessage(webview, "open", state)

	if state then WebView.Focus(webview) else WebView.BlurAll() end
end

local function add(text)
	WebView.SendMessage(webview, "msg", text)
end

-- opens on key up so the T itself isn't typed into the input, and only for a T pressed while closed so the key up
-- of a message's last t, released after Enter closed the chat, doesn't reopen it

local t_pressed = false

Event.Add("OnKeyDown", function(key)
	if key == Key.T then t_pressed = not open end
end)

Event.Add("OnKeyUp", function(key)
	if key == Key.T and t_pressed and not open then
		t_pressed = false
		set_open(true)
	end
end)

WebView.SetMessageHandler(webview, function(event, text)
	set_open(false)

	if event ~= "send" or not text:find("%S") then return end

	local name, rest = text:match("^/(%S+)%s*(.*)")

	if not name then return Net.Send("SimpleChat", text) end

	local args = {}

	for arg in rest:gmatch("%S+") do args[#args + 1] = arg end

	local ok, err = Cmd.Execute(name, args)

	if not ok then add(err) end
end)

Event.Add("OnChat", function(_, msg) add(msg) end)