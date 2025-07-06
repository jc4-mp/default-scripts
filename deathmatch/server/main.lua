local spawnpoints = 
{
    vec3(2851.5984, 541.08887, -9920.057),
    vec3(2854.5715, 528.397, -9935.115),
    vec3(2834.3748, 516.5238, -9991.221),
    vec3(2869.9185, 516.65894, -9997.688),
    vec3(2858.1287, 531.3163, -10004.096),
    vec3(2819.4868, 523.0144, -9969.774),
    vec3(2871.0574, 520.4144, -9885.819),
    vec3(2908.9282, 529.0062, -9977.156)
}

local weapons =
{
    "wpn_000_assault_rifle",
    "wpn_001_assault_rifle",
    "wpn_022_shotgun",
    "wpn_032_sniper_rifle",
    "wpn_050_smg"
}

function respawnPlayer(player)
	Timer.Set(function(player)
        player:Respawn(spawnpoints[math.random(1, #spawnpoints)])
        player:GiveWeapon(weapons[math.random(1, #weapons)], 240, true, WeaponSlot.Primary)

        print(weapons[math.random(1, #weapons)])
    end, 2500, 1, player)
end

Event.Add("PlayerJoin", function(client)
    respawnPlayer(client:GetNetPlayer())
end)

Event.Add("PlayerKilled", function(player, damager, loss, hitBone, weapon, position)
    respawnPlayer(player)
end)