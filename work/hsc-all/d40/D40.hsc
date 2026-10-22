(global boolean b_debug_gameplay true)

(global short enc1_4_spawn_max 20)
(global short enc1_4_spawn_count 0)

(global boolean b_enc4_spawn_flood_wave false)

(global real r_spawn_scale 1.0)
(global short s_min_combat_spawn 2)

(global short s_min_carrier_spawn 2)
(global short s_min_infection_spawn 4)

(global boolean b_enc1_4_manager_complete false)
(global short s_enc1_4_limiter 0)

(global boolean dialogue_bridge_ready false)
(global boolean mark_bridge_cutscene false)

(global boolean b_enc3_5_manager_complete false)
(global short s_enc3_5_limiter 0)
(global boolean b_enc3_6_manager_complete false)
(global short s_enc3_6_limiter 0)

(global boolean b_enc4_2_manager_complete false)
(global short s_enc4_2_limiter 0)

(global boolean b_dialogue_monitor_player false)
(global boolean b_dialogue_monitor_self false)
(global boolean b_dialogue_monitor_complete false)
(global boolean b_foehammer_crash_start false)
(global boolean b_foehammer_crash_complete false)

(global boolean b_race_over false)
(global boolean b_player_longsword false)
(global short warthog_interval 0)
(global cutscene_flag race_end_point fl_foehammer_rv_point)
(global short warthog_race_direction 0)
(global short last_player_end_distance 0)

;====================================================================================================================================================================================================
; level startup ==============================================================================================================================================
;====================================================================================================================================================================================================
(script startup d40_start
	(ai_allegiance player human)
	(d40_insertion_point_fixups)
	(f_start_auto_save_loop)

	(coop_control)
	(diff_control)
	(wake d40_music_controller)

	(if (f_insertion_point_area_pending insertion_start) (wake d40_beat_1))
	(if (f_insertion_point_area_pending insertion_bridge) (wake d40_beat_2))
	(if (f_insertion_point_area_pending insertion_cryo) (wake d40_beat_3))
	(if (f_insertion_point_area_pending insertion_tube) (wake d40_beat_4))
	(if (f_insertion_point_area_pending insertion_engine) (wake d40_beat_5))
	(if (f_insertion_point_area_pending insertion_warthog) (wake d40_beat_6))
	(if (f_insertion_point_area_pending insertion_longsword) (wake d40_beat_7))
)

(script static void coop_control
	(if
		(game_is_cooperative)
		(begin
			; * 1.2-1.4
			(set r_spawn_scale (* r_spawn_scale (+ 1.0 (/ (game_coop_player_count) 10))))
			; + 1-3
			(set s_min_combat_spawn (+ s_min_combat_spawn (game_coop_player_count) -1))
		)
	)
)

(script static void diff_control
	(if
		(= "heroic" (game_difficulty_get))
		(begin
			(set r_spawn_scale (* r_spawn_scale 1.1))
			(set s_min_combat_spawn (+ s_min_combat_spawn 1))
			(set s_min_carrier_spawn (+ s_min_carrier_spawn 1))
			(set s_min_infection_spawn (+ s_min_infection_spawn 1))
		)
	)
	(if
		(= "legendary" (game_difficulty_get))
		(begin
			(set r_spawn_scale (* r_spawn_scale 1.25))
			(set s_min_combat_spawn (+ s_min_combat_spawn 1))
			(set s_min_carrier_spawn (+ s_min_carrier_spawn 1))
			(set s_min_infection_spawn (+ s_min_infection_spawn 2))
		)
	)
)

; =================================================================================================
; chapter scripts
; =================================================================================================
(script dormant present_chapter_1
	(f_hud_chapter chapter_d40_1)
	(sleep (game_ticks_from_seconds 2.0))
	(f_hud_obj_new obj_d40_bridge obj_d40_bridge)
	(sleep (game_ticks_from_seconds 2.0))
	(f_exclusive_blip_flag fl_ladder 0)
)

(script dormant present_chapter_2
	; the two chapters were designed to spool out in legacy
	; that's now done through the chapter title data in blamscenario, with automatic timing
	(f_hud_chapter_slow chapter_d40_2_left)
)

(script dormant present_chapter_3
	(f_hud_chapter chapter_d40_3)
	(sleep (game_ticks_from_seconds 2.0))
	(f_hud_obj_new obj_d40_escape obj_d40_escape)
)

;====================================================================================================================================================================================================
; d40_beat_1
;====================================================================================================================================================================================================

(script dormant d40_beat_1
	(wake beat_1_object_handling)
	(wake section1)
	(wake section2)
)

(script dormant beat_1_object_handling
	(object_create_folder crates_start)
	(object_create_folder w_cafeteria)
	(object_create_folder eq_cafeteria)
	(object_create_folder bi_cafeteria)

	(sleep_until mark_bridge_cutscene 1)
	(object_destroy_folder crates_start)
	(object_destroy_folder w_cafeteria)
	(object_destroy_folder eq_cafeteria)
	(object_destroy_folder bi_cafeteria)
	(garbage_collect_now)
)

(script dormant section1
	; unlock progress data
	(submit_incident "ins_d40_start")
	(submit_incident "unlock_d40")
	(submit_incident_with_custom_string_id "game_activity_begin" "d40")

	(print_if b_debug_gameplay "cinematic dialog: m10_maw - cin01_intro")
	(f_play_cinematic cinematics\d40\d40_intro.cinematic)
	(wake present_chapter_1)
	(wake music_intro)

	(sleep_until (volume_test_players tv_section1) 1)
	(print "d40_beat_1")

	;(print_if b_debug_gameplay "vo: cortana tells chief to go to the briedge.")
	(wake dialogue_mission_start)
	(game_save_no_timeout)

	(wake enc1_0)
	(wake enc1_1)
	(wake enc1_2)
	(wake enc1_3)
	(wake enc1_4)
	(wake mus_03)
	(wake nav_beat_1)
)

(script dormant enc1_0
	;(obj_bridge)
	(game_save_no_timeout)
	(sleep (game_ticks_from_seconds 10.0))
	; place the units, twice for quantity
	(ai_place gr_enc1_0_sents)
	(sleep (game_ticks_from_seconds 2.0))
	(ai_place gr_enc1_0_sents)
)

(script dormant enc1_1
	(sleep_until (volume_test_players tv_enc1_1) 1)
	(game_save_no_timeout)
	(f_ai_place_over_ticks gr_enc1_1_sents gr_enc1_1_flood none none none none)
)

(script dormant enc1_2
	(sleep_until (volume_test_players tv_enc1_2) 1)
	(game_save_no_timeout)
	(ai_place gr_enc1_2_flood)
)

(script dormant enc1_3
	(sleep_until (volume_test_players tv_enc1_3) 1)
	; music
	; (sound_looping_set_alternate "levels\d40\music\d40_01" true)
)

(script dormant enc1_4
	(sleep_until (volume_test_players tv_enc1_4) 1)
	(volume_teleport_players_not_inside tv_coop_00_encounter1_4 fl_coop_00_encounter1_4)
	(game_save_no_timeout)

	(sleep_until (objects_can_see_object (players) dm_enc1_4_door 10) 1)
	(device_set_position dm_enc1_4_door 1)
	(sleep_until (> (device_get_position dm_enc1_4_door) 0.4) 1)

	(f_ai_place_over_ticks sq_enc1_4_flood_ic sq_enc1_4_flood_ii gr_enc1_4_flood none none none)
	(wake enc1_4_manager)
	(sleep_until (volume_test_players tv_enc1_5) 1)
	(set b_enc1_4_manager_complete true)
)

(script dormant enc1_4_manager
	(sleep_until
		(begin
			(if (<= s_enc1_4_limiter (* 20 r_spawn_scale))
				(begin
					(if
						(< (ai_living_count sq_enc1_4_flood_c) s_min_combat_spawn)
						(begin
							(ai_place sq_enc1_4_flood_c 1)
							(set s_enc1_4_limiter (+ s_enc1_4_limiter 1))
						)
					)
					(if
						(< (ai_living_count sq_enc1_4_flood_i) s_min_infection_spawn)
						(begin
							(ai_place sq_enc1_4_flood_i)
						)
					)
				)
			)
 			b_enc1_4_manager_complete
		)
 		1
	)
)

(script dormant section2
	(sleep_until (volume_test_players tv_section2) 1)
	; music
	; (sound_looping_set_alternate "levels\d40\music\d40_01" false)
	; backtracking door
	; (device_set_position_immediate dm_bsp0_cutoff 0)
	(wake enc2_1)
	(game_save_no_timeout)
	(ai_disposable gr_enc1_0_sents true)
)

(script dormant enc2_1
	(sleep_until (volume_test_players tv_enc2_1) 1)
	(game_save_no_timeout)
	(wake enc2_2)

	(ai_place gr_enc2_1_flood)
)

(script dormant enc2_2
	(game_save_no_timeout)
	(wake enc2_4)
	(wake enc2_5)
	(ai_place sq_enc2_2_flood_c)

	(sleep_until (volume_test_players tv_enc2_2) 1)
	(f_ai_place_over_ticks sq_enc2_2_cov_e sq_enc2_2_cov_s sq_enc2_2_cov_s2 none none none)
	;(wake enc2_5_music)
	(wake mus_04)

	(if
		(= (game_difficulty_get_real) "easy")
		(begin
			(device_set_position_immediate dm_enc2_1_door2 1)
			(device_set_position_immediate dm_enc2_1_door1 1)
		)
		(begin
			(ai_place sq_enc2_2_cov_h)
			(device_set_position dm_enc2_1_door2 1)
			(sleep (game_ticks_from_seconds 4.0))
			(device_set_position dm_enc2_1_door1 1)
		)
	)

	(ai_place sq_enc2_2_flood_i)
	(sleep_until
		(= 0 (ai_living_count sq_enc2_2_cov_h))
 		1
	)
	(game_save_no_timeout)
	(sleep (game_ticks_from_seconds 3.0))
	; music
	; (sound_looping_stop "levels\d40\music\d40_01")
)

(script command_script cs_enc2_2_hunter1
	(sleep_until (> (device_get_position dm_enc2_1_door2) 0.37) 1)
	(cs_smash_direction 0)
)

(script command_script cs_enc2_2_hunter2
	(sleep_until (> (device_get_position dm_enc2_1_door1) 0.37) 1)
	(cs_smash_direction 0)
)

(script dormant enc2_4
	(sleep_until
		(and
			(volume_test_players tv_enc2_4)
			(<= (ai_living_count gr_enc2_2_cov) 2)
		)
		1
	)
	(game_save_no_timeout)
	(ai_place gr_enc2_4_cov)
	(sleep_until (= 0 (ai_living_count gr_enc2_4_cov)) 1)
	(game_save_no_timeout)
)

;(script dormant enc2_5_music
;	(sleep_until
;		(and
;			(<= (ai_living_count gr_enc2_2_cov) 0)
;			(<= (ai_living_count gr_enc2_4_cov) 0)
;		)
;		1
;	)
	; music
	; (sound_looping_start "levels\d40\music\d40_011" none 1)
;)

(script dormant enc2_5
	(sleep_until (volume_test_players tv_enc2_6) 1)
	(game_save_no_timeout)

	(ai_place gr_enc2_5_cov)
	(sleep (game_ticks_from_seconds 1))
	(wake dialogue_enter_bridge)
	(wake enc2_5_blip)

	(sleep_until (<= (ai_nonswarm_count gr_enc2_5_cov) 0) 1)
	(sleep (game_ticks_from_seconds 1))
	(set dialogue_bridge_ready true)

	; bridge cinematic
	(sleep_until
		(and
			(volume_test_players tv_cinematic_bridge)
			(script_finished "dialogue_enter_bridge")
		)
		1
	)
	(wake enc2_5_cine)
)

(script dormant enc2_5_blip
	(sleep (game_ticks_from_seconds 10))
	(if
		(> (ai_nonswarm_count gr_enc2_5_cov) 0)
		(f_blip_ai gr_enc2_5_cov blip_enemies)
	)
)

(script dormant enc2_5_cine
	(f_unblip_flag fl_cortana_port)
	(f_play_cinematic cinematics\d40\d40_bridge.cinematic ps_post_bridge_cine)
	(wake mus_bridge_cine_end)
	(wake kill_all_beat_1)

	(set mark_bridge_cutscene true)
	(object_destroy sc_bridge_screen)

	(ai_place gr_enc2_5_sents)
	(wake mus_06)
	(f_hud_obj_new obj_d40_engineering obj_d40_engineering)
)

(script command_script cs_enc2_5_sents_avoid_window
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_enable_moving true)

	(sleep_until
		(begin
			(if
				(and
					(< (ai_strength ai_current_squad) 0.75)
					(volume_test_object tv_enc2_5_sents_window ai_current_actor)
				)
				(cs_move_towards_point ps_enc2_5_sents/p0 0.25)
			)

			false ; forever
		)
		1
	)
)

;kill ai
(script dormant kill_all_beat_1

	(ai_disposable gr_enc1_0_sents true)
	(ai_disposable gr_enc1_1_sents true)
	(ai_disposable gr_enc1_1_flood true)

	(ai_disposable gr_enc1_2_flood true)

	(ai_disposable gr_enc1_4_flood true)

	(ai_disposable gr_enc2_1_flood true)

	(ai_disposable gr_enc2_2_flood true)
	(ai_disposable gr_enc2_2_cov true)

	(ai_disposable gr_enc2_4_cov true)

	(ai_disposable gr_enc2_5_cov true)
)

(script dormant nav_beat_1
	(sleep_until (volume_test_players tv_act_nav_messhall) 1)
	(f_exclusive_blip_flag fl_messhall 0)
	(sleep_until (volume_test_players tv_act_nav_bridge) 1)
	(f_exclusive_blip_flag fl_bridge 0)
	(sleep_until (volume_test_players tv_end_nav_bridge) 1)
	(f_unblip_flag fl_bridge)
)

;====================================================================================================================================================================================================
; d40_beat_2
;====================================================================================================================================================================================================

(script dormant d40_beat_2
	(wake beat_2_object_handling)
	(sleep_until mark_bridge_cutscene 1)
	; unlock progress data
	(submit_incident "ins_d40_bridge")
	(submit_incident "unlock_d40")
	(submit_incident_with_custom_string_id "game_activity_begin" "d40")

	(print "d40_beat_2")
	(device_set_position_immediate dm_cafeteria_door 0)
	(sleep_forever enc1_4_manager)
	(game_save_no_timeout)
	;(print "loop music d40_01")

	(wake enc2_6)
	(sleep_until (volume_test_players tv_enc2_5_retreat2) 1)
	(wake dialogue_get_to_engine)
	(device_set_position_immediate bridge_blast_door_exit 1)
	(print "opening bridge blast door")
	(wake nav_beat_2)
)

(script dormant beat_2_object_handling
	(sleep_until
		(or
			mark_bridge_cutscene
			(volume_test_players tv_enc2_4)
		)
		1
	)
	(object_create_folder crates_bridge)
	(object_create_folder w_bridge)
	(object_create_folder bi_bridge)
	(object_create_folder w_cryo)
	(object_create_folder eq_cryo)
	(object_create_folder bi_cryo)

	(sleep_until (volume_test_players tv_engine_room) 1)
	(object_destroy_folder crates_bridge)
	(object_destroy_folder w_bridge)
	(object_destroy_folder bi_bridge)
	(object_destroy_folder w_cryo)
	(object_destroy_folder eq_cryo)
	(object_destroy_folder bi_cryo)
	(garbage_collect_now)
)

(script dormant enc2_6
	(sleep_until (volume_test_players tv_enc2_6) 1)
	(game_save_no_timeout)
	(wake enc2_7)
	(device_set_position_immediate dm_enc2_6_door 1)
	(sleep_until (volume_test_players tv_enc2_6b) 1)
	(ai_place gr_enc2_6_flood)
	(wake mus_07)
	(sleep_until (= 0 (ai_living_count gr_enc2_6_flood)) 1)
	(game_save_no_timeout)
)

(script dormant enc2_7
	(sleep_until (volume_test_players tv_enc2_7) 1)
	(game_save_no_timeout)
	(f_ai_place_over_ticks gr_enc2_7_cov gr_enc2_7_flood none none none none)
)

(script dormant kill_all_beat_2
	(ai_disposable gr_enc2_5_sents true)
	(ai_disposable gr_enc2_6_flood true)
	(ai_disposable gr_enc2_7_cov true)
	(ai_disposable gr_enc2_7_flood true)
)

(script dormant nav_beat_2
	(sleep_until (volume_test_players tv_enc2_6) 1)
	(f_exclusive_blip_flag fl_armory_a 0)
	(sleep_until (volume_test_players tv_act_armory_access) 1)
	(f_exclusive_blip_flag fl_armory_access 0)
	(sleep_until (volume_test_players tv_section3) 1)
	(f_unblip_flag fl_armory_access)
)

;====================================================================================================================================================================================================
; d40_beat_3
;====================================================================================================================================================================================================
(script dormant (d40_beat_3)
	(sleep_until (volume_test_players tv_section3) 1)
	(print "d40_beat_3")
	(game_save_no_timeout)
	; music
	; (sound_looping_stop "levels\d40\music\d40_012")
	(wake enc3_1)
	(wake enc3_2)
	(wake nav_beat_3)
)

(script dormant enc3_1
	(sleep_until (volume_test_players tv_enc3_1) 1)
	(game_save_no_timeout)
	(f_ai_place_over_ticks gr_enc3_1_flood gr_enc3_1_sents none none none none)
	(device_set_position dm_cryo_blast_door_broken .3)
	(ai_prefer_target_ai gr_enc3_1_sents gr_enc3_1_flood true)

	(sleep_until
		(or
			(volume_test_players tv_enc3_1b)
			(<= (ai_strength gr_enc3_1_sents) .5)
		)
		1
	)
	(ai_place sq_enc3_1_flood_i2)
)

(script dormant enc3_2
	(sleep_until (volume_test_players tv_enc3_2) 1)
	(game_save_no_timeout)
	(wake enc3_3)
	(wake enc3_4)
	(wake enc3_5)
	(ai_place gr_enc3_2_sents)
	(wake mus_08)

	(sleep_until (= 0 (ai_living_count gr_enc3_2_sents)) 1)
	(game_save_no_timeout)
)

(script dormant enc3_3
	(sleep_until (volume_test_players tv_enc3_3) 1)
	(game_save_no_timeout)
	(f_ai_place_over_ticks sq_enc3_3_flood_c sq_enc3_3_flood_i gr_enc3_3_sents none none none)

	(sleep_until
		(or
			(>= (device_get_position dm_enc3_3_door1) 0.8)
			(>= (device_get_position dm_enc3_3_door2) 0.8)
		)
 		1
 		300
	)
	(wake mus_09)
	(if
		(>= (device_get_position dm_enc3_3_door1) 0.8)
		(ai_place sq_enc3_3_flood_di)
		(if
			(>= (device_get_position dm_enc3_3_door2) 0.8)
			(ai_place sq_enc3_3_flood_di2)
		)
	)

	(sleep_until
		(and
			(volume_test_players_all tv_enc3_3b)
			(<= (ai_living_count gr_enc3_3_sents) 0)
		)
 		1
	)
	(ai_place sq_enc3_3_flood_c2)
)

(script dormant enc3_4
	(sleep_until (volume_test_players tv_enc3_4) 1)
	(game_save_no_timeout)
	; music
	; (sound_looping_start "levels\d40\music\d40_013" none 1)

	(ai_place sq_enc3_4_monitor_s)
	(game_save_no_timeout)
)

(script dormant enc3_5
	(sleep_until (volume_test_players tv_enc3_5) 1)
	(game_save_no_timeout)
	(wake kill_all_beat_2)
	(wake enc3_6)

	(wake enc3_5_manager)
	(sleep_until (volume_test_players tv_enc3_5b) 1)
	(set b_enc3_5_manager_complete true)
	(game_save_no_timeout)
)

(script dormant enc3_5_manager
	(sleep_until
		(begin ;loop until manager complete
			(if (<= s_enc3_5_limiter (* 20 r_spawn_scale)) ;while
				(begin
					(if
						(< (ai_living_count sq_enc3_5_flood_c) s_min_combat_spawn)
						(begin
							(ai_place sq_enc3_5_flood_c 1)
							(set s_enc3_5_limiter (+ s_enc3_5_limiter 1))
						)
					)
					(if
						(< (ai_living_count sq_enc3_5_flood_c2) s_min_carrier_spawn)
						(begin
							(ai_place sq_enc3_5_flood_c2 1)
							(set s_enc3_5_limiter (+ s_enc3_5_limiter 1))
						)
					)
					(if
						(< (ai_living_count sq_enc3_5_flood_i) s_min_infection_spawn)
						(begin
							(ai_place sq_enc3_5_flood_i)
						)
					)
					(sleep (game_ticks_from_seconds 0.5))
				)
			)
 			b_enc3_5_manager_complete ;check if complete
		)
 		1
	)
)

;this may be redundant after navmesh clean-up in the area
(script command_script cs_enc3_5_flood_advance
	(cs_move_towards_point ps_enc3_5_flood_advance/p1 0.25)
	(cs_move_towards_point ps_enc3_5_flood_advance/p0 2)
)

(script dormant enc3_6
	(sleep_until (volume_test_players tv_enc3_6) 1)
	(game_save_no_timeout)
	; music
	; (sound_looping_stop "levels\d40\music\d40_013")

	(ai_place sq_enc3_6_flood_si)
	(wake enc3_6_manager)
	(sleep_until (volume_test_players tv_section4) 1)
	(set b_enc3_6_manager_complete true)
	(game_save_no_timeout)
)

(script dormant enc3_6_manager
	(sleep_until
		(begin ;loop until manager complete
			(if (<= s_enc3_6_limiter (* 10 r_spawn_scale)) ;while
				(begin
					(if (volume_test_players_all tv_enc3_6)
						(begin
							(if
								(< (ai_living_count sq_enc3_6_flood_c) s_min_combat_spawn)
								(begin
									(ai_place sq_enc3_6_flood_c 1)
									(set s_enc3_6_limiter (+ s_enc3_6_limiter 1))
								)
							)
							(if
								(< (ai_living_count sq_enc3_6_flood_c2) s_min_carrier_spawn)
								(begin
									(ai_place sq_enc3_6_flood_c2 1)
									(set s_enc3_6_limiter (+ s_enc3_6_limiter 1))
								)
							)
							(if
								(< (ai_living_count sq_enc3_6_flood_i) s_min_infection_spawn)
								(begin
									(ai_place sq_enc3_6_flood_i)
								)
							)
							(sleep (game_ticks_from_seconds 0.5))
						)
					)
				)
			)
 			b_enc3_6_manager_complete ;check if complete
		)
 		1
	)
)

(script dormant kill_all_beat_3
	(ai_disposable gr_enc3_1_flood true)
	(ai_disposable gr_enc3_1_sents true)
	(ai_disposable gr_enc3_2_sents true)
	(ai_disposable gr_enc3_3_flood true)
	(ai_disposable gr_enc3_3_sents true)
	(ai_disposable gr_enc3_4_monitor true)
	(ai_disposable gr_enc3_5_flood true)
	(ai_disposable gr_enc3_6_flood true)
)

(script dormant nav_beat_3
	(sleep_until (volume_test_players tv_section3) 1)
	(f_exclusive_blip_flag fl_ship_hall_cryo 0)
	(sleep_until (volume_test_players tv_act_cryo_b) 1)
	(f_exclusive_blip_flag fl_cryo_b 0)
	(sleep_until (volume_test_players tv_act_esc_pod_hall) 1)
	(f_exclusive_blip_flag fl_esc_pod_hall 0)
	(sleep_until (volume_test_players tv_act_beat_5) 1)
	(f_unblip_flag fl_esc_pod_hall)
)

;====================================================================================================================================================================================================
; d40_beat_4
;====================================================================================================================================================================================================
(script dormant d40_beat_4
	(sleep_until (volume_test_players tv_section4) 1)
	(game_save_no_timeout)
	(print "d40_beat_4")
	(wake enc4_1)
	(wake nav_beat_4)
)

(script dormant enc4_1
	(sleep_until (volume_test_players tv_enc4_1) 1)
	(game_save_no_timeout)
	(f_ai_place_over_ticks gr_enc4_1_cov gr_enc4_1_flood none none none none)
	(wake enc4_2)
)

(script dormant enc4_2
	(game_save_no_timeout)
	(wake enc4_3)

	(ai_place gr_enc4_2_cov)
	(ai_place sq_enc4_2_flood_ceag) ;place single flood combat near covenant
	(ai_prefer_target_ai gr_enc4_2_cov gr_enc4_2_flood true)
	(ai_prefer_target_ai gr_enc4_2_flood gr_enc4_2_cov true)

	(wake enc4_2_manager)
	(wake mus_10)

	(sleep_until
		(or
			(>= s_enc4_2_limiter (* 35 r_spawn_scale))
			(volume_test_players tv_enc4_3)
		)
		1
	)
	(set b_enc4_2_manager_complete true)
	(wake kill_all_beat_3)
	(game_save_no_timeout)
)

(script dormant enc4_2_manager
	(sleep_until
		(begin ;loop until manager complete
			(if (<= s_enc4_2_limiter (* 35 r_spawn_scale)) ;while
				(begin
					(sleep_until (not (volume_test_players tv_enc4_2c)) 1)
					(if
						(< (ai_living_count sq_enc4_2_sents_s) (* 1.5 s_min_combat_spawn))
						(begin
							(print "spawning sentinels")
							(ai_place sq_enc4_2_sents_s 1)
							(set s_enc4_2_limiter (+ s_enc4_2_limiter 1))
							(sleep (game_ticks_from_seconds 1.5))
						)
					)
					(begin ;else
						(if
							(< (ai_living_count sq_enc4_2_flood_c) (* 1.5 s_min_combat_spawn))
							(begin
								(ai_place sq_enc4_2_flood_c 1)
								(set s_enc4_2_limiter (+ s_enc4_2_limiter 1))
							)
						)
						(if
							(< (ai_living_count sq_enc4_2_flood_c2) s_min_carrier_spawn)
							(begin
								(ai_place sq_enc4_2_flood_c2 1)
								(set s_enc4_2_limiter (+ s_enc4_2_limiter 1))
							)
						)
						(if
							(< (ai_living_count sq_enc4_2_flood_i) s_min_infection_spawn)
							(begin
								(ai_place sq_enc4_2_flood_i)
							)
						)
					)
				)
			)
 			b_enc4_2_manager_complete ;check if complete
		)
 		1
	)
)

;this may be redundant after navmesh clean-up in the area
(script command_script cs_enc4_2_flood_advance
	(cs_move_towards_point ps_enc4_2_flood_advance/p1 1)
	(cs_move_towards_point ps_enc4_2_flood_advance/p0 2)
)

(script dormant enc4_3
	; activate enc4_3 only after the engine room has started
	(sleep_until (volume_test_players tv_engine_room) 1)

	(sleep_until
		(and
			(not (objects_can_see_object (players) dm_enc4_3_door 10))
			(not (volume_test_players tv_enc4_3b))
		)
 		1
	)

	(ai_place sq_enc4_3_flood_sc)
	(wake mus_11)
	(wake mus_12)
	(sleep (game_ticks_from_seconds 10))

	(sleep_until
		(and
			(= 0 (ai_living_count gr_enc4_3_flood))
			(not (volume_test_players tv_enc4_3_sw))
		)
		1
	)
	(ai_place sq_enc4_3_flood_sw s_min_combat_spawn)
	(object_create eq_camo)
)

(script dormant kill_all_beat_4
	(ai_disposable gr_enc4_1_cov true)
	(ai_disposable gr_enc4_1_flood true)
	(ai_disposable gr_enc4_2_cov true)
	(ai_disposable gr_enc4_2_flood true)
	(ai_disposable gr_enc4_2_sents true)
)

(script dormant nav_beat_4
	(f_exclusive_blip_flag fl_esc_pod_hall 0)
	(sleep_until (volume_test_players tv_act_beat_5) 1)
	(f_exclusive_blip_flag fl_engine_room 0)
	(sleep_until (volume_test_players tv_enc5_1) 1)
	(f_unblip_flag fl_engine_room)
)

;====================================================================================================================================================================================================
; d40_beat_5
;====================================================================================================================================================================================================

(script dormant d40_beat_5
	(wake beat_5_object_handling)
	(sleep_until (volume_test_players tv_section5) 1)
	(print "d40_beat_5")
	(game_save_no_timeout)
	(wake mus_13)
	(wake present_chapter_2)

	(wake kill_all_beat_4)

	(wake enc5_1)

	(sleep_until (volume_test_players tv_engine_room) 1)

	; bring players into engine room, so we can lock hallway door and cleanup
	(volume_teleport_players_not_inside tv_engine_room_teleport fl_engine_room_teleport)
	(device_set_position_immediate dm_blast_door_hall 0)

	(wake dialogue_engine_enter)

	(wake beat_5_piston_triggered)
	(wake beat_5_open_engine_room)
	(wake enc5_2)
	(wake enc5_3)

	(sleep_until (script_finished dialogue_engine_enter) 1)
	(sleep (game_ticks_from_seconds 5))
	(wake dialogue_monitor_player)
	(wake dialogue_monitor_self)
)

(script dormant beat_5_object_handling
	(sleep_until
		(or
			(volume_test_players tv_enc4_1)
			(f_insertion_point_matches insertion_engine)
		)
		1
	)

	(object_create_folder crates_engine)
	(object_create_folder w_armory)
	(object_create_folder eq_armory)
	(object_destroy eq_camo)

	(sleep_until (<= (f_exhaust_alive) 0) 1)
	(object_destroy_folder w_armory)
	(object_destroy_folder eq_armory)
	(garbage_collect_now)

	(sleep_until (= (device_get_position elevator_door) 0) 1)
	(object_destroy_folder crates_engine)
	(garbage_collect_now)
	(object_create_folder v_hog_run)
)

(script dormant enc5_1
	(game_save_no_timeout)
	(ai_place gr_enc5_1_monitor)

	(sleep_until (volume_test_players tv_enc5_1_main) 1)
	(sleep (game_ticks_from_seconds 2.0))
	(wake enc5_1_flood_handler)
	(wake enc5_1_sents_handler)
)

(global boolean b_debug_monitor false)

(script command_script cs_enc5_1_monitor
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)
	(ai_disregard (ai_actors ai_current_actor) true)

	(sleep_until
		(cond
			(
				(and
					(f_volume_player_majority tv_enc5_1_north)
					(volume_test_objects tv_enc5_1_south (ai_actors ai_current_actor))
				)
				(begin
					; move north to players
					(print_if b_debug_monitor "monitor south -> north")
					(cs_fly_by ps_monitor_ston/p0)
					(cs_fly_by ps_monitor_ston/p1)
					(cs_fly_by ps_monitor_ston/p2)
					false
				)
			)
			(
				(and
					(f_volume_player_majority tv_enc5_1_south)
					(volume_test_objects tv_enc5_1_north (ai_actors ai_current_actor))
				)
				(begin
					; move south to players
					(print_if b_debug_monitor "monitor north -> south")
					(cs_fly_by ps_monitor_ntos/p0)
					(cs_fly_by ps_monitor_ntos/p1)
					(cs_fly_by ps_monitor_ntos/p2)
					false
				)
			)
			(
				(volume_test_objects tv_enc5_1_north (ai_actors ai_current_actor))
				(begin
					(if (>= (enc5_1_player_highest_floor) 2)
						(begin
							; north 2nd floor
							(print_if b_debug_monitor "monitor north >=2")
							(cs_fly_by ps_monitor_n2/p0)
							(cs_fly_to ps_monitor_n2/p1)
							(cs_fly_to_and_face ps_monitor_n2/p1 ps_monitor_n2/p2)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_to ps_monitor_n2/p3)
							(cs_fly_to_and_face ps_monitor_n2/p3 ps_monitor_n2/p4)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_by ps_monitor_n2/p0)
							(cs_face_player true)
							(sleep (game_ticks_from_seconds 10))
							(cs_face_player false)
						)
						(begin
							; north 1st floor
							(print_if b_debug_monitor "monitor north 1")
							(cs_fly_to ps_monitor_n1/p0)
							(cs_fly_to ps_monitor_n1/p1)
							(cs_fly_to_and_face ps_monitor_n1/p1 ps_monitor_n1/p6)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_to ps_monitor_n1/p2)
							(cs_fly_to_and_face ps_monitor_n1/p2 ps_monitor_n1/p5)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_to ps_monitor_n1/p3)
							(cs_fly_to_and_face ps_monitor_n1/p3 ps_monitor_n1/p4)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_to ps_monitor_n1/p7)
							(cs_fly_to_and_face ps_monitor_n1/p7 ps_monitor_n1/p5)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_by ps_monitor_n1/p8)
							(cs_face_player true)
							(sleep (game_ticks_from_seconds 10.0))
							(cs_face_player false)
						)
					)
					false
				)
			)
			(
				(volume_test_objects tv_enc5_1_south (ai_actors ai_current_actor))
				(begin
					(if (>= (enc5_1_player_highest_floor) 2)
						(begin
							; south 2nd floor
							(print_if b_debug_monitor "monitor south >=2")
							(cs_fly_by ps_monitor_s2/p0)
							(cs_fly_to ps_monitor_s2/p1)
							(cs_fly_to_and_face ps_monitor_s2/p1 ps_monitor_s2/p2)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_to ps_monitor_s2/p3)
							(cs_fly_to_and_face ps_monitor_s2/p3 ps_monitor_s2/p4)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_to ps_monitor_s2/p0)
							(cs_face_player true)
							(sleep (game_ticks_from_seconds 10))
							(cs_face_player false)
						)
						(begin
							; south 1st floor
							(print_if b_debug_monitor "monitor south 1")
							(cs_fly_to ps_monitor_s1/p0)
							(cs_fly_to ps_monitor_s1/p1)
							(cs_fly_to_and_face ps_monitor_s1/p1 ps_monitor_s1/p2)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_to ps_monitor_s1/p3)
							(cs_fly_to_and_face ps_monitor_s1/p3 ps_monitor_s1/p4)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_to ps_monitor_s1/p5)
							(cs_fly_to_and_face ps_monitor_s1/p5 ps_monitor_s1/p6)
							(cs_fly_by ps_monitor_s1/p6)
							(cs_fly_to ps_monitor_s1/p7)
							(cs_fly_to_and_face ps_monitor_s1/p7 ps_monitor_s1/p8)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_by ps_monitor_s1/p9)
							(cs_fly_to ps_monitor_s1/p10)
							(cs_fly_to_and_face ps_monitor_s1/p10 ps_monitor_s1/p11)
							(sleep (game_ticks_from_seconds 2.0))
							(cs_fly_by ps_monitor_s1/p0)
							(cs_face_player true)
							(sleep (game_ticks_from_seconds 10.0))
							(cs_face_player false)
						)
					)
					false
				)
			)
		)
		1
	)
)

; which floor a player is currently on (checks high-to-low)
(script static short enc5_1_player_highest_floor
	(cond
		((volume_test_players tv_enc5_1_floor3) 3)
		((volume_test_players tv_enc5_1_floor2) 2)
		((volume_test_players tv_enc5_1_floor1) 1)
		(true 0)
	)
)

(global boolean b_enc5_1_complete false)

(script dormant enc5_1_sents_handler
	(sleep_until
		(begin
			(enc5_1_sents_spawn)
			b_enc5_1_complete
		)
		1
	)
)

; returns true if at least half of all active players are in the given volume
(script static boolean (f_volume_player_majority (trigger_volume tv))
	(>=
		(*
			2
			(+
				(if (volume_test_object tv player0) 1 0)
				(if (volume_test_object tv player1) 1 0)
				(if (volume_test_object tv player2) 1 0)
				(if (volume_test_object tv player3) 1 0)
			)
		)
		(game_coop_player_count)
	)
)

(script static void enc5_1_sents_spawn
	(if
		(volume_test_players tv_enc5_1_main)
		(cond
			((f_volume_player_majority tv_enc5_1_north) (enc5_1_sents_place sq_enc5_1_sents_n))
			((f_volume_player_majority tv_enc5_1_south) (enc5_1_sents_place sq_enc5_1_sents_s))
		)
	)
)

(script static void (enc5_1_sents_place
						(ai squad)
					)
	(if
		(<= (ai_living_count gr_enc5_1_sents) 1)
		(begin
			(sleep (game_ticks_from_seconds 6.0))
			(enc5_1_sents_dialogue)
			(sleep (game_ticks_from_seconds 9.0))
			(ai_place squad)
		)
	)
)

(script static void enc5_1_sents_dialogue
	(if (>= (enc5_1_player_highest_floor) 2)
		(set b_dialogue_monitor_player true) ;monitor speak to player
		(set b_dialogue_monitor_self true) ;else, monitor speak to self
	)
)

(script command_script cs_enc5_1_sents_n
	(cs_enable_moving true)
	(cs_fly_by ps_enc5_1_sents_n/p1 0.5)
	(cs_fly_by ps_enc5_1_sents_n/p0 0.5)
)

(script command_script cs_enc5_1_sents_s
	(cs_enable_moving true)
	(cs_fly_by ps_enc5_1_sents_s/p1 0.5)
	(cs_fly_by ps_enc5_1_sents_s/p0 0.5)
)

(global long s_enc5_1_flood_last_inner 0)

(script dormant enc5_1_flood_handler
	(wake enc5_1_side_corridor_s12)
	(wake enc5_1_side_corridor_s23)
	(wake enc5_1_side_corridor_n12)

	(sleep_until
		(begin
			(if
				(and
					(volume_test_players tv_enc5_1_main)
					(>= (- (game_tick_get) s_enc5_1_flood_last_inner)
						(game_ticks_from_seconds 20.0)
					)
				)
				(begin
					(enc5_1_flood_spawn)
					(enc5_1_infs_spawn)
					(set s_enc5_1_flood_last_inner (game_tick_get))
				)
			)
			b_enc5_1_complete
		)
		1
	)
)

(global short s_enc5_1_s12_wave -1)
(global short s_enc5_1_s23_wave -1)
(global short s_enc5_1_n12_wave -1)

; corridors can spawn a wave of flood in the side hallways, at most once each per engine destruction cycle
; checks for player at the bottom (lower), waits for them to reach a point in the corridor (upper) or times out

(script dormant enc5_1_side_corridor_s12
	(sleep_until
		(begin
			(if
				; ready
				(and
					(or
						(> (f_exhaust_killed) 0)
						(= legendary (game_difficulty_get))
					)
					(volume_test_players tv_enc5_1_s12_lower)
					(< s_enc5_1_s12_wave (f_exhaust_killed))
				)
				; wave
				(begin
					(sleep_until
						(volume_test_players tv_enc5_1_s12_upper)
						1
						(game_ticks_from_seconds 20.0)
					)
					(if
						(and
							(not b_enc5_1_complete)
							(= (device_get_position engine_room_door_level_3) 0.0)
						)
						(begin
							(enc5_1_corridor_spawn sq_enc5_1_flood_s12 sq_enc5_1_infs_s12)
							(set s_enc5_1_s12_wave (f_exhaust_killed))
						)
					)
				)
			)

			b_enc5_1_complete
		)
		1
	)
)

(script dormant enc5_1_side_corridor_s23
	(sleep_until
		(begin
			(if
				; ready
				(and
					(or
						(= (f_exhaust_killed) 0)
						(= legendary (game_difficulty_get))
					)
					(volume_test_players tv_enc5_1_s23_lower)
					(< s_enc5_1_s23_wave (f_exhaust_killed))
				)
				; wave
				(begin
					(sleep_until
						(volume_test_players tv_enc5_1_s23_upper)
						1
						(game_ticks_from_seconds 20.0)
					)
					(if
						(and
							(not b_enc5_1_complete)
							(= (device_get_position engine_room_door_level_4a) 0.0)
						)
						(begin
							(enc5_1_corridor_spawn sq_enc5_1_flood_s23 sq_enc5_1_infs_s23)
							(set s_enc5_1_s23_wave (f_exhaust_killed))
						)
					)
				)
			)

			b_enc5_1_complete
		)
		1
	)
)

(script dormant enc5_1_side_corridor_n12
	(sleep_until
		(begin
			(if
				; ready
				(and
					(or
						(> (f_exhaust_killed) 0)
						(= legendary (game_difficulty_get))
					)
					(volume_test_players tv_enc5_1_n12_lower)
					(< s_enc5_1_n12_wave (f_exhaust_killed))
				)
				; wave
				(begin
					(sleep_until
						(volume_test_players tv_enc5_1_n12_upper)
						1
						(game_ticks_from_seconds 20.0)
					)
					(if
						(and
							(not b_enc5_1_complete)
							(= (device_get_position engine_room_door_level_4a) 0.0)
						)
						(begin
							(enc5_1_corridor_spawn sq_enc5_1_flood_n12 sq_enc5_1_infs_n12)
							(set s_enc5_1_n12_wave (f_exhaust_killed))
						)
					)
				)
			)

			b_enc5_1_complete
		)
		1
	)
)

; places combat and infection forms in a corridor if counts are below threshold
; returns combat form place count, 0 otherwise (for limiter tracking)
(script static void (enc5_1_corridor_spawn
						(ai combat_squad)
						(ai infs_squad)
					)
	(if
		(<= (ai_living_count infs_squad) s_min_infection_spawn)
		(ai_place infs_squad)
	)
	(if
		(<= (ai_living_count combat_squad) s_min_combat_spawn)
		(begin
			(print "flood corridor")
			(inspect s_min_combat_spawn)
			(ai_place combat_squad s_min_combat_spawn)
		)
	)
)

(script static void enc5_1_flood_spawn
	(if
		(<=
			(ai_living_count gr_enc5_1_flood)
			2
		)
		; attempt spawns, print on success
		(cond
			((enc5_1_flood_ground_north_spawn) (print "flood ground north"))
			((enc5_1_flood_ground_south_spawn) (print "flood ground south"))
			(true (print "flood ground failed"))
		)
	)
	(if
		(<=
			(+ (ai_living_count sq_enc5_1_flood_us) (ai_living_count sq_enc5_1_flood_un))
			1
		)
		(if
			(volume_test_players tv_enc5_1_main)
			; attempt spawns, print on success
			(cond
				((enc5_1_flood_upper_north_spawn) (print "flood upper north"))
				((enc5_1_flood_upper_south_spawn) (print "flood upper south"))
				((enc5_1_flood_upper_center_spawn) (print "flood upper center"))
				(true (print "flood upper failed"))
			)
		)
	)
)

; returns true on successful spawn
(script static boolean enc5_1_flood_ground_north_spawn
	(enc5_1_flood_ground_side_spawn tv_enc5_1_north sq_enc5_1_flood_north)
)

; returns true on successful spawn
(script static boolean enc5_1_flood_ground_south_spawn
	(enc5_1_flood_ground_side_spawn tv_enc5_1_south sq_enc5_1_flood_south)
)

; returns true on successful spawn
(script static boolean (enc5_1_flood_ground_side_spawn
						(trigger_volume tv_side)
						(ai squad)
					)
	(if
		(f_volume_player_majority tv_side)
		(begin
			(ai_place squad)
			true
		)
		false
	)
)

; returns true on successful spawn
(script static boolean enc5_1_flood_upper_north_spawn
	(if
		(f_volume_player_majority tv_enc5_1_south)
		(enc5_1_flood_upper_side_spawn tv_enc5_1_un_safety engine_room_door_level_4 sq_enc5_1_flood_un)
		false
	)
)

; returns true on successful spawn
(script static boolean enc5_1_flood_upper_south_spawn
	(if
		(f_volume_player_majority tv_enc5_1_north)
		(enc5_1_flood_upper_side_spawn tv_enc5_1_us_safety engine_room_door_level_4b sq_enc5_1_flood_us)
		false
	)
)

; returns true on successful spawn
(script static boolean enc5_1_flood_upper_center_spawn
	(enc5_1_flood_upper_side_spawn tv_enc5_1_uc_safety engine_room_door_level_4a sq_enc5_1_flood_uc)
)

; returns true on successful spawn
(script static boolean (enc5_1_flood_upper_side_spawn
						(trigger_volume tv_safety)
						(device door)
						(ai squad)
					)
	(if
		(and
			(not (volume_test_players tv_safety))
			(= (device_get_position door) 0.0)
		)
		(begin
			(ai_place squad)
			true
		)
		false
	)
)

(script static void enc5_1_infs_spawn
	(if
		(and
			(< (ai_living_count gr_enc5_1_infs) s_min_infection_spawn)
			(<= (enc5_1_player_highest_floor) 1)
		)
		(cond
			((volume_test_players tv_enc5_1_north) (ai_place sq_enc5_1_infs_n2))
			((volume_test_players tv_enc5_1_south) (ai_place sq_enc5_1_infs_s2))
		)
	)
)

(script dormant beat_5_piston_triggered
	(wake manage_engines)
	(wake manage_engine_1)
	(wake manage_engine_2)
	(wake manage_engine_3)
	(wake manage_engine_4)
)

(script static boolean (f_player_holding_explosive (unit player))
	(or
		; grenades
		(> (unit_get_total_grenade_count player) 0)
		; rocket
		(unit_has_weapon_and_could_fire_primary_barrel player objects\weapons\support_high\rocket_launcher\rocket_launcher.weapon)
		; fuel rod
		(unit_has_weapon_and_could_fire_primary_barrel player objects\weapons\support_high\flak_cannon\flak_cannon.weapon)
	)
)

(script static boolean f_players_holding_explosive
	(or
		(f_player_holding_explosive player0)
		(f_player_holding_explosive player1)
		(f_player_holding_explosive player2)
		(f_player_holding_explosive player3)
	)
)

(script dormant manage_engines
	; sleep until the player uses a switch
	(sleep_until
		(or
			(= (device_group_get engine_piston_1_position) 1)
			(= (device_group_get engine_piston_2_position) 1)
			(= (device_group_get engine_piston_3_position) 1)
			(= (device_group_get engine_piston_4_position) 1)
		)
		1
	)

	(wake dialogue_engine_first_console)
	(game_save_no_timeout)

	; killing two exhausts at once should not deadlock the script
	; but we should only play one dialog
	(sleep_until (>= (f_exhaust_killed) 1) 1)
	(if (or (= (f_exhaust_killed) 1) (= (f_exhaust_killed) 2)) ; in case we skip 1
		(begin
			(wake dialogue_engine_first_destroyed)
			(object_wake_physics cr_engine_room_debris_crate_1)
		)
	)

	(sleep_until (>= (f_exhaust_killed) 2) 1)
	(wake mus_15)

	(sleep_until (>= (f_exhaust_killed) 3) 1)
	(if (= (f_exhaust_killed) 3)
		(wake dialogue_engine_third_destroyed)
	)

	(sleep_until (>= (f_exhaust_killed) 4) 1)
	(wake dialogue_engine_fourth_destroyed)

	; remaining centered pistons boom
	(device_set_position engine_piston_5_device r_engine_destroyed_position)
	(device_set_position engine_piston_6_device r_engine_destroyed_position)
)

(script dormant manage_engine_1
	(f_manage_engine_assembly engine_piston_1_control engine_piston_1_position engine_piston_1_device engine_exhaust_1 audio_vig_06_enginevent_03)

	(device_set_position_immediate dm_reactor1_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 2) 1)
	(device_set_position_immediate dm_reactor1_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 3) 1)
	(device_set_position_immediate dm_reactor1_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 4) 1)
	(device_set_position_immediate dm_reactor1_vfx r_reactor_health_state)
)

(script dormant manage_engine_2
	(f_manage_engine_assembly engine_piston_2_control engine_piston_2_position engine_piston_2_device engine_exhaust_2 audio_vig_06_enginevent_04)

	(device_set_position_immediate dm_reactor2_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 2) 1)
	(device_set_position_immediate dm_reactor2_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 3) 1)
	(device_set_position_immediate dm_reactor2_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 4) 1)
	(device_set_position_immediate dm_reactor2_vfx r_reactor_health_state)
)

(script dormant manage_engine_3
	(f_manage_engine_assembly engine_piston_3_control engine_piston_3_position engine_piston_3_device engine_exhaust_3 audio_vig_06_enginevent_01)

	(device_set_position_immediate dm_reactor3_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 2) 1)
	(device_set_position_immediate dm_reactor3_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 3) 1)
	(device_set_position_immediate dm_reactor3_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 4) 1)
	(device_set_position_immediate dm_reactor3_vfx r_reactor_health_state)
)

(script dormant manage_engine_4
	(f_manage_engine_assembly engine_piston_4_control engine_piston_4_position engine_piston_4_device engine_exhaust_4 audio_vig_06_enginevent_02)

	(device_set_position_immediate dm_reactor4_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 2) 1)
	(device_set_position_immediate dm_reactor4_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 3) 1)
	(device_set_position_immediate dm_reactor4_vfx r_reactor_health_state)
	(sleep_until (>= (f_exhaust_killed) 4) 1)
	(device_set_position_immediate dm_reactor4_vfx r_reactor_health_state)
)

(global real r_engine_destroyed_position 0.4)
(global real r_reactor_health_state 0)
(global boolean b_loop_started false)
(script static void (f_manage_engine_assembly (device control) (device_group group) (device piston) (object exhaust_port) (object emitter))
	(set b_loop_started false)
	(sleep_until
		(begin
			(if
				(= (device_group_get group) 1)
				(begin
					(f_controls_unblip)

					; disable control
					(f_controls_enable)
					(device_group_set control group 1)
					(device_set_power control 0)

					; open piston
					(f_pistons_close)
					(device_set_position piston 1)
					(f_blip_object exhaust_port blip_neutralize)
				)
			)
			(if (and (not b_loop_started) (>= (device_get_position piston) 0.25))
				(begin
					(sound_impulse_start sound/levels/d40/d40_piston_exposed emitter 1)
					(set b_loop_started true)
				)
			)
			; loop until exhaust is destroyed
			(<= (object_get_health exhaust_port) 0)
		)
		1
	)

	; half open
	(device_set_position piston r_engine_destroyed_position)
	(sound_impulse_stop sound/levels/d40/d40_piston_exposed)
	(sound_impulse_start sound/levels/d40/d40_piston_destroyed emitter 1)
	; increment reactor health, controls vfx
	(set r_reactor_health_state (+ r_reactor_health_state 0.2))

	(f_unblip_object exhaust_port)
	(f_controls_blip)
	(game_save_no_timeout)
)

(script static void f_pistons_close
	(if
		(> (object_get_health engine_exhaust_1) 0)
		(begin
			(device_set_position engine_piston_1_device 0)
			(device_group_set engine_piston_1_control engine_piston_1_position 0)
			(f_unblip_object engine_exhaust_1)
		)
	)
	(if
		(> (object_get_health engine_exhaust_2) 0)
		(begin
			(device_set_position engine_piston_2_device 0)
			(device_group_set engine_piston_2_control engine_piston_2_position 0)
			(f_unblip_object engine_exhaust_2)
		)
	)
	(if
		(> (object_get_health engine_exhaust_3) 0)
		(begin
			(device_set_position engine_piston_3_device 0)
			(device_group_set engine_piston_3_control engine_piston_3_position 0)
			(f_unblip_object engine_exhaust_3)
		)
	)
	(if
		(> (object_get_health engine_exhaust_4) 0)
		(begin
			(device_set_position engine_piston_4_device 0)
			(device_group_set engine_piston_4_control engine_piston_4_position 0)
			(f_unblip_object engine_exhaust_4)
		)
	)
	(sound_impulse_stop sound/levels/d40/d40_piston_exposed)
)

(script static void f_controls_enable
	(if
		(> (object_get_health engine_exhaust_1) 0)
		(begin
			(device_set_power engine_piston_1_control 1)
			(device_group_set engine_piston_1_control engine_piston_1_position 0)
		)
	)
	(if
		(> (object_get_health engine_exhaust_2) 0)
		(begin
			(device_set_power engine_piston_2_control 1)
			(device_group_set engine_piston_2_control engine_piston_2_position 0)
		)
	)
	(if
		(> (object_get_health engine_exhaust_3) 0)
		(begin
			(device_set_power engine_piston_3_control 1)
			(device_group_set engine_piston_3_control engine_piston_3_position 0)
		)
	)
	(if
		(> (object_get_health engine_exhaust_4) 0)
		(begin
			(device_set_power engine_piston_4_control 1)
			(device_group_set engine_piston_4_control engine_piston_4_position 0)
		)
	)
)

(script static void f_controls_blip
	(if
		(> (object_get_health engine_exhaust_1) 0)
		(f_blip_object engine_piston_1_control blip_objective)
	)
	(if
		(> (object_get_health engine_exhaust_2) 0)
		(f_blip_object engine_piston_2_control blip_objective)
	)
	(if
		(> (object_get_health engine_exhaust_3) 0)
		(f_blip_object engine_piston_3_control blip_objective)
	)
	(if
		(> (object_get_health engine_exhaust_4) 0)
		(f_blip_object engine_piston_4_control blip_objective)
	)
)

(script static void f_controls_unblip
	(f_unblip_object engine_piston_1_control)
	(f_unblip_object engine_piston_2_control)
	(f_unblip_object engine_piston_3_control)
	(f_unblip_object engine_piston_4_control)
)

; called from audio so that the presentation is pleasent
; secretly updates the objective texts to the right count
(script dormant engine_room_objective
	(f_hud_obj_new obj_d40_frogblast obj_d40_frogblast)
	(sleep_until (>= (f_exhaust_killed) 1) 1)
	(f_hud_obj_advance obj_d40_frogblast2 true)
	(sleep_until (>= (f_exhaust_killed) 2) 1)
	(f_hud_obj_advance obj_d40_frogblast3 true)
	(sleep_until (>= (f_exhaust_killed) 3) 1)
	(f_hud_obj_advance obj_d40_frogblast4 true)
	(sleep_until (>= (f_exhaust_killed) 4) 1)
	(f_hud_obj_advance obj_d40_frogblast5 false)
)

; set the internal strings to the right state, and show complete in hud if requested
(script static void (f_hud_obj_advance (user_interface_objective obj_reference) (boolean b_show_hud_finish))
	; pause menu should show how many engines are destroyed
	(f_hud_pause_menu_new_objective_internal obj_reference)
	; hud should say how many engines are destroyed is completed
	(objectives_hud_clear)
    (objectives_hud_set_string 0 obj_reference)
	(if b_show_hud_finish
		(begin
			(set b_needs_clear_obj_hud_pop false)
			(objectives_hud_finish_up_to 0)
		)
		(set b_needs_clear_obj_hud_pop true)
	)
)

(script static boolean armory_needed
	(and
		(not (f_players_holding_explosive))
		(or
			(> (device_get_position engine_piston_1_device) r_engine_destroyed_position)
			(> (device_get_position engine_piston_2_device) r_engine_destroyed_position)
			(> (device_get_position engine_piston_3_device) r_engine_destroyed_position)
			(> (device_get_position engine_piston_4_device) r_engine_destroyed_position)
		)
	)
)

(global boolean b_armory_reminding false)

(script dormant armory_reminder
	(wake dialogue_engine_armory)
	(sleep_until
		(begin
			(if
				(armory_needed)
				(begin
					(set b_armory_reminding true)
					(f_blip_flag fl_engine_armory blip_objective)

					(sleep_until (not (armory_needed)) 1)
					(set b_armory_reminding false)
					(f_unblip_flag fl_engine_armory)
				)
			)

			(= (f_exhaust_killed) 4)
		)
		1
	)
)

(script dormant beat_5_open_engine_room
	(sleep_until (<= (f_exhaust_alive) 0) 1)

	(print "engine room complete")
	(set b_enc5_1_complete true)
	(set b_dialogue_monitor_complete true)

	; close entrance doors, everybody in here now
	(device_set_position entrance_engine_room 0)
	(device_set_position entrance_engine_room2 0)
	(device_set_power entrance_engine_room 0)
	(device_set_power entrance_engine_room2 0)
	(volume_teleport_players_not_inside tv_engine_room fl_engine_room_teleport)

	(device_set_position engine_room_blast_door_elevator_entrance 1)
	(device_set_position engine_room_blast_door_elevator_entrance2 1)

	(wake mus_17)

	(game_save_no_timeout)
	(sleep (game_ticks_from_seconds 4.00)) ; small delay for asthetics
	(f_hud_obj_new obj_d40_elevator obj_d40_elevator)
	(sleep (game_ticks_from_seconds 1.00))

	(f_exclusive_blip_flag_clear)
	(f_blip_flag fl_engine_escape_0a blip_objective)
	(f_blip_flag fl_engine_escape_0b blip_objective)

	(sleep_until (volume_test_players tv_enc5_1_exit) 1)
	(f_unblip_flag fl_engine_escape_0a)
	(f_unblip_flag fl_engine_escape_0b)
	(f_blip_flag fl_engine_escape_1 blip_objective)
)

(script dormant enc5_2
	(sleep_until (<= (f_exhaust_alive) 0) 1)
	(f_ai_place_over_ticks sq_enc5_2_cov_ds sq_enc5_2_cov_ds2 none none none none)
	(if (= (game_difficulty_get_real) "legendary")
		(ai_place sq_enc5_2_cov_h)
	)

	(sleep_until (volume_test_players tv_enc5_2) 1)
	(f_ai_place_over_ticks sq_enc5_2_cov_ese sq_enc5_2_cov_esg none none none none)
	(sleep 1)
	(device_group_set unsc_cargo_elevator_device unsc_cargo_elevator_position 0)
)

(script dormant enc5_3
	(sleep_until (volume_test_players enc5_3) 1)

	; blip if any elevator enemies are still alive
	(if
		(> (ai_nonswarm_count gr_enc5_2_cov_es) 0)
		(begin
			(f_blip_ai gr_enc5_2_cov_es blip_enemies)
			(sleep_until
				(and
					(volume_test_players enc5_3)
					(= (ai_nonswarm_count gr_enc5_2_cov_es) 0)
				)
				1
			)
		)
	)

	(f_unblip_flag fl_engine_escape_1)
	(device_set_position elevator_door 0)
	(sleep_until (< (device_get_position elevator_door) 0.3) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_enc5_3_prelift1)
	(sleep (game_ticks_from_seconds 0.16))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_enc5_3_prelift2)
	(sleep (game_ticks_from_seconds 0.16))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_enc5_3_prelift3)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_enc5_3_prelift4)
	(sleep (game_ticks_from_seconds 0.16))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_enc5_3_prelift5)
	(sleep (game_ticks_from_seconds 0.16))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_enc5_3_prelift6)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_enc5_3_prelift7)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_enc5_3_prelift8)
	(damage_objects_effect "objects\vehicles\human\scorpion\turrets\scorpion_cannon\weapon\projectiles\damage_effects\scorpion_cannon_round.damage_effect" (volume_return_objects elevator_miss_damage))

	(device_group_set unsc_cargo_elevator_device unsc_cargo_elevator_position 1)
	(wake dialogue_enter_lift)

	; our intension is that players that are close to the elevator, but not on it, will die in the explosions.
	; players that are very far away get teleported onto the elevator
	(sleep_until (>= (device_get_position unsc_cargo_elevator_device) 0.1) 1)
	(volume_teleport_players_not_inside tv_coop_03_elevator fl_coop_03_elevator)
	(elevator_explosion 0.1 fl_enc5_3_01a fl_enc5_3_01b)
	(elevator_explosion 0.2 fl_enc5_3_02a fl_enc5_3_02b)
	(elevator_explosion 0.3 fl_enc5_3_03a fl_enc5_3_03b)
	(elevator_explosion 0.4 fl_enc5_3_04a fl_enc5_3_04b)
	(elevator_explosion 0.5 fl_enc5_3_05a fl_enc5_3_05b)
	(elevator_explosion 0.6 fl_enc5_3_06a fl_enc5_3_06b)
	(elevator_explosion 0.7 fl_enc5_3_07a fl_enc5_3_07b)
	(elevator_explosion 0.8 fl_enc5_3_08a fl_enc5_3_08b)
	(elevator_explosion 0.9 fl_enc5_3_09a fl_enc5_3_09b)
	(elevator_explosion 1.0 fl_enc5_3_10a fl_enc5_3_10b)
)

(script static void (elevator_explosion (real position)(cutscene_flag flag_1)(cutscene_flag flag_2))
	(sleep_until (>= (device_get_position unsc_cargo_elevator_device) position) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" flag_1)
	(sleep (game_ticks_from_seconds 0.5))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" flag_2)
)

(script dormant kill_all_beat_5
	(ai_disposable gr_enc5_1_cov true)
	(ai_disposable gr_enc5_1_flood true)
	(ai_disposable gr_enc5_1_infs true)
	(ai_disposable gr_enc5_1_monitor true)
	(ai_disposable gr_enc5_1_sents true)
	(ai_disposable gr_enc5_2_cov true)
)

;====================================================================================================================================================================================================
; d40_beat_6
;====================================================================================================================================================================================================

(script dormant d40_beat_6
	(sleep_until (volume_test_players tv_section6) 1)
	(wake vehicle_bay_explosions)
	; unlock progress data
	(submit_incident "ins_d40_warthog")
	(submit_incident "unlock_d40")
	(submit_incident_with_custom_string_id "game_activity_begin" "d40")

	(print "d40_beat_6")
	(game_save_no_timeout)
	(wake present_chapter_3)

	(wake kill_all_beat_5)
	(wake mus_18)

	; set all race related values
	(set warthog_race_direction 1)
	;(update_race_point fl_foehammer_rv_point)

	(wake beat6_spawn_first_encounter)
	(wake enc6_0_trigger)
	(wake dialogue_enter_vehicle_bay)
	(wake dialogue_leave_warthog_room)
)
(global real r_distance_delta 0)
(global short s_current_race_distance 0)
(script dormant check_player_in_warthog
	(wake update_race_point_loop)
	(set last_player_end_distance (objects_distance_to_flag (players) race_end_point))
	(sleep_until
		(begin
			(set s_current_race_distance (objects_distance_to_flag (players) race_end_point))
			(set r_distance_delta (+ r_distance_delta (- s_current_race_distance last_player_end_distance)))
			(set last_player_end_distance s_current_race_distance)
			(if (and
					(any_players_in_vehicle_type s_vehicle_type_warthog)
					(not (game_is_cooperative))
					(>= (game_seconds_from_ticks warthog_interval) 8)
				)
				(begin
					(set warthog_interval 0)
					(begin ;if current distance to end point is too big start wrong direction dialog
						(if (> r_distance_delta 8)
							(begin
								(set r_distance_delta 0)
								(dialogue_player_wrong_direction)
							)
						)
						(set r_distance_delta 0)
					)

				)
			)

			(if (and
					(> (game_seconds_from_ticks warthog_interval) 30)
					(not (any_players_in_vehicle));after 15 seconds not being in warthog start cortana warning dialogue
				)
				(begin
					(set warthog_interval 0)
					(dialogue_player_leaves_vehicle)

				)
			)
			(set warthog_interval (+ 1 warthog_interval))
			b_race_over
		)
		1
	)
)


(script static void (update_race_point
						(cutscene_flag race_flag)
					)
	(set race_end_point race_flag)
	(set last_player_end_distance (abs_real (objects_distance_to_flag (players) race_flag)))
)

(global short s_timer_seconds (* 7 60)) ; 7 min default
(global short s_timer_seconds_elapsed 0)
(global boolean b_timer_show false)

(script static short timer_seconds_left
	(- s_timer_seconds s_timer_seconds_elapsed)
)

(script static boolean (timer_seconds_until (short seconds))
	; debug
	; (if
	; 	(<= (timer_seconds_left) seconds)
	; 	(inspect seconds)
	; )
	(<= (timer_seconds_left) seconds)
)

(script static void (timer_show (boolean show))
	(set b_timer_show show)
	(if
		show
		(begin
			(chud_bonus_round_set_timer (timer_seconds_left))
			(chud_bonus_round_show_timer true)
			(chud_bonus_round_start_timer true)
		)
		(begin
			(chud_bonus_round_start_timer false)
			(chud_bonus_round_show_timer false)
		)
	)
)

(script dormant timer_measure
	; initial increment
	(set s_timer_seconds_elapsed (+ s_timer_seconds_elapsed 1))

	(sleep_until
		(begin
			(if
				b_timer_show
				(set s_timer_seconds_elapsed (+ s_timer_seconds_elapsed 1))
			)
			(timer_seconds_until 0)
		)
		(game_ticks_from_seconds 1)
	)
)

(script dormant manage_timer
	(wake timer_measure)
	(timer_show true)
	(wake timer_progression)

	(sleep_until (timer_seconds_until 30) 1)
	(wake dialogue_thirty_seconds)

	(sleep_until (timer_seconds_until 0) 1)

	; out of time! failure cinematic
	(if (not b_player_longsword)
		(begin
			(timer_show false)
			(wake mus_23)
			(f_play_fail_cinematic cinematics\d40\d40_fail.cinematic)
		)
	)
)

(script static void (measured_sleep (trigger_volume trigger) (real timer_ratio))
	; until player hits trigger or our time has come
	(sleep_until
		(or
			(volume_test_players trigger)
			(<= (timer_seconds_left) (* timer_ratio s_timer_seconds))
		)
		1
	)
	(if
		(not (volume_test_players trigger))
		(print "measured_sleep timed out")
	)
)

(script static void (measured_save (string name) (real timer_ratio))
	; if we have enough time, save
	(if
		(> (timer_seconds_left) (* timer_ratio s_timer_seconds))
		(game_save)
		(print "measured_save skipped")
	)
	(print name)
	(inspect (timer_seconds_left))
	(inspect (* timer_ratio s_timer_seconds))
)

(script dormant timer_progression
	;pausing autosave loop
	(f_pause_auto_save_loop)

	(measured_sleep tv_enc6_1_9 0.71)
	; not safe enough yet here, figure out enemies
	(measured_save "split checkpoint" 0.71)

	(measured_sleep tv_enc6_3_2 0.5)
	(measured_save "foehammer checkpoint" 0.5)
)

(script dormant beat6_spawn_first_encounter
	; sq_gr_enc6_0_cov
	(f_ai_place_over_ticks enc6_0_elites enc6_0_grunts1 enc6_0_grunts2 enc6_0_grunts3 none none)
)

(script dormant enc6_0_trigger
	(sleep_until
		(volume_test_players tv_enc6_0)
		1
		(game_ticks_from_seconds 15)
	)
	; sq_gr_enc6_0_flood
	(f_ai_place_over_ticks enc6_0_combats enc6_0_infs none none none none)
	(wake enc6_0_1_trigger)

	(sleep_until
		(or
			(unit_in_vehicle_type player0 s_vehicle_type_warthog)
			(unit_in_vehicle_type player1 s_vehicle_type_warthog)
			(unit_in_vehicle_type player2 s_vehicle_type_warthog)
			(unit_in_vehicle_type player3 s_vehicle_type_warthog)
			(volume_test_players tv_enc6_1)
		)
		1
		(game_ticks_from_seconds 30)
	)
	(wake dialogue_player_in_warthog)

	(cond
		(
			(= (game_difficulty_get_real) "easy")
			; +1 min
			(set s_timer_seconds (+ s_timer_seconds (* 1 60)))
		)
		(
			(= (game_difficulty_get_real) "heroic")
			; -1 min
			(set s_timer_seconds (- s_timer_seconds (* 1 60)))
		)
		(
			; -2 min
			(= (game_difficulty_get_real) "legendary")
			(set s_timer_seconds (- s_timer_seconds (* 2 60)))
		)
	)
	(wake manage_timer)
)

(script dormant vehicle_bay_explosions
	(sleep_until (volume_test_players tv_enc6_0) 1)
	(unit_kill bay_warthog_sacrifice)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_hor_med" fl_vehicle_bay_exp1)
	(sleep (game_ticks_from_seconds 0.5))
	(effect_new "fx/explosions/common/explo_unsc_hor_med" fl_vehicle_bay_exp0)
)

(script dormant enc6_0_1_trigger
	(sleep_until (volume_test_players tv_enc6_0_1) 1)
	(wake enc6_1_trigger)

	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_vehicle_bay_exp2)

	(wake exterior_explo_1)
)

(script dormant update_race_point_loop
	(update_race_point fl_foehammer_rv_point)
	(sleep_until
		(begin
			(cond
				((volume_test_players tv_enc6_1_6) (backwards_check fl_foehammer_rv_point fl_foehammer_rv_point tv_enc6_1_6))
				((volume_test_players tv_enc6_1_4) (backwards_check fl_race_point_1 fl_race_point_1 tv_enc6_1_4))
				((volume_test_players tv_race_point_2) (backwards_check fl_race_point_2 fl_race_point_2 tv_race_point_2))
				((volume_test_players tv_race_point_3_safety_1) (backwards_check fl_race_point_2 fl_race_point_2 tv_race_point_3_safety_1))
				((volume_test_players tv_race_point_3) (backwards_check fl_race_point_3 fl_race_point_3 tv_race_point_3))
				((volume_test_players tv_race_point_4_safety_1) (backwards_check fl_race_point_3 fl_race_point_3 tv_race_point_4_safety_1))
				((volume_test_players tv_race_point_4) (backwards_check fl_race_point_4 fl_race_point_4 tv_race_point_4))
				((volume_test_players tv_enc6_1_9) (backwards_check fl_race_point_4 fl_race_point_4 tv_enc6_1_9))
				((volume_test_players tv_enc6_1_9_1) (backwards_check fl_foehammer_rv_point fl_foehammer_rv_point tv_enc6_1_9_1)) ;special case for shortcut handling
				((volume_test_players tv_enc6_1_9_2) (backwards_check fl_foehammer_rv_point fl_foehammer_rv_point tv_enc6_1_9_2))
				((volume_test_players tv_enc6_1_9_3) (backwards_check fl_race_point_4 fl_race_point_4 tv_enc6_1_9_3));seems like we needed one more to prevent an edgecase
				((volume_test_players tv_enc6_4) (backwards_check fl_extraction_point fl_extraction_point tv_enc6_4));this is a point of no return.
				((volume_test_players tv_enc6_5_1_safety) (backwards_check fl_extraction_point fl_extraction_point tv_enc6_5_1_safety))
				((volume_test_players tv_enc6_5_1) (backwards_check fl_extraction_point2 fl_extraction_point2 tv_enc6_5_1)) ;there is a point of no return between tv_enc6_5_1 and tv_enc6_1_9. we don't need to account for the players making it all the way back there.
				((volume_test_players tv_enc6_5_3_safety) (backwards_check fl_extraction_point2 fl_extraction_point2 tv_enc6_5_3_safety))
				((volume_test_players tv_enc6_5_3) (backwards_check fl_extraction_point4 fl_extraction_point4 tv_enc6_5_3))
				((volume_test_players tv_enc6_5_4) (backwards_check fl_extraction_point2 fl_extraction_point2 tv_enc6_5_4))
				((volume_test_players tv_enc7_0) (backwards_check fl_extraction_point3 fl_extraction_point3 tv_enc7_0)) ; this is the jump landing volume. point of no return.
				((volume_test_players tv_enc7_0_2_safety) (backwards_check fl_extraction_point3 fl_extraction_point3 tv_enc7_0_2_safety))
				((volume_test_players tv_enc7_0_2) (backwards_check fl_control_button_end fl_control_button_end tv_enc7_0_2))
			)
			b_race_over
		)
	1)
)

(script static void (backwards_check (cutscene_flag fwd_point) (cutscene_flag bwd_point) (trigger_volume vol))
	(if (= race_end_point fwd_point)
		(update_race_point bwd_point)
		(update_race_point fwd_point)
	)
	(sleep_until (not (volume_test_players vol)) 1)
)

(script dormant enc6_1_trigger
	(sleep_until (volume_test_players tv_enc6_1) 1)

	(wake enc6_1_1_trigger)

	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_vehicle_bay_exp3)
	; sq_gr_enc6_1_cov_scorpion_bay
	(f_ai_place_over_ticks enc6_1_elites_scorpion_bay enc6_1_grunts_scorpion_bay none none none none)
	(sleep (game_ticks_from_seconds 0.5))

	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_vehicle_bay_exp4)
	; sq_gr_enc6_1_flood_scorpion_bay
	(f_ai_place_over_ticks enc6_1_combat_marine_3 enc6_1_combat_marine_3_1 enc6_1_combat_marine_3_2 enc6_1_combat_marine_3_3 enc6_1_infs none)
)

(script dormant enc6_1_1_trigger
	(sleep_until (volume_test_players tv_enc6_1_1) 1)

	(wake enc6_1_2_trigger)

	(ai_disposable sq_gr_enc6_0_cov true)
	(ai_disposable sq_gr_enc6_0_flood true)


	; sq_gr_enc6_1_cov_pelican_bay
	(f_ai_place_over_ticks enc6_1_2_elites enc6_1_2_grunts none none none none)
	(sleep (game_ticks_from_seconds 1))
	; sq_gr_enc6_1_flood_pelican_bay
	(f_ai_place_over_ticks enc6_1_combat_elite_2 enc6_1_combat_marine_2 enc6_1_infection_2 none none none)
)

(script dormant enc6_1_2_trigger
	(sleep_until (volume_test_players tv_enc6_1_2) 1)

	(wake enc6_1_4_trigger)

	(ai_disposable sq_gr_enc6_1_cov_scorpion_bay true)
	(ai_disposable sq_gr_enc6_1_flood_scorpion_bay true)

)

(script dormant enc6_1_4_trigger
	(sleep_until (volume_test_players tv_enc6_1_4) 1)

	(wake enc6_1_5_trigger)
	(wake race_point_2)



	(f_ai_place_over_ticks enc6_1_3_1_flood enc6_1_3_1_sents none none none none)
)

(script dormant race_point_2
	(sleep_until (volume_test_players tv_race_point_2) 1)

	(wake race_point_3)
)

(script dormant enc6_1_5_trigger
	(sleep_until (volume_test_players tv_enc6_1_5) 1)

	(wake enc6_1_5_1_trigger)
	(wake pelican_4_trigger)

	(ai_disposable sq_gr_enc6_1_flood_pelican_bay true)
	(ai_disposable sq_gr_enc6_1_cov_pelican_bay true)

	(garbage_collect_now)
	(sleep (game_ticks_from_seconds 1))

	(f_ai_place_over_ticks enc6_1_combat_elite_1 enc6_1_combat_marine_1 enc6_1_infection_1 none none none)
	(sleep (game_ticks_from_seconds 1))
	(f_ai_place_over_ticks enc6_1_3_sents_1 enc6_1_3_sents_2 none none none none)
)

(script dormant race_point_3
	(sleep_until (volume_test_players tv_race_point_3) 1)

	(f_ai_place_over_ticks enc6_1_3_sents_3 enc6_1_3_2_marines_2 none none none none)

	(wake race_point_4)
)

(script dormant pelican_4_trigger
	(sleep_until (volume_test_players tv_pelican_4) 1)

	(ai_disposable enc6_1_3_1_flood true)
	(ai_disposable enc6_1_3_1_sents true)
)

(script dormant enc6_1_5_1_trigger
	(sleep_until (volume_test_players tv_enc6_1_5_1) 1)
	(wake pelican_3_trigger)
)

(script dormant pelican_3_trigger
	(sleep_until (volume_test_players tv_pelican_3) 1)

	(wake enc6_1_8_trigger)
)

(script dormant race_point_4
	(sleep_until (volume_test_players tv_race_point_4) 1)

)

(script dormant enc6_1_8_trigger
	(sleep_until (volume_test_players tv_enc6_1_8) 1)
	(f_ai_place_over_ticks enc6_1_3_2_carriers1 enc6_1_3_2_infb1 enc6_1_3_2_marines_1 none none none)

	(ai_disposable enc6_1_combat_elite_1 true)
	(ai_disposable enc6_1_combat_marine_1 true)
	(ai_disposable enc6_1_infection_1 true)
	(ai_disposable sq_gr_enc6_1_sents_mac_chamber true)
	(wake enc6_1_9_trigger)
)

(script dormant enc6_1_9_trigger
	(sleep_until (volume_test_players tv_enc6_1_9) 1)



	(ai_place sq_gr_enc6_2_cov)
	(wake enc6_1_9_1_trigger)
	(wake big_jump1_explosions)
	(wake big_jump1_player0)
	(wake big_jump1_player1)
	(wake big_jump1_player2)
	(wake big_jump1_player3)
)

(script dormant enc6_1_9_1_trigger
	(sleep_until (volume_test_players tv_enc6_1_9_1) 1)

	(wake enc6_2_trigger)


	(sleep_until (volume_test_players tv_enc6_1_9_2) 1)
	(wake trigger_flyby)
	(sleep_until (>= (device_get_position dm_foehammer_flyby) 0.35) 1)
	(wake dialogue_foehammer_evade)
)

(script dormant trigger_flyby
	(wake foehammer_flyby_emitters)
	(do_flyby_foehammer)
	(sleep (game_ticks_from_seconds 4))
	(do_flyby_banshee_b)
	(sleep (game_ticks_from_seconds 4))
	(do_flyby_banshee_a)

)

(script static void do_flyby_foehammer
	(object_create_if_necessary dm_foehammer_flyby)
	(device_set_position_transition_time dm_foehammer_flyby 18)
	(device_set_position dm_foehammer_flyby 1)
	(device_set_position_track dm_foehammer_flyby "flyby" 0)
	(device_animate_position dm_foehammer_flyby 1 18 1 1 true)
)
(script static void do_flyby_banshee_a
	(object_create_if_necessary dm_banshee_a_flyby)
	(device_set_position_transition_time dm_banshee_a_flyby 26)
	(device_set_position dm_banshee_a_flyby 1)
	(device_set_position_track dm_banshee_a_flyby "a_flyby" 0)
	(device_animate_position dm_banshee_a_flyby 1 26 1 1 true)
)

(script static void do_flyby_banshee_b
	(object_create_if_necessary dm_banshee_b_flyby)
	(device_set_position_transition_time dm_banshee_b_flyby 18)
	(device_set_position dm_banshee_b_flyby 1)
	(device_set_position_track dm_banshee_b_flyby "b_flyby" 0)
	(device_animate_position dm_banshee_b_flyby 1 18 1 1 true)
)


(script dormant enc6_2_trigger
	(sleep_until (volume_test_players tv_enc6_2) 1)

	(ai_place sq_gr_enc6_2_1_flood)
	(sleep (game_ticks_from_seconds 1))
	(ai_place sq_gr_enc6_2_sents)

	(sleep_until (volume_test_players tv_big_jump1_end) 1)

	(ai_disposable sq_gr_enc6_1_flood_mac_chamber true)
	(wake enc6_2_cleanup_trigger)
	(wake enc6_3_trigger)
	(ai_place sq_gr_enc6_2_2_flood)
)

(script dormant enc6_2_cleanup_trigger
	(sleep_until (volume_test_players tv_enc6_2_wipe) 1)
	(ai_disposable sq_gr_enc6_2_cov true)
)

(script dormant big_jump1_explosions
	(sleep_until (volume_test_players tv_enc6_1_9_1) 1)

	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_big_jump1_exp0)
	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_big_jump1_exp1)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_big_jump1_exp2)

	(sleep_until (volume_test_players tv_enc6_2) 1)
	(sleep (game_ticks_from_seconds 2.0))
	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_big_jump1_exp3)
	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_big_jump1_exp4)
)

; jump!
(script dormant big_jump1_player0
	(sleep_until (volume_test_object tv_big_jump1_safe player0) 1)
	(object_cannot_take_damage player0)

	(sleep_until (volume_test_object tv_big_jump1_end player0) 1)
	(object_can_take_damage player0)
)

(script dormant big_jump1_player1
	(sleep_until (volume_test_object tv_big_jump1_safe player1) 1)
	(object_cannot_take_damage player1)

	(sleep_until (volume_test_object tv_big_jump1_end player1) 1)
	(object_can_take_damage player1)
)

(script dormant big_jump1_player2
	(sleep_until (volume_test_object tv_big_jump1_safe player2) 1)
	(object_cannot_take_damage player2)

	(sleep_until (volume_test_object tv_big_jump1_end player2) 1)
	(object_can_take_damage player2)
)

(script dormant big_jump1_player3
	(sleep_until (volume_test_object tv_big_jump1_safe player3) 1)
	(object_cannot_take_damage player3)

 	(sleep_until (volume_test_object tv_big_jump1_end player3) 1)
	(object_can_take_damage player3)
)

(script dormant enc6_3_trigger
	(sleep_until (volume_test_players tv_enc6_3) 1)
	(wake enc6_3_1_trigger)

	(object_destroy_folder sc_track_middle_vehicles)

	(ai_disposable sq_gr_enc6_2_1_flood true)
	(ai_disposable sq_gr_enc6_2_2_flood true)
	(ai_disposable sq_gr_enc6_2_sents true)

	(ai_place sq_gr_enc6_3_flood)

	(sleep (game_ticks_from_seconds 1))
	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_enc6_3_exp0)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_enc6_3_exp1)
)

(script dormant enc6_3_1_trigger
	(sleep_until (volume_test_players tv_enc6_3_1) 1)
	(ai_place sq_gr_enc6_3_cov)

	(sleep (game_ticks_from_seconds 2))

	(ai_flee_to_point fuel_rod_grunts ps_grunts_flee/p0)
	(sleep (game_ticks_from_seconds 0.5))
	(ai_flee_to_point grunts_advance ps_grunts_flee/p0)

	(wake enc6_3_2_trigger)
	; (wake enc6_3_explosions)
)

; (script dormant enc6_3_explosions
; 	(sleep_until (volume_test_players tv_) 1)

; 	(sleep (game_ticks_from_seconds 1))
; 	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_enc6_3_exp2)
; 	(sleep (game_ticks_from_seconds 1))
; 	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_enc6_3_exp3)
; 	(sleep (game_ticks_from_seconds 1))
; 	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_enc6_3_exp4)
; )

(script dormant enc6_3_2_trigger
	(sleep_until (volume_test_players tv_enc6_3_2) 1)

	(wake enc6_4_trigger)
	(wake dialogue_foehammer_pick_up)

	(ai_disposable sq_gr_enc6_3_cov true)
	(ai_disposable sq_gr_enc6_3_flood true)
)

(script dormant enc6_4_trigger
	(sleep_until (volume_test_players tv_enc6_4) 1)

	(wake enc6_5_0_trigger)

	(timer_show false)
	; pretend timer took 10s regardless
	(set s_timer_seconds_elapsed (+ s_timer_seconds_elapsed 10))

	(sleep_until b_foehammer_crash_start 1)
	(wake trigger_chase)


	(sleep_until
		(> (device_get_position dm_foehammer_crash) 0.5)
		1
	)
	; nude crates out of path
	; (effect_new_at_point_set_point "fx/explosions/common/explo_unsc_hor_med" ps_enc6_4_exp 0)
	; (effect_new_at_point_set_point "fx/explosions/common/explo_unsc_hor_med" ps_enc6_4_exp 1)
)

(script dormant trigger_chase
	(wake foehammer_death_emitters)
	(play_foehammer_crash)
	(sleep (game_ticks_from_seconds 4))
	(play_banshee_crash)
)

(script static void play_foehammer_crash
	(device_set_position_transition_time dm_foehammer_crash 22)
	(device_set_position dm_foehammer_crash 1)
	(device_set_overlay_track dm_foehammer_crash "crash")
	(device_animate_overlay dm_foehammer_crash 1 22 1 1)
)

(script static void play_banshee_crash
	(device_set_position_transition_time dm_banshee_a_crash 18)
	(device_set_position dm_banshee_a_crash 1)
	(device_set_overlay_track dm_banshee_a_crash "a_crash")
	(device_animate_overlay dm_banshee_a_crash 1 16 1 1)

	(device_set_position_transition_time dm_banshee_b_crash 18)
	(device_set_position dm_banshee_b_crash 1)
	(device_set_overlay_track dm_banshee_b_crash "b_crash")
	(device_animate_overlay dm_banshee_b_crash 1 16 1 1)
)

(script dormant enc6_5_0_trigger
	(sleep_until (or b_foehammer_crash_complete (volume_test_players tv_enc6_5_0)) 1)
	(wake enc6_5_0_1_trigger)
	(wake mus_21)
	(wake whr_explos_fh_1)

	(timer_show true)

	(ai_place sq_gr_enc6_5_0_flood_long_room)
	(sleep (game_ticks_from_seconds 1))
	(ai_place sq_gr_enc6_5_0_sents_long_room)
	(sleep (game_ticks_from_seconds 1))
	(ai_place sq_gr_enc6_5_0_cov_long_room)
)

(script dormant enc6_5_0_1_trigger
	(sleep_until (volume_test_players tv_enc6_5_0_1) 1)

	(ai_place sq_gr_enc6_5_1_0_flood_hallway)

	(wake enc6_5_1_trigger)
)

(script command_script cs_thirsty_grunt
	(ai_suppress_combat ai_current_squad true)
	(sleep_until (volume_test_players tv_enc6_5_1_grunt_ee) 1)
	(cs_face_player true)
	(wake dialogue_thirsty_grunt)
	(submit_incident "listened_to_thirsty_grunt")
	(sleep_until false 1) ; hold forever
)

(script dormant enc6_5_1_trigger
	(sleep_until (volume_test_players tv_enc6_5_1) 1)

	(ai_disposable sq_gr_enc6_5_0_flood_long_room true)
	(ai_disposable sq_gr_enc6_5_0_sents_long_room true)
	(ai_disposable sq_gr_enc6_5_0_cov_long_room true)
	(sleep (game_ticks_from_seconds 1))
	(ai_place sq_gr_enc6_5_1_grunt_ee)
	(object_create_folder bi_grunt_ee)
	(wake enc6_5_2_trigger)
)

(script dormant enc6_5_2_trigger
	(sleep_until (volume_test_players tv_enc6_5_2) 1)

	(ai_disposable sq_gr_enc6_5_1_0_flood_hallway true)
	(ai_place sq_gr_enc6_5_1_flood_runway)
	(sleep (game_ticks_from_seconds 1))
	(ai_place sq_gr_enc6_5_1_sents_runway)
	(ai_prefer_target_ai sq_gr_enc6_5_1_flood_runway sq_gr_enc6_5_1_sents_runway true)
	(ai_prefer_target_ai sq_gr_enc6_5_1_sents_runway sq_gr_enc6_5_1_flood_runway true)

	(wake big_jump2_trigger)
	(wake dialogue_big_jump)
)

(script dormant big_jump2_trigger
	(sleep_until (volume_test_players tv_big_jump2) 1)

	(wake jump2_player0)
	(wake jump2_player1)
	(wake jump2_player2)
	(wake jump2_player3)
)

; jump again!
(script dormant jump2_player0
	(sleep_until (volume_test_object tv_big_jump2_safe player0) 1)
	(object_cannot_take_damage player0)

 	(sleep_until
		(or
			(volume_test_object tv_big_jump2_failed player0)
			(volume_test_object section7 player0)
		)
		1
	)
	(object_can_take_damage player0)
)

(script dormant jump2_player1
	(sleep_until (volume_test_object tv_big_jump2_safe player1) 1)
	(object_cannot_take_damage player1)

 	(sleep_until
		(or
			(volume_test_object tv_big_jump2_failed player1)
			(volume_test_object section7 player1)
		)
		1
	)
	(object_can_take_damage player1)
)

(script dormant jump2_player2
	(sleep_until (volume_test_object tv_big_jump2_safe player2) 1)
	(object_cannot_take_damage player2)

 	(sleep_until
		(or
			(volume_test_object tv_big_jump2_failed player2)
			(volume_test_object section7 player2)
		)
		1
	)
	(object_can_take_damage player2)
)

(script dormant jump2_player3
	(sleep_until (volume_test_object tv_big_jump2_safe player3) 1)
	(object_cannot_take_damage player3)

 	(sleep_until
		(or
			(volume_test_object tv_big_jump2_failed player3)
			(volume_test_object section7 player3)
		)
		1
	)
	(object_can_take_damage player3)
)

;====================================================================================================================================================================================================
; d40_beat_7
;====================================================================================================================================================================================================
(script dormant d40_beat_7
	(sleep_until (volume_test_players tv_enc7_0) 1)
	(print "d40_beat_7")



	(ai_disposable sq_gr_enc6_5_1_flood_runway true)
	(ai_disposable sq_gr_enc6_5_1_sents_runway true)
	(ai_disposable sq_gr_enc6_5_1_grunt_ee true)
	(garbage_collect_now)
	(sleep (game_ticks_from_seconds 1))

	(ai_place gr_enc7_0_flood)

	(wake enc7_0_2_trigger)
)

(script dormant enc7_0_2_trigger
	(sleep_until (volume_test_players tv_enc7_0_2) 1)
	(wake enc7_1_trigger)
	(wake hangar_approach_explosions)
)

(script dormant enc7_1_trigger
	(sleep_until (volume_test_players tv_enc7_1) 1)
	(print "enc7_7_1_trigger")
	(wake get_aboard_trigger)

	(f_ai_place_over_ticks gr_enc7_7_flood gr_enc7_7_cov none none none none)
)

(global short s_enc7_7_shoot_on_ticks 10)
(global real r_enc7_7_shoot_timing_seconds 0.75)

(script command_script cs_enc7_7_shoot
	(cs_enable_targeting true)
	(cs_enable_looking true)

	(sleep (game_ticks_from_seconds (real_random_range 0.0 0.8)))

	; strafe shots every 25s
	(sleep_until
		(begin
			(cs_shoot_point true ps_enc7_7_shoot/p0)
			(sleep s_enc7_7_shoot_on_ticks)
			(cs_shoot_point false ps_enc7_7_shoot/p0)
			(sleep (game_ticks_from_seconds r_enc7_7_shoot_timing_seconds))
			(cs_shoot_point true ps_enc7_7_shoot/p1)
			(sleep s_enc7_7_shoot_on_ticks)
			(cs_shoot_point false ps_enc7_7_shoot/p1)
			(sleep (game_ticks_from_seconds r_enc7_7_shoot_timing_seconds))
			(cs_shoot_point true ps_enc7_7_shoot/p2)
			(sleep s_enc7_7_shoot_on_ticks)
			(cs_shoot_point false ps_enc7_7_shoot/p2)
			(sleep (game_ticks_from_seconds r_enc7_7_shoot_timing_seconds))
			(cs_shoot_point true ps_enc7_7_shoot/p3)
			(sleep s_enc7_7_shoot_on_ticks)
			(cs_shoot_point false ps_enc7_7_shoot/p3)
			(sleep (game_ticks_from_seconds r_enc7_7_shoot_timing_seconds))
			(cs_shoot_point true ps_enc7_7_shoot/p4)
			(sleep s_enc7_7_shoot_on_ticks)
			(cs_shoot_point false ps_enc7_7_shoot/p4)
			(sleep (game_ticks_from_seconds r_enc7_7_shoot_timing_seconds))

			(cs_shoot true)
			(sleep (game_ticks_from_seconds 15.0))

			false
		)
		1
	)
)

(script dormant hangar_approach_explosions
	(sleep_until (volume_test_players tv_enc7_1) 1)

	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_hangar_approach_exp0)
	(sleep (game_ticks_from_seconds 1))

	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_hangar_approach_exp1)
	(sleep (game_ticks_from_seconds 1))

	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_hangar_approach_exp2)
	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_hangar_approach_exp3)
	(sleep (game_ticks_from_seconds 1))

	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_hangar_approach_exp4)
	(effect_new "objects\levels\shared\fx\stub_effect\stub_effect" fl_hangar_approach_exp5)
)

(script dormant get_aboard_trigger
	(sleep_until (volume_test_players tv_get_aboard) 1)
	; players who have not yet made the jump, should get to enjoy the final moments
	(volume_teleport_players_not_inside tv_coop_04_final fl_coop_04_final)
	(set b_race_over true)
	(ai_disposable gr_enc7_0_flood true)
	(wake dialogue_get_aboard)
	(wake kill_all_beat_7)

	(sleep_until (volume_test_players tv_grand_finale) 1)

	; success!
	(set b_player_longsword true)
	(timer_show false)

	(submit_incident_with_custom_string_id "game_activity_end_completed" "d40")

	(if (= (game_difficulty_get_real) legendary)
		(f_play_cinematic cinematics\d40\d40_outro_legend.cinematic)
		(f_play_cinematic cinematics\d40\d40_outro.cinematic)
	)

	(credits_interval)
	(f_play_cinematic cinematics\d40\credits.cinematic)
	(credits_interval)
	(f_play_cinematic cinematics\d40\credits_post.cinematic)
	(game_won)
)

(script static void credits_interval
	(fade_out 0 0 0 0)
	(sleep (game_ticks_from_seconds 0.5))
)

(script dormant kill_all_beat_7
	(sleep_until (volume_test_players tv_grand_finale) 1)
	(print "kill_all_beat_7")
	(ai_erase_all)
)

(script dormant nav_wart_run
	(sleep_until
		(begin
			(cond
				((volume_test_players tv_enc6_0_1) (f_exclusive_blip_flag fl_wart_run_0 0))
				((volume_test_players tv_act_wart_run_1) (f_exclusive_blip_flag fl_wart_run_1 0))
				((volume_test_players tv_act_wart_run_2) (f_exclusive_blip_flag fl_wart_run_2 0))
				((volume_test_players tv_act_wart_run_3) (f_exclusive_blip_flag fl_wart_run_3 0))
				((volume_test_players tv_act_wart_run_4) (f_exclusive_blip_flag fl_wart_run_4 0))
				((volume_test_players tv_act_wart_run_5) (f_exclusive_blip_flag fl_wart_run_5_foehammer 0))
			)

			(or
				(volume_test_players tv_act_wart_run_6)
				b_foehammer_crash_complete
			) ; exit contidion timed to dialog or player positioning
		)
		1 ; delay
	)
	(f_exclusive_blip_flag fl_wart_run_6 0)
	(sleep_until
		(begin
			(cond
				((volume_test_players tv_act_wart_run_6) (f_exclusive_blip_flag fl_wart_run_6 0))
				((volume_test_players tv_act_wart_run_7) (f_exclusive_blip_flag fl_wart_run_7 0))
				((volume_test_players tv_act_wart_run_8) (f_exclusive_blip_flag fl_wart_run_8 0))
			)

			false ; never end
		)
		1
	)
)

;==================================================================================================================
; utils
;==================================================================================================================
(script static short (f_exhaust_alive)
	(+
		(if (<= (object_get_health engine_exhaust_1) 0) 0 1)
		(if (<= (object_get_health engine_exhaust_2) 0) 0 1)
		(if (<= (object_get_health engine_exhaust_3) 0) 0 1)
		(if (<= (object_get_health engine_exhaust_4) 0) 0 1)
	)
)

(script static short (f_exhaust_killed)
	(- 4 (f_exhaust_alive))
)

; sets power and adds flag for if the exhaust port has power
(script static boolean (f_try_power_piston_control (device switch) (object exhaust_port) (cutscene_flag flag))
	(if (> (object_get_health exhaust_port) 0)
		(begin
			(device_set_power switch 1)
			(f_blip_object switch 0)
		)
	)
	(> (object_get_health exhaust_port) 0)
)


; a script for exclusive blipping a flag, used for generic level progression
(global cutscene_flag fl_last_blip_flag fl_none)

(script static void (f_exclusive_blip_flag (cutscene_flag fl) (short type))
	(if (!= fl_last_blip_flag fl)
		(begin
			(f_unblip_flag fl_last_blip_flag)
			(f_blip_flag fl type)
			(set fl_last_blip_flag fl)
		)
	)
)

(script static void f_exclusive_blip_flag_clear
	(if (!= fl_last_blip_flag fl_none)
		(begin
			(f_unblip_flag fl_last_blip_flag)
			(set fl_last_blip_flag fl_none)
		)
	)
)

;====================================================================================================================================================================================================
; flavor scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
; flavor scripts are rumbles, explosions etc - one-off things with no implication for gameplay
;====================================================================================================================================================================================================
; player_effects
;====================================================================================================================================================================================================

(script static void pe_camera_shake_s
	(print "camera shake")
	(player_effect_set_max_translation .01 .0025 .015)
	(player_effect_set_max_rotation 0.25 1 1)
	(player_effect_start 1 0)
	;todo - replace this with an appropriate audio asset reference
	(print "missing audio call")
	(player_effect_stop 1)
 )

 (script static void pe_camera_shake_m
	(print "missing audio call")
	(player_effect_set_max_translation .06 .02 .12)
	(player_effect_set_max_rotation 2 5 5)
	(player_effect_start 1 0)
	;todo - replace this with an appropriate audio asset reference
	(print "missing audio call")
	(player_effect_stop 1)
 )

 (script static void pe_camera_shake_l
 	(print "missing audio call")
	(player_effect_set_max_translation .12 .04 .24)
	(player_effect_set_max_rotation 4 8 8)
	(player_effect_start 1 0)
	;todo - replace this with an appropriate audio asset reference
	(print "missing audio call")
	(player_effect_stop 1)
 )

(script static void (f_random_explosion
						(point_reference points)
						(real delay_min)
						(real delay_max)
					)
	(effect_new_random "fx/explosions/common/explo_unsc_hor_lrg" points)
	(sleep (game_ticks_from_seconds (real_random_range delay_min delay_max)))
)

(script static void (f_random_explosions_endless
						(trigger_volume trigger)
						(point_reference points)
						(real delay_min)
						(real delay_max)
					)
	; loop for player
	(sleep_until
		(begin
			(sleep_until (volume_test_players trigger) 1)

			(f_random_explosion points delay_min delay_max)

			false ; repeat
		)
		1
	)
)

(script dormant whr_explo_1_endless
	(sleep (game_ticks_from_seconds 6))
	(f_random_explosions_endless tv_whr_explo_1 ps_whr_explo_1 0.5 2.0)
)

(script dormant whr_explo_2_endless
	(sleep (game_ticks_from_seconds 6))
	(f_random_explosions_endless tv_whr_explo_2 ps_whr_explo_2 0.5 2.0)
)

(script dormant exterior_explo_1
	(sleep_until (volume_test_players tv_exterior_explo_1) 1)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_1)
	(sleep (game_ticks_from_seconds 0.23))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_1b)
	(wake whr_explo_1_endless)

	(sleep_until (volume_test_players tv_exterior_explo_2) 1)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_2b)
	(sleep (game_ticks_from_seconds 0.13))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_2a)
	(sleep (game_ticks_from_seconds 1.17))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_2c)
	(sleep (game_ticks_from_seconds 1.33))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_2d)
	(wake whr_explo_2_endless)

	(sleep_until (volume_test_players tv_exterior_explo_3) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_3)
	(sleep (game_ticks_from_seconds 0.2))
	(pe_camera_shake_l)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_exterior_explo_3b)
	(sleep (game_ticks_from_seconds 1.67))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_3c)

	(sleep_until (volume_test_players tv_exterior_explo_4) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_4)

	(sleep_until (volume_test_players tv_exterior_explo_5) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_5)
	(sleep (game_ticks_from_seconds 0.17))
	(pe_camera_shake_l)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_exterior_explo_5b)
	(sleep (game_ticks_from_seconds 1.17))
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_exterior_explo_5c)
	(sleep (game_ticks_from_seconds 0.33))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_exterior_explo_5d)

)

;first volume that starts the post foehammerdeath explosions
(script dormant whr_explos_fh_1
 	(sleep_until (volume_test_players tv_whr_explo_fh_1) 1)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_1)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_11)
	(sleep (game_ticks_from_seconds 0.4))
	(effect_new "fx/explosions/common/explo_unsc_vert_med" fl_whr_explo_fh_5)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_6)
	(sleep (game_ticks_from_seconds 0.4))
	(effect_new "fx/explosions/common/explo_unsc_vert_med" fl_whr_explo_fh_2)
	(sleep (game_ticks_from_seconds 0.6))
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_3)
	(sleep (game_ticks_from_seconds 0.3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_4)
	(sleep (game_ticks_from_seconds 1.0))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_7)
	(sleep (game_ticks_from_seconds 1.4))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_8)
	(sleep (game_ticks_from_seconds 1.0))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_9)
	;wake the next explo sequence and the special jumps in the room
	(wake whr_explos_fh_2)
	(wake whr_explos_fh_3)
	(wake whr_explos_fh_22)


)

;this is the volume that triggers the first room mid entry explosions
(script dormant whr_explos_fh_22

 	(sleep_until (volume_test_players tv_whr_explo_fh_22) 1)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_154)
	(sleep (game_ticks_from_seconds 0.6))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_155)
	(sleep (game_ticks_from_seconds 0.6))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_156)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_157)
)


;this is the volume that triggers the first room mid explosions
(script dormant whr_explos_fh_2

 	(sleep_until (volume_test_players tv_whr_explo_fh_2) 1)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_12)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_13)
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_109)
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_111)
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_115)
	(sleep (game_ticks_from_seconds 0.4))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_14)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_15)
	(sleep (game_ticks_from_seconds 0.4))
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_16)
	(sleep (game_ticks_from_seconds 0.6))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_17)
	(sleep (game_ticks_from_seconds 0.3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_18)
	;wake the next explo sequence
	(wake whr_explos_fh_4)
	(wake whr_explos_fh_21)
	(wake whr_explos_fh_23)
)

;this is the volume that triggers the small steam ramp
(script dormant whr_explos_fh_23

 	(sleep_until (volume_test_players tv_whr_explo_fh_23) 1)
	(effect_new "fx/vignettes/d40/steam_unsc_burst_sml" fl_whr_explo_fh_107)
)

;this is the volume that triggers the first room exit explosions
(script dormant whr_explos_fh_21

 	(sleep_until (volume_test_players tv_whr_explo_fh_21) 1)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_152)
	(sleep (game_ticks_from_seconds 0.6))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_153)
	(effect_new "fx/vignettes/d40/spark_unsc_falling" fl_whr_explo_fh_151)
)

;this a special explosion on the middle jump
(script dormant whr_explos_fh_3

 	(sleep_until (volume_test_players tv_whr_explo_fh_3) 1)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_19)
)

;explos for hallway a enter
(script dormant whr_explos_fh_4

 	(sleep_until (volume_test_players tv_whr_explo_fh_4) 1)
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_121)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_21)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_20)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_106)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_22)
	(sleep (game_ticks_from_seconds 0.6))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_23)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_24)

	;wake the next explo sequence
	(wake whr_explos_fh_5)
)

;explos for hallway a sec b
(script dormant whr_explos_fh_5

 	(sleep_until (volume_test_players tv_whr_explo_fh_5) 1)
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_160)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_25)
	(pe_camera_shake_m)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_26)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_160)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_27)
	(sleep (game_ticks_from_seconds 0.6))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_28)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_29)

	;wake the next explo sequence and tunnel
	(wake whr_explos_fh_6)
	(wake whr_explos_fh_20)
)

;explos for hallway a sec c
(script dormant whr_explos_fh_6

 	(sleep_until (volume_test_players tv_whr_explo_fh_6) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_30)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_31)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_33)
	(sleep (game_ticks_from_seconds .5))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_34)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_32)

	;wake the next explo sequence
	(wake whr_explos_fh_7)

)

;explos for hallway a tunnel
(script dormant whr_explos_fh_20

	(sleep_until (volume_test_players tv_whr_explo_fh_20) 1)
	(effect_new "fx/vignettes/d40/spark_unsc_burst" fl_whr_explo_fh_145)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_148)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_149)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_146)
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_150)
	(sleep (game_ticks_from_seconds .3))

	;wake the next explo sequence
	(wake whr_explos_fh_7)
	(wake whr_explos_fh_8)
)

;explos for hallway a sec d
(script dormant whr_explos_fh_7

 	(sleep_until (volume_test_players tv_whr_explo_fh_7) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_35)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_36)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_37)

	;wake the next explo sequence
	(wake whr_explos_fh_8)
)

;explos for broken opening enter
(script dormant whr_explos_fh_8

 	(sleep_until (volume_test_players tv_whr_explo_fh_8) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_38)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/vignettes/d40/spark_unsc_falling" fl_whr_explo_fh_147)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_39)
	(sleep (game_ticks_from_seconds .4))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_42)
	(sleep (game_ticks_from_seconds .2))
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_40)
	(sleep (game_ticks_from_seconds .5))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_41)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_43)
	(sleep (game_ticks_from_seconds .4))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_44)

	;wake the next explo sequence
	(wake whr_explos_fh_9)
)

;explos for runway big jump
(script dormant whr_explos_fh_9

 	(sleep_until (volume_test_players tv_whr_explo_fh_9) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_45)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_52)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_53)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_46)
	(sleep (game_ticks_from_seconds 1))
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_47)
	(effect_new "fx/vignettes/d40/spark_unsc_falling" fl_whr_explo_fh_147)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_48)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_44)
	(sleep (game_ticks_from_seconds 1))
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_49)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_54)
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_91)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_55)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_56)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_57)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_58)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_60)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_55)
	(sleep (game_ticks_from_seconds .2))
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_50)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_51)

	;wake the next explo sequence
	(wake whr_explos_fh_10)
)

;explos for big jump
(script dormant whr_explos_fh_10

 	(sleep_until (volume_test_players tv_whr_explo_fh_10) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_61)
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_62)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_65)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_68)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_64)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_67)
	(sleep (game_ticks_from_seconds .5))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_63)
	(sleep (game_ticks_from_seconds .6))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_66)


	;wake the next explo sequence
	(wake whr_explos_fh_11)
)

;explos for big jump gap
(script dormant whr_explos_fh_11

 	(sleep_until (volume_test_players tv_whr_explo_fh_11) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_69)
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_70)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_71)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_72)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_73)


	;wake the next explo sequence
	(wake whr_explos_fh_12)
)

;explos for hallway b enter
(script dormant whr_explos_fh_12

 	(sleep_until (volume_test_players tv_whr_explo_fh_12) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_74)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_75)
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_85)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_76)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_77)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_78)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_79)
	(sleep (game_ticks_from_seconds .3))

	;wake the next explo sequence and the tunnel
	(wake whr_explos_fh_13)
	(wake whr_explos_fh_19)
)

;explos for hallway b sec b
(script dormant whr_explos_fh_13

 	(sleep_until (volume_test_players tv_whr_explo_fh_13) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_80)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds .7))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_81)
	(sleep (game_ticks_from_seconds .7))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_82)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds .5))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_83)

	;wake the next explo sequence
	(wake whr_explos_fh_14)
)

;explos for hallway b tunnel
(script dormant whr_explos_fh_19

	(sleep_until (volume_test_players tv_whr_explo_fh_19) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_138)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_139)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_137)
	(effect_new "fx/vignettes/d40/spark_unsc_burst" fl_whr_explo_fh_136)
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_140)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_141)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_142)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_143)

	;wake the next explo sequence
	(wake whr_explos_fh_15)
)

;explos for hallway b sec c
(script dormant whr_explos_fh_14

 	(sleep_until (volume_test_players tv_whr_explo_fh_14) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_84)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_87)
	(sleep (game_ticks_from_seconds .25))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_89)
	(pe_camera_shake_s)

	;wake the next explo sequence
	(wake whr_explos_fh_15)
)

;explos for hallway b sec d
(script dormant whr_explos_fh_15

 	(sleep_until (volume_test_players tv_whr_explo_fh_15) 1)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_90)
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_103)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_102)
	(effect_new "fx/vignettes/d40/spark_unsc_burst" fl_whr_explo_fh_136)
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_96)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_97)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_98)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_99)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_100)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_101)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_92)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds .7))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_93)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_94)
	(pe_camera_shake_s)

	;wake the next explo sequence
	(wake whr_explos_fh_16)
)

;explos for final tunnel enter
(script dormant whr_explos_fh_16

 	(sleep_until (volume_test_players tv_whr_explo_fh_16) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_105)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_108)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_120)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_110)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_112)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_113)
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_114)
	(pe_camera_shake_s)

	;wake the next explo sequence
	(wake whr_explos_fh_17)
)

;explos for final tunnel exit
(script dormant whr_explos_fh_17

 	(sleep_until (volume_test_players tv_whr_explo_fh_17) 1)

	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_116)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_122)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds .3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_123)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_118)
	(effect_new "fx/vignettes/d40/steam_unsc_burst" fl_whr_explo_fh_158)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_119)
	(sleep (game_ticks_from_seconds .1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_125)
	(sleep (game_ticks_from_seconds .2))
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_126)
	(sleep (game_ticks_from_seconds .2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_fh_127)

	;wake the next explo sequence
	(wake whr_explos_fh_18)
)

;explos for longsword room
(script dormant whr_explos_fh_18

 	(sleep_until (volume_test_players tv_whr_explo_fh_18) 1)
	(sleep (game_ticks_from_seconds .6))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_128)
	(sleep (game_ticks_from_seconds .8))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_129)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_131)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_132)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_133)
	(sleep (game_ticks_from_seconds 3))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_134)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_135)
	(sleep (game_ticks_from_seconds .6))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_128)
	(sleep (game_ticks_from_seconds .8))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_129)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_131)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_132)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_133)
	(sleep (game_ticks_from_seconds 3))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_134)
	(pe_camera_shake_s)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_135)
	(sleep (game_ticks_from_seconds .6))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_128)
	(sleep (game_ticks_from_seconds .8))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_129)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_131)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_132)
	(sleep (game_ticks_from_seconds 1))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_133)
	(sleep (game_ticks_from_seconds 3))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_134)
	(sleep (game_ticks_from_seconds 2))
	(effect_new "fx/explosions/common/explo_unsc_vert_lrg" fl_whr_explo_fh_135)
)


(script dormant whr_explos_end_1
 	(sleep_until (volume_test_players tv_whr_explo_end_1) 1)
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_2)
	(sleep (game_ticks_from_seconds 1.0))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_3)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_5)
	(sleep (game_ticks_from_seconds 1.0))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_6)
	(sleep (game_ticks_from_seconds 0.35))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_7)
	(sleep_until (volume_test_players tv_whr_explo_end_2) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_tun1)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_tun2)
	(sleep (game_ticks_from_seconds 0.4))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_tun3)

	(sleep_until (volume_test_players tv_whr_explo_end_3) 1)
	;(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_tun4)
	;(sleep (game_ticks_from_seconds 0.3))
	;(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_tun5)
	(sleep (game_ticks_from_seconds 0.75))
	(pe_camera_shake_s)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_tun6)

	(sleep_until (volume_test_players tv_whr_explo_end_4) 1)
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_z_1)
	(sleep (game_ticks_from_seconds 0.1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_z_2)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_z_3)
	(sleep (game_ticks_from_seconds 1.0))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_z_4)
	(sleep (game_ticks_from_seconds 0.2))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_z_5)
	(sleep (game_ticks_from_seconds 0.1))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_z_6)
	(sleep (game_ticks_from_seconds 0.3))
	(effect_new "fx/explosions/common/explo_unsc_hor_lrg" fl_whr_explo_end_z_7)

)