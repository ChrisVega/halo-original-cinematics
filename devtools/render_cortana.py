"""Renders the H2A Cortana model from the player's MCC (decoded by devtools/h2a) by itself, with her textures,
to shots/cortana_*.png: a check of the model, UVs and textures outside the game."""
import sys, os, math
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "h2a"))
import numpy as np
from PIL import Image
import tpl
CACHE = os.path.join(os.environ["LOCALAPPDATA"], "OriginalCinematics", "cache")
d = tpl.read_tpl_bytes("cortana__h.tpl")
g = tpl.read_graph(d, d.find(b"OGM1"))
parts = tpl.build(d, g)
suffix = sys.argv[1] if len(sys.argv) > 1 else ""
HOLO = "--holo" in sys.argv
if suffix == "--holo": suffix = ""
body = np.asarray(Image.open(os.path.join(CACHE, "h2a_ch_cortana_04%s.png" % suffix)).convert("RGBA"), dtype=np.float32) / 255
hair = np.asarray(Image.open(os.path.join(CACHE, "h2a_ch_cortana_04_hair%s.png" % suffix)).convert("RGBA"), dtype=np.float32) / 255
use = {2: body, 3: body, 4: body, 5: body, 7: hair, 8: hair}
def render(yaw_deg, W=700, H=1000, out="x.png", zoom=1.0, center_y=0.9):
    img = np.zeros((H, W, 3), np.float32); img[:] = (0.08, 0.08, 0.1)
    zb = np.full((H, W), 1e9, np.float32)
    ca, sa = math.cos(math.radians(yaw_deg)), math.sin(math.radians(yaw_deg))
    scale = H / 1.9 * zoom
    L = np.array([0.4, 0.5, 0.75]); L /= np.linalg.norm(L)
    for pi, tex in use.items():
        pt = parts[pi]
        V = np.array(pt["verts"], np.float32); UV = np.array(pt["uvs"] or [(0, 0)] * len(V), np.float32)
        x = V[:, 0] * ca + V[:, 2] * sa; z = -V[:, 0] * sa + V[:, 2] * ca; y = V[:, 1]
        sx = W / 2 + x * scale; sy = H / 2 - (y - center_y) * scale
        th, tw = tex.shape[:2]
        for f in pt["faces"]:
            a, b, c = f
            if max(f) >= len(V): continue
            p = np.array([[sx[a], sy[a]], [sx[b], sy[b]], [sx[c], sy[c]]])
            area = (p[1, 0] - p[0, 0]) * (p[2, 1] - p[0, 1]) - (p[2, 0] - p[0, 0]) * (p[1, 1] - p[0, 1])
            if abs(area) < 1e-6: continue
            n = np.cross(V[b] - V[a], V[c] - V[a]); nn = np.linalg.norm(n)
            n = n / nn if nn > 0 else n
            nr = np.array([n[0] * ca + n[2] * sa, n[1], -n[0] * sa + n[2] * ca])
            shade = 0.35 + 0.65 * abs(float(nr @ L))
            x0, x1 = int(max(0, p[:, 0].min())), int(min(W - 1, p[:, 0].max()) + 1)
            y0, y1 = int(max(0, p[:, 1].min())), int(min(H - 1, p[:, 1].max()) + 1)
            if x1 <= x0 or y1 <= y0: continue
            gx, gy = np.meshgrid(np.arange(x0, x1) + 0.5, np.arange(y0, y1) + 0.5)
            w1 = ((gx - p[0, 0]) * (p[2, 1] - p[0, 1]) - (p[2, 0] - p[0, 0]) * (gy - p[0, 1])) / area
            w2 = ((p[1, 0] - p[0, 0]) * (gy - p[0, 1]) - (gx - p[0, 0]) * (p[1, 1] - p[0, 1])) / area
            w0 = 1 - w1 - w2
            m = (w0 >= 0) & (w1 >= 0) & (w2 >= 0)
            if not m.any(): continue
            zz = w0 * z[a] + w1 * z[b] + w2 * z[c]
            u = (w0 * UV[a, 0] + w1 * UV[b, 0] + w2 * UV[c, 0]) % 1.0
            v = (w0 * UV[a, 1] + w1 * UV[b, 1] + w2 * UV[c, 1]) % 1.0
            col = tex[(v * (th - 1)).astype(int), (u * (tw - 1)).astype(int)]
            m &= col[..., 3] > 0.3
            sub = zb[y0:y1, x0:x1]
            m &= -zz < sub
            sub[m] = -zz[m]
            c3 = col[..., :3]
            if HOLO:
                lum = (c3 @ np.array([0.3, 0.59, 0.11], np.float32))[..., None]
                c3 = np.array([80/255, 10/255, 190/255], np.float32) + lum * np.array([0.6, 0.55, 0.25], np.float32)
            img[y0:y1, x0:x1][m] = c3[m] * shade
    Image.fromarray((np.clip(img, 0, 1) * 255).astype(np.uint8)).save(out)
    print("wrote", out)
tag = (suffix.strip(".") or "raw") + ("_holo" if HOLO else "")
render(-90, out="shots/cortana_%s_front.png" % tag)
render(-55, out="shots/cortana_%s_turn.png" % tag)
render(-90, out="shots/cortana_%s_face.png" % tag, zoom=5, center_y=1.64)
