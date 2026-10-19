-- hold the fire key to make your NPC fire at you, press the grenade key to make it throw a grenade at you and the melee
-- key to make it run at you and hit you

local FIRE_KEY = Key.B
local GRENADE_KEY = Key.G
local MELEE_KEY = Key.U

local firing = false
local keys_down = {} -- a held key repeats OnKeyDown, a press throws one grenade or hits once

local function set_firing(enable)
	if firing == enable then return end

	firing = enable

	Net.Send("npc_shooter_fire", enable)
end

local function press(key, event)
	if keys_down[key] then return end

	keys_down[key] = true

	Net.Send(event)
end

Event.Add("OnKeyDown", function(key)
	if key == FIRE_KEY then
		set_firing(true)
	elseif key == GRENADE_KEY then
		press(key, "npc_shooter_grenade")
	elseif key == MELEE_KEY then
		press(key, "npc_shooter_melee")
	end
end)

Event.Add("OnKeyUp", function(key)
	if key == FIRE_KEY then
		set_firing(false)
	end

	keys_down[key] = nil
end)