local TableResult, TableError = SQL.Execute([[
    CREATE TABLE IF NOT EXISTS accounts (
		steam_id TEXT PRIMARY KEY NOT NULL,
        last_seen DATETIME DEFAULT CURRENT_TIMESTAMP,
        skin VARCHAR(128) DEFAULT '',
		x FLOAT DEFAULT NULL,
		y FLOAT DEFAULT NULL,
		z FLOAT DEFAULT NULL
    )]])

if TableResult then
    print("Accounts table created successfully")
else
    print("Accounts table creation failed:", TableError)
end

function LoadPlayer(client)
	if not TableResult then return end
	
	-- register player if it doesn't exist
	
	local steamId = client:GetUserId()
	
	SQL.Execute("INSERT OR IGNORE INTO accounts (steam_id) VALUES (?)", steamId)
	
	-- get this player's info
	
	local entries = SQL.Query("SELECT steam_id, skin, x, y, z FROM accounts WHERE steam_id = ?", steamId)
	if #entries == 1 then
		-- load player's info
		
		local entry = entries[1]
		
		if entry.x and entry.y and entry.z then
			local player = client:GetPlayer():AsPlayer()
			local position = vec3(entry.x, entry.y, entry.z)

			print("Loaded position:", position)

			player:SetSkin(entry.skin)
			player:Teleport(position)
		end
			
		print("Player " .. steamId .. " logged in")
	else
		print("Player " .. steamId .." is not allowed to register")
	end
end

function SavePlayer(client)
	if not TableResult then return end

	local steamId = client:GetUserId()
	local player = client:GetPlayer():AsPlayer()
	local playerPos = player:GetPosition()
	local skin = player:GetSkin()
	
	local result, err = SQL.Execute([[
		UPDATE accounts
		SET x = ?, y = ?, z = ?, skin = ?, last_seen = CURRENT_TIMESTAMP
		WHERE steam_id = ?]], playerPos.x, playerPos.y, playerPos.z, skin, steamId)

	print("saved position:", playerPos)
	
	if result then
		print("Player " .. steamId .. " saved")
	else
		print("Player " .. steamId .." could not be saved:", err)
	end
end

-- a client starts its resources before it joins, and a player only has its object once joined: those are loaded
-- on join

local pendingLoads = {}

Event.Add("OnPlayerResourceAction", function(client, name, action)
	if Resource.Name ~= name or action ~= ResourceAction.Start then return end
	
	if client:GetPlayer() then
		LoadPlayer(client)
	else
		pendingLoads[client:GetUserId()] = true
	end
end)

Event.Add("OnPlayerJoin", function(client)
	if not pendingLoads[client:GetUserId()] then return end

	pendingLoads[client:GetUserId()] = nil

	LoadPlayer(client)
end)

Event.Add("OnPlayerQuit", function(client)
	SavePlayer(client)
end)