local water = nil

Event.Add("OnKeyDown", function(key)
	if Chat.IsTyping() or not World.LocalPlayer() then return end

	if key == Key.M then
		Net.Send("spawnTornado", World.LocalPlayer():AsPlayer():GetAimPosition())
	end

	if key == Key.K then
		Net.Send("despawnTornado")
	end

	if key == Key.N then
		Net.Send("setTornadoPos", World.LocalPlayer():AsPlayer():GetAimPosition())
	end

	if key == Key.J then
		--Net.Send("setSandstorm", World.LocalPlayer():AsPlayer():GetAimPosition())
		if water then
			water:Destroy()
			water = nil
		else
			water = World.SpawnWaterBox(World.LocalPlayer():AsPlayer():GetAimPosition(), vec3(10, 5, 10), 1)
		end
	end
end)