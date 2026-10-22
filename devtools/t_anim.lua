local ce = require("ce_map"); local A = require("ce_anim")
local m = assert(ce.open(arg[1]))
for _, path in ipairs({[[cinematics\animations\captain\x10\x10.antr]], [[characters\captain\captain.antr]], [[characters\cortana\cortana.antr]]}) do
  local t = m.by_path[path]
  if not t then print("missing", path) else
    local g = A.read_graph(m, t)
    local n = 0; for _ in pairs(g.nodes) do n = n + 1 end
    print(path, "nodes", n, "anims", #g.animations + 1)
    for i = 0, math.min(#g.animations, 8) do local a = g.animations[i]; print("  ", a.name, a.frame_count, a.node_count, a.compressed and "COMPRESSED" or "raw", a.frame_size) end
    local a = g.by_name["how_did_they"] or g.animations[0]
    local fr, err = A.decode(m, a); print("  decode", a.name, fr and "ok" or err, fr and fr[0][0].rot[4])
  end
end
