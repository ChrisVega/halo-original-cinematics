local ce = require("ce_map")
local m = ce.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map]])
for _, path in ipairs({ "characters\\cortana\\cortana.mod2", "characters\\captain\\captain.mod2" }) do
    local tag = m.by_path[path]
    local base = tag.data
    print("=== " .. path)
    for i, p in m:each(base + 184, 156) do
        if i <= 4 then
            local name = m:str32(p)
            local sc = m:f32(p + 68)
            local x, y, z = m:f32(p + 40), m:f32(p + 44), m:f32(p + 48)
            print(string.format("  node %d %-18s pos=%.3f %.3f %.3f scale=%.4f", i, name, x, y, z, sc))
        end
    end
end
