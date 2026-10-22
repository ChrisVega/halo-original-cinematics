local ce = require("ce_map"); local cs = require("ce_script")
local m = assert(ce.open(arg[1])); local s = cs.read(m)
local used, visited = {}, {}
local function walk(e)
  if type(e) ~= "table" then return end
  if e.fn then
    if s.scripts[e.fn] and not visited[e.fn] then visited[e.fn] = true; walk(s.scripts[e.fn].body) end
    used[e.fn] = (used[e.fn] or 0) + 1
    if e.fn == "wake" then local n = e.args[1] and (e.args[1].value or e.args[1].global); if n and s.scripts[n] and not visited[n] then visited[n] = true; walk(s.scripts[n].body) end end
    for _, a in ipairs(e.args) do walk(a) end
  end
end
walk(s.scripts["x10"].body)
local t = {}
for k, v in pairs(used) do if not s.scripts[k] then t[#t+1] = k .. "=" .. v end end
table.sort(t); print(table.concat(t, " "))
local snd = {}
local function sounds(e) if type(e)~="table" then return end; if e.fn == "sound_impulse_start" or e.fn == "sound_looping_start" then snd[#snd+1] = e.fn:sub(7,13) .. ":" .. tostring(e.args[1].value) end; if e.args then for _, a in ipairs(e.args) do sounds(a) end end end
for k in pairs(visited) do sounds(s.scripts[k].body) end
sounds(s.scripts["x10"].body)
table.sort(snd); print(#snd, table.concat(snd, " "))
