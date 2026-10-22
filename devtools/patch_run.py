def patch(p,pairs):
    s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
    for old,new in pairs:
        old=old.replace('\n',nl); new=new.replace('\n',nl); assert s.count(old)==1,old; s=s.replace(old,new)
    open(p,'wb').write(s.encode('utf-8'))
patch('mod/OriginalCinematics/Scripts/ce_timeline.lua',[
# walk_off membership helper + run seat on handoff
("""function T:destroy(name, force)""",
"""function T:_walks_off(name)
    for _, n in ipairs((self.walk_off or {}).objects or {}) do
        if n == name then return true end
    end
end

-- walk_off: keep going (running, the flee stance) instead of stopping
function T:_run_on(o)
    o.rec, o.custom, o.walk_on, o.seat = nil, nil, true, "flee"
end

function T:destroy(name, force)"""),
("""                local o = self.objects[name]
                o.rec, o.custom, o.walk_on = nil, nil, true
                return""",
"""                self:_run_on(self.objects[name])
                return"""),
# a walk_off crewman whose recording slows to a stop runs on at once
("""        if walking then
            moving = true
            local a = self:base_anim(o, true)""",
"""        if walking then o.has_walked = true end
        if not walking and o.has_walked and self:_walks_off(o.name) then
            self:_run_on(o)
            walking = false
        end
        if walking then
            moving = true
            local a = self:base_anim(o, true)"""),
])
