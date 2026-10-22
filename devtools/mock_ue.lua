-- A stand-in for the UE4SS Lua API so the mod's game-side code can run offline.
-- Every object answers any method with another stub; a few return real data.
local M = { calls = {}, time = 0 }
local rest = {}
for line in io.lines(MOCK_LAB_LOG) do
  local name, x, y, z, qx, qy, qz, qw = line:match("bone %d+ (%S+) parent=%S+ pos=%(([%-%d%.]+) ([%-%d%.]+) ([%-%d%.]+)%) q=%(([%-%d%.]+) ([%-%d%.]+) ([%-%d%.]+) ([%-%d%.]+)%)")
  if name and not rest[name] then rest[#rest + 1] = name; rest[name] = { tonumber(x), tonumber(y), tonumber(z), tonumber(qx), tonumber(qy), tonumber(qz), tonumber(qw) } end
end

local Stub = {}
local function stub(name) return setmetatable({ _name = name or "stub" }, Stub) end
local count = 0
Stub.__index = function(self, k)
  local special = {
    IsValid = function() return true end,
    GetFName = function() return { ToString = function() return self._name end } end,
    GetFullName = function() return "Stub " .. self._name end,
    GetNumBones = function() return #rest end,
    GetBoneName = function(_, i) return { ToString = function() return rest[i + 1] end } end,
    GetBoneTransformByName = function(_, fname)
      local r = rest[fname._s] or { 0, 0, 0, 0, 0, 0, 1 }
      return { Translation = { X = r[1], Y = r[2], Z = r[3] }, Rotation = { X = r[4], Y = r[5], Z = r[6], W = r[7] } }
    end,
    IsPlaying = function() return self._playing or false end,
    GetUrl = function() return { ToString = function() return self._url or "" end } end,
    GetRealTimeSeconds = function() return M.time end,
    GetViewTarget = function() return M.viewtarget end,
    SetViewTargetWithBlend = function(_, a) M.viewtarget = a end,
    SpawnActor = function(_, c, loc) count = count + 1; return stub("Actor" .. count) end,
    AddComponentByClass = function() count = count + 1; return stub("Comp" .. count) end,
    OpenUrl = function(_, url) M.calls[#M.calls + 1] = "OpenUrl " .. url; return true end,
    CreateMeshSection_LinearColor = function(_, ...) local n = select("#", ...); assert(n == 12, "CreateMeshSection args " .. n) end,
    SetBoneRotationByName = function(_, f, r, s) assert(r.Pitch and r.Yaw and r.Roll, "bad rotator"); M.bones = (M.bones or 0) + 1 end,
    StartCameraFade = function(_, a, b) M.calls[#M.calls + 1] = string.format("fade %s->%s", a, b) end,
  }
  if special[k] then return special[k] end
  if k == "SequencePlayer" then return M.seqplayer end
  if k == "LevelSequenceAsset" then return stub("LS_m01_POA-cin01_sc01_heroic") end
  if k == "PlayerCameraManager" or k == "CameraComponent" then return stub(k) end
  return function() return stub(k) end
end
Stub.__newindex = function(self, k, v) rawset(self, k, v) end

M.seqplayer = stub("SequencePlayer"); M.seqplayer._playing = true
local seqactor = stub("LSA")
_G.FName = function(s) return { _s = s, ToString = function() return s end } end
_G.StaticFindObject = function(p) return stub(p:match("[^%.]+$")) end
_G.FindFirstOf = function(c) return stub(c) end
_G.FindAllOf = function(c) if c == "LevelSequenceActor" then return { seqactor } end; return {} end
_G.LoadAsset = function(p) return stub(p) end
_G.StaticConstructObject = function() return stub("MediaPlayer") end
local loops = {}
_G.LoopAsync = function(ms, fn) loops[#loops + 1] = fn end
_G.ExecuteInGameThread = function(fn) fn() end
M.loops = loops
return M
