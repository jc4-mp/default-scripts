-- Helper function to check if player has admin permissions
local function hasAdminPermission(player)
    if not player then return false end
    
    return player:HasAcl(AclLevel.Admin) or player:HasAcl(AclLevel.Owner)
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
Net.AddEvent("admin_menu_request", function()
    local sender = Net.Sender()

    if not hasAdminPermission(sender) then
        Net.SendToPlayer(sender, "admin_menu_error", "Access denied: Insufficient permissions")
        return
    end
    
    Net.SendToPlayer(sender, "admin_menu_response", getResourceList())
end)

-- Network event: Client requests resource action (start/stop/restart)
Net.AddEvent("resource_action", function(resource_name, action)
    local sender = Net.Sender()

    if not hasAdminPermission(sender) then
        Net.SendToPlayer(sender, "resource_action_result", false, "Access denied: Insufficient permissions")
        return
    end
    
    if not resource_name or resource_name == "" then
        Net.SendToPlayer(sender, "resource_action_result", false, "Invalid resource name")
        return
    end
    
    local success = false
    local message = ""
    local err = nil
    
    if action == "start" then
        success, err = Resources.Start(resource_name)
        message = success and ("Sent start to resource '" .. resource_name .. "'") or ("Failed to start resource '" .. resource_name .. "': " .. tostring(err))
    elseif action == "stop" then
        success, err = Resources.Stop(resource_name)
        message = success and ("Sent stop to resource '" .. resource_name .. "'") or ("Failed to stop resource '" .. resource_name .. "': " .. tostring(err))
    elseif action == "restart" then
        success, err = Resources.Restart(resource_name)
        message = success and ("Sent restart to resource '" .. resource_name .. "'") or ("Failed to restart resource '" .. resource_name .. "': " .. tostring(err))
    else
        Net.SendToPlayer(sender, "resource_action_result", false, "Invalid action: " .. tostring(action))
        return
    end
    
    -- Log admin action
    print("[AdminMenu] " .. sender:GetName() .. " (" .. sender:GetNetId() .. ") performed action '" .. action .. "' on resource '" .. resource_name .. "' - " .. (success and "SUCCESS" or "FAILED"))
    
    Net.SendToPlayer(sender, "resource_action_result", success, message)
end)

Net.AddEvent("admin_menu_request_open", function()
    local sender = Net.Sender()

    if not hasAdminPermission(sender) then
        print("Access denied: Insufficient permissions")
        Net.SendToPlayer(sender, "admin_menu_error", "Access denied: Insufficient permissions")
        return
    end
    
    local resources = getResourceList()
    Net.SendToPlayer(sender, "admin_permission_granted", true)
    Net.SendToPlayer(sender, "admin_menu_response", resources)
end)

-- resource actions from an event run once it's done, so the admins' lists are refreshed when a resource starts or stops
-- (OnResourceStop comes while the resource still runs, so it's listed as stopped here)
local function sendListToAdmins(stopping)
    local resources = getResourceList()

    for _, resource in ipairs(resources) do
        if resource.name == stopping then resource.status = ResourceStatus.Stopped end
    end

    for _, player in ipairs(World.GetPlayers()) do
        if hasAdminPermission(player) then
            Net.SendToPlayer(player, "admin_menu_response", resources)
        end
    end
end

Event.Add("OnResourceStart", function() sendListToAdmins() end)
Event.Add("OnResourceStop", sendListToAdmins)

print("[AdminMenu] Server-side loaded successfully")
