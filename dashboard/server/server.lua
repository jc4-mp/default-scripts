-- Net.AddEvent("request_access", function()
-- ...existing commented code...

local VehicleTableReady = false
local VehicleTableError = nil
local LoadSavedVehicles

-- SQL calls are synchronous: each returns its result, or nil and the error
local tableResult, tableError = SQL.Execute([[
    CREATE TABLE IF NOT EXISTS vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id TEXT NOT NULL,
        model TEXT NOT NULL,
        spawned_by TEXT NOT NULL,
        pos_x REAL DEFAULT 0,
        pos_y REAL DEFAULT 0,
        pos_z REAL DEFAULT 0,
        rot_x REAL DEFAULT 0,
        rot_y REAL DEFAULT 0,
        rot_z REAL DEFAULT 0,
        saved_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
]])

if tableResult then
    VehicleTableReady = true
    print("[VehicleDB] Vehicles table ready")
else
    VehicleTableError = tableError or "unknown error"
    print("[VehicleDB] Vehicles table creation failed:", VehicleTableError)
end

Net.AddEvent("ResourceActionFromClient", function(data)
    local resource = data.resource
    local action = data.action
    local sender = Net.Sender()

    if not resource or not action then return end

    if action == "Start" then
        Resources.Start(resource)
    elseif action == "Stop" then
        Resources.Stop(resource)
    elseif action == "Restart" then
        Resources.Restart(resource)
    end
end)

Net.AddEvent("SpawnVehicle_Server", function(data)
    if not data then return end

    local sender    = Net.Sender()
    local nick      = sender:GetName()
    local vehicleId = data.id
    local modelName = data.model
    local category  = data.category
    local rot       = data.rotation
    local pos       = data.position
    local position  = vec3(pos.x, pos.y, pos.z)
    local rotation  = vec3(rot.x, rot.y, rot.z)

    local myVehicle = World.SpawnVehicle(vehicleId, position, rotation)
    local ID        = myVehicle:GetNetId()
    local v_lock    = myVehicle:SetLocked(true)

    print(string.format(
        "[VehicleSpawner] Spawned %s (%s) for %s at (%.2f, %.2f, %.2f) | NetId=%s | Locked=%s",
        vehicleId, modelName, nick, position.x, position.y, position.z, tostring(ID), tostring(v_lock)
    ))

    Net.Broadcast("VehicleSpawned_Broadcast", {
        id = vehicleId,
        model = modelName,
        category = category,
        pos = pos,
        rot = rot,
        spawned_by = nick,
        netid = ID
    })
end)

Net.AddEvent("Vehicle_Delete_Request", function(data)
    if not data or not data.netid then
        print("[VehicleSpawner] Delete failed — missing NetId.")
        return
    end

    local nid = tonumber(data.netid)
    local veh = World.GetObjectByNID(nid)
    if not veh then
        print(string.format("[VehicleSpawner] Delete failed — no vehicle found for NetId=%s", tostring(nid)))
        return
    end

    World.Destroy(veh)
    Net.Broadcast("Vehicle_Deleted_Broadcast", { netid = nid })
end)

Net.AddEvent("Dashboard_RequestAccess", function()
    local sender = Net.Sender()
    if not sender then return end

    local acl  = sender:GetAcl()
    local nick = sender:GetName()

    if sender:HasAcl(AclLevel.Owner) or sender:HasAcl(AclLevel.Admin) or sender:HasAcl(AclLevel.Moderator) then
        local role = "admin"
        if not sender:HasAcl(AclLevel.Owner) and not sender:HasAcl(AclLevel.Admin) then role = "moderator" end

        print(string.format("[Dashboard] Access granted to %s (role=%s)", nick, role))
        Net.SendToPlayer(sender, "Dashboard_AccessResult", { granted = true, role = role })
    else
        print(string.format("[Dashboard] Access denied for %s (ACL=%s)", nick, tostring(acl)))
        Net.SendToPlayer(sender, "Dashboard_AccessResult", { granted = false })
    end
end)

-- clients have no pings (only the server keeps them): every second they go to the players with the dashboard open
local dashboardOpen = {} -- user id -> PlayerHandle

Net.AddEvent("Dashboard_SetOpen", function(open)
    local sender = Net.Sender()
    if sender then dashboardOpen[sender:GetUserId()] = open and sender or nil end
end)

Event.Add("OnPlayerQuit", function(client)
    dashboardOpen[client:GetUserId()] = nil
end)

Timer.Set(function()
    if next(dashboardOpen) == nil then return end

    local pings = {}
    for _, client in ipairs(World.GetPlayers()) do
        table.insert(pings, { client:GetUserId(), client:GetPing() })
    end

    local targets = {}
    for _, client in pairs(dashboardOpen) do
        table.insert(targets, client)
    end

    Net.SendToPlayers(targets, "Dashboard_Pings", pings)
end, 1000, -1)

Net.AddEvent("Vehicle_Request_List", function()
    local client = Net.Sender()
    if not client then return end
    if not VehicleTableReady then
        if VehicleTableError then
            print("[VehicleDB] Vehicle list unavailable:", VehicleTableError)
        end
        Net.SendToPlayer(client, "Vehicle_List_Response", { vehicles = {} })
        return
    end

    local rows, error = SQL.Query([[
        SELECT model, spawned_by, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, saved_at
        FROM vehicles
        ORDER BY saved_at DESC
    ]])

    if error then
        print("[VehicleDB] Vehicle list query failed:", error)
        rows = {}
    end

    Net.SendToPlayer(client, "Vehicle_List_Response", { vehicles = rows or {} })
end)

-- ============================================================
--  WORLD VEHICLE SPAWN TRACKING
-- ============================================================
local WORLD_RESPAWN_TIME = 0.1 * 60 * 1000 -- 5 minutes

-- worldSpawnPoints[db_row_index] = {
--     game_id, pos, rot, active, vehicleNetId
-- }
local worldSpawnPoints = {}

local function SpawnWorldVehicleAtPoint(spawnId)
    local sp = worldSpawnPoints[spawnId]
    if not sp then
        print(string.format("[WorldVehicles] SpawnWorldVehicleAtPoint — no spawn point for id=%s", tostring(spawnId)))
        return
    end

    local veh = World.SpawnVehicle(sp.game_id, sp.pos, sp.rot)
    if not veh then
        print(string.format("[WorldVehicles] Failed to spawn %s at spawnId=%d", sp.game_id, spawnId))
        return
    end

    veh:SetData("isWorld", "isWorld", true)
    veh:SetData("world_spawn_id", tostring(spawnId), true)
    veh:SetPrimaryColor(1.0, 1.0, 1.0)
    veh:SetLocked(true)

    sp.active       = true
    sp.vehicleNetId = veh:GetNetId()

    print(string.format("[WorldVehicles] Spawned %s | spawnId=%d netId=%s",
        sp.game_id, spawnId, tostring(sp.vehicleNetId)))
end

local function DeactivateWorldSpawn(spawnId)
    local sp = worldSpawnPoints[spawnId]
    if not sp then return end

    sp.active       = false
    sp.vehicleNetId = nil

    print(string.format("[WorldVehicles] spawnId=%d deactivated — respawning in %.0f seconds",
        spawnId, WORLD_RESPAWN_TIME / 1000))

    Timer.Set(function()
        print(string.format("[WorldVehicles] Respawn timer fired for spawnId=%d", spawnId))
        SpawnWorldVehicleAtPoint(spawnId)
    end, WORLD_RESPAWN_TIME, 1)
end

local function FindWorldSpawnByNetId(netId)
    for id, sp in pairs(worldSpawnPoints) do
        if sp.vehicleNetId == netId then
            return id, sp
        end
    end
    return nil, nil
end

LoadSavedVehicles = function()
    if not VehicleTableReady then return end

    print("[VehicleDB] Loading saved vehicles from database...")

    local rows, error = SQL.Query([[
        SELECT game_id, model, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, spawned_by, saved_at
        FROM vehicles
    ]])

    if error then
        print("[VehicleDB] Failed to load saved vehicles:", error)
        return
    end

    if not rows or #rows == 0 then
        print("[VehicleDB] No vehicles found in database.")
        return
    end

    local count = 0
    for i, v in ipairs(rows) do
        if v.game_id and v.pos_x and v.rot_x then
            local pos = vec3(tonumber(v.pos_x), tonumber(v.pos_y), tonumber(v.pos_z))
            local rot = vec3(tonumber(v.rot_x), tonumber(v.rot_y), tonumber(v.rot_z))

            -- Register spawn point BEFORE spawning
            worldSpawnPoints[i] = {
                game_id      = v.game_id,
                pos          = pos,
                rot          = rot,
                active       = false,
                vehicleNetId = nil,
            }

            -- Spawn using the tracked function so netId is recorded
            SpawnWorldVehicleAtPoint(i)
            count = count + 1

            print(string.format(
                "[VehicleDB] Registered spawnId=%d '%s' (%s) at (%.1f, %.1f, %.1f) | By: %s",
                i, v.model or "unknown", v.game_id,
                pos.x, pos.y, pos.z, v.spawned_by or "unknown"
            ))
        end
    end

    print(string.format("[VehicleDB] Loaded and tracked %d world vehicle spawn(s).", count))
end

-- ============================================================
--  WORLD VEHICLE DESTROYED → respawn after timer
-- ============================================================
-- NOTE: This is in ADDITION to the OnVehicleDestroy in vehicle manager
-- That one handles player-owned vehicles. This one handles isWorld vehicles.
Event.Add("OnVehicleDestroy", function(vehicle)
    local isWorld = vehicle:GetData("isWorld")
    if isWorld ~= "isWorld" then return end

    local netId = vehicle:GetNetId()
    local spawnId, sp = FindWorldSpawnByNetId(netId)

    if not spawnId then
        print(string.format(
            "[WorldVehicles] Destroyed isWorld vehicle netId=%s but no matching spawnId found — skipping respawn",
            tostring(netId)))
        return
    end

    print(string.format("[WorldVehicles] isWorld vehicle destroyed | spawnId=%d netId=%s — starting respawn timer",
        spawnId, tostring(netId)))

    DeactivateWorldSpawn(spawnId)
end)

-- ============================================================
--  WORLD VEHICLE PURCHASED → replenish spawn after timer
-- ============================================================
-- Called from vehicle manager's UnlockVehicleServer after player buys
-- Fire this event from UnlockVehicleServer:
--   Event.Fire("WorldVehicle_Purchased", { spawnId = spawnId })
Event.Add("WorldVehicle_Purchased", function(data)
    local spawnId = data and tonumber(data.spawnId)
    if not spawnId then
        print("[WorldVehicles] WorldVehicle_Purchased — invalid spawnId")
        return
    end

    local sp = worldSpawnPoints[spawnId]
    if not sp then
        print(string.format("[WorldVehicles] WorldVehicle_Purchased — no spawn point for spawnId=%d", spawnId))
        return
    end

    print(string.format("[WorldVehicles] Player purchased world vehicle at spawnId=%d — replenishing after timer",
        spawnId))
    DeactivateWorldSpawn(spawnId)
end)

-- ============================================================
--  WAYPOINT / SAVE / RESOURCE handlers (unchanged)
-- ============================================================
Net.AddEvent("Vehicle_Set_Waypoint", function(data)
    if not data or not data.netid then
        print("[VehicleSpawner] Invalid waypoint payload.")
        return
    end

    local nid    = tonumber(data.netid)
    local veh    = World.GetObjectByNID(nid)
    local pos    = veh:GetPosition()
    local sender = Net.Sender()

    print(string.format("[VehicleSpawner] Waypoint for %s -> (%.2f, %.2f, %.2f)",
        tostring(data.model or "unknown"), pos.x, pos.y, pos.z))

    Net.SendToPlayer(sender, "Vehicle_Waypoint_Broadcast", {
        netid = nid,
        id = data.id,
        model = data.model,
        pos = { x = pos.x, y = pos.y, z = pos.z }
    })
end)

Net.AddEvent("Vehicle_Save_Request", function(data)
    local client = Net.Sender()
    if not client then return end
    if not VehicleTableReady then
        print("[VehicleDB] Save skipped because vehicles table is unavailable")
        return
    end

    local playerName = client:GetName()

    if not data or not data.model or not data.pos or not data.rot then
        print("[VehicleDB] Invalid save payload from " .. playerName)
        return
    end

    local pos    = data.pos
    local rot    = data.rot
    local result, err = SQL.Execute([[
        INSERT INTO vehicles (game_id, model, spawned_by, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]],
        tostring(data.id or ""), tostring(data.model), tostring(playerName),
        tonumber(pos.x) or 0.0, tonumber(pos.y) or 0.0, tonumber(pos.z) or 0.0,
        tonumber(rot.x) or 0.0, tonumber(rot.y) or 0.0, tonumber(rot.z) or 0.0)

    if not result then
        print("[VehicleDB] Vehicle save failed:", err or "unknown error")
        return
    end

    local rows, error = SQL.Query("SELECT saved_at FROM vehicles ORDER BY saved_at DESC LIMIT 1")
    if error then
        print("[VehicleDB] Vehicle save timestamp lookup failed:", error)
    end

    local row = rows and rows[1]
    local savedAt = row and row.saved_at or os.date("%Y-%m-%d %H:%M:%S")

    Net.Broadcast("Vehicle_Save_Broadcast", {
        model = data.model,
        spawned_by = playerName,
        pos = pos,
        rot = rot,
        saved_at = savedAt
    })

    print(string.format("[VehicleDB] %s saved '%s' at (%.2f, %.2f, %.2f) | %s",
        playerName, data.model, pos.x, pos.y, pos.z, savedAt))
end)

local function getResourceList()
    local resources     = {}
    local all_resources = Resources.GetAll()
    for _, resource in ipairs(all_resources) do
        table.insert(resources, {
            name   = resource:GetName(),
            status = resource:GetStatus()
        })
    end
    return resources
end

Net.AddEvent("resource_request", function()
    local sender        = Net.Sender()
    local resource_list = getResourceList()
    Net.SendToPlayer(sender, "resource_response", resource_list)
end)

if VehicleTableReady then LoadSavedVehicles() end

Net.AddEvent("Loot:RequestSpawnList", function()
    local sender = Net.Sender()
    local nick   = sender:GetName()

    local function sendSpawnList(rows, error)
        if error then
            print("[Loot] Spawn list query failed:", error)
            rows = {}
        end

        local list = {}
        if rows then
            for _, row in ipairs(rows) do
                table.insert(list, {
                    id         = row.id,
                    tier       = row.tier,
                    name       = "T" .. row.tier .. " Spawn",
                    spawned_by = row.placed_by,
                    pos_x      = row.pos_x,
                    pos_y      = row.pos_y,
                    pos_z      = row.pos_z,
                    date       = row.created_at,
                })
            end
        end

        Net.SendToPlayer(sender, "Loot:SpawnListResponse", { loots = list })
    end

    if sender:HasAcl(AclLevel.Moderator) and not sender:HasAcl(AclLevel.Owner) and not sender:HasAcl(AclLevel.Admin) then
        -- Only show spawns placed by this player
        print(string.format("[Loot] Moderator %s requested own spawn list", nick))
        sendSpawnList(SQL.Query("SELECT * FROM LootSpawnPoints WHERE placed_by = ? ORDER BY id DESC", nick))
    else
        -- Admin/Owner sees everything
        print(string.format("[Loot] Admin %s requested full spawn list", nick))
        sendSpawnList(SQL.Query("SELECT * FROM LootSpawnPoints ORDER BY id DESC"))
    end
end)

Net.AddEvent("Loot:DeleteSpawnPoint", function(data)
    local id = tonumber(data.id)
    if not id then
        print("[Loot] DeleteSpawnPoint — invalid id")
        return
    end

    local result, err = SQL.Execute("DELETE FROM LootSpawnPoints WHERE id = ?", id)
    if result then
        print(string.format("[Loot] Deleted spawn point id=%d", id))
        Net.Broadcast("Loot:SpawnPointDeleted", { id = id })
    else
        print("[Loot] Delete failed:", err or "unknown error")
    end
end)

Net.AddEvent("PlayerActionFromClient", function(data)
    local sender = Net.Sender()
    if not sender then return end

    if not sender:HasAcl(AclLevel.Owner) and not sender:HasAcl(AclLevel.Admin) and not sender:HasAcl(AclLevel.Moderator) then
        print(string.format("[Dashboard] Unauthorized player action attempt by %s", sender:GetName()))
        return
    end

    local action  = data.action
    local steamid = tostring(data.steamid)
    local name    = tostring(data.name or "unknown")

    print(string.format("[Dashboard] Action '%s' on %s (%s) by %s",
        action, name, steamid, sender:GetName()))

    -- Find target player
    local target = nil
    for _, client in ipairs(World.GetPlayers()) do
        if tostring(client:GetUserId()) == steamid then
            target = client
            break
        end
    end

    if action == "whisper" then
        if not target then
            print("[Dashboard] Whisper — target not found: " .. steamid)
            return
        end
        local msg = tostring(data.message or "")
        -- Send whisper message to target via chat
        Net.SendToPlayer(target, "admin_whisper", {
            from    = sender:GetName(),
            message = msg
        })
        print(string.format("[Dashboard] Whispered to %s: %s", name, msg))
    elseif action == "kick" then
        if not target then
            print("[Dashboard] Kick — target not found: " .. steamid)
            return
        end
        local reason = tostring(data.reason or "No reason given")
        target:Kick(reason)
        print(string.format("[Dashboard] Kicked %s — reason: %s", name, reason))
    elseif action == "ban" then
        if not target then
            print("[Dashboard] Ban — target not found: " .. steamid)
            return
        end
        local reason = tostring(data.reason or "No reason given")
        target:Ban(reason)
        print(string.format("[Dashboard] Banned %s — reason: %s", name, reason))
    elseif action == "teleport_to" then
        -- Teleport sender to target
        if not target then
            print("[Dashboard] TeleportTo — target not found: " .. steamid)
            return
        end
        local targetPlayer = target:GetPlayer()
        if not targetPlayer then return end
        local pos = targetPlayer:GetPosition()
        local senderPlayer = sender:GetPlayer()
        if not senderPlayer then return end
        senderPlayer:AsPlayer():Teleport(vec3(pos.x, pos.y + 2, pos.z))
        print(string.format("[Dashboard] Teleported %s to %s at (%.1f, %.1f, %.1f)",
            sender:GetName(), name, pos.x, pos.y, pos.z))
    elseif action == "teleport_to_pos" then
        if not target then
            print(string.format("[Dashboard] TeleportToPos — target %s not online", steamid))
            return
        end
        local pos = data.pos
        if not pos or not pos.x or not pos.y or not pos.z then
            print("[Dashboard] TeleportToPos — invalid pos data")
            return
        end
        local targetPlayer = target:GetPlayer()
        if not targetPlayer then return end
        targetPlayer:AsPlayer():Teleport(vec3(pos.x, pos.y, pos.z))
        print(string.format("[Dashboard] Teleported %s to pos (%.1f, %.1f, %.1f)",
            name, pos.x, pos.y, pos.z))
    elseif action == "teleport_to_me" then
        -- Teleport target to sender
        if not target then
            print("[Dashboard] TeleportToMe — target not found: " .. steamid)
            return
        end
        local senderPlayer = sender:GetPlayer()
        if not senderPlayer then return end
        local pos = senderPlayer:GetPosition()
        local targetPlayer = target:GetPlayer()
        if not targetPlayer then return end
        targetPlayer:AsPlayer():Teleport(vec3(pos.x + 2, pos.y, pos.z))
        print(string.format("[Dashboard] Teleported %s to %s at (%.1f, %.1f, %.1f)",
            name, sender:GetName(), pos.x, pos.y, pos.z))
    elseif action == "set_health" then
        if not target then
            print("[Dashboard] SetHealth — target not found: " .. steamid)
            return
        end
        local hp = tonumber(tonumber(data.value))
        if not hp then return end
        local targetPlayer = target:GetPlayer()
        if not targetPlayer then return end
        -- the UI asks for 0-800 (the old max health), health is 0..1 now
        targetPlayer:SetHealth(math.min(hp / 800, 1))
        print(string.format("[Dashboard] Set health of %s to %.1f", name, hp))
    elseif action == "show_inventory" then
        print(string.format("[Dashboard] Fetching inventory for %s (%s)", name, steamid))

        local rows, error = SQL.Query([[
        SELECT category, slot, stack_data
        FROM player_inventory
        WHERE steam_id = ?
        ORDER BY category ASC, slot ASC
    ]], steamid)
        if error then
            print("[Dashboard] Inventory query failed:", error)
            rows = {}
        end

        local items = {}
        if rows then
            for _, row in ipairs(rows) do
                table.insert(items, {
                    category   = row.category,
                    slot       = row.slot,
                    stack_data = row.stack_data, -- raw JSON string, parse on client
                })
            end
        end

        print(string.format("[Dashboard] Found %d inventory slots for %s", #items, name))

        Net.SendToPlayer(sender, "admin_inventory_data", {
            name      = name,
            steamid   = steamid,
            inventory = items,
        })
    else
        print(string.format("[Dashboard] Unknown action: %s", tostring(action)))
    end
end)
