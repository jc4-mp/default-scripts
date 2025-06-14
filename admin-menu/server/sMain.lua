-- Helper function to check if player has admin permissions
local function hasAdminPermission(player)
    if not player then return false end
    
    local acl_level = player:GetAclLevel()
    return acl_level == AclLevel.Admin or acl_level == AclLevel.Owner
end

-- Helper function to get all resources and their status
local function getResourceList()
    local resources = {}
    local all_resources = Resources.GetAll()
    
    for _, resource in ipairs(all_resources) do
        local name = resource:GetName()
        local status = resource:GetStatus()
        table.insert(resources, {
            name = name,
            status = status
        })
    end
    
    return resources
end

-- Network event: Client requests resource list
Net.AddEvent("admin_menu_request", function(player)
    if not hasAdminPermission(player) then
        Net.SendToTarget(player, "admin_menu_error", "Access denied: Insufficient permissions")
        return
    end
    
    local resources = getResourceList()
    Net.SendToTarget(player, "admin_menu_response", resources)
end)

-- Network event: Client requests resource action (start/stop/restart)
Net.AddEvent("resource_action", function(player, resource_name, action)
    if not hasAdminPermission(player) then
        Net.SendToTarget(player, "resource_action_result", false, "Access denied: Insufficient permissions")
        return
    end
    
    if not resource_name or resource_name == "" then
        Net.SendToTarget(player, "resource_action_result", false, "Invalid resource name")
        return
    end
    
    local success = false
    local message = ""
    
    if action == "start" then
        success = Resources.Start(resource_name)
        message = success and ("Resource '" .. resource_name .. "' started successfully") or ("Failed to start resource '" .. resource_name .. "'")
    elseif action == "stop" then
        success = Resources.Stop(resource_name)
        message = success and ("Resource '" .. resource_name .. "' stopped successfully") or ("Failed to stop resource '" .. resource_name .. "'")
    elseif action == "restart" then
        success = Resources.Restart(resource_name)
        message = success and ("Resource '" .. resource_name .. "' restarted successfully") or ("Failed to restart resource '" .. resource_name .. "'")
    else
        Net.SendToTarget(player, "resource_action_result", false, "Invalid action: " .. tostring(action))
        return
    end
    
    -- Log admin action
    print("[AdminMenu] " .. player:GetNick() .. " (" .. player:GetNetId() .. ") performed action '" .. action .. "' on resource '" .. resource_name .. "' - " .. (success and "SUCCESS" or "FAILED"))
    
    Net.SendToTarget(player, "resource_action_result", success, message)
end)

Net.AddEvent("admin_menu_request_open", function(player)
    print("admin_menu_request_open")
    print(player)
    
    if not hasAdminPermission(player) then
        print("Access denied: Insufficient permissions")
        Net.SendToTarget(player, "admin_menu_error", "Access denied: Insufficient permissions")
        return
    end
    
    local resources = getResourceList()
    Net.SendToTarget(player, "admin_permission_granted", true)
    Net.SendToTarget(player, "admin_menu_response", resources)
end)

print("[AdminMenu] Server-side loaded successfully")
