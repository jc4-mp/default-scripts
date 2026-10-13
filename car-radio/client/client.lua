Event.Add("OnResourceStart", function(name)
	if Resource.Name == name then
        Sound.Create("car_song0", "song0.wav")
        Sound.Create("car_song1", "song1.wav")
	end
end)

local vehiclesSong = {}

Cmd.Add("song", function(id)
    local localPlayer = World.LocalPlayer()
    if localPlayer == nil then
        return
    end

    local vehicle = localPlayer:AsPlayer():GetVehicle()

    if vehicle ~= nil then
        Net.Send("playSong", vehicle, "car_song" .. tostring(id))
    end
end)

Net.AddEvent("playSong", function(vehicle, songName)
    if vehicle == nil then
        return
    end

    local position = vehicle:GetPosition()

    vehiclesSong[vehicle] = Sound.Play3D(songName, position, false)

    print(songName)
end)

Event.Add("OnUpdate", function()
    for k, v in pairs(vehiclesSong) do
        local position = k:GetPosition()

        if position ~= nil then
            v:Set3DAttributes(position, k:GetVelocity())
        else
            vehiclesSong[k] = nil
        end
    end
end)