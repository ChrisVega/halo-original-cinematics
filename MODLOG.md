# MODLOG: Original Cinematics (Halo: Campaign Evolved + MCC Halo CE)

## Goal
Campaign Evolved (host, primary) plays Halo CE's original cutscenes, rebuilt in real time with
the remake's models, using the original voices. MCC (companion) supplies cutscene scripts, cameras,
animations and voices from the player's own install. First slice: a10 intro (CE script `x10`).

## Installs on this PC
- Campaign Evolved: `D:\SteamLibrary\steamapps\common\Halo Campaign Evolved` (Steam), exe
  `Meteorite\Binaries\Win64\HaloCampaignEvolved.exe` 2026.08.11.1121610.2-Rel-i343-Meteorite-2607-CU4, UE 5.5.
  Blam sim in `HaloSimulation_tag_release.dll`. No anti-cheat folder.
- MCC: `C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection`, CE in `halo1\`.
  a10.map = CEA (MCC) engine, uncompressed, 3747 tags; script source kept in scenario (source_files[0]).
  Dialog audio in `halo1\sound\pc\sounds_dialogs.fsb` (FSB5, codec 12 = CELT), name lists in `lst\`.

## Facts
- Remake cutscenes = loose MP4s `Meteorite\Content\Movies\CinematicsPreRenders\A15\m01_POA-cin01_sc01_space`,
  `sc03_sarge_{easy,heroic,legendary}`, `sc05_cryo`, `cin02_bridge`, `cin03_outro`.
- Remake has real bipeds: BP_KeyesBipedActor, CaptainKeyes_Head, etc. (pak index unencrypted names).
- Remake HaloScript (hs_doc from Halo Meister): Halo3/Reach-era. Has camera_set (scenario points only),
  custom_animation (string_id), sound_impulse_start. No recording_play. Console verb `hs:`.
- UE cm ↔ Blam: ×304.8, Y mirrored (Halo Meister bridge). To verify against CE coords.
- CE x10 = autumn_glory_1, autumn_glory_2 (space bsp 7), bridge (bsp 1), hangar_cryo (bsp 8).
  a10 scenario: 292 camera points, 221 flags, 99 recorded animations.

## Route
UE4SS (RE-UE4SS experimental-latest v3.0.1-1181, official Steam config/signatures for Campaign
Evolved, MIT) + Lua mod. Our code reads CE data from the MCC folder at runtime, runs the x10 timeline,
drives a cutscene camera and poses remake meshes; voices decoded from the player's FSB.
Remake HaloScript can't replay CE recordings or use CE camera points directly, so the timeline runs in Lua.

## Lab
- Saves backup: `C:\Users\cmveg\.universal-modder\backups\hce-saved\20261018-153539.zip` (um backup restore).
- Dev install: dwmapi.dll + ue4ss\ in Win64; mod folder junctioned from project `mod\OriginalCinematics`.
  Remove both to restore vanilla.
- CE extraction (private, never shipped): `C:\Users\cmveg\halo-ce-extract`.

## Next
1. Scout launch: media hooks, bones, pawn position, classes.

## 2026-10-18 progress
- Scout run 1: UE4SS needed a custom GUObjectHashTables signature (package/ue4ss_overrides). Works.
  A15 level = /Game/Levels/Halo1/Solo/A15/A15 (World Partition). Cin cam BP_dUniCineCam_Spherical.
  Media hooks on MediaPlayer:Open* did not fire (opened natively) -> poll MediaPlayers.
  Remake cryo player pos matches CE coords (UE = CE*304.8, Y mirrored).
- CE readers done (Lua, run on player PC): ce_map (tags/scenario), ce_script (decompiles script nodes),
  ce_recording (unit-control streams), ce_anim (raw + compressed animations; x10 gestures compressed).
  Voices: halo1/sound/pc/sounds_dialogs.fsb (FSB5 CELT) + lst/sounds_dialogs.lst.bin name->index (0-based);
  decode with vgmstream-cli (-s index+1). Tag class for animations in maps: "antr".
- Remake assets: Keyes = /Game/characters/keyes/Common/Skeleton/SK_Keyes + MetaHumans/CaptainKeyes_Head.
  NO Cortana mesh in remake -> placeholder from CE model via ProceduralMeshComponent (present in exe).
- Next: lab.lua run (stop video, camera actor, Keyes poseable, bone pose, wav via MediaPlayer, proc mesh).
- Dev console (repl.lua, dev/enabled): devtools/run.sh sends Lua to the game. Mod can auto-start A15:
  BlamCampaignFlowGameSubsystem:SetAndBeginCampaign(DA_FirstPlayableCampaign, "A15", options) (devtools/q_start.lua).
- Opening = LevelSequence LS_m01_POA-cin01_sc01_easynormal driving MediaPlayer MP_ExternalPreroll; closing media
  is undone by the sequence (it re-opens video and re-takes the view target). Must pause/hold the sequence player.
- Remake bridge IS at CE coordinates: hs:ai_place sq_bridge_keyes puts remake Keyes at blam (0.76,-0.02,0) = CE keyesa10.
  Remake zone sets: zs_01..zs_04 (strings in a15-scenario.ubulk).
- CRASH: touching DataLayerInstance objects through UE4SS reflection (methods or ForEachProperty) -> AV 0x18. Never again.

## v0.1 scene player (built offline, mock-tested)
- main.lua: finds MCC (OC_MCC_DIR env or Steam libraries), prepares sounds async (vgmstream -> wav -> ffmpeg AAC mp4,
  cache %LOCALAPPDATA%\OriginalCinematics\cache; remake media player is Electra-only: no WAV), director loop 16 ms.
- director.lua: trigger LS_m01_POA-cin01_sc01*, pause SequencePlayer, close CinematicsPreRenders media each frame,
  hs:player_enable_input 0/1, GoToEndAndStop at the end; skips sc03/sc05.
- ce_timeline.lua: HaloScript subset interpreter + biped sim (recordings, custom anims with root motion). Full x10
  runs 244.9 s offline. ue_stage.lua: CameraActor (+WP streaming source, aspect 1.85), Keyes PoseableMesh x3
  (head/hair attached to Head_M), retarget.lua (conj quats, mirror Y, delta from rest; verified offline: rest
  round-trip 2.6 deg, idle = hands behind back), Cortana = ProceduralMesh from CE mod2 + MI_Holo_Glyph_03_Blue.
- Not drawn in v0.1: crewmen, marines, Johnson, Chief, ships (voices/camera still play).
- Untested in game: Electra playing local mp4 via StaticConstructObject MediaPlayer + MediaSoundComponent;
  whether paused sequence holds the Blam mission; video overlay hiding; CreateMeshSection 12 args.

## 2026-10-19 Melty release + video takeover
- Melty draft "Original Cinematics" (slug original-cinematics, id f82d9236-b7e4-48bc-aafc-e1d637ea44eb),
  games: custom-halo-campaign-evolved (primary) + halo-mcc (companion). Release 0.1.0 one-click, not tested.
- Package (dist/OriginalCinematics-0.1.0.zip): UE4SS 3 experiment (ue4ss1018) + Campaign Evolved steam
  signatures (GUObjectHashTables override from package/ue4ss_overrides) + MSVC runtime DLLs + the mod;
  maps into {game}/Meteorite/Binaries/Win64 (ue4ss/ and ue4ss/Mods/OriginalCinematics). Vendor notices included.
- Test mode: reads %LOCALAPPDATA%\Melty\test\original-cinematics.json, starts A15 itself, writes
  "pass ready" / "pass scene-started" to the checks file; TEST works like OC_TEST.
- Video takeover: director now pauses (not ends) the triggering sequence, sets MediaPlayer.PlayOnOpen=false
  and closes the stream (restored at the end), keeps closing re-opened players, refreshes the player list
  every 300 frames. Skip list now also covers the bridge preroll (LS_m01_POA%-cin02) besides sc03/sc05.
- Camera: begin_camera remembers the previous view target; end_camera hands the view back before the
  cutscene camera is destroyed (finish calls it).

- 0.1.0 rebuilt/uploaded twice after code changes; latest release id e483f5d9-1835-4883-8634-e77c4d457122 (draft, one-click yes). Diagnostics added: logs each MediaPlayer (name/url/playing), logs re-opened players; inactive skip closes media around GoToEndAndStop and restores after; PlayOnOpen saved by full object name (fresh UE4SS wrappers).

## 2026-10-19 Blam-side cutscene data (a10.map)
- MCC still ships the original Blam cache: halo1\maps\a10.map (108 MB). Dumped read-only with a Python port of ce_map/ce_script offsets.
- 189 compiled HaloScript scripts incl. x10 (intro), x30 (outro), bridge, hangar_cryo, launch/approach/autumn_ext.
- 292 cutscene camera points (name/pos/rot/fov), 221 cutscene flags (teleport/effect markers), 99 recorded animations (69 unique, x10 cast/vehicles).
- x30 outro data is present too: camera points chief_x30_back_*, autumn_glory_*, takeoff_*, hallway_*; graphs cinematics\animations\chief\x30, pilot\x30, marines\x30, lifeboat\x30; model characters\cyborg\cyborg_cinematic. x30 does switch_bsp 6/7 (docked/space).
- No original cutscene video files exist (only terminals/*.bk2 and prebuild/swf/video/vid_epilogue.bk2); originals were engine-driven, so real-time replacement is the only route. Remake outro sequence is LS_m01_POA-cin03_outro.

## 2026-10-19 late: camera freeze fixed (Claude takeover)
- Test 331c8e31 (run 1): scene ran ~7 s (camera moving, Keyes posed, keyes02 voice) then UE4SS logged
  "Hook threw exception: Ref was not function ... removing hook" on the EngineTick hook. Our update stopped -> frozen camera.
  Cause: LoopAsync(16) queued a new ExecuteInGameThread closure every 16 ms from the async thread (Lua state shared across threads).
- Fix (main.lua): one LoopInGameThreadAfterFrames(1, ...) game-thread loop, started once the async sound setup finishes;
  test auto-start uses LoopInGameThreadWithDelay(2000) + CancelDelayedAction. No more ExecuteInGameThread outside the dev REPL.
- Resubmitted 0.1.0: release 6ba6dde7-c025-476c-8bb6-78ba24f9a7f7, upload 1fccb95c (sha a64dd4bb...). Recipe saved as recipe.json.

## 2026-10-20 Keyes floor + camera framing (0.1.1)
- Offline measurement (devtools/t_feet.lua, run_feet.py): over 2051 posed frames the lowest foot bone stays
  0.5-7.3 cm above the actor origin -> the pose/retarget is sound; the sinking came from the one-time -0.4 cm
  "remake floor" offset, which used the remake Keyes actor at world (0,0,0), not the bridge.
- CE unit z under Keyes: -121.9 cm at ticks 300-600, +0.3 cm at tick 1200+ -> the bridge path climbs ~1.2 m,
  so a fixed height can never hold.
- ue_stage.lua: removed _floor_fix; added per-frame _trace_floor (KismetSystemLibrary:LineTraceSingle down,
  z+300 -> z-500, ignores the cast and hidden remake actors) and foot planting: actor z = hit z +
  rest sole offset - current posed foot z (+0.5 cm), rejected if the correction would exceed 250 cm.
  Logs "floor <name>: foot ..., floor ..., moved ..." once, and any trace failure (3x).
- Camera: CE fov 1.2 rad is horizontal for a 4:3 frame; shipped on a 16:9 frame it crops ~22% of the vertical
  view (reads as too close). scenes sheet now carries source_aspect 1.3333 / target_aspect 1.7778; camera
  AspectRatio is the target, and FOV is widened by target/source preserving the vertical view. director passes
  the row's aspects into Stage.
- Workflow: Melty tests install the submitted release, not the working copy (the installed mod is a real folder,
  not the dev junction). Build -> submit -> test through Melty every time; no direct exe launches (breaks sign-in).

## 2026-10-20 camera aim (0.1.2)
- Camera point layout confirmed from a10.map: name +4, position +40 (CE units), rotation +52 = yaw, pitch, roll
  (radians), fov +64 (all points 1.2217 rad = 70 deg). The bridge points are named keyes_x10_deck_1a/1b/2a/2b,
  keyes_react_1a, keyes_cu, keyes_rev_wide, etc.
- Pitch convention bug: CE pitch is positive up, Unreal pitch is positive down; update_camera was adding
  +deg(pitch), aiming every shot up by twice its pitch. Corrected to -deg(pitch); roll stays mirrored
  (the bridge shots' 10-20 deg Dutch angles are real).
- Camera height now takes Keyes' first floor-trace shift (0.1.1 run: -3.6 cm at the first bridge frame), so
  the shot keeps the original's height relative to him on the remake's floor.
- 0.1.1 floor trace verified by the creator: Keyes no longer sinks. 0.1.2 is the camera build.



## 2026-10-20 0.1.5-0.1.8 (Claude, overnight)
- 0.1.5 framing guard (scenes.framing): turns/backs the camera to keep Keyes' Head_M in frame; mouth from voice loudness (FACIAL_C_Jaw).
- 0.1.6 Cortana stand-in solid (two-sided, BasicShapeMaterial tinted); test mode logs world + enables dev console.
- 0.1.7 mouth group: lips/teeth/tongue/chin (18 face bones) carried round the jaw pivot.
- 0.1.8 jaw axis kept in the head's frame (was actor yaw: twisted when head turned); body vs look: standing, facing changes
  under 70 deg turn chest/neck/head (LOOK_SHARE), bigger ones turn the body 4 deg/tick; walking turns 12 deg/tick;
  limb rest alignment (bone_map.align): remake legs rest ~10 deg apart, forearms ~30 deg forward -> swung onto CE rest first;
  voice clips padded 0.6 s (cache .v3.mp4): the media player dropped clip ends.
- Remake has NO in-game Cortana mesh (only FX). Creator chose H2A Cortana from MCC halo2/preload/paks/shared.pck
  (<database>:cortana__h.tpl, textures ch_cortana_04*.pct DXT5). Format per Wildenhaus/Index (LibH2A); Python prototype
  devtools/h2a/{pck,tpl}.py decodes the mesh (A-pose, 1.79 m, Y-up). Lua port pending.
- Unattended test start: SetAndBeginCampaign right at the front end loads A15 (world reaches A15 cell) but the screen stays
  black and the intro never triggers; a creator-started run works.

## 2026-10-20 0.2.3 (crew, shoulders, Cortana size)
- Creator played 0.2.2 (manual): H2A Cortana loaded; framing guard swung the hangar shots toward Keyes 100 m away -> framing.max_dist 1200 cm.
- Crew: chairs are vehicles (scenario 0x240/0x24c now parsed); vehicle_load_magic seats the unit at the chair model's "seat" marker
  (gbxmodel markers @0xAC, 64 B; instances @+52, 32 B). Crewman bipd's graph is characters\marine\marine (obje +0x38) -> Scene:graph
  follows the object tag's graph ref. Marine graph has no unarmed stand idles: base_anim falls back unarmed->pistol->rifle, idle%1/idle/%0/%2.
  Seated floor trace starts just above the feet (from z+300 it hits the chair). cam_offset only from the framing subject. keyes_rest.lua only for Keyes.
- Shoulders: remake ShoulderFixup_L/R (AdvancedSkeleton correctives) were stiff -> sheets/fixups.json, half-way between Scapula and Shoulder turn.
- Cortana: CE Cortana is 55 cm tall on a pedestal at z 0.357 (1.09 m); her shots are framed for that. H2A at 1.79 m put the camera
  inside her. h2a.scale "ce" = matched to the CE model's height. Texture recoloured violet via ffmpeg filter (png_suffix .holo2), tint white.
- MCC folder now passed by Melty: settings .env ORIGINAL_CINEMATICS_MCC_DIR={game:halo-mcc}, read by main.lua.
- Release 0.2.3 bd8f01a2 submitted (draft, one-click yes). Untested: creator's game was open.

## 2026-10-20 0.2.58 camera
- Creator's reference (MCC classic): Keyes close, camera to the crewman's right, letterboxed. Ours: framing guard backed the
  camera away from Keyes (min_dist 110) into walls and the crewman's head -> his face vanished up close, Keyes looked far.
- scenes.framing = null (original camera untouched); new column letterbox_aspect 2.39 (CameraComponent constrained aspect,
  bars top/bottom); FOV still widened 4:3 -> 16:9 (Hor+), so the bars only crop.
- Crew uniform colours (creator asked for red/yellow): todo, needs the crewman material's parameter names.
- 0.2.59: shot check log lines (orig vs ours position per cast member, head screen coords) every cut / 15 frames; Keyes lean step 50 cm.
- 0.2.59 run shot check: every cast member stands within 0-2 cm of the original's spot (positions match exactly) except when the
  Keyes 50 cm chair step kicked in: then 100-185 cm off and the floor trace put him on top of the chair/console (+89..+117 cm).
- Shoulder shot (keyes_x10_peer_1a) vs creator's MCC reference: Keyes/crewman screen spacing matches 70 deg horizontal on a
  2.39 frame, not 86 deg (Hor+). 0.2.60: no widening (target_aspect 1.3333), letterbox 2.39; Keyes step removed.
- Open: the roll in peer_1a is 27 deg but Keyes looks upright in the reference; check roll convention with another reference.
- 0.2.61: Hor+ 16:9, no letterbox (fit in devtools/fit_camera.py: original 4:3 vertical framing holds Keyes' head 293/313; bars cut it).

## 2026-10-21 0.2.62 camera ground truth (original engine)
- D:\games\halo ce = open Halo port (Xbox data). Runs hidden: HALO_HIDDEN_WINDOW=1 HALO_NULL_RENDERER=1 HALO_NO_AUDIO=1
  HALO_TELNET_CONSOLE=1 (127.0.0.1:2323). devtools/ce_record_camera.py: map_name a10, then game_time + debug_camera_save
  (camera.txt: pos / forward / up / fov) ~10/s -> probe-out/ce_camera_truth.tsv. Positions = map camera points exactly.
- Facing (devtools/fit_ce_rotation2.py): forward = Rx(c) Ry(-b) Rz(a) x, zero error over 11 still shots; roll always 0.
  Old mapping (yaw/-pitch/roll) was wrong: invented Dutch tilts and wrong up/down on rolled shots.
- Moves: position smootherstep along a line over the script ticks (fit_ce_move.py); facing turns in the last quarter
  (fit_ce_turn.py, window k=4 best of 2..12).
- 0.2.63: crew uniforms = remake's own MI_NavyCrew_Command/Engineer/Science per crewman (hash of name), on slots wearing a
  NavyCrew material (not Anatomy/NamePatch); log "uniform <name>: <mat> (n slots)". Which division is red/yellow/blue: unverified.
- Cortana: offline render (devtools/render_cortana.py [--holo]) shows the H2A model + UVs + textures are right; her texture is a
  grey pattern the H2A shader tints. In game h2a.use "vertex": tinted texture (vertex_filter) -> 256x256 raw cache
  h2a_<tex>.vtx.rgba, sampled per vertex, drawn with /Engine/EngineDebugMaterials/VertexColorMaterial (falls back to tinted).
- 0.2.64: Cortana violet (original CE look) + per-frame shimmer (bands sweeping up, scanlines, flicker) on vertex colours; vtx cache renamed .vtx2.rgba. Still opaque (no see-through yet).
- 0.2.65 camera check (devtools/compare_camera.py, fit_camera_rules.py): cut order and positions match the original; rule
  search over wrap/chain/turn timing/easing: best = facing eases WITH position (late-turn k=4 was a mis-fit), short-way
  angles, interrupting move starts from the current camera. Cut timing drifts up to +67 ticks later in the original by the
  hangar: each voice wait is 7-20 ticks longer in the Xbox data (port) than MCC's voice files; MCC timing kept.
  Worst remaining shots: keyes_peer_walk_1 (3 chained moves), display_walk_1a, alert_1a.
- 0.2.66: music_start (scenes sheet): x10_music01 from 43.5 s at takeover (seek once ready, plus elapsed). Creator: 'video still playing in background' on 0.2.59 run; log shows remake players stopped - asked what exactly.
- 0.2.67: creator heard the remake's video audio (Wwise StopAll every 5 frames already runs) -> _hush_others every 15 frames: stops/logs any playing AudioComponent not ours (and not a MediaSound one) and BinkMediaPlayers.
- 0.2.67 run (creator): much better. Lean: head/neck odd; eye close-up (keyes_to_cortana_2, 12 cm) off to the side (our head x 1.53);
  remake video audio still heard; theme never played: sheet held "\x10" (JSON escape slip) -> "no sound file".
- 0.2.68: theme path fixed, from 0 s; remake intro video blocked as soon as it opens (idle loop, every 10 frames);
  MediaSoundComponents not ours muted; look turn cleared during custom animations (stale walk look twisted the lean);
  scenes.closeup {close_cm 60, fade_cm 100}: camera shifted by (our Head_M - original CE head node posed) near his head.

## 2026-10-21 0.2.70 (close-up camera, hips, sound)
- Root cause of three separate complaints (his face blinking out, the display-glass shot with the camera "too low"
  and a slab of console across the frame, and the crash when he walks away from the chair): the close-up rule
  (scenes.closeup) compared our Keyes' head in MESH space (GetBoneTransformByName, component space) with the
  original's head in WORLD space, so the camera was pushed about 6.7 m sideways and 1 m up. Now ours is put in
  the world first (component location + component rotation * bone offset).
- Hips: the lean's bone location stayed on the pelvis after the custom animation ended, so Keyes walked away
  through the chair and the command console. The rest position is captured before the first location is applied
  and put back when the lean is over.
- Sound: the remake's intro sound is not in an AudioComponent (the hush found none), and the Wwise master RTPC
  (RTPC_Volume_Master) does not reach it. 0.2.70 logs every sound source the remake has (AudioComponent,
  MediaSoundComponent, AkComponent, AkAmbientSound, AkAudioEvent) once per scene, stops the Wwise ones too, and
  no longer skips media sound components in the Unreal sweep. Next run's log names the object that carries it.
- Video: all MediaSource kinds are pointed at a missing file (not just FileMediaSource).
- The log now says which version is running (main.lua).

## 2026-10-21 0.2.71 (back to 0.2.67)
- Creator: 0.2.70 broke the scene. Reverted: the game's mod folder, the project source (mod/) and dist/ now hold the
  0.2.67 scripts; 0.2.71 on Melty is the 0.2.67 code (same zip, new name).
- 0.2.69/0.2.70 work is set aside in mod_source_0.2.70/ (Wwise master mute, near clip, custom-hips, the close-up
  head fix, the hips reset, the sound-source log, the media-source block). Nothing is lost; it is not in the build.
- Lesson: one change at a time, tested, before the next. Three camera/pose changes went out together and the
  scene could not be judged.

## 2026-10-21 0.2.72 (the lean only)
- Root cause of the 0.2.70 mess: GetBoneTransformByName(name, 0) is WORLD (the mod's own world_pos/world_quat
  helpers use mode 0 for world and mode 1 for component space). My 0.2.70 close-up change added the component
  location to an already-world value, and the hips-reset change set a world value in component space: both moved
  things by the character's own position (about 6.7 m). Both are reverted in 0.2.72.
- Hips reset now captures the rest position in component space (mode 1), the same space b.loc is set in.
- Added: 'face seam <name>' log every second during a scripted animation: where the face mesh's head is against
  the body's Head_M, and how far apart they are. That is the measurement for the face disappearing during the lean.

## 2026-10-21 0.2.76 (crash: two null pointers)
- All 13 crash dumps on this PC (18 Oct onwards) are the same: ACCESS_VIOLATION, fault address 0x0, the same code
  spot in ten of them. A native call with a null argument, which Lua's pcall cannot catch.
- 0.2.69's Wwise master-volume hold passed a volume setting that does not exist in this game straight into the
  audio engine (SetRTPCValue(rt or nil, ...)). It never worked (the remake's sound kept playing) and it could kill
  the game. Now the setting is left alone and the log says so.
- The face and body meshes are checked before every frame they are posed: a mesh the engine has dropped is skipped.
- 0.2.75 added the measurement the face work needs: 'head diff <name>' every second (ours vs the original's head,
  where the character is, what is playing). First reading: 5 cm apart during how_did_they, up to 43 cm at the worst
  moment, and the camera is no longer pulled 9.4 m away (0.1 cm and 2.3 cm now).

## 2026-10-21 0.2.77 (crash + Keyes' face)
- Crash proven by disassembly: game+0x72147ce is the exec thunk of UAkGameplayStatics::SetRTPCValue; it calls a
  virtual on the RTPC object (vtable read at a freed address). D:_wwise_master cached the LoadAsset'd UAkRtpc in
  self.rtpc_master; it is not rooted, GC freed it mid-scene, the next 30-frame call crashed. All _wwise_master code
  and calls removed (it never silenced anything). 21:16/21:20 crashes (0.2.69/70) have the same thunk.
- Face vanishing during the lean: 'face seam' was 0 cm, so the face follows; it was culled. Crew got bounds_scale 10
  for this earlier, Keyes kept 1. characters sheet: keyes bounds_scale 10.
- Note: scene never calls near clip during the lean (only at display_rev_1a); untouched.

## 2026-10-21 0.2.78 (camera: smooth, aim, unblock)
- Creator: walk to the chair jerky and Keyes leaves frame; display_rev too low (remake display base fills the
  frame); last Keyes shot (keyes_to_cortana_*) his face out of frame.
- Jerky: the timeline camera changes once per tick (30/s), shown every frame as-is. scenes.smooth_camera: blend
  previous tick -> current by the fraction into the next tick (one tick behind); jumps > jump_cm not blended.
- Walk to chair (peer_walk_2/3): head diff 0.2.77 log: original head z 45 (floor -122), ours 170 -> the remake's
  floor there is ~125 cm higher. scenes.aim: turn camera by angle(orig head -> our head) while orig head is in frame
  and outside closeup fade_cm; cap 30 deg; smoothed; reset on cut. Logs 'aim: turned'.
- display_rev: scenes.unblock: every 10 frames trace camera -> Keyes Head_M/Neck_M/Root_M (first 80%), hide the hit
  component (SetVisibility false) for the shot, restore on cut / finish; logs 'unblock: hid'.
- Last shot: no data yet (0.2.77 run quit before it). If still wrong, read 'aim' and head diff around keyes_to_cortana.

## 2026-10-21 0.2.79 (survey; aim/unblock off)
- 0.2.78 run: creator says camera worse, bobbing. aim chased a phantom: on the walk to the chair the recording's z
  is -0.4 wu (pilot pit level) but the original engine ground-snaps the biped, so the original's head was NOT at 45.
  The "remake floor 1.2 m higher" reading was wrong. unblock re-hit one mesh 4x (hidden meshes still collide).
  Both off in the sheet; smooth_camera kept.
- The world match (remake = CE*304.8, Y flipped) was only ever checked at ONE point (remake Keyes spawn = keyesa10).
  "positions match exactly" in shot logs is circular (ours vs the same converted CE numbers).
- devtools/survey_ce.lua lists CE bridge landmarks: 10 chair pods + 2 pilot chairs (x10_chair_*, pod_*, pilot_*).
- 0.2.79 Stage:survey() writes %LOCALAPPDATA%/OriginalCinematics/survey_remake.tsv once per scene: every static and
  skeletal mesh in the bridge box (mesh, owner class, location, rotation, scale, extent) + FLOOR grid every 50 cm.
  Next: match remake chair meshes to CE chairs, least-squares fit (yaw, scale, offset), floor diff map.
- 0.2.80 run: survey crashed the game (UE4SS null+0x18 read while walking StaticMeshComponents: likely GetOwner()/
  Bounds on an ownerless or pending component; pcall cannot catch it). 1026 rows written, none of them the bridge:
  only loose props / Jeffries-tube pieces. The bridge itself is not plain StaticMeshComponents (instanced or
  packed-level geometry?). Remake's own Keyes actor hidden at UE (-8780,-11482,-1) while ours plays near origin.
  Next survey: line traces only (safe, ISM-proof): a scan of the remake bridge surfaces, no component reads.
- 0.2.81 run: survey at takeover got 1 hit (bridge collision streams in later). Live scan through the dev console
  (devtools/q_scan.lua, run.sh now points at the game's mod folder) mid-scene: probe-out/survey_remake_0281.tsv
  (from z 400: mostly ceiling, ceiling at 341-377). Landmarks (UE cm): remake pilot chairs (850..950, +-100, floor
  -153) vs CE pilot chairs (792, -+121, -137): ~1 m forward, 40 cm closer. Side control stations y +-900..1050 at
  x -1150..-500 and -200..50 = CE side pods (x -78/-659/-994, y +-1048): sides MATCH. Centre: remake
  SM_A15_Bridge_ControlPillar_A (x -550..-100, y +-400, up to 387) where CE has the sunken pit pods 4/5 (-333, +-197,
  z -119). Remake holo table x -1300..-900. Window floor x>=500 at -125.
  CE shots: display_rev_1a cam (449,21,123) -> Keyes flag keyes_x10_display (271,6,0); keyes_to_cortana_1 (297,201,154).
- 0.2.82: survey at tick 150, from z 200 (under ceiling); 'shot line' log 3 frames after every cut: what blocks camera
  -> Keyes Head_M/Root_M (mesh + distance).
- 0.2.82 run (probe-out/run82.log, survey_remake_0282.tsv): shot lines: display_rev_1a camera (449,21,123) is
  ~100 cm BEHIND the remake's SM_UNSC_POA_Bridge_NavConsole_Center_A (hit at x 320-350; Keyes at 271): the
  original looked through a holo display, the remake put a solid console there. keyes_x10_peer_1b blocked by
  NavConsole_Left_A. Last close-up keyes_to_cortana_2 (13 cm): head on screen ours 1.49,1.43 AND orig 1.52,1.75:
  by our own reconstruction even the original's head is off-frame -> our reconstruction of the original at that
  moment is wrong (Keyes' head ~15-18 cm from where the 12 cm camera points). Needs original-engine truth for Keyes.

## 2026-10-21 0.2.92-0.2.93 (bridge done for now; B30 start)
- Bridge: creator happy. panic_1 skipped (skip_objects), others walk_off (run whole time, flee stance, removed at
  keyes_to_cortana_2). shot_adjust final: display_rev_1a up 25, 1b up 15, keyes_to_cortana_2 right 16 up -4 fwd -8.
- B30 request: no remake video; ride in on the pelican first person (like the original's cutscene_insertion after
  camera_control false), marines aboard, dismount on the beach. Original script: probe-out/b30_scripts.txt
  (cutscene_insertion: player0 in insertion_pelican_1 seat p-riderlf, beach_lz_marine/left_marine via
  vehicle_load_magic rider, recording_play_and_hover insertion_pelican_1_in, dialog b30_insert_010..040, exit,
  vehicle_unload rider, pelican flies out insertion_pelican_1_out).
- Remake: video CinematicsPreRenders/B30/m04_SC-cin01_intro, LS_m04_SC-cin01_intro (+ _AUDIO, _AUDIO_VO).
- 0.2.93: test mode mission from <mod>/test_level.txt (now B30). Next: look-around run via dev console.

## 2026-10-22 how the original holds the mission (and what that means here)
- Halo CE's A10 intro is a Blam script, not a video. `x10` (static) does
  `unit_suspended`, `switch_bsp 7`, `object_type_predict` (captain, cortana,
  the chairs), `cinematic_start`, `camera_control true`, then `autumn_glory_1`,
  `autumn_glory_2`, `bridge`, `hangar_cryo`, then the cleanups.
- CE's `mission_a10` (startup) calls it as a function:
  `(if (cinematic_skip_start) (x10))` and only AFTER that returns does it
  `(wake x10_post) (wake mission_bsp) (wake music_a10) ...`.
  So the mission's scripts are literally downstream of the cutscene: it
  cannot start while the cutscene plays. `cinematic_skip_start` is the engine
  call that starts the cinematic (the "skip" button's other end).
- The remake's A15 scenario keeps the same shape: `f_play_cinematic` blocks,
  and the mission's `wake` calls sit behind it. Only the cutscene body was
  swapped for a pre-rendered movie: the Blam `cine` tag is an empty shell
  (0 scenes) that only names which UE5 LevelSequence + MP4 to run.
- The video has no Blam tag. `cinematic` and `cinematic_transition` have no
  movie field (checked with mjolnir fields). The only handle is the UE5
  MediaSource, reached at runtime.
- The video's sound is a `MediaSoundComponent` on a LEVEL actor (not on the
  cutscene), so it outlives the movie; that is why the audio always played
  when the mod only muted it while a scene was already running.
- Reach lives in MCC as `haloreach` (its campaign maps are m05..m70; A10 is
  m10.map). Its scenarios sit in H5 super maps / a legacy pak, which this
  toolchain (ce_map for CE maps, mjolnir for the remake's IoStore) cannot
  read. CE's structure is the template the remake uses, so Reach was not
  needed to answer the question.

## 2026-10-22 changes
- MJOLNIR edit to the A15 scenario: `submit_incident_with_custom_string_id`
  and `pre_bridge_load` moved from AFTER the cinematic call to BEFORE it, so
  the bridge exists while the original cutscene plays while the mission's
  scripts still wait behind the cinematic. Only lines moved: the tag keeps
  its byte length. Override container: pakchunk999-MJOLNIR-Windows_P.*.
- The remake's intro movie on disk
  (Meteorite\Content\Movies\CinematicsPreRenders\A15\m01_POA-cin01_sc01_space\
  m01_POA-cin01_sc01_space.mp4, 370 MB with an AAC track) replaced with the
  creator's own video, stripped of its audio track: no picture of the
  remake's movie, and no audio to play at all. The smaller file also removed
  the repeated close/re-open/re-decode that was stuttering the game.
- The mod now PAUSES the remake's cutscene instead of ending it, so the
  Blam script stays inside f_play_cinematic and the mission cannot start; the
  cutscene is ended when our scene is over, and then the mission starts.
