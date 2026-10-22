local ce = require("ce_map"); local R = require("ce_recording")
local m = assert(ce.open(arg[1])); local s = m:read_scenario()
for _, n in ipairs({"keyes_look_1","keyes_walk_1"}) do
  local r = R.new(s.recordings[n]); print(n, r.length)
  local t = 0
  while not r.done do local c = r:step(); t = t + 1
    if t % 30 == 1 then print(t, c.animation_state, string.format("thr=%.2f,%.2f face=%.2f,%.2f", c.throttle[1], c.throttle[2], c.facing[1], c.facing[2])) end end
end
