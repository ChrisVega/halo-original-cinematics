local Scene = require("ce_scene"); local S = require("ce_sound")
local snd = S.new(arg[2], arg[3], arg[4], arg[5])
local sc = Scene.load(arg[1], snd)
local names = sc:sounds_used("x10")
local n, missing = snd:prepare(names)
local ok = 0
for _, nm in ipairs(names) do if snd:playable(nm) then ok = ok + 1 end end
print("sounds", #names, "steps run", n, "playable", ok, "missing", table.concat(missing, ","))
