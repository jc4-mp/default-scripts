local coolKillMsgs =
{
	"rekt",
	"destroyed",
	"raped",
	"owned",
	"obliterated",
	"annihilated",
	"demolished",
	"slaughtered",
	"murdered",
	"assassinated",
	"executed",
	"terminated",
	"crushed",
	"decimated",
}

local suicideMsgs =
{
    "%s just lost a 1v0.",
    "%s was no match for their own stupidity.",
    "%s ragequit life.",
    "%s pressed the wrong button... fatally.",
    "%s tried to be a hero. Failed at living.",
    "%s thought they could fly.",
    "%s eliminated themselves. Efficiency?",
    "%s was outplayed by physics.",
    "%s has achieved peak embarrassment.",
    "%s discovered a new way to fail.",
    "%s forgot how explosives work.",
    "%s skipped the tutorial... and life.",
    "%s just gave everyone a free laugh.",
    "%s self-deleted. Impressive.",
}

local function getName(player)
	local client = player:GetClient()

	return client and client:GetName() or "?"
end

Event.Add("OnPlayerKilled", function(player, damager, loss, weapon, position)
	local playerDamager = damager and damager:AsPlayer() or nil

    if playerDamager and player ~= playerDamager then
		Chat.Print(getName(playerDamager) .. " " .. coolKillMsgs[math.random(1, #coolKillMsgs)] .. " " .. getName(player))
    else
        Chat.Print(string.format(suicideMsgs[math.random(1, #suicideMsgs)], getName(player)))
    end
end)

Cmd.Add("p", function()
	print(World.LocalPlayer():GetPosition() + vec3(0, 1, 0))
end)

Event.Add("OnResourceStart", function(name)
	if Resource.Name == name then
		Local.UnlockAbility(Ability.Parachute)
		Local.UnlockAbility(Ability.Wingsuit)
		Local.UnlockAbility(Ability.Hammer)
		Local.UnlockAbility(Ability.ExitVehicle)
	end
end)

Event.Add("OnResourceStop", function(name)
	if Resource.Name == name then
		Local.LockAbility(Ability.Parachute)
		Local.LockAbility(Ability.Wingsuit)
		Local.LockAbility(Ability.Hammer)
		Local.LockAbility(Ability.ExitVehicle)
	end
end)