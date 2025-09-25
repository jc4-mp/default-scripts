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
		local player = Players.LocalPlayer()

		player:GoRagdoll()
	end
end)

Cmd.Add("lmao", function()
    Net.Send("lmao1", Players.LocalPlayer():GetAimPosition())
end)

Event.Add("OnVehiclePartChangedState", function(vehicle, part, state)
	-- I will check if the driver door is opened here and make the vehicle explode when the door is closed
	-- and i will add this in a random test so you will not expect it
end)

Event.Add("OnPlayerTeleport", function(player)
    print("player:", tostring(player) .. " teleported")
    print("health:", player:GetHealth())
end)

Event.Add("OnPlayerRagdollStart", function(player)
end)

Event.Add("OnPlayerRagdollEnd", function(player)
end)

Event.Add("OnVehicleNitrousUse", function(vehicle)
end)

Event.Add("OnVehicleTurboJump", function(vehicle)
end)

Event.Add("OnVehicleCollision", function(vehicle, position, normal, impulse)
	if impulse > 20000 then
		print(vehicle, position, normal, impulse)
	end
end)