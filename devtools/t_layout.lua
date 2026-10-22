local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local map = sc.map
local function bit(flags, n) local w = flags[(n // 32) + 1] or 0; return (w >> (n % 32)) & 1 == 1 end
local function qn(s, o) local x,y,z,w = string.unpack("<i2i2i2i2", s, o); local k=1/32767; return math.sqrt((x*k)^2+(y*k)^2+(z*k)^2+(w*k)^2) end
local function score(a, blob, which, grouped)
  -- which: "frame" uses flags set; "default" uses flags clear
  local sel = function(f, n) local b = bit(f, n); if which == "default" then return not b end return b end
  local nodes = a.node_count
  local per = 0
  for n = 0, nodes-1 do if sel(a.rot_flags,n) then per=per+8 end if sel(a.trans_flags,n) then per=per+12 end if sel(a.scale_flags,n) then per=per+4 end end
  local count = which == "default" and 1 or a.frame_count
  local bad, tot, maxp = 0, 0, 0
  local p = 1
  for f = 0, count-1 do
    if grouped then
      for n = 0, nodes-1 do if sel(a.rot_flags,n) then local l=qn(blob,p); tot=tot+1; if math.abs(l-1)>0.02 then bad=bad+1 end; p=p+8 end end
      for n = 0, nodes-1 do if sel(a.trans_flags,n) then for k=0,2 do local v=math.abs(string.unpack("<f",blob,p+k*4)); if v~=v or v>maxp then maxp=v end end; p=p+12 end end
      for n = 0, nodes-1 do if sel(a.scale_flags,n) then p=p+4 end end
    else
      for n = 0, nodes-1 do
        if sel(a.rot_flags,n) then local l=qn(blob,p); tot=tot+1; if math.abs(l-1)>0.02 then bad=bad+1 end; p=p+8 end
        if sel(a.trans_flags,n) then for k=0,2 do local v=math.abs(string.unpack("<f",blob,p+k*4)); if v~=v or v>maxp then maxp=v end end; p=p+12 end
        if sel(a.scale_flags,n) then p=p+4 end
      end
    end
  end
  return string.format("bad %d/%d maxp %.3g", bad, tot, maxp)
end
local g = sc:graph([[characters\marine\marine]])
for _, name in ipairs({"stand pistol move-front", "stand pistol aim-still", "stand pistol idle", "pchair-driver unarmed idle%0", "stand pistol turn-left", "stand pistol move-back", "pilot_fidget01"}) do
  local a = g.by_name[name]
  local dd, fd = map:data(a.ptr + 140), map:data(a.ptr + 160)
  print(name, "| default interleaved:", score(a, dd, "default", false), "grouped:", score(a, dd, "default", true), "| frames interleaved:", score(a, fd, "frame", false), "grouped:", score(a, fd, "frame", true))
end
