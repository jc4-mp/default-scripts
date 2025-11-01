local CENTER = vec3(10030, 616, 3904)
local START_DELAY = 3000
local CHECK_INTERVAL = 500
local VEHICLE_POOL = {
    "v018_car_monstertruck_civilian_01", "v008_car_taxitrike_civilian",
    "v046_car_racingbuggy_civilian", "v004_car_articulatedtruck_commercial_01",
    "v023_car_racingsuper_civilian_01", "v013_car_armoredtransport_military_01",
    "v014_car_offroadtruck_military_01"
}
local spawnedVehicles = {}
local alivePlayers = {}
local playerVehicleMap = {}
local roundActive = false
local setupInProgress = false
local heightTimer = nil
local freezeTimer = nil
local loadedCount = 0
local totalPlayers = 0

local function broadcast(msg)
    Chat.Broadcast(msg:gsub("[\128-\255]", ""))
end

local function getAllPlayers()
    local players = {}
    for _, obj in ipairs(World.GetAllByType(NetObjectType.Player)) do
        local p = obj:AsPlayer()
        if p then table.insert(players, p) end
    end
    return players
end

local function checkVehicleHeights()
    if not roundActive then return end
    for pid, player in pairs(alivePlayers) do
        local vehNetId = playerVehicleMap[pid]
        if vehNetId and spawnedVehicles[vehNetId] then
            local veh = spawnedVehicles[vehNetId]
            if veh:GetPosition().y < 595 then
                veh:SetHealth(-10000)
            end
        end
    end
end

local function startRoundCountdown()
    Timer.Set(function()
        broadcast("The derby will begin in 3 seconds!")
    end, 1, 1)
    Timer.Set(function()
        broadcast("2...")
    end, 1000, 1)
    Timer.Set(function()
        broadcast("1...")
    end, 2000, 1)

    Timer.Set(function()
        broadcast("GO! Let the chaos begin!")
        roundActive = true
        heightTimer = Timer.Set(checkVehicleHeights, CHECK_INTERVAL, -1)
    end, START_DELAY, 1)
end

local function endRound()
    if not roundActive and not setupInProgress then return end
    roundActive = false
    setupInProgress = false

    if heightTimer then
        Timer.Kill(heightTimer)
        heightTimer = nil
    end

    if freezeTimer then
        Timer.Kill(freezeTimer)
        freezeTimer = nil
    end

    local vehiclesToDestroy = {}
    for _, veh in pairs(spawnedVehicles) do
        table.insert(vehiclesToDestroy, veh)
    end
    for _, veh in ipairs(vehiclesToDestroy) do
        if veh then World.Destroy(veh) end
    end

    spawnedVehicles, alivePlayers, playerVehicleMap = {}, {}, {}
    Net.Broadcast("Derby:EnableAbilities")
end

local function checkWinner()
    if not roundActive then return end

    local aliveCount = 0
    local lastPlayer = nil
    for _, player in pairs(alivePlayers) do
        aliveCount = aliveCount + 1
        lastPlayer = player
    end

    if aliveCount <= 1 then
        if lastPlayer then
            broadcast(string.format("%s wins the derby!", lastPlayer:GetNick()))
        else
            broadcast("All vehicles have been destroyed. No winner this round.")
        end
        Timer.Set(endRound, 2000, 1)
    end
end

local function removePlayerFromDerby(player)
    local pid = tostring(player:GetNetId())
    if not alivePlayers[pid] then return end
    
    broadcast(string.format("%s has been eliminated!", player:GetNick()))
    alivePlayers[pid] = nil

    local vehNetId = playerVehicleMap[pid]
    if vehNetId and spawnedVehicles[vehNetId] then
        spawnedVehicles[vehNetId]:SetHealth(0)
    end
    
    checkWinner()
end

Event.Add("OnPlayerTeleport", function(player)
    if not setupInProgress then return end
    
    local pNetId = tostring(player:GetNetId())
    if alivePlayers[pNetId] then
        local vehNetId = playerVehicleMap[pNetId]
        if vehNetId and spawnedVehicles[vehNetId] then
            player:WarpIntoVehicle(spawnedVehicles[vehNetId], VehicleSeat.Driver)
        end

        loadedCount = loadedCount + 1
        broadcast(string.format("%d of %d players loaded...", loadedCount, totalPlayers))
        
        if loadedCount >= totalPlayers then
            setupInProgress = false
            startRoundCountdown()
        end
    end
end)

Event.Add("OnPlayerKilled", function(player, _, _, _, _, _)
    if roundActive and alivePlayers[tostring(player:GetNetId())] then
        removePlayerFromDerby(player)
    end
end)

Net.AddEvent("Derby:StartRequest", function(_)
    local caller = Net.Sender()
    if not caller then return end
    if roundActive or setupInProgress then return end

    local acl = caller:GetAclLevel()
    if acl ~= AclLevel.Admin and acl ~= AclLevel.Owner then
        Net.Send("Derby:StartDenied", { msg = "You need admin rights." }, caller)
        return
    end

    setupInProgress = true
    local players = getAllPlayers()
    totalPlayers = #players
    loadedCount = 0

    if totalPlayers == 0 then
        broadcast("No players to start a derby.")
        setupInProgress = false
        return
    end

    alivePlayers, spawnedVehicles, playerVehicleMap = {}, {}, {}
    local model = VEHICLE_POOL[math.random(#VEHICLE_POOL)]
    broadcast("Welcome to the derby! Your goal: be the last one standing. Destroy your rivals, push them over the edge, and whatever you do... don't fall off the roof!")
    broadcast(string.format("Derby starting with %d participants. Please wait.", totalPlayers))
    for i, player in ipairs(players) do
        local angle = (2 * math.pi / totalPlayers) * (i - 1)

        local radius = 100
        local pos = vec3(
            CENTER.x + radius * math.cos(angle),
            CENTER.y,
            CENTER.z + radius * math.sin(angle)
        )

        local yaw = math.atan(pos.x - CENTER.x, pos.z - CENTER.z)

        local half_yaw = yaw * 0.5
        local rot = quat(math.cos(half_yaw), 0, math.sin(half_yaw), 0)

        local veh = World.SpawnVehicle(model, pos, rot)

        veh:SetLocked(true)
        veh:SetRotation(rot)

        local pNetId = tostring(player:GetNetId())
        local vNetId = tostring(veh:GetNetId())
        spawnedVehicles[vNetId] = veh
        playerVehicleMap[pNetId] = vNetId
        alivePlayers[pNetId] = player
    end

    freezeTimer = Timer.Set(function()
        if roundActive then
            Timer.Kill(freezeTimer)
            freezeTimer = nil
            return
        end
        for _, veh in pairs(spawnedVehicles) do
            if veh then
                veh:SetVelocity(vec3(0, 0, 0))
            end
        end
    end, 50, -1)

    local safeSpot = vec3(CENTER.x, CENTER.y + 10, CENTER.z)
    for _, player in pairs(alivePlayers) do
        player:Teleport(safeSpot)
    end

    Net.Broadcast("Derby:DisableAbilities")
end)

Event.Add("OnResourceStop", function()
    if roundActive or setupInProgress then endRound() end
end)