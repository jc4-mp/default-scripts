-- hold the fire key to make your NPC fire at you, press the grenade key to make it throw a grenade at you

local FIRE_KEY = Key.B
local GRENADE_KEY = Key.G

local firing = false
local grenade_key_down = false -- a held key repeats OnKeyDown, a press throws one grenade

local function set_firing(enable)
	if firing == enable then return end

	firing = enable

	Net.Send("npc_shooter_fire", enable)
end

Event.Add("OnKeyDown", function(key)
	if key == FIRE_KEY then
		set_firing(true)
	elseif key == GRENADE_KEY and not grenade_key_down then
		grenade_key_down = true

		Net.Send("npc_shooter_grenade")
	end
end)

Event.Add("OnKeyUp", function(key)
	if key == FIRE_KEY then
		set_firing(false)
	elseif key == GRENADE_KEY then
		grenade_key_down = false
	end
end)