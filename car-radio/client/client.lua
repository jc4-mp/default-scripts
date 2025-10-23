Event.Add("OnResourceStart", function(name)
	if Resource.Name == name then
        Sound.Create("car_song0", "song0.wav")
        Sound.Create("car_song1", "song1.wav")
	end
end)

local vehiclesSong = {}

Cmd.Add("song", function(id)
    local localPlayer = Players.LocalPlayer()
    local vehicle = localPlayer:GetVehicle()

    if vehicle ~= nil then
        Net.Send("playSong", vehicle, "car_song" .. tostring(id))
    end
end)

Net.AddEvent("playSong", function(vehicle, songName)
    local position = vehicle:GetPosition()

    vehiclesSong[vehicle] = Sound.Play3D(songName, position, false)

    print(songName)
end)

Event.Add("OnUpdate", function()
    for k, v in pairs(vehiclesSong) do
        if k ~= nil then
            v:Set3DAttributes(k:GetPosition(), k:GetVelocity())
        end
    end
end)