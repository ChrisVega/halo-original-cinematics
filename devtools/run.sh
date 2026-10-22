#!/bin/sh
# Sends a Lua snippet to the running game through the mod's dev console and prints the result.
# usage: devtools/run.sh file.lua   (or snippet on stdin)
D="/d/SteamLibrary/steamapps/common/Halo Campaign Evolved/Meteorite/Binaries/Win64/ue4ss/Mods/OriginalCinematics/dev"
rm -f "$D/out.txt"
if [ -n "$1" ]; then cp "$1" "$D/in.lua.tmp"; else cat > "$D/in.lua.tmp"; fi
mv "$D/in.lua.tmp" "$D/in.lua"
i=0
while [ ! -f "$D/out.txt" ] && [ $i -lt 120 ]; do sleep 0.5; i=$((i+1)); done
if [ -f "$D/out.txt" ]; then cat "$D/out.txt"; else rm -f "$D/in.lua"; echo "(no answer: is the game running with the mod?)"; fi
