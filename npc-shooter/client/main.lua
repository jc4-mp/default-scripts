-- hold the key to make your NPC fire at you

local FIRE_KEY = Key.B

local firing = false

local function set_firing(enable)
	if firing == enable then return end

	firing = enable

	Net.Send("npc_shooter_fire", enable)
end

Event.Add("OnKeyDown", function(key)
	if key == FIRE_KEY then
		set_firing(true)
	end
end)

Event.Add("OnKeyUp", function(key)
	if key == FIRE_KEY then
		set_firing(false)
	end
end)