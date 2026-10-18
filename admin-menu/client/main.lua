-- the admin menu, opened with F1 once the server grants it

local open_key = Key.F1
local refresh_ms = 5000

local webview = WebView.Create("admin-menu", {
	url = "resource://admin-menu/client/ui.html",
	size = Render.GetSize(),
	visible = false,
})

local open = false

-- through the chat resource
local function printChat(text)
	Event.Fire("AddChatMessage", { parts = { { text = text } } })
end

local function requestResourceList()
	Net.Send("admin_menu_request")
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
		requestResourceList()
	else
		WebView.BlurAll()
	end
end

Event.Add("OnKeyDown", function(key)
	if key == open_key and not open then
		Net.Send("admin_menu_request_open")
	end
end)

Timer.Set(function()
	if open then requestResourceList() end
end, refresh_ms, -1)

Net.AddEvent("admin_permission_granted", function()
	setOpen(true)
end)

Net.AddEvent("admin_menu_response", function(resource_list)
	local resources = {}

	for _, resource in ipairs(resource_list or {}) do
		resources[#resources + 1] = { name = tostring(resource.name), running = resource.status == ResourceStatus.Running }
	end

	WebView.SendMessage(webview, "resources", resources)
end)

Net.AddEvent("resource_action_result", function(success, message)
	printChat(message)

	if open then requestResourceList() end
end)

Net.AddEvent("admin_menu_error", function(error_message)
	printChat("Admin Menu Error: " .. error_message)
end)

WebView.SetMessageHandler(webview, function(event, data)
	if event == "close" then
		setOpen(false)
	elseif event == "refresh" then
		requestResourceList()
	elseif event == "action" then
		Net.Send("resource_action", data.resource, data.action)
		printChat("Performing " .. data.action .. " on resource: " .. data.resource)
	end
end)

WebView.SendMessage(webview, "init", { close_key = open_key })