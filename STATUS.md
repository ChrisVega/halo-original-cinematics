# Where the build stands, and what the tests proved

## Proven

1. **The mission's script is ours to edit, and the game runs it.** A patched A15
   mission script (the intro movie's calls removed, one camera call added) is
   compiled and run by the game's own compiler when the level loads.
2. **The remake's intro video can be switched off for good.** The movie never
   starts on any difficulty when the mission script stops calling it.
3. **The original's camera path is extracted.** 31 interior camera points out of
   CE's a10 map, with position, rotation, 70 degree field of view and the blend
   time the original script uses to reach each one (`sheets/camera_path.json`).
4. **The original's cutscene script is read.** CE's `bridge` script: the camera
   sequence with blend times, the staging (`object_teleport`, `custom_animation`,
   `recording_play`), the dialogue (`sound_impulse_start` + sleep to each line's
   length), and the whole thing as one blocking script so the mission wakes after.
5. **The remake's cutscene data slots exist and are empty**: cutscene camera
   points (512), cutscene spline points (512), thespian/performances (256),
   vignettes (256). The engine still has the classic structures and commands, and
   C10 even ships one real in-engine performance ("tp_crazy_marine"), so the
   engine does populate these blocks.

## Not yet proven

- **Whether the engine honours a classic camera call from the mission script.**
  The probe (`camera_set_field_of_view 90 0`, riding the branch that runs on a
  normal playthrough) was inconclusive: with the movie off there is nothing on
  screen to measure the view against, so "was it wider?" cannot be told from the
  run. This needs a look with a reference shot, or a repeated call with a
  visible difference.
- **Whether the original's actor staging can be driven from the mission's own
  data.** The remake's bridge came up empty of NPCs when the movie was off: the
  movie was doing the camera *and* the staging, so both have to come from the
  cutscene we author.

## The blocker

The A15 camera-points block is empty **and has no element storage allocated** in
the shipped tag. MJOLNIR can read and write blocks that already have elements
(proven on the cutscene flags block) and its writer will grow a block that has a
donor (`--duplicate`), but it refuses any index on a block whose count is zero,
and it has no way to allocate storage for an empty one. Writing the camera path
therefore means creating that storage by hand in the 2.7 MB mission file:

- the block's element data is stored field by field (all names together, all
  positions together, rotations and fields of view separately), so the layout has
  to be mirrored exactly,
- the count MJOLNIR and the engine read is not the inline field in the data
  walk but the block's own record, which still has to be located,
- MJOLNIR's exact-walk is the verifier: a payload whose walk is not exact is
  never installed.

## What happens next

1. Re-run the FOV probe with a reference shot to settle whether the engine
   honours classic camera calls at all (this decides whether the original's
   camera path goes into the scenario's blocks at all).
2. If yes: allocate the camera-points storage, write the original's 31 points in,
   and write the mission script to walk them with the original's blend times.
3. Stage the bridge the same way, as a performance block, with the original's
   dialogue on its own ticks.
4. The mission's scripts already wake after the cutscene, so the mission starts
   cleanly once the cutscene plays.