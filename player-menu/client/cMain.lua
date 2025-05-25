local open = false

function toggleOpen()
    open = not open
    Input.SetEnabled(not open)
    UI.SetCursorVisible(open)
end

-- Listen for 'P' key press to toggle the menu
Event.Add("KeyUp", function(key)
    if Chat.IsTyping() then return end

    if key == Key.P then
        toggleOpen()
    end
end)

-- Render the menu if it's open
Event.Add("Render", function()
    if open then
        onRender()
    end
end)

local players_list = {}
local t = 0

function onRender()
    -- Update players list every 1 second
    local nowTime = Client:GetElapsedSeconds()
    if nowTime - t > 1 then
        players_list = Players.GetJoined()
        t = nowTime
    end

    local render_size = Render.GetSize()
    local window_width = math.min(600, math.max(400, render_size.x * 0.35))
    local window_height = math.min(500, math.max(300, render_size.y * 0.6))
    local window_pos = vec2(render_size.x * 0.5 - window_width / 2, render_size.y * 0.5 - window_height / 2)

    UI.SetNextWindowSize(vec2(window_width, window_height), 0) -- 0 for ImGuiCond_Always
    UI.SetNextWindowPos(window_pos, 0)

    local main_window_flags = UI.WindowFlags_NoCollapse

    if UI.Begin("Player List", main_window_flags) then
        local child_height = UI.GetContentRegionAvail().y
        -- Parameters for BeginChild: name, size, border (boolean), window_flags (number)
        if UI.BeginChild("PlayerListScrollRegion", vec2(0, child_height), false, 0) then
            -- Parameters for BeginTable: str_id, column_count, flags (number)
            local table_flags = UI.TableFlags_ScrollY --| UI.TableFlags_Sortable
            if UI.BeginTable("PlayerListTable", 4, table_flags) then
                UI.TableSetupScrollFreeze(1, 1)
                UI.TableSetupColumn("ID", UI.TableColumnFlags_WidthFixed, 40)
                UI.TableSetupColumn("Ping", UI.TableColumnFlags_WidthFixed, 60)
                UI.TableSetupColumn("Name", UI.TableColumnFlags_WidthStretch, 0)
                UI.TableSetupColumn("Warp", UI.TableColumnFlags_WidthFixed, 80)
                UI.TableHeadersRow()

                for _, player_client in ipairs(players_list) do
                    if player_client and player_client.GetNetId and player_client.GetNick then
                        local net_id = player_client:GetNetId()
                        local nick = player_client:GetNick()
                        local net_player = player_client:GetNetPlayer()

                        UI.TableNextRow(nil, 28) -- 28 is a slightly larger row height for padding

                        UI.TableNextColumn()
                        UI.Text(tostring(net_id))

                        UI.TableNextColumn() -- Column for Ping
                        local ping = math.floor(player_client:GetPing())
                        UI.Text(tostring(ping))

                        UI.TableNextColumn()
                        UI.Text(nick or "Loading...")

                        UI.TableNextColumn()
                        if net_player and net_player.GetPosition then
                            local avail = UI.GetContentRegionAvail()
                            if UI.Button("Warp##" .. tostring(net_id), vec2(avail.x, 0)) then
                                local target_pos = net_player:GetPosition()
                                if target_pos then
                                    if Local and Local.Teleport then
                                        Local.Teleport(target_pos)
                                        toggleOpen() -- Close menu after warping
                                    else
                                        print("[PlayerMenu] Error: Local.Teleport function not found.")
                                    end
                                else
                                    print("[PlayerMenu] Warning: Could not get position for player " .. (nick or tostring(net_id)))
                                end
                            end
                        else
                            -- If no net_player or GetPosition, button cannot function
                            UI.Text("N/A")
                        end
                    end
                end
                UI.EndTable()
            end
            UI.EndChild()
        end
        UI.End()
    end
end
