Cmd.Add("derby", function()
    Net.Send("Derby:StartRequest", {})
end) 

function lockAllAbilities()
    for _, ability in pairs(Ability) do
        Local.LockAbility(ability)
    end
end

function unlockAllAbilities()
    for _, ability in pairs(Ability) do
        Local.UnlockAbility(ability)
    end
end

Net.AddEvent("Derby:DisableAbilities", function()
    lockAllAbilities()
end)

Net.AddEvent("Derby:EnableAbilities", function()
    unlockAllAbilities()
end)