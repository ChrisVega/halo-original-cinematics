import json
p='sheets/scenes.json'; d=json.load(open(p,encoding='utf-8'))
r=d['rows'][0]; c=d['columns']
if 'start_facing' not in c: c.append('start_facing'); r.append(None)
r[c.index('start_facing')]={"x10_crew_panic_1":180}
d['about']+=" start_facing: degrees (original's angle convention) an object faces when created, before its own script moves it (creator: panic crewman 1 faces the big screen behind him until the alarm)."
json.dump(d,open(p,'w',encoding='utf-8',newline='\n'),indent=2,ensure_ascii=False)
def patch(p,old,new):
    s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
    old=old.replace('\n',nl); new=new.replace('\n',nl); assert s.count(old)==1,old; open(p,'wb').write(s.replace(old,new).encode('utf-8'))
patch('mod/OriginalCinematics/Scripts/ce_timeline.lua',"    self.objects[name] = o\n    self:emit({ type = \"create\"",
"    local sf = self.start_facing and self.start_facing[name]\n    if sf then o.yaw = math.rad(sf) end\n    self.objects[name] = o\n    self:emit({ type = \"create\"")
patch('mod/OriginalCinematics/Scripts/director.lua',"    tl.shot_adjust, tl.chain_ease, tl.walk_off = row.shot_adjust, row.chain_ease, row.walk_off",
"    tl.shot_adjust, tl.chain_ease, tl.walk_off = row.shot_adjust, row.chain_ease, row.walk_off\n    tl.start_facing = row.start_facing")
