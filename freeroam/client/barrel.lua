-- rigid object sync test: /barrel spawns a dynamic barrel where you aim. JC4MP only spawns a rigid object whose model
-- and collision the game already has loaded, so it asks for the first barrel loaded here (the other client needs it too)

local BARRELS = {
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_a",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_b",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_b1",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_c",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_blue_a",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_brown_a",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_brown_b",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_orange_a",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_orange_b",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_red_b",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_yellow_a",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_yellow_b",
	"models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_water_barrel_01",
	"models/environments/locale_global/gas_station_a/gas_station_prop_a_barrel_01",
}

Cmd.Add("barrel", function()
	for _, base in ipairs(BARRELS) do
		if Asset.IsLoaded(base .. ".modelc") and Asset.IsLoaded(base .. "_col.pfxc") then
			return Net.Send("SpawnTestBarrel", World.LocalPlayer():AsPlayer():GetAimPosition() + vec3(0, 1, 0), base)
		end
	end

	error("no barrel is loaded here", 0)
end)