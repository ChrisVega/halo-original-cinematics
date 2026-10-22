-- Meshes around a point: nearest 40 static meshes and the extent of geometry near it.
local cx, cy, cz, R = -500, 0, 0, 3000
local list = {}
local minx, maxx, miny, maxy, minz, maxz = 1e9, -1e9, 1e9, -1e9, 1e9, -1e9
for _, c in ipairs(FindAllOf("StaticMeshComponent") or {}) do
    local l = c:K2_GetComponentLocation()
    local dx, dy, dz = l.X - cx, l.Y - cy, l.Z - cz
    local d = math.sqrt(dx * dx + dy * dy + dz * dz)
    if d < R and not (l.X == 0 and l.Y == 0 and l.Z == 0) then
        local ok, mesh = pcall(function() return c.StaticMesh end)
        local mn = ok and mesh and mesh:IsValid() and mesh:GetFName():ToString() or "?"
        list[#list + 1] = { d = d, s = string.format("%-55s %.0f %.0f %.0f", mn, l.X, l.Y, l.Z) }
        minx, maxx = math.min(minx, l.X), math.max(maxx, l.X)
        miny, maxy = math.min(miny, l.Y), math.max(maxy, l.Y)
        minz, maxz = math.min(minz, l.Z), math.max(maxz, l.Z)
    end
end
table.sort(list, function(a, b) return a.d < b.d end)
for i = 1, math.min(#list, 45) do print(list[i].s) end
return string.format("%d meshes; x %.0f..%.0f y %.0f..%.0f z %.0f..%.0f", #list, minx, maxx, miny, maxy, minz, maxz)
