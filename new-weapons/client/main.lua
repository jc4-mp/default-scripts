local newWeaponsIds =
{
	838
}

Event.Add("ResourceStart", function(name)
	if name == Resource.Name then
		for k, v in pairs(newWeaponsIds) do
			Weapons.RegisterNew(v)
		end
	end
end)

Event.Add("ResourceStop", function(name)
	if name == Resource.Name then
		for k, v in pairs(newWeaponsIds) do
			Weapons.UnregisterNew(v)
		end
	end
end)