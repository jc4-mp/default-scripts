local TableResult = SQL.Execute([[
    CREATE TABLE IF NOT EXISTS accounts (
		steam_id TEXT PRIMARY KEY NOT NULL,
        last_seen DATETIME DEFAULT CURRENT_TIMESTAMP,
		x FLOAT DEFAULT NULL,
		y FLOAT DEFAULT NULL,
		z FLOAT DEFAULT NULL
    )]])

if TableResult.success then
    print("Accounts table created successfully")
else
    print("Accounts table creation failed:", TableResult.error)
end

function LoadPlayer(client)
	if not TableResult.success then return end
	
	-- register player if it doesn't exist
	
	local steamId = client:GetSteamId()
	
	SQL.Execute("INSERT INTO accounts (steam_id) VALUES (?)", steamId)
	
	-- get this player's info
	
	local entries = SQL.Query("SELECT steam_id, x, y, z FROM accounts WHERE steam_id = ?", steamId)
	if #entries == 1 then
		-- load player's info
		
		local entry = entries[1]
		
		if entry.x and entry.y and entry.z then
			local position = vec3(entry.x, entry.y, entry.z)

			print("Saved position:", position)
			
			Net.SendToTarget(client, "loadPlayerInfo", position)
		end
			
		print("Player " .. steamId .. " logged in")
	else
		print("Player " .. steamId .." is not allowed to register")
	end
end

function SavePlayer(client)
	if not TableResult.success then return end

	local steamId = client:GetSteamId()
	local player = client:GetNetPlayer()
	local playerPos = player:GetPosition()
	
	local result = SQL.Execute([[
		UPDATE accounts
		SET x = ?, y = ?, z = ?, last_seen = CURRENT_TIMESTAMP
		WHERE steam_id = ?]], playerPos.x, playerPos.y, playerPos.z, steamId)
	
	if result.success then
		print("Player " .. steamId .. " saved")
	else
		print("Player " .. steamId .." could not be saved:", result.error)
	end
end

Event.Add("PlayerResourceAction", function(client, name, action)
	if Resource.Name ~= name or action ~= ResourceAction.Start then return end
	
	LoadPlayer(client)
end)

Event.Add("PlayerQuit", function(client)
	SavePlayer(client)
end)