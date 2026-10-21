-- /c4 plants a C4 in front of you (the server, server/main.lua, plays the planting and spawns it). while you have C4s
-- planted, a panel on the right lists them with their distance and the keys: Z sets off the selected one (Shift+Z all
-- of them), V disarms it without setting it off and C selects the next one

local REFRESH_MS = 200 -- how often the distances are updated
local FORWARD = 0.7 -- how far in front of the player's feet the C4 goes
local WIDTH, HEIGHT = 280, 380

local webview = WebView.Create("c4", {
	url = "resource://c4/client/ui.html",
	position = vec2(Render.GetSize().x - WIDTH - 20, Render.GetSize().y * 0.15),
	size = vec2(WIDTH, HEIGHT),
	visible = false,
})

local c4s = {} -- { id, position } of each C4 you planted, oldest first
local planting = false
local selected = 1
local keys_down = {} -- a held key repeats OnKeyDown, a press acts once
local config -- the server's MODEL, PLANT_MS and MAX
local preload

local function refresh()
	local player = World.LocalPlayer()
	local list = {}

	for i, c4 in ipairs(c4s) do
		list[i] = player and math.floor(player:GetPosition():distance(c4.position) + 0.5) or 0
	end

	WebView.SetVisible(webview, planting or #c4s > 0)
	WebView.SendMessage(webview, "state", {
		distances = list,
		selected = selected,
		planting = planting,
		plant_ms = config.PLANT_MS,
		max = config.MAX,
	})
end

Cmd.Add("c4", function()
	local player = World.LocalPlayer()
	if not (player and config) then return end

	player = player:AsPlayer()

	if player:GetVehicle() then error("get out of the vehicle to plant a C4", 0) end
	if planting then error("you are already planting a C4", 0) end
	if #c4s >= config.MAX then error("you can't have more than " .. config.MAX .. " C4s planted", 0) end

	-- a character faces its -z
	local spot = player:GetPosition() + player:GetRotation() * vec3(0, 0, -FORWARD)
	local hit = Physics.Raycast(spot + vec3(0, 1, 0), spot - vec3(0, 1, 0), PfxLayer.RaycastDefault)

	if not hit.hasHit then error("stand on the ground to plant a C4", 0) end

	Net.Send("c4_plant", hit.hitPos, math.deg(player:GetEulerRotation().y))
end)

Event.Add("OnKeyDown", function(key)
	if keys_down[key] then return end

	keys_down[key] = true

	local c4 = c4s[selected]
	if not c4 then return end

	if key == Key.Z then
		Net.Send("c4_detonate", not Input.IsKeyDown(Key.Shift) and c4.id or nil)
	elseif key == Key.V then
		Net.Send("c4_disarm", c4.id)
	elseif key == Key.C then
		selected = selected % #c4s + 1

		refresh()
	end
end)

Event.Add("OnKeyUp", function(key)
	keys_down[key] = nil
end)

Timer.Set(function()
	if #c4s > 0 then
		refresh()
	end
end, REFRESH_MS, -1)

-- a networked rigid object only shows in games that have its model loaded, so every player keeps a C4 loaded out of
-- sight under the map
Net.AddEvent("c4_config", function(server_config)
	config = server_config
	preload = preload or World.SpawnRigidObject(vec3(0, -1000, 0), config.MODEL .. ".modelc", config.MODEL .. "_col.pfxc",
		RigidObjectMotionType.Static)

	if preload then
		preload:EnableCollision(false)
	end
end)

-- a newly planted C4 gets selected
Net.AddEvent("c4_state", function(list, is_planting)
	selected = #list > #c4s and #list or math.max(1, math.min(selected, #list))
	c4s = list
	planting = is_planting

	refresh()
end)

-- the server sends its config and your C4s once asked, and your C4s again whenever they change

Event.Add("OnClientJoin", function() Net.Send("c4_state") end)

if World.LocalPlayer() then
	Net.Send("c4_state")
end