def patch(p,pairs):
    s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
    for old,new in pairs:
        old=old.replace('\n',nl); new=new.replace('\n',nl); assert s.count(old)==1,old; s=s.replace(old,new)
    open(p,'wb').write(s.encode('utf-8'))
patch('mod/OriginalCinematics/Scripts/ce_timeline.lua',[
("""        if walking then o.has_walked = true end
        if not walking and o.has_walked and self:_walks_off(o.name) then
            self:_run_on(o)
            walking = false
        end
""",
"""        -- walk_off: past its last step (where the original slows to a stop
        -- before deleting it) it runs on instead
        o.rec_tick = (o.rec_tick or 0) + 1
        if o.run_after and o.rec_tick >= o.run_after then
            self:_run_on(o)
            walking = false
        end
"""),
("""        if o.rec.done then""","""        if o.rec and o.rec.done then"""),
("""        o.rec = R.new(rec); o.rec_delete = delete""",
"""        o.rec = R.new(rec); o.rec_delete = delete
        o.rec_tick, o.run_after = 0, nil
        if self:_walks_off(o.name) then
            -- the tick of its last step
            local probe, t, last = R.new(rec), 0, nil
            while not probe.done and t < 20000 do
                t = t + 1
                local c = probe:step()
                if math.abs(c.throttle[1]) + math.abs(c.throttle[2]) > 0.01 then last = t end
            end
            o.run_after = last
        end"""),
])
