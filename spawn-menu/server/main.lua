Net.AddEvent("spawn", function(id, position)
    local veh = World.SpawnVehicle(id, position)

    veh:SetPrimaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetSecondaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetTertiaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh:SetMetallic(math.random(0.0, 100.0) / 100.0)

   Timer.Set(function(player, vehicle)
        player:WarpIntoVehicle(vehicle, VehicleSeat.DriverSeat)
    end, 250, 1, Net.Sender():GetNetPlayer(), veh)

    --[[local ro = World.SpawnRigidObject(
        position + vec3(math.random(0, 5), math.random(0, 5), math.random(0, 5)),
        "models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_b1.modelc",
        "models/environments/locale_global/mil_prop_barrel_a/mil_prop_barrel_a_barrel_b1_col.pfxc")]]

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