Net.AddEvent("spawn", function(id, position)
    local veh1 = World.SpawnVehicle(id, position + vec3(0, 4, 0))

    veh1:SetPrimaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh1:SetSecondaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh1:SetTertiaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh1:SetMetallic(math.random(0.0, 100.0) / 100.0)
    
    --[[local veh2 = World.SpawnVehicle(id, position + vec3(4, 4, 0))

    veh2:SetPrimaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh2:SetSecondaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh2:SetTertiaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh2:SetMetallic(math.random(0.0, 100.0) / 100.0)]]

   --Timer.Set(function(player, vehicle2)
        Net.Sender():GetNetPlayer():WarpIntoVehicle(veh1, VehicleSeat.DriverSeat)
   -- end, 250, 1, Net.Sender():GetNetPlayer(), veh2)
    
    --World.SpawnTether(Net.Sender():GetNetPlayer(), vec3(0.0, 1.0, 0.0), veh2, vec3(0.0, 2.0, 0.0))
    --World.SpawnTether(position - vec3(0.0, 1.0, 0.0), veh2, vec3(0.0, 2.0, 0.0))
    --World.SpawnTether(veh1, vec3(0.0, 2.0, 0.0), veh2, vec3(0.0, 0.0, 0.0))]]
    
    --[[local gayAnimal = World.SpawnNPC("domestic_pig", position + vec3(2, 0, 0))

    Timer.Set(function(player, animal)
        animal:Follow(player, MoveType.Run, MoveStyle.Normal)
    end, 1000, 1, Net.Sender():GetNetPlayer(), gayAnimal)]]

    --[[local ro = World.SpawnRigidObject(
        position + vec3(0, 1, 0),
        "models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_b1.modelc",
        "models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_b1_col.pfxc",
        RigidObjectMotionType.Static)]]

    --[[Timer.Set(function(obj)
        print(obj:GetPfx(), obj:GetModel())
        obj:SetAngularVelocity(vec3(0, 100, 0))
    end, 2000, 1, ro)]]
    
    --[[veh:SetPartState(VehiclePart.FrontLeft, VehiclePartState.Open)
    veh:SetPartState(VehiclePart.FrontRight, VehiclePartState.Open)
    veh:SetPartState(VehiclePart.Trunk, VehiclePartState.Open)
    veh:SetPartState(VehiclePart.Hood, VehiclePartState.Open)
    veh:SetPartState(VehiclePart.RearLeft, VehiclePartState.Open)
    veh:SetPartState(VehiclePart.RearRight, VehiclePartState.Open)]]
end)

Net.AddEvent("spawnMg", function(id, position)
    World.SpawnMountedGun(id, position)
end)

Net.AddEvent("weapon", function(weapon_id, player)
    player:GetNetPlayer():GiveWeapon(weapon_id, 500, WeaponSlot.Primary)
end)

Event.Add("OnPreTick", function()
    for k, v in pairs(Players.GetJoined()) do
        local player = v:GetNetPlayer()
    end
end)