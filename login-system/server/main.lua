local TableResult = SQL.Execute([[
    CREATE TABLE IF NOT EXISTS accounts (
		steam_id TEXT PRIMARY KEY NOT NULL,
		acl_level INTEGER NOT NULL
    )
]])

if TableResult.success then
    print("Accounts table created successfully")
else
    print("Accounts table creation failed:", TableResult.error)
end

local acl =
{
	["76561198149892734"] = { level = AclLevel.Owner } -- tony
}

function LoadPlayer(client)
	if not TableResult.success then return end
	
	-- register player if it doesn't exist
	
	local steamId = client:GetSteamId()
	local aclEntry = acl[steamId]
	local aclLevel = AclLevel.Normal

	-- if player is in the ACL, set its level
	
	if aclEntry then aclLevel = aclEntry.level end
	
	SQL.Execute("INSERT INTO accounts (steam_id, acl_level) VALUES (?, ?)", steamId, aclLevel)
	
	-- get this player's info
	
	local entries = SQL.Query("SELECT steam_id, acl_level FROM accounts WHERE steam_id = ?", steamId)
	if #entries == 1 then
		client:SetAclLevel(entries[1].acl_level)
		
		print("Player " .. steamId .. " logged in, acl level: " .. entries[1].acl_level)
	else
		print("Player " .. steamId .." is not allowed to register")
	end
end

-- temp shit for now, we don't have ClientResourceStart yet

Event.Add("ResourceStart", function()
	for k, v in pairs(Players.GetJoined()) do
		LoadPlayer(v)
	end
end)

Event.Add("PlayerJoin", function(client)
	LoadPlayer(client)
end)