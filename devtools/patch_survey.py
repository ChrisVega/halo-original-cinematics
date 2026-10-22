p='mod/OriginalCinematics/Scripts/ue_stage.lua'
s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
i=s.index('-- Survey (once per scene)'); j=s.index("-- The remake places its own Keyes on the bridge at the original's spot; ours")
BS=chr(92)
fn='''-- Survey (once per scene): a scan of the remake's bridge by line traces only
-- (reading mesh components directly crashed the game in 0.2.80). Straight down
-- every 50 cm over the bridge: the height and the name of what is hit (floor,
-- chair, console), to find the remake's chairs and floors and fit them against
-- the original's (devtools/fit_bridge.py). Written to
-- %LOCALAPPDATA%/OriginalCinematics/survey_remake.tsv.
function Stage:survey()
    local k = kismet()
    if not k then return end
    local path = (os.getenv("LOCALAPPDATA") or ".") .. "/OriginalCinematics/survey_remake.tsv"
    local f = io.open(path, "wb")
    if not f then return end
    local ignore = {}
    for _, a in ipairs(self.actors or {}) do
        local live = false
        pcall(function() live = a:IsValid() end)
        if live then ignore[#ignore + 1] = a end
    end
    local col = { R = 0, G = 0, B = 0, A = 0 }
    local g = 0
    for x = -2200, 1700, 50 do
        for y = -1600, 1600, 50 do
            local out = {}
            local ok, hit = pcall(function()
                return k:LineTraceSingle(self.pc, { X = x, Y = y, Z = 230 }, { X = x, Y = y, Z = -450 }, 0, false, ignore, 0, out, true, col, col, 0)
            end)
            if ok and hit then
                local z, cname, mname = 0, "?", "?"
                pcall(function() z = tonumber(out.Location.Z) or 0 end)
                pcall(function()
                    local c = out.Component:Get()
                    cname = c:GetFName():ToString()
                    pcall(function() mname = c.StaticMesh:GetFName():ToString() end)
                end)
                f:write(string.format("HIT@t%d@t%d@t%.1f@t%s@t%s@n", x, y, z, mname, cname))
                g = g + 1
            end
        end
    end
    f:close()
    self.log("survey: %d trace hits -> %s", g, path)
end

'''.replace('@', BS)
s=s[:i]+fn.replace('\n',nl)+s[j:]
open(p,'wb').write(s.encode('utf-8'))
