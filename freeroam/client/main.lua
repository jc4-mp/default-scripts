Event.Add("OnResourceStart", function(name)
	if Resource.Name == name then
		Local.UnlockAbility(Ability.GrapplingHook)
		Local.LockAbility(Ability.Tether)
		Local.UnlockAbility(Ability.Parachute)
		Local.UnlockAbility(Ability.Wingsuit)
		Local.UnlockAbility(Ability.Hammer)
		Local.UnlockAbility(Ability.ExitVehicle)
		Local.UnlockAbility(Ability.Tether)
		Local.UnlockAbility(Ability.RetractTether)
		Local.UnlockAbility(Ability.ParachuteSlingshot)

		Players.SetTagsEnabled(true)
		World.SetTime(8)
		Local.SetHoverboardEnabled(true)
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
	if key == Key.F then
		local player = World.LocalPlayer():AsPlayer()

		player:GoRagdoll()
	--elseif key == Key.X then
		--Net.Send("explosion", World.LocalPlayer():AsPlayer():GetAimPosition())
	end
end)

Cmd.Add("lmao", function()
    Net.Send("lmao1", World.LocalPlayer():AsPlayer():GetAimPosition())
end)

Cmd.Add("alltp", function()
    Net.Send("alltp", World.LocalPlayer():AsPlayer():GetAimPosition())
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
	--[[local camPos = Camera.GetPosition()
	local aimPos = player:GetAimPosition()
	local delta = aimPos - camPos
	local dir = delta:normalize()
	local ray = Physics.Raycast(camPos, camPos + dir * 1000.0, PfxLayer.FullCollision)

	print(ray.hasHit)

	if ray.hasHit then
		print(ray.normal, ray.hitPos, ray.hitDistance, ray.gameObject, ray.netObject:AsVehicle(), ray.netObject:AsRigidObject())
	end]]
end)

local ro = nil
local fx = nil

Cmd.Add("tt", function()
    --[[ro = World.SpawnRigidObject(
        World.LocalPlayer():AsPlayer():GetAimPosition() + vec3(0, 1, 0),
        "models/characters/animals/birds/toucan/toucan_red_body.modelc",
        "models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_b1_col.pfxc",
        RigidObjectMotionType.Static)]]

	print(World.LocalPlayer():AsPlayer():GetAimPosition())
end)

Event.Add("OnPlayerRagdollEnd", function(player)
end)

--[[Event.Add("OnVehicleCollision", function(vehicle, position, normal, impulse)
	if impulse > 20000 then
		print(vehicle, position, normal, impulse)
	end
end)]]

Event.Add("OnVehicleHornPlay", function(vehicle)
	print("play")
end)

Event.Add("OnVehicleHornStop", function(vehicle)
	print("stop")
end)

Event.Add("OnPlayerKilled", function(player, damager, loss, weapon, position)
	print("DEATH", position, player, loss)
end)