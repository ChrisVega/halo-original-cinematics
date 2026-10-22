-- Halo: Campaign Evolved (Steam, UE 5.5): the hash-table getter is reached through
-- the first call inside a small object-hash helper; decode that rel32 call target.
function Register()
    return "48 89 5C 24 08 57 48 83 EC 20 48 8B D9 E8 ?? ?? ?? ?? 48 8B C8 48 8D 53 F8 E8 ?? ?? ?? ?? 48 8B 4B 08 48 85 C9"
end

function OnMatchFound(MatchAddress)
    local call = MatchAddress + 0xD
    return call + 5 + DerefToInt32(call + 1)
end
