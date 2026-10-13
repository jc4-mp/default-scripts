---@diagnostic disable: different-requires
local webviewOpen = false
local webview_id = "dashboard_ui"
local dashboardBusy = false
local render_size = Render.GetSize()

local SpawnList = require("spawn_list")

-- Create WebView
local config = {
    url = "resource://dashboard/client/ui.html",
    position = vec2(0, 0),
    size = render_size,
    visible = false,
    input_enabled = false,
    z_order = 60000
}

local created_webview_id = WebView.Create(webview_id, config)
if created_webview_id == "" then
    print("[Dashboard] Failed to create dashboard WebView")
    return
end

webview_id = created_webview_id
local localResourceTable = {}

-- clients have no pings (only the server keeps them), the server sends them every second while the dashboard is open:
-- user id -> ping
local pings = {}

Net.AddEvent("Dashboard_Pings", function(list)
    pings = {}
    for _, entry in ipairs(list) do
        pings[entry[1]] = entry[2]
    end
end)

local function BuildPlayerList()
    local playerData = {}
    local players = World.GetPlayers()
    for _, client in ipairs(players) do
        local ping = pings[client:GetUserId()]
        table.insert(playerData, {
            nick = client:GetName(),
            ping = ping and math.floor(ping) or "-",
            steamid = client:GetUserId(),
            status = "normal"
        })
    end
    return playerData
end




local function SendVehicleList()
    local vehicles = {}

    for _, cat in ipairs(SpawnList.categories) do
        if cat.type == "vehicle" then
            for _, item in ipairs(cat.items) do
                if not item.separator and item.id then
                    table.insert(vehicles, {
                        id = item.id,                               -- internal game ID
                        model = item.name,                          -- display name
                        category = string.lower(cat.name),          -- category
                        price = tonumber(item.price),               -- lockpick buy cost
                        steal_price = tonumber(item.steal_price),   -- steal cost
                        respawn_time = tonumber(item.respawn_time), -- default 10 mins
                        limit = tonumber(item.limit)                -- default single spawn
                    })
                end
            end
        end
    end

    WebView.SendMessage(webview_id, "vehicle_spawnlist", { vehicles = vehicles })
end



local function CloseDashboard()
    if not webviewOpen then return end

    webviewOpen = false
    Net.Send("Dashboard_SetOpen", false)
    if _G.cursorVisibilityManager then
        _G.cursorVisibilityManager:close("dashboard")
    else
        UI.SetCursorVisible(false)
    end

    WebView.SetInputEnabled(webview_id, false)
    WebView.SetVisible(webview_id, false)
    WebView.SendToBack(webview_id)
    WebView.BlurAll()
end


Event.Add("OnKeyDown", function(key)
    if key == Key.F2 then
        if dashboardBusy then return end
        dashboardBusy = true
        Timer.Set(function() dashboardBusy = false end, 300, 1)

        if webviewOpen then
            CloseDashboard()
        else
            -- Request auth from server before opening
            Net.Send("Dashboard_RequestAccess")
        end
    end
end)

Net.AddEvent("Dashboard_AccessResult", function(data)
    dashboardBusy = false  -- clear regardless of grant/deny so F2 works again
    if data and data.granted then
        webviewOpen = true
        pings = {}
        Net.Send("Dashboard_SetOpen", true)
        if _G.cursorVisibilityManager then
            _G.cursorVisibilityManager:open("dashboard")
        else
            UI.SetCursorVisible(true)
        end
        WebView.SetInputEnabled(webview_id, true)
        WebView.SetVisible(webview_id, true)
        WebView.BringToFront(webview_id)
        WebView.Focus(webview_id)
        WebView.SendMessage(webview_id, "set_role", { role = data.role or "admin" })
    end
end)

local function handle_webview_message(event, data)
    if event == "dashboard_close_request" then
        dashboardBusy = true
        Timer.Set(function() dashboardBusy = false end, 300, 1)
        CloseDashboard()
    elseif event == "resource_action" then
        local resource = data.resource
        local action = data.action

        if resource and action then
            Net.Send("ResourceActionFromClient", { resource = resource, action = action })
        end
    elseif event == "player_action" then
        local steamid = data.steamid
        local name    = data.name
        local action  = data.action

        Net.Send("PlayerActionFromClient", {
            steamid = steamid,
            name    = name,
            action  = action,
            message = data.message,
            reason  = data.reason,
            value   = data.value,
            pos     = data.pos,
        })
    elseif event == "update_playerlist" then
        local players = BuildPlayerList()
        WebView.SendMessage(webview_id, "fresh_playerlist", { players = players })
    elseif event == "update_resource_list" then
        Net.Send("resource_request")
    elseif event == "admin_announcement" then
        if data and data.text then
            Net.Send("ClientAnnounceRequest", { text = data.text })
        else
        end
    elseif event == "map_set_can_draw" then
        -- Forward to player_ui webview
        Event.Fire("Map_SetCanDraw", { enabled = data.enabled })

        -- === NEW: Handle vehicle spawn requests ===
    elseif event == "vehicle_spawn_request" then
        if not data then return end

        local id = data.id or "?"
        local model = data.model or "?"
        local category = data.category or "?"
        local rot = data.rotation or { x = 0, y = 0, z = 0 }

        -- Get local player and aim position
        local player = World.LocalPlayer():AsPlayer()
        local aimPos = player:GetAimPosition()



        -- Forward to server
        Net.Send("SpawnVehicle_Server", {
            id = id,
            model = model,
            category = category,
            rotation = rot,
            position = { x = aimPos.x, y = aimPos.y, z = aimPos.z }
        })
    elseif event == "vehicle_action_request" then
        local payload = {
            netid = data.netid,
            model = data.model,
            id = data.id,
            pos = data.pos,
            rot = data.rot,
            category = data.category,
            spawned_by = data.spawned_by
        }

        if data.action == "delete" then
            Net.Send("Vehicle_Delete_Request", payload)
        elseif data.action == "save" then
            Net.Send("Vehicle_Save_Request", payload)
        elseif data.action == "waypoint" then
            Net.Send("Vehicle_Set_Waypoint", payload)
        elseif data.action == "waypoint_db" then
            if not data.pos then return end
            World.SetWaypoint(vec3(data.pos.x, data.pos.y, data.pos.z))
        elseif data.action == "refresh_db" then
            Net.Send("Vehicle_Request_List", {})
        end
    elseif event == "loot_place_mode" then
        local tier = tonumber(data.tier)
        if not tier then return end
        Event.Fire("Loot:StartPlacement", { tier = tier })
    elseif event == "loot_action_request" then
        if data.action == "waypoint" then
            World.SetWaypoint(vec3(data.pos.x, data.pos.y, data.pos.z))
        elseif data.action == "refresh" then
            Net.Send("Loot:RequestSpawnList", {})
        elseif data.action == "delete" then
            Net.Send("Loot:DeleteSpawnPoint", { id = tonumber(data.id) })
        end
    end
end




WebView.SetMessageHandler(webview_id, handle_webview_message)


Net.AddEvent("admin_inventory_data", function(data)
    WebView.SendMessage(webview_id, "show_player_inventory", {
        name      = data.name,
        steamid   = data.steamid,
        inventory = data.inventory,
    })
end)
Net.AddEvent("Vehicle_Save_Broadcast", function(data)
    if not data then return end
    WebView.SendMessage(webview_id, "vehicle_save_feedback", {
        model = data.model or "unknown",
        spawned_by = data.spawned_by or "unknown",
        pos = data.pos or { x = 0, y = 0, z = 0 },
        rot = data.rot or { x = 0, y = 0, z = 0 },
        saved_at = data.saved_at,
        netid = data.netid -- forward it
    })
end)

Net.AddEvent("Loot:SpawnPointDeleted", function(data)
    WebView.SendMessage(webview_id, "loot_spawn_deleted", { id = data.id })
end)


Net.AddEvent("Vehicle_Deleted_Broadcast", function(data)
    if not data or not data.netid then return end

    -- Tell the WebView to remove that entry
    WebView.SendMessage(webview_id, "vehicle_deleted_update", {
        netid = data.netid,
        model = data.model
    })
end)

Net.AddEvent("Vehicle_Waypoint_Broadcast", function(data)
    if not data or not data.pos then return end

    local pos = vec3(data.pos.x, data.pos.y, data.pos.z)
    World.SetWaypoint(pos)
end)


Net.AddEvent("VehicleSpawned_Broadcast", function(data)
    if not data then return end

    WebView.SendMessage(webview_id, "vehicle_spawned_update", {
        id = data.id,
        model = data.model,
        category = data.category,
        pos = data.pos,
        rot = data.rot,
        spawned_by = data.spawned_by,
        netid = data.netid
    })
end)

Net.AddEvent("Vehicle_List_Response", function(data)
    if not data or not data.vehicles then return end
    WebView.SendMessage(webview_id, "vehicle_list_update", data)
end)



-- Update local table and send to WebView
local function updateLocalResources(resource_list)
    localResourceTable = {}
    for _, res in ipairs(resource_list or {}) do
        table.insert(localResourceTable, {
            name = tostring(res.name or "Unknown"),
            status = tonumber(res.status or 0)
        })
    end

    WebView.SendMessage(webview_id, "update_resource_list", { resources = localResourceTable })
    -- print("Updated resource table and sent to WebView (" .. tostring(#localResourceTable) .. " entries).")
end

-- Listen for server response
Net.AddEvent("resource_response", function(resource_list)
    updateLocalResources(resource_list)
end)

-- after WebView.Create(...) or similar setup
Timer.Set(function()
    SendVehicleList()
    Net.Send("Vehicle_Request_List", {})
end, 2000, 1)


Event.Add("Loot:PlacementConfirmed", function(data)
    WebView.SendMessage(webview_id, "loot_place_confirmed", data)
end)

Net.AddEvent("Loot:SpawnListResponse", function(data)
    WebView.SendMessage(webview_id, "loot_list_update", data)
end)
