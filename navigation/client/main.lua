-- shows the game's navigation data and walks civilians along the sidewalks with it.
--
-- /navmesh draws what's around you within RADIUS m: the navmesh vertices (cyan) outline where characters can walk, the
-- road graph samples are the car roads (orange), the sidewalks civilians walk (green) and the other roads (grey), and
-- the road graph junctions are the white squares.
--
-- /peds [count] spawns civilians on the sidewalks around you (the server spawns them, see server/main.lua), again
-- despawns them. each one walks to a sidewalk point 4-15 m away, the ones ahead of it first, and only takes a point it
-- can reach in a straight line without leaving the navmesh.

local RADIUS = 30
local REFRESH_SECONDS = 0.25
local SPAWN_RADIUS = 50
local DEFAULT_PED_COUNT = 8
local STEP_MIN = 4
local STEP_MAX = 15

local COLOR_NAVMESH = 1
local COLOR_LAND = 2
local COLOR_PEDESTRIAN = 3
local COLOR_OTHER = 4
local COLOR_NODE = 5

local webview = WebView.Create("navigation", {
	url = "resource://navigation/client/ui.html",
	size = Render.GetSize(),
	visible = false,
	input_enabled = false,
})

local visible = false
local last_refresh = -math.huge
local points = {} -- { position, color } to draw

local peds_spawned = false
local headings = {} -- ped index -> the direction it last walked

local function flat(v)
	return vec3(v.x, 0, v.z)
end

local function flat_distance(a, b)
	local x, z = a.x - b.x, a.z - b.z
	return math.sqrt(x * x + z * z)
end

local function on_navmesh(position)
	return NavMesh.GetClosestPosition(position, 1) ~= nil
end

local function shuffle(list)
	for i = #list, 2, -1 do
		local j = math.random(i)
		list[i], list[j] = list[j], list[i]
	end

	return list
end

-- whether a character can walk from a to b in a straight line without leaving the navmesh, checked every meter

local function can_walk(a, b)
	local steps = math.floor(a:distance(b))

	for i = 1, steps do
		if not on_navmesh(a + (b - a) * (i / steps)) then return false end
	end

	return true
end

-- overlay

local function refresh_points()
	local center = Camera.GetPosition()

	points = {}

	for _, vertex in ipairs(NavMesh.GetVertices(center, RADIUS)) do
		points[#points + 1] = { vertex, COLOR_NAVMESH }
	end

	for _, sample in ipairs(RoadGraph.GetSamples(center, RADIUS)) do
		local color = sample.type == RoadGraphType.Land and COLOR_LAND or sample.type == RoadGraphType.Pedestrian and COLOR_PEDESTRIAN or COLOR_OTHER

		points[#points + 1] = { sample.position, color }
	end

	for _, node in ipairs(RoadGraph.GetNodes(center, RADIUS)) do
		points[#points + 1] = { node.position, COLOR_NODE }
	end
end

Cmd.Add("navmesh", function()
	visible = not visible
	last_refresh = -math.huge
	points = {}
	WebView.SetVisible(webview, visible)
end)

-- the navigation data is read on the update thread, where the game streams it

Event.Add("OnUpdate", function()
	local now = Client.GetElapsedSeconds()

	if visible and now - last_refresh >= REFRESH_SECONDS then
		last_refresh = now
		refresh_points()
	end
end)

-- the points on screen as { x, y, color, x, y, color, ... }

Event.Add("OnRender", function()
	if not visible then return end

	local screen = {}

	for _, point in ipairs(points) do
		local position = Camera.WorldToScreen(point[1])

		if position then
			screen[#screen + 1] = position.x
			screen[#screen + 1] = position.y
			screen[#screen + 1] = point[2]
		end
	end

	WebView.SendMessage(webview, "points", screen)
end)

-- peds

local function pick_target(position, heading)
	local ahead, others = {}, {}

	for _, sample in ipairs(RoadGraph.GetSamples(position, STEP_MAX, RoadGraphType.Pedestrian)) do
		if flat_distance(sample.position, position) > STEP_MIN then
			local direction = flat(sample.position - position):normalize()
			local list = heading and direction.x * heading.x + direction.z * heading.z > 0.5 and ahead or others

			list[#list + 1] = sample.position
		end
	end

	for _, list in ipairs({ shuffle(ahead), shuffle(others) }) do
		for i = 1, math.min(#list, 20) do
			if can_walk(position, list[i]) then return list[i] end
		end
	end
end

Cmd.Add("peds", function(count)
	if peds_spawned then
		peds_spawned = false
		Net.Send("navigation_despawn_peds")
		return
	end

	count = tonumber(count) or DEFAULT_PED_COUNT

	local player = World.LocalPlayer():AsPlayer()
	local spots = {}

	for _, sample in ipairs(shuffle(RoadGraph.GetSamples(player:GetPosition(), SPAWN_RADIUS, RoadGraphType.Pedestrian))) do
		if #spots >= count then break end

		if on_navmesh(sample.position) then
			spots[#spots + 1] = sample.position
		end
	end

	if #spots == 0 then
		error("no sidewalks around you", 0)
	end

	peds_spawned = true
	headings = {}

	Net.Send("navigation_spawn_peds", spots)
end)

Net.AddEvent("navigation_ped_arrived", function(index, position)
	local target = pick_target(position, headings[index])

	if target then
		headings[index] = flat(target - position):normalize()
	end

	Net.Send("navigation_ped_target", index, target)
end)