local ce = require("ce_map"); local A = require("ce_anim")
local m = assert(ce.open(arg[1]))
local g = A.read_graph(m, m.by_path[ [[cinematics\animations\captain\x10\x10.antr]] ])
local a = g.by_name["how_did_they"]
local size, ext, foff, ptr = string.unpack("<I4I4I4I4", m.tag_data, m:ofs(a.ptr + 160))
local dsize = string.unpack("<I4", m.tag_data, m:ofs(a.ptr + 140))
print("frame data size", size, "external", ext, "fileoff", foff, "ptr", string.format("%x", ptr), "default size", dsize, "comp off", a.compressed_offset)
local fd = m:data(a.ptr + 160)
print(#fd, string.format("%q", fd:sub(1, 48)))
local fr = A.decode(m, a)
for _, f in ipairs({0, 30, 60, 90, 120, 183}) do
  local s = {}
  for _, n in ipairs({0, 2, 10, 20}) do local q = fr[f][n].rot; s[#s+1] = string.format("%s:(%.2f %.2f %.2f %.2f)", g.nodes[n].name, q[1], q[2], q[3], q[4]) end
  print(f, table.concat(s, " "))
end
print("root pos", fr[0][0].pos[1], fr[183][0].pos[1])
