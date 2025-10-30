Event.Add("OnResourceStart", function(name)
	if Resource.Name == name then
		Local.LockAbility(Ability.Tether)
		Local.UnlockAbility(Ability.Parachute)
		Local.UnlockAbility(Ability.Wingsuit)
		Local.UnlockAbility(Ability.Hammer)
		Local.UnlockAbility(Ability.ExitVehicle)
	end
end)

Event.Add("OnResourceStop", function(name)
	if Resource.Name == name then
		Local.UnlockAbility(Ability.Tether)
		Local.LockAbility(Ability.Parachute)
		Local.LockAbility(Ability.Wingsuit)
		Local.LockAbility(Ability.Hammer)
		Local.LockAbility(Ability.ExitVehicle)
	end
end)