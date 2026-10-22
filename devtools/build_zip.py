"""Zips dist/ (minus older zips) into dist/OriginalCinematics-<version>.zip."""
import sys, zipfile, hashlib, os
from pathlib import Path
v = sys.argv[1]
dist = Path(__file__).resolve().parent.parent / "dist"
out = dist / f"OriginalCinematics-{v}.zip"
# A byte-order mark stops Lua from loading the file at all (the mod then never
# runs and the game plays its own cutscene). Refuse to build such a package.
bad = []
for f in sorted(dist.rglob("*")):
    if f.is_file() and f.suffix in (".lua", ".json", ".ini", ".txt") and f.read_bytes()[:3] == b"\xef\xbb\xbf":
        bad.append(str(f.relative_to(dist)))
if bad:
    raise SystemExit("byte-order mark in: " + ", ".join(bad))
# every script must compile under real Lua (0.2.79 shipped a broken string)
import subprocess
if subprocess.run([sys.executable, str(Path(__file__).parent / "luacheck.py")], cwd=dist.parent).returncode:
    raise SystemExit("lua check failed")
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for f in sorted(dist.rglob("*")):
        if f.is_file() and f.suffix != ".zip":
            z.write(f, f.relative_to(dist).as_posix())
data = out.read_bytes()
print(out.name, len(data), hashlib.sha256(data).hexdigest(), len(zipfile.ZipFile(out).namelist()))
