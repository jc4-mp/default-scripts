-- your drone squad's keys (numpad) and a panel on the right with them and the squad's state, toggled with Num0. the
-- server (server/main.lua) commands the drones

local AIM_MS = 100 -- how often the aim is sent while firing
local WIDTH, HEIGHT = 300, 330

local webview = WebView.Create("drones", {
	url = "resource://drones/client/ui.html",
	position = vec2(Render.GetSize().x - WIDTH - 20, (Render.GetSize().y - HEIGHT) / 2),
	size = vec2(WIDTH, HEIGHT),
	visible = true,
})

local visible = true
local firing = false
local keys_down = {} -- a held key repeats OnKeyDown, a press acts once

local function aim_position()
	local player = World.LocalPlayer()

	return player and player:AsPlayer():GetAimPosition()
end

local KEYS = {
	{ key = Key.Num1, name = "1", text = "spawn a drone", press = function() Net.Send("drones_spawn") end },
	{ key = Key.Num2, name = "2", text = "follow me", press = function() Net.Send("drones_follow") end },
	{ key = Key.Num3, name = "3", text = "hold position", press = function() Net.Send("drones_hold") end },
	{ key = Key.Num4, name = "4", text = "fly to where I aim", press = function()
		local aim = aim_position()
		if aim then Net.Send("drones_spot", aim) end
	end },
	{ key = Key.Num5, name = "5", text = "fire where I aim (hold)", press = function() firing = true end },
	{ key = Key.Num6, name = "6", text = "hunt the closest player", press = function() Net.Send("drones_hunt") end },
	{ key = Key.NumDec, name = ".", text = "remove my drones", press = function() Net.Send("drones_remove") end },
	{ key = Key.Num0, name = "0", text = "hide this panel", press = function()
		visible = not visible
		WebView.SetVisible(webview, visible)
	end },
}

local by_key = {}
local key_list = {}

for _, k in ipairs(KEYS) do
	by_key[k.key] = k
	key_list[#key_list + 1] = { key = k.name, text = k.text }
end

Event.Add("OnKeyDown", function(key)
	if keys_down[key] or not by_key[key] then return end

	keys_down[key] = true

	by_key[key].press()
end)

Event.Add("OnKeyUp", function(key)
	keys_down[key] = nil

	if key == Key.Num5 and firing then
		firing = false
		Net.Send("drones_fire")
	end
end)

-- the drones fire where you aim while the fire key is held, so the aim follows your camera

Timer.Set(function()
	local aim = firing and aim_position()

	if aim then
		Net.Send("drones_fire", aim)
	end
end, AIM_MS, -1)

Net.AddEvent("drones_state", function(count, max, next_type, mode, squad_firing, prey)
	WebView.SendMessage(webview, "state", {
		keys = key_list,
		count = count,
		max = max,
		next_type = next_type,
		mode = mode,
		firing = squad_firing,
		prey = prey,
	})
end)

-- the server sends the squad's state once asked, and whenever it changes

Event.Add("OnClientJoin", function() Net.Send("drones_state") end)

if World.LocalPlayer() then
	Net.Send("drones_state")
end