(global boolean b_debug false)

(global short s_random_squad_spawn_counter 0)
(global boolean b_should_spawn_random_squad true)

(global boolean b_unit_dropped_dropship_a false)

(global boolean b_exit_arrival_pelican false) ;set to true right before the arrival pelican is despawned.

(global vehicle v_pelican none)

(global boolean b_ext_a_spawn true)
(global short s_ext_a_spawn_counter 0)
(global short s_ext_a_squad_index 1)

(global boolean b_crev_ent_turrets true)
(global short s_crev_ent_turret_counter 0)
(global short s_crev_ent_turret_limit 4)

(global long l_default_turret_delay (* 30 10))

(global vehicle v_dropship_a none)
(global boolean ext_b_player_trigger false)
(global vehicle v_dropship_b none)

(global long l_control_turret_delay (* 30 10))
(global boolean b_marines_halted false)

(global short s_enc_obj_con 0)

(global boolean b_snwfld_a_vista_combat true) ; feature flag to turn off combat in the snwfld a vista.  when set to false, the vehicles will spawn but the pilots won't

; opening sequence tuning variables
(global real r_sec_to_player_control 9) ; used by both objectives and navpoints to time the boots hitting the ground
(global real r_sec_navpoint_delay 3) ; used by the first navpoint so it's timed with the objective appearance

(global boolean b_bunker_marines_can_advance false) ; true if the player wipes out the shades pinning the marines on the cave slope. used by bunker encounter and checkpointing

; tracking when dialog lines have played to trigger navpoints, spawns, and objectives
(global boolean b_zulupelicancallsforhelp false)
(global boolean b_cortanahascalledoutrendezvous false)
(global boolean b_fireteamzulufoundinsnowfielda false)
(global boolean b_cortanahascalledoutscorpion false)
(global boolean b_cortanahascalledouticetunnel false)
(global boolean b_cortanahascalledouttunnela false)
(global boolean b_cortanahascalledoutchasmdoor false)
(global boolean b_cortanahastoldbisentitowait false)
(global boolean b_cortanahascalledoutziggurat false)

(script startup b40_start
	(submit_incident_with_custom_string_id "game_activity_begin" "b40")
	(ai_allegiance player human)
	(b40_insertion_point_fixups)
	(f_start_auto_save_loop)

	(wake f_setup_fireteam_params)

	; wake the other chapter titles and objectives
	; first chapter title & objective are part of the intro sequence and is woken there for timing purposes
	(wake play_chapter_title_rolling_thunder)
	(wake play_chapter_title_control)

	(wake play_objective_zulu_nonblocking)
	(wake play_objective_push_nonblocking)
	(wake play_objective_push_jetpack_nonblocking)
	(wake play_objective_substructure_nonblocking)
	(wake play_objective_ziggurat_nonblocking)
	(wake play_objective_head_control_room_nonblocking)

	(wake game_win_script)

	(wake b40_music_controller)
	(wake b40_rally_point_unlocks)

	(f_kill_all_continuous)

	; beat 1
	(if (f_insertion_point_area_pending ins_b1_start) (wake mission_b1_main))
	(if (f_insertion_point_area_pending ins_b1_bridge) (wake mission_b1_middle))
	(if (f_insertion_point_area_pending ins_b1_elevator) (wake mission_b1_end))

	; beat 2
	(if (f_insertion_point_area_pending ins_b2_start) (wake mission_b2_main))
	(if (f_insertion_point_area_pending ins_b2_scorpion) (wake mission_b2_main))
	(if (f_insertion_point_area_pending ins_b2_postchasm) (wake mission_b2_middle))

	; beat 3
	(if (f_insertion_point_area_pending ins_spiral) (wake mission_ext_b_bunker))
	(if (f_insertion_point_area_pending ins_b3_start) (wake mission_b3_main))
	; beat 4
	(if (f_insertion_point_area_pending ins_b4_start) (wake mission_b4))

)

;========== kill all continuous scripts ==========
(script static void f_kill_all_continuous
	(sleep_forever ini_crevasse_turret_a)
	(sleep_forever ini_crevasse_turret_b)
	(sleep_forever ini_crevasse_turret_c)
	(sleep_forever ini_zig_bottom_turrets)
	(sleep_forever ini_zig_control_turrets)
)

;========== random squad spawning ==========
(script static void (f_spawn_random_squads (ai squad_1) (ai squad_2) (ai squad_3) (short squads_to_spawn))
	(set s_random_squad_spawn_counter 0)
	(begin_random
		(if (and b_should_spawn_random_squad (!= squad_1 none))
			(begin
				(ai_place squad_1)
				(sleep 2) ; sleep so that when this function places multiple squads, they are spread out over a few frames.
				(set s_random_squad_spawn_counter (+ 1 s_random_squad_spawn_counter))
				(if (= s_random_squad_spawn_counter squads_to_spawn) (set b_should_spawn_random_squad false))
			)
		)
		(if (and b_should_spawn_random_squad (!= squad_2 none))
			(begin
				(ai_place squad_2)
				(sleep 2) ; sleep so that when this function places multiple squads, they are spread out over a few frames.
				(set s_random_squad_spawn_counter (+ 1 s_random_squad_spawn_counter))
				(if (= s_random_squad_spawn_counter squads_to_spawn) (set b_should_spawn_random_squad false))
			)
		)
		(if (and b_should_spawn_random_squad (!= squad_3 none))
			(begin
				(ai_place squad_3)
				(sleep 2) ; sleep so that when this function places multiple squads, they are spread out over a few frames.
				(set s_random_squad_spawn_counter (+ 1 s_random_squad_spawn_counter))
				(if (= s_random_squad_spawn_counter squads_to_spawn) (set b_should_spawn_random_squad false))
			)
		)
	)
	(set b_should_spawn_random_squad true)
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; b40 missionlevel scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
;creating script for when we load in
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; beat 1 ============================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; insertion point: ins_b1_start =====================================================================================================================================================================
;====================================================================================================================================================================================================

; start game
; play cutscene of foehammer flying in the tunnel
(script dormant mission_insertion
	(f_play_cinematic cinematics\b40\b40_intro.cinematic)
	(set b_intro_cinematic_has_finished true) ; needed for the first encounter so the grunt doesn't begin fleeing early
	(ai_place pelican_arrival_squad)
	(players_into_arrival_pelican)

	; lock players gaze to match cinematic (looking out from pelican)
	(player_control_lock_gaze player0 fh_pelican_arrival/player_face 1000)
	(if (coop_players_2) (player_control_lock_gaze player1 fh_pelican_arrival/player_face 1000))
	(if (coop_players_3) (player_control_lock_gaze player2 fh_pelican_arrival/player_face 1000))
	(if (coop_players_4) (player_control_lock_gaze player3 fh_pelican_arrival/player_face 1000))

	(device_set_power insertion_door_back 1)

	(wake mission_b1_main_navpoints)

	; chapter titles and objectives
	(wake play_chapter_title_daddy)
	(wake play_objective_find_control_room_nonblocking)

	; vo
	(wake vo_tower_intro)
	(wake vo_arena_a)

	(sleep (game_ticks_from_seconds 1))
	; unlock player gaze
	(player_control_unlock_gaze player0)
	(if (coop_players_2) (player_control_unlock_gaze player1))
	(if (coop_players_3) (player_control_unlock_gaze player2))
	(if (coop_players_4) (player_control_unlock_gaze player3))
)

(global boolean b_intro_cinematic_has_finished false) ; used by encounter so this grunt doesn't scream early
(global boolean b_flee_grunt_finished false) ; used by encounter so this grunt rejoins the others
(script dormant encounter_tower
	; place the grunts before the cutscene ends so you can see all the cutscene grunts coming out of the black screen
	(ai_place insertion_cov_grunts_flee)
	(ai_place insertion_cov_grunts_interior)

	; ...but don't let the grunts in the interior open the door early, they just need to be seen by 2p and 4p.
	(ai_braindead insertion_cov_grunts_interior true)

	; then, wait for the cutscene to end and delay an appropriate amount...
	(sleep_until (= (cinematic_in_progress) false) 1)
	(sleep (game_ticks_from_seconds 12.0))

	; and spawn the reinforcement elite and allow the interior grunts to leave
	(ai_place insertion_cov_elites)

	(sleep_until (or
					b_intro_elite_spotted_player ; elites saw the player via the encounter
					(<= (ai_living_count insertion_cov_elites) 0) ; the elites died before making it out the door and never saw the player.
					(= (skull_enabled skull_adaptation) true) ; on remix there is probably not an elite to set the bool, so just send everyone. #elegant
				)
	1
	(game_ticks_from_seconds 3)) ; after 3 seconds continue anyways
	(set b_intro_elite_spotted_player true) ; fall back incase we used the failsafe time out on the sleep_until. this boolean is needed for encounter objective logic.
	(ai_braindead insertion_cov_grunts_interior false)
)

(script dormant encounter_arena_a
	(sleep_until (volume_test_players a1_trigger) 1)
	(ai_place sq_gr_a1_cov_all)
)

(script dormant mission_b1_main
	(place_b1_objects)
	(wake mission_insertion)
	(wake encounter_tower)
	(wake encounter_arena_a)
)

;==============================================================
; command scripts (b1 ; ins_b1_start) =========================
;==============================================================

(script command_script cs_fleeing_grunts
	(cs_ignore_obstacles true)
	(ai_flee_to_point ai_current_squad ps_insertion_fleeing_grunts/flee_point)
)

(global boolean b_intro_elite_spotted_player false)
(script command_script cs_intro_elite_point
	(cs_enable_moving true)
	(cs_enable_dialogue true)
	(cs_enable_targeting true)
	(cs_enable_looking true)

	(set b_intro_elite_spotted_player true)
	(cs_face_player true)
	(cs_action_at_player ai_action_point)
	(cs_face_player false)
)

;===========================
; ==== starting pelican ====
;===========================

; this is all part of the intro sequence. this loads all players in the same pelican and drops them off at level start.
(script static void players_into_arrival_pelican
	(unit_enter_vehicle_immediate player0 (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint) "pelican_p_l05")
	(unit_enter_vehicle_immediate player1 (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint) "pelican_p_r05")
	(unit_enter_vehicle_immediate player2 (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint) "pelican_p_l04")
	(unit_enter_vehicle_immediate player3 (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint) "pelican_p_r04")

	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint) "pelican_p_l05" false false)
	(if (coop_players_2) (vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint) "pelican_p_r05" false false))
	(if (coop_players_3) (vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint) "pelican_p_l04" false false))
	(if (coop_players_4) (vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint) "pelican_p_r04" false false))

)

(script command_script cs_arrival_pelican

	;fly to player drop point.
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_vehicle_speed 0.3)

	(cs_fly_to_and_face fh_pelican_arrival/mid-point fh_pelican_arrival/mid-point_aim)
	(cs_fly_to_and_face fh_pelican_arrival/end fh_pelican_arrival/end_point_aim)

	;dump the players out
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l05")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r05")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l04")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r04")
	(set b_players_unloaded true)

	(sleep (game_ticks_from_seconds 3))

	;fly-out pattern
	(unit_close (ai_vehicle_get_from_spawn_point pelican_arrival_squad/spawnpoint))
	(cs_vehicle_speed 0.5)
	(cs_fly_by fh_pelican_arrival/mid-point)
	(cs_fly_by fh_pelican_arrival/exit_point_1)
	(cs_vehicle_speed .75)
	(cs_fly_by fh_pelican_arrival/exit_point_2)
	(cs_fly_by fh_pelican_arrival/exit_point_3)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.99 (game_ticks_from_seconds 6)) ; this will cause the audio to start fading over 6 seconds
	;(cs_fly_by fh_pelican_arrival/exit_point_4)
	(cs_fly_to_and_face fh_pelican_arrival/exit_point_4 fh_pelican_arrival/exit_point_facing) ; sink out of sight
	(cs_fly_to_and_face fh_pelican_arrival/exit_point_5 fh_pelican_arrival/exit_point_facing) ; sink out of sight
	(set b_exit_arrival_pelican true) ; reactivate the driver_migrator script
	(ai_erase ai_current_squad)
)

;====================================================================================================================================================================================================
; insertion point: ins_b1_bridge ====================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant mission_b1_middle
	(wake mission_b1_save)
	(wake encounter_bridge_a)
	(wake place_and_load_snowfield_a_marines)
	(wake place_snowfld_a_marine_playfighters)
	(wake encounter_arena_b)
	(wake mission_b1_middle_navpoints)
	(wake b1_teleport_and_cleanup_snowfield_a)
	(wake b1_bridge_a_banshee_jetpack_catcher)

	; music vo
	(wake vo_bridge_a_trigger)
	(wake vo_arena_b)
	(wake music_trigger_4)
	(wake music_trigger_5)
)

(script dormant mission_b1_save
	(wake mission_b1_bridge_saves)
	(wake mission_b1_arena_saves)
)

(script dormant mission_b1_bridge_saves
	(sleep_until (volume_test_players a_bridge_save) 1)
	(game_save_no_timeout)

	; so you don't need to play the full bridge again when the elite general kills you
	(sleep_until (volume_test_players tv_checkpoint_bridge_a_pre-gold) 1)
	(game_save_no_timeout)

	; if you beat the general and die to the shade turret, we should have your back
	(sleep_until (= (ai_living_count a_bridge_elites_general) 0) 1)
	(game_save_no_timeout)
)

(script dormant mission_b1_arena_saves
	(sleep_until (volume_test_players a2_top_a_save) 1)
	(game_save_no_timeout)

	(sleep_until (volume_test_players a2_top_b_save) 1)
	(game_save_no_timeout)
)

(script dormant encounter_bridge_a
	(sleep_until (volume_test_players tv_bridge_a) 1)
	(ai_place sq_gr_bridge_a)

	(ai_activity_set a_bridge_grunts_a asleep)
	(ai_activity_set grunts_low asleep)

	(sleep_until (volume_test_players tv_bridge_a_elite) 1)
	(ai_place a_bridge_elites_general)
	(wake music_trigger_3)
)

(script dormant encounter_arena_b
	(sleep_until (volume_test_players a2_top_trigger) 1)
	(ai_place sq_gr_a2_top_cov)

	(wake music_trigger_6_7)
)

;====================================================================================================================================================================================================
; insertion point: ins_b1_elevator ==================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant mission_b1_end
	(wake encounter_smalltunnelk)
	(wake enc_a2_bottom_tunnel)

	; vo music
	(wake vo_elevator_a_trigger)
)

;==============================================================
; encounter scripts (b1 ; ins_b1_elevator) ====================
;==============================================================

(script dormant encounter_smalltunnelk
	(sleep_until (volume_test_players a2_bottom_trigger) 1)

	;despawns the marines we placed originally, they will be replaced
	(ai_erase ext_a_area_a_marines)

	(ai_place ext_a_grunts_lift)
	(ai_activity_set ext_a_grunts_lift asleep)
)

(script dormant enc_a2_bottom_tunnel
	(sleep_until (volume_test_players a2_bottom_save) 1)
	(game_save_no_timeout)

	(sleep_until (volume_test_players ext_a_save) 1)
	(game_save_no_timeout)
)

;==============================================================
; command scripts (b1 ; ins_b1_elevator) ======================
;==============================================================

(global real r_ext_a_pelican_delay 1.5) ; no less than x seconds after the bridge trigger, spawn the pelican
(global real r_ext_a_banshee_delay 0) ; offset for the banshee to follow the pelican
(script dormant place_and_load_snowfield_a_marines
	; ideally, wait for the audio context before spawning the pelican but safety spawn it if the player gets too far down the bridge to the point where you'd see it
	(sleep_until (or b_zulupelicancallsforhelp (volume_test_players tv_bridge_a_pelican)) 1 )

	(ai_place ext_a_area_a_pa)
	(ai_place ext_a_area_a_marines_p)

	(set v_pelican (ai_vehicle_get_from_starting_location ext_a_area_a_pa/pilot_spawn))
	(vehicle_load_magic v_pelican "pelican_p_l01" (ai_get_object ext_a_area_a_marines_p/spawnpoint))
	(vehicle_load_magic v_pelican "pelican_p_l02" (ai_get_object ext_a_area_a_marines_p/spawnpoint1))
	(vehicle_load_magic v_pelican "pelican_p_l03" (ai_get_object ext_a_area_a_marines_p/spawnpoint2))
	(vehicle_load_magic v_pelican "pelican_p_r01" (ai_get_object ext_a_area_a_marines_p/spawnpoint3))

	; place banshee chaser and update bridge aggro
	(ai_place ext_a_bnsh_bp)
	(f_setup_ext_a_pelican_aggro)
)



(script dormant place_snowfld_a_marine_playfighters
	(sleep_until (volume_test_players tv_bridge_a) 1)

	; place the wraith and two turrets early so the field doesn't look so empty
	;(object_create_folder bof_vehicle_cleanup_2_snfld_a_vista) ; we will destroy with this blam object folder, but since everything has to be referenced we'd rather be explicit in this function
	(object_create_if_necessary ext_a_dropship_turret)
	(object_create_if_necessary ext_a_dropship_wraith_a)
	(object_create_if_necessary ext_a_turret_a)

	; if feature flag on, spawn the wraith and far out shade pilots and load them into the vehicles
	(if b_snwfld_a_vista_combat
		(begin
			(ai_place ext_a_area_a_cov_wp_bridge)
			(ai_place ext_a_area_a_cov_tgb_bridge)

			(sleep 1)


			; load the pilots
			(vehicle_load_magic ext_a_dropship_turret "" (ai_actors ext_a_area_a_cov_tgb_bridge))
			(vehicle_load_magic ext_a_dropship_wraith_a "" (ai_actors ext_a_area_a_cov_wp_bridge))

			(ai_prefer_target_ai ext_a_area_a_cov_wp_bridge ext_a_area_a_marines_p true)
			(ai_prefer_target_ai ext_a_area_a_cov_tgb_bridge ext_a_area_a_marines_p true)
		)
	)

	; nobody dies, just this once
	(ai_cannot_die ext_a_area_a_pa true)
	(ai_cannot_die ext_a_area_a_marines_p true)
	(ai_cannot_die ext_a_area_a_cov_wp_bridge true)
	(ai_cannot_die ext_a_area_a_cov_tgb_bridge true)

	(object_cannot_take_damage ext_a_dropship_turret)
	(object_cannot_take_damage ext_a_dropship_wraith_a)
	(object_cannot_take_damage ext_a_turret_a)
)

(script static void cleanup_bridge_a_vista_fighting
	(f_prepare_bridge_a_vista_for_combat)

	(if b_snwfld_a_vista_combat
		(begin
			(ai_vehicle_exit ext_a_area_a_cov_wp_bridge)
			(ai_vehicle_exit ext_a_area_a_cov_tgb_bridge)

			(sleep 1)

			(ai_erase ext_a_area_a_cov_wp_bridge)
			(ai_erase ext_a_area_a_cov_tgb_bridge)
		)
	)

	; banshee should not be around in any circumstances
	(ai_erase ext_a_bnsh_bp)
)

; squads and vehicles are spawned with invincibility so the player can't cheese them.
; however, when the player makes it down to them via banshee or golden path, they need to be able to die.
(script static void f_prepare_bridge_a_vista_for_combat
	(ai_cannot_die ext_a_area_a_pa false)
	(ai_cannot_die ext_a_area_a_marines_p false)
	(ai_cannot_die ext_a_area_a_cov_wp_bridge false)
	(ai_cannot_die ext_a_area_a_cov_tgb_bridge false)

	(object_can_take_damage ext_a_dropship_turret)
	(object_can_take_damage ext_a_dropship_wraith_a)
	(object_can_take_damage ext_a_turret_a)
)

(global real r_wraith_shelling_vista_min 12)
(global real r_wraith_shelling_vista_max 18)
(script command_script cs_cinematic_shelling_vista

	; begin shooting loop
	(sleep_until
		(begin
			(cs_shoot_point true (ai_point_set_get_point ps_snwflda_wraith_targets (random_range 0 (ai_get_point_count ps_snwflda_wraith_targets))))
			(sleep (game_ticks_from_seconds (real_random_range r_wraith_shelling_vista_min r_wraith_shelling_vista_max)))

			(or b_player_skipping_bridge_a (volume_test_players tv_snwfld_a_vista_cleanup)) ; exit condition
		)
	1 )
)

(global boolean b_bridge_pelican_in_range false) ; used to inform the objective editor when the pelican is reasonably close enough to bridge a for the squads to react
(global boolean b_pelican_chase_stop false) ; used to inform the objective editor when the pelican crosses over the bridge
(global boolean b_pelican_pre_unload false) ; used to inform the objective editor when the pelican has unloaded and is headed out
(global boolean b_pelican_post_unload false) ; used to inform the objective editor when the pelican has unloaded and is headed out
; used with squad ext_a_area_a_pa
(script command_script cs_pelican_a
	(set b_pelican_chase_stop false) ; pie fixup, the objective editor doesn't actually reset bools to their declared value when the map is reset
	(set b_pelican_pre_unload false) ; pie fixup, the objective editor doesn't actually reset bools to their declared value when the map is reset
	(set b_pelican_post_unload false) ; pie fixup, the objective editor doesn't actually reset bools to their declared value when the map is reset

	; enable failsafes for the scripted flight path
 	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(f_load_pelican_cargo_vehicle (ai_vehicle_get_from_squad ai_current_squad 0) ext_a_pelican_whog)

	; entry flight path, flies to each point in sequence
	(cs_vehicle_speed 1)
	(cs_fly_by ps_pelican_a_flightpath/p10)
	(cs_fly_by ps_pelican_a_flightpath/p11)
	(cs_fly_by ps_pelican_a_flightpath/p0)
	(set b_bridge_pelican_in_range true)
	(cs_vehicle_speed .8)
	(cs_fly_by ps_pelican_a_flightpath/p1)
	(cs_vehicle_speed .65)
	(cs_fly_by ps_pelican_a_flightpath/p2)
	(cs_vehicle_speed 1)
	(cs_fly_to_and_face ps_pelican_a_flightpath/p4 ps_pelican_a_flightpath/p3 1)

	(set b_pelican_chase_stop true)
	(set b_bridge_pelican_in_range false)

	(ai_disregard (ai_actors ext_a_area_a_pa) true)
	(ai_disregard (ai_actors ext_a_area_a_marines_p) true)
	(ai_disregard v_pelican true)
	(cs_fly_by ps_pelican_a_flightpath/p4)

	(set b_pelican_pre_unload true)

	(f_unload_pelican_cargo	(ai_vehicle_get_from_squad ai_current_squad 0))
	(begin_random
		(begin (vehicle_unload v_pelican "pelican_p_l01") (sleep 5))
		(begin (vehicle_unload v_pelican "pelican_p_l02") (sleep 5))
		(begin (vehicle_unload v_pelican "pelican_p_l03") (sleep 5))
		(begin (vehicle_unload v_pelican "pelican_p_r01") (sleep 5))
	)
	(sleep (game_ticks_from_seconds 3.0))
	(cs_fly_by ps_pelican_a_flightpath/p5)

	(set b_pelican_post_unload true)

	(cs_fly_by ps_pelican_a_flightpath/p6)
	(cs_fly_by ps_pelican_a_flightpath/p7)
	(cs_fly_by ps_pelican_a_flightpath/p8)
	(cs_fly_by ps_pelican_a_flightpath/p9)

	(ai_erase ai_current_squad)
)

(script static void f_setup_ext_a_pelican_aggro
	; upper bridge squads gain awareness...
	(ai_magically_see_object a_bridge_turret_grunts ext_a_area_a_pa)
	(ai_magically_see_object jackals_m ext_a_area_a_pa)
	(ai_magically_see_object a_bridge_jackals_a ext_a_area_a_pa)

	; ...cinematic firepower...
	(ai_vehicle_enter a_bridge_turret_grunts/spawnpoint_t a_bridge_turret_1)
	(ai_vehicle_enter a_bridge_turret_grunts/spawnpoint_t2 a_bridge_turret_2)

	; ....and a burning thirst for sweet sweet pelican blood
	(sleep_until b_bridge_pelican_in_range 1)
	(ai_prefer_target_ai a_bridge_turret_grunts ext_a_area_a_pa true)
	(ai_prefer_target_ai jackals_m ext_a_area_a_pa true)
	;(ai_prefer_target_ai a_bridge_jackals_a ext_a_area_a_pa true)

	; once the moment passes, ignore the pelican because here comes spartan
	(sleep_until (not b_bridge_pelican_in_range) 1)

	(ai_prefer_target_ai a_bridge_turret_grunts ext_a_area_a_pa false)
	(ai_prefer_target_ai jackals_m ext_a_area_a_pa false)
	;(ai_prefer_target_ai a_bridge_jackals_a ext_a_area_a_pa false)

	; can't undo magic sight, so make everyone prefer spartans again
	(ai_prefer_target_team sq_gr_bridge_a player)
)

; banshee didn't exist in legacy on easy/normal... but it looked rad when it attacked the pelican on the higher difficulties
; so, in all difficulties, the banshee should follow the pelican in.  and we'll have it follow
; the pelican out on easy/normal so it doesn't alter the combat.
; and in heroic legendary, we'll have it setup for combat in a way that looks right
(global boolean b_last_boost_state false)
(global boolean b_bridge_a_banshee_peel_off false)
(global boolean b_bridge_a_banshee_combat false)
(script command_script cs_chase_pelican
	; pie fixups - objective editor doesn't actually reset state on bools
	(set b_bridge_a_banshee_peel_off false)
	(set b_bridge_a_banshee_combat false)

	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving true)

	(ai_magically_see ai_current_actor ext_a_area_a_pa)
	(ai_prefer_target_ai ai_current_actor ext_a_area_a_pa true)
	(cs_shoot true)


	; get out of the rock canyon
	(cs_vehicle_boost true)
	(cs_fly_by ps_banshee_a_flightpath/pa2)
	(cs_vehicle_boost false)
	(cs_vehicle_speed 0.45)

	; chase loop
	 (sleep_until
	 	(begin
	 		; use boost to catch up if outside of combat distance, and switch to banshee bomb for variety
	 		(if (> (objects_distance_to_object ai_current_actor v_pelican) 18)
	 			(begin ; banshee is out of range and needs to boost to catch up.  switch to banshee bomb for variety
	 				(if (not b_last_boost_state)
	 					(begin
							(cs_look_object true v_pelican)
							(cs_vehicle_boost true)
	 						(set b_last_boost_state true)
	 						(cs_shoot_secondary_trigger true)
	 					)
	 				)

	 			)
	 			(begin ; banshee is in range and can stop boosting. also, switch back to twin cannons
	 				(if (and b_last_boost_state (<= (objects_distance_to_object ai_current_actor v_pelican) 12))
	 					(begin
	 						(cs_vehicle_boost false)
	 						(set b_last_boost_state false)
	 						(cs_shoot_secondary_trigger false)
	 					)
	 				)
	 			)
	 		)
	 		(or b_pelican_chase_stop (volume_test_object tv_bridge_a_banshee_breakoff ai_current_actor))
	 	)
	 1 )

	; a flashy boost to position in the canyon and not get hijacked easily
	(cs_vehicle_boost true)
	(cs_fly_by ps_banshee_a_flightpath/p2)
	(cs_fly_by ps_banshee_a_flightpath/p3)
	(cs_vehicle_boost false)
	(cs_fly_by ps_banshee_a_flightpath/p4)
	(cs_shoot_secondary_trigger false)

	; last thing in the command script, decide if we're peeling off to chase the pelican (easy/normal) or entering combat
	(if (= (game_difficulty_get) normal) ; remember, game_difficulty_get returns easy as "normal", which is good here
		(begin ; then easy/normal
			(cs_run_command_script ai_current_actor cs_banshee_peel_off_and_follow_pelican)
		)
		(begin ; else heroic/legendary
			; the bridge is now the priority
			(ai_prefer_target_ai ai_current_actor ext_a_area_a_pa false)
			(wake send_off_banshee_after_timer) ; queue up our exit for combat
			(cs_run_command_script ai_current_actor cs_banshee_setup_for_combat)
		)
	)
)

; only boost for the first 3 of the points
(global short s_point_counter 0)
(global short s_boost_limit 3)
(script command_script cs_banshee_peel_off_and_follow_pelican
	(cs_enable_looking true)
	(cs_enable_targeting true)

	; head lower
	(cs_vehicle_speed 0.45)

	(cs_fly_by ps_banshee_a_flightpath/pb4)
	(cs_fly_by ps_banshee_a_flightpath/pb5)
	(cs_fly_by ps_banshee_a_flightpath/pb6)

	(cs_shoot_secondary_trigger true)
	(cs_shoot true)
	; get into banshee bomb position
	(cs_fly_by ps_banshee_a_flightpath/pb7)


	; fly between one of 5 random points until the pelican leaves, boosting every other time
	(sleep_until
		(begin
			(cs_vehicle_speed 0.7)
			; hover below the bridge
			(begin_random
				(begin
					(if (not b_pelican_post_unload)
						(begin ; then the pelican is not done unloading
							(if (= (% s_point_counter 2) 0)
								(begin ; then we should boost
									(cs_vehicle_boost true)
								)
								(begin ; else we shouldn't boost
									(cs_vehicle_boost false)
								)
							)
							(set s_point_counter (+ s_point_counter 1)) ; increment point counter
							(cs_fly_by ps_banshee_a_flightpath_peel/p0) ; fly to the the point
						)
					)
				)
				(begin
					(if (not b_pelican_post_unload)
						(begin ; then the pelican is not done unloading
							(if (= (% s_point_counter 2) 0)
								(begin ; then we should boost
									(cs_vehicle_boost true)
								)
								(begin ; else we shouldn't boost
									(cs_vehicle_boost false)
								)
							)
							(set s_point_counter (+ s_point_counter 1)) ; increment point counter
							(cs_fly_by ps_banshee_a_flightpath_peel/p1) ; fly to the the point
						)
					)
				)
				(begin
					(if (not b_pelican_post_unload)
						(begin ; then the pelican is not done unloading
							(if (= (% s_point_counter 2) 0)
								(begin ; then we should boost
									(cs_vehicle_boost true)
								)
								(begin ; else we shouldn't boost
									(cs_vehicle_boost false)
								)
							)
							(set s_point_counter (+ s_point_counter 1)) ; increment point counter
							(cs_fly_by ps_banshee_a_flightpath_peel/p2) ; fly to the the point
						)
					)
				)
				(begin
					(if (not b_pelican_post_unload)
						(begin ; then the pelican is not done unloading
							(if (= (% s_point_counter 2) 0)
								(begin ; then we should boost
									(cs_vehicle_boost true)
								)
								(begin ; else we shouldn't boost
									(cs_vehicle_boost false)
								)
							)
							(set s_point_counter (+ s_point_counter 1)) ; increment point counter
							(cs_fly_by ps_banshee_a_flightpath_peel/p3) ; fly to the the point
						)
					)
				)
				(begin
					(if (not b_pelican_post_unload)
						(begin ; then the pelican is not done unloading
							(if (= (% s_point_counter 2) 0)
								(begin ; then we should boost
									(cs_vehicle_boost true)
								)
								(begin ; else we shouldn't boost
									(cs_vehicle_boost false)
								)
							)
							(set s_point_counter (+ s_point_counter 1)) ; increment point counter
							(cs_fly_by ps_banshee_a_flightpath_peel/p4) ; fly to the the point
						)
					)
				)
			)

			(set s_point_counter 0)


			b_pelican_post_unload ; exit condition, pelican's leaving
		)

	1 )

	(cs_vehicle_speed 0.45)
	(cs_vehicle_boost true)

	(cs_fly_by ps_banshee_a_flightpath/pb10)
	(cs_fly_by ps_banshee_a_flightpath/pb0)
	(cs_fly_by ps_banshee_a_flightpath/pb1)
	(cs_fly_by ps_banshee_a_flightpath/pb2)
	(cs_vehicle_boost false)
	(cs_fly_by ps_banshee_a_flightpath/pb3)
	(cs_fly_by ps_banshee_a_flightpath/pb_exit)
	(ai_erase ai_current_squad)
)

(script command_script cs_banshee_setup_for_combat
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving true)

	(set b_bridge_a_banshee_combat true) ; unlocks the task in the objective editor, applies long vision, magic sight, and aggressive attitude

	; kick to combat mode
	(ai_braindead ai_current_actor true)
	(sleep 1)
	(ai_braindead ai_current_actor false)
	(cs_force_combat_status 3) ; sets to "active" combat status
	(ai_set_combat_status ai_current_squad dangerous)

	(cs_queue_command_script ai_current_actor cs_backoff_bridge_then_return_to_combat) ; guard against hitting the bridge volume
)

(script command_script cs_backoff_bridge_then_return_to_combat
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving true)

	; if the banshee ever breaks the plane above the bridge...
	(sleep_until (volume_test_object tv_bridge_a_banshee_bridgeguard ai_current_actor) 1)

	; do a flashy boost to reposition out in the canyon and avoid hijack
	(cs_vehicle_boost true)
	(cs_fly_by ps_banshee_a_flightpath/p2)
	(cs_fly_by ps_banshee_a_flightpath/p3)
	(cs_vehicle_boost false)
	(cs_fly_by ps_banshee_a_flightpath/p4)
	(cs_shoot_secondary_trigger false)

	; then loop back to combat
	(cs_run_command_script ai_current_actor cs_banshee_setup_for_combat)
)

; prevent players from having an unlimited time to hijack the banshee and also from being required to kill it
(script dormant send_off_banshee_after_timer
	(sleep_until 	(or
						(= (ai_living_count a_bridge_elites_general) 1)
						(volume_test_players tv_bridge_a_elite)
					)
	1 (game_ticks_from_seconds 30.0))
	(sleep_until (= (ai_living_count a_bridge_elites_general) 0) 1 (game_ticks_from_seconds 30.0)) 	; sleep until the general is dead, or 75 seconds have passed
	(sleep (game_ticks_from_seconds 30.0)) 															; stick around for a bit after the general's death
	(cs_run_command_script ext_a_bnsh_bp cs_banshee_bug_out)
)

; sorry to hurry, but i'm in a jet
(script command_script cs_banshee_bug_out
	(cs_vehicle_boost true)
	(cs_fly_by ps_banshee_a_flightpath/pb10_high)
	(cs_fly_by ps_banshee_a_flightpath/pb1)
	(cs_fly_by ps_banshee_a_flightpath/pb2)
	(cs_vehicle_boost false)
	(cs_fly_by ps_banshee_a_flightpath/pb3)
	(cs_fly_by ps_banshee_a_flightpath/pb_exit)
	(ai_erase ai_current_squad)
)
;====================================================================================================================================================================================================
; beat 2 ============================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; insertion point: ins_b2_start =====================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant mission_b2_main
	(if (f_insertion_point_area_pending ins_b2_middle) ; if we are launching before rally point bravo (b2_scorpion)
		(begin ; then...
			(wake start_snowfield_a)
		)
	)

	; common regardless of insertion point

	; snowfield b
	(wake mission_ext_a_snowfield_b)
	(wake encounter_snowfield_b)
	(wake show_scorpion_tooltip)
	(wake vo_scorpion_destroyed)
	(wake vo_snowfield_b_reunion_trigger)
	(wake vo_snowfield_b_cleared_trigger)

	; snowfield c
	(wake encounter_snowfield_c)
	(wake chasm_door_monitor)
	(wake vo_snowfield_c_ice_tunnel)
	(wake vo_snowfield_c_intro_trigger)
	(wake vo_snowfield_c_wraith_destroyed)
	(wake vo_snowfield_c_clear)
	(wake vo_tunnel_a_door)
	(wake music_trigger_12)

	; navigation
	(wake mission_b1_end_navpoints)
	(wake mission_b2_main_navpoints)
)

(script dormant chasm_door_monitor
	(sleep_until (> (device_group_get chasm_door_position) 0) 1) ; wait for the switch to be hit
	(device_set_power dm_tun_garage_3 1); turn the power on so the door turns green before it opens
	(device_set_position dm_tun_garage_3 1) ; open the door
	; door is set to "not close automatically"
	(set s_music_trigger_b40 130)
)

(script dormant f_rally_point_add_scorpion_marines_to_followers
	(sleep_until (>= (ai_living_count ext_a_area_b_marines) 1) 1)
	(f_add_squad_to_fireteam_followers ext_a_area_b_marines)
)


(script dormant start_snowfield_a
	(sleep_until (volume_test_players ext_a_trigger) 1) ; consider how this might handle jetpack - maybe we should be spawning the vehicles down below early
	(game_save_no_timeout)
	(wake encounter_snowfield_a)

	; vo music
	(wake music_trigger_10)
	(wake vo_snowfield_a_hijack_tip)
	(wake vo_snowfield_a_warthog_destroyed)
	(wake vo_snowfield_a_warning)
	(wake vo_snowfield_a_tank_clear)
	(wake vo_snowfield_a_reunion_trigger)
	(wake vo_snowfield_a_scorpion)
)

(script dormant encounter_snowfield_a
	;(sleep_until
	;(or
	;	(f_insertion_point_matches ins_b2_scorpion)
	;	(volume_test_players ext_a_trigger)
	;)1)

	(f_encounter_snowfield_a_placements)
	(f_encounter_snowfield_a_vehicles_setup)

	(sleep_until
		(or
			(f_insertion_point_matches ins_b2_scorpion)
			(volume_test_players ext_a_area_a_follow)
		)
	1)

	(f_encounter_snowfield_a_conditional_spawns)
)

(script dormant encounter_snowfield_b
	(sleep_until
		(or
			(f_insertion_point_matches ins_b2_scorpion)
			(volume_test_players ext_a_area_b_trigger)
		)
	1 )

	; spawn the marines and then the covies
	(f_enc_ext_a_area_b_mar)
	(f_enc_ext_a_area_b)

	; queue up tank ghosts if the player takes the tank
	(wake encounter_snowfield_b_create_tank_ghosts)

	; when we reach the tank decision point...
	; if the player created enough room for more squads...
	(sleep_until (volume_test_players np_trigger_8b_snowfield_b_tank_decision) 1)

	(if (< (ai_living_count ext_a_area_b_cov) 6)
		(begin ;then there's room for extra squads
			(wake enc_ext_a_area_b_2)
		)
	)
)


(script dormant encounter_snowfield_b_create_tank_ghosts
	; we need to spawn the ghosts when the player rounds the corner, so either spawn them or "time out" if the player hits the volume
	(sleep_until (or (f_player_is_driving_tank) (volume_test_players ext_a_area_b_ghosts)) 1)
	(if (f_player_is_driving_tank)
		(begin
			(ai_place ext_a_area_b_cov_gap)
			(ai_place ext_a_area_b_cov_gbp)
			(sleep 1)
			(vehicle_load_magic ext_a_area_b_ghost_a "" (ai_actors ext_a_area_b_cov_gap))
			(vehicle_load_magic ext_a_area_b_ghost_b "" (ai_actors ext_a_area_b_cov_gbp))

			(f_ai_magically_see_players ext_a_area_b_cov_gap)
			(f_ai_magically_see_players ext_a_area_b_cov_gbp)
		)
	)
)

(script dormant encounter_snowfield_c
	(sleep_until
		(or
			(volume_test_players ext_a_area_c_trigger_a)
			(volume_test_players ext_a_area_c_trigger_b)
		)
	1 )

	(f_ini_ext_a_c_dropship_b)
	(f_ini_ext_a_c_dropship_c)
	(wake enc_ext_a_area_c_cov)
	(wake ini_ext_a_area_c_turrets)
	(wake ini_ext_a_area_c_banshee) ; reinforcement banshee
)

(script static void f_encounter_snowfield_a_placements
	(ai_place ext_a_area_a_marines_ini)
	(ai_place sq_gr_snowfield_a_back)
	(ai_place sq_gr_snowfield_a_front)
	(ai_place sq_gr_snowfield_a_vehicles)
	(f_spawn_random_squads ext_a_area_a_cov_je ext_a_area_a_cov_ge none s_ext_a_squad_index)

	; begin the timer until fighting turns lethal and the wraith starts fighting
	(wake snowfield_a_playfighting_timer)
)

(global boolean b_snwfld_a_cov_wraithstart false)
(global boolean b_snwfld_a_cov_playfight false)
(script dormant snowfield_a_playfighting_timer
	(set b_snwfld_a_cov_wraithstart false)
	(set b_snwfld_a_cov_playfight false)
	(sleep (game_ticks_from_seconds 8.0))
	(set b_snwfld_a_cov_wraithstart true)
	(sleep (game_ticks_from_seconds 6.0))
	(set b_snwfld_a_cov_playfight true)
)

; returns true when the ghost, two shades, and all forward infantry have been defeated in snowfield a.  back of house infantry may still be present, so this is not a "snowfield a clear" check
; used in the objective editor to get them to join your firetream
(script static boolean f_zulu_marines_turrets_and_ghosts_gone
	(=
		(+
			(ai_living_count ext_a_area_a_cov_ga)
			(ai_living_count ext_a_area_a_cov_gpa)
			(ai_living_count ext_a_area_a_cov_tgb)
		)
	0 )
)

(script static boolean f_zulu_marines_no_longer_pinned_down
	(and
		(f_zulu_marines_turrets_and_ghosts_gone)
		(=
			(+
				(ai_living_count ext_a_area_a_cov_ge)
				(ai_living_count ext_a_area_a_cov_je)
				(ai_living_count ext_a_area_a_cov_gg)
				(ai_living_count ext_a_area_a_cov_jg)
				(ai_living_count ext_a_area_a_cov_nag)
				; vista squads use this same check, so include them
				(ai_living_count ext_a_area_a_cov_tgb_bridge)
			)
		0 )
		)
)

; time for your closeups, greenhorns.  make sarge proud.
(script command_script cs_magic_see_zulu_marines_mutual
	(ai_magically_see ai_current_actor ext_a_area_a_marines_ini)
	(ai_magically_see ext_a_area_a_marines_ini ai_current_actor)
)

(script static void f_encounter_snowfield_a_vehicles_setup
	(object_create_anew ext_a_pelican_whog)
	(object_create_if_necessary ext_a_dropship_wraith_a)
	(object_create_if_necessary ext_a_turret_a)
	(object_create_if_necessary ext_a_dropship_turret)

	(sleep 1)

	; tell the pilot to walk to the ghost
	(ai_vehicle_enter ext_a_area_a_cov_gpa ext_a_dropship_ghost_a)

	; load the shades
	(vehicle_load_magic ext_a_turret_a "" (ai_actors ext_a_area_a_cov_ga))
	(vehicle_load_magic ext_a_dropship_turret "" (ai_actors ext_a_area_a_cov_tgb))

	; and setup the wraith
	(vehicle_load_magic ext_a_dropship_wraith_a "" (ai_actors ext_a_area_a_cov_wp))
	(f_update_wraith_shelling_frequency_on_higher_difficulties)

	(sleep 1) ; wait a moment for the vehicle load
	(cs_run_command_script ext_a_area_a_cov_wp cs_cinematic_shelling)
	(sleep 1) ; sigh, wait a moment so the attached doesn't blow through
	(wake set_wraith_abort_on_damage)
)

(global real r_wraith_shelling_timer_min 9.0)
(global real r_wraith_shelling_timer_max 14.0)

; shell more insistently on heroic and legendary
(script static void f_update_wraith_shelling_frequency_on_higher_difficulties
	(if (not (= (game_difficulty_get) normal))		;game_difficulty_get returns "normal" for easy and normal, so this is heroic and legendary only
		(begin
			(set r_wraith_shelling_timer_min 6.0)
			(set r_wraith_shelling_timer_max 11)
		)
	)
)

(global boolean b_wraith_can_break_off false)
(script command_script cs_cinematic_shelling
	; make the wraith docile for an initial period so the shades can take the player's attention, even if the player shoots the wraith
	(sleep_until b_snwfld_a_cov_wraithstart 1)

	(set b_wraith_can_break_off true)		; this tells the aiobjective that an abort is possible

	; begin shooting loop
	(sleep_until
		(begin
			(print "taking a shot")
			(cs_shoot_point true (ai_point_set_get_point ps_snwflda_wraith_targets (random_range 0 (ai_get_point_count ps_snwflda_wraith_targets))))
			(sleep (game_ticks_from_seconds (real_random_range r_wraith_shelling_timer_min r_wraith_shelling_timer_max)))

			(f_snwfld_a_wraith_should_stop_shelling) ; exit condition
		)
	1 )
)

; make this a static so that it can be used in the the task and the cs loop
(global boolean b_wraith_cs_aborted false)
(script static boolean f_snwfld_a_wraith_should_stop_shelling
	(or
		b_wraith_cs_aborted																				; this is for the ai_objective, the command script will take care of itself
		(= (+ (ai_living_count ext_a_area_a_marines_ini) (ai_living_count sq_player_followers)) 0) 			; no marines left to shell
		(volume_test_players tv_snflda_wraith_aggro)														; player advances into wraith's half of snowfield
		(and																								; on easy normal, let players clear out the whole field before dealing with the wraith
			(= (game_difficulty_get) normal)
			(f_zulu_marines_no_longer_pinned_down)
		)
		(and
			(not (= (game_difficulty_get) normal))														; on heroic/legendary, pivot the wraith as soon as the other vehicle threats are gone.
			(f_zulu_marines_turrets_and_ghosts_gone)
		)
	)
)

(script dormant set_wraith_abort_on_damage
	(set b_wraith_cs_aborted false) ; pie fixup
	(ai_disregard (ai_actors ext_a_area_a_cov_wp) true) ; make all ai ignore the wraith so they don't damage it
	; wait until the shelling stops for any reason (exit condition or damage abort)
	(sleep_until (not (cs_command_script_attached ext_a_area_a_cov_wp cs_cinematic_shelling)) 1)
	(ai_disregard (ai_actors ext_a_area_a_cov_wp) false) ; marines can't damage the wraith out of cinematic shelling anymore, so they can shoot
	(set b_wraith_cs_aborted true)
)

; it's no fun when the marines get roasted.  put this on all the tasks the wraith moves to so it follows you
(script command_script cs_prefer_players
	(ai_prefer_target_team ai_current_actor player)
)

(script command_script cs_shade_shoot_point_for_seconds
	(cs_abort_on_damage true)
	(sleep_until
		(begin
			(cs_shoot_point true (ai_point_set_get_point ps_snwflda_shade_targets (random_range 0 (ai_get_point_count ps_snwflda_shade_targets))))

			 b_snwfld_a_cov_playfight ; exit condition, rely on timeout
		)
	1 (game_ticks_from_seconds 15)) ; this is the timeout version of sleep until
)


(script static void f_encounter_snowfield_a_conditional_spawns
	(if (< (ai_living_count ext_a_area_a_cov) 10)
		(ai_place ext_a_area_a_cov_jo)
		(ai_place ext_a_area_a_cov_eo)
	)
	(if (< (ai_living_count ext_a_area_a_cov) 10)
		(ai_place ext_a_area_a_cov_jq)
	)
)

(script dormant mission_ext_a_snowfield_b
	(sleep_until
		(or
			(volume_test_players ext_a_area_c_trigger_a)
			(volume_test_players ext_a_area_c_trigger_b)
		)
	1)

	(game_save_no_timeout)
	(set s_ext_a_squad_index 3)

	(sleep_until (volume_test_players tv_wraith_engaged) 1)
	(game_save_no_timeout)
)

; show scorpion tank tooltip after player first enters vehicle
(script dormant show_scorpion_tooltip
	;(sleep_until (vehicle_test_seat_unit_list ext_a_tank "scorpion_d" (players)) 1)
	(sleep_until (f_player_is_driving_tank) 1)
	(hud_set_training_text "training_entered_tank")
	(hud_show_training_text true)

	(sleep (* 30 10))
	(hud_show_training_text false)
)

; returns true if the player is currently driving any scorpion tank.  no, it doesn't check wraiths.
(script static boolean f_player_is_driving_tank
	(any_players_in_vehicle_type s_vehicle_type_scorpion)
)

; returns true if the player is currently driving any warthog
(script static boolean f_player_is_driving_warthog
	(any_players_in_vehicle_type s_vehicle_type_warthog)
)

;==============================================================
; encounter scripts (b2 ; ins_b2_start) =======================
;==============================================================
(script static void f_enc_ext_a_area_b_mar
	(ai_place ext_a_area_b_marines_unique)
	(sleep 2)
	(ai_place ext_area_b_marines_scorp)
)

(script static void f_enc_ext_a_area_b
	; spacing out these placements like we do on the tarmac so they don't all spawn on the same frame. whole thing should happen over the course of a second
	(ai_place ext_a_area_b_cov_eu)
	(sleep 2)

	(ai_place ext_a_area_b_cov_ee)
	(sleep 2)

	(ai_place ext_a_area_b_cov_ge)
	(sleep 2)

	(ai_place ext_a_area_b_cov_je)
	(sleep 2)

	(f_spawn_random_squads ext_a_area_b_cov_gu ext_a_area_b_cov_ju none s_ext_a_squad_index)

	; let the marines and elites from both sides see each other
	(ai_magically_see ext_a_area_b_marines ext_a_area_b_cov_bug_audio_out)
	(ai_magically_see ext_a_area_b_cov_bug_audio_out ext_a_area_b_marines)
	(ai_magically_see ext_a_area_b_cov_bug_audio_out ext_a_area_b_marines)
)

; fired from the fallback script rather than a specific squad because there's a good chance the initial elites die
(script command_script cs_board_snwld_ghost_c
	(ai_vehicle_enter ai_current_actor ext_a_area_b_ghost_c)
)

(script dormant enc_ext_a_area_b_2
	; when it is time to spawn conditional reinforcements, pick either the goalies for the tank or the ice cave for on foot, but not both
	(if (f_player_is_driving_tank)
		(begin ; tank path, ensure the goalies are present
			(ai_place ext_a_area_b_cov_ek) ; place a guaranteed goalie squad, the elite
			(sleep 2) ; spacing out spawns over a few frames
			(place_random_snwfld_c_tank_goalie_squads)
		)
		(begin ; else on foot, so put some infantry on the ice cliffs.  objective will bring them into the tunnel as needed
			(ai_place ext_a_area_b_cov_eq) ; place a guaranteed ice cave squad, the elite
			(sleep 2) ; spacing out spawns
			(place_random_snwfld_c_ice_cave_squads)
		)
	)
)

(script static void place_random_snwfld_c_tank_goalie_squads
	; randomly place one of two goalie squads
	(begin_random
		(if b_ext_a_spawn
			(begin
				(ai_place ext_a_area_b_cov_gk)
				(sleep 2)
				(set s_ext_a_spawn_counter (+ 1 s_ext_a_spawn_counter))
				(if (= s_ext_a_spawn_counter s_ext_a_squad_index) (set b_ext_a_spawn false))
			)
		)
		(if b_ext_a_spawn
			(begin
				(ai_place ext_a_area_b_cov_jk)
				(sleep 2)
				(set s_ext_a_spawn_counter (+ 1 s_ext_a_spawn_counter))
				(if (= s_ext_a_spawn_counter s_ext_a_squad_index) (set b_ext_a_spawn false))
			)
		)
	)
	(set s_ext_a_spawn_counter 0)
	(set b_ext_a_spawn true)
)

(script static void place_random_snwfld_c_ice_cave_squads
	; randomly place one of two squads in the ice cave
	(begin_random
		(if b_ext_a_spawn
			(begin
				(ai_place ext_a_area_b_cov_gq)
				(sleep 2)
				(set s_ext_a_spawn_counter (+ 1 s_ext_a_spawn_counter))
				(if (= s_ext_a_spawn_counter s_ext_a_squad_index) (set b_ext_a_spawn false))
			)
		)
		(if b_ext_a_spawn
			(begin
				(ai_place ext_a_area_b_cov_jq)
				(sleep 2)
				(set s_ext_a_spawn_counter (+ 1 s_ext_a_spawn_counter))
				(if (= s_ext_a_spawn_counter s_ext_a_squad_index) (set b_ext_a_spawn false))
			)
		)
	)
	(set s_ext_a_spawn_counter 0)
	(set b_ext_a_spawn true)

)

(script static void f_ini_ext_a_c_dropship_b
	(ai_place ext_a_area_c_cov_wbp) ; field wraith
	(ai_place ext_a_area_c_cov_wcp) ; cliff wraith
	(vehicle_load_magic crev_ent_wraith_b "" (ai_actors ext_a_area_c_cov_wbp))
	(vehicle_load_magic crev_ent_wraith_c "" (ai_actors ext_a_area_c_cov_wcp))
)

; used by the cliff wraith objective to gate it moving to aggressive mode
(global boolean b_cliffwraithdonewaiting false)
(script static void f_cliff_wraith_wait
	(sleep (game_ticks_from_seconds 12))
	(set b_cliffwraithdonewaiting true)
)

; verb combat status?  nay. noun combat status.
(script command_script cs_goose_combat_status
	(ai_set_combat_status ai_current_squad dangerous)
)

(script static void f_ini_ext_a_c_dropship_c
	(ai_place ext_a_area_c_cov_gap)
	(ai_place ext_a_area_c_cov_gbp)
	(ai_place ext_a_area_c_cov_gcp)

	(vehicle_load_magic crev_ent_ghost_a "" (ai_actors ext_a_area_c_cov_gap))
	(vehicle_load_magic crev_ent_ghost_b "" (ai_actors ext_a_area_c_cov_gbp))
	(vehicle_load_magic crev_ent_ghost_c "" (ai_actors ext_a_area_c_cov_gcp))

	(f_ai_magically_see_players ext_a_area_c_cov_gap)
	(f_ai_magically_see_players ext_a_area_c_cov_gbp)
	(f_ai_magically_see_players ext_a_area_c_cov_gcp)
)

(script dormant enc_ext_a_area_c_cov
	(set s_ext_a_spawn_counter 0)
	(set b_ext_a_spawn true)

	(ai_place ext_a_area_c_cov_jq)

	(sleep_until
		(or
			(volume_test_players marines_objective_trigger_2) ; volumes at the very end of the two paths that lead to the area where there is the entrance to the tunnel
			(volume_test_players marines_objective_trigger_3)
		)
	1)
	; place the hunters a bit later so that the player can see them running uphill, not already stationed on the top
	(ai_place ext_a_area_c_cov_h)
)

(script dormant ini_ext_a_area_c_turrets
	(begin_random
		(if b_crev_ent_turrets
			(begin
				(wake crev_ent_turret_a)
				(set s_crev_ent_turret_counter (+ 1 s_crev_ent_turret_counter))
				(if (= s_crev_ent_turret_counter s_crev_ent_turret_limit) (set b_crev_ent_turrets false))
			)
		)
		(if b_crev_ent_turrets
			(begin
				(wake crev_ent_turret_b)
				(set s_crev_ent_turret_counter (+ 1 s_crev_ent_turret_counter))
				(if (= s_crev_ent_turret_counter s_crev_ent_turret_limit) (set b_crev_ent_turrets false))
			)
		)
		(if b_crev_ent_turrets
			(begin
				(wake crev_ent_turret_c)
				(set s_crev_ent_turret_counter (+ 1 s_crev_ent_turret_counter))
				(if (= s_crev_ent_turret_counter s_crev_ent_turret_limit) (set b_crev_ent_turrets false))
			)
		)
		(if b_crev_ent_turrets
			(begin
				(wake crev_ent_turret_d)
				(set s_crev_ent_turret_counter (+ 1 s_crev_ent_turret_counter))
				(if (= s_crev_ent_turret_counter s_crev_ent_turret_limit) (set b_crev_ent_turrets false))
			)
		)
		(if b_crev_ent_turrets
			(begin
				(wake crev_ent_turret_e)
				(set s_crev_ent_turret_counter (+ 1 s_crev_ent_turret_counter))
				(if (= s_crev_ent_turret_counter s_crev_ent_turret_limit) (set b_crev_ent_turrets false))
			)
		)
	)
	(set s_crev_ent_turret_counter 0)
	(set b_crev_ent_turrets true)
)

(script dormant crev_ent_turret_a
	(ai_place ext_a_area_c_cov_tag)
	(ai_vehicle_enter ext_a_area_c_cov_tag crev_ent_turret_a)
)

(script dormant crev_ent_turret_b
	(ai_place ext_a_area_c_cov_tbg)
	(ai_vehicle_enter ext_a_area_c_cov_tbg crev_ent_turret_b)
)

(script dormant crev_ent_turret_c
	(ai_place ext_a_area_c_cov_tcg)
	(ai_vehicle_enter ext_a_area_c_cov_tcg crev_ent_turret_c)
)

(script dormant crev_ent_turret_d
	(ai_place ext_a_area_c_cov_tdg)
	(ai_vehicle_enter ext_a_area_c_cov_tdg crev_ent_turret_d)
)

(script dormant crev_ent_turret_e
	(ai_place ext_a_area_c_cov_teg)
	(ai_vehicle_enter ext_a_area_c_cov_teg crev_ent_turret_e)
)

; snowfield c reinforcement banshee
(script dormant ini_ext_a_area_c_banshee
	; two checks here - the trigger condition for the banshee unique to each difficulty, and a wraith safety for normal/heroic so we don't overwhelm you.  effect is:
		; on normal, only trigger the banshee when the player has killed both wraiths and entered the snowfield
		; on heroic, trigger the banshee spawn either when the player has killed one wraith and advanced far enough into the field, or hangs back and kills both wraiths
		; on legendary, trigger the banshee spawn on the trigger volume or the first dead wraith
	(sleep_until (and
					(f_snwfld_c_player_has_advanced_far_enough_xor_hung_back_and_killed_enough_wraiths)
					(f_snwfld_c_banshee_wont_overwhelm_player)
				)
	1 )

	; spawn the banshee
	(object_create_if_necessary ext_a_area_c_banshee)
	(sleep 1) ; let the banshee exist before entering via the command script
	(ai_place ext_a_area_c_cov_bp)
	; command script on spawn point handles banshee entrance for easier editor testing
)

; this is the trigger condition for the spawn
(script static boolean f_snwfld_c_player_has_advanced_far_enough_xor_hung_back_and_killed_enough_wraiths
	(or
		(and													; on easy/normal, you have to actually enter the snowfield, even if the wraiths are dead (handled by safety) to spawn the banshee
			(= (game_difficulty_get) normal)
			(volume_test_players tv_snwfld_c_banshee_aggro)
		)
		(and													; on heroic, entering the snowfield or hanging back and kill both wraiths will spawn the banshee
			(= (game_difficulty_get) heroic)
			(or
				(volume_test_players tv_snwfld_c_banshee_aggro)
				(<= (ai_living_count ext_a_area_c_cov_wraiths) 0)
			)
		)
		(and													; on legendary, entering the snowfield or killing one wraith will spawn the banshee
			(= (game_difficulty_get) legendary)
			(or
				(<= (ai_living_count ext_a_area_c_cov_wraiths) 1)
				(volume_test_players tv_snwfld_c_banshee_aggro)
			)
		)
	)
)

; this is the wraith safety
(script static boolean f_snwfld_c_banshee_wont_overwhelm_player
	(or
		(and													; on easy/normal, block banshee spawn if the *either* wraith is alive
			(= (game_difficulty_get) normal)
			(<= (ai_living_count ext_a_area_c_cov_wraiths) 0)
		)
		(and													; on heroic, block banshee spawn if both wraiths are alive
			(= (game_difficulty_get) heroic)
			(<= (ai_living_count ext_a_area_c_cov_wraiths) 1)
		)
		(and													; on legendary, you're a big spartan and this safety is disabled
			(= (game_difficulty_get) legendary)
			true
		)
	)
)

(script command_script cs_get_in_snowfield_c_banshee
	(ai_vehicle_enter_immediate ai_current_actor ext_a_area_c_banshee)
)

(global boolean b_snowfield_a_ai_full_lod_a false)
(script continuous snowfield_a_ai_full_lod_a
	(if (not b_snowfield_a_ai_full_lod_a)
		(begin
			(sleep_until (volume_test_players snowfield_a_ai_full_lod_area_a) 1)
			(set b_snowfield_a_ai_full_lod_a true)

			(ai_force_full_lod ext_a_area_a_cov)
			(ai_force_full_lod ext_a_bnsh_bp)
			(ai_force_full_lod ext_a_area_a_marines)
		)
	)
)

(script continuous snowfield_a_ai_clear_lod_a
	(if b_snowfield_a_ai_full_lod_a
		(begin
			(sleep_until (volume_test_players snowfield_a_ai_clear_lod_area_a) 1)
			(set b_snowfield_a_ai_full_lod_a false)

			(ai_clear_lod ext_a_area_a_cov)
			(ai_clear_lod ext_a_bnsh_bp)
			(ai_clear_lod ext_a_area_a_marines)
		)
	)
)

(global boolean b_snowfield_a_ai_full_lod_b false)

(script continuous snowfield_a_ai_full_lod_b
	(if (not b_snowfield_a_ai_full_lod_b)
		(begin
			(sleep_until (volume_test_players snowfield_a_ai_full_lod_area_b) 1)
			(set b_snowfield_a_ai_full_lod_b true)

			(ai_force_full_lod ext_a_area_b_cov)
			(ai_force_full_lod ext_a_area_a_marines_p)

			(ai_clear_lod ext_a_area_a_cov)
			(ai_clear_lod ext_a_bnsh_bp)
			(ai_clear_lod ext_a_area_a_marines)
		)
	)
)

(script continuous snowfield_a_ai_clear_lod_b
	(if b_snowfield_a_ai_full_lod_b
		(begin
			(sleep_until (or (volume_test_players snowfield_a_ai_clear_lod_area_b_forward)
			(volume_test_players snowfield_a_ai_clear_lod_area_b_backward)) 1)

			(set b_snowfield_a_ai_full_lod_b false)

			(ai_clear_lod ext_a_area_b_cov)
			(ai_clear_lod ext_a_area_a_marines_p)

			(ai_force_full_lod ext_a_area_a_cov)
			(ai_force_full_lod ext_a_bnsh_bp)
			(ai_force_full_lod ext_a_area_a_marines)
		)
	)
)

(global boolean b_snowfield_a_ai_full_lod_c false)

(script continuous snowfield_a_ai_full_lod_c
	(if (not b_snowfield_a_ai_full_lod_c)
		(begin
			(sleep_until (volume_test_players snowfield_a_ai_full_lod_area_c) 1)
			(set b_snowfield_a_ai_full_lod_c true)

			(ai_force_full_lod ext_a_area_c_cov)

			(ai_clear_lod ext_a_area_b_cov)
			(ai_clear_lod ext_a_area_a_marines_p)
		)
	)
)

(script continuous snowfield_a_ai_clear_lod_c
	(if b_snowfield_a_ai_full_lod_c
		(begin
			(sleep_until (volume_test_players snowfield_a_ai_clear_lod_area_c) 1)
			(set b_snowfield_a_ai_full_lod_c false)

			(ai_clear_lod ext_a_area_c_cov)

			(ai_force_full_lod ext_a_area_b_cov)
			(ai_force_full_lod ext_a_area_a_marines_p)
		)
	)
)

(global boolean b_snowfield_a_ai_full_lod_d false)

(script continuous snowfield_a_ai_full_lod_d
	(if (not b_snowfield_a_ai_full_lod_d)
		(begin
			(sleep_until (volume_test_players snowfield_a_ai_full_lod_area_d) 1)
			(set b_snowfield_a_ai_full_lod_d true)

			(ai_force_full_lod ext_a_area_c_cov)
		)
	)
)

(script continuous snowfield_a_ai_clear_lod_d
	(if b_snowfield_a_ai_full_lod_d
		(begin
			(sleep_until (volume_test_players snowfield_a_ai_clear_lod_area_d) 1)
			(set b_snowfield_a_ai_full_lod_d false)

			(ai_clear_lod ext_a_area_c_cov)
		)
	)
)

(script static void b1_cleanup
	; ai from mission start
	(ai_erase sq_gr_insertion_cov)

	; ai from arena_a
	(ai_erase sq_gr_a1_cov_all)

	; ai from bridge_a
	(ai_erase sq_gr_bridge_a)
	(ai_erase sq_bridge_a_elite_general)
	(cleanup_bridge_a_vista_fighting) ; squads in the snowfield + the banshee to make room for the real stuff

	; ai from arena b
	(ai_erase sq_gr_a2_top_cov)

	; objects
	(cleanup_b1_objects)
)

(script static void b2_cleanup

	; ai from snowfield a
	(ai_erase ext_a_area_a_cov)

	; ai from snowfield b
	(ai_erase ext_a_area_b_cov)

	; ai from snowfield c
	(sleep_forever ini_ext_a_area_c_banshee) ; handle players running through snowfield - this script actually recreates the banshee if the snowfield c guys die, so kill it if it's still running before erasing anyone
	(ai_erase ext_a_area_c_cov)

	; objects from all 3 snowfields + vista squads
	(cleanup_b2_objects)
)

;====================================================================================================================================================================================================
; insertion point: ins_b2_middle ====================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant mission_b2_middle
	(wake b2_teleport_and_cleanup_prechasm)
	(wake b2_teleport_and_cleanup_postchasm)
	(wake mission_crevasse)
	(wake crevasse_open_the_two_big_doors)
	(wake chasm_open_big_door)
	(wake mission_ext_b)
	(wake crevasse_save)

	; navpoints
	(wake mission_b2_middle_navpoints)
	(wake mission_b2_ice_tunnel_navpoints)
	(wake mission_b2_bunker_navpoints)

	; object management
	(wake tarmac_cleanup)
	(wake place_b4_objects_spiral_bunker_at_spiral_entrance)

	; vo music
	(wake vo_crevasse_intro)
	(wake vo_large_tunnel_b_intro)
	(wake vo_snowfield_g_intro_trigger)
	(wake music_trigger_14)
	(wake music_trigger_15b)
	(wake music_trigger_16)
	(wake music_trigger_18)
)

(script dormant place_b4_objects_spiral_bunker_at_spiral_entrance
	(sleep_until (volume_test_players tv_ext_b_b_trigger_spiral_entrance) 1)
	(place_b4_objects_spiral_bunker)
)

(script dormant mission_crevasse
	(sleep_until (volume_test_players crevasse_trigger) 1)

	(f_game_save)
	(wake enc_crevasse)

	(wake ini_crevasse_turret_a)
	(wake ini_crevasse_turret_b)
	(wake ini_crevasse_turret_c)
)

; these are the two doors after
(script dormant crevasse_open_the_two_big_doors
	(sleep_until (volume_test_players tv_chasm_entrance_door) 1)

	; open the door in front
	(device_set_power dm_tun_garage_2 1) ; turn on power so it turns green before it opens
	(device_set_position dm_tun_garage_2 1)
)

; this is the second door
(script dormant chasm_open_big_door
	(sleep_until (> (device_group_get large_door_canyon_1_position) 0) 1) ; wait for the switch input
	(device_set_power large_door_canyon_1 1) 		; power on the door so it turns green before it opens
	(device_set_position large_door_canyon_1 1)		; open the door
)

(script dormant mission_ext_b
	; ice tunnel
	(wake mission_ext_b_ice_tunnel)

	; tarmac / snowfield e
	(wake mission_ext_b_tarmac)

	; spiral / snowfield f / shine tower
	(wake enc_ext_b_b_marines)
	(wake ini_ext_b_b_dropship_a_spiral)
	(wake enc_ext_b_b_spiral_turrets)

	; bunker/snowfield g
	(wake mission_ext_b_bunker)

	; checkpoints
	(sleep_until (volume_test_players tv_ext_b_b_trigger_spiral_entrance) 1)
	(f_game_save)

	(sleep_until (volume_test_players tv_ext_b_b_trigger_spiral_exit) 1)
	(f_game_save)
)

(script dormant mission_ext_b_ice_tunnel
	(sleep_until (volume_test_players ext_b_trigger) 1)
	(wake ini_ext_b_tunnel)
)

(script dormant mission_ext_b_tarmac
	(sleep_until (volume_test_players ext_b_a_trigger_a) 1)
	(f_game_save)

	; these all place squads immediately, so space them out over ~ a second and defer the inside squads by a bit longer as well
	(wake ini_ext_b_a_dropship_a) ; place the dropship first as it is the most time sensitive
	(sleep 15)

	(wake ini_ext_b_second)
	(sleep 15)

	(wake ini_ext_b_banshee_a) ; banshee comes down on a delay anyway, so it's really no rush
	(sleep 15)

	; everything below is an interior squad interior, so give them a longer wait (can split them out on own trigger volume later if perf demands)
	(wake ini_ext_b_trigger_b)
	(sleep 15)

	(wake ini_ext_b_trigger_c)
	(sleep 15)

	; queues up spiral squad on a sleep
	(wake ini_ext_b_trigger_d)

	(f_game_save) ; and book another save after the spawns are done, if we can.
)

; split out for the ins_spiral script
(script dormant mission_ext_b_bunker
	(sleep_until (volume_test_players tv_ext_b_b_trigger_spiral_exit) 1)

	; this block of wakes are sequenced in the order they are spawned for ease of reading.
	; but the individual scripts actually handle their own placements conditions
	; take a look at the gr_ext_b_area_c_cov to see the squad groups in each
	(wake enc_ext_b_cave) ; cave/slope - places gr_ext_b_area_b_cave squads
	(wake enc_ext_b_c_rocks) ; rocks - places gr_ext_b_area_b_rocks squads, which also includes the banshee
	(wake enc_ext_b_c_bunker) ; bunker - places gr_ext_b_area_b_bunker squads
	(wake enc_ext_b_c_trench_cov) ; trench - places the gr_ext_b_trench_cov squad
	(wake enc_ext_b_c_hallway) ; hallway - places the gr_ext_b_hallway_cov squad

	(wake mission_ext_b_bunker_weapons)

	; checkpoints
	; upon exiting the ice lake...
	(if (<= (ai_living_count ext_b_area_b_cov_spiral_hunters) 0)
		(begin ; then
			(game_save_no_timeout) ; save with no timeout upon reaching the area if the hunters are dead
		)
		(begin
			(f_game_save) ; otherwise, use a timeout as the player might still be in danger
		)
	)

	; - note that cave, rocks, and bunker scripts above each have their own checkpointing as well
)

; configures the sandbox items available on different difficulties in the snowfield_g encounter
(script dormant mission_ext_b_bunker_weapons
	; on easy and normal, spawn some extra ammo on the cliff behind the player
	; because these objects are part of the blam object folder for cleanup, the if's need to both create and destroy to ensure desired behavior in all difficulties
	(if (= (game_difficulty_get) normal)
		(begin
			(object_create_if_necessary dead_marine31)
			(object_create_if_necessary ammo_rocket_launcher12)
			(object_create_if_necessary ammo_rocket_launcher13)
			(object_create_if_necessary ammo_rocket_launcher14)
		)
		(begin
			(object_destroy ammo_rocket_launcher12)
			(object_destroy ammo_rocket_launcher13)
			(object_destroy ammo_rocket_launcher14)
		)
	)

	; and if you're really on legendary, surely you only need one extra rocket pack, right?
	(if (= (game_difficulty_get) legendary)
		(begin
			(object_destroy weap_rocket_launcher8)
			(object_destroy ammo_rocket_launcher11)
		)
		(begin
			(object_create_if_necessary weap_rocket_launcher8)
			(object_create_if_necessary ammo_rocket_launcher11)
		)
	)
)

;==============================================================
; encounter scripts (b2 ; ins_b2_middle) ======================
;==============================================================

(script dormant enc_crevasse
	(ai_place gr_chasm_cov_a)
	(ai_place gr_chasm_cov_b)

	(wake music_trigger_15)
	(wake music_trigger_15a)
)

(script dormant crevasse_save
	(wake large_door_canyon_save)
	(sleep_until (volume_test_players crev_a_save) 1)
	(f_game_save)
	(sleep_until (volume_test_players crev_b_save) 1)
	(f_game_save)
)

(script dormant large_door_canyon_save
	(sleep_until (> (device_get_position large_door_canyon_1) 0) 1)
	(f_game_save)
)

(script dormant ini_crevasse_turret_a
	(sleep_until (and
					(> (ai_living_count sq_chasm_grunt_left) 0)
					(> (object_get_health crevasse_turret_a) 0)
				)
	1 )

	(f_sleepy_squad_man_turret sq_chasm_grunt_left crevasse_turret_a)
)

(script dormant ini_crevasse_turret_b
	(sleep_until (and
				(> (ai_living_count sq_chasm_grunt_right) 0)
				(> (object_get_health crevasse_turret_b) 0)
			)
	1 )
	(f_sleepy_squad_man_turret sq_chasm_grunt_right crevasse_turret_b)
)

(script dormant ini_crevasse_turret_c
	(sleep_until (and
					(> (ai_living_count sq_chasm_b_tgrunt) 0)
					(> (object_get_health crevasse_turret_c) 0)
			)
	1 )
	(f_sleepy_squad_man_turret sq_chasm_b_tgrunt crevasse_turret_c)
)

; make sure a squad will both man a turret and sleep
(script static void (f_sleepy_squad_man_turret (ai grunt_squad) (vehicle turret))
	(ai_vehicle_enter_immediate grunt_squad turret)
	(ai_activity_set grunt_squad asleep)
	(sleep_until
		(begin
			(if (<= (ai_in_vehicle_count grunt_squad) 0) (ai_vehicle_enter grunt_squad turret))
			(<= (ai_living_count sq_chasm_b_tgrunt) 0) ; break loop when everybody is dead
		)
		l_default_turret_delay ; delay between grunts being told to mount up
	)
)

(script dormant ini_ext_b_tunnel
	; enc_ext_b_tunnel
	(ai_place gr_ext_b_area_a_cov_t)
	(ai_activity_set sq_ext_b_area_a_cov_ga asleep)
	(sleep_until (>= (ai_combat_status gr_ext_b_area_a_cov_t) "visible") 1)
	(ai_vehicle_enter sq_ext_b_area_a_cov_ea tunnel_ghost_b)
	(ai_vehicle_enter sq_ext_b_area_a_cov_nwg2 tunnel_ghost_c)

	(f_ai_magically_see_players gr_ext_b_area_a_cov_t)
)

(script dormant ini_ext_b_a_dropship_a
	(ai_place sq_ext_b_area_a_cov_dropship)
	(set v_dropship_a (ai_vehicle_get_from_starting_location sq_ext_b_area_a_cov_dropship/pilot_spawn))

	;cargo_ghost_a
	(unit_enter_vehicle ext_b_a_cargo_ghost_a v_dropship_a "fork_p_cargo01")
	(unit_enter_vehicle ext_b_a_cargo_ghost_b v_dropship_a "fork_p_cargo03")

	(ai_place gr_ext_b_area_a_drop_e)
	(ai_place gr_ext_b_area_a_drop_f)

	(ai_vehicle_enter_immediate  sq_ext_b_area_a_cov_ee ext_b_a_cargo_ghost_a)
	(ai_vehicle_enter_immediate sq_ext_b_area_a_cov_ef ext_b_a_cargo_ghost_b)

	(vehicle_load_magic v_dropship_a "fork" (ai_actors sq_ext_b_area_a_cov_ge))
	(vehicle_load_magic v_dropship_a "fork" (ai_actors sq_ext_b_area_a_cov_gf))

	(f_ai_magically_see_players sq_ext_b_area_a_cov_ee)
	(f_ai_magically_see_players sq_ext_b_area_a_cov_ef)
)

(script dormant ini_ext_b_trigger_b
	(ai_place gr_enc_ext_b_a_trigger_b)
	(ai_place sq_elites_tower)
	(sleep 1)
	(f_ai_magically_see_players sq_elites_tower)
)

(script dormant ini_ext_b_trigger_c
	(ai_place gr_enc_ext_b_a_trigger_c)
)

(script dormant ini_ext_b_second
	(ai_place gr_ini_ext_b_second)
	(ai_vehicle_enter_immediate ext_b_area_a_cov_gpc ext_b_a_ghost_c)
	(ai_vehicle_enter_immediate ext_b_area_a_cov_gpd ext_b_a_ghost_d)
	(ai_vehicle_enter_immediate sq_turret_a_gunner ext_b_a_turret_a)
	(ai_vehicle_enter_immediate sq_turret_b_gunner ext_b_a_turret_b)
)

; wraith goalies
(script dormant ini_ext_b_trigger_d
	(sleep_until (or
					(volume_test_players tv_ext_b_trigger_d)
					(= (ai_living_count sq_wraith_gunner_34) 0)
				)
	1 )

	(ai_place sq_hunter_oq)

	(if (and
			(<= ; if at least 3 of the 4 ghosts are dead...
				(+
					(ai_living_count sq_ext_b_area_a_cov_ee)
					(ai_living_count sq_ext_b_area_a_cov_ef)
					(ai_living_count ext_b_area_a_cov_gpc)
					(ai_living_count ext_b_area_a_cov_gpd)
				)
			1 )
			(f_player_is_driving_tank) ;and the player is driving a tank to handle them
		)
		(begin ; then, spawn two ghosts with the hunter goalies
			(ai_place sq_ghost_pilot_ef)
		)
	)

	(sleep (game_ticks_from_seconds 5.0)) ; allow the spawn to happen before forcing lod
	(wake f_tarmac_force_full_load_for_goalies)
)

; when the player takes out the wraith, mark the interior tarmac squads disposable (since we're past them... and unlikely to look back
; and ensure the goalies have a full brain
(script dormant f_tarmac_force_full_load_for_goalies
	(ai_force_full_lod gr_ini_ext_b_trigger_d)
	(ai_disposable gr_enc_ext_b_a_trigger_b true)
	(ai_disposable gr_enc_ext_b_a_trigger_c true)
)

(script dormant ini_ext_b_banshee_a
	(ai_place ext_b_area_a_cov_bp)
	(ai_vehicle_enter ext_b_area_a_cov_bp ext_b_banshee_a)

	(sleep 1)
	(f_ai_magically_see_players ext_b_area_a_cov_bp)
)

(script dormant enc_ext_b_b_spiral_turrets
	(sleep_until (volume_test_players tv_ext_b_b_trigger_spiral_entrance) 1)

	; if the player has created enough space, spawn some optional guards.  players running through will not see these squads
	(if (< (ai_living_count ext_a_area_b_cov) 8)
		(begin
			(ai_place ext_b_area_b_cov_spiral_top)
			(ai_place ext_b_area_b_cov_arch_top)
		)
	)

	(ai_place ext_b_area_b_cov_tga)
	(ai_place ext_b_area_b_cov_tgb)
	(wake enc_ext_b_b_spiral_turrets_c)

	(sleep 1)

	(ai_vehicle_enter ext_b_area_b_cov_tga ext_b_b_turret_a)
	(ai_vehicle_enter ext_b_area_b_cov_tgb ext_b_b_turret_b)
)

; split out to own script for use in the dev insertion point ins_spiral
(script dormant enc_ext_b_b_spiral_turrets_c
	(ai_place ext_b_area_b_cov_tgc)

	(sleep 1)

	(ai_vehicle_enter ext_b_area_b_cov_tgc ext_b_b_turret_c)
)

(script dormant enc_ext_b_b_marines
	(sleep_until (volume_test_players ext_b_b_trigger_b) 1)
	(ai_place ext_b_marines_mt)
	(ai_place ext_b_marines_s)
	(ai_place ext_b_area_b_cov_h)

	(sleep_until (volume_test_players ext_b_marines_trigger) 1)
    (set ext_b_player_trigger true) ; used by objective to set follow
)

(script dormant ini_ext_b_b_dropship_a_spiral
	(sleep_until (volume_test_players ext_b_b_trigger_dropship) 1)

	; spawn dropship and store a reference to it
	(ai_place ext_b_area_b_cov_dropship)
	(set v_dropship_b (ai_vehicle_get_from_starting_location ext_b_area_b_cov_dropship/pilot_spawn))

	; spawn dropship squads
	(ai_place ext_b_area_b_cov_ep)
	(ai_place ext_b_area_b_cov_gp)
	(ai_place ext_b_area_b_cov_jp)

	(sleep 1)

	; load dropship with the squads
	(vehicle_load_magic v_dropship_b "fork" (ai_actors ext_b_area_b_cov_ep))
	(vehicle_load_magic v_dropship_b "fork" (ai_actors ext_b_area_b_cov_gp))
	(vehicle_load_magic v_dropship_b "fork" (ai_actors ext_b_area_b_cov_jp))
)

;==============================================================
; encounter scripts (b2 bunker; ins_b2_spiral) ================
;==============================================================

; this places everything in gr_ext_b_area_b_cave
; first place the spec ops elite and the reinforcements,
; then, depending on how many enemies the player has killed in the ice lake, either place the support squad or use some of the existing squads from the ice lake to create pressure in the cave
(script dormant enc_ext_b_cave
	;(sleep_until (volume_test_players tv_ext_b_b_trigger_spiral_exit) 1)
	(ai_place ext_b_area_b_cov_si)
	(ai_place gr_ext_b_area_b_cave_reinf)

	; make the spec ops invisible before the player sees them
	(ai_set_active_camo ext_b_area_b_cov_si true)

	; ideally these squads are always present, but if the player is running past everything
	; some fleeing grunts and jackals aren't going to make a difference (was present in legacy)
	(if (< (ai_living_count ext_b_area_b_cov) 8)
		(begin ; then
			(ai_place gr_ext_b_area_b_cave_support)
			(sleep 1) ; next script checks the living fraction of the cave mouth reinforcements, so give them a frame to exist so we don't blow through it
			;(wake enc_ext_b_cave_mouth_dialogue_support_spawn)
		)
		(begin ; else
			(ai_set_objective gr_ext_b_cov_spiral_ship aiobjective_ext_b_area_c_cave) ; since the player didn't kill people in the ice lake, use some existing ice lake squads to create pressure in the cave instead
			;(wake enc_ext_b_cave_mouth_dialogue_no_support_spawn)
		)
	)

	; kick the marines out of the fireteam and into the cave objective so they stop following
	(f_empty_fireteam_followers_into_objective aiobjective_ext_b_area_c_cave)

	; attempt a save once the player kills the spec ops elite
	(sleep_until (<= (ai_living_count ext_b_area_b_cov_si) 0) 1)
	(f_game_save) ; use a timeout here because we just saved at the exit to the spiral

	(sleep_until (<= (ai_living_count gr_ext_b_area_b_cave_reinf) 0) 1)
	(f_game_save) ; this is pretty necessary on legendary
)

; commenting out as this conversation's placement/condition has moved; keeping here in case level design wants to revive this
; (script dormant enc_ext_b_cave_mouth_dialogue_support_spawn
; 	; the support squad was placed, so once the player has killed the spec ops elite and enough of the slope support squad, the line is ready
; 	(sleep_until (and (<= (ai_living_fraction ext_b_area_b_cov_si) 0) (<= (ai_living_fraction gr_ext_b_area_b_cave_mouth) .4)) 1)
; 	(sleep_until (volume_test_players tv_vo_snowfield_g_intro ) 1)
; 	(sleep (game_ticks_from_seconds 1.75)) ; when using rockets or grenades, it's suuuuuper clear it's the final kill that triggers this.  give a little breathing room to make it feel more natural.
; 	(wake vo_snowfield_g_intro)
; )

; (script dormant enc_ext_b_cave_mouth_dialogue_no_support_spawn
; 	; support squad was not placed, so wait for the spec ops elite and spiral hunters to be gone (things preventing dubbo from entering the cave)
; 	(sleep_until (and (<= (ai_living_fraction ext_b_area_b_cov_si) 0) (<= (ai_living_fraction ext_b_area_b_cov_h) 0) ) 1)

; 	; and then trigger the line if the player moves far enough into the space.  this means players who run past the encounter likely will not hear the line.
; 	(sleep_until (volume_test_players tv_vo_snowfield_g_intro ) 1)
; 	(wake vo_snowfield_g_intro)
; )

(script dormant enc_ext_b_c_rocks
	(sleep_until (volume_test_players ext_b_c_trigger_a) 1)

	; this used to be elites and grunts off to the left, but it widens the threat cone... a lot.  flatter geo is part of this as well.
	; so buff up the vehicle fight with an extra banshee instead, which uses kungfu gates to keep things from getting overwhelming.
	(if (< (ai_living_count gr_ext_b_area_c_cov) 3)
		(begin
			(ai_place ext_b_area_c_cov_bp 1)
		)
	)
	(ai_place gr_ext_b_area_b_rocks)

	; attempt a checkpoint with timeout if the player kills the shades pinning the marines on the cave slope
	(sleep 1) ; ensure the rocks_turret finishes spawning before we check its health
	(sleep_until (and
					(<= (ai_living_count ext_b_area_b_cov_tgc) 0) 	; spiral turret, heroic/legendary only
					(<= (ai_living_count gr_ext_b_area_b_rocks_turret) 0) 		; bunker turret by the rocks, all difficulties
				)
	1 )
	(set b_bunker_marines_can_advance true) ; used by the marine encounter as well
	(f_game_save) ; use a timeout because the banshees/ghosts may already have begun pressuring
)

; turrets near the exit to the snowfield, along with bunker reinforecements
(script dormant enc_ext_b_c_bunker
	(sleep_until (volume_test_players tv_player_past_bunker_trees) 1)
	;(sleep_until (volume_test_players ext_b_c_trigger_a) 1)
	(ai_place gr_ext_b_area_c_cov_bunker)

	(wake vo_snowfield_g_outro_trigger)

	; attempt a checkpoint with no timeout if the player clears all ghosts and banshees
	(sleep 1) ; ensure ghosts exist before we check their health
	(sleep_until ( and
					(<= (ai_living_count ext_b_area_c_cov_gb) 0)
					(<= (ai_living_count ext_b_area_b_cov_tgc) 0)
					(<= (ai_living_count gr_ext_b_area_b_rocks_turret) 0)
				)
	1 )
	(game_save_no_timeout)
)

; these are the guys that spawn in the hallways in the trench
(script dormant enc_ext_b_c_trench_cov

	; place overshields immediately, one always and an additional for co-op.
	(object_create_if_necessary equip_active_os)
	(if (game_is_cooperative)
		(begin
			(object_create_if_necessary equip_active_os2_coop)
		)
	)

	; kill this script if the player hears the victory line so the guys never spawn
	(wake enc_ext_b_c_trench_cov_monitor)

	(sleep_until (volume_test_players tv_ext_b_c_trench_cov) 1)
	(ai_place gr_ext_b_area_c_cov_trench)
)

(script dormant enc_ext_b_c_trench_cov_monitor
	(sleep_until b_cortanahastoldbisentitowait 1)
	(sleep_forever enc_ext_b_c_trench_cov) ; don't let people spawn in the trench after the victory line for bunker
)

; spawns the hallway reinforcements
(script dormant enc_ext_b_c_hallway
	(sleep_until (volume_test_players ext_b_c_trigger_d) 1)
	(ai_place gr_ext_b_area_c_cov_hallway)

	; checkpoint if the player kills both the door squad, the ghosts, and the hallway squad
	(sleep_until ( and
					(<= (ai_living_count gr_ext_b_area_c_cov_hallway) 0)
					(<= (ai_living_count gr_ext_b_area_c_cov_bunker) 0)
				)
	1 )
	(game_save_no_timeout)
)

;==============================================================
; cleanup
;==============================================================

(global boolean b_snowfield_b_ai_full_lod_a false)

(script continuous snowfield_b_ai_full_lod_a
	(if (not b_snowfield_b_ai_full_lod_a)
		(begin
			(sleep_until (volume_test_players snowfield_b_ai_full_lod_area_a) 1)
			(set b_snowfield_b_ai_full_lod_a true)

			(ai_force_full_lod gr_ext_b_area_a_cov) ; this group is huge in the outliner and goes all the way to the tarmac.
			(ai_force_full_lod ext_b_area_a_cov_da)
		)
	)
)

(script continuous snowfield_b_ai_clear_lod_a
	(if b_snowfield_b_ai_full_lod_a
		(begin
			(sleep_until (volume_test_players snowfield_b_ai_clear_lod_area_a) 1)
			(set b_snowfield_b_ai_full_lod_a false)

			(ai_clear_lod gr_ext_b_area_a_cov)
			(ai_clear_lod ext_b_area_a_cov_da)
		)
	)
)

(global boolean b_snowfield_b_ai_full_lod_b false)

(script continuous snowfield_b_ai_full_lod_b
	(if (not b_snowfield_b_ai_full_lod_b)
		(begin
			(sleep_until (volume_test_players snowfield_b_ai_full_lod_area_b) 1)
			(set b_snowfield_b_ai_full_lod_b true)

			(ai_force_full_lod ext_b_area_b_cov)
			(ai_force_full_lod ext_b_marines)

			(ai_clear_lod gr_ext_b_area_a_cov)
			(ai_clear_lod ext_b_area_a_cov_da)
		)
	)
)

(script continuous snowfield_b_ai_clear_lod_b
	(if b_snowfield_b_ai_full_lod_b
		(begin
			(sleep_until (volume_test_players snowfield_b_ai_clear_lod_area_b) 1)
			(set b_snowfield_b_ai_full_lod_b false)

			(ai_clear_lod ext_b_area_b_cov)
			(ai_clear_lod ext_b_marines)

			(ai_force_full_lod gr_ext_b_area_a_cov)
			(ai_force_full_lod ext_b_area_a_cov_da)
		)
	)
)

(global boolean b_snowfield_b_ai_full_lod_c false)

(script continuous snowfield_b_ai_full_lod_c
	(if (not b_snowfield_b_ai_full_lod_c)
		(begin
			(sleep_until (volume_test_players snowfield_b_ai_full_lod_area_c) 1)
			(set b_snowfield_b_ai_full_lod_c true)

			(ai_force_full_lod gr_ext_b_area_c_cov)

			(ai_clear_lod ext_b_area_b_cov)
			(ai_clear_lod ext_b_marines)

			(ai_force_full_lod gr_ext_b_area_b_cave_support)
		)
	)
)

(script continuous snowfield_b_ai_clear_lod_c
	(if b_snowfield_b_ai_full_lod_c
		(begin
			(sleep_until (volume_test_players snowfield_b_ai_clear_lod_area_c) 1)
			(set b_snowfield_b_ai_full_lod_c false)

			(ai_clear_lod gr_ext_b_area_c_cov)

			(ai_force_full_lod ext_b_area_b_cov)
			(ai_force_full_lod ext_b_marines)

			(ai_clear_lod gr_ext_b_area_b_cave_support)
		)
	)
)

(global boolean b_snowfield_b_ai_full_lod_d false)

(script continuous snowfield_b_ai_full_lod_d
	(if (not b_snowfield_b_ai_full_lod_d)
		(begin
			(sleep_until (volume_test_players snowfield_b_ai_full_lod_area_d) 1)
			(set b_snowfield_b_ai_full_lod_d true)

			(ai_force_full_lod gr_ext_b_area_c_cov)
		)
	)
)

(script continuous snowfield_b_ai_clear_lod_d
	(if b_snowfield_b_ai_full_lod_d
		(begin
			(sleep_until (volume_test_players snowfield_b_ai_clear_lod_area_d) 1)
			(set b_snowfield_b_ai_full_lod_d false)

			(ai_clear_lod gr_ext_b_area_c_cov)
		)
	)
)

(script static void b2_cleanup_chasm
	(ai_disposable gr_chasm_cov_a true)
	(ai_disposable gr_chasm_cov_b true)
)

;==============================================================
; command scripts (b2 ; ins_b1_elevator) ======================
;==============================================================

; used with sqaud sq_ext_b_area_a_cov_dropship in the tarmac
(script command_script cs_ext_b_a_dropship_a
	; enable failsafes for the scripted flight path
 	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_vehicle_speed 0.66)
	(cs_fly_to ps_dropship_a_flightpath/p0 0.1)

	; drop the ghosts
	(unit_open v_dropship_a)
	(unit_exit_vehicle ext_b_a_cargo_ghost_a)
	(unit_exit_vehicle ext_b_a_cargo_ghost_b)

	; make them face the player
	(sleep 1) ; wait a frame or the command script won't activate
	(cs_run_command_script sq_ext_b_area_a_cov_ee cs_ghost_briefly_face_player)
	(cs_run_command_script sq_ext_b_area_a_cov_ef cs_ghost_briefly_face_player)

	; drop the infantry
	(sleep (game_ticks_from_seconds 1.0))
	(begin_random
		(begin (vehicle_unload v_dropship_a "fork_p_r1") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_r2") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_r3") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_r4") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_r5") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_r6") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_r7") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_r8") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_l1") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_l2") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_l3") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_l4") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_l5") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_l6") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_l7") (sleep 5))
		(begin (vehicle_unload v_dropship_a "fork_p_l8") (sleep 5))
	)

	(set b_unit_dropped_dropship_a true)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close v_dropship_a)
	(cs_fly_to_and_face ps_dropship_a_flightpath/p7 ps_dropship_a_flightpath/p1)
	(cs_fly_by ps_dropship_a_flightpath/p1)
	(cs_fly_by ps_dropship_a_flightpath/p2)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_dropship_a_flightpath/p3)
	(cs_fly_by ps_dropship_a_flightpath/p5)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.99 (game_ticks_from_seconds 2.0)) ; make the audio start fading here so it doesn't pop, needs at least 6 seconds.
	(cs_fly_by ps_dropship_a_flightpath/p6)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (game_ticks_from_seconds 2.0)) ; in case the player was able to keep up with the dropship, make it seem like it flew away fast

	(sleep (game_ticks_from_seconds 2.0))
	(ai_erase ai_current_squad)
)

; for the dropship ghosts in the tarmac, just get them to stick around
(script command_script cs_ghost_briefly_face_player
	(cs_face_player true)
	(sleep (game_ticks_from_seconds 2.0)) ; hold it for just a second
	(cs_face_player false)
)

; used with squad ext_b_area_b_cov_dropship
(script command_script cs_ext_b_b_dropship_b
	; enable failsafes for the scripted flight path
 	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_vehicle_speed 0.5)
	(cs_fly_by ps_dropship_b_flightpath/p0)
	(cs_fly_by ps_dropship_b_flightpath/p1)
	(cs_vehicle_speed 0.75)
	(cs_fly_by ps_dropship_b_flightpath/p2)
	(unit_open v_dropship_b)
	(sleep 30)
	(begin_random
		(begin (vehicle_unload v_dropship_b "fork_p_r1") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_r2") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_r3") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_r4") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_r5") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_r6") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_r7") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_r8") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_l1") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_l2") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_l3") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_l4") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_l5") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_l6") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_l7") (sleep 5))
		(begin (vehicle_unload v_dropship_b "fork_p_l8") (sleep 5))
	)
	(sleep 90)
	(unit_close v_dropship_b)
	(cs_vehicle_speed 0.5)
	(cs_fly_by ps_dropship_b_flightpath/p3)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_dropship_b_flightpath/p4)
	(ai_erase ai_current_squad)
)


; on easy and normal, give players a moment to respond.  use for non-camo elites so they keep heroic tough.
(script command_script cs_sword_elite_berserk_on_e_n
	(if (= (game_difficulty_get) normal)
		(begin
			(ai_berserk ai_current_actor true)
		)
	)
)

; on everying but legendary, give players a moment to respond.  use for camo elites since heroic will have them upgrading shields.  thus:
; easy/normal 	- low shield & roars
; heroic 		- high shield, still roars
; legendary 	- high shield, just runs you down like the demon you are
(script command_script cs_sword_elite_berserk_on_e_n_h
	(if (not (= (game_difficulty_get) legendary))
		(begin
			(ai_berserk ai_current_actor true)
		)
	)
)

; always have the spiral cave elite roar.  you're welcome.
(global boolean b_cave_has_roared false)
(script command_script cs_spiral_cave_sword_elite_berserk
	(ai_berserk ai_current_actor true)
	(set b_cave_has_roared true)
)

(script command_script cs_spiral_cave_support_flee
	;(ai_flee_from_object ai_current_actor player0)
	(ai_flee_to_point ai_current_actor ps_cave_slope_flee/p0)
)

;====================================================================================================================================================================================================
; beat 3 ============================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; insertion point: ins_b3_start =====================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant mission_b3_main
	(wake mission_b3_save)

	(wake enc_b4_b_cov)
	(wake enc_b4_bridge)
	(wake enc_b5_a_cov)
	(wake enc_b5_hall_cov)
	(wake tarmac_cleanup)
	(wake b3_teleport_and_cleanups) ; twin bridges teleport and cleanups

	; nav needs to be woken before the sleep in case the player hijacks the banshee or jetpacks
	(wake arena_e_navpoint_loop)
	(wake mission_b3_arena_f_hunter_hint)

	(sleep_until (volume_test_players b3_bottom_trigger) 1)

	(wake enc_b3_bottom_cov)
	(wake enc_b3_lift_cov)
	(wake encounter_arena_d)
	(wake enc_b3_bridge)


	; music vo
	(wake music_trigger_20)
	(wake music_trigger_21)
	(wake music_trigger_24)
	(wake music_trigger_25)
	(wake music_trigger_26)
	(wake music_trigger_27)
	(wake vo_bridge_e_hunters)
)

(global boolean b_entered_vehicle_dawdle false)
(script dormant check_dawdle_vehicle
	(sleep_until (any_players_in_vehicle) 1)
	(set b_entered_vehicle_dawdle true)
)

(script dormant mission_b3_save
	(wake mission_b3_bottom_a_save)
	(wake mission_b3_bottom_b_save)
	(wake mission_b3_top_save)
	(wake mission_b3_bridge_save)
	(wake mission_b3_arena_d_save)
	(wake mission_b3_b4_a_save)
	(wake mission_b3_b4_bridge_save)
	(wake mission_b3_b5_a_save)
	(wake mission_b3_c_bridge_save)
)

(script dormant mission_b3_bottom_a_save
	(sleep_until (volume_test_players b3_bottom_a_save) 1)
	(game_save_no_timeout)
)
(script dormant mission_b3_bottom_b_save
	(sleep_until (volume_test_players b3_bottom_b_save) 1)
	(game_save_no_timeout)
)
(script dormant mission_b3_top_save
	(sleep_until (volume_test_players b3_top_save) 1)
	(game_save_no_timeout)
)
(script dormant mission_b3_bridge_save
(sleep_until (volume_test_players b3_bridge_save) 1)
	(game_save_no_timeout)
)
(script dormant mission_b3_b4_a_save
	(sleep_until (volume_test_players b4_a_save) 1)
	(game_save_no_timeout)
)
(script dormant mission_b3_b4_bridge_save
	(sleep_until (volume_test_players b4_bridge_save) 1)
	(game_save_no_timeout)
)
(script dormant mission_b3_b5_a_save
	(sleep_until (volume_test_players b5_a_save) 1)
	(game_save_no_timeout)
)
(script dormant mission_b3_c_bridge_save
	(sleep_until (volume_test_players c_bridge_save) 1)
	(game_save_no_timeout)
)
(script dormant mission_b3_arena_d_save
	(sleep_until (volume_test_players tv_arena_d_save) 1)
	(game_save_no_timeout)
)

; on b4_b_trigger start enc_b4_b
(script dormant enc_b4_b_cov
	(sleep_until (volume_test_players b4_b_trigger) 1)

	(ai_place sq_gr_b4_b_cov)
	(ai_activity_set b4_b_cov_grunts_g asleep)
	(ai_activity_set b4_b_cov_grunts_m asleep)
	(ai_activity_set b4_b_cov_grunts_w asleep)
	(wake arena_e_elites_save)
)

; book a save after the player clears the elites in the room
(script dormant arena_e_elites_save
	(sleep_until (= (ai_living_count sq_gr_b4_b_cov_elites) 0) 1)
	(f_game_save)

)

;==============================================================
; encounter scripts (b3 ; ins_b3_start) =======================
;==============================================================


(script dormant enc_b4_bridge
	(sleep_until (volume_test_players b4_bridge_trigger) 1)

	(device_set_power b4_bridge_door 1)

	(if (= (random_range 0 2) 0)
    	(ai_place b4_bridge_grunts_a)
    	(ai_place b4_bridge_jackals_a)
	)

	(ai_place b4_bridge_elites_c)
	(ai_place b3_hunters)

	(sleep 1)
	(f_ai_magically_see_players sq_gr_b4_bridge)

	(sleep_until (volume_test_players b4_bridge_reins_trigger_a) 1)
	(f_game_save)

	(ai_place b4_bridge_elites_g)
	(if (= (random_range 0 2) 0)
    	(ai_place b4_bridge_grunts_e)
    	(ai_place b4_bridge_jackals_e)
	)

	(sleep_until (volume_test_players b4_bridge_reins_trigger_b) 1)

	(ai_place b4_bridge_stealth_elites)
	(ai_place b4_bridge_stealth_elites_leg)

	(sleep 1)
	(f_ai_magically_see_players sq_gr_b4_bridge)
	(wake b4_bridge_stealth_guard_save)
)

; book a save after the stealth guards are dead
(script dormant b4_bridge_stealth_guard_save
	(sleep_until (and
					(= (ai_living_count b4_bridge_stealth_elites) 0)
					(= (ai_living_count b4_bridge_stealth_elites_leg) 0)
				)
	1 )

	(f_game_save)
)

; on b5_a_trigger start mission_b5
(script dormant enc_b5_a_cov
	(sleep_until (volume_test_players b5_a_trigger) 1)
	(ai_place gr_arena_f)

	; set most of the squad to asleep
	(ai_activity_set sq_arena_f_grunts asleep)

	(wake music_trigger_28)
)

(script dormant enc_b5_hall_cov
	(sleep_until (volume_test_players b5_hall_trigger) 1)

	(f_game_save)
	(ai_place sq_gr_b5_hall_cov)

	; if any of the ai from the previous encounter are in combat, set behaviour of the stealthed elites to hyperaware
	(sleep_until (> (ai_fighting_count gr_arena_f) 0) 1)
	(ai_set_combat_status sq_gr_b5_hall_cov alert)
)

(script dormant enc_b3_bottom_cov
	(ai_place gr_arena_c_cov)
	(ai_activity_set sq_arena_c_s1_grunts asleep)
	(ai_activity_set sq_arena_c_s2_grunts asleep)
	(ai_activity_set sq_arena_c_s3_grunts_a asleep)
	(ai_activity_set sq_arena_c_s3_grunts_b asleep)

	; wait until at least one of the squads notices the player, and then set the behaviour of the squad to defensive
;	(sleep_until (> (ai_fighting_count gr_arena_c_s3) 0) 1)
;	(ai_set_objective gr_arena_c_s3 obj_b3_bottom_cov_guards_defensive)
)

; spawn jackal at top of the lift
(script dormant enc_b3_lift_cov
	(sleep_until (volume_test_players b3_lift_cov_trigger) 1)

	; clean marines
	(ai_erase ext_a_area_a_marines)
	(ai_erase ext_a_area_b_marines)
	(ai_erase ext_b_marines)

	; (sleep_until (volume_test_players b3_top_jackal_trigger))
	(ai_place gr_stunnel_g_cov)

)

(global short s_arena_d_objcon 0)

(script dormant encounter_arena_d
	(sleep_until (volume_test_players b3_top_trigger) 1)
	(ai_place gr_arena_d)
	(ai_activity_set sq_arena_d_s1_grunts asleep)
	(wake music_trigger_22)
	(wake music_trigger_23)

	(wake arena_d_lightbridge_monitor)
)

; on b3_bridge_trigger start mission_b3_bridge
(script dormant enc_b3_bridge
	(sleep_until (volume_test_players b3_bridge_trigger) 1)

	; spawn b3 bridge squads
	(ai_place sq_gr_b3_bridge)
	(ai_place sq_gr_b4_b3_sleeping_grunts)
	(ai_place sq_gr_b3_sleeping_grunts)
	; and b4 bridge squads
	(ai_activity_set sq_gr_b3_sleeping_grunts asleep)
	(ai_activity_set sq_gr_b4_b3_sleeping_grunts asleep)

	; wait until we hit the reins trigger, and then spawn the remaining squads inside the structure
	(sleep_until (volume_test_players b3_bridge_reins_trigger) 1)
	(f_game_save)

	(ai_place sq_gr_b3_bridge_reins)
	(f_ai_magically_see_players b3_bridge_stealth_elite)
	(f_ai_magically_see_players b3_bridge_grunts_reins)
	(wake b3_stealth_guards_save)

)

(script dormant b3_stealth_guards_save
	(sleep_until (and
					(= (ai_living_count b3_bridge_stealth_elite) 0)
					(= (ai_living_count b3_bridge_stealth_elite_h_l) 0)
				)
	1 )

	(f_game_save)
)

;==============================================================
; cleanup
;==============================================================

; this is for squads only, not the objects because we don't have a point of no return yet
(script dormant tarmac_cleanup
	(sleep_until (volume_test_players tv_ext_b_b_trigger_spiral_exit) 1)
	(b3_cleanup_tarmac_squads)

	;objects
	(cleanup_b3_objects)

	; don't run garbage collector because this is mid combat
)

; split to static so teleports activated after the spiral insertion point can use it when entering the bunker with cleanup_postchasm_until_bunker
(script static void b3_cleanup_tarmac_squads
	(ai_erase gr_ext_b_area_a_cov_t) 	; ice tunnel squads
	(ai_erase gr_ext_b_area_a_drop_e)	; dropship squads
	(ai_erase gr_ext_b_area_a_cov)		; rest of tarmac squads
)

(script static void b3_cleanup_postchasm_until_bunker
	; ai squads
	(ai_erase gr_ext_b_area_c_cov) 	; bunker cov
	(ai_erase ext_b_area_b_cov) 	; spiral cov
	(b3_cleanup_tarmac_squads)		; tarmac and ice tunnel squads

	; objects
	(cleanup_b4_objects_spiral_bunker)
)

; before entering arena e
(script static void b3_cleanup_arena_c_to_arena_e
	; ai squads
	(ai_erase gr_arena_c_cov)		; arena c
	(ai_erase gr_stunnel_g_cov)   	; arena d and small tunnel g
	(ai_erase gr_arena_d)

	(ai_erase sq_gr_b3_bridge)		; twin bridge 1
	(ai_erase sq_gr_b3_sleeping_grunts)
	(ai_erase sq_gr_b4_b3_sleeping_grunts)
	(ai_disposable sq_gr_b3_bridge_reins true) ; use disposable since in case they are following

	(f_cleanup_marines)

	; objects
	(cleanup_b4_objects_arena_c_d)

	; lightbridge
	(set lightbridge_monitor_end true)

)

; before entering arena f
(script static void b3_cleanup_arena_c_to_arena_f
	; arena c, arena d, twin bridge 1
	(b3_cleanup_arena_c_to_arena_e)

	; ai squads for arena e and twin bridge 2
	(ai_erase sq_gr_b4_b_cov)				; arena e
	(ai_erase sq_gr_b4_b_cov_elites)
	(ai_erase sq_gr_b4_b_cov_elites_sword)
	(ai_erase sq_gr_b4_bridge)				; twin bridge 2, including hunter support

	; objects
	(cleanup_b4_objects_arena_e)
)

(script static void f_cleanup_marines
	; marines
	(ai_erase gr_marines_all)
)


;====================================================================================================================================================================================================
; beat 4 ============================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; insertion point: ins_b4_start =====================================================================================================================================================================
;====================================================================================================================================================================================================


(script dormant mission_b4
	(sleep_until (volume_test_players ext_c_trigger_a) 1)

	(b4_manage_zig_objects)

	(ai_place sq_gr_a_zig_cov_bottom)
	(wake mission_b4_save)
	(wake mission_b4_navpoint_loop)

	; music vo
	(wake vo_ziggurat)
	(wake vo_ziggurat_banshee_trigger)
	(wake vo_ziggurat_directive)
	(wake vo_snowfield_h_ghosts)
	(wake music_trigger_31)

	(wake mission_control)
	(wake enc_c_bridge_banshee_setup)
	(wake ziggurat_banshee_lost_trigger)
	(wake enc_c_bridge_banshee_stolen)

	(wake enc_ext_c_ghost_ini)
	(wake enc_c_bridge_initial)
	(sleep 30)
	(wake enc_c_bridge_second)
	(sleep 60)
	(ai_place sq_gr_zig_cov_bottom)

	(sleep_until (= (device_get_position c_bridge_door_near) 1) 1)
	(wake enc_c_bridge_reins)

	(sleep_until (volume_test_players ext_c_trigger_b) 1)

	; remove all bridge squads
	;(ai_erase gr_c_bridge) ; commented 12/7/25 because this is not co-op safe, but it may be required for perf.

	(ai_place sq_gr_ext_c_cov_grunts)

	(wake ini_zig_bottom_turrets)

	(sleep_until (volume_test_players tv_zig_trigger_player_past_1st_switchback) 1)
	(f_game_save)

	(sleep_until (volume_test_players tv_zig_trigger_player_past_2nd_switchback) 1)
	(ai_place sq_gr_zig_cov_top)
	(f_game_save)
	(wake ini_zig_control_turrets)
)



(script static void b4_manage_zig_objects
	; when the player comes in through rally point echo, we don't need to cleanup because nothing will have been placed
	; additionally, the insertion point will place objects earlier so they load during blacksreen instead of when the player hits the trigger volume
	(if (f_insertion_point_area_pending ins_b3_start)
		(begin ; then the player is not using rally point echo
				; b3_cleanups handle everything up to the entrance to arena f, so this just needs to handle the squads in arena f
			(ai_erase gr_arena_f)
			(ai_erase sq_gr_b5_hall_cov)

			; objects
			(cleanup_b4_objects_arena_f)
			(garbage_collect_now)

			(sleep 2)						; give the cleanup a few frames before placing new objects

			(place_b5_zig_objects)
		)
	)
)

;==============================================================
; encounter scripts (b4 ; ins_b4_start) =======================
;==============================================================

(script dormant mission_b4_save
	(wake mission_bc1_elevator_save)

	(sleep_until (volume_test_players zig_migration_trigger) 1)
	(game_save_no_timeout)
)

(script dormant mission_bc1_elevator_save
	; place in its own script because the volume can be avoided
	(sleep_until (volume_test_players c1_top_a_save) 1)
	(game_save_no_timeout)
)

(script dormant mission_control
	(sleep_until (volume_test_players control_trigger) 1)

	(ai_place sq_gr_control_cov)
	(game_save_no_timeout)
	(wake control_fight_mid_save)

	; wait until the player is in front of the door with the top squad dead and the control squad docile/dormant
	(sleep_until (and
					(volume_test_players control_trigger_save)
					(= (ai_living_count sq_gr_zig_cov_top) 0)
					(<= (ai_combat_status sq_gr_control_cov) idle)
				)
	1 )

	(game_save_no_timeout)
)

; book a save after killing the commander
(script dormant control_fight_mid_save
	(sleep_until (= (ai_living_count elite_commander_control) 0) 1)
	(game_save_no_timeout)
)

(global boolean b_elites_racing_to_banshees false)
(global boolean b_top_guards_move_in false)
(script dormant enc_c_bridge_banshee_setup
	; pie fixups
	(set b_elites_racing_to_banshees false)
	(set b_top_guards_move_in false)

    ; create banshee pilots on bridge
    (ai_place banshee_a_elite)
    (ai_place banshee_b_elite)

	(sleep 1)

    (sleep_until (or 															;race for the banshees if:
					(and															; the elites are alert and the player is pushing up the slope
						(volume_test_players c_bridge_banshee_trigger)
						(= (ai_combat_status sq_gr_c_banshee_elites) alert)
					)
					(or																; or, either pilot loses more than half its shields
						(<= (object_get_shield (ai_get_object banshee_a_elite)) 0.49)
						(<= (object_get_shield (ai_get_object banshee_b_elite)) 0.49)
					)
					(volume_test_players c_bridge_banshee_trigger_safety) 			; or safety, if the player advances too far up the slope
				)
	1 )
	(set b_elites_racing_to_banshees true) ; audio can use this
    (cs_run_command_script banshee_a_elite cs_enter_banshee_a)
    (cs_run_command_script banshee_b_elite cs_enter_banshee_b)
    (ai_set_objective banshee_a_elite aiobjective_c_bridge_banshee_elites)
    (ai_set_objective banshee_b_elite aiobjective_c_bridge_banshee_elites)

	; don't let the top squad crowd the elite pilots
	(wake send_in_top_grunts_after_delay)

	; on heroic and legendary, spawn reinforcements only if the player takes the banshee.  call the legendary logic first since that reinforcement is closer to the edge and needs to take off first to avoid cheese.
	(if (= (game_difficulty_get) legendary)
		(begin
			(sleep_until (player_in_banshee) 1)
			(f_place_legendary_banshee_pilot)
		)
	)

	(if (>= (game_difficulty_get) heroic)
		(begin
			(f_send_backup_banshee_pilot) ; the red elite on the bridge will try to get in the back banshee if the first is killed
			(sleep_until (player_in_banshee) 1)
			(f_place_heroic_banshee_pilot)
		)
	)



	; attempt a save once the pilots are dead, but we're okay with a timeout because this is a complicated canyon to save in.
	(sleep_until (= (ai_living_count sq_gr_c_banshee_elites) 0) 1)
	(f_game_save)
)

; we have top grunts on it.  top grunts.
(script dormant send_in_top_grunts_after_delay
	; give the banshee pilots time to make it to the entry spots
	(sleep (game_ticks_from_seconds 6.0))
	(set b_top_guards_move_in true)
)

(script command_script cs_enter_banshee_a
	(cs_enable_targeting true)
	(cs_enable_looking true)

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	(cs_go_to ps_c_bridge_elite/ba_enter)
	(ai_vehicle_enter ai_current_actor c_bridge_banshee_a)
)

(script command_script cs_enter_banshee_b
	(cs_enable_targeting true)
	(cs_enable_looking true)

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)

	(cs_go_to ps_c_bridge_elite/bb_enter)
	(ai_vehicle_enter ai_current_actor c_bridge_banshee_b)
)

(script dormant enc_c_bridge_banshee_stolen
	; create an incident if a player stole the elite's banshee for that’s my ride achievement.
	(sleep_until (player_in_banshee) 1)
	(submit_incident "stole_banshee_from_bridge_elite")
)

(script dormant ziggurat_banshee_lost_trigger
	(sleep_until
		(and
			(> (ai_in_vehicle_count banshee_a_elite) 0)
			(> (ai_in_vehicle_count banshee_b_elite) 0)
			(not (player_in_banshee))
		)
	1)

	; disable that's my ride achievement
	(sleep_forever enc_c_bridge_banshee_stolen)
)

(script static void f_send_backup_banshee_pilot
	(ai_vehicle_enter c_bridge_top_guards c_bridge_banshee_b)
	(ai_set_objective c_bridge_top_guards aiobjective_c_bridge_banshee_elites)
)

(script static void f_place_heroic_banshee_pilot
	(object_create_if_necessary c_bridge_banshee_c)
    (ai_place banshee_c_elite)
    (sleep (game_ticks_from_seconds 2)) ; delay a bit as the player will need to deal with the other banshee
	(ai_vehicle_enter banshee_c_elite c_bridge_banshee_c)

	(ai_set_objective banshee_c_elite aiobjective_c_bridge_banshee_elites)
)

(script static void f_place_legendary_banshee_pilot
	(object_create_if_necessary c_bridge_banshee_d)
    (ai_place banshee_d_elite)
    (sleep 1)
	(ai_vehicle_enter banshee_d_elite c_bridge_banshee_d)	; legendary only

	(ai_set_objective banshee_d_elite aiobjective_c_bridge_banshee_elites)
)

(script dormant enc_ext_c_ghost_ini
	; create ghost pilots
	(ai_place ext_c_ghost_pilot_a)
	(ai_place ext_c_ghost_pilot_b)
	(ai_place ext_c_ghost_pilot_c)

	(sleep 1)
	(wake enc_ext_c_ghost_pilot_a)
	(wake enc_ext_c_ghost_pilot_b)
	(wake enc_ext_c_ghost_pilot_c)
)

(script dormant enc_ext_c_ghost_pilot_a
	(sleep_until (and (volume_test_players tv_zig_trigger_player_in_lower_courtyard)(> (ai_fighting_count ext_c_ghost_pilot_a) 0)) 1)
	(ai_vehicle_enter ext_c_ghost_pilot_a ext_c_ghost_a)
)
(script dormant enc_ext_c_ghost_pilot_b
	(sleep_until (and (volume_test_players tv_zig_trigger_player_in_lower_courtyard)(> (ai_fighting_count ext_c_ghost_pilot_b) 0)) 1)
	(ai_vehicle_enter ext_c_ghost_pilot_b ext_c_ghost_b)
)
(script dormant enc_ext_c_ghost_pilot_c
	(sleep_until (and (volume_test_players tv_zig_trigger_player_in_lower_courtyard)(> (ai_fighting_count ext_c_ghost_pilot_c) 0)) 1)
	(ai_vehicle_enter ext_c_ghost_pilot_c ext_c_ghost_c)
)

(script dormant enc_c_bridge_initial
	(ai_place gr_c_bridge_forward)


	; wraith pilot
	(ai_place ext_c_wraith_pilot)
	(sleep 1)
	(ai_vehicle_enter_immediate ext_c_wraith_pilot ext_c_wraith)
)

(script dormant enc_c_bridge_second
	(ai_place gr_c_bridge_top)
)

(script dormant enc_c_bridge_reins
	(sleep_until (volume_test_players tv_c_bridge_reins_trigger) 1)
	(ai_place gr_c_bridge_small_hall)
	(device_set_position c_bridge_door_far 1)
	(device_one_sided_set c_bridge_door_far false)
)

;==============================================================
; helper scripts (b4 ; ins_b4_start) ==========================
;==============================================================

(script static boolean player_in_banshee
	(or (player_in_vehicle c_bridge_banshee_a) (player_in_vehicle c_bridge_banshee_b))
)

;==============================================================
; continuous scripts (b4 ; ins_b4_start) ======================
;==============================================================

(script dormant ini_zig_bottom_turrets
	(begin_random
		(sleep l_control_turret_delay)
		(begin (ai_vehicle_enter zig_cov_bot_turret_grunts_a zig_bottom_turret_a) (sleep l_control_turret_delay))
		(sleep l_control_turret_delay)
		(begin (ai_vehicle_enter zig_cov_bot_turret_grunts_b zig_bottom_turret_b) (sleep l_control_turret_delay))
		(sleep l_control_turret_delay)
	)
)

(script dormant ini_zig_control_turrets
	(begin_random
		(sleep l_control_turret_delay)
		(begin (ai_vehicle_enter zig_control_turret_grunts control_turret_a) (sleep l_control_turret_delay))
		(sleep l_control_turret_delay)
		(begin (ai_vehicle_enter zig_control_turret_grunts control_turret_b) (sleep l_control_turret_delay))
		(sleep l_control_turret_delay)
	)
)

(script dormant game_win_script
	(sleep_until (volume_test_players game_win_trigger) 1)
	(submit_incident_with_custom_string_id "game_activity_end_completed" "b40")

	; outro cutscene of mc reaching the halo control room
	(f_play_cinematic cinematics\b40\b40_outro.cinematic)
	(game_won)
)



;====================================================================================================================================================================================================
; fireteam management
;====================================================================================================================================================================================================

(script dormant f_setup_fireteam_params
	(ai_player_set_fireteam_no_max player0)

	(if (coop_players_2) (ai_player_set_fireteam_no_max player1))
	(if (coop_players_3) (ai_player_set_fireteam_no_max player2))
	(if (coop_players_4) (ai_player_set_fireteam_no_max player3))
)

; removes all fireteam members in the special squad and places them in a new objective
(script static void (f_empty_fireteam_followers_into_objective (string_id objective_following))
	(ai_player_remove_fireteam_squad player0 sq_player_followers)
	(ai_set_objective sq_player_followers objective_following) ; change objective for all new followers (if any)
)

(script static void (f_add_squad_to_fireteam_followers_with_objective (ai target_squad) (string_id objective_following))
	(f_helper_migrate_and_add_squad_to_fireteam target_squad)
	(ai_set_objective sq_player_followers objective_following) ; change objective for all new followers (if any)
)

(script static void (f_add_squad_to_fireteam_followers (ai target_squad))
	(f_helper_migrate_and_add_squad_to_fireteam target_squad)
	(ai_set_objective sq_player_followers aiobjective_followers) ; change objective for all new followers (if any)
)

(script static void (f_helper_migrate_and_add_squad_to_fireteam (ai target_squad))
	; migrate the targets into the followers squad - we'll use this to do operations on all followers.
	(ai_migrate_persistent target_squad sq_player_followers)

	; and (re) add the follower squad into the player's fireteam.
	(ai_player_add_fireteam_squad player0 sq_player_followers)
)


;====================================================================================================================================================================================================
; fireteam helpers (used from marine objectives)
;====================================================================================================================================================================================================

; called from the objective so the snowfield_a marines fight more convincingly
(script static void f_add_area_a_marines_to_followers
	(f_add_squad_to_fireteam_followers ext_a_area_a_marines_p) 		; these will only be spawned in a banshee from bridge_a case, they are the ones dropped from the pelican
	(f_add_squad_to_fireteam_followers ext_a_area_a_marines_ini)
)

; called from the objective so the snowfield_b marines fight more convincingly
(script static void f_add_area_b_marines_to_followers
	(f_add_squad_to_fireteam_followers ext_a_area_b_marines)
)

; called from the objective to mirror area_b_marine structure
(script static void f_add_postchasm_marines_to_followers
	(f_add_squad_to_fireteam_followers ext_b_postchasm_marines)
)

; called from the objective to mirror area_b_marine structure
(script static void f_add_ice_lake_marines_to_fireteam
 	(f_add_squad_to_fireteam_followers ext_b_marines)
)

; called from the objective when the unique squad runs over in snowfield_b (area_b marines)
(global boolean b_marine_needed_for_gunner true)
(script static void f_coax_unique_marine_into_scorpion_gunner_seat
	; begin_random shuffles the order; the guard flag ensures only the first squad picked gets in the tank and the rest are skipped.
	(begin_random
		(if b_marine_needed_for_gunner
			(begin
				(ai_vehicle_enter ext_a_area_b_marines_unique_b ext_a_tank "scorpion_g")
				(set b_marine_needed_for_gunner false)
			)
		)
		(if b_marine_needed_for_gunner
			(begin
				(ai_vehicle_enter ext_a_area_b_marines_unique_d ext_a_tank "scorpion_g")
				(set b_marine_needed_for_gunner false)
			)
		)
		(if b_marine_needed_for_gunner
			(begin
				(ai_vehicle_enter ext_a_area_b_marines_unique_f ext_a_tank "scorpion_g")
				(set b_marine_needed_for_gunner false)
			)
		)
		(if b_marine_needed_for_gunner
			(begin
				(ai_vehicle_enter ext_a_area_b_marines_unique_m ext_a_tank "scorpion_g")
				(set b_marine_needed_for_gunner false)
			)
		)
	)
	; reset the guard flag for any subsequent calls to this function
	(set b_marine_needed_for_gunner true)
)


;====================================================================================================================================================================================================
; navpoints
;====================================================================================================================================================================================================

; start of mission to end of bridge
(script dormant mission_b1_main_navpoints
	(sleep (game_ticks_from_seconds (+ r_sec_to_player_control r_sec_navpoint_delay)))
	(f_blip_flag navpoint_1_arena_a 0)

	(sleep_until (volume_test_players np_trigger_1b_arena_a_hinter) 1)
	(f_unblip_all)

	; don't start the hint at beginning of mission or the squads won't be placed
	(sleep_until (volume_test_players np_trigger_1b_arena_a_hinter) 1)
	(wake arena_a_hint_navpoint)

	(sleep_until (volume_test_players np_trigger_2_bridge_a) 1)
	(sleep_forever arena_a_hint_navpoint) ; player has made it past the room, so kill the hint script
	(f_unblip_all)

	; wait until the player hits the bridge
	(sleep_until (volume_test_players tv_bridge_a_elite) 1)
	(wake bridge_a_hint_navpoint)

	(sleep_until (or (volume_test_players a2_top_a_save) (volume_test_players np_trigger_7b_snowfield_a_mid)) 1)
	(sleep_forever bridge_a_hint_navpoint) ; player has made it past the bridge or jumped off into the snowfield, so kill the hint script
	(f_unblip_all)

	; to be continued in mission_b1_middle_navpoints
)

	; in case the player hits a dead end
	(script dormant arena_a_hint_navpoint
		; arena hint navpoint given if the middle squads and one of the flanks is cleared.
		(sleep_until
			(and
				(<= (ai_living_count sq_gr_a1_cov_door) 0) 												; whole door coverage
				(<= (ai_living_count sq_gr_a1_cov_middle) 0)											; whole middle of room
				(or
					(<= (+ (ai_living_count grunts_flank_left) (ai_living_count sq_gr_a1_cov_ledge)) 1) ; left flank grunts, one straggler fine
					(<= (ai_living_count grunts_flank_right) 0) 										; whole right flank
				)
			)
		1 )
		(sleep (game_ticks_from_seconds 2)) ; a little buffer so you can't feel the trigger condition so tightly
		(f_blip_flag navpoint_2_bridge_a 0)
	)

	(script dormant bridge_a_hint_navpoint
		; bridge hint given x seconds after the player kills the general; main script kills if they pass the bridge afterwards
		; this acts more like a dawdle timer than a guide, since the door is locked behind you anyway
		(sleep_until (<= (ai_living_count a_bridge_elites_general) 0) 1 )
		(sleep (game_ticks_from_seconds 7.5))
		(f_blip_flag navpoint_3_arena_b 0)
	)

; interior section: arena b following the first bridge to the beginning of snowfield a
(script dormant mission_b1_middle_navpoints
	(sleep_until (volume_test_players np_trigger_3_arena_b) 1)
	(wake arena_b_hint_navpoint)

	(sleep_until (volume_test_players np_trigger_4_small_tunnel) 1)
	(sleep_forever arena_b_hint_navpoint) ; player has made it through the arena, so kill the hint script
	(f_unblip_all)
	(f_blip_flag navpoint_5_elevator_a 0)

	(sleep_until (or (> (device_group_get elevator_a_position) 0) (volume_test_players np_trigger_6_small_tunnel_d)) 1) ; compound is for if you bypass with jetpack
	(f_unblip_all)

	; exit from lower tunnel to snowfield_a
	(sleep_until (volume_test_players np_trigger_6_small_tunnel_d) 1)
	(f_unblip_all)
	;(f_blip_flag navpoint_7_snowfield_a 0) ; linear cooridor with branches or combat, not sure what we're helping here.

	(sleep_until (volume_test_players np_trigger_7_snowfield_a) 1)
	(f_unblip_all)

	; to be continued in mission_b1_end_navpoints
)

	(script dormant arena_b_hint_navpoint
		; arena b hint is given on squad clear or reaching deep enough in the room
		(sleep_until
			(or
				(or
					(volume_test_players np_trigger_3b_bridge_b_hint_right_track)
					(volume_test_players np_trigger_3b_bridge_b_hint_overshoot)
				)
				(<= (ai_living_count sq_gr_a2_top_cov) 0)
			)
		1 )
		(sleep (game_ticks_from_seconds 1)) ; a little buffer so you can't feel the trigger condition so tightly
		(f_blip_flag navpoint_4_small_tunnel 0)
	)

; snowfield a -> snowfield c
(script dormant mission_b1_end_navpoints
	; only handle the snowfield a if we are before the scorpion point
	(if (f_insertion_point_area_pending ins_b2_middle)
		(begin
			(sleep_until (volume_test_players np_trigger_7b_snowfield_a_mid) 1)
			(f_unblip_all)
			(f_blip_flag navpoint_8a_snowfield_b 0)

			; let the player digest combat in the snowfield, and then wait for for cortana's line before the scorpion
			(sleep_until (volume_test_players np_trigger_7c_snowfield_a_mid_off) 1)
			(f_unblip_all)

			; wait for cortana callout on tank
			(sleep_until b_cortanahascalledoutscorpion 1)
			(sleep (game_ticks_from_seconds 1)) ; give a little buffer after the line so the nav feels good
			(f_unblip_all)
			(f_blip_flag navpoint_8b_scorpion 0)
		)
	)

	; wait until the player either gets in the scorpion or reaches the decision point
	(sleep_until
		(or
			(f_player_is_driving_tank)
			(volume_test_players np_trigger_8b_snowfield_b_tank_decision)
		)
	1)

	; branch on whether the player is in a vehicle or on foot
	(f_unblip_all)
	(if (any_players_in_vehicle)
		(begin ; then send the vehicle path navpoint
			(f_blip_flag navpoint_8c_snowfield_c_vehicle 0)
		)
		(begin ; else, send them on the infantry path after the ice tunnel dialogue
			(f_blip_flag navpoint_8c_snowfield_c_infantry 0)
		)
	)

	(sleep_until (f_player_has_moved_from_snowfield_b_to_snowfield_c) 1)
	(f_unblip_all)

	; to be continued mission_b2_main_navpoints
)

(script static boolean f_player_has_moved_from_snowfield_b_to_snowfield_c
	(or (volume_test_players np_trigger_8_1_snowfield_b) (volume_test_players np_trigger_8_2_snowfield_b))
)

(script dormant mission_b2_main_navpoints
	; wait for the voiceline callout on the tunnel
	(sleep_until b_cortanahascalledouttunnela 1)
	(sleep (game_ticks_from_seconds 0.5)) ; give a little buffer after the line so the nav feels good
	(f_unblip_all)
	(f_blip_flag navpoint_9_large_tunnel_a 0)

	(sleep_until (volume_test_players np_trigger_9_large_tunnel_a) 1)
	(f_unblip_all)

	;  when the player reaches the switch
	(sleep_until (volume_test_players np_trigger_9b_large_tunnel_a_switch) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_9b_large_tunnel_switch 0)

	; wait until the door starts opening
	(sleep_until (> (device_group_get chasm_door_position) 0) 1)
	(f_unblip_all)

	; to be continued in mission_b2_middle_navpoints
)

(script dormant mission_b2_middle_navpoints
	(sleep_until (volume_test_players np_trigger_10_large_tunnel_b) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_10_large_tunnel_b 0)

	(sleep_until
		(or
			b_cortanahascalledoutchasmdoor
			(> (device_get_position large_door_canyon_1) 0)
		)
	1 )

	; give a little buffer after the line so the nav feels good
	(f_unblip_all)
	(sleep (game_ticks_from_seconds 7))

	; only blip if the door isn't open
	(if (= (device_get_position large_door_canyon_1) 0)
		(begin
			(f_unblip_all)
			(f_blip_flag navpoint_10b_large_tunnel_b_switch 0)
		)
	)

	; wait until the door starts opening
	(sleep_until (> (device_get_position large_door_canyon_1) 0) 1)
	(f_unblip_all)

	; to be continued in mission_b2_ice_tunnel_navpoints
)

(script dormant mission_b2_ice_tunnel_navpoints
	(sleep_until (volume_test_players np_trigger_11_snowfield_e) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_12_snowfield_f 0)

	(sleep_until (volume_test_players np_trigger_12_snowfield_f) 1)
	(f_unblip_all)

	(sleep_until (volume_test_players np_trigger_13_spiral_down) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_14_small_cave 0)

	(sleep_until
		(or
			(volume_test_players np_trigger_14_small_cave)
			(volume_test_players tv_spiral_cave_player_over_top)
		)
	1 )
	(f_unblip_all)

	; to be continued in mission_b2_bunker_navpoints
)

(script dormant mission_b2_bunker_navpoints
	(sleep_until (volume_test_players np_trigger_15_snowfield_g) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_16_small_tunnel_e 0)

	(sleep_until (volume_test_players np_trigger_16_small_tunnel_e) 1)
	(f_unblip_all)
	(wake small_tunnel_g_hint_navpoint)

	(sleep_until (volume_test_players np_trigger_17_small_tunnel_g) 1)
	(sleep_forever small_tunnel_g_hint_navpoint) ; player has made it past the dead end, kill the hinter
	(f_unblip_all)
	(f_blip_flag navpoint_18_elevator_b 0)

	(sleep_until (> (device_group_get elevator_b_position) 0) 1)
	(f_unblip_all)

	(sleep_until (volume_test_players tv_np_bridge_e_on) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_19_bridge_e 0)

	(sleep_until (volume_test_players np_trigger_19_bridge_e) 1)
	(f_unblip_all)

	; to be continued in mission_b3_bunker_navpoints
)

; in case the player hits a dead end
(script dormant small_tunnel_g_hint_navpoint
	(sleep_until (or (volume_test_players np_trigger_17_small_tunnel_g_pocket) (volume_test_players np_trigger_17_small_tunnel_g_pocket2)) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_17_small_tunnel_g 0)
)

(global cutscene_flag last_blip_flag navpoint_17_small_tunnel_g)
(global cutscene_flag current_blip_flag navpoint_17_small_tunnel_g)
(global boolean b_nav_active false)
(global short s_nav_point_delay (game_ticks_from_seconds 1))
(global real r_unblip_distance 1)
(global real r_blip_distance 3)

(script dormant arena_e_navpoint_loop
	; wake when the player enters the interior from the bunker or lands on the twin bridges (hijack/jetpack case)
	(sleep_until (or
					(volume_test_players b3_bottom_trigger)
					(f_player_on_twin_bridges_but_not_in_banshee)
				)

	1)

	; begin nav control loop
	(f_unblip_all) ; make sure the unblip-system navs are removed
	(sleep_until
		(begin
			(arena_e_nav_control)
			(volume_test_players tv_arena_e_navend) ;exit condition
		)
	1 ) ;run every 1 tick
)

; check to see see if any player is in the volume covering the twin bridges and isn't a banshee
(script static boolean f_player_on_twin_bridges_but_not_in_banshee
	(cond
		((and (volume_test_object tv_b3_bridge player0) (not (unit_in_vehicle_type player0 s_vehicle_type_banshee))) 							true)
		((and (coop_players_2)(volume_test_object tv_b3_bridge player1) (not (unit_in_vehicle_type player1 s_vehicle_type_banshee))) 			true)
		((and (coop_players_3) (volume_test_object tv_b3_bridge player2) (not (unit_in_vehicle_type player2 s_vehicle_type_banshee))) 			true)
		((and (coop_players_4)(volume_test_object tv_b3_bridge player3) (not (unit_in_vehicle_type player3 s_vehicle_type_banshee))) 			true)

		(true 																																	false)
	)
)

(script static void arena_e_nav_control
	(cond

		((f_nav_ai_tv_check navpoint_21_arena_e_ramp sq_gr_b4_b_cov_elites tv_np_arena_e_ramp)						(f_blip_one navpoint_21_arena_e_ramp))
		((f_navend_distance_check navpoint_21_arena_e_ramp r_unblip_distance)								(f_unblip_one navpoint_21_arena_e_ramp))

		((f_nav_ai_tv_check navpoint_21_arena_e_back_ramp sq_gr_b4_b_cov_elites tv_np_arena_e_ramp_back)			(f_blip_one navpoint_21_arena_e_back_ramp))
		((f_navend_distance_check navpoint_21_arena_e_back_ramp r_unblip_distance)							(f_unblip_one navpoint_21_arena_e_back_ramp))

		; this room demands a bit more aggressive hinting, so we give the nav even if the squad isn't dead.
		((volume_test_players tv_np_arena_e_upper_exit)														(f_blip_one navpoint_21_arena_e_upper_exit))
		;((f_nav_ai_tv_check navpoint_21_arena_e_upper_exit sq_gr_b4_b_cov_elites tv_np_arena_e_upper_exit)	(f_blip_one navpoint_21_arena_e_upper_exit))
		((f_navend_distance_check navpoint_21_arena_e_upper_exit r_unblip_distance)							(f_unblip_one navpoint_21_arena_e_upper_exit))

		((f_nav_ai_tv_check navpoint_21_arena_e_exit sq_gr_b4_b_cov_elites np_trigger_21_arena_e_exit)				(f_blip_one navpoint_21_arena_e_exit))
		((f_navend_distance_check navpoint_21_arena_e_exit r_unblip_distance)								(f_unblip_one navpoint_21_arena_e_exit))

		((f_nav_ai_tv_check navpoint_22_bridge_f sq_gr_b4_b_cov_elites tv_np_arena_e_exit)							(f_blip_one navpoint_22_bridge_f))
		((f_navend_distance_check navpoint_22_bridge_f r_unblip_distance)									(f_unblip_one navpoint_22_bridge_f))
	)
)

(script dormant mission_b3_arena_f_hunter_hint
	(sleep_until (>= (ai_living_count sq_arena_f_hunters) 1) 1) ; wait for hunters to exist
	(sleep_until (= (ai_living_count sq_arena_f_hunters) 0) 1) ; then wait for them to die
	(sleep (game_ticks_from_seconds 3)) ; give a little bit of breathing room after the combat before popping the hint
	(f_unblip_all)
	(f_blip_flag navpoint_25_natural_bridge 0)
)

(script dormant mission_b4_navpoint_loop
	(sleep_forever mission_b3_arena_f_hunter_hint)
	(f_unblip_all) ; make sure the unblip-system navs are removed
	(sleep_until
		(begin
			(mission_b4_nav_control)
			(= (device_get_position large_door_ziggurat_3) 1) ;exit condition, when the last door to the control room is open
		)
		1 ;run every 1 tick
	)
)

(script static void mission_b4_nav_control
	(cond
		; door 3
		((> (device_get_position large_door_ziggurat_3) 0)													(f_unblip_one navpoint_29_control_room))

		; door 2
		((and (= (device_get_position large_door_ziggurat_2) 1)(<= (ai_living_count sq_gr_control_cov) 0))	(f_blip_one navpoint_29_control_room))
		((> (device_get_position large_door_ziggurat_2) 0)													(f_unblip_one navpoint_28b_large_hallway_2))

		; door 1
		((and (= (device_get_position large_door_ziggurat_1) 1)(<= (ai_living_count sq_gr_control_cov) 0))	(f_blip_one navpoint_28b_large_hallway_2)) ; delay a bit for combat
		((> (device_get_position large_door_ziggurat_1) 0)													(f_unblip_one navpoint_28_large_hallway_a))

		; elevator hint
		((volume_test_players tv_zig_trigger_player_in_lower_courtyard)										(f_blip_one navpoint_28_large_hallway_a))
		((volume_test_players np_trigger_26_elevator_c_off)													(f_unblip_one navpoint_26_elevator_c))
		((volume_test_players np_trigger_26_elevator_c)														(f_blip_one navpoint_26_elevator_c))

		; area starts here
		(b_cortanahascalledoutziggurat																		(f_blip_one navpoint_28_large_hallway_a))
	)
)

;=========================================
; navpoint system
;==========================================

(script static void (f_blip_one (cutscene_flag f))
	(if (!= last_blip_flag f)
		(begin
			(f_unblip_flag last_blip_flag)
			(sleep s_nav_point_delay)
			(f_blip_flag f 0)
			(set last_blip_flag f)
			(set b_nav_active true)
		)
	)
)

(script static void (f_unblip_one (cutscene_flag f))
	(set last_blip_flag f)
	(f_unblip_flag last_blip_flag)
	(set b_nav_active false)
)

(script static boolean (f_nav_ai_tv_check (cutscene_flag f) (ai encounter_squad )(trigger_volume tv_nav))

	(and
		(<= (ai_living_count encounter_squad) 0)
		(volume_test_players tv_nav)
	)
)

; normal checks are "everyone's dead and you're to a point" - this is "everyone's dead or you reach a point" so we can be a bit more aggressive on the hinting.
(script static boolean (f_nav_ai_tv_check_or (cutscene_flag f) (ai encounter_squad )(trigger_volume tv_nav))

	(or
		(<= (ai_living_count encounter_squad) 0)
		(volume_test_players tv_nav)
	)
)

(script static boolean (f_navend_distance_check (cutscene_flag f) (real d))
	(and
		(= last_blip_flag f)
		(= b_nav_active true)
		(< (objects_distance_to_flag (players) f) d)
	)
)

(script static boolean (f_navend_volume_check (cutscene_flag f) (trigger_volume tv_nav))
	(and
		(= last_blip_flag f)
		(= b_nav_active true)
		(volume_test_players tv_nav)
	)
)

; removes all navpoints used in the level
; keeping the old navpoints here until the navpoints task is closed - we might need them again in the future
(script static void f_unblip_all
	(f_unblip_flag navpoint_1_arena_a)
	(f_unblip_flag navpoint_1b_arena_a_exit)
	(f_unblip_flag navpoint_2_bridge_a)
	(f_unblip_flag navpoint_3_arena_b)
	(f_unblip_flag navpoint_4_small_tunnel)
	(f_unblip_flag navpoint_5_elevator_a)
	(f_unblip_flag navpoint_6_small_tunnel_d)
	(f_unblip_flag navpoint_7_snowfield_a)
	(f_unblip_flag navpoint_8a_snowfield_b)
	(f_unblip_flag navpoint_8b_scorpion)
	(f_unblip_flag navpoint_8c_snowfield_c)
	(f_unblip_flag navpoint_8c_snowfield_c_vehicle)
	(f_unblip_flag navpoint_8c_snowfield_c_infantry)
	(f_unblip_flag navpoint_9_large_tunnel_a)
	(f_unblip_flag navpoint_9b_large_tunnel_switch)
	(f_unblip_flag navpoint_10_large_tunnel_b)
	(f_unblip_flag navpoint_10b_large_tunnel_b_switch)
	(f_unblip_flag navpoint_11_snowfield_e)
	(f_unblip_flag navpoint_12_snowfield_f)
	(f_unblip_flag navpoint_13_spiral_down)
	(f_unblip_flag navpoint_14_small_cave)
	(f_unblip_flag navpoint_15_snowfield_g)
	(f_unblip_flag navpoint_16_small_tunnel_e)
	(f_unblip_flag navpoint_17_small_tunnel_g)
	(f_unblip_flag navpoint_18_elevator_b)
	(f_unblip_flag navpoint_19_bridge_e)
	(f_unblip_flag navpoint_20_small_tunnel_l)
	(f_unblip_flag navpoint_21_arena_e_ramp)
	(f_unblip_flag navpoint_21_arena_e_exit)
	(f_unblip_flag navpoint_21_arena_e_back_ramp)
	(f_unblip_flag navpoint_21_arena_e_upper_exit)
	(f_unblip_flag navpoint_22_bridge_f)
	(f_unblip_flag navpoint_23_small_tunnel_j)
	(f_unblip_flag navpoint_24_small_hallway_a)
	(f_unblip_flag navpoint_25_natural_bridge)
	(f_unblip_flag navpoint_26_elevator_c)
	(f_unblip_flag navpoint_27_zig_top)
	(f_unblip_flag navpoint_28_large_hallway_a)
	(f_unblip_flag navpoint_28b_large_hallway_2)
	(f_unblip_flag navpoint_29_control_room)
)

;=========================================
; chapter titles
;==========================================

(script dormant play_chapter_title_daddy
	(f_hud_chapter intro)
)

(script dormant play_chapter_title_rolling_thunder
	(sleep_until (volume_test_players tv_rolling_thunder_chapter_title) 1)
	(f_hud_chapter thunder)
)

(script dormant play_chapter_title_control
	(sleep_until (volume_test_players tv_control_chaptertitle) 1)
	(f_hud_chapter control)
	(set s_music_trigger_b40 290)
)

;=========================================
; objectives
;==========================================

; find halo's control room - golden path
(script dormant play_objective_find_control_room_nonblocking
	; timed for the boots hitting the ground, wake time matters!
	(sleep (game_ticks_from_seconds r_sec_to_player_control))
	(f_hud_obj_new "obj_b40_controlroom" "obj_b40_controlroom")
)

; rendezvous with fireteam zulu - golden path
(script dormant play_objective_zulu_nonblocking
	(sleep_until b_cortanahascalledoutrendezvous 1)
	(f_hud_obj_new_no_hud_completion "obj_b40_zulu" "obj_b40_zulu") ; you haven't actually found that control room yet, now have ya, buddy
)

; push through the covenant forces - golden path
(script dormant play_objective_push_nonblocking
	(sleep_until b_fireteamzulufoundinsnowfielda 1)
	(sleep_forever play_objective_push_jetpack_nonblocking) ; kill the safety since this went off
	(f_hud_obj_new "obj_b40_push" "obj_b40_push") ; mark rendezvous complete since you did link up
)

; push through the covenant forces (banshee/jetpack safety, when the player skips rendezvous with fireteam zulu)
(script dormant play_objective_push_jetpack_nonblocking
	(sleep_until (volume_test_players np_trigger_7b_snowfield_a_mid) 1)
	(f_hud_obj_new_no_hud_completion "obj_b40_push" "obj_b40_push") ; if you hit this safety you did not link up, so don't show as completed
)

; push through the covenant forces - rally point bravo, called from insertion script
(script dormant play_rally_point_bravo_objective_nonblocking
	(f_hud_obj_new_no_hud_completion "obj_b40_push" "obj_b40_push") ; don't show completion since this is from a rally point
)

; proceed through the substructure - golden path
(script dormant play_objective_substructure_nonblocking
	(sleep_until (volume_test_players tv_substructure_obj) 1)
	(f_hud_obj_new "obj_b40_chasm1" "obj_b40_chasm1") ; mark complete because you pushed through forces
)

; proceed through the substructure - rally point charlie, called from insertion script
(script dormant play_rally_point_charlie_objective_nonblocking
	(f_hud_obj_new_no_hud_completion "obj_b40_chasm1" "obj_b40_chasm1") ; don't show completion since this is from a rally point
)

; head for the control center ziggurat - golden path
(script dormant play_objective_ziggurat_nonblocking
	(sleep_until (volume_test_players tv_head_for_zigg_obj) 1)
	(f_hud_obj_new "obj_b40_chasm2" "obj_b40_chasm2") ; mark complete because you pushed through the substructure
)

; head for the control center ziggurat - rally point delta, called from insertion script
(script dormant play_rally_point_delta_objective_nonblocking
	(f_hud_obj_new_no_hud_completion "obj_b40_chasm2" "obj_b40_chasm2") ; don't show completion since this is from a rally point
)

; head for the control center ziggurat - rally point echo, called from insertion script
(script dormant play_rally_point_echo_objective_nonblocking
	(f_hud_obj_new_no_hud_completion "obj_b40_chasm2" "obj_b40_chasm2") ; don't show completion since this is from a rally point
)


; head for halo's control room - golden path
(script dormant play_objective_head_control_room_nonblocking
	(sleep_until b_cortanahascalledoutziggurat 1)
	(f_hud_obj_new "obj_b40_control" "obj_b40_control") ; mark complete because you found the ziggurat
)

;=========================================
; rally points
;==========================================

(script dormant b40_rally_point_unlocks
	(wake b40_unlock_rally_point_b2_scorpion)
	(wake b40_unlock_rally_point_postchasm)
	(wake b40_unlock_rally_point_b3_start)
	(wake b40_unlock_rally_point_b4_start)
	(wake b40_unlock_next_level)
)

(script dormant b40_unlock_rally_point_b2_scorpion
	(sleep_until
		(or
			(f_insertion_point_script_is_blocked ins_b2_postchasm)
			(volume_test_players tv_b2_scorpion_rally)
		) 1)

	(print_if b_debug "rally point b40: unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_b40_b2_scorpion")
	(f_unlock_insertion_point_with_incident_name "unlock_b40")
	(submit_incident_with_custom_string_id "game_activity_begin" "b40")
)

(script dormant b40_unlock_rally_point_postchasm
	(sleep_until
		(or
			(f_insertion_point_script_is_blocked ins_b3_start)
			(volume_test_players tv_b2_postchasm_rally)
		) 1)

	(print_if b_debug "rally point b40: unlocking rally point charlie")
	(f_unlock_insertion_point_with_incident_name "ins_b40_b2_postchasm")
	(f_unlock_insertion_point_with_incident_name "unlock_b40")
	(submit_incident_with_custom_string_id "game_activity_begin" "b40")
)

(script dormant b40_unlock_rally_point_b3_start
	(sleep_until
		(or
			(f_insertion_point_script_is_blocked ins_b4_start)
			(volume_test_players b3_bottom_safe)
			(volume_test_players tv_arena_e_cleanup)
			(volume_test_players tv_arena_f_cleanup)
		) 1)

	(print_if b_debug "rally point b40: unlocking rally point delta")
	(f_unlock_insertion_point_with_incident_name "ins_b40_b3_start")
	(f_unlock_insertion_point_with_incident_name "unlock_b40")
	(submit_incident_with_custom_string_id "game_activity_begin" "b40")
)

(script dormant b40_unlock_rally_point_b4_start
	(sleep_until (volume_test_players tv_b4_start_rally) 1)

	(print_if b_debug "rally point b40: unlocking rally point echo")
	(f_unlock_insertion_point_with_incident_name "ins_b40_b4_start")
	(f_unlock_insertion_point_with_incident_name "unlock_b40")
	(submit_incident_with_custom_string_id "game_activity_begin" "b40")
)

(script dormant b40_unlock_next_level
	(sleep_until (volume_test_players game_win_trigger) 1)

	(print_if b_debug "rally point b40: unlocking next level - c10")
	(f_unlock_insertion_point_with_incident_name "unlock_c10")
)

;====================================================================================================================================================================================================
; forced teleports
;====================================================================================================================================================================================================


;=================
; forced teleports - bridge a banshee/jetpack handler
;=================

; checks all players to see if any players are in the volumes that trigger the banshee/jetpack catcher logic
(script static boolean f_any_player_in_bridge_a_banshee_jetpack_catcher_volumes
	(or
		(f_player_in_bridge_a_banshee_jetpack_catcher_volumes player0)
		(and (coop_players_2) (f_player_in_bridge_a_banshee_jetpack_catcher_volumes player1))
		(and (coop_players_3) (f_player_in_bridge_a_banshee_jetpack_catcher_volumes player2))
		(and (coop_players_4) (f_player_in_bridge_a_banshee_jetpack_catcher_volumes player3))
	)

)

; split out the banshee/jetpack check per-player so it can be used for teleport logic
(script static boolean (f_player_in_bridge_a_banshee_jetpack_catcher_volumes (player player_to_check))
	(or
		(and																		; reasonable wraith-combat distance, scoped to banshee to avoid bridge/cliff jumpers
			(volume_test_object tv_snowfield_a_banshee_catcher player_to_check)
			(unit_in_vehicle_type player_to_check s_vehicle_type_banshee)
		)
		(volume_test_object tv_snowfield_a_banshee_catcher_foot player_to_check) 	; touching the ground in snowfield a, regardless of how you got there
		(volume_test_object np_trigger_7b_snowfield_a_mid player_to_check) 			; far enough down the canyon, regardless of how you got there, also drives navpoints
	)
)

(global boolean b_player_skipping_bridge_a false) ; fires if the player crosses the jetpack catch boundary or enters the snowfield a canyon in a banshee, used by the objective editor to unlock the vista wraith.  available for audio as well.
(script dormant b1_bridge_a_banshee_jetpack_catcher
	(set b_player_skipping_bridge_a false) ; pie objective editor fixup
	(sleep_until (f_any_player_in_bridge_a_banshee_jetpack_catcher_volumes) 1)
	(set b_player_skipping_bridge_a true)

	; remove the golden path teleport so we don't double place b2 objects
	(sleep_forever b1_teleport_and_cleanup_snowfield_a)

	; teleport players
		; however, since trigger volumes don't support multiple heights, we have to use multiple trigger volumes...
		; so use a helper to check if they're in any of the volumes and teleport accordingly
	(if (coop_players_2)
	(begin ; then at least 2p coop - check if player0 or player1 needs teleport, and make it so
			(if (not (f_player_in_bridge_a_banshee_jetpack_catcher_volumes player0))
				(begin ; then player is not in volume and needs teleport
					(object_teleport player0 flag_bridge_a_skip_tele)
				)
			)
			(if (not (f_player_in_bridge_a_banshee_jetpack_catcher_volumes player1))
				(begin ; then player is not in volume and needs teleport
					(object_teleport player1 flag_bridge_a_skip_tele)
				)
			)
		)
	)

	(if (coop_players_3)
		(begin ; then at least 3p coop - check if player2 needs teleport, and make it so
			(if (not (f_player_in_bridge_a_banshee_jetpack_catcher_volumes player2))
				(begin ; then player is not in volume and needs teleport
					(object_teleport player2 flag_bridge_a_skip_tele)
				)
			)
		)
	)

	(if (coop_players_4)
		(begin ; then 4p coop - check if player3 needs teleport, and make it so
			(if (not (f_player_in_bridge_a_banshee_jetpack_catcher_volumes player3))
				(begin ; then player is not in volume and needs teleport
					(object_teleport player3 flag_bridge_a_skip_tele)
				)
			)
		)
	)

	; point of no return
	(f_powerdown_arena_b_entrance)	; don't let players return to any interior spaces - there may be dormant triggers we need to avoid

	; cleanup/placement, separated to static for readbility
	(bridge_a_jetpack_banshee_fixup)
)

; non golden path, used when the player hijacks or flies down with the jetpack skull
; invoked from the banshee catcher
(script static void bridge_a_jetpack_banshee_fixup
	; remove post bridge_a objectives
	(sleep_forever play_objective_push_nonblocking) ; this is a safety for jetpack/banshee hijacks, so kill the other to avoid doubling up on backtrack
	(sleep_forever play_objective_zulu_nonblocking) ; this is a safety for jetpack/banshee hijacks, and the bridge dialog might be pending if you jetpack immediately, so kill that too.

	; ensure vista squads can be killed
	(f_prepare_bridge_a_vista_for_combat)

	; cut out bridge a vo lines per audio if this happens
	(sleep_forever vo_bridge_a_trigger)
	(sleep_forever vo_bridge_a) ; this is the script the vo_bridge_a_trigger script wakes
	(sleep_forever vo_arena_b)

	; ensure snowfield b and c are populated with vehicles and pickups since the player didn't pass through the elevator
	(place_b2_objects_snowfield_b_and_c_only)
)

;=================
; forced teleports - snowfield a
;=================

; snowfield a, just before the entrance
(script dormant b1_teleport_and_cleanup_snowfield_a
	(sleep_until (volume_test_players tv_snwfld_a_vista_cleanup) 1)

	; if the player took this route they are on golden path and don't need the banshee handler anymore
	(sleep_forever b1_bridge_a_banshee_jetpack_catcher)

	; teleport players not in safety
	(volume_teleport_players_not_inside tv_snwfld_a_vista_safe flag_snwfld_a_tele)

	; point of no return
	(device_set_power elevator_a_control_1 0) 	; disable the power to the control at the bottom of the elevator
	(device_set_power elevator_a_control_2 0) 	; disable the power to the control at the top of the elevator
	(device_set_position elevator_a 1) 			; and ensure the elevator is going in the right direction, to the "down" position.

	(f_powerdown_arena_b_entrance)				; and since the elevator won't work anymore, don't let players back in this room

	; cleanup
	(b1_cleanup)
	(garbage_collect_now)

	(sleep 2) ; small delay between cleanup and placement

	; place new objects
	(place_b2_objects)
)

;=================
; forced teleports - chasm
;=================

; prechasm, after the door shuts, for when the zone set doesn't pull them past the door
; this needs to handle players in vehicles so the tank doesn't get left behind... and that's going to suck.
(script dormant b2_teleport_and_cleanup_prechasm
	(sleep_until (volume_test_players tv_chasm_entrance_door) 1)

	; teleport players not in safety
	(if (coop_players_2)
	(begin ; then at least 2p coop - check if player0 or player1 needs teleport, and make it so
			(f_volume_teleport_player_not_inside_with_vehicle player0 tv_prechasm_safe (f_get_safe_cutscene_flag_prechasm))
			(f_volume_teleport_player_not_inside_with_vehicle player1 tv_prechasm_safe (f_get_safe_cutscene_flag_prechasm))
		)
	)

	(if (coop_players_3)
		(begin ; then at least 3p coop - check if player2 needs teleport, and make it so
			(f_volume_teleport_player_not_inside_with_vehicle player2 tv_prechasm_safe (f_get_safe_cutscene_flag_prechasm))
		)
	)

	(if (coop_players_4)
		(begin ; then 4p coop - check if player3 needs teleport, and make it so
			(f_volume_teleport_player_not_inside_with_vehicle player3 tv_prechasm_safe (f_get_safe_cutscene_flag_prechasm))
		)
	)

	; point of no return
	(device_set_power dm_tun_garage_3 0) ; turn off power so it will be red when you look at it and will not open
	(device_set_position_immediate dm_tun_garage_3 0)

	; cleanup
	(b2_cleanup)
	(garbage_collect_now)

	(sleep 2) ; small delay between cleanup and placement

	; place new objects
	(place_b3_objects)
)

; this would read *far* more cleanly as a cond, but using a cond to return cutscene flags purges scripts after a successful compile for some reason.
(script static cutscene_flag f_get_safe_cutscene_flag_prechasm
	(if (not (volume_test_players tv_pre_chasm_flag_a_safety))
		(begin ; then zone a clear, return flag_a
			flag_pre_chasm_teleport_a
		)
		(begin ; else zone a is not clear, so try zone b
			(if (not (volume_test_players tv_pre_chasm_flag_b_safety))
				(begin ; then zone b clear, return flag_b
					flag_pre_chasm_teleport_b
				)
				(begin ; else neither zone a nor zone b clear, so return zone_c.  because there are only 4 players and one must be triggering this teleport (not in any zone), this zone must be clear
					flag_pre_chasm_teleport_c
				)
			)
		)
	)
)

; this teleport was removed in the zone set pass in early april so that players can backtrack for the daddy skull, but it can be resurrected here if we need the memory from reclaiming the chasm.
; until then, this is basically a cleanup script, centralized with the other ponr's for readability.
(script dormant b2_teleport_and_cleanup_postchasm
	(sleep_until (volume_test_players tv_postchasm_cleanup) 1)

	; teleport players not in safety
	; the flags and safety volumes for a vehicle teleport need implemented if we resurrect as we do in the prechasm teleport.  use tv_postchasm_clean_safe as the safe volume. flags need to be created
	;
	; point of no return
	;(device_set_power large_door_canyon_1 0) ; turn off power so it will be red when you look at it and will not open
	;(device_set_position_immediate large_door_canyon_1 0)

	; cleanup
	(b2_cleanup_chasm)
)



;=================
; forced teleports - twin bridges
;=================

(script dormant b3_teleport_and_cleanups
	(wake b3_teleport_and_cleanup_arena_c)
	(wake b3_teleport_and_cleanup_arena_d)
	(wake b3_teleport_and_cleanup_arena_e)
	(wake b3_teleport_and_cleanup_arena_f)
)

; arena c, just after the bunker.  disables the arena f teleport.
(script dormant b3_teleport_and_cleanup_arena_c
	(sleep_until (volume_test_players b3_bottom_cleanup) 1 )

	; if we insert after in delta, we're already inside the bunker, and echo inserts can't backtrack.
	; so skip the unneeded teleport, ponr, and cleanup
	(if (f_insertion_point_area_pending ins_spiral)
		(begin

			; teleport players not in safety
			(volume_teleport_players_not_inside b3_bottom_safe flag_b3_bottom_tele)

			; point of no return - though technically, players will be able to jetpack back to the bunker entrance from the bridge...  but if they do that, they need to jetpack back up.
			; arena d will lock the elevator behind you anyway, so there's no other option.
			(f_powerdown_bunker_entrance)

			; cleanup
			(ai_kill gr_ext_b_area_c_cov_hallway) ; if the player sprints to the zone these bodies can still be around the corner, so kill them naturally

			(sleep 2)							  ; ai_kill is expensive, so let the deaths play out before cleaning up the rest behind us

			; objects
			(b3_cleanup_postchasm_until_bunker)
			(garbage_collect_now)

			(sleep 2) 								; give the cleanup a few frames before placing new objects
		)
	)

	; create new objects, even when we are using the insertion point
	(place_b4_objects_arena_c_d)
)

; arena d, as the elevator begins to rise.  this is for co-op experience rather than memory, so cleanup is limited.
(script dormant b3_teleport_and_cleanup_arena_d
	(sleep_until (volume_test_players tv_arena_d_cleanup) 1)

	; teleport players not in safety
	(volume_teleport_players_not_inside tv_arena_d_safe flag_arena_d_tele)

	; point of no return
	(device_set_power elevator_b_control_1 0) 	; disable the power to the control at the bottom of the elevator
	(device_set_power elevator_b_control_2 0) 	; disable the power to the control at the top of the elevator
	(device_set_position elevator_b 1) 			; and ensure the eleavtor is going in the right direction, to the "up" position

	; cleanup - this really only needs to cleanup arena_d since the arena_c teleport will have just cleaned up until the bunker.
	; so just mark the arena d guys as disposable and erase the marines, no need for a dedicated function
	(ai_disposable gr_arena_c_cov true)
	(f_cleanup_marines)
	(garbage_collect_now)

	(game_save_no_timeout)
)

; arena e, at the end of the first twin bridge, only used when the player takes the banshee or jetpacks up from the bunker.  disables the arena c and arena d teleport.
(script dormant b3_teleport_and_cleanup_arena_e
	(sleep_until (volume_test_players tv_arena_e_cleanup) 1)

	; if these are still running, the player took the banshee/jetpack route and took the first bridge
	; so remove the interior bunker teleports as this would be backtracking and we don't want to teleport people backwards
	(sleep_forever b3_teleport_and_cleanup_arena_c)
	(sleep_forever b3_teleport_and_cleanup_arena_d)

	; teleport players not in safety
	(volume_teleport_players_not_inside tv_arena_e_tele_safe flag_arena_e_tele)

	; point of no return
	(f_powerdown_bunker_entrance) ; in all cases, don't let players reenter the bunker after hitting this, due to erases, to cover jetpack/banshee pass

	; in coop only, lock the door back to first twin bridge so the hunters in the next section can't spawn on top of you
	; in solo, leave the door open so players can backtrack for weapons. since they can't be in two places at once, hunter spawns are not an issue.
	(if (coop_players_2)
		(begin
			(f_powerdown_arena_e_entrance)
		)
	)

	; cleanup
	(b3_cleanup_arena_c_to_arena_e)			; in case this is golden path
	(b3_cleanup_postchasm_until_bunker)		; in case this is banshee/jetpack
	(garbage_collect_now)

	(sleep 2) 								; give the cleanup a few frames before placing new objects

	; place new objects
	(place_b4_objects_arena_e)

	(game_save_no_timeout)
)

; arena f, at the end of the second twin bridge, only used when the player takes the banshee or jetpacks up from the bunker.  disables the arena c and arena d and arena e teleport.
(script dormant b3_teleport_and_cleanup_arena_f
	(sleep_until (volume_test_players tv_arena_f_cleanup) 1)

	; if these are still running, the player took the banshee/jetpack route and took the second bridge,
	; so remove the interior bunker teleports and the as this would be backtracking and we don't want to teleport people backwards
	(sleep_forever b3_teleport_and_cleanup_arena_c)
	(sleep_forever b3_teleport_and_cleanup_arena_d)
	(sleep_forever b3_teleport_and_cleanup_arena_e)


	; teleport players not in safety
	(volume_teleport_players_not_inside tv_arena_f_tele_safe flag_arena_f_tele)

	; point of no return
	(device_set_power dm_hexdoor_arena_f 0) ; turn off power so it will be red when you look at it and will not open
	(device_set_position_immediate dm_hexdoor_arena_f 0)

	; this also closes the bunker exit and twin-bridge 1 entrance from the outside in case this is banshee/jetpack
	(f_powerdown_bunker_entrance)
	(f_powerdown_arena_e_entrance)

	; cleanup
	(b3_cleanup_arena_c_to_arena_f)		; in case this is golden path
	(b3_cleanup_postchasm_until_bunker)	; in case this is banshee/jetpack
	(garbage_collect_now)

	; objects

	(sleep 2)							; give the cleanup a few frames before placing new objects

	; create new objects
	(place_b4_objects_arena_f)

	(game_save_no_timeout)
)

;=================
; forced teleports - helpers
; 	helpers, since these get reused a few times on the twin bridge teleports and the names are the worst
;=================

(script static void f_powerdown_arena_b_entrance
	(device_set_power dm_hexdoor_arena_b 0) ; turn off power so it will be red when you look at it and will not open
	(device_set_position_immediate dm_hexdoor_arena_b 0)
)

(script static void f_powerdown_bunker_entrance
	(device_set_power dm_hexdoor_bunker 0) ; turn off power so it will be red when you look at it and will not open
	(device_set_position_immediate dm_hexdoor_bunker 0)
)

(script static void f_powerdown_arena_e_entrance
	(device_set_power dm_hexdoor_arena_e 0) ; turn off power so it will be red when you look at it and will not open
	(device_set_position_immediate dm_hexdoor_arena_e 0)
)

;====================================================================================================================================================================================================
; object place and cleanup functions
;====================================================================================================================================================================================================

; //////
; mission intro, arena a, and bridge a (except the vista objects, which are managed inline)
; //////
(script static void place_b1_objects
	(object_create_folder bof_shields_insertion)
	(object_create_folder bof_vehicle_cleanup_1)
	(object_create_folder bof_pickup_cleanup_1)
	(object_create_folder bof_body_cleanup_1)
	(object_create_folder bof_crate_cleanup_1)
)

(script static void cleanup_b1_objects
	(object_destroy_folder bof_shields_insertion)
	(object_destroy_folder bof_vehicle_cleanup_1)
	(object_destroy_folder bof_pickup_cleanup_1)
	(object_destroy_folder bof_body_cleanup_1)
	(object_destroy_folder bof_crate_cleanup_1)
)

; //////
; snowfields a, snowfield b, and snowfield c
; //////

(script static void place_b2_objects
	(object_create_folder bof_vehicle_cleanup_2_snfld_a) ; the wraith and two turrets are created earlier as part of bof_vehicle_cleanup_2_snfld_a_vista when the player enters bridge_a
	(object_create_folder bof_pickup_cleanup_2_snfld_a)
	(object_create_folder bof_body_cleanup_2_snfld_a)
	(object_create_folder bof_crate_cleanup_2_snfld_a)
	(place_b2_objects_snowfield_b_and_c_only) ; split snowfield b & c into a static so they can be called from rally point bravo as well as handle the jetpack down from the bridge
)
(script static void place_b2_objects_snowfield_b_and_c_only
	(object_create_folder bof_vehicle_cleanup_2_snfld_b)
	(object_create_folder bof_pickup_cleanup_2_snfld_b)
	(object_create_folder bof_body_cleanup_2_snfld_b)
	(object_create_folder bof_crate_cleanup_2_snfld_b)

	(object_create_folder bof_vehicle_cleanup_2_snfld_c)
	(object_create_folder bof_pickup_cleanup_2_snfld_c)
	(object_create_folder bof_body_cleanup_2_snfld_c)
	(object_create_folder bof_crate_cleanup_2_snfld_c)
)

(script static void cleanup_b2_objects
	(object_destroy_folder bof_vehicle_cleanup_2_snfld_a_vista)

	(object_destroy_folder bof_vehicle_cleanup_2_snfld_a)
	(object_destroy_folder bof_vehicle_cleanup_2_snfld_b)
	(object_destroy_folder bof_vehicle_cleanup_2_snfld_c)

	(object_destroy_folder bof_pickup_cleanup_2_snfld_a)
	(object_destroy_folder bof_pickup_cleanup_2_snfld_b)
	(object_destroy_folder bof_pickup_cleanup_2_snfld_c)

	(object_destroy_folder bof_body_cleanup_2_snfld_a)
	(object_destroy_folder bof_body_cleanup_2_snfld_b)
	(object_destroy_folder bof_body_cleanup_2_snfld_c)

	(object_destroy_folder bof_crate_cleanup_2_snfld_a)
	(object_destroy_folder bof_crate_cleanup_2_snfld_b)
	(object_destroy_folder bof_crate_cleanup_2_snfld_c)
)

; //////
; chasm and tarmac
; //////

(script static void place_b3_objects
	(object_create_folder bof_vehicle_cleanup_3_chasm)
	(object_create_folder bof_pickup_cleanup_3_chasm)
	(object_create_folder bof_body_cleanup_3_chasm)
	(object_create_folder bof_crate_cleanup_3_chasm)
	(place_b3_objects_tarmac_only) ; split tarmac into a static so it can be called from rally point charlie (insertion script)
)
(script static void place_b3_objects_tarmac_only
	(object_create_folder bof_vehicle_cleanup_3_tarmac)
	(object_create_folder bof_pickup_cleanup_3_tarmac)
	(object_create_folder bof_body_cleanup_3_tarmac)
	(object_create_folder bof_crate_cleanup_3_tarmac)
)

(script static void cleanup_b3_objects
	(object_destroy_folder bof_vehicle_cleanup_3_chasm)
	(object_destroy_folder bof_pickup_cleanup_3_chasm)
	(object_destroy_folder bof_body_cleanup_3_chasm)
	(object_destroy_folder bof_crate_cleanup_3_chasm)
	(object_destroy_folder bof_vehicle_cleanup_3_tarmac)
	(object_destroy_folder bof_pickup_cleanup_3_tarmac)
	(object_destroy_folder bof_body_cleanup_3_tarmac)
	(object_destroy_folder bof_crate_cleanup_3_tarmac)
)


; //////
; spiral and bunker
; //////

(script static void place_b4_objects_spiral_bunker
	(object_create_folder bof_shields_4_spiral_bunker)
	(object_create_folder bof_vehicle_cleanup_4_spiral_bunker)
	(object_create_folder bof_pickup_cleanup_4_spiral_bunker)
	(object_create_folder bof_body_cleanup_4_spiral_bunker)
	(object_create_folder bof_crate_cleanup_4_spiral_bunker)
)

; called from the arena ponrs
(script static void cleanup_b4_objects_spiral_bunker
	(object_destroy_folder bof_shields_4_spiral_bunker)
	(object_destroy_folder bof_vehicle_cleanup_4_spiral_bunker)
	(object_destroy_folder bof_pickup_cleanup_4_spiral_bunker)
	(object_destroy_folder bof_body_cleanup_4_spiral_bunker)
	(object_destroy_folder bof_crate_cleanup_4_spiral_bunker)
)

; //////
; twin bridges - arena c and d
; //////
(script static void place_b4_objects_arena_c_d
	(object_create_folder bof_pickup_cleanup_4_arena_c_d)
	(object_create_folder bof_body_cleanup_4_arena_c_d)
	(object_create_folder bof_crate_cleanup_4_arena_c_d)
)

(script static void cleanup_b4_objects_arena_c_d
	(object_destroy_folder bof_pickup_cleanup_4_arena_c_d)
	(object_destroy_folder bof_body_cleanup_4_arena_c_d)
	(object_destroy_folder bof_crate_cleanup_4_arena_c_d)
)

; //////
; twin bridges - arena e
; //////
(script static void place_b4_objects_arena_e
	(object_create_folder bof_pickup_cleanup_4_arena_e)
	(object_create_folder bof_body_cleanup_4_arena_e)
	(object_create_folder bof_crate_cleanup_4_arena_e)
)

(script static void cleanup_b4_objects_arena_e
	(object_destroy_folder bof_pickup_cleanup_4_arena_e)
	(object_destroy_folder bof_body_cleanup_4_arena_e)
	(object_destroy_folder bof_crate_cleanup_4_arena_e)
)

; //////
; twin bridges - arena f
; //////
(script static void place_b4_objects_arena_f
	(object_create_folder bof_pickup_cleanup_4_arena_f)
	(object_create_folder bof_body_cleanup_4_arena_f)
	(object_create_folder bof_crate_cleanup_4_arena_f)
)

(script static void cleanup_b4_objects_arena_f
	(object_destroy_folder bof_pickup_cleanup_4_arena_f)
	(object_destroy_folder bof_body_cleanup_4_arena_f)
	(object_destroy_folder bof_crate_cleanup_4_arena_f)
)

; //////
; ziggurat canyon & control room
; //////
(script static void place_b5_zig_objects
	(object_create_folder bof_shields_5)
	(object_create_folder bof_vehicle_cleanup_5)
	(object_create_folder bof_pickup_cleanup_5)
	(object_create_folder bof_body_cleanup_5)
	(object_create_folder bof_crate_cleanup_5)
)

; no need to cleanup end of level

;====================================================================================================================================================================================================
; bridge monitors
; light bridges interpolate through space due to an animation issue, killing everything below them
; thus, we use two device machines, one for collision (the real one, invisible) and a vignette machine for the visual.
;
; to use, configure the device control to use a device group, but do not hook the bridge itself up to the device group.
; let the script listen to the group changes and create/destroy collision as it toggles the visuals accordingly.
;====================================================================================================================================================================================================

(global boolean lightbridge_monitor_end false)

(script dormant arena_d_lightbridge_monitor
	(print "lightbridge monitor started")
	(branch lightbridge_monitor_end (lightbridge_monitor_over)) ;end script when player reaches point of no return

	;have light bridge be on from the start
	(device_set_position_immediate dm_lightbridge_visuals 1)

	(sleep_until
		(begin
			(f_toggle_lightbridge_on_group_change dm_lightbridge_collision dm_lightbridge_visuals dg_lightbridge_position)

			false ; exit condition
		)
		1
	)
)

(script static void lightbridge_monitor_over
	(print "lightbridge monitor ended")
)

(script static void (f_toggle_lightbridge_on_group_change (device_name lightbridge_collision) (device_name lightbridge_visuals) (device_group lightbridge_group))
	; ; wait until the device group is on, then create the collision and toggle the visuals on
	(sleep_until (= (device_group_get lightbridge_group) 1) 1)
	(object_create lightbridge_collision)
	(device_set_position_immediate lightbridge_visuals 1)

	; wait until the device group is off, then remove the collision and toggle the visuals off
	(sleep_until (= (device_group_get lightbridge_group) 0) 1)
	(object_destroy lightbridge_collision)
	(device_set_position_immediate lightbridge_visuals 0)

	; prevent idle players from coyote-floating when the bridge goes away
	(sleep 1)
	(object_wake_physics player0)
	(object_wake_physics player1)
	(object_wake_physics player2)
	(object_wake_physics player3)
)

;====================================================================================================================================================================================================