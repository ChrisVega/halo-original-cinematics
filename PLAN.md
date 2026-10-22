# Plan — the remake plays Halo CE's own cutscene

The old approach (a script mod that re-enacted the cutscene at run time) is gone. This one
changes the game's own files: the remake's mission script and its cutscene data are edited so
the game itself plays the original's cutscene, with the original's camera path, its actors in
the bridge and its chairs, and the mission starting afterwards the way CE starts it.

## Where we are

- [x] The game is back to stock: our script mod unlinked, the override container deleted, the
      remake's own A15 intro movie restored.
- [x] The tools are in this folder: MJOLNIR 0.4.0 (reads and writes the remake's tags),
      vgmstream, ffmpeg, Invader.
- [x] Read out of the games' own files how the camera is driven in CE (`camera_set` with
      camera scripts), in Reach (scripted cinematic: scene, shot, objects, camera) and in the
      remake (the engine still has all of it; see `CAMERA-SYSTEM-STUDY.md`).
- [ ] **Open:** does the remake's engine honour a Blam-driven camera? Settled by one
      experiment (a single `camera_set` call in the A15 scenario's own source).

## Steps

1. **Record the original.** Run the CE build on this PC, start A10, and record the camera
   (position, orientation, field of view) and the game clock for every frame of the original's
   bridge cutscene. This is the 1:1 truth; the sheets are filled from it.
2. **Settle the engine question.** Bake one `camera_set` call into the A15 scenario's source
   text, start the mission, watch what the camera does.
3. **Build the cutscene in the game's own data.** In sheets, then in the game:
   - the shots (which camera script, which blend, how long, what is on screen),
   - the camera path, key by key, in the remake's units,
   - the actors: Keyes, the crew in their chairs, Cortana's hologram, each with its position,
     facing and animation,
   - the dialogue and the music, on the original's timing.
4. **The mission starts afterwards** the way CE starts it: the cutscene ends, the mission's
   scripts wake, the player takes over.
5. **Test in the game**, capture the footage, and only then decide what ships (the Melty draft
   holds the files, GitHub is the backup).

## The sheets are the source of truth

| sheet | one row is | columns |
|---|---|---|
| `sheets/camera_path.json` | one camera key | shot, time, position, orientation, field of view, source frame |
| `sheets/cutscene_shots.json` | one shot | name, camera script, blend, duration, actors, dialogue, music |
| `sheets/actors.json` | one actor | name, tag, position, facing, animation, what it does |

Every cell has to be filled and verified before a build. If something is unknown it is written
down as unknown, not guessed.

## Rules for this build

- The camera path comes from the original game's own recording, never from invention.
- The game plays the cutscene itself: no script mod, no re-enactment at run time.
- Nothing the game ships is modified: the edits go into an override container that is deleted
  to undo everything.
