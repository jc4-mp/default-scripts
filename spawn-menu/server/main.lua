Net.AddEvent("spawn", function(id, position)
    local veh1 = World.SpawnVehicle(id, position + vec3(0, 4, 0))

    veh1:SetPrimaryColor(math.random(), math.random(), math.random())
    veh1:SetSecondaryColor(math.random(), math.random(), math.random())
    veh1:SetTertiaryColor(math.random(), math.random(), math.random())
    veh1:SetMetallic(math.random(0.0, 100.0) / 100.0)
    
    --[[Net.Sender():GetNetPlayer():WarpIntoVehicle(veh1, VehicleSeat.DriverSeat)
    
    local veh2 = World.SpawnVehicle(id, position + vec3(4, 4, 0))

    veh2:SetPrimaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh2:SetSecondaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh2:SetTertiaryColor(math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0))
    veh2:SetMetallic(math.random(0.0, 100.0) / 100.0)]]
    
    --World.SpawnTether(Net.Sender():GetNetPlayer(), vec3(0.0, 1.0, 0.0), veh1, vec3(0.0, 2.0, 0.0))
    --World.SpawnTether(position - vec3(0.0, 1.0, 0.0), veh2, vec3(0.0, 2.0, 0.0))
    --World.SpawnTether(veh1, vec3(0.0, 2.0, 0.0), veh2, vec3(0.0, 0.0, 0.0))]]
    
    --[[local gayAnimal = World.SpawnNPC("domestic_pig", position + vec3(2, 0, 0))

    Timer.Set(function(player, animal)
        animal:Follow(player, MoveType.Run, MoveStyle.Normal)
    end, 1000, 1, Net.Sender():GetNetPlayer(), gayAnimal)]]

    --[[local ro = World.SpawnRigidObject(
        position + vec3(0, 0.5, 0),
        "models/environments/locale_global/glo_prop_metal_fence_a/glo_prop_metal_fence_a_debris_single_plate_01.modelc",
        "models/environments/locale_global/glo_prop_metal_fence_a/glo_prop_metal_fence_a_debris_single_plate_01_col.pfxc",
        RigidObjectMotionType.Static)]]

    --[[Timer.Set(function(rigidobject, newPos)
        rigidobject:SetPosition(newPos + vec3(0.0, 5.0, 0.0))
    end, 2500, 1, veh1, position)]]

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

Net.AddEvent("weapon", function(weapon_id)
    Net.Sender():GetPlayer():AsPlayer():GiveWeapon(weapon_id, 500, WeaponSlot.Primary)
end)