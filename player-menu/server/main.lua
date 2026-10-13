-- clients have no pings (only the server keeps them): every second they go to the players that have the menu open

local watching = {} -- user id -> PlayerHandle of a player with the menu open

Net.AddEvent("playerMenu:open", function(open)
    local sender = Net.Sender()

    if sender then watching[sender:GetUserId()] = open and sender or nil end
end)

Event.Add("OnPlayerQuit", function(client)
    watching[client:GetUserId()] = nil
end)

Timer.Set(function()
    if next(watching) == nil then return end

    local pings = {}

    for _, client in ipairs(World.GetPlayers()) do
        pings[#pings + 1] = { client:GetNetId(), client:GetPing() }
    end

    local targets = {}

    for _, client in pairs(watching) do
        targets[#targets + 1] = client
    end

    Net.SendToPlayers(targets, "playerMenu:pings", pings)
end, 1000, -1)

-- the Warp button: the sender goes to where the server has the target player

Net.AddEvent("playerMenu:warp", function(target_net_id)
    local sender = Net.Sender()
    local sender_player = sender and sender:GetPlayer()

    if not sender_player then return end

    for _, client in ipairs(World.GetPlayers()) do
        if client:GetNetId() == target_net_id then
            local target = client:GetPlayer()

            if target then sender_player:AsPlayer():Teleport(target:GetPosition()) end

            return
        end
    end
end)