local wv_url = "resource://default-scripts/spawn-menu/client/window.html"
local WEBVIEW_ID = "spawn_menu_ui"
local webview_created = false
local activeWindow = false

function CreateWebView()
    local screenSize = Render.GetSize()
    local size = vec2(860, 640)
    local pos = (screenSize / 2) - (size / 2)

    local created = WebView.Create(WEBVIEW_ID, {
        url = wv_url,
        position = pos,
        size = size,
        visible = true,
        input_enabled = false,
        z_order = 100
    })

    if created ~= "" then
        webview_created = true

        WebView.SetMessageHandler(WEBVIEW_ID, function(event, data)
            if event == "spawn:item" then
                if data and data.id and data.type then
                    local player = Players.LocalPlayer()
                    if player then
                        if data.type == "vehicle" then
                            local spawn_pos = player:GetPosition()
                            local spawn_rot = player:GetRotation()
                            Net.Send("spawn", data.id, spawn_pos, spawn_rot, Players.LocalClient())
                        elseif data.type == "mounted_gun" then
                            local spawn_pos = player:GetAimPosition()
                            Net.Send("spawnMg", data.id, spawn_pos)
                        elseif data.type == "skin" then
                            Local.SetSkin(data.id)
                        elseif data.type == "weapon" then
                            Net.Send("weapon", data.id, Players.LocalClient())
                        end
                        SetVisible(false)
                    end
                end
            elseif event == "ui:close" then
                SetVisible(false)
            end
        end)
    end
end

function SetVisible(visible)
    if not webview_created then
        return
    end

    activeWindow = visible
    WebView.SetVisible(WEBVIEW_ID, visible)
    WebView.SetInputEnabled(WEBVIEW_ID, visible)
    UI.SetCursorVisible(visible)
end

function ToggleSpawnMenu()
    if not webview_created then
        CreateWebView()
    end

    activeWindow = not activeWindow
    SetVisible(activeWindow)
end

function OnResourceStop(resourceName)
    if resourceName == Resource.Name then
        if webview_created then
            if activeWindow then
                SetVisible(false)
            end
            WebView.Destroy(WEBVIEW_ID)
        end
    end
end

Event.Add("OnKeyUp", function(key)
    if key == Key.V then
        ToggleSpawnMenu()
    end
end)

Event.Add("OnResourceStop", OnResourceStop)