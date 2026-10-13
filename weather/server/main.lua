local function is_admin()
    local player = Net.Sender()
    return player:HasAcl(AclLevel.Admin) or player:HasAcl(AclLevel.Owner)
end

Net.AddEvent("spawnTornado", function(position)
    if not is_admin() then return end
    Weather.SyncAct(WeatherAct.SpawnTornado, position, 5.0)
end)

Net.AddEvent("despawnTornado", function(position)
    if not is_admin() then return end
    Weather.SyncAct(WeatherAct.DespawnTornado, 5.0)
end)

Net.AddEvent("setTornadoPos", function(position)
    if not is_admin() then return end
    Weather.SyncProperty(WeatherProperty.TornadoPosition, position)
end)

Net.AddEvent("setSandstorm", function(position)
    if not is_admin() then return end
    Weather.SyncProperty(WeatherProperty.SandstormPosition, position)
end)