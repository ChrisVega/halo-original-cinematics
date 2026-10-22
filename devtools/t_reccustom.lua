local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
local T = getmetatable(tl).__index
local orig = T.hs_recording_play
local function wrap(fn, label) return function(self, a)
  local o = self:obj(a[1].value or a[1].global)
  if o and o.custom then print(label, self.tick, o.name, "custom", o.custom.anim.name, "frame", o.custom.frame, "/", o.custom.anim.frame_count) end
  return fn(self, a) end end
T.hs_recording_play = wrap(T.hs_recording_play, "play")
T.hs_recording_play_and_delete = wrap(T.hs_recording_play_and_delete, "play_del")
while tl:step() and tl.tick <= 2100 do tl:take_events() end
