import json
p='sheets/scenes.json'; d=json.load(open(p,encoding='utf-8'))
r=d['rows'][0]; c=d['columns']
r[c.index('skip_objects')]=None
panic=["x10_crew_panic_1","x10_crew_panic_2","x10_crew_panic_3","x10_crew_panic_4","x10_crew_panic_5","x10_crew_panic_6"]
if 'walk_off' not in c: c.append('walk_off'); r.append(None)
r[c.index('walk_off')]={"objects":panic,"until":"keyes_to_cortana_2"}
d['about']+=" walk_off: these objects are not deleted when the script deletes them (on camera in the remake): they keep walking straight ahead, and all go at the cut to 'until' (creator's call: removed at Keyes' eye close-up)."
json.dump(d,open(p,'w',encoding='utf-8',newline='\n'),indent=2,ensure_ascii=False)
def patch(p,pairs):
    s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
    for old,new in pairs:
        old=old.replace('\n',nl); new=new.replace('\n',nl); assert s.count(old)==1,old; s=s.replace(old,new)
    open(p,'wb').write(s.encode('utf-8'))
patch('mod/OriginalCinematics/Scripts/ce_timeline.lua',[
("""function T:destroy(name)
    name = lower(name)
    if self.objects[name] then""",
"""function T:destroy(name, force)
    name = lower(name)
    -- walk_off (scenes sheet): deleted in the original off camera, on camera
    -- in the remake; it keeps walking straight ahead instead, until the cut
    local wo = self.walk_off
    if not force and wo and self.objects[name] then
        for _, n in ipairs(wo.objects or {}) do
            if n == name then
                local o = self.objects[name]
                o.rec, o.custom, o.walk_on = nil, nil, true
                return
            end
        end
    end
    if self.objects[name] then"""),
("""    local a, ag = self:base_anim(o, moving)
    if o.base.anim ~= a then""",
"""    if o.walk_on then
        moving = true
        local wa = self:base_anim(o, true)
        local speed = 0.5 / 32
        if wa and wa.frame_count > 0 then
            local sx = 0
            for f = 0, wa.frame_count - 1 do sx = sx + (frame_info(self.d.map, wa, f)) end
            if sx > 0 then speed = sx / wa.frame_count end
        end
        self:_move_local(o, speed, 0)
    end
    local a, ag = self:base_anim(o, moving)
    if o.base.anim ~= a then"""),
("""    local pos = p.pos
    -- shot_adjust""",
"""    if self.walk_off and point_name == self.walk_off["until"] then
        for n, o in pairs(self.objects) do
            if o.walk_on then self:destroy(n, true) end
        end
    end
    local pos = p.pos
    -- shot_adjust"""),
])
patch('mod/OriginalCinematics/Scripts/director.lua',[(
"    tl.shot_adjust, tl.chain_ease = row.shot_adjust, row.chain_ease",
"    tl.shot_adjust, tl.chain_ease, tl.walk_off = row.shot_adjust, row.chain_ease, row.walk_off")])
