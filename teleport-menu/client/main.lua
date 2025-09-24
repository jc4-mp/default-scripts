local locations = require("teleport_locations")
local helpers = require("helpers")
local open_key = Key.G
local hovered_location_index_this_frame = nil

local open = false

function toggleOpen()
    open = not open
    UI.SetCursorVisible(open)
    Input.SetEnabled(not open)
end

Event.Add("OnKeyDown", function(key)
    if key == open_key and not open and not Chat.IsTyping() then
        toggleOpen()
    end
end)

Event.Add("OnKeyUp", function(key)
    if key == open_key and open then
        toggleOpen()
    end
end)

Event.Add("OnMouseDown", function(key)
    if key == Key.MouseLeft and open and hovered_location_index_this_frame then
        local selected_location = locations[hovered_location_index_this_frame]
        Net.Send("requestTeleport", selected_location.position)
        toggleOpen()
    end
end)

Event.Add("OnRender", function()
    if open then
        renderMenu()
    end
end)

function renderMenu()
    local screen_size = Render.GetSize()
    if not screen_size or screen_size.x == 0 or screen_size.y == 0 then return end -- Guard against invalid screen size

    local center = vec2(screen_size.x / 2, screen_size.y / 2)
    local num_locations = #locations

    if num_locations == 0 then return end -- No locations to draw

    -- A large radius to ensure triangle points extend well beyond the screen edges
    local large_radius = math.max(screen_size.x, screen_size.y) * 2.0 -- Increased for safety

    local mouse_pos_normalized = UI.GetMousePos()
    if not mouse_pos_normalized then return end -- Guard if mouse pos is not available
    local mouse_pos_screen = vec2(mouse_pos_normalized.x * screen_size.x, mouse_pos_normalized.y * screen_size.y)

    local slice_angle_rad = (2 * math.pi) / num_locations

    for i = 1, num_locations do
        -- Calculate angles for the current slice, offset to start from top
        local angle_start_rad = (i - 1) * slice_angle_rad - (math.pi / 2)
        local angle_end_rad = i * slice_angle_rad - (math.pi / 2)

        -- Vertices of the triangle slice
        local v0 = center
        local v1 = helpers.add_vec2(center, vec2(math.cos(angle_start_rad) * large_radius, math.sin(angle_start_rad) * large_radius))
        local v2 = helpers.add_vec2(center, vec2(math.cos(angle_end_rad) * large_radius, math.sin(angle_end_rad) * large_radius))

        local fill_color = vec4(0.1, 0.1, 0.15, 0.75) -- Default dark semi-transparent color

        if helpers.is_point_in_triangle(mouse_pos_screen, v0, v1, v2) then
            hovered_location_index_this_frame = i
            fill_color = vec4(0.3, 0.3, 0.4, 0.9) -- Brighter, more opaque hover color
        end

        Render.FillTriangle(v0, v1, v2, fill_color)
        Render.DrawTriangle(v0, v1, v2, vec4(1, 1, 1, 0.9)) -- White border

        -- Text rendering logic
        local text_angle_rad = (angle_start_rad + angle_end_rad) / 2
        
        local text_radius_factor = 0.3 -- Base factor for text distance from center
        local text_scale = 0.9

        if num_locations > 12 then -- Many locations: make text smaller and push slightly further
            text_scale = 0.65
            text_radius_factor = 0.38
        elseif num_locations > 8 then -- Medium number of locations
            text_scale = 0.75
            text_radius_factor = 0.34
        end
        local text_radius = math.min(screen_size.x, screen_size.y) * text_radius_factor
        local text_pos = helpers.add_vec2(center, vec2(math.cos(text_angle_rad) * text_radius, math.sin(text_angle_rad) * text_radius))
        
        Render.DrawText(locations[i].name, text_pos, text_scale * 30, vec4(1, 1, 1, 1), true, 1, 200) -- Center text, add shadow, allow some wrap width
    end
end