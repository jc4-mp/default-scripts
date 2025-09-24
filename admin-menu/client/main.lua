-- Admin Menu Client-side Implementation
-- Handles UI rendering, user interaction, and server communication

local open = false
local has_permission = false
local resources = {}
local last_update = 0
local update_interval = 5 -- Update resource list every 5 seconds
local selected_tab = 0

function toggleOpen()
    if not has_permission then
        Chat.Print("You don't have permission to access the admin menu.")
        return
    end
    
    open = not open
    Input.SetEnabled(not open)
    UI.SetCursorVisible(open)
    
    if open then
        requestResourceList()
    end
end

function requestResourceList()
    Net.Send("admin_menu_request")
end

function performResourceAction(resource_name, action)
    if not resource_name or not action then return end
    
    Net.Send("resource_action", resource_name, action)
    Chat.Print("Performing " .. action .. " on resource: " .. resource_name)
end

-- Network event handlers
Net.AddEvent("admin_permission_granted", function()
    has_permission = true
    toggleOpen()
end)

Net.AddEvent("admin_menu_response", function(resource_list)
    resources = resource_list or {}
    last_update = Client.GetElapsedSeconds()
end)

Net.AddEvent("resource_action_result", function(success, message)
    Chat.Print(message)

    if open then
        requestResourceList()
    end
end)

Net.AddEvent("admin_menu_error", function(error_message)
    Chat.Print("Admin Menu Error: " .. error_message)
end)

-- Render event
Event.Add("OnRender", function()
    if open then
        onRender()
    end
end)

function onRender()
    -- Auto-refresh resource list
    local current_time = Client.GetElapsedSeconds()
    if current_time - last_update > update_interval then
        requestResourceList()
    end
    
    local render_size = Render.GetSize()
    local window_size = vec2(
        math.min(1000, math.max(800, render_size.x * 0.6)),
        math.min(800, math.max(500, render_size.y * 0.7))
    )
    
    UI.SetNextWindowSize(window_size, 0)
    UI.SetNextWindowPos(vec2(render_size.x * 0.5 - window_size.x / 2, render_size.y * 0.5 - window_size.y / 2), 0)
    
    local main_window_flags = UI.WindowFlags_NoCollapse
    
    if UI.Begin("Admin Menu", main_window_flags) then
        if UI.BeginTabBar("AdminMenuTabs", 0) then
            -- Resources Tab
            if UI.BeginTabItem("Resources") then
                renderResourcesTab()
                UI.EndTabItem()
            end
            
            -- Future tabs can be added here
            -- if UI.BeginTabItem("Players") then
            --     renderPlayersTab()
            --     UI.EndTabItem()
            -- end
            
            UI.EndTabBar()
        end
        
        UI.End()
    end
end

function renderResourcesTab()
    -- Header with refresh button
    UI.Text("Resource Management")
    UI.SameLine()
    if UI.Button("Refresh") then
        requestResourceList()
    end
    
    UI.Separator()
    UI.Spacing()
    
    -- Resource list
    local table_height = UI.GetContentRegionAvail().y - 50
    if UI.BeginChild("ResourceListChild", vec2(0, table_height), true) then
        local table_flags = UI.TableFlags_ScrollY | UI.TableFlags_RowBg | UI.TableFlags_BordersOuter
        if UI.BeginTable("ResourceTable", 3, table_flags) then
            -- Table headers
            UI.TableSetupScrollFreeze(0, 1)
            UI.TableSetupColumn("Resource Name", UI.TableColumnFlags_WidthStretch, 0)
            UI.TableSetupColumn("Status", UI.TableColumnFlags_WidthFixed, 80)
            UI.TableSetupColumn("Actions", UI.TableColumnFlags_WidthFixed, 300)
            UI.TableHeadersRow()
            
            -- Resource rows
            for i, resource in ipairs(resources) do
                UI.TableNextRow(nil, 30)
                
                -- Resource name
                UI.TableNextColumn()
                UI.Text(tostring(resource.name) or "Unknown")
                
                -- Status with color
                UI.TableNextColumn()
                local running = resource.status == ResourceStatus.Running
                local statusText = resource.status == ResourceStatus.Running and "Running" or "Stopped"
                local status_color = running and vec4(0, 1, 0, 1) or vec4(1, 0, 0, 1)
                UI.TextColored(status_color, statusText)
                
                -- Action buttons
                UI.TableNextColumn()
                local button_width = 80
                local spacing = 10
                
                -- Start button (disabled if already running)
                if running then
                    UI.BeginDisabled()
                end
                if UI.Button("Start##" .. i, vec2(button_width, 0)) then
                    performResourceAction(tostring(resource.name), "start")
                end
                if running then
                    UI.EndDisabled()
                end
                
                UI.SameLine(0, spacing)
                
                -- Stop button (disabled if not running)
                if not running then
                    UI.BeginDisabled()
                end
                if UI.Button("Stop##" .. i, vec2(button_width, 0)) then
                    performResourceAction(tostring(resource.name), "stop")
                end
                if not running then
                    UI.EndDisabled()
                end
                
                UI.SameLine(0, spacing)
                
                -- Restart button
                if UI.Button("Restart##" .. i, vec2(button_width, 0)) then
                    performResourceAction(tostring(resource.name), "restart")
                end
            end
            
            UI.EndTable()
        end
        UI.EndChild()
    end
    
    -- Footer info
    UI.Separator()
    UI.Text("Total Resources: " .. #resources)
    UI.SameLine(0.0, 20.0)
    local running_count = 0
    for _, resource in ipairs(resources) do
        if resource.status == ResourceStatus.Running then running_count = running_count + 1 end
    end
    UI.Text("Running: " .. running_count)
end

Event.Add("OnKeyDown", function(key)
    if key == Key.F1 then
        Net.Send("admin_menu_request_open")
    end
end)