Event.Add("OnResourceStart", function(name)
	if Resource.Name == name then
        Sound.Create("ay", "test.wav")
	end
end)

Cmd.Add("ss", function()
    local channel = Sound.Play2D("ay", false)

    channel:SetPaused(true)

    Timer.Set(function(ch)
        ch:SetPaused(false)
    end, 1000, 1, channel)
end)

Cmd.Add("ss2", function()
    print(Sound.Play3D("ay", Players.LocalPlayer():GetAimPosition(), false))
end)