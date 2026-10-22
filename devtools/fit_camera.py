import re,math
L=open('run.log').read().splitlines()
cam=None;S=[]
for l in L:
    m=re.search(r'shot t=(\d+)( CUT)? cam \((-?\d+),(-?\d+),(-?\d+)\) yaw (\S+) pitch (\S+) roll (\S+) fov (\S+)',l)
    if m: cam=dict(t=int(m[1]),p=[float(m[i]) for i in(3,4,5)],y=float(m[6]),pi=float(m[7]),r=float(m[8]),f=float(m[9]));continue
    m=re.search(r'shot   keyes_x10: .* off (\d+) cm; head on screen ours (-?[\d.]+),(-?[\d.]+) .*, (-?\d+) cm from',l)
    if m and cam and int(m[1])<5: S.append((cam,float(m[2]),float(m[3]),float(m[4])))
def axes(y,p):
    y,p=math.radians(y),math.radians(p)
    F=(math.cos(p)*math.cos(y),math.cos(p)*math.sin(y),math.sin(p))
    R=(-math.sin(y),math.cos(y),0)
    U=(-math.sin(p)*math.cos(y),-math.sin(p)*math.sin(y),math.cos(p))
    return F,R,U
A=2.39 if 'fov 70' in open('run.log').read() else 1.7778
def world(c,x,y,f):
    th=math.tan(math.radians(c['f']/2)); ro=math.radians(c['r'])
    sx=x*math.cos(ro)-y*math.sin(ro); sy=x*math.sin(ro)+y*math.cos(ro)
    r=sx*f*th; u=-sy*f*th/A
    F,R,U=axes(c['y'],c['pi'])
    return [c['p'][i]+F[i]*f+R[i]*r+U[i]*u for i in range(3)]
pts=[(c,world(c,x,y,f)) for c,x,y,f in S]
def scr(c,h,ps,rs,hf=70,asp=4/3):
    F,R,U=axes(c['y'],c['pi']*ps)
    d=[h[i]-c['p'][i] for i in range(3)]
    f=sum(d[i]*F[i] for i in range(3))
    if f<1: return None
    th=math.tan(math.radians(hf/2))
    sx=sum(d[i]*R[i] for i in range(3))/f/th; sy=-sum(d[i]*U[i] for i in range(3))/f/th*asp
    ro=math.radians(c['r']*rs)
    return sx*math.cos(ro)+sy*math.sin(ro), -sx*math.sin(ro)+sy*math.cos(ro)
seen={}
for c,h in pts: seen.setdefault(c['t']//30,(c,h))
for ps in(1,-1):
  for rs in(1,-1):
    out=[];inside=0
    for c,h in pts:
        s=scr(c,h,ps,rs)
        if s and abs(s[0])<1 and abs(s[1])<1: inside+=1
    print('pitch',ps,'roll',rs,'head in 4:3 frame',inside,'/',len(pts))
print()
last=-1
for c,h in pts:
    if c['t']-last<60: continue
    last=c['t']
    a=scr(c,h,1,1);b=scr(c,h,-1,1)
    f=lambda s:'behind' if not s else '%5.2f,%5.2f'%s
    print('t=%4d cam z %4.0f pitch %5.1f roll %5.1f head z %4.0f | now %s | flipped %s'%(c['t'],c['p'][2],c['pi'],c['r'],h[2],f(a),f(b)))
print()
for c,h in pts:
    if 795<=c['t']<=800:
        for rs in (1,-1,0):
            print('roll x',rs, scr(c,h,1,rs,86.1,16/9))
        break
