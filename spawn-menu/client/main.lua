local spawnlist = require("spawn_list")

local open_key = Key.V

local webview = WebView.Create("spawn-menu", {
	url = "resource://spawn-menu/client/ui.html",
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

local function spawn(category, item)
	if category.type == "vehicle" then
		Net.Send("spawn", item.id, World.LocalPlayer():AsPlayer():GetAimPosition())
	elseif category.type == "mounted_gun" then
		Net.Send("spawnMg", item.id, World.LocalPlayer():AsPlayer():GetAimPosition())
	elseif category.type == "skin" then
		Local.SetSkin(item.id)
	elseif category.type == "weapon" then
		Net.Send("weapon", item.id)
	end
end

Event.Add("OnKeyUp", function(key)
	if key == open_key and not open then
		setOpen(true)
	end
end)

WebView.SetMessageHandler(webview, function(event, data)
	if event == "close" then
		setOpen(false)
	elseif event == "spawn" then
		local category = spawnlist.categories[data.category]
		local item = category and category.items[data.item]

		if item then
			spawn(category, item)
			setOpen(false)
		end
	end
end)

WebView.SendMessage(webview, "init", { close_key = open_key, categories = spawnlist.categories })