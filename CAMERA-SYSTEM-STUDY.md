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
    (sleep 100)
    (bomber_flight_1)
    (camera_set autumn_glory_1c 200)
    ...
```

So in CE the camera is driven by **`camera_set <camera-script> <blend-ms>`**. The camera
scripts (`autumn_glory_1a`, `_1b`, `_1c`, `_1f`, `bridge`, `hangar_cryo`, …) are keyframed
paths held in the mission's cutscene data; the script says which one the camera is on and how
fast it blends to the next.

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

## The remake

The remake's own cutscenes are movies, so its scripts never need any of that. But the engine
still has it:

- The remake's simulation DLL (`HaloSimulation_tag_release.dll`) still exports the whole
  camera/cinematic vocabulary — 1695 script functions, among them `camera_set`,
  `camera_set_cinematic_scene`, `camera_set_field_of_view`, `camera_set_flying_cam_at_point`,
  `camera_set_pan`, `camera_set_spline_point`, `camera_set_look_at_target`,
  `camera_set_animation_with_speed`, `cinematic_set_shot`, `cinematic_set_active_camera`,
  `cinematic_scripting_create_scene`, `cinematic_scripting_create_object`,
  `cinematic_scripting_create_and_animate_cinematic_object`,
  `cinematic_scripting_start_animation/dialogue/music/effect`,
  `cinematic_object_create_cinematic_anchor`, `camera_control`, `cinematic_start`,
  `cinematic_in_progress`, `object_cinematic_visibility`, `cinematic_show_letterbox`,
  `debug_camera_save/load`, `director_debug_camera`.
  The recovered list is in `research/remake-console.json`; the camera and cinematic entries
  are the ones that matter.
- The remake's own campaign scripts use only six of them: `camera_control`, `cinematic_set`,
  `cinematic_start`, `cinematic_in_progress`, `cinematic_fade_in_to_cinematic`,
  `cinematic_preroll`.
- MJOLNIR's compiler front-end knows only the functions the shipped scenarios call (483
  opcodes, recovered from 13 scenarios), so it refuses `camera_set` and the Reach-style
  calls. That is the tool's front-end, not the game: the game compiles the scenario's script
  **source text** at level load, and the engine's own function table has all of them.
- The remake's `cinematic` tag (class `cine`) is the classic Halo 1 shape: name, channel type,
  flags, easing in/out, transition settings, header/footer/early-exit script blocks, and a
  `scenes` block of up to 32 scene references. The remake's own cinematics have **zero**
  scenes, because they point at an engine-level sequence and a movie instead.

## The open question

Does the remake's engine still honour a Blam-driven camera — CE's `camera_set` with camera
scripts, or Reach's scripted shots — or is the classic camera system only a shell kept for
compatibility?

**The experiment that answers it:** put a single `camera_set` call into the A15 scenario's own
source text, bake the override, and start the mission.

- Scenario compiles, camera moves → the classic system is alive, and CE's camera path can be
  brought across 1:1 (script + camera scripts in the cutscene data).
- Scenario refuses to compile → the camera has to be driven another way, and the options are
  the engine-level sequence route or the scripted-shot route if its data can be authored.

Either way the camera path itself comes from the original, recorded from the original game
running on this PC: the CE build here (the halobeta port with the original Xbox map) has a
script console on `127.0.0.1:2323`, and `map_name a10`, `game_time` and `debug_camera_save`
give the camera's position, orientation and field of view for every frame of the original's
cutscene. That recording is the 1:1 source; the CE camera scripts are its editorial form.
