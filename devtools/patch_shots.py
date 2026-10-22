import json
# sheet: per-shot camera adjustments + chained-move easing
p='sheets/scenes.json'
d=json.load(open(p,encoding='utf-8'))
r=d['rows'][0]; c=d['columns']
for k,v in [('shot_adjust',{
    "display_rev_1a":{"up":50},
    "display_rev_1b":{"up":50},
    "keyes_to_cortana_2":{"right":10,"up":4,"forward":-15}}),
  ('chain_ease','out')]:
    if k in c: r[c.index(k)]=v
    else: c.append(k); r.append(v)
d['about'] += (" shot_adjust: per camera point, cm in the camera's own directions (right, up, forward) added to the original's"
 " position (creator's calls: display_rev up over the remake's solid nav console; keyes_to_cortana_2 right and back so his face is in the eye close-up)."
 " chain_ease = 'out': a camera move that interrupts another (the walk to the chair is three chained pans) starts at speed and only eases at its end, instead of stopping and starting again.")
json.dump(d,open(p,'w',encoding='utf-8',newline='\n'),indent=2,ensure_ascii=False)

def patch(p, pairs):
    s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
    for old,new in pairs:
        old=old.replace('\n',nl); new=new.replace('\n',nl)
        assert s.count(old)==1, (p, old[:60]); s=s.replace(old,new)
    open(p,'wb').write(s.encode('utf-8'))

patch('mod/OriginalCinematics/Scripts/director.lua', [(
"    local tl = scene:timeline(row.ce_script)",
"    local tl = scene:timeline(row.ce_script)\n    tl.shot_adjust, tl.chain_ease = row.shot_adjust, row.chain_ease")])

patch('mod/OriginalCinematics/Scripts/ce_timeline.lua', [(
"    local target = { pos = p.pos, rot = p.rot, fov = p.fov }",
"""    local pos = p.pos
    -- shot_adjust (scenes sheet): cm along the camera's own right/up/forward
    local adj = self.shot_adjust and self.shot_adjust[point_name]
    if adj then
        local a, b = p.rot[1], p.rot[2]
        local fx, fy, fz = math.cos(a) * math.cos(b), math.sin(a) * math.cos(b), math.sin(b)
        local rx, ry = math.sin(a), -math.cos(a)
        local r, u, f = (adj.right or 0) / 304.8, (adj.up or 0) / 304.8, (adj.forward or 0) / 304.8
        pos = { pos[1] + rx * r + fx * f, pos[2] + ry * r + fy * f, pos[3] + u + fz * f }
        self:note(string.format("shot_adjust %s: right %s up %s forward %s cm", point_name,
            tostring(adj.right or 0), tostring(adj.up or 0), tostring(adj.forward or 0)))
    end
    local target = { pos = pos, rot = p.rot, fov = p.fov }"""),
("        self.camera = { pos = { table.unpack(p.pos) }, rot = { table.unpack(p.rot) }, fov = p.fov }",
 "        self.camera = { pos = { table.unpack(pos) }, rot = { table.unpack(p.rot) }, fov = p.fov }"),
("            to = target, t = 0, n = ticks }",
 "            to = target, t = 0, n = ticks,\n            -- interrupting a move still under way: start at speed (chain_ease)\n            chained = self.cam_move ~= nil and self.chain_ease == \"out\" }"),
("    local kp, kr = ease(k), ease(k)",
 "    local e = ease(k)\n    if m.chained then local v = 1 - k; e = 1 - v * v * v end\n    local kp, kr = e, e"),
])
