"""Second rule search: quintic moves that carry over the camera's speed and acceleration when one move interrupts
another, angles lerped with or without wrap, facing on the same curve. Scored against the recorded original camera."""
import math, itertools
exec(open("devtools/fit_camera_rules.py").read().split("res=[]")[0])
def quintic(p0,v0,a0,p1,n,u):
    # coefficients for p(u), u in [0,1], with p'(0)=v0*n, p''(0)=a0*n*n, p(1)=p1, p'(1)=0, p''(1)=0
    V=v0*n; A=a0*n*n; D=p1-p0
    c3=10*D-6*V-1.5*A; c4=-15*D+8*V+1.5*A; c5=6*D-3*V-0.5*A
    return p0+V*u+0.5*A*u*u+c3*u**3+c4*u**4+c5*u**5
def make(wrap, carry):
    def cam(tick):
        # state per channel: value, velocity, accel at move start
        cur=None; mv=None
        def eval_at(mv,cur,tk):
            if not mv: return cur
            t0,n,start,tgt=mv; u=min(1,(tk-t0)/n)
            return [quintic(start[i][0],start[i][1],start[i][2],tgt[i],n,u) for i in range(6)]
        for t0,name,n in sets:
            if t0>tick: break
            p=cams[name]; tgt=p[:3]+p[3:6]
            if cur is None or n<=0:
                cur=tgt; mv=None
            else:
                if mv and carry:
                    h=0.5
                    x0=eval_at(mv,cur,t0); xm=eval_at(mv,cur,t0-h); xp=eval_at(mv,cur,t0+h)
                    start=[(x0[i],(xp[i]-xm[i])/(2*h),(xp[i]-2*x0[i]+xm[i])/(h*h)) for i in range(6)]
                else:
                    x0=eval_at(mv,cur,t0); start=[(x0[i],0,0) for i in range(6)]
                if wrap:
                    for i in range(3,6):
                        d=(tgt[i]-start[i][0]+math.pi)%(2*math.pi)-math.pi; tgt[i]=start[i][0]+d
                mv=(t0,n,start,tgt); cur=x0
        x=eval_at(mv,cur,tick)
        return x[:3],x[3:6]
    return cam
def score(cam):
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
        per[name]=round(e); tot+=e
    return tot,per
for wrap,carry in itertools.product((True,False),(True,False)):
    tot,per=score(make(wrap,carry)); print("wrap=%s carry=%s score %.0f"%(wrap,carry,tot), per)
