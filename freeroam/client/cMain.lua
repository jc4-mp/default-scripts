Event.Add("ClientJoin", function()
	local localPlayer = Players.Local():GetGamePlayer()
	
	localPlayer:EnableAbility(Ability.GrapplingHook)
	localPlayer:EnableAbility(Ability.Parachute)
	localPlayer:EnableAbility(Ability.Wingsuit)
	localPlayer:EnableAbility(Ability.ExitVehicle)
end)