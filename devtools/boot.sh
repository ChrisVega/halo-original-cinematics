#!/bin/sh
# Launches Campaign Evolved (if not running), waits for the menu, starts A15 through the mod's
# dev console, and waits until the mission world is loaded.
P=/c/Users/cmveg/Melty/master-chief-collection-halo-campaign-evolved
UM="$LOCALAPPDATA/Melty/modding-kit/bin/um"
world() { echo 'return FindFirstOf("World"):GetFullName()' | sh $P/devtools/run.sh 2>/dev/null; }
if ! "$UM" win ps | grep -q HaloCampaignEvolved; then "$UM" win launch --steam 2806050 >/dev/null; fi
for i in $(seq 1 60); do w=$(world); case "$w" in *Frontend*|*A15*) break;; esac; sleep 4; done
case "$w" in *Frontend*) sleep 3; sh $P/devtools/run.sh $P/devtools/q_start.lua;; esac
for i in $(seq 1 40); do w=$(world); case "$w" in *A15*) echo "$w"; exit 0;; esac; sleep 3; done
echo "mission did not load: $w"; exit 1
