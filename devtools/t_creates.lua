local Scene = require("ce_scene")
local sc = Scene.load(arg[1], nil)
local tl = sc:timeline("x10")
local seen = {}
while tl:step() do
  for _, e in ipairs(tl:take_events()) do
    if e.type == "create" and not seen[e.name] then seen[e.name] = true; print(e.name, e.kind, e.tag) end
  end
end
