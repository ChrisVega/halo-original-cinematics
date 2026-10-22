# Runs a mod Lua file under Lua 5.4 (lupa) for offline tests.
import sys
from lupa import lua54
L = lua54.LuaRuntime(unpack_returned_tuples=True)
p = sys.argv[1].replace(chr(92), '/')
L.execute('package.path = "' + p + '/?.lua;" .. package.path')
L.globals().arg = L.table(*sys.argv[3:])
L.execute(open(sys.argv[2], encoding='utf-8').read())
