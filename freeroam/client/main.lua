Event.Add("OnResourceStart", function(name)
	if Resource.Name == name then
		Local.UnlockAbility(Ability.GrapplingHook)
		Local.UnlockAbility(Ability.Parachute)
		Local.UnlockAbility(Ability.Wingsuit)
		Local.UnlockAbility(Ability.Hammer)
		Local.UnlockAbility(Ability.ExitVehicle)
		Local.UnlockAbility(Ability.Tether)
		Local.UnlockAbility(Ability.RetractTether)
		Local.UnlockAbility(Ability.ParachuteSlingshot)

		Players.SetTagsEnabled(true)
		World.SetTime(12)
	end
end)

Event.Add("OnResourceStop", function(name)
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

Event.Add("OnKeyDown", function(key)
	if key == Key.F and not Chat.IsTyping() then
		local client = Players.Local()
		local player = client:GI()
		local character = player:GetCharacter()

		character:GoRagdoll()
	end
end)

Cmd.Add("lmao", function()
	local player = Players.Local()
	local spawn_pos = player:GI():GetAimPosition()

    Net.Send("lmao1", spawn_pos)
end)

Event.Add("OnVehiclePartChangedState", function(vehicle, part, state)
	-- I will check if the driver door is opened here and make the vehicle explode when the door is closed
	-- and i will add this in a random test so you will not expect it
end)