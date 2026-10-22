-- Where is the remake's bridge? List mesh components whose mesh or owner name
-- mentions the bridge, with their world positions, plus the player's position.
local pc = FindFirstOf("PlayerController")
local pawn = pc and pc.Pawn
if pawn and pawn:IsValid() then
    local l = pawn:K2_GetActorLocation()
    print(string.format("player %.0f %.0f %.0f", l.X, l.Y, l.Z))
end
local seen, n = {}, 0
for _, c in ipairs(FindAllOf("StaticMeshComponent") or {}) do
    local ok, mesh = pcall(function() return c.StaticMesh end)
    local mn = ok and mesh and mesh:IsValid() and mesh:GetFName():ToString() or ""
    local owner = c:GetOwner()
    local on = owner and owner:IsValid() and owner:GetFName():ToString() or ""
    local key = (mn .. on):lower()
    if key:find("bridge") or key:find("captain") or key:find("helm") or key:find("holo") then
        local l = c:K2_GetComponentLocation()
        local k = mn .. string.format("%d%d", math.floor(l.X / 500), math.floor(l.Y / 500))
        if not seen[k] then
            seen[k] = true; n = n + 1
            if n <= 60 then print(string.format("%-50s %-40s %.0f %.0f %.0f", mn, on, l.X, l.Y, l.Z)) end
        end
    end
end
local total = #(FindAllOf("StaticMeshComponent") or {})
return "matches " .. n .. " of " .. total
