local TableResult = SQL.Execute([[
    CREATE TABLE IF NOT EXISTS accounts (
		steam_id TEXT PRIMARY KEY NOT NULL
    )
]])

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
	
	local entries = SQL.Query("SELECT steam_id FROM accounts WHERE steam_id = ?", steamId)
	if #entries == 1 then
		print("Player " .. steamId .. " logged in: ")
	else
		print("Player " .. steamId .." is not allowed to register")
	end
end

-- temp shit for now, we don't have ClientResourceStart yet

Event.Add("ResourceStart", function(name)
	if Resource.Name ~= name then return end
	
	for k, v in pairs(Players.GetJoined()) do
		LoadPlayer(v)
	end
end)

Event.Add("PlayerJoin", function(client)
	LoadPlayer(client)
end)