local newWeaponsIds =
{
	838
}

Event.Add("OnResourceStart", function(name)
	if name == Resource.Name then
		for k, v in pairs(newWeaponsIds) do
			Weapons.RegisterNew(v)
		end
	end
end)

Event.Add("OnResourceStop", function(name)
	if name == Resource.Name then
		for k, v in pairs(newWeaponsIds) do
			Weapons.UnregisterNew(v)
		end
	end
end)