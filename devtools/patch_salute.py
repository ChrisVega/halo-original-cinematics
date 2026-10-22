import json
p='sheets/scenes.json'; d=json.load(open(p,encoding='utf-8'))
r=d['rows'][0]; c=d['columns']
r[c.index('skip_objects')]=None
wo=r[c.index('walk_off')]["objects"]
if "x10_crew_panic_1" not in wo: wo.insert(0,"x10_crew_panic_1")
json.dump(d,open(p,'w',encoding='utf-8',newline='\n'),indent=2,ensure_ascii=False)
def patch(p,pairs):
    s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
    for old,new in pairs:
        old=old.replace('\n',nl); new=new.replace('\n',nl); assert s.count(old)==1,old; s=s.replace(old,new)
    open(p,'wb').write(s.encode('utf-8'))
patch('mod/OriginalCinematics/Scripts/ce_timeline.lua',[
("""function T:_run_on(o)
    o.rec, o.custom, o.walk_on, o.seat = nil, nil, true, "flee"
end""",
"""function T:_run_on(o)
    -- a salute still playing finishes first
    if o.custom then o.run_after_custom = true; return end
    o.rec, o.walk_on, o.seat = nil, true, "flee"
end"""),
("""        if o.custom.frame >= a.frame_count then
            o.custom = nil
        end""",
"""        if o.custom.frame >= a.frame_count then
            o.custom = nil
            if o.run_after_custom then o.run_after_custom = nil; self:_run_on(o) end
        end"""),
("""        if o.run_after and o.rec_tick >= o.run_after then""",
"""        if o.run_after and o.rec_tick >= o.run_after and not o.custom then"""),
])
