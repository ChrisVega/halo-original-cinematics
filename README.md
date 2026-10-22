# Original Cinematics

Halo: Campaign Evolved plays Halo: Combat Evolved's original cutscenes in real time.

The remake's opening cinematic for A15 (Pillar of Autumn) is a pre-rendered movie. This mod
replaces it with the original in-engine cutscene: the same camera work, the same script, the
same voices and the same music, staged with the remake's own assets and played inside the
remake's own bridge.

Nothing from either game ships with the mod. Every piece of the original cutscene — the
camera and object paths, the HaloScript, the animation, the voices, the music and Cortana's
hologram textures — is read at run time from the player's own copy of Halo: The Master Chief
Collection. The level script change that lets the bridge exist while the cutscene plays, and
the replacement for the remake's intro movie, are installed into the game folder.

## Install

Install from Melty and press Play. The mod needs both games:

- Halo: Campaign Evolved (the host — the mod is installed into it and it is launched)
- Halo: The Master Chief Collection (the original cutscene's data, read at run time)

## What is in here

| path | what |
|---|---|
| `mod/OriginalCinematics/Scripts` | the mod itself (Lua, running in UE4SS inside the remake) |
| `mod/OriginalCinematics/media` | the replacement for the remake's A15 intro movie |
| `mod/OriginalCinematics/tools` | vgmstream and ffmpeg, used to decode the original's sound banks and textures at run time |
| `sheets` | the design sheets: scenes, characters, systems, bone map, flights, video skips. Every row is one thing, every column one of its properties, and the code is generated from them |
| `work` | the level patch: the script that edits A15's scenario, and the override container it bakes |
| `recipe.json` / `melty.json` | the install recipe (where each file lands in the game) |
| `MODLOG.md` | the build log: what each build changed and why |
| `SCENARIO-EDIT-NOTES.md` | how the remake's level script is edited and patched |

## How it is built

1. The mod's behaviour comes from the sheets in `sheets/` (`sheets_gen.lua` turns them into the
   tables the mod runs on).
2. The level patch is made with [MJOLNIR](https://github.com/devnull9090/mjolnir-core): the
   scenario's HaloScript is read out of the installed game, two lines are moved, the payload is
   patched (byte length preserved) and baked into an override container
   (`pakchunk999-MJOLNIR-Windows_P.*`) that the game loads in front of the shipped one.
   Nothing the game ships is modified: deleting the three files reverts everything.
3. The package is assembled from `mod/` plus the override container and installed with the
   recipe.

## Credits

- Halo: Combat Evolved and Halo: Campaign Evolved are trademarks of Microsoft / 343 Industries.
  This is an unofficial, community-made mod and is not affiliated with or endorsed by them.
- [UE4SS](https://www.ue4ss.com) (MIT) — the scripting layer the mod runs in.
- [MJOLNIR](https://github.com/devnull9090/mjolnir-core) — the toolchain that reads and writes the
  remake's tags.
- [vgmstream](https://github.com/vgmstream/vgmstream) and [FFmpeg](https://ffmpeg.org) — used to
  decode the original's sound banks and textures at run time.
- The cutscene data, voices and music come from the player's own Master Chief Collection.

## License

The mod's own code and the replacement intro movie are the work of the creator of this
repository. The cutscene data it reads belongs to its owners and is never redistributed with it.
