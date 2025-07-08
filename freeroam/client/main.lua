Event.Add("ResourceStart", function(name)
	if Resource.Name == name then
		Local.UnlockAbility(Ability.GrapplingHook)
		Local.UnlockAbility(Ability.Parachute)
		Local.UnlockAbility(Ability.Wingsuit)
		Local.UnlockAbility(Ability.Hammer)
		Local.UnlockAbility(Ability.ExitVehicle)
		Local.UnlockAbility(Ability.Tether)
		Local.UnlockAbility(Ability.RetractTether)
		Local.UnlockAbility(Ability.ParachuteSlingshot)
	end
end)

Event.Add("ResourceStop", function(name)
	if Resource.Name == name then
		Local.LockAbility(Ability.GrapplingHook)
		Local.LockAbility(Ability.Parachute)
		Local.LockAbility(Ability.Wingsuit)
		Local.LockAbility(Ability.Hammer)
		Local.LockAbility(Ability.ExitVehicle)
		Local.LockAbility(Ability.Tether)
		Local.LockAbility(Ability.RetractTether)
		Local.LockAbility(Ability.ParachuteSlingshot)
	end
end)