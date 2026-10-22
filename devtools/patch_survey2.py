BS=chr(92)
p='mod/OriginalCinematics/Scripts/ue_stage.lua'
s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
# scan starts under the ceiling (341+ cm), not above it
old='{ X = x, Y = y, Z = 230 }, { X = x, Y = y, Z = -450 }'
assert s.count(old)==1; s=s.replace(old,'{ X = x, Y = y, Z = 200 }, { X = x, Y = y, Z = -450 }')
# shot line: on every cut, what lies between the camera and Keyes
old2='    pcall(self._aim, self, pos, rot, c, ch, cc)'
assert s.count(old2)==1
new2=old2+nl+'''    if self.shot_line_in then
        self.shot_line_in = self.shot_line_in - 1
        if self.shot_line_in == 0 then pcall(self._shot_line, self, pos) end
    end'''.replace('\n',nl)
s=s.replace(old2,new2)
old3='        self.aim_fix = nil'+nl
assert s.count(old3)==1
s=s.replace(old3, old3+'        self.shot_line_in = 3'+nl)
anchor='-- Survey (once per scene)'
fn='''-- Shot line (survey): a few frames after every cut, what the remake has
-- between the camera and our Keyes (head and hips), by line trace: the mesh,
-- and how far from the camera. Ours are ignored.
function Stage:_shot_line(pos)
    local k = kismet()
    if not k then return end
    local keyes
    for _, r in pairs(self.reps) do
        if r.row and r.row.id == "keyes" and r.body then keyes = r end
    end
    if not keyes then return end
    local ignore = {}
    for _, r in pairs(self.reps) do
        local live = false
        pcall(function() live = r.actor:IsValid() end)
        if live then ignore[#ignore + 1] = r.actor end
    end
    local col = { R = 0, G = 0, B = 0, A = 0 }
    local parts = {}
    for _, bn in ipairs({ "Head_M", "Root_M" }) do
        local t = keyes.body:GetBoneTransformByName(FName(bn), 0).Translation
        local tx, ty, tz = tonumber(t.X), tonumber(t.Y), tonumber(t.Z)
        local d = math.sqrt((tx - pos.X) ^ 2 + (ty - pos.Y) ^ 2 + (tz - pos.Z) ^ 2)
        local out = {}
        local hit = k:LineTraceSingle(self.pc, { X = pos.X, Y = pos.Y, Z = pos.Z }, { X = tx, Y = ty, Z = tz }, 0, false, ignore, 0, out, true, col, col, 0)
        if hit then
            local m, hx, hy, hz = "?", 0, 0, 0
            pcall(function() local c = out.Component:Get(); m = c:GetFName():ToString(); pcall(function() m = c.StaticMesh:GetFName():ToString() end) end)
            pcall(function() hx, hy, hz = tonumber(out.Location.X), tonumber(out.Location.Y), tonumber(out.Location.Z) end)
            parts[#parts + 1] = string.format("%s BLOCKED by %s at (%.0f,%.0f,%.0f), %.0f of %.0f cm", bn, m, hx, hy, hz,
                math.sqrt((hx - pos.X) ^ 2 + (hy - pos.Y) ^ 2 + (hz - pos.Z) ^ 2), d)
        else
            parts[#parts + 1] = string.format("%s clear (%.0f cm)", bn, d)
        end
    end
    self.log("shot line from (%.0f,%.0f,%.0f): %s", pos.X, pos.Y, pos.Z, table.concat(parts, "; "))
end

'''
s=s.replace(anchor, fn.replace('\n',nl)+anchor)
open(p,'wb').write(s.encode('utf-8'))
# survey later, once the bridge's collision has streamed in (5 s in)
p='mod/OriginalCinematics/Scripts/director.lua'
s=open(p,'rb').read().decode('utf-8')
old='    local sok, serr = pcall(stage.survey, stage)'+nl+'    if not sok then log("survey failed: %s", tostring(serr)) end'+nl
assert s.count(old)==1; s=s.replace(old,'')
old='            a.ticks = a.ticks + 1; guard = guard + 1'+nl
assert s.count(old)==1
s=s.replace(old, old+'''            -- the bridge's collision streams in after the takeover: survey 5 s in
            if a.ticks == 150 then
                local sok, serr = pcall(a.stage.survey, a.stage)
                if not sok then self.ctx.log("survey failed: %s", tostring(serr)) end
            end
'''.replace('\n',nl))
open(p,'wb').write(s.encode('utf-8'))
