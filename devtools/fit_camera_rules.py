"""Tries rule variants for the original's camera moves (angle wrap, where a move that interrupts another starts,
easing, turn timing) and scores each against the recorded original camera, every shot aligned at its own cut."""
import math, itertools, re
exec(open("devtools/compare_camera.py").read().split('off=float')[0])
def run(wrap, chain, turn_k, pos_ease):
    def la(a,b,k):
        if wrap: d=(b-a+math.pi)%(2*math.pi)-math.pi
        else: d=b-a
        return a+d*k
    def at_state(cur,mv,tick):
        if not mv: return cur
        (pa,ra),(pb,rb),t0,n=mv; k=min(1,(tick-t0)/n)
        kp=ease(k) if pos_ease else k
        kr=ease(k*turn_k-(turn_k-1)) if turn_k else kp
        return ([pa[i]+(pb[i]-pa[i])*kp for i in range(3)],[la(ra[i],rb[i],kr) for i in range(3)])
    def cam(tick):
        cur=None; mv=None
        for t0,name,n in sets:
            if t0>tick: break
            p=cams[name]
            if cur is None or n<=0: cur=(p[:3],p[3:6]); mv=None
            else:
                st=at_state(cur,mv,t0) if chain=="current" else (mv[1] if mv else cur)
                mv=(st,(p[:3],p[3:6]),t0,n); cur=st
        return at_state(cur,mv,tick)
    tot=0; per={}
    for i,(t0,name,n) in enumerate(sets):
        if n!=0 or name not in truth_cut: continue
        tc=truth_cut[name]; nxt=[s[0] for s in sets[i+1:] if s[2]==0]; end=(nxt[0]-t0) if nxt else 200
        e=0
        for t in T:
            dt=t[0]-tc
            if 0<=dt<end-3:
                pos,rot=cam(t0+dt)
                e+=math.dist(pos,t[1:4])*3.048+math.degrees(math.acos(max(-1,min(1,sum(a*b for a,b in zip(fwd(rot),t[4:7]))))))
        per[name]=e; tot+=e
    return tot,per
truth_cut={}
prev=None
for t in T:
    if prev is not None and math.dist(t[1:4],prev[1:4])>0.05:
        n=min(cams,key=lambda k: math.dist(cams[k][:3],t[1:4]))
        if math.dist(cams[n][:3],t[1:4])<0.007: truth_cut.setdefault(n,t[0])
    prev=t
res=[]
for wrap,chain,turn_k,pe in itertools.product((True,False),("current","target"),(0,1,2,3,4,6),(True,False)):
    tot,per=run(wrap,chain,turn_k,pe); res.append((tot,wrap,chain,turn_k,pe,per))
res.sort(key=lambda r:r[0])
for r in res[:6]: print("score %.0f wrap=%s chain=%s turn_k=%s ease_pos=%s"%r[:5])
print({k:round(v) for k,v in res[0][5].items()})
