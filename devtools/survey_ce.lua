-- Every object the original places on the bridge (named or not), in CE world units.
local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local s = sc:timeline("bridge,hangar_cryo").d.scenario
local keys = {}
for k, v in pairs(s) do if type(v) == "table" then keys[#keys + 1] = k end end
table.sort(keys); print("scenario lists: " .. table.concat(keys, " "))
for _, kind in ipairs({ "scenery", "vehicles", "bipeds", "machines", "controls", "equipment" }) do
  local list = s[kind]
  local pal = s[(kind:gsub("s$", "")) .. "_palette"] or s[kind .. "_palette"] or (kind == "scenery" and s.scenery_palette) or {}
  if list then
    for i, p in pairs(list) do
      local x, y, z = p.pos[1], p.pos[2], p.pos[3]
      if x > -6 and x < 5 and y > -4.5 and y < 4.5 and z > -1.5 and z < 2 then
        local nm = p.name and s.object_names and s.object_names[p.name]
        print(string.format("CE\t%s\t%s\t%s\t%.3f\t%.3f\t%.3f\t%.1f", kind, nm and nm.name or "-", tostring(pal[p.type]),
          x, y, z, math.deg(p.rot and p.rot[1] or 0)))
      end
    end
  end
end
