# Which script drives the camera — CE, Reach, and the remake

Everything below was read out of the games' own files on this PC, not from memory.

## Halo: Combat Evolved (the original)

The bridge cutscene in A10 is a Blam script inside the mission's scenario. The strings in
`halo1\maps\a10.map` show the vocabulary it uses:

```
unit_suspended, switch_bsp, object_type_predict (captain, cortana, the chairs),
cinematic_start, camera_control, autumn_glory_1, autumn_glory_2, bridge,
cinematic_set_near_clip_distance, hangar_cryo, x10_cleanup, x10_chair_cleanup,
bomber_cleanup, object_destroy, object_create, chief, halo_setup, capt_keyes, ...
```

and the camera scripts themselves, dumped from the original game running on this PC:

```
(script static void autumn_glory_1 (static)
  (begin
    (object_create_anew glory_halo)
    (object_pvs_set_camera autumn_glory_1a)
    (bomber_setup)
    (camera_set autumn_glory_1a2 0)      ; camera script, blend 0 ms
    (fade_in 0.0 0.0 0.0 90)
    (sleep 180)
    (camera_set autumn_glory_1b 200)     ; next camera script, 200 ms blend
    ...
```

So in CE the camera is driven by **`camera_set <camera-script> <blend-ms>`**. The camera
scripts (`autumn_glory_1a`, `_1b`, `_1c`, `_1f`, `bridge`, `hangar_cryo`, …) are keyframed
paths held in the mission's cutscene data; the script says which one the camera is on and how
fast it blends to the next.

The truth was also recorded: the CE build on this PC (the halobeta port of the original Xbox
game) has a script console on `127.0.0.1:2323`, and `map_name a10`, `game_time` and
`debug_camera_save` give the camera's position, facing, up vector and field of view for every
sample of the original's cutscene. That recording is `research/ce_camera_a10.tsv` (1408
samples, 241 s of game time): the exterior space shots, the bridge, the hangar.

## Halo: Reach (the remake's own engine family)

Reach does the same beat the modern way, with a scripted cinematic. Strings in
`haloreach\maps\m10.map`:

```
camera_set_cinematic_scene, cinematic_tag_reference_get_scene, cinematic_set_shot,
cinematic_object_create_cinematic_anchor,
cinematic_scripting_create_and_animate_cinematic_object (carter_1, emile_1, jun_1, player_1, ...),
cinematic_scripting_get_object, camera_control, cinematic_start, cinematic_exit_pre,
cinematic_tag_fade_in_to_game, cinematic_exit_post, cinematic_exit_post_title,
object_hide, player_enable_input, player_disable_movement
```

A scene is chosen, shots are set, characters are created and animated by name, and the camera
is driven by the scene's camera data.

## The remake — the classic cutscene machinery is all still there

The remake's cutscenes are movies, so its own scripts never need any of that. But the engine
still has it, and the **scenario tag has the classic data slots, empty**:

| what the remake's A15 scenario holds | size |
|---|---|
| `cutscene camera points` | 0 of 512 |
| `cutscene spline points` | 0 of 512 |
| `thespian` (performances: actors, lines, dialogue, sync) | 0 of 256 |
| `vignettes` (camera script name, camera data, performances) | 0 of 256 |
| `cutscene flags` | 102 of 512 (the remake's own) |
| `cutscene titles` | 3 of 128 |

and the remake's `cinematic` tag (`cine`) is the classic Halo 1 shape — name, channel type
(letterbox / briefing / perspective / vignette), flags, easing in and out, transition settings,
header / footer / early-exit script blocks and a `scenes` block of up to 32 scene references.
All 46 of the remake's own cinematic tags are 1572–1584 bytes: shells with **zero scenes**,
because they point at an engine-level sequence and a movie instead.

The engine file (`HaloSimulation_tag_release.dll`) still carries the whole vocabulary:

- 1695 script functions, among them `camera_set`, `camera_set_cinematic_scene`,
  `camera_set_field_of_view`, `camera_set_flying_cam_at_point`, `camera_set_pan`,
  `camera_set_spline_point`, `camera_set_look_at_target`, `camera_set_animation_with_speed`,
  `cinematic_set_shot`, `cinematic_set_active_camera`, `cinematic_scripting_create_scene`,
  `cinematic_scripting_create_object`,
  `cinematic_scripting_create_and_animate_cinematic_object`,
  `cinematic_scripting_start_animation/dialogue/music/effect`,
  `cinematic_object_create_cinematic_anchor`, `camera_control`, `cinematic_start`,
  `cinematic_in_progress`, `object_cinematic_visibility`, `cinematic_show_letterbox`,
  `thespian_performance_activate`, `thespian_performance_setup_and_begin`,
  `performance_begin`, `cast_squad_in_performance`, `performance_play_line_by_id`.
  The recovered list is in `research/remake-console.json`.
- the classic data structures: `scenario_cutscene_camera_point_block`,
  `scenario_cutscene_spline_point_block` (orientation, spline in/out tangents),
  `scenario_performances_block` (tasks, lines, actors in search, point set, script name),
  `scenario_vignettes_block` (vignette name, camera script name, camera data, performances),
  `cinematic_scene_reference_block` / `cinematic_scene_block` (camera frame data,
  attachments, anchor, reset lighting).

## What this means

The remake is a remake of a game that had exactly this system, and the system is still in
the engine and still in the scenario tag — with the camera points, the spline points, the
performances and the vignettes sitting empty, ready to be filled. So the cutscene can be
written into the remake's own data:

1. the camera path from CE's recording goes into the scenario's cutscene camera points and
   spline points (or into the cinematic tag's scenes),
2. the actors in the bridge and the chairs go into the performances (thespian) block,
3. the mission script plays it with the remake's own `cinematic_set` / `cinematic_start` /
   `cinematic_in_progress` sequence.

MJOLNIR can write all of it: `mjolnir set` takes a field path with indices
(`control points[3].position`), and `mjolnir pack` bakes the edited tag into an override
container the game loads in front of the shipped one.

One open question, settled by the first build: the remake's own scripts only use six of the
engine's camera functions (`camera_control`, `cinematic_set`, `cinematic_start`,
`cinematic_in_progress`, `cinematic_fade_in_to_cinematic`, `cinematic_preroll`), and MJOLNIR's
compiler front-end only knows the functions the shipped scenarios call (483 opcodes), so it
refuses `camera_set`. The game compiles the scenario's script source itself when the level
loads, and the engine's own table has the call — whether the game's compiler takes it is what
the first build tests.
