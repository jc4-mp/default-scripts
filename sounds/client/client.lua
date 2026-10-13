Event.Add("OnResourceStart", function(name)
	if Resource.Name == name then
        Sound.Create("ay", "test.wav")
	end
end)

Cmd.Add("ss", function()
    local channel = Sound.Play2D("ay", false)
    if not channel then
        return
    end

    channel:SetPaused(true)

    Timer.Set(function(ch)
        ch:SetPaused(false)
    end, 1000, 1, channel)
end)

Cmd.Add("ss2", function()
    local channel = Sound.Play3D("ay", World.LocalPlayer():AsPlayer():GetAimPosition(), false)
    if not channel then
        return
    end

    print(channel)
end)