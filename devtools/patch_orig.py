def patch(p,pairs):
    s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
    for old,new in pairs:
        old=old.replace('\n',nl); new=new.replace('\n',nl); assert s.count(old)==1,old; s=s.replace(old,new)
    open(p,'wb').write(s.encode('utf-8'))
patch('mod/OriginalCinematics/Scripts/ce_timeline.lua',[
# re-creating an object really replaces it (a kept one left a second body standing)
("T.hs_object_create_anew = function(self, a) local n = argv(a[1]); self:destroy(n); self:create(n) end",
 "T.hs_object_create_anew = function(self, a) local n = argv(a[1]); self:destroy(n, true); self:create(n) end"),
# no run from the start: they walk and salute as in the original
("    -- walk_off crew run the whole time (the flee stance)\n    if self:_walks_off(name) then o.seat = \"flee\" end\n", ""),
# keep going in the same gait: a walk stays a walk, the panic runs stay runs
("""    o.rec, o.walk_on, o.seat = nil, true, "flee"
end""",
"""    o.rec, o.walk_on = nil, true
    if o.panic then o.seat = "flee" end
end"""),
("    if o and an then o.custom = { anim = an, frame = 0, graph = g }; o.rec = nil end",
 "    if o and an then o.custom = { anim = an, frame = 0, graph = g }; o.rec = nil end\n    if o and tostring(argv(a[3])):find(\"panic\") then o.panic = true end"),
("        o.rec_tick, o.run_after = 0, nil",
 "        o.rec_tick, o.run_after = 0, nil\n        if tostring(argv(a[2])):find(\"panic\") then o.panic = true end"),
])
