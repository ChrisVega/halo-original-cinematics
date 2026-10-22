"""Compiles every mod Lua file with real Lua 5.4 (lupa); exits 1 on any error."""
import sys, glob
from lupa import lua54
L = lua54.LuaRuntime()
bad = 0
for f in sorted(glob.glob("mod/OriginalCinematics/Scripts/*.lua")):
    src = open(f, "rb").read()
    if src.startswith(b"\xef\xbb\xbf"): print("BOM", f); bad += 1; continue
    ok, err = L.eval("function(s, n) local f, e = load(s, n); return f ~= nil, e end")(src, f)
    if not ok: print("FAIL", f, err); bad += 1
print("lua check:", "clean" if not bad else f"{bad} bad")
sys.exit(1 if bad else 0)
