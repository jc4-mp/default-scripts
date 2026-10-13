Net.AddEvent("spawnTornado", function(position)
    Weather.SyncAct(WeatherAct.SpawnTornado, position, 5.0)
end)

Net.AddEvent("despawnTornado", function(position)
    Weather.SyncAct(WeatherAct.DespawnTornado, 5.0)
end)

Net.AddEvent("setTornadoPos", function(position)
    Weather.SyncProperty(WeatherProperty.TornadoPosition, position)
end)

Net.AddEvent("setSandstorm", function(position)
    Weather.SyncProperty(WeatherProperty.SandstormPosition, position)
end)