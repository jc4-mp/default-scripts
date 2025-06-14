-- Admin Menu Client-side Implementation
-- Handles UI rendering, user interaction, and server communication

local open = false
local has_permission = false
local resources = {}
local last_update = 0
local update_interval = 5 -- Update resource list every 5 seconds
local selected_tab = 0

-- UI state
local show_confirmation = false
local confirmation_action = nil
local confirmation_resource = nil

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
    Net.Send("admin_menu_request", Players.Local())
end

function performResourceAction(resource_name, action)
    if not resource_name or not action then return end
    
    Net.Send("resource_action", Players.Local(), resource_name, action)
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
    local color = success and Color.Green or Color.Red
    Chat.Print(message)

    if open then
        requestResourceList()
    end
end)

Net.AddEvent("admin_menu_error", function(error_message)
    Chat.Print("Admin Menu Error: " .. error_message)
end)

-- Command registration
Cmd.Add("admin", function()
    -- First check with server for permissions
    print("admin")
    Net.Send("admin_menu_request_open", Players.Local())
end)

-- Render event
Event.Add("Render", function()
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
        math.min(700, math.max(500, render_size.y * 0.7))
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
    
    -- Render confirmation dialog if needed
    if show_confirmation then
        renderConfirmationDialog()
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
    local table_height = UI.GetContentRegionAvail().y - 30
    if UI.BeginChild("ResourceListChild", vec2(0, table_height), true) then
        local table_flags = UI.TableFlags_ScrollY | UI.TableFlags_RowBg | UI.TableFlags_BordersOuter
        if UI.BeginTable("ResourceTable", 4, table_flags) then
            -- Table headers
            UI.TableSetupScrollFreeze(0, 1)
            UI.TableSetupColumn("Resource Name", UI.TableColumnFlags_WidthStretch, 0)
            UI.TableSetupColumn("Status", UI.TableColumnFlags_WidthFixed, 80)
            UI.TableSetupColumn("Actions", UI.TableColumnFlags_WidthFixed, 200)
            UI.TableSetupColumn("Info", UI.TableColumnFlags_WidthFixed, 60)
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
                local button_width = 60
                local spacing = 5
                
                -- Start button (disabled if already running)
                if running then
                    UI.BeginDisabled()
                end
                if UI.Button("Start##" .. i, vec2(button_width, 0)) then
                    showConfirmation("start", tostring(resource.name))
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
                    showConfirmation("stop", tostring(resource.name))
                end
                if not running then
                    UI.EndDisabled()
                end
                
                UI.SameLine(0, spacing)
                
                -- Restart button
                if UI.Button("Restart##" .. i, vec2(button_width, 0)) then
                    showConfirmation("restart", tostring(resource.name))
                end
                
                -- Info column
                UI.TableNextColumn()
                if UI.Button("?##" .. i, vec2(25, 0)) then
                    Chat.Print("Resource: " .. tostring(resource.name) .. " | Status: " .. tostring(statusText))
                end
            end
            
            UI.EndTable()
        end
        UI.EndChild()
    end
    
    -- Footer info
    UI.Separator()
    UI.Text("Total Resources: " .. #resources)
    UI.SameLine()
    local running_count = 0
    for _, resource in ipairs(resources) do
        if resource.status == ResourceStatus.Running then running_count = running_count + 1 end
    end
    UI.Text("Running: " .. running_count)
end

function showConfirmation(action, resource_name)
    show_confirmation = true
    confirmation_action = action
    confirmation_resource = resource_name
end

function renderConfirmationDialog()
    local render_size = Render.GetSize()
    local dialog_size = vec2(400, 150)
    
    UI.SetNextWindowSize(dialog_size, 0)
    UI.SetNextWindowPos(vec2(render_size.x * 0.5 - dialog_size.x / 2, render_size.y * 0.5 - dialog_size.y / 2), 0)
    
    local dialog_flags = UI.WindowFlags_NoCollapse | UI.WindowFlags_NoResize | UI.WindowFlags_Modal
    
    if UI.Begin("Confirm Action", dialog_flags) then
        UI.Text("Are you sure you want to " .. confirmation_action .. " the resource:")
        UI.Text("'" .. confirmation_resource .. "'?")
        UI.Spacing()
        UI.Separator()
        UI.Spacing()
        
        local button_width = 80
        if UI.Button("Yes", vec2(button_width, 0)) then
            performResourceAction(confirmation_resource, confirmation_action)
            show_confirmation = false
        end
        
        UI.SameLine()
        
        if UI.Button("No", vec2(button_width, 0)) then
            show_confirmation = false
        end
        
        UI.End()
    end
end

-- Handle ESC key to close menu
Event.Add("KeyUp", function(key)
    if key == Key.Escape and open then
        toggleOpen()
    end
end)

print("[AdminMenu] Client-side loaded successfully")
