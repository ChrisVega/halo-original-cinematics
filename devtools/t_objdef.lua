local ce = require("ce_map")
local m = ce.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map]])
local s = m:read_scenario()
for i, p in ipairs(s.bipeds) do
    local nm = s.object_names[p.name]
    local tag = s.biped_palette[p.type]
    if nm and (nm.name:find("cortana") or nm.name:find("keyes")) then
        print(string.format("biped[%d] name=%s palette=%d tag=%s pos=%.3f %.3f %.3f rot=%.3f %.3f %.3f",
            i, nm.name, p.type, tostring(tag), p.pos[1], p.pos[2], p.pos[3], p.rot[1], p.rot[2], p.rot[3]))
    end
end
print("--- cortana model tags in map ---")
for k, v in pairs(m.by_path) do
    if k:find("cortana") then print(k) end
end
