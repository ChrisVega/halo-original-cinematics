-- Runs the real main.lua against the mock game for the whole opening.
MOCK_LAB_LOG = arg[1]
local M = require("mock_ue")
local real_getenv = os.getenv
dofile(arg[2])  -- main.lua
-- run setup loop until ready, then drive the director at 60 fps of mock time
for _ = 1, 3 do for _, fn in ipairs(M.loops) do pcall(fn) end end
local frames = 0
while M.time < 260 do
  M.time = M.time + 1 / 60
  for _, fn in ipairs(M.loops) do fn() end
  frames = frames + 1
end
print("frames", frames, "bone sets", M.bones or 0)
for i = 1, math.min(#M.calls, 12) do print(M.calls[i]) end
print("total calls logged", #M.calls)
