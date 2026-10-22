import sys
from pathlib import Path
from lupa import LuaRuntime

root = Path(__file__).resolve().parent.parent
scripts = root / "mod" / "OriginalCinematics" / "Scripts"
devtools = root / "devtools"

lua = LuaRuntime(encoding="utf-8")
g = lua.globals()
g.POSE_MAP = r"C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map"
g.POSE_REST = str(Path.home() / "AppData" / "Local" / "OriginalCinematics" / "keyes_rest.lua")
lua.execute(
    f'package.path = [[{scripts}\\?.lua;{devtools}\\?.lua;]] .. package.path'
)
src = (devtools / "t_pose.lua").read_text(encoding="utf-8")
lua.execute(src)
