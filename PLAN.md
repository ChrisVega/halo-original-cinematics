# Plan — the remake plays Halo CE's own cutscene

The old approach (a script mod that re-enacted the cutscene at run time) is gone. This one
changes the game's own files: the remake's scenario tag and its cutscene data are written so
the game itself plays the original's cutscene, with the original's camera path, its actors in
the bridge and its chairs, and the mission starting afterwards the way CE starts it.

## Where we are

- [x] The game is back to stock: our script mod unlinked, the override container deleted, the
      remake's own A15 intro movie restored.
- [x] The tools are in this folder: MJOLNIR 0.4.0 (reads and writes the remake's tags and
      writes override containers), vgmstream, ffmpeg, Invader.
- [x] How the camera is driven in CE, Reach and the remake: `CAMERA-SYSTEM-STUDY.md`.
- [x] The original's camera path, recorded frame by frame from the original game running on
      this PC: `research/ce_camera_a10.tsv` (1408 samples over 241 s of game time).
- [x] The remake's data slots for the cutscene found and confirmed empty: cutscene camera
      points (512), cutscene spline points (512), thespian/performances (256), vignettes (256).
- [ ] **Next:** author a minimal cutscene in the remake and see it play.

## Steps

1. **A minimal cutscene.** Author one scene with one camera frame in the remake's cinematic
   tag, point the A15 script at it, bake the override, start the mission. This answers whether
   the remake's engine still plays a Blam-driven camera, and whether the game's own script
   compiler accepts the classic calls.
2. **The camera path.** Turn CE's recording into the remake's cutscene camera points and
   spline points: position, orientation and field of view per key, in the remake's units
   (CE's unit is 30.48 cm, Y flipped), shot by shot, with the original's blend times.
3. **The actors.** Keyes, the crew in the bridge, Cortana: the performances (thespian) block
   holds who is on screen, what they do and when; the dialogue and the music follow the
   original's timing.
4. **The mission starts afterwards** the way CE starts it: the cutscene ends, the mission's
   scripts wake, the player takes over.
5. **Test in the game**, capture the footage, and only then decide what ships (the Melty draft
   holds the files, GitHub is the backup).

## The sheets are the source of truth

| sheet | one row is | columns |
|---|---|---|
| `sheets/camera_path.json` | one camera key | shot, time, position, orientation, field of view, source sample |
| `sheets/cutscene_shots.json` | one shot | name, camera script, blend, duration, actors, dialogue, music |
| `sheets/actors.json` | one actor | name, remake tag, position, facing, animation, action |

Every cell has to be filled and verified before a build. If something is unknown it is written
down as unknown, not guessed.

## Rules for this build

- The camera path comes from the original game's own recording, never from invention.
- The game plays the cutscene itself: no script mod, no re-enactment at run time.
- Nothing the game ships is modified: the edits go into an override container that is deleted
  to undo everything.
