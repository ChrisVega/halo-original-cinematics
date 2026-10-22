local CM = require("ce_model")
local ce = require("ce_map")
local m = ce.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map]])
for _, path in ipairs({ "characters\\captain\\captain.mod2", "characters\\cortana\\cortana.mod2" }) do
    local tag = m.by_path[path]
    local model = CM.read(m, tag, 4)
    print("=== " .. path)
    for i, n in ipairs(model.nodes) do
        if i <= 6 then
            print(string.format("  node %d %-18s parent=%d pos=%.3f %.3f %.3f", i, n.name, n.parent, n.pos[1], n.pos[2], n.pos[3]))
        end
    end
end
