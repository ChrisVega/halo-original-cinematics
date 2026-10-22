local ce = require("ce_map"); local m = assert(ce.open(arg[1])); local s = m:read_scenario()
for _, n in ipairs({"player0_x10_base","keyes_deck","keyes_peer","cortana_face_keyes","space_walk_base"}) do local f=s.flags[n]; if f then print(n, f.pos[1]*304.8, -f.pos[2]*304.8, f.pos[3]*304.8, math.deg(f.facing[1])) else print(n,"missing") end end
