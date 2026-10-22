"""Simulates the mod's camera (camera_set calls with their ticks from a mod run log, the mod's easing) and compares it
with the original engine's recorded camera (probe-out/ce_camera_truth.tsv), sample by sample."""
import re, math, sys
cams={l.split("\t")[0]:[float(x) for x in l.split("\t")[1:]] for l in open("probe-out/a10_cameras.tsv")}
T=[list(map(float,l.split("\t")[1:])) for l in open("probe-out/ce_camera_truth.tsv").readlines()[1:]]
sets=[]
for l in open("probe-out/run.log"):
    m=re.search(r"camera_set (\S+) ticks=(\d+) at tick (\d+)",l)
    if m: sets.append((int(m[3]),m[1],int(m[2])))
    if "ended" in l and sets: break
def ease(u): u=max(0,min(1,u)); return u*u*u*(u*(6*u-15)+10)
def fwd(r):
    a,b,c=r; x,y,z=math.cos(a),math.sin(a),0
    x,z=x*math.cos(b),x*math.sin(b)
    return (x, y*math.cos(c)-z*math.sin(c), y*math.sin(c)+z*math.cos(c))
def lerp_ang(a,b,k):
    d=(b-a+math.pi)%(2*math.pi)-math.pi; return a+d*k
def camera_at(tick):
    cur=None; mv=None
    for t0,name,n in sets:
        if t0>tick: break
        p=cams[name]
        if cur is None or n<=0: cur=(p[:3],p[3:6]); mv=None
        else:
            # where the camera was at t0 is the start
            st=camera_at_state(cur,mv,t0)
            mv=(st,(p[:3],p[3:6]),t0,n); cur=st
    return camera_at_state(cur,mv,tick)
def camera_at_state(cur,mv,tick):
    if not mv: return cur
    (pa,ra),(pb,rb),t0,n=mv; k=min(1,(tick-t0)/n)
    kp,kr=ease(k),ease(k*4-3)
    return ([pa[i]+(pb[i]-pa[i])*kp for i in range(3)],[lerp_ang(ra[i],rb[i],kr) for i in range(3)])
off=float(sys.argv[1]) if len(sys.argv)>1 else None
first=sets[0][0]
if off is None:
    # align: first truth sample exactly at the first camera point
    p0=cams[sets[0][1]][:3]
    off=min(t[0] for t in T if math.dist(t[1:4],p0)<1e-3)-first
print("time offset",off,"camera_sets",len(sets))
cur=None; rows={}
for t in T:
    tick=t[0]-off
    if tick<first or tick>sets[-1][0]+200: continue
    pos,rot=camera_at(tick)
    name=[s for s in sets if s[0]<=tick][-1][1]
    pe=math.dist(pos,t[1:4])*304.8
    fe=math.degrees(math.acos(max(-1,min(1,sum(a*b for a,b in zip(fwd(rot),t[4:7]))))))
    r=rows.setdefault(name,[0,0,0]); r[0]=max(r[0],pe); r[1]=max(r[1],fe); r[2]+=1
for name,(pe,fe,n) in rows.items(): print("%-28s worst position %6.1f cm  worst aim %5.1f deg  (%d samples)"%(name,pe,fe,n))

print("\n--- aligned per shot (each cut matched to the original's cut) ---")
# truth cuts: a sample sitting exactly on a camera point after a jump
cut_times=[]
prev=None
for t in T:
    if prev is not None and math.dist(t[1:4],prev[1:4])>0.05:
        n=min(cams, key=lambda k: math.dist(cams[k][:3],t[1:4]))
        if math.dist(cams[n][:3],t[1:4])*304.8<2: cut_times.append((t[0],n,math.dist(cams[n][:3],t[1:4])*304.8))
    prev=t
ours=[(t0,name) for t0,name,n in sets if n==0]
print("our cuts (script tick):", [(t,n) for t,n in ours][:20])
print("original cuts (game time, nearest point, cm away):")
for c in cut_times[:40]: print("   %5d %-28s %.0f"%c)

print("shot   our tick  original time  (original - ours, ticks)")
oc={n:t for t,n,_ in cut_times}
for t,n in ours:
    if n in oc: print("  %-26s %5d %6d   %+d"%(n,t,oc[n],oc[n]-off-t))
    else: print("  %-26s %5d   not seen in original"%(n,t))

print("per shot, each lined up at its own cut:")
truth_cut={n:t for t,n,_ in cut_times}
seq=[(t0,name,n) for t0,name,n in sets]
for i,(t0,name,n) in enumerate(seq):
    if n!=0 or name not in truth_cut: continue
    tc=truth_cut[name]; nxt=[s[0] for s in seq[i+1:] if s[2]==0]
    end=(nxt[0]-t0) if nxt else 200
    worst_p=worst_a=0; k=0
    for t in T:
        dt=t[0]-tc
        if 0<=dt<end-3:
            pos,rot=camera_at(t0+dt)
            worst_p=max(worst_p,math.dist(pos,t[1:4])*304.8)
            worst_a=max(worst_a,math.degrees(math.acos(max(-1,min(1,sum(a*b for a,b in zip(fwd(rot),t[4:7])))))))
            k+=1
    print("  %-26s %3d samples  worst position %5.1f cm  worst aim %4.1f deg"%(name,k,worst_p,worst_a))
