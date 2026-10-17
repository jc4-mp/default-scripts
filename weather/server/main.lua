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

-- the world sandstorm's size and wind (global_sandstorm.location), the newest spawned last

local SANDSTORM_SIZE = vec3(2000, 600, 1000)
local SANDSTORM_WIND_SPEED = 45

local sandstorms = {}

Net.AddEvent("spawnSandstorm", function(position)
    if not is_admin() then return end

    local player = Net.Sender():GetPlayer()
    if not player then return end

    -- the wind blows at the player, and like the world's the box's center is 150 m above the ground (its bottom
    -- 150 m below it)

    local from = player:GetPosition()
    local yaw = math.deg(math.atan2(from.x - position.x, from.z - position.z))

    table.insert(sandstorms, World.SpawnSandstorm(position + vec3(0, 150, 0), SANDSTORM_SIZE, SANDSTORM_WIND_SPEED, vec3(0, yaw, 0)))
end)

Net.AddEvent("destroySandstorm", function()
    if not is_admin() then return end

    local sandstorm = table.remove(sandstorms)

    if sandstorm then
        World.Destroy(sandstorm)
    end
end)