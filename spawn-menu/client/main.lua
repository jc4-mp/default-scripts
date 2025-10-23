local spawnlist = require("spawn_list")

local open = false
local selection = { category = 0, item_index = -1 }

function toggleOpen()
    open = not open
    Input.SetEnabled(not open)
    UI.SetCursorVisible(open)
end

Event.Add("OnKeyUp", function(key)
    if Chat.IsTyping() then return end

    if key == Key.V then
        toggleOpen()
    end
end)

Event.Add("OnRender", function()
    if open then
        onRender()
    end
end)

function onRender()
    local render_size = Render.GetSize()
    local window_size = vec2(
        math.min(1000, math.max(600, render_size.x * 0.5)),
        math.min(800, math.max(400, render_size.y * 0.5))
    )
    UI.SetNextWindowSize(window_size, 0)
    UI.SetNextWindowPos(vec2(render_size.x * 0.5 - window_size.x / 2, render_size.y * 0.5 - window_size.y / 2), 0)

    local main_window_flags = WindowFlags.NoResize | WindowFlags.NoScrollbar | WindowFlags.NoCollapse

    if UI.Begin("Spawn Menu", main_window_flags) then
        local active_tab = 1

        if UI.BeginTabBar("SpawnMenuTabs", 0) then
            for category_index, category in ipairs(spawnlist.categories) do
                if UI.BeginTabItem(category.name) then
                    active_tab = category_index
                    local list_height_in_tab = UI.GetContentRegionAvail().y * 0.8
                    if UI.BeginChild("VehicleListChild", vec2(0, list_height_in_tab), true) then
                        for item_index, item in ipairs(category.items) do
                            if item.separator then
                                UI.SeparatorText(item.name .. "##" .. category_index .. "_" .. item_index)
                            else
                                local is_selected = selection.item_index == item_index and selection.category == category_index
                                -- Selectable with unique id
                                if UI.Selectable(item.name .. "##" .. category_index .. "_" .. item_index, is_selected) then
                                    selection = { category = category_index, item_index = item_index }
                                end
                            end
                        end
                        UI.EndChild()
                    end
                    UI.EndTabItem()
                end
            end
            UI.EndTabBar()
        end

        UI.Separator()
        UI.Spacing()

        local button_width = UI.GetContentRegionAvail().x
        local button_label = spawnlist.categories[active_tab].button_name
        if UI.Button(button_label, vec2(button_width, 0)) and selection.item_index ~= -1 then
            local category = spawnlist.categories[selection.category]
            local item = category.items[selection.item_index]
            if item then
                if category.type == "vehicle" then
                    local spawn_pos = Players.LocalPlayer():GetAimPosition()
                    Net.Send("spawn", item.id, spawn_pos)
                elseif category.type == "mounted_gun" then
                    local spawn_pos = Players.LocalPlayer():GetAimPosition()
                    Net.Send("spawnMg", item.id, spawn_pos)
                elseif category.type == "skin" then
                    Local.SetSkin(item.id)
                elseif category.type == "weapon" then
                    Net.Send("weapon", item.id, Players.LocalClient())
                end
                toggleOpen()
            end
        end

        UI.End()
    end
end