import json
p='sheets/scenes.json'; d=json.load(open(p,encoding='utf-8'))
r=d['rows'][0]; c=d['columns']
r[c.index('shot_adjust')]["keyes_to_cortana_2"]={"right":16,"up":-4,"forward":0}
if 'skip_objects' not in c: c.append('skip_objects'); r.append(None)
r[c.index('skip_objects')]=["x10_crew_panic_1","x10_crew_panic_2","x10_crew_panic_3","x10_crew_panic_4","x10_crew_panic_5","x10_crew_panic_6"]
d['about']+=" skip_objects: script objects never drawn (creator: the panic crew vanish on camera where the original deleted them off screen)."
json.dump(d,open(p,'w',encoding='utf-8',newline='\n'),indent=2,ensure_ascii=False)
def patch(p,old,new):
    s=open(p,'rb').read().decode('utf-8'); nl='\r\n' if '\r\n' in s else '\n'
    old=old.replace('\n',nl); new=new.replace('\n',nl); assert s.count(old)==1,old; open(p,'wb').write(s.replace(old,new).encode('utf-8'))
patch('mod/OriginalCinematics/Scripts/ue_stage.lua',"function Stage:create(ev)\n",
"function Stage:create(ev)\n    for _, n in ipairs(self.ctx.skip_objects or {}) do\n        if n == ev.name then return end\n    end\n")
patch('mod/OriginalCinematics/Scripts/director.lua',"mcc = self.ctx.mcc, cache = self.ctx.cache, hide = row.hide })",
"mcc = self.ctx.mcc, cache = self.ctx.cache, hide = row.hide, skip_objects = row.skip_objects })")
