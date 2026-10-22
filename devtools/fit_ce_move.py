"""Fits the original engine's camera move curve (a camera_set with ticks) from recorded truth: start, length, easing."""
import math
cams={l.split("\t")[0]:[float(x) for x in l.split("\t")[1:]] for l in open("probe-out/a10_cameras.tsv")}
T=[list(map(float,l.split("\t")[1:])) for l in open("probe-out/ce_camera_truth.tsv").readlines()[1:]]
def samples(a,b,lo,hi):
    A,B=cams[a][:3],cams[b][:3]; d=[B[i]-A[i] for i in range(3)]; L2=sum(v*v for v in d)
    out=[]
    for t in T:
        if not lo<t[0]<hi: continue
        s=sum((t[1+i]-A[i])*d[i] for i in range(3))/L2
        if math.dist(t[1:4],[A[i]+s*d[i] for i in range(3)])<0.002 and -0.01<s<1.01: out.append((t[0],s))
    return out
eases={"linear":lambda u:u,"smoothstep":lambda u:u*u*(3-2*u),"cosine":lambda u:(1-math.cos(math.pi*u))/2,
"smootherstep":lambda u:u*u*u*(u*(6*u-15)+10)}
def fit(S):
    best=None
    for name,e in eases.items():
        for t0 in range(int(S[0][0])-60,int(S[0][0])+30):
            for n in range(10,260):
                err=sum((min(1,max(0,e(min(1,max(0,(t-t0)/n)))))-s)**2 for t,s in S)
                if best is None or err<best[0]: best=(err,name,t0,n)
    return best
import sys
a,b,lo,hi=sys.argv[1],sys.argv[2],float(sys.argv[3]),float(sys.argv[4])
print(fit(samples(a,b,lo,hi)))
