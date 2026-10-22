(global short s_split_dir 0)
(global short s_library_progress 0)
; these two variables are the communication layer between encounters and the monitor.
(global boolean b_343_away false) ; set by the monitor scripts
(global boolean b_door_fight_cleared false) ; set by encounters scripts
(global ai ai_monitor none)
(global real r_flood_tank_elevator_attack 0.3) ; what position does the elevator go to for flood tank to attack on elevator_2
(global long l_time_point 0) ; for testing

; door vignette position values
(global real r_door_try_1_dm_pos 0.25) ; -> sleep for r_door_try_1_delay
(global real r_door_fail_dm_pos 0.50) ; -> sleep r_door_fail_delay

(global real r_door_try_2_dm_pos 0.75) ; -> sleep r_door_try_2_delay
(global real r_door_open_dm_pos 1) ; -> sleep r_door_open_delay
; door vignette 343 delay times
(global real r_door_try_1_delay 3.0)
(global real r_door_fail_delay 2.0)

(global real r_door_try_2_delay 3.0)
(global real r_door_open_delay 2.0)

(global user_interface_objective uio_cur_obj obj_c20_follow)

(global boolean b_opening_final_door false)

;====================================================================================================================================================================================================
; c20 startup ==============================================================================================================================================
;====================================================================================================================================================================================================
(script startup c20_start
	(ai_allegiance player human)
	(ai_allegiance player sentinel)
	(ai_allegiance player guilty)
	(ai_allegiance flood guilty)
	(ai_allegiance sentinel guilty)
	(c20_insertion_point_fixups)
	(f_start_auto_save_loop)

	; music
	(wake c20_music_controller)

	(if
		(f_insertion_point_matches insertion_floor1_start)
		(begin
			(set s_music_trigger_c20 10)
			(f_play_cinematic cinematics\c20\c20_intro.cinematic)
			(wake c20_beat1)
		)
	)
	(if (f_insertion_point_matches insertion_floor1_middle) (wake c20_beat1))
	(if (f_insertion_point_matches insertion_floor1_lift) (wake c20_beat1))
	(if (f_insertion_point_matches insertion_floor2_start) (wake c20_beat2))
	(if (f_insertion_point_matches insertion_floor2_middle) (wake c20_beat2))
	(if (f_insertion_point_matches insertion_floor2_lift) (wake c20_beat2))
	(if (f_insertion_point_matches insertion_floor3_start) (wake c20_beat3))
	(if (f_insertion_point_matches insertion_floor3_arena) (wake c20_beat3))
	(if (f_insertion_point_matches insertion_floor3_lift) (wake c20_beat3))
	(if (f_insertion_point_matches insertion_floor4_start) (wake c20_beat4))
)

; floor 1
(script dormant c20_beat1
	; unlock progress data
	(submit_incident "ins_c20_floor1_start")
	(submit_incident_with_custom_string_id "game_activity_begin" "c20")
	(submit_incident "unlock_c20")
	; flow
	(wake mission_start)
	(wake reached_service_tunnel)
	(wake lift_1_logic)
	(wake disable_post_elevator_1_set)
	(wake beat_1_end)
	; monitor
	(wake 343_start_to_shaft)
	(wake 343_shaft_present)
	(wake 343_library_a)
	(wake 343_middle_sec_door)
	(wake 343_broken_door)
	(wake 343_sentinel_intro)
	; encounters
	(wake library_a_init)
	(wake library_a_door)
	(wake library_a_twists)
	(wake library_a_fin)
	(wake middle_sec_door)
	(wake carrier_intro)
	(wake tunnel)
	(wake sentinel_intro)

	;narrative
	(wake vo_floor1_intro_trigger)
	(wake vo_floor1_centercorridor1_trigger)
	(wake vo_floor1_intro_dawdle_trigger)
	(wake vo_floor1_librarya_first_encounter)
	(wake vo_floor1_librarya_breaking_door_vignette)
	(wake vo_floor1_carrier_trigger)
	(wake vo_floor1_librarya_door)
	(wake vo_floor1_middle_door)
	(wake vo_floor1_smallroomb_trigger)
	(wake vo_floor1_sentinel_intro_trigger)
	(wake vo_floor1_lift_trigger)

	; hacks to fix old stuff
	;(object_set_phantom_power door_floor_1_left_control false) ; disables left door at start of level

	;nav points
	(wake floor_1_library_a_nav_control)
	(wake floor_1_to_lift_a_nav_control)
)

; beat kill scripts are to make debuging easier. if a beat leaves a script off the kill list it won't break player flow.
(script dormant c20_beat1_kill
	(sleep_forever mission_start)
	(sleep_forever reached_service_tunnel)
	(sleep_forever lift_1_logic)
	(sleep_forever disable_post_elevator_1_set)
	(sleep_forever 343_start_to_shaft)
	(sleep_forever 343_shaft_present)
	(sleep_forever 343_library_a)
	(sleep_forever 343_middle_sec_door)
	(sleep_forever 343_broken_door)
	(sleep_forever 343_sentinel_intro)
	(sleep_forever library_a_init)
	(sleep_forever library_a_door)
	(sleep_forever library_a_twists)
	(sleep_forever library_a_fin)
	(sleep_forever middle_sec_door)
	(sleep_forever carrier_intro)
	(sleep_forever tunnel)
	(sleep_forever sentinel_intro)
	; narrative
	(sleep_forever vo_floor1_intro_trigger)
	(sleep_forever vo_floor1_centercorridor1_trigger)
	(sleep_forever vo_floor1_intro_dawdle_trigger)
	(sleep_forever vo_floor1_librarya_first_encounter)
	(sleep_forever vo_floor1_librarya_breaking_door_vignette)
	(sleep_forever vo_floor1_carrier_trigger)
	(sleep_forever vo_floor1_librarya_door)
	(sleep_forever vo_floor1_middle_door)
	(sleep_forever vo_floor1_smallroomb_trigger)
	(sleep_forever vo_floor1_sentinel_intro_trigger)
	(sleep_forever vo_floor1_lift_trigger)
)

; floor 2
(script dormant c20_beat2
	(wake c20_beat1_kill)
	; unlock progress data
	(submit_incident "ins_c20_floor2_start")
	(submit_incident_with_custom_string_id "game_activity_begin" "c20")
	(submit_incident "unlock_c20")
	; flow
	(wake lift_2_logic)
	(wake disable_floor_2b_set)
	(wake f2_light_bridge_obj_complete)
	(wake chapter_4_display)
	(wake beat_2_end)
	; monitor
	(wake 343_hallway_b)
	(wake 343_lib_cd_controller)
	(wake 343_to_small_room_c)
	(wake 343_large_room_a)
	(wake 343_lift2)
	; vignettes
	(wake f2_vignette_infector_well)
	; encounters
	(wake f2_lhallway_b_enc)
	(wake f2_lhallway_b_enc_left_vent_init)
	(wake f2_lhallway_b_enc_right_vent_init)
	(wake f2_lhallway_b_enc_clock_side_int)
	(wake f2_lhallway_b_enc_counter_side_int)
	(wake f2_lhallwayb_sec_door_init)
	(wake f2_lib_d_enc_init)
	(wake f2_lib_d_1st_breakin_door)
	(wake f2_lib_d_enc_midway_init)
	(wake f2_lib_d_enc_midway_init)
	(wake tank_intro)
	(wake f2_center_east_enc)
	(wake f2_center_east_sec_door)
	(wake f2_lrooma_enc_init)
	(wake f2_sroomd_enc_init)
	(wake f2_tank_elevator_enc_init)

	;narrative/music
	(wake c20_music_triggers_beat2)
	(wake vo_floor2_intro)
	(wake vo_floor2_hallwayb_door_trigger)
	(wake vo_floor2_reclaimer_intro)
	(wake vo_floor2_reclaimer_trigger)
	(wake vo_floor2_libraryd)
	(wake vo_floor2_pureform_trigger)
	(wake vo_floor2_libraryd_exit)
	(wake vo_floor2_centercorridorb_door)
	(wake vo_floor2_smallroomc_trigger)
	(wake vo_floor2_lift)

	;nav points
	(wake floor_2_to_library_d_nav_control)
	(wake floor_2_library_d_nav_control)
	(wake floor_2_end_library_d_to_lift_b)
)

; beat kill scripts are to make debuging easier. if a beat leaves a script off the kill list it won't break player flow.
(script dormant c20_beat2_kill
	; flow
	(sleep_forever lift_2_logic)
	(sleep_forever disable_floor_2b_set)
	(sleep_forever f2_light_bridge_obj_complete)
	(sleep_forever chapter_4_display)
	(sleep_forever beat_2_end)
	; monitor
	(sleep_forever 343_hallway_b)
	(sleep_forever 343_lib_cd_controller)
	(sleep_forever 343_to_small_room_c)
	(sleep_forever 343_large_room_a)
	(sleep_forever 343_lift2)

	; vignettes
	(sleep_forever f2_vignette_infector_well)
	; encounters
	(sleep_forever f2_lhallway_b_enc)
	(sleep_forever f2_lhallway_b_enc_left_vent_init)
	(sleep_forever f2_lhallway_b_enc_right_vent_init)
	(sleep_forever f2_lhallway_b_enc_clock_side_int)
	(sleep_forever f2_lhallway_b_enc_counter_side_int)
	(sleep_forever f2_lhallwayb_sec_door_init)
	(sleep_forever f2_lib_d_enc_init)
	(sleep_forever f2_lib_d_1st_breakin_door)
	(sleep_forever f2_lib_d_enc_midway_init)
	(sleep_forever tank_intro)
	(sleep_forever f2_center_east_enc)
	(sleep_forever f2_center_east_sec_door)
	(sleep_forever f2_lrooma_enc_init)
	(sleep_forever f2_sroomd_enc_init)
	(sleep_forever f2_tank_elevator_enc_init)
	; music/narrative
	(sleep_forever c20_music_triggers_beat2)
	(sleep_forever vo_floor2_intro)
	(sleep_forever vo_floor2_hallwayb_door_trigger)
	(sleep_forever vo_floor2_reclaimer_intro)
	(sleep_forever vo_floor2_reclaimer_trigger)
	(sleep_forever vo_floor2_libraryd)
	(sleep_forever vo_floor2_pureform_trigger)
	(sleep_forever vo_floor2_libraryd_exit)
	(sleep_forever vo_floor2_centercorridorb_door)
	(sleep_forever vo_floor2_smallroomc_trigger)
)

; floor 3
(script dormant c20_beat3
	; unlock progress data
	(submit_incident "ins_c20_floor3_start")
	(submit_incident_with_custom_string_id "game_activity_begin" "c20")
	(submit_incident "unlock_c20")
	; flow
	(wake lift_3_logic)
	(wake disable_floor_3b_set)
	(wake f3_light_bridge_done)
	(wake beat_3_end)
	; monitor
	(wake c20_beat2_kill)
	(wake 343_floor_3_intro)
	(wake 343_large_hall)
	(wake 343_jump_door)
	(wake 343_library_e)
	(wake 343_large_room_b)
	(wake 343_to_lift3)
	(wake 343_beat_3_outro)
	; vignettes
	(wake vignette_large_hall_c)
	(wake vignette_jump_scare)
	; encounters
	(wake flood_pre_sent_fight)
	(wake flood_sent_fight)
	(wake large_hall_tank_attack)
	(wake large_hall_end)
	(wake library_f_a)
	(wake library_f_door)
	(wake library_f_b)
	(wake security_door_3)
	(wake light_bridges)
	(wake stealth_ambush)

	;narrative/music
	(wake c20_music_triggers_beat3)
	(wake vo_floor3_intro)
	(wake vo_floor3_hallway)
	(wake vo_floor3_jump_scare)
	(wake vo_floor3_centercorridorc)
	(wake vo_floor3_door_trigger)
	(wake vo_floor3_door_returns)
	(wake vo_floor3_largeroomb_start)
	(wake vo_floor3_largeroomb_end_trigger)
	(wake vo_floor3_largehallwayd)
	(wake vo_floor3_outro)

	;nav points
	(wake floor_3_lift_b_to_library_f_nav_control)
	(wake floor_3_library_f_nav_control)
	(wake floor_3_largeroom_b_to_lift_a_nav_control)
)

; beat kill scripts are to make debuging easier. if a beat leaves a script off the kill list it won't break player flow.
(script dormant c20_beat3_kill
	; flow
	(sleep_forever lift_3_logic)
	(sleep_forever disable_floor_3b_set)
	(sleep_forever f3_light_bridge_done)
	(sleep_forever beat_3_end)
	; monitor
	(sleep_forever c20_beat2_kill)
	(sleep_forever 343_floor_3_intro)
	(sleep_forever 343_large_hall)
	(sleep_forever 343_jump_door)
	(sleep_forever 343_library_e)
	(sleep_forever 343_large_room_b)
	(sleep_forever 343_to_lift3)
	(sleep_forever 343_beat_3_outro)
	; vignettes
	(sleep_forever vignette_large_hall_c)
	(sleep_forever vignette_jump_scare)
	; encounters
	(sleep_forever flood_pre_sent_fight)
	(sleep_forever flood_sent_fight)
	(sleep_forever large_hall_tank_attack)
	(sleep_forever large_hall_end)
	(sleep_forever library_f_a)
	(sleep_forever library_f_door)
	(sleep_forever library_f_b)
	(sleep_forever security_door_3)
	(sleep_forever light_bridges)
	(sleep_forever stealth_ambush)
	; music/narrative
	(sleep_forever c20_music_triggers_beat3)
	(sleep_forever vo_floor3_intro)
	(sleep_forever vo_floor3_hallway)
	(sleep_forever vo_floor3_jump_scare)
	(sleep_forever vo_floor3_centercorridorc)
	(sleep_forever vo_floor3_door_trigger)
	(sleep_forever vo_floor3_door_returns)
	(sleep_forever vo_floor3_largeroomb_start)
	(sleep_forever vo_floor3_largeroomb_end_trigger)
	(sleep_forever vo_floor3_largehallwayd)
)

; floor 4
(script dormant c20_beat4
	(wake c20_beat3_kill)
	; flow
	(wake disable_floor_4_set)
	(wake final_chapter)
	(wake final_door)
	(wake energy_barrier)
	(wake c20_won)
	; monitor
	(wake 343_hallway_e)
	; enounters
	(wake large_hall_e_init)
	(wake large_hall_e_l)
	(wake large_hall_e_r)
	(wake beat_4_final)

	;narrative
	(wake vo_floor4_intro)
	(wake vo_floor4_hallway3_door)
	(wake vo_floor4_index)

	;nav points
	(wake floor_4_lift_a_to_centerroom_a_nav_control)
)

; blam complains if kill volumes are attached to a moving object
(script continuous prockill
	(sleep 1)
	(if (volume_test_object tv_prockill_volume_lift_1 player0) (unit_kill player0))
	(if (volume_test_object tv_prockill_volume_lift_1 player1) (unit_kill player1))
	(if (volume_test_object tv_prockill_volume_lift_1 player2) (unit_kill player2))
	(if (volume_test_object tv_prockill_volume_lift_1 player3) (unit_kill player3))
	(sleep 1)
	(if (volume_test_object tv_prockill_volume_lift_2 player0) (unit_kill player0))
	(if (volume_test_object tv_prockill_volume_lift_2 player1) (unit_kill player1))
	(if (volume_test_object tv_prockill_volume_lift_2 player2) (unit_kill player2))
	(if (volume_test_object tv_prockill_volume_lift_2 player3) (unit_kill player3))
	(sleep 1)
	(if (volume_test_object tv_prockill_volume_lift_3 player0) (unit_kill player0))
	(if (volume_test_object tv_prockill_volume_lift_3 player1) (unit_kill player1))
	(if (volume_test_object tv_prockill_volume_lift_3 player2) (unit_kill player2))
	(if (volume_test_object tv_prockill_volume_lift_3 player3) (unit_kill player3))
)


;====================================================================================================================================================================================================
; c20 beat 1 flow
;====================================================================================================================================================================================================
(script dormant mission_start
	(sleep_until (volume_test_players tv_act_mission_start) 1)
)


(script dormant reached_service_tunnel
	(sleep_until (volume_test_players tv_reached_service))
	(f_hud_obj_complete_noblock)
)

(script dormant lift_1_logic
	(sleep_until (volume_test_players tv_lift_1_start) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; top of lift 1
	(wake beat_1_outro_encounter)
	(wake beat_2_prep)
	(f_device_pendulum_logic elevator_1 tv_lift_1_start tv_lift_1_recall 0.3)
)

(script dormant disable_post_elevator_1_set
	(sleep_until (volume_test_players tv_lift_1_start) 1)
	(zone_set_trigger_volume_enable begin_zone_set:set_floor_2a false)
	(zone_set_trigger_volume_enable zone_set:set_floor_2a false)
)

; not in beat 1 script so that it has life across beats
(script dormant beat_1_end
	; (sleep_until (volume_test_players tv_act_sentinel_intro) 1)
	(sleep_until (>= (device_get_position elevator_1) 0.5) 1)
	(f_place_monitor sq_monitor/sp_f2_start)
	(wake c20_beat2)
)

;====================================================================================================================================================================================================
; c20 beat 1 encounters
;====================================================================================================================================================================================================
(script dormant library_a_init
;	(sleep_until (volume_test_players tv_act_lib_a_inf) 1)
;	(ai_place sq_f1_flood_start_inf) <<< moved to line 750 to trigger when the door opens
	(sleep_until (volume_test_players tv_act_library_a_init) 1)
	(ai_place sq_f1_flood_marine3_0)
	(sleep_until (volume_test_players tv_end_library_a_init) 1)
	(ai_disposable sq_f1_flood_start_inf true)
	(ai_disposable gr_library_a_init true)
)

(script dormant library_a_door
	(sleep_until (volume_test_players tv_act_library_a_door) 1)
	(set b_door_fight_cleared false)
	(ai_place gr_library_a_door_init)
	(f_flood_group_blip_gate gr_library_a_door_init)
	(sleep_until (<= (ai_nonswarm_count gr_library_a_door_init) 0) 1)
	(set b_door_fight_cleared true)
	(device_set_position f1_lib_a_breakin_door_device 1)
	(ai_place gr_library_a_door_burst)
	(set s_music_trigger_c20 30)
	(sleep_until (volume_test_players tv_end_library_a_door) 1)
	(ai_disposable gr_library_a_door true)
)

(script dormant library_a_twists
	(sleep_until (volume_test_players tv_act_library_a_twists) 1)
	(ai_place gr_library_a_twists)
	(sleep_until (volume_test_players tv_end_library_a_twists) 1)
	(ai_disposable gr_library_a_twists true)
)

(script dormant library_a_fin
	(sleep_until (volume_test_players tv_act_library_a_fin) 1)
	(ai_place gr_library_a_fin)
	(sleep_until (volume_test_players tv_end_library_a_fin) 1)
	(ai_disposable gr_library_a_fin true)
)

(script dormant middle_sec_door
	(sleep_until (volume_test_players tv_act_middle_entrance) 1)
	(set b_door_fight_cleared false)
	(sleep_until b_343_away 1)
	(set s_vo_progress_c20 22)
	(ai_place gr_middle_sec_door_init)
	(set s_music_trigger_c20 40)
	(sleep_until (<= (f_ai_living_weight_count gr_middle_sec_door) 1) 1)
	(ai_place gr_middle_sec_door_wave_2)
	(sleep_until (<= (f_ai_living_weight_count gr_middle_sec_door) 1) 1)
	(ai_place gr_middle_sec_door_wave_3)
	(if (game_is_cooperative)
		(begin
			(sleep_until (<= (f_ai_living_weight_count gr_middle_sec_door) 1) 1)
			(ai_place gr_middle_sec_door_wave_3)
		)
	)
	(f_flood_group_blip_gate gr_middle_sec_door)
	(sleep_until (<= (f_ai_living_weight_count gr_middle_sec_door) 0.7) 1)
	(set b_door_fight_cleared true)
	(set s_music_trigger_c20 50)
	(ai_disposable gr_middle_sec_door true) ; stragler infectionf forms
)

(script command_script cs_middle_sec_swarm_pipe
	(cs_swarm_to pts_middle_sec_infector_nav/p1 1)
)

(script command_script cs_middle_sec_swarm
	(cs_swarm_to pts_middle_sec_infector_nav/p0 1)
)

(script dormant carrier_intro
	(sleep_until (>= (device_get_position floor_1_middle_entrance_door) 0.75) 1)
	(ai_place gr_carrier_intro)
	(sleep_until (volume_test_players tv_end_carrier_intro) 1)
	(ai_disposable gr_carrier_intro true)
	; (ai_kill_silent gr_carrier_intro)
)

(script dormant tunnel
	(sleep_until (volume_test_players tv_act_tunnel) 1)
	(ai_place sq_carrier2_drop)
	(sleep_until (>= (device_get_position elevator_1) 0.25) 1)
	(ai_disposable sq_carrier2_drop true)
	; (ai_kill_silent sq_carrier2_drop)
)

(script dormant sentinel_intro
	(sleep_until (volume_test_players tv_act_sentinel_intro) 1)
	(ai_place gr_sentinel_intro)
	(if (game_is_cooperative)
		(begin
			(sleep (game_ticks_from_seconds 2))
			(ai_place gr_back)
		)
	)
	(sleep_until (>= (device_get_position elevator_1) 0.25) 1)
	(ai_disposable gr_sentinel_intro true)
	; (ai_kill_silent gr_sentinel_intro)
)

; this script straddles beat 1 and 2 so exists outside the normal activaiton pattern
(script dormant beat_1_outro_encounter
	(sleep_until (>= (device_get_position elevator_1) 0.20) 1)
	(ai_place gr_elevator_1_attack_1)
	(set s_music_trigger_c20 60)
	(sleep_until (>= (device_get_position elevator_1) 0.40) 1)
	(ai_place gr_elevator_1_attack_2)
	(sleep_until (>= (device_get_position elevator_1) 0.60) 1)
	(ai_place gr_elevator_1_attack_3)
	; (ai_place sq_f2_lhallb_ent_carriers) deactivated to give the player a breather
	(sleep_until (volume_test_players tv_end_elevator_1_attack) 1)
	(ai_disposable gr_elevator_1_attack true)
	; (ai_kill_silent gr_elevator_1_attack)
)

;====================================================================================================================================================================================================
; c20 beat 2 flow
;====================================================================================================================================================================================================
(script dormant beat_2_prep
	(sleep_until (>= (device_get_position elevator_1) 1) 1)
	(print "push co-op players beat_2_prep")
	(volume_teleport_players_not_inside tv_lift_1_coop_safe_bottom fl_coop_end_beat_1)
	(zone_set_trigger_volume_enable begin_zone_set:set_floor_2a true)
	(sleep (game_ticks_from_seconds 1))
	(zone_set_trigger_volume_enable zone_set:set_floor_2a true)
)

(script dormant disable_floor_2b_set
	(sleep_until (volume_test_players tv_act_tank_intro) 1)
	(zone_set_trigger_volume_enable begin_zone_set:set_floor_2b false)
	(zone_set_trigger_volume_enable zone_set:set_floor_2b false)
)

(script dormant beat_2_shutdown_mid
	(device_set_power floor_2_door_backfill 0)
	(sleep_until (<= (device_get_position floor_2_door_backfill) 0) 1)
	(print "push co-op players beat_2_shutdown_mid")
	(volume_teleport_players_not_inside tv_beat_2_shutdown_mid_safe fl_coop_beat_2_mid)
	(print "beat_2_shutdown_mid clear enemies now")
	(ai_disposable gr_f2_lib_d_room4 true)
	(ai_disposable gr_f2_libd_corridor1_enc1 true)
	(ai_disposable gr_f2_libd_corridor1_enc2 true)
	(ai_disposable gr_f2_libd_midway_room true)
	(ai_disposable gr_f2_lib_d_room3 true)
	(ai_disposable gr_lhallb_entrance true)
	(ai_disposable gr_f2_lhallb_side_vents true)
	(ai_disposable gr_f2_lhallb_sec_door true)
	(ai_disposable gr_f2_lhallb_entrance true)
	(zone_set_trigger_volume_enable begin_zone_set:set_floor_2b true)
	(sleep (game_ticks_from_seconds 1))
	(zone_set_trigger_volume_enable zone_set:set_floor_2b true)
)


(script dormant lift_2_logic
	(sleep_until (volume_test_players tv_act_lift2) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; lift 2
	(f_device_pendulum_logic elevator_2 tv_act_lift2 tv_lift2_recall (* r_flood_tank_elevator_attack 0.90)) ; giving a little buffer before the attack
)

(script dormant f2_light_bridge_obj_complete
	(sleep_until (>= (device_group_get light_bridge_c_group) 1) 1)
	; (sleep (game_ticks_from_seconds 2.0))
	(f_hud_obj_complete_noblock)
)

; chapter 4 appears at the transition between floor 2 and 3. names don't match player order
(script dormant chapter_4_display
	(sleep_until (volume_test_players tv_act_lift2) 1)
	(sleep_until (> (device_get_position elevator_2) 0) 1)
	(sleep (game_ticks_from_seconds 1))
	(f_hud_chapter chapter_c20_4)
)

(script dormant beat_2_end
	(sleep_until (volume_test_players tv_act_lift2) 1)
	(sleep_until (>= (device_get_position elevator_2) 0.5) 1)
	(print "beat 2 is done")
	(f_place_monitor sq_monitor/sp_f3_start)
	(wake c20_beat3)
)

;====================================================================================================================================================================================================
; c20 beat 2 vignettes
;====================================================================================================================================================================================================
; flood wall test
; hs:begin (f_vig_infectors)
(script static void f_test_vig_f2_infectors
	(device_set_position floor_2_stacks_entrance_door 1.0)
	(wake f2_vignette_infector_well)
)


(script dormant f2_vignette_infector_well
	(sleep_until (volume_test_players tv_hallway_b_rejoin) 1)
	(sleep_until (< 0.25 (device_get_position floor_2_stacks_entrance_door)) 1)
	(ai_place gr_vig_infectors_f2)
	(sleep_until (volume_test_players tv_f2_lib_d_entrance) 1)
	(ai_erase gr_vig_infectors_f2)
)

(script command_script cs_vig_infectors_0
	(print "cs_vig_infectors a")
	(cs_swarm_to pts_vig_infectors_0/p0 1)
	(print "cs_vig_infectors b")
	(cs_swarm_to pts_vig_infectors_0/p1 1)
	(print "cs_vig_infectors c")
	(ai_erase ai_current_actor)
)

(script command_script cs_vig_infectors_1
	(print "cs_vig_infectors a")
	(cs_swarm_to pts_vig_infectors_1/p0 1)
	(print "cs_vig_infectors b")
	(cs_swarm_to pts_vig_infectors_1/p1 1)
	(print "cs_vig_infectors c")
	(ai_erase ai_current_actor)
)


;====================================================================================================================================================================================================
; c20 beat 2 encounters
;====================================================================================================================================================================================================

; large hallway b: enemies right after the elevator
(script dormant f2_lhallway_b_enc
;	(ai_place gr_f2_lhallb_ent_center)
	(print "f2 large hallway b entrance spawning done")
)

; large hallway b: enemies emerging from vents to left of exiting elevator
(script dormant f2_lhallway_b_enc_left_vent_init
	(sleep_until (volume_test_players tv_f2_lhallb_clock1) 1)
	(ai_place gr_lhallb_ent_vent_left)
	(print "f2 large hallway b entrance left vent spawning done")
	(sleep_until (volume_test_players tv_f2_lhallb_cleanup) 1)
	(ai_erase gr_lhallb_ent_vent_left)
	(print "erase hallway b entrance left")
)

; large hallway b:enemies emerging from vents to right of exiting elevator
(script dormant f2_lhallway_b_enc_right_vent_init
	(sleep_until (volume_test_players tv_f2_lhallb_counter1) 1)
	(ai_place gr_lhallb_ent_vent_right)
	(print "f2 large hallway b entrance right vent spawning done")
	(sleep_until (volume_test_players tv_f2_lhallb_cleanup) 1)
	(ai_erase gr_lhallb_ent_vent_right)
	(print "erase hallway b entrance right")
)

; large hallway b: enemies down the clockwise side of the room
(script dormant f2_lhallway_b_enc_clock_side_int
	; the player can go left and/or right
	(sleep_until
		(or
			(volume_test_players tv_f2_lhallb_clock2)
			(volume_test_players tv_f2_lhallb_clock3)
		)
	1)
	(ai_place sq_lhallb_clockvent5_floodmar)
	(print "f2 large hallway b clockwise side spawning done")


	(sleep_until (volume_test_players tv_f2_lhallb_clock2) 1)

	(ai_place sq_lhallb_clockvent7_floodmar)
	(sleep (game_ticks_from_seconds 2))
	(ai_place sq_lhallb_clockvent8_floodmar)

	(sleep_until (volume_test_players tv_f2_lhallb_cleanup) 1)
	(ai_erase sq_lhallb_clockvent5_floodmar)
	(ai_erase sq_lhallb_clockvent7_floodmar)
	(ai_erase sq_lhallb_clockvent8_floodmar)
	(print "erase hallway b clockwise side")
)

; large hallway b: enemies down the counter-clockwise side of the room
(script dormant f2_lhallway_b_enc_counter_side_int
	; the player can go left and/or right
	(sleep_until
		(or
			(volume_test_players tv_f2_lhallb_counter2) ; tv_act_f2_lhallb_counter2
			(volume_test_players tv_f2_lhallb_counter3)
		)
	1)
	(ai_place sq_lhallb_countvent5_floodelite)
	(print "f2 large hallway b counter side spawning done")

	(sleep_until (volume_test_players tv_f2_lhallb_counter4) 1)

	(ai_place sq_lhallb_countvent7_floodelite)
	(sleep (game_ticks_from_seconds 2))
	(ai_place sq_lhallb_countvent8_floodelite)

	(sleep_until (volume_test_players tv_f2_lhallb_cleanup) 1)
	(ai_erase sq_lhallb_countvent5_floodelite)
	(ai_erase sq_lhallb_countvent7_floodelite)
	(ai_erase sq_lhallb_countvent8_floodelite)
	(print "erase hallway b counter side")
)

(script dormant f2_lhallwayb_sec_door_init
	(sleep_until (volume_test_players tv_hallway_door_b_op) 1)
	(print "f2 starting large hallway b security door encounter")
	(set b_door_fight_cleared false)
	(sleep_until b_343_away 1)
	;(breakpoint "f2_lhallwayb_sec_door_init a")
	(ai_place gr_f2_hallb_sec_door_wave1)
	(set s_music_trigger_c20 80)
	(ai_prefer_target_team sq_lhallb_sec_carrier_counter1 player)
	(print "gr_f2_hallb_sec_door_wave1 attack")
	(sleep_until (<= (f_ai_living_weight_count gr_f2_lhallb_sec_door_flood) 3) 1)
	(ai_place sq_f2_lhallb_sec_sentinels)
	(set s_vo_progress_c20 40)
	(sleep_until (<= (f_ai_living_weight_count gr_f2_lhallb_sec_door_flood) 2) 1)
	(ai_place gr_f2_hallb_sec_door_wave2)
	(ai_prefer_target_team sq_lhallb_sec_carrier_clock1 player)
	(ai_prefer_target_team sq_lhallb_sec_carrier_counter2 player)
	(print "gr_f2_hallb_sec_door_wave2 attack")
	(sleep_until (<= (f_ai_living_weight_count gr_f2_lhallb_sec_door_flood) 2) 1)
	(ai_place gr_f2_hallb_sec_door_wave3)
	(ai_prefer_target_team sq_lhallb_sec_carrier_clock2 player)
	(if (game_is_cooperative)
		(begin
			(sleep_until (<= (f_ai_living_weight_count gr_f2_lhallb_sec_door_flood) 2) 1)
			(ai_place gr_f2_hallb_sec_door_wave2)
			(ai_prefer_target_team sq_lhallb_sec_carrier_clock1 player)
			(ai_prefer_target_team sq_lhallb_sec_carrier_counter2 player)
		)
	)
	(print "gr_f2_hallb_sec_door_wave3 attack")
	(f_flood_group_blip_gate gr_f2_lhallb_sec_door_flood)
	(sleep_until (<= (f_ai_living_weight_count gr_f2_lhallb_sec_door_flood) 0.7) 1)
	(set b_door_fight_cleared true)
	;(breakpoint "f2_lhallwayb_sec_door_init b")
	(set s_music_trigger_c20 90)
	(sleep_until (volume_test_players tv_f2_secdoor_cleanup) 1)
	(ai_erase gr_f2_lhallb_sec_door)
	(print "erase hallway b sec door characters")
)

; enemies lib d corridor
(script dormant f2_lib_d_enc_init
	(sleep_until (= (device_group_get door_floor_2_right_group) 1) 1)
	(ai_place gr_f2_libd_corridor1_enc1)
	(print "f2 lib d start triggered")
	(sleep_until (volume_test_players tv_f2_lib_d_entrance) 1)
	(ai_place gr_f2_libd_corridor1_enc2)
	(sleep_until (volume_test_players tv_f2_libd_pt1_cleanup) 1)
	(ai_erase gr_f2_libd_corridor1_enc2)
	(print "erase library d start encounter")
)

; lib d room break in
(script dormant f2_lib_d_1st_breakin_door
	; (print "temp break in door ready")
	; (device_set_position f2_lib_d_1st_breakin_door_device 0)
	(sleep_until (volume_test_players tv_f2_lib_d_breakin_door) 1)
	(if (game_is_cooperative) (object_create_folder fold_coop_floor2_b))
	(sleep (game_ticks_from_seconds 1))
	(device_set_position f2_lib_d_1st_breakin_door_device 1)
	;(sleep_until (= (device_get_position f2_lib_d_1st_breakin_door_device) 1) 1)
	(print "f2 lib d break in door triggered")
	(ai_place sq_f2_lib_d_breakin_infect1)
	(sleep_until (volume_test_players tv_f2_libd_pt1_cleanup) 1)
	(ai_erase sq_f2_lib_d_breakin_infect1)
	(print "erase library d break in encounter")
)

; enemies lib d midway room
(script dormant f2_lib_d_enc_midway_init
	(sleep_until (volume_test_players tv_f2_lib_d_breakin_door) 1)
	(ai_place sq_f2_lib_d_mid_floodelite)
	(sleep_until (<= (ai_living_fraction sq_f2_lib_d_mid_floodelite) 0.70) 1)
	(ai_place sq_f2_lib_d_mid_floodelite2)
	(ai_place gr_f2_lib_d_room3)
	(print "f2 lib d midway room triggered")
	(sleep_until (volume_test_players tv_f2_libd_pt1_cleanup) 1)
	(ai_erase sq_f2_lib_d_mid_floodelite2)
	(ai_erase gr_f2_lib_d_room3)
	(print "erase library d midway encounter")
)


; lib d tank room / tank intro
(global boolean b_fight_option true)
(script dormant tank_intro
	(sleep_until (volume_test_players tv_act_pre_tank_intro) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; pre tank intro
	(print "play obj_dest_floodtank_banging-sound")
	(sound_impulse_start sound/levels/c20/obj_dest_floodtank_banging ss_tank_pre_intro 1) ;play sfx for flood pre-intro
	(ai_place sq_f2_lib_b_r4_floodmar)
	(sleep_until (volume_test_players tv_act_tank_intro) 1)
	(set b_door_fight_cleared false)
	(ai_place sq_f2_lib_d_r4_tank)
	(device_set_position_immediate dm_tank_spawn_fx_1 0.5) ; 0.5 default activation value for generic vignette machines
	(print "f2 lib d tank room tank triggered")
	(if (game_is_cooperative) (ai_place sq_f2_lib_b_r4_floodmar_co))
	(f_flood_group_blip_gate gr_f2_lib_d_room4)
	(sleep_until
		(begin
			(cond
				((and (not b_fight_option) (volume_test_players tv_tank_intro_inner)) (set b_fight_option true))
				((and b_fight_option (not (volume_test_players tv_tank_intro_outer))) (set b_fight_option false))
			)
			(<= (f_ai_living_weight_count gr_f2_lib_d_room4) 0)
		)
		1
	)
	(set b_door_fight_cleared true)
	(sleep (game_ticks_from_seconds 3))
	(device_set_position_immediate dm_tank_spawn_fx_1 1) ; put fx into finished state so they dont re-trigger on save/load
	(device_set_position f2_lib_d_2nd_breakin_door_device 1)
	(ai_place sq_f2_lib_d_breakin_infect2)
	(sleep_until (volume_test_players tv_end_f2_libd_2) 1)
	(ai_erase gr_f2_lib_d_room4)
	; (ai_erase sq_f2_lib_d_breakin_infect2)
	(print "erase library d tank encounter")
)

; hs:begin (f_test_tank_intro)
(script static void f_test_tank_intro
	(device_set_position_immediate dm_tank_spawn_fx_1 0)
	(sleep 1)
	(ai_place sq_f2_lib_d_r4_tank)
	(device_set_position_immediate dm_tank_spawn_fx_1 0.5)
)

; enemies center corridor east
(script dormant f2_center_east_enc
	(sleep_until (volume_test_players tv_act_tank_intro) 1)
	(sleep_until (= (device_get_position door_floor_2_rightb_control) 0) 1)
	(sleep_until (= (device_group_get door_floor_2_rightb_group) 1) 1)
	(ai_place sq_centeast_sec_floodmixed)
	(print "f2 center east encounter triggered")
	(sleep_until (volume_test_players tv_end_f2_libd_2) 1)
	(ai_erase sq_centeast_sec_floodmixed)
	(print "erase pre-sec door encounter")
)

; enemies for center corridor east security door
(script dormant f2_center_east_sec_door
	(sleep_until (volume_test_players tv_act_343_small_room) 1)
	; (print "f2_center_east_sec_door a")
	(set b_door_fight_cleared false)
	(sleep_until b_343_away 1)
	; (print "f2_center_east_sec_door b")
	(ai_place sq_centeast_sec_infector1)
	(set s_music_trigger_c20 130)
	(sleep (game_ticks_from_seconds 2))
	(ai_place sq_centeast_sec_floodmar1)
	(sleep_until (<= (f_ai_living_weight_count gr_f2_centeast_sec_door) 2) 1)
	; (print "f2_center_east_sec_door c")
	(ai_place gr_f2_centeast_sec_door_wave2)
	(sleep_until (<= (f_ai_living_weight_count gr_f2_centeast_sec_door) 2) 1)
	; (print "f2_center_east_sec_door d")
	(ai_place gr_f2_centeast_sec_door_wave3)
	(f_flood_group_blip_gate gr_f2_centeast_sec_door)
	(sleep_until (<= (f_ai_living_weight_count gr_f2_centeast_sec_door) 0.7) 1)
	(print "f2_center_east_sec_door complete")
	(set b_door_fight_cleared true)
	(set s_music_trigger_c20 140)
	(sleep_until (volume_test_players tv_end_f2_libd_2) 1)
	(ai_erase sq_centeast_sec_infector1)
	(ai_erase sq_centeast_sec_floodmar1)
	(ai_erase gr_f2_centeast_sec_door)
	(print "erase sec door encounter")
)

(script command_script f2_center_east_end_swarm
	(cs_swarm_to pts_infector_landing/p0 1)
)

; enemies large room a
(script dormant f2_lrooma_enc_init
	(sleep_until (volume_test_players tv_act_f2_lroom_a) 1)
	(wake f2_lrooma_pit_fill)
	(wake f2_lrooma_pit_release)
	(print "f2 large room a population triggered")
	(wake f2_lrooma_enc_a)
	(wake f2_lrooma_enc_b)
	(wake f2_lrooma_enc_c)
	(sleep_until (volume_test_players tv_end_f2_lroom_a) 1)
	(f_end_f2_lrooma)
)

(script static void f_end_f2_lrooma
	(sleep_forever f2_lrooma_enc_a)
	(sleep_forever f2_lrooma_enc_b)
	(sleep_forever f2_lrooma_enc_c)
	(sleep_forever f2_lrooma_pit_fill)
	(sleep_forever f2_lrooma_pit_release)
	(ai_erase gr_f2_lroom_a)
)

(script dormant f2_lrooma_enc_a
	(sleep_until (>= (device_group_get light_bridge_a_group) 1) 1)
	(print "f2 large room a light bridge a enc triggered")
	(ai_place sq_f2_lroom_a_floodmar0)
	; (device_set_position floor_2_middle_entrance_door 0)
)

(script dormant f2_lrooma_enc_b
	(sleep_until (volume_test_players tv_f2_largeroom_a_island) 1)
	(ai_place sq_f2_lroom_a_floodmar1)
	(print "f2 large room a light bridge b-1 enc triggered")
	(sleep_until (>= (device_group_get light_bridge_b_group) 1) 1)
	(sleep_until (volume_test_players tv_f2_largeroom_a_island) 1)
;	(ai_place gr_f2_lroom_a_midway)
	(ai_place sq_f2_lroom_a_floodmar2)
	(print "f2 large room a light bridge b-2 enc triggered")
)

(script dormant f2_lrooma_enc_c
	(sleep_until (volume_test_players tv_f2_largeroom_a_island2) 1)
	(ai_place sq_f2_lroom_a_carrier)
	(sleep_until (>= (device_group_get light_bridge_c_group) 1) 1)
	(ai_place sq_f2_lroom_a_floodmar3)
	(print "f2 large room a light bridge c enc triggered")
)

(script dormant f2_lrooma_pit_fill
	(sleep_until
		(begin
			(if (< (f_ai_living_weight_count gr_infector_pit_1) 4) (ai_place sq_infectors_pit_1))
			(if (< (f_ai_living_weight_count gr_infector_pit_2) 4) (ai_place sq_infectors_pit_2))
			false ; sleep exit
		)
		(game_ticks_from_seconds (real_random_range 0.5 2.0))
	)
)

(script dormant f2_lrooma_pit_release
	(sleep_until
		(begin
			(sleep_until (or (volume_test_players tv_pit_release_1) (volume_test_players tv_pit_release_2)) 1)
			(if (volume_test_players tv_pit_release_1) (cs_run_command_script sq_infectors_pit_1 cs_pit_release))
			(if (volume_test_players tv_pit_release_2) (cs_run_command_script sq_infectors_pit_2 cs_pit_release))
			(sleep (game_ticks_from_seconds 6.0))
			false
		)
		1
	)
)

(script command_script cs_scramble_infector_pit_1
	; (ai_disposable ai_current_actor true)
	(cs_abort_on_damage true)
	(cs_swarm_to pts_infector_pit_1/init 2)
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_swarm_to pts_infector_pit_1/p1 4)
				(cs_swarm_to pts_infector_pit_1/p2 4)
				(cs_swarm_to pts_infector_pit_1/p3 4)
				(cs_swarm_to pts_infector_pit_1/p4 4)
			)
			(volume_test_players tv_pit_release_1)
		)
	)
)

(script command_script cs_scramble_infector_pit_2
	; (ai_disposable ai_current_actor true)
	(cs_abort_on_damage true)
	(cs_swarm_to pts_infector_pit_2/init 2)
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_swarm_to pts_infector_pit_2/p1 4)
				(cs_swarm_to pts_infector_pit_2/p2 4)
				(cs_swarm_to pts_infector_pit_2/p3 4)
				(cs_swarm_to pts_infector_pit_2/p4 4)
			)
			(volume_test_players tv_pit_release_2)
		)
	)
)

(script command_script cs_pit_release
	(print "pit attack")
)

;carrier & corpses encounter before elevator
(script dormant f2_sroomd_enc_init
	(print "f2 corpse script ready!")
	(sleep_until (volume_test_players tv_act_343_lift2))
	; (sleep_until
	; 	(and (= (device_group_get light_bridge_c_group) 1) (>= (device_get_position floor_2_middle_exit_door) 0.25))
	; )
	(ai_place gr_f2_sroomd_carriers)
	(print "f2 carriers & corpses triggered")
	(sleep_until (volume_test_players tv_act_pre_flood_sent_fight) 1)
	(ai_erase gr_f2_sroomd_carriers)
)

;tank attacks player as the elevator gets stuck
(script dormant f2_tank_elevator_enc_init
	(sleep_until (volume_test_players tv_act_343_lift2) 1)
	(zone_set_trigger_volume_enable begin_zone_set:set_elevator_2 false)
	(zone_set_trigger_volume_enable zone_set:set_elevator_2 false)
	(sleep_until (volume_test_players tv_act_lift2) 1)
	(sleep_until (>= (device_get_position elevator_2) r_flood_tank_elevator_attack) 1)
	(set b_door_fight_cleared false)
	(device_set_position elevator_2	 r_flood_tank_elevator_attack) ; interupts the elevator which is initially being driven by f_device_pendulum_logic
	(print "push co-op players f2_tank_elevator_enc_init")
	(volume_teleport_players_not_inside tv_lift_2_coop_safe fl_coop_lift_tank_target)
	(f_end_f2_lrooma)
	(ai_disposable gr_f2_sroomd_carriers true)
	; (ai_migrate_persistent gr_f2_sroomd_carriers sq_f2_elevator_2_fl_melee)
	(wake begin_elevator_2_zone)
	; todo todo we should be cleaning up dudes here just in case
	;(player_effect_set_max_translation .03 .01 .06)
	(player_effect_set_max_translation .01 .01 .01)
	(player_effect_set_max_rotation 1 2 2)
	(player_effect_start 1 0)
	(player_effect_stop 0.5)
	(ai_place sq_f2_elevator_2_fl_melee)
	(if (game_is_cooperative)
		(begin
			(sleep (game_ticks_from_seconds 4.0))
			(ai_place sq_f2_tank_co)
		)
	)
	(wake f2_elevator_snipe)
	(sleep_until (<= (f_ai_living_weight_count gr_f2_liftshaft_b) 2) 1)
	(ai_place sq_f2_elevator_2_fl_gun)
	(f_flood_group_blip_gate gr_f2_liftshaft_b)
	(sleep_until (<= (f_ai_living_weight_count gr_f2_liftshaft_b) 0) 1)
	(set b_door_fight_cleared true)
	(sleep (game_ticks_from_seconds 4))
	(device_set_position elevator_2 1.0)
	(kill_volume_disable kill_elevator_2_fall)
)

(script dormant f2_elevator_snipe
	(sleep (game_ticks_from_seconds 2.0)) ; space for others
	(ai_place sq_f2_elevator_2_fl_r)
	(sleep_until (<= (f_ai_living_weight_count sq_f2_elevator_2_fl_r) 0) 1)
	(sleep (game_ticks_from_seconds 4.0))
	; we'll give them max of one more sniper
	(if (not (<= (f_ai_living_weight_count gr_f2_liftshaft_jump) 0))
		(ai_place sq_f2_elevator_2_fl_r)
	)
)

(script dormant begin_elevator_2_zone
	(zone_set_trigger_volume_enable begin_zone_set:set_elevator_2 true)
	(sleep (game_ticks_from_seconds 1))
	(zone_set_trigger_volume_enable zone_set:set_elevator_2 true)
)

(script command_script cs_attack_elevator
	(begin_random_count 1
		; (begin
		; 	(cs_move_towards_point pts_elev2_run_0/p0 1.0)
		; 	(cs_move_towards_point pts_elev2_run_0/p1 1.0)
		; )
		(begin
			(cs_move_towards_point pts_elev2_run_1/p0 1.0)
			(cs_move_towards_point pts_elev2_run_1/p1 1.0)
		)
		(begin
			(cs_move_towards_point pts_elev2_run_2/p0 1.0)
			(cs_move_towards_point pts_elev2_run_2/p1 1.0)
		)
	)
	(sleep (random_range 10 25))
	(cs_jump_to_point 2 2)
	(f_ai_magically_see_players ai_current_actor)
)

(script command_script cs_snipe_elevator
	(cs_move_towards_point pts_elev2_run_0/p0 1.0)
	(cs_move_towards_point pts_elev2_run_0/p1 1.0)
	(f_ai_magically_see_players ai_current_actor)
)

;====================================================================================================================================================================================================
; c20 beat 3 flow
;====================================================================================================================================================================================================
; removed because it is handled by the elevator tank fight
; (script dormant beat_3_coop_advance
; 	(sleep_until (>= (device_get_position elevator_2) 1) 1)
; 	(print "push co-op players beat_3_coop_advance")
; 	(volume_teleport_players_not_inside tv_lift_2_coop_safe_bottom fl_coop_elevator_2)
; )

(script dormant disable_floor_3b_set
	(sleep_until (volume_test_players tv_act_library_f_b) 1)
	(zone_set_trigger_volume_enable begin_zone_set:set_floor_3b false)
	(zone_set_trigger_volume_enable zone_set:set_floor_3b false)
)

(script dormant beat_3_mid_shutdown
	(device_set_power floor_3_door_backfill 0)
	(sleep_until (<= (device_get_position floor_3_door_backfill) 0) 1)
	(print "push co-op players cs_343_large_room_b")
	(volume_teleport_players_not_inside tv_beat_3_shutdown_mid_safe fl_coop_beat_3_mid)
	(ai_disposable gr_library_f_b true)
	(ai_disposable gr_library_f_a true)
	(ai_disposable gr_large_hall_end true)
	(ai_disposable gr_large_hall_tank_attack true)
	(ai_disposable gr_infect_rush true)
	(ai_disposable gr_flood_sent_fight true)
	(zone_set_trigger_volume_enable begin_zone_set:set_floor_3b true)
	(sleep (game_ticks_from_seconds 1))
	(zone_set_trigger_volume_enable zone_set:set_floor_3b true)
)

(script dormant lift_3_logic
	(sleep_until (volume_test_players tv_act_lift3) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; lift 3
	(wake lift_3_fight)
	; (zone_set_trigger_volume_enable begin_zone_set:set_floor_3b false)
	; (zone_set_trigger_volume_enable zone_set:set_floor_3b false)
	(wake beat_4_prep)
	(f_device_pendulum_logic elevator_3 tv_act_lift3 tv_lift3_recall 0.3)
)

(script dormant f3_light_bridge_done
	(sleep_until (>= (device_group_get light_bridge_g_group) 1) 1)
	; (sleep (game_ticks_from_seconds 2))
	(f_hud_obj_complete_noblock)
)

(script dormant beat_3_end
	(sleep_until (volume_test_players tv_act_lift3) 1)
	(sleep_until (>= (device_get_position elevator_3) 0.5) 1)
	(print "beat 3 is done")
	(f_place_monitor sq_monitor/sp_f4_start)
	(wake c20_beat4)
)

;====================================================================================================================================================================================================
; c20 beat 3 vignettes
;====================================================================================================================================================================================================
(script dormant vignette_large_hall_c
	(sleep_until (volume_test_players tv_act_flood_sent_fight) 1)
	; (ai_place sq_flood_bangers) ; cut for scope
	(wake vignette_shoot_out)
	(sleep_until (volume_test_players tv_end_flood_sent_fight) 1)
	(sleep_forever vignette_shoot_out)
	(ai_kill sq_flood_bangers)
	(ai_kill sq_b3_shoot_out_flood)
	(ai_kill sq_b3_shoot_out_sent)
)

; this has been cut for scope, does not work as intended because cs_custom_animation blocks and never returns or yields
(script command_script cs_flood_banger
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_custom_animation objects\characters\floodcombat_human\floodcombat_human "m52:unarmed:melee_glass:var1" true)
				(cs_custom_animation objects\characters\floodcombat_human\floodcombat_human "m52:unarmed:melee_glass:var2" true)
				(cs_custom_animation objects\characters\floodcombat_human\floodcombat_human "m52:unarmed:jump_at_glass" true)
			)
			(sleep (game_ticks_from_seconds 0.5))
			(cs_stop_custom_animation)
			false
		)
	(game_ticks_from_seconds 0.5)) ; loop every half second
)

; hs:begin (f_test_shoot_out)
(script static void f_test_shoot_out
	(wake vignette_shoot_out)
)

(script dormant vignette_shoot_out
	(ai_place sq_b3_shoot_out_flood)
	(ai_place sq_b3_shoot_out_sent)
	(ai_magically_see sq_b3_shoot_out_flood sq_b3_shoot_out_sent)
	(ai_magically_see sq_b3_shoot_out_sent sq_b3_shoot_out_flood)
	; for perf reason, we avoid deaths until player gets closer to the vignette
	(ai_cannot_die sq_b3_shoot_out_flood true)
	(ai_cannot_die sq_b3_shoot_out_sent true)
	(sleep_until (volume_test_players tv_act_343_large_hall) 1)
	(ai_cannot_die sq_b3_shoot_out_flood false)
	(ai_cannot_die sq_b3_shoot_out_sent false)
	(sleep_until
		(begin
			(if (= (ai_nonswarm_count sq_b3_shoot_out_flood) 0)
				(begin
					(print "sq_b3_shoot_out_flood")
					(sleep (game_ticks_from_seconds 2))
					(ai_place sq_b3_shoot_out_flood)
					(ai_magically_see sq_b3_shoot_out_flood sq_b3_shoot_out_sent)
				)
			)
			(if (= (ai_living_fraction sq_b3_shoot_out_sent) 0)
				(begin
					(print "sq_b3_shoot_out_sent")
					(sleep (game_ticks_from_seconds 2))
					(ai_place sq_b3_shoot_out_sent)
					(ai_magically_see sq_b3_shoot_out_sent sq_b3_shoot_out_flood)
				)
			)
			(volume_test_players tv_end_flood_sent_fight) ; also killed by sleep forever incase aliasing breaks things
		)
		6 ; a little bit of randomness via aliasing
	)
)

; hs:begin (f_test_jump_scare jump_pos pause_pos)
(script static void (f_test_jump_scare (real r_test_jump_pos) (real r_test_pause_pos))
	(set r_door_jump_pos r_test_jump_pos)
	(set r_door_jump_pause_pos r_test_pause_pos)
	(ai_erase sq_flood_jumpers)
	(device_set_position_immediate floor_3_jump_scare_door 0)
	(sleep 1)
	(device_set_position floor_3_jump_scare_door r_door_jump_pause_pos)
	(ai_place sq_flood_jumpers)
	(sleep_until (>= (device_get_position floor_3_jump_scare_door) r_door_jump_pause_pos) 1)
	(sleep (game_ticks_from_seconds 4))
	(device_set_position floor_3_jump_scare_door 1.0)
)

(global real r_door_jump_pos 0.25) ; door position that flood will start jumping at
(global real r_door_jump_pause_pos 0.40) ; position at which the door will pause to let flood finish jump
(script dormant vignette_jump_scare
	(sleep_until (> (device_get_position floor_3_jump_scare_door) 0) 1)
	(print "jumper jumper jumper")
	(ai_place sq_flood_jumpers)
	; door is set in motion by ball boy command script, this catches the door and pauses it opening without out having to be refrenced in ballboys script
	(sleep_until (>= (device_get_position floor_3_jump_scare_door) r_door_jump_pause_pos) 1)
	(device_set_position floor_3_jump_scare_door (device_get_position floor_3_jump_scare_door))
	(sleep (game_ticks_from_seconds 4))
	(device_set_position floor_3_jump_scare_door 1.0) ; finish open
	(sleep_until (volume_test_players tv_end_large_hall_end) 1)
	(ai_disposable sq_flood_jumpers true)
)

(script command_script cs_jump_scare
	(ai_braindead ai_current_actor true)
	; (print "prep jump")
	(sleep_until (>= (device_get_position floor_3_jump_scare_door) r_door_jump_pos) 1)
	; (print "ready jump")
	; each jumper needs a different delay to feel good
	(cond
		((volume_test_object tv_jumper_0 ai_current_actor) (sleep 1))
		((volume_test_object tv_jumper_1 ai_current_actor) (sleep (random_range 10 20)))
	)
	; (print "jump!")
	(ai_braindead ai_current_actor false)
	(cs_jump_to_point 4 3.75)
)

;====================================================================================================================================================================================================
; c20 beat 3 encounter
;====================================================================================================================================================================================================

(script dormant flood_pre_sent_fight
	(sleep_until (volume_test_players tv_act_pre_flood_sent_fight) 1)
	(ai_place gr_infect_rush)
	(sleep_until (volume_test_players tv_end_flood_sent_fight) 1)
	(ai_disposable gr_infect_rush true)
)

(script dormant flood_sent_fight
	(sleep_until (volume_test_players tv_act_flood_sent_fight) 1)
	(ai_place gr_flood_sent_fight)
	(sleep_until (volume_test_players tv_end_flood_sent_fight) 1)
	(ai_disposable gr_flood_sent_fight true)
)

(script dormant large_hall_tank_attack
	(sleep_until (volume_test_players tv_act_large_hall_tank_attack) 1)
	(ai_place gr_large_hall_tank_attack)
	(sleep_until (volume_test_players tv_end_flood_sent_fight) 1)
	(ai_disposable gr_large_hall_tank_attack true)
)

(script dormant large_hall_end
	(sleep_until (volume_test_players tv_act_large_hall_end) 1)
	(ai_place gr_large_hall_end)
	(sleep_until (volume_test_players tv_end_large_hall_end) 1)
	(ai_disposable gr_large_hall_end true)
)

(script dormant library_f_a
	(sleep_until (volume_test_players tv_act_library_f_a) 1)
	(ai_place gr_library_f_a)
	(sleep_until (volume_test_players tv_end_library_f) 1)
	(ai_disposable gr_library_f_a true)
)

(script dormant library_f_door
	(sleep_until (volume_test_players tv_act_library_f_door) 1)
	(set b_door_fight_cleared false)
	;(breakpoint "library_f_door a")
	(ai_place gr_library_f_door1)
	(f_flood_group_blip_gate gr_library_f_door1)
	(sleep_until (<= (ai_nonswarm_count gr_library_f_door1) 1) 1)
	(set b_door_fight_cleared true)
	;(breakpoint "library_f_door b")
	(sleep (game_ticks_from_seconds 1))
	(device_set_position f3_lib_f_breakin_door_device 1)
	(ai_place gr_library_f_door2)
	(sleep_until (volume_test_players tv_end_library_f) 1)
	(ai_disposable gr_library_f_door true)
)

(script dormant library_f_b
	(sleep_until (volume_test_players tv_act_library_f_b) 1)
	(ai_place gr_library_f_b)
	(sleep_until (<= (device_get_position floor_3_door_backfill) 0) 1)
	(ai_disposable gr_library_f_b true)
)

; large room b
(script dormant security_door_3
	(sleep_until (volume_test_players tv_act_large_room_b) 1)
	;(breakpoint "security_door_3 a")
	(set b_door_fight_cleared false)
	(sleep_until b_343_away 1)
	(ai_place gr_security_door_3_1) ; infectors
	(set s_music_trigger_c20 190)
	(sleep_until (<= (f_ai_living_weight_count gr_security_door_3) 0.7) 1)
	(ai_place gr_security_door_3_2) ; infectors
	(sleep_until (<= (f_ai_living_weight_count gr_security_door_3) 1) 1)
	(ai_place gr_security_door_3_3) ; small combat
	(sleep_until (<= (f_ai_living_weight_count gr_security_door_3) 1) 1)
	(ai_place sq_carrie2_9)
	(sleep (game_ticks_from_seconds 4))
	(ai_place sq_flood_mixed4_99)
	(sleep_until (<= (f_ai_living_weight_count gr_security_door_3) 2) 1)
	(ai_place gr_security_door_3_5)
	(if (game_is_cooperative)
		(begin
			(sleep_until (<= (f_ai_living_weight_count gr_security_door_3) 2) 1)
			(ai_place gr_security_door_3_4)
		)
	)
	(f_flood_group_blip_gate gr_security_door_3)
	(sleep_until (<= (f_ai_living_weight_count gr_security_door_3) 2) 1)
	(set b_door_fight_cleared true)
	;(breakpoint "security_door_3 b")
	(set s_music_trigger_c20 200)
	(sleep_until (>= (device_get_position floor_3_arena_entrance) 0.1) 1)
	(ai_place gr_security_door_3_post)
	(sleep_until (>= (device_get_position elevator_3) 0.1) 1)
	(ai_disposable gr_security_door_3 true)
)

(script command_script cs_wall_climb_sec_door_3
	(cs_swarm_to pts_infector_climb_target/p0 2)
)

; temp debug, leaving if i need it again
; (global short foo_foo_foo 0)
; (script continuous bar
; 	(sleep 1)
; 	(set foo_foo_foo (f_ai_living_weight_count gr_security_door_3))
; )

(script dormant light_bridges
	(sleep_until (>= (device_get_position floor_3_arena_entrance) 0.75) 1)
	(ai_place gr_light_bridges)
	(sleep_until (>= (device_get_position elevator_3) 0.1) 1)
	(ai_erase gr_light_bridges)
)

(script dormant stealth_ambush
	(sleep_until (>= (device_get_position floor_3_arena_exit) 0.75) 1)
	(ai_place gr_stealth_ambush)
	(sleep_until (>= (device_get_position elevator_3) 1.0) 1)
	(ai_erase gr_stealth_ambush)
)

; removing this for pacing reasons, jan 26
(script dormant lift_3_fight
	(print "elevator 3 script running")
; 	(sleep_until (>= (device_get_position elevator_3) 0.15) 1)
;	(ai_place gr_lift_3_fight_1)
;	(print "elevator c wave 1 go")
;	(sleep_until (>= (device_get_position elevator_3) 0.40) 1)
;	(ai_place gr_lift_3_fight_2)
;	(print "elevator c wave 2 go")
;	(sleep_until (>= (device_get_position elevator_3) 0.60) 1)
;	(ai_place gr_lift_3_fight_3)
;	(print "elevator c wave 3 go")
;	(sleep_until (volume_test_players tv_end_lift_3_fight) 1)
;	(ai_erase gr_lift_3_fight)
)

;====================================================================================================================================================================================================
; c20 beat 4 flow
;====================================================================================================================================================================================================
(script dormant disable_floor_4_set
	(sleep_until (volume_test_players tv_act_lift3) 1)
	(zone_set_trigger_volume_enable begin_zone_set:set_floor_4 false)
	(zone_set_trigger_volume_enable zone_set:set_floor_4 false)
)

(script dormant beat_4_prep
	(sleep_until (>= (device_get_position elevator_3) 1) 1)
	(print "push co-op players beat_4_prep")
	(volume_teleport_players_not_inside tv_lift_3_coop_safe_bottom fl_coop_lift_3)
	(zone_set_trigger_volume_enable begin_zone_set:set_floor_4 true)
	(sleep (game_ticks_from_seconds 1))
	(zone_set_trigger_volume_enable zone_set:set_floor_4 true)
)

(script dormant final_chapter
	(sleep_until (volume_test_players tv_act_final_chapter) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; beat 4 start
	(f_final_chapter)
)

(script dormant final_door
	(sleep_until (>= (device_get_position floor_4_door_last_room) 1) 1) ; wait until we are opened once
	(sleep_until
		(begin
			(if (volume_test_players_all tv_past_fin_door)
				(device_set_position floor_4_door_last_room 0) ; everybody in the room, close the door
				(device_set_position floor_4_door_last_room 1) ; keep it open
			)
			(<= (device_get_position floor_4_door_last_room) 0) ; close all the way, be done
		)
		5
	)
)

(script dormant energy_barrier
	(sleep_until (<= 0.5 (device_get_position floor_4_door_last_room)) 1)
	(device_set_position_immediate dm_index_field 0.5) ; fade energy barrier ; 0.5 is new default activate value for default vignette machines
)

(script dormant c20_won
	(sleep_until (volume_test_players tv_vo_floor4_index) 1)

	; end game
	(print_if b_debug_gameplay "game won !")
	(submit_incident "unlock_c45")
	(submit_incident_with_custom_string_id "game_activity_end_completed" "c20")
	(set s_music_trigger_c20 250)
	(set b_cinematic_lower_weapon true)
	(f_play_cinematic cinematics\c20\c20_outro.cinematic)
	(game_won)
)

;====================================================================================================================================================================================================
; c20 beat 4 encounters
;====================================================================================================================================================================================================
(script dormant large_hall_e_init
	(sleep_until (volume_test_players tv_act_intro_hall_e_init) 1)
	(ai_place gr_intro_hall_e_init)
	(sleep_until (volume_test_players tv_act_large_hall_e_init) 1)
	(ai_place gr_large_hall_e_init)
	(sleep_until (volume_test_players tv_end_large_hall_e_init) 1)
	(ai_erase gr_large_hall_e_init)
)

; this encounter will be killed once players trigger the final fight
(script dormant large_hall_e_l
	(sleep_until (volume_test_players tv_act_large_hall_e_l) 1)
	(ai_place gr_large_hall_e_l)
)

; this encounter will be killed once players trigger the final fight
(script dormant large_hall_e_r
	(sleep_until (volume_test_players tv_act_large_hall_e_r) 1)
	(ai_place gr_large_hall_e_r)
)

(global short s_final_floor 2)
(global short s_final_ceiling 4)
(global short s_final_reups_left 12)
(script dormant beat_4_final
	(sleep_until (volume_test_players tv_act_hallway_door_e_op) 1)
	(set b_door_fight_cleared false)
	(sleep_until b_343_away 1)
	; clean up non-activate side encounters because our final will produce enough monsters
	(sleep_forever large_hall_e_l)
	(sleep_forever large_hall_e_r)
	; rules for the final encounter
	; 1. flood forms will continue to re-up until the limit is reached
	; 2. the monitor will return when only 2 re-ups are left, or the tanks are dead
	(wake final_waves_controller)
	(set s_music_trigger_c20 230)
	(sleep (game_ticks_from_seconds 1))
	(ai_place sq_flood_tank2_32)
	(device_set_position_immediate dm_tank_spawn_fx_2 0.5) ; activate default machine with 0.5
	(device_set_position_immediate dm_tank_spawn_fx_3 0.5) ; activate default machine with 0.5
	(if (game_is_cooperative)
		(begin
			(sleep (game_ticks_from_seconds 2))
			(ai_place sq_flood_tank2_32)
		)
	)
	(f_blip_ai sq_flood_tank2_32/spawn_point 1)
	(f_blip_ai sq_flood_tank2_32/spawn_point1 1)
	(sleep 5)
	(device_set_position_immediate dm_tank_spawn_fx_2 1) ; set to not re-trigger
	(device_set_position_immediate dm_tank_spawn_fx_3 1) ; set to not re-trigger
	(sleep_until
		(or
			(<= (+ (ai_nonswarm_count sq_flood_tank2_32/spawn_point) (ai_nonswarm_count sq_flood_tank2_32/spawn_point1)) 0)
			(<= s_final_reups_left 2)
		)
	)
	(print "*********  end beat_4_final *********")
	(f_unblip_ai sq_flood_tank2_32)
	(set b_door_fight_cleared true)
	(set s_music_trigger_c20 240)
)

(script dormant final_waves_controller
	(cond
		((= (game_difficulty_get) normal) (begin (set s_final_floor 2) (set s_final_ceiling 4)))
		((= (game_difficulty_get) heroic) (begin (set s_final_floor 3) (set s_final_ceiling 5)))
		((= (game_difficulty_get) legendary) (begin (set s_final_floor 4) (set s_final_ceiling 7)))
	)
	(if (game_is_cooperative)
		(set s_final_ceiling (+ s_final_ceiling 3))
		(set s_final_floor (+ s_final_floor 1))
	)
	(wake final_waves_assist)
	(sleep_until
		(begin
			(if (<= (f_ai_living_weight_count gr_beat_4_final) s_final_floor)
				(begin
					(set s_final_reups_left (- s_final_reups_left 1))
					(f_reup_final s_final_ceiling)
					(print "final reups left: ")
					(inspect s_final_reups_left)
				)
			)
			(<= s_final_reups_left 0) ; stop re-upping when at 0
		)
		1
 	)
)

; assist script will intermitnetly add just one more guy in case player is not engaging
(global boolean b_in_reup false) ; to check if f_reup_final is doing work
(script dormant final_waves_assist
	(sleep_until
		(begin
			(print "attempt assist")
			(if (not b_in_reup)
				(begin_random_count 1
					(f_final_spawn 12 fl_fin_l_0 sq_fin_l_0)
					(f_final_spawn 12 fl_fin_l_1 sq_fin_l_1)
					(f_final_spawn 12 fl_fin_l_2 sq_fin_l_2)
					(f_final_spawn 12 fl_fin_end_0 sq_fin_end_0)
					(f_final_spawn 12 fl_fin_end_1 sq_fin_end_1)
					(f_final_spawn 12 fl_fin_end_2 sq_fin_end_2)
					(f_final_spawn 12 fl_fin_end_3 sq_fin_end_3)
					(f_final_spawn 12 fl_fin_r_0 sq_fin_r_0)
					(f_final_spawn 12 fl_fin_r_1 sq_fin_r_1)
					(f_final_spawn 12 fl_fin_r_2 sq_fin_r_2)
					(f_final_spawn 12 fl_fin_strt_0 sq_fin_strt_0)
					(f_final_spawn 12 fl_fin_strt_1 sq_fin_strt_1)
					(f_final_spawn 12 fl_fin_strt_2 sq_fin_strt_2)
					(f_final_spawn 12 fl_fin_strt_3 sq_fin_strt_3)
				)
			)
			(<= s_final_reups_left 0) ; end when all waves are depleted
		)
		(game_ticks_from_seconds 8)
	)
)

; hs:begin (f_test_reup 8)
(script static void (f_test_reup (short max_flood))
	(ai_erase_all)
	(f_reup_final max_flood)
)

(global real r_min_vent_dist 8)
(global real r_max_vent_dist 20)
(script static void (f_reup_final (short max_flood))
	(print "begin f_reup_final")
	(if (game_is_cooperative) (set r_min_vent_dist 4) (set r_min_vent_dist 8))
	(sleep_until
		(begin
			; (print "  spawn loop top")
			(set b_in_reup true)
			(begin_random
				(f_final_spawn max_flood fl_fin_l_0 sq_fin_l_0)
				(f_final_spawn max_flood fl_fin_l_1 sq_fin_l_1)
				(f_final_spawn max_flood fl_fin_l_2 sq_fin_l_2)
				(f_final_spawn max_flood fl_fin_end_0 sq_fin_end_0)
				(f_final_spawn max_flood fl_fin_end_1 sq_fin_end_1)
				(f_final_spawn max_flood fl_fin_end_2 sq_fin_end_2)
				(f_final_spawn max_flood fl_fin_end_3 sq_fin_end_3)
				(f_final_spawn max_flood fl_fin_r_0 sq_fin_r_0)
				(f_final_spawn max_flood fl_fin_r_1 sq_fin_r_1)
				(f_final_spawn max_flood fl_fin_r_2 sq_fin_r_2)
				(f_final_spawn max_flood fl_fin_strt_0 sq_fin_strt_0)
				(f_final_spawn max_flood fl_fin_strt_1 sq_fin_strt_1)
				(f_final_spawn max_flood fl_fin_strt_2 sq_fin_strt_2)
				(f_final_spawn max_flood fl_fin_strt_3 sq_fin_strt_3)
			)
			(set b_in_reup false)
			(>= (f_ai_living_weight_count gr_beat_4_final) max_flood)
		)
		(game_ticks_from_seconds (real_random_range 0.5 0.75))
	)
	; (print "finish f_reup_final")
)

(script static void (f_final_spawn (short max_flood)(cutscene_flag spawn_check)(ai squad))
	(if (f_final_spawn_ok max_flood spawn_check)
		(ai_place squad)
		(sleep (game_ticks_from_seconds (real_random_range 0.1 0.25)))
	)
	(sleep 1)
)

(global real r_vent_dist 0)
(script static boolean (f_final_spawn_ok (short max_flood) (cutscene_flag spawn_check))
	(set r_vent_dist (objects_distance_to_flag (players) spawn_check))
	; (inspect spawn_check)
	; (inspect r_vent_dist)
	(if
		(and
			(< (f_ai_living_weight_count gr_beat_4_final) max_flood)
			(< r_vent_dist r_max_vent_dist)
			(> r_vent_dist r_min_vent_dist)
		)
		(begin
			(print "    +")
			true
		)
		(begin
			(print "    .")
			false
		)
	)
)

;====================================================================================================================================================================================================
; c20 beat 1 monitor
;====================================================================================================================================================================================================
(script dormant 343_start_to_shaft
	(sleep_until (volume_test_players tv_act_mission_start) 1)
	(sleep_until (not (volume_test_players tv_act_mission_start)) 1)
	(cs_queue_command_script ai_monitor cs_343_start_to_shaft)
	(f_hud_chapter chapter_c20_1)
	(set s_music_trigger_c20 20)
	(sleep (game_ticks_from_seconds 4.0))
	(f_hud_obj_new_noblock obj_c20_follow)
)

(script command_script cs_343_start_to_shaft
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set s_vo_progress_c20 1)
	(cs_fly_by pts_monitor_intro/p0)
	(cs_fly_by pts_monitor_intro/p1)
	(cs_fly_by pts_monitor_intro/p2)
	(cs_fly_by pts_monitor_intro/p3)
	(cs_look_player true)
)

(script dormant 343_shaft_present
	(sleep_until (volume_test_players tv_act_343_shaft_present) 1)
	(if (not (cs_command_script_attached ai_monitor cs_343_library_a))
		(cs_queue_command_script ai_monitor cs_343_shaft_present)
	)
)

(script command_script cs_343_shaft_present
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set s_library_progress -1) ; cs_343_library_a needs alt path
	(cs_fly_by pts_monitor_shaft_present/p0)
	(cs_fly_by pts_monitor_shaft_present/p1)
	(cs_fly_by pts_monitor_shaft_present/p2)
	(cs_fly_by pts_monitor_shaft_present/p3)
	(cs_fly_by pts_monitor_shaft_present/p4)
	(set s_library_progress 0) ; cs_343_library_a can run main path
	(cs_fly_by pts_monitor_shaft_present/p5)
	(set s_vo_progress_c20 10)
)

(script dormant 343_library_a
	(sleep_until (>= (device_get_position floor_1_door_right) 0.1) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; library_a
	(sleep_until (>= (device_get_position floor_1_door_right) 0.5) 1)
	(ai_place sq_f1_flood_start_inf)
	(if (cs_command_script_attached ai_monitor cs_343_start_to_shaft)
		(begin
			(print "queu next")
			(cs_queue_command_script ai_monitor cs_343_library_a)
		)
		(begin
			(print "run next")
			(cs_run_command_script ai_monitor cs_343_library_a)
		)
	)
)

(script command_script cs_343_library_a
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(if (< s_library_progress 0) (cs_fly_by pts_monitor_shaft_present/p4))
	(cs_fly_to_object_marker floor_1_door_right "monitor_loc_a")
	(cs_fly_to_object_marker floor_1_door_right "monitor_loc_b")
	(cs_fly_to pts_343_lib_a/p0point25)
	(cs_fly_to pts_343_lib_a/p0point5)
	(cs_fly_to pts_343_lib_a/p0point75)
	(cs_fly_to pts_343_lib_a/p1)
	(cs_fly_to pts_343_lib_a/p1point5)
	(cs_fly_to pts_343_lib_a/p2)
	(cs_fly_to pts_343_lib_a/p3)
	(cs_fly_to pts_343_lib_a/p3point25)
	(cs_fly_to pts_343_lib_a/p3point5)
	(cs_fly_to pts_343_lib_a/p3point75)
	(cs_fly_to pts_343_lib_a/p4)
	(cs_fly_to pts_343_lib_a/p5)
	(cs_fly_to pts_343_lib_a/p5point25)
	(f_monitor_breakable_door_pause f1_lib_a_breakin_door_device)
	(cs_fly_to pts_343_lib_a/p5point5)
	(cs_fly_to pts_343_lib_a/p5point75)
	(set s_vo_progress_c20 15)
	(cs_fly_to pts_343_lib_a/p6)
	(cs_fly_to pts_343_lib_a/p7)
	(cs_fly_to pts_343_lib_a/p8)
	(cs_fly_to pts_343_lib_a/p9)
	(cs_fly_to pts_343_lib_a/p10)
	(cs_fly_to pts_343_lib_a/p11)
	(cs_fly_to pts_343_lib_a/p12)
	(cs_fly_to pts_343_lib_a/p13)
	(cs_fly_to pts_343_lib_a/p14)
	(cs_fly_to pts_343_lib_a/p14point25)
	(cs_fly_to pts_343_lib_a/p14point5)
	(cs_fly_to pts_343_lib_a/p15)
	(cs_fly_to pts_343_lib_a/p16)
	(if (< (device_get_position floor_1_door_right_end_closed) 0.5)
		(cs_fly_to pts_343_lib_a/p17)
	)
	(sleep_until (>= (device_get_position floor_1_door_right_end_closed) 0.5) 1)
	(cs_fly_to pts_343_end_lib_a/p0)
	(cs_fly_to pts_343_end_lib_a/p1)
	(cs_fly_to pts_343_end_lib_a/p2)
)

(script dormant 343_middle_sec_door
	(sleep_until (volume_test_players tv_act_middle_entrance) 1)
	(set b_343_away false)
	(print "attempt checkpoint save...")
	(f_game_save) ; pre wave fight 1 - shaft door 1
	(cs_queue_command_script ai_monitor cs_343_middle_sec_door)
	(sleep (game_ticks_from_seconds 4.0))
	; monitor error handling
	; if the monitor does not reach away destination, activate the encounter
	(if (not (f_monitor_arrived tv_middle_sec_343_wait 30))
		(begin
			(print "error: monitor failed to arrive")
			(f_place_monitor sq_monitor_middle_sec_rec_pre)
			(cs_queue_command_script ai_monitor cs_343_middle_sec_door)
		)
	)

	(sleep_until b_door_fight_cleared 1)
	; if the monitor does not open the door, unblock player and restart monitor
	(if (f_monitor_opperated_device floor_1_middle_entrance_door 30) (sleep_forever ))
	(device_set_position floor_1_middle_entrance_door 1)
	(f_place_monitor sq_monitor_middle_sec_rec_post)
	(set b_343_away false)
	(print "error: monitor failed to open the door")
)

; this is run if the monitor is detected to be stuck or too slow
; run from placement script
(script command_script cs_343_middle_sec_door_fix
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to pts_343_middle_entrance/p3)
	(cs_fly_to pts_343_middle_entrance/p2)
)

(script command_script cs_343_middle_sec_door
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to_object_marker floor_1_middle_entrance_door "monitor_loc_a")
	(set s_vo_progress_c20 20)
	(wake shut_floor_1_backfill) ; add to fail safe?
	(cs_face_object true dm_sec_door_f1_1_fx)
	(f_door_try_fail dm_sec_door_f1_1_fx)
	(cs_face_object false dm_sec_door_f1_1_fx)
	(sleep_until (= s_vo_progress_c20 21) 1) ; wait for monitor to finish his vo line before moving aside
	(f_hud_obj_new_noblock obj_c20_hold)
	(f_unblip_flag fl_nav_smallroom_b)
	(cs_fly_to pts_343_middle_entrance/p1)
	(cs_face_player true)
	(set b_343_away true)
	(sleep (game_ticks_from_seconds 4))
	(sleep_until b_door_fight_cleared 1)
	(f_hud_obj_complete_noblock)
	(set b_343_away false)
	(cs_face_player false)
	(cs_fly_to_object_marker floor_1_middle_entrance_door "monitor_loc_a")
	(cs_face_object true dm_sec_door_f1_1_fx)
	(f_door_try_open dm_sec_door_f1_1_fx floor_1_middle_entrance_door)
	(cs_face_object false dm_sec_door_f1_1_fx)
	(sleep_until (>= (device_get_position floor_1_middle_entrance_door) 0.25) 1)
	(f_hud_obj_complete_noblock)
	(cs_fly_to_object_marker floor_1_middle_entrance_door "monitor_loc_b")
	(cs_fly_to pts_343_middle_entrance/p5)
)

(script dormant shut_floor_1_backfill
	(device_set_power floor_1_door_backfill 0)
	(sleep_until (<= (device_get_position floor_1_door_backfill) 0) 1)
	; groups in previous encounters
	(ai_disposable gr_library_a_fin true)
	(ai_disposable gr_library_a_twists true)
	(ai_disposable gr_library_a_door true)
	(ai_disposable gr_library_a_init true)
	(print "push coop players shut_floor_1_backfill")
	(volume_teleport_players_not_inside tv_middle_sec_door_fight fl_coop_middle_sec_fight)
)

; paste -> hs:begin (f_test_sec_door)
(script static void (f_test_sec_door)
	(print "warning: this is a test script for fx iteration, game flow might break")
	(device_set_position_immediate floor_1_middle_entrance_door 0)
	(f_place_monitor sq_monitor/spawnpoint_b)
	(cs_run_command_script ai_monitor cs_343_test_sec_door)
)

(script command_script cs_343_test_sec_door
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	; (cs_teleport pts_343_end_lib_a/p2 pts_343_middle_entrance/p1)
	(sleep (game_ticks_from_seconds 2))
	(print "a) monitor move to door marker")
	(cs_fly_to_object_marker floor_1_middle_entrance_door "monitor_loc_a")
	(cs_face_object true dm_sec_door_f1_1_fx)
	(f_door_try_fail dm_sec_door_f1_1_fx)
	(cs_face_object false dm_sec_door_f1_1_fx)
	(print "b) monitor move away")
	(cs_fly_to pts_343_end_lib_a/p2)
	(sleep (game_ticks_from_seconds 4))
	(print "c) monitor move to door marker")
	(cs_fly_to_object_marker floor_1_middle_entrance_door "monitor_loc_a")
	(cs_face_object true dm_sec_door_f1_1_fx)
	(f_door_try_open dm_sec_door_f1_1_fx floor_1_middle_entrance_door)
	(cs_face_object false dm_sec_door_f1_1_fx)
	(sleep_until (>= (device_get_position floor_1_middle_entrance_door) 0.25) 1)
	(print "d) monitor move through door")
	(cs_fly_to_object_marker floor_1_middle_entrance_door "monitor_loc_b")
	(cs_fly_to pts_343_middle_entrance/p5)
)

(script dormant 343_broken_door
	(sleep_until (volume_test_players tv_act_broken_door) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; post wave fight 1 - shaft door 1
	(cs_queue_command_script ai_monitor cs_343_broken_door)
)

(script command_script cs_343_broken_door
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to pts_343_broke_door/p0)
	(set s_vo_progress_c20 30)
	(cs_fly_to pts_343_broke_door/door_a)
	(cs_face_object true dm_sec_door_f1_2_fx)
	(f_door_fail dm_sec_door_f1_2_fx)
	(cs_face_object false dm_sec_door_f1_2_fx)
	(sleep_until (= s_vo_progress_c20 31) 1)
	(if (not (volume_test_players tv_reached_service))
		(f_hud_obj_new_noblock obj_c20_service)
	)
	(cs_fly_to pts_343_broke_door/p1)
	(cs_fly_to pts_343_broke_door/p2)
	(cs_fly_to pts_343_broke_door/p3)
	(cs_fly_to pts_343_broke_door/p4)
	(cs_teleport pts_sentinel_intro/p0 pts_sentinel_intro/p1)
)

(script dormant 343_sentinel_intro
	(sleep_until (volume_test_players tv_act_sentinel_intro) 1)
	(f_place_monitor sq_monitor_sentinel_intro)
	(cs_queue_command_script ai_monitor cs_343_sentinel_intro)
)

(script command_script cs_343_sentinel_intro
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_teleport pts_sentinel_intro/p0 pts_sentinel_intro/p1)
	(cs_fly_to pts_sentinel_intro/p1)
	(f_hud_obj_new_noblock obj_c20_elevator1)
	(cs_fly_to pts_sentinel_intro/p2)
)

;====================================================================================================================================================================================================
; c20 beat 2 monitor
;====================================================================================================================================================================================================
(script dormant 343_hallway_b
	(sleep_until (volume_test_players tv_act_hallway_b) 1)
	(if (game_is_cooperative) (object_create_folder fold_coop_floor2_a))
	(set s_split_dir 0)
	(print "attempt checkpoint save...")
	(f_game_save) ; start of beat 2
	(cs_queue_command_script ai_monitor cs_343_hallway_b_init)
	(f_hud_chapter chapter_c20_2)
	(set s_music_trigger_c20 70)
	(sleep_until (not (cs_command_script_running ai_monitor cs_343_hallway_b_init)) 1)
	(sleep_until
		(begin
			(f_monitor_choose_cs_by_player_distance_to_point pts_343_hallway_b_clock/p3 cs_343_hallway_b_clock pts_343_hallway_b_counter/p3 cs_343_hallway_b_counter)
			(not (volume_test_players_all tv_hallway_b_split)) ; exit
		)
		1
	)
	(sleep_until (volume_test_players tv_hallway_door_b_op) 1)
	(cs_queue_command_script ai_monitor cs_343_hallway_b_door)
	(sleep (game_ticks_from_seconds 4))
	; monitor error handling
	; if the monitor does not reach away destination, activate the encounter
	(if (not (f_monitor_arrived tv_hallway_b_343_wait 120))
		(begin
			(set b_343_away true)
			(print "error: monitor failed to leave")
		)
	)
	(sleep_until b_door_fight_cleared 1)
	; if the monitor does not open the door, unblock player and restart monitor
	(if (f_monitor_opperated_device floor_2_stacks_entrance_door 120) (sleep_forever))
	(f_door_try_open dm_sec_door_f2_1_fx floor_2_stacks_entrance_door)
	(f_place_monitor sq_monitor_hallway_b_recovery)
	(set b_343_away false)
	(print "error: monitor failed to open the door")
	(print "attempt checkpoint save...")
	(f_game_save) ; failsafe
)

(script command_script cs_343_hallway_b_init
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to pts_343_hallway_b_counter/p0)
	(f_hud_obj_new_noblock obj_c20_explore)
)

(script command_script cs_343_hallway_b_clock
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set s_split_dir 1)
	(cs_fly_to pts_343_hallway_b_clock/p1)
	(cs_fly_to pts_343_hallway_b_clock/p2)
	(sleep_until (not (volume_test_players_all tv_hallway_b_split)) 1)
	(cs_fly_to pts_343_hallway_b_clock/p3)
	(sleep_until (volume_test_players tv_hallway_b_rejoin) 1)
	(cs_fly_to pts_343_hallway_b_clock/p4)
	(cs_fly_to pts_343_hallway_b_clock/p5)
)

(script command_script cs_343_hallway_b_counter
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set s_split_dir -1)
	(cs_fly_to pts_343_hallway_b_counter/p1)
	(cs_fly_to pts_343_hallway_b_counter/p2)
	(sleep_until (not (volume_test_players_all tv_hallway_b_split)) 1)
	(cs_fly_to pts_343_hallway_b_counter/p3)
	(sleep_until (volume_test_players tv_hallway_b_rejoin) 1)
	(cs_fly_to pts_343_hallway_b_counter/p4)
	(cs_fly_to pts_343_hallway_b_counter/p5)
)

(script command_script cs_343_hallway_b_door
	(cs_enable_pathfinding_failsafe true)
	; (cs_ignore_obstacles true)
	(set b_343_away false)
	(cs_fly_to_object_marker floor_2_stacks_entrance_door "monitor_loc_a")
	(cs_face_object true dm_sec_door_f2_1_fx)
	(f_door_try_fail dm_sec_door_f2_1_fx)
	(cs_face_object false dm_sec_door_f2_1_fx)
	(f_unblip_flag fl_nav_centercorridor_b)
	(print "attempt checkpoint save...")
	(f_game_save) ; post wave fight 2 - vent door 1
	(set s_vo_progress_c20 39)
	(sleep (game_ticks_from_seconds 2))
	(f_hud_obj_new_noblock obj_c20_hold)
	(set b_343_away true)
	(sleep_until
		(begin
			(sleep (game_ticks_from_seconds 4))
			(cs_face_object true dm_sec_door_f2_1_fx)
			(f_door_try_fail dm_sec_door_f2_1_fx)
			(cs_face_object false dm_sec_door_f2_1_fx)
			b_door_fight_cleared
		)
	 	1  ; (game_ticks_from_seconds 120))
	)
	(f_hud_obj_complete_noblock)
	(sleep (game_ticks_from_seconds 4))
	(set b_343_away false)
	(cs_fly_to_object_marker floor_2_stacks_entrance_door "monitor_loc_a")
	(cs_face_object true dm_sec_door_f2_1_fx)
	(f_door_try_open dm_sec_door_f2_1_fx floor_2_stacks_entrance_door)
	(cs_face_object false dm_sec_door_f2_1_fx)
	(sleep_until (>= (device_get_position floor_2_stacks_entrance_door) 0.5) 1)
	(f_hud_obj_new_noblock obj_c20_delve)
	(cs_fly_to_object_marker floor_2_stacks_entrance_door "monitor_loc_b")
	(cs_fly_to pts_343_lib_d/door1_wait)
	(print "attempt checkpoint save...")
	(f_game_save) ; post wave fight 2 - vent door 1
)


(global boolean player_in_lib_d false)
(script dormant 343_lib_cd_controller
	(sleep_until (volume_test_players tv_act_343_cd) 1)
	(sleep_until (volume_test_object tv_act_343_cd ai_monitor) 1)
	(cs_run_command_script ai_monitor cs_343_lib_cd)
	(sleep_until (lib_d_open) 1)
	(cs_queue_command_script ai_monitor cs_343_lib_d)
	(sleep_until (volume_test_players tv_act_343_library_d) 1)
	(set player_in_lib_d true)
)

; do we need to visit reclaimer
(script static boolean rec_needed
	(< s_vo_progress_c20 46)
)

; returns which position the player is in
(script static short player_lib_c_pos
	(if (volume_test_players tv_act_343_library_c2)
		2
	(if (volume_test_players tv_act_343_library_c1)
		1
	(if (volume_test_players tv_act_343_cd)
		0
		-1
	)))
)

(script static short 343_lib_c_pos
	(if (volume_test_object tv_act_343_library_c2 ai_monitor)
		2
	(if (volume_test_object tv_act_343_library_c1 ai_monitor)
		1
	(if (volume_test_object tv_act_343_cd ai_monitor)
		0
		-1
	)))
)

(script static boolean lib_d_open
	(>= (device_get_position floor_2_door_right) 0.1)
)

(script command_script cs_343_lib_cd
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(sleep_until
		(begin
			; this cond supports three movements
			; 1. c0 -> c1
			; 2. c1 -> c2 present reclaimer -> c1 -> c0
			; 3. c1 -> c0
			(cond
				(
					(and (rec_needed) (> (player_lib_c_pos) (343_lib_c_pos)) (= (343_lib_c_pos) 1)) ; run the reclaimer presentation, end at c0
					(begin
						(cs_fly_to pts_343_lib_c/p3)
						(cs_fly_to pts_343_lib_c/p4)
						(cs_fly_to pts_343_lib_c/p5)
						(cs_fly_to pts_343_lib_c/p6)
						(cs_fly_to_and_face pts_343_lib_c/p7 pts_343_lib_c/p8reclaimer 1)
						(set s_vo_progress_c20 45)
						(sleep_until (= s_vo_progress_c20 46) 1) ; wait until vo to end
						(cs_fly_to pts_343_lib_c/p6)
						(cs_fly_to pts_343_lib_c/p5)
						(cs_fly_to pts_343_lib_c/p4)
						(cs_fly_to pts_343_lib_c/p3)
						(cs_fly_to pts_343_lib_d/lib_c_wait)
						(cs_fly_to pts_343_lib_d/door1_wait)
					)
				)
				(
					(and (rec_needed) (> (player_lib_c_pos) (343_lib_c_pos)) (= (343_lib_c_pos) 0)) ; move to c1
					(cs_fly_to pts_343_lib_d/lib_c_wait)
				)
				(
					(and (< (player_lib_c_pos) (343_lib_c_pos)) (= (343_lib_c_pos) 1)) ; move to c0
					(cs_fly_to pts_343_lib_d/door1_wait)
				)
				(true (sleep 1))
			)

			(and (= (343_lib_c_pos) 0) player_in_lib_d (or (not (rec_needed)) (= (player_lib_c_pos) -1))) ; exit sleep
		)
		1 ; sleep time
	)
)

(script command_script cs_343_lib_d
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to pts_343_lib_d/door1_wait)
	(sleep_until (>= (device_get_position floor_2_door_right) 0.1) 1)
	(cs_fly_to_object_marker floor_2_door_right "monitor_loc_a") ; (cs_fly_to pts_343_lib_d/door1_a)
	(sleep_until (>= (device_get_position floor_2_door_right) 0.5) 1)
	(cs_fly_to_object_marker floor_2_door_right "monitor_loc_b") ; (cs_fly_to pts_343_lib_d/door1_b)
	(cs_fly_to pts_343_lib_d/p3)
	(cs_fly_to pts_343_lib_d/p4)
	(cs_fly_to pts_343_lib_d/p5)
	(cs_fly_to pts_343_lib_d/p6)
	(cs_fly_to pts_343_lib_d/p7)
	(cs_fly_to pts_343_lib_d/breakin_0)
	(if (< (device_get_position f2_lib_d_1st_breakin_door_device) 0.5)
		(cs_fly_to pts_343_lib_d/breakin_1)
	)
	(f_monitor_breakable_door_pause f2_lib_d_1st_breakin_door_device)
	(cs_fly_to pts_343_lib_d/p8)
	(cs_fly_to pts_343_lib_d/p9)
	(cs_fly_to pts_343_lib_d/p10)
	(cs_fly_to pts_343_lib_d/p11)
	(cs_fly_to pts_343_lib_d/p12)
	(f_monitor_breakable_door_pause f2_lib_d_2nd_breakin_door_device)
	(cs_fly_to pts_343_lib_d/p13)
	(cs_fly_to pts_343_lib_d/p14)
	(cs_fly_to pts_343_lib_d/p15)
	(cs_fly_to pts_343_lib_d/p16)
	(cs_fly_to pts_343_lib_d/door2_wait)
	(sleep_until (>= (device_get_position floor_2_door_right_end) 0.1) 1)
	(cs_fly_to pts_343_lib_d/door2_a)
	(sleep_until (>= (device_get_position floor_2_door_right_end) 0.5) 1)
	(cs_fly_to pts_343_lib_d/door2_b)
	(cs_fly_to pts_343_lib_d/p20)
)

(script dormant 343_to_small_room_c
	(sleep_until (volume_test_players tv_act_343_small_room) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; pre wave fight 3 - shaft door 2
	(cs_queue_command_script ai_monitor cs_343_small_room_c)
	(sleep (game_ticks_from_seconds 4))
	; monitor error handling
	; if the monitor does not reach the door zone
	(if (not (f_monitor_arrived tv_beat_2_shutdown_mid_safe 10))
		(begin
			(print "error: monitor failed to arrive")
			(f_place_monitor sq_monitor_room_c_rec_pre)
			(cs_queue_command_script ai_monitor cs_343_small_room_c)
		)
	)

	(sleep_until b_door_fight_cleared 1)
	; if the monitor does not open the doors, unblock player and restart monitor
	(if (and
			(f_monitor_opperated_device floor_2_middle_entrance_door2 60)
			(f_monitor_opperated_device floor_2_middle_entrance_door 40)
		)
		(sleep_forever) ; then
	)
	(f_door_try_open dm_sec_door_f2_2_fx floor_2_middle_entrance_door2)
	(f_door_try_open dm_sec_door_f2_3_fx floor_2_middle_entrance_door)
	(f_place_monitor sq_monitor_room_c_recovery)
	(set b_343_away false)
	(cs_queue_command_script ai_monitor cs_343_large_room_a) ; if the second door didn't open the player may have issed the kicke off of the cs
	(print "error: monitor failed to open the doors")
	(print "attempt checkpoint save...")
	(f_game_save) ; fallback post wave fight 3 - shaft door 2
)

; run from back up monitor placement script
(script command_script cs_343_small_room_c_fix
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to pts_343_to_small_room_c/p7)
	(cs_fly_to pts_343_to_small_room_c/p8)
	(cs_fly_to pts_343_lib_d/door2_a)
	(cs_fly_to pts_343_lib_d/door2_b)
	(cs_fly_to pts_343_lib_d/p20)
)

(script command_script cs_343_small_room_c
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set b_343_away false)
	(cs_fly_to_object_marker floor_2_middle_entrance_door2 "monitor_loc_a")
	(wake beat_2_shutdown_mid)
	(cs_face_object true dm_sec_door_f2_2_fx)
	(f_door_try_fail dm_sec_door_f2_2_fx)
	(cs_face_object false dm_sec_door_f2_2_fx)
	(f_unblip_flag fl_nav_smallroom_c)
	(set l_time_point (game_tick_get))
	(f_hud_obj_new_noblock obj_c20_survivedoor)
	(set s_vo_progress_c20 50)
	(cs_fly_by pts_343_to_small_room_c/p2)
	(set l_time_point (- (game_tick_get) l_time_point))
	(set b_343_away true)
	(cs_fly_by pts_343_to_small_room_c/p1)
	(cs_fly_by pts_343_to_small_room_c/p0)
	(cs_pause 4.0) ; enemy attack
	(sleep_until b_door_fight_cleared 1)
	(print "cleared cleared cleared")
	(f_hud_obj_complete_noblock)
	(set b_343_away false)
	(cs_teleport pts_343_to_small_room_c/p7 pts_343_to_small_room_c/p8)
	(cs_fly_by pts_343_to_small_room_c/p8)
	(set s_vo_progress_c20 51)
	(cs_fly_to_object_marker floor_2_middle_entrance_door2 "monitor_loc_a")
	(cs_face_object true dm_sec_door_f2_2_fx)
	(f_door_try_open dm_sec_door_f2_2_fx floor_2_middle_entrance_door2)
	(cs_face_object false dm_sec_door_f2_2_fx)
	(sleep_until (>= (device_get_position floor_2_middle_entrance_door2) 0.25) 1)
	(f_hud_obj_complete_noblock)
	(print "attempt checkpoint save...")
	(f_game_save) ; post wave fight 3 - shaft door 2
	(cs_fly_to_object_marker floor_2_middle_entrance_door2 "monitor_loc_b")
	(cs_fly_to_object_marker floor_2_middle_entrance_door "monitor_loc_a")
	(cs_face_object true dm_sec_door_f2_3_fx)
	(f_door_try_open dm_sec_door_f2_3_fx floor_2_middle_entrance_door)
	(cs_face_object false dm_sec_door_f2_3_fx)
	(sleep_until (>= (device_get_position floor_2_middle_entrance_door) 0.25) 1)
	(cs_fly_to_object_marker floor_2_middle_entrance_door "monitor_loc_b")
	(cs_fly_to pts_343_large_room_a/p0)
)

(script dormant 343_large_room_a
	(sleep_until (volume_test_players tv_act_343_large_room_a) 1)
	(cs_queue_command_script ai_monitor cs_343_large_room_a)
)

(script command_script cs_343_large_room_a
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_by pts_343_large_room_a/p0)
	(cs_fly_by pts_343_large_room_a/p1)
	(cs_fly_by pts_343_large_room_a/p2)
	(f_hud_obj_new_noblock obj_c20_accesslight)
	(cs_fly_by pts_343_large_room_a/p3)
	(cs_fly_by pts_343_large_room_a/p4)
	(cs_fly_to pts_343_large_room_a/p5)
)

(script dormant 343_lift2
	(sleep_until (and (volume_test_object tv_act_343_lift2 ai_monitor) (volume_test_players tv_act_343_lift2)) 1)
	(cs_queue_command_script ai_monitor cs_343_lift2)
	; monitor error handling
	; if the door doesn't open, unblock player and restart monitor
	(if (not (f_monitor_opperated_device floor_2_middle_exit_door 60))
		(begin
			(f_door_try_open dm_sec_door_f2_4_fx floor_2_middle_exit_door)
			(f_place_monitor sq_monitor_lift2_recovery)
			(print "error: monitor failed to open the door")
		)
	)
	(sleep_until (volume_test_players tv_343_lift2_leave))
	(cs_queue_command_script ai_monitor cs_343_beat2_outro)
)

(script command_script cs_343_lift2
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to pts_343_large_room_a/p6)
	(cs_fly_to pts_343_large_room_a/p7)
	(cs_fly_by pts_343_lift2/p0)
	(cs_fly_to_object_marker floor_2_middle_exit_door "monitor_loc_a")
	(cs_face_object true dm_sec_door_f2_4_fx)
	(f_door_try_open dm_sec_door_f2_4_fx floor_2_middle_exit_door)
	(cs_face_object false dm_sec_door_f2_4_fx)
	(sleep_until (>= (device_get_position floor_2_middle_exit_door) 0.25) 1)
	(cs_fly_to_object_marker floor_2_middle_exit_door "monitor_loc_b")
	(f_hud_obj_new_noblock obj_c20_elevator2)
	(cs_fly_by pts_343_lift2/lift_wait)
)

(script command_script cs_343_beat2_outro
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_by pts_343_lift2/p4)
	(cs_fly_to pts_343_lift2/p5)
	(sleep_until (script_finished "vo_floor2_lift") 1)
	(ai_erase ai_current_actor)
)

;====================================================================================================================================================================================================
; c20 beat 3 monitor
;====================================================================================================================================================================================================
(script dormant 343_floor_3_intro
	(sleep_until (volume_test_players tv_act_343_floor_3_intro) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; beat 3 start
	(cs_queue_command_script ai_monitor cs_343_floor_3_intro)
)

(script command_script cs_343_floor_3_intro
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(f_hud_obj_new_noblock obj_c20_follow)
	(cs_fly_to pts_343_floor3_intro/p0)
	(cs_fly_to pts_343_floor3_intro/p1)
	(cs_fly_to pts_343_floor3_intro/p2)
	(cs_fly_to pts_343_floor3_intro/p3)
)

(script dormant 343_large_hall
	(sleep_until (volume_test_players tv_act_343_large_hall) 1)
	(cs_queue_command_script ai_monitor cs_343_large_hall)
)

(script command_script cs_343_large_hall
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to pts_343_large_hall/p0)
	(cs_fly_to pts_343_large_hall/p1)
	(cs_fly_to pts_343_large_hall/p2)
	(cs_fly_to pts_343_large_hall/p3)
	(cs_fly_to pts_343_large_hall/p4)
)

(script dormant 343_jump_door
	(sleep_until (volume_test_players tv_act_343_jump_scare) 1)
	(cs_queue_command_script ai_monitor cs_343_jump_door)
	; monitor error handling
	; if the door doesn't open, unblock player and restart monitor
	(if (f_monitor_opperated_device floor_3_jump_scare_door 60) (sleep_forever))
	(device_set_position floor_3_jump_scare_door 1.0)
	(f_place_monitor sq_monitor_large_hall_recovery)
	(print "error: monitor failed to open the door")
)

(script command_script cs_343_jump_door
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to_object_marker floor_3_jump_scare_door "monitor_loc_a")
	(cs_face_object true dm_sec_door_f3_1_fx)
	(f_door_try_open dm_sec_door_f3_1_fx floor_3_jump_scare_door)
	(cs_face_object false dm_sec_door_f3_1_fx)
	(cs_fly_to pts_343_large_hall/p4)
	(sleep_until (>= (device_get_position floor_3_jump_scare_door) 1.0) 1)
	(cs_fly_to_object_marker floor_3_jump_scare_door "monitor_loc_b")
	(cs_fly_to pts_343_library_e/init)
	(set s_vo_progress_c20 68)
)

(script dormant 343_library_e
	(sleep_until (volume_test_players tv_act_343_library_f3) 1)
	(if (game_is_cooperative) (object_create_folder fold_coop_floor3_a))
	(cs_queue_command_script ai_monitor cs_343_library_e)
	; monitor error handling
	; there are two doors with a variable time breakable door in between
	; first door
	(if (not (f_monitor_opperated_device floor_3_doorhalfopen_normal 30))
		(begin
			(print "error: monitor failed to open floor_3_doorhalfopen_normal")
			(f_door_try_open dm_sec_door_f3_2_fx floor_3_doorhalfopen_normal)
		)
	)
	; breakable blood gate door
	(sleep_until (>= (device_get_position f3_lib_f_breakin_door_device) 1) 1)
	; second door
	(if (f_monitor_opperated_device floor_3_door_normal_end 120)
		(sleep_forever) ; doors opened
	)
	(f_door_try_open dm_sec_door_f3_3_fx floor_3_door_normal_end)
	(f_place_monitor sq_monitor/spawnpoint_d_arena)
	(print "error: monitor failed to open floor_3_door_normal_end")
)

(script command_script cs_343_library_e
	(sleep_until (= s_vo_progress_c20 69) 1) ; waits for dialogue vo_floor3_centercorridorc to finish
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to_object_marker floor_3_doorhalfopen_normal "monitor_loc_a")
	(cs_face_object true dm_sec_door_f3_2_fx)
	(f_door_try_open dm_sec_door_f3_2_fx floor_3_doorhalfopen_normal)
	(cs_face_object false dm_sec_door_f3_2_fx)
	(sleep_until (>= (device_get_position floor_3_doorhalfopen_normal) 0.25) 1)
	(print "attempt checkpoint save...")
	(f_game_save) ; pre library_f (sometimes miss labeled)
	(cs_fly_to_object_marker floor_3_doorhalfopen_normal "monitor_loc_b")
	(cs_fly_to pts_343_library_e/p2)
	(cs_fly_to pts_343_library_e/p3)
	(cs_fly_to pts_343_library_e/p4)
	(cs_fly_to pts_343_library_e/p5)
	(cs_fly_to pts_343_library_e/p6)
	(cs_fly_to pts_343_library_e/p7)
	(cs_fly_to pts_343_library_e/p8)
	(cs_fly_to pts_343_library_e/p9)
	(cs_fly_to pts_343_library_e/p10)
	(cs_fly_to pts_343_library_e/p11)
	(cs_fly_to pts_343_library_e/p12)
	(cs_fly_to pts_343_library_e/p13)
	(cs_fly_to pts_343_library_e/p14)
	(cs_fly_to pts_343_library_e/p15)
	(cs_fly_to pts_343_library_e/p16)
	(f_monitor_breakable_door_pause f3_lib_f_breakin_door_device)
	(cs_fly_to pts_343_library_e/p17)
	(cs_fly_to pts_343_library_e/p18)
	(cs_fly_to pts_343_library_e/p19)
	(cs_fly_to pts_343_library_e/p20)
	(cs_fly_to pts_343_library_e/p21)
	(cs_fly_to_object_marker floor_3_door_normal_end "monitor_loc_a")
	(cs_face_object true dm_sec_door_f3_3_fx)
	(f_door_try_open dm_sec_door_f3_3_fx floor_3_door_normal_end)
	(cs_face_object false dm_sec_door_f3_3_fx)
	(sleep_until (>= (device_get_position floor_3_door_normal_end) 0.25) 1)
	(cs_fly_to_object_marker floor_3_door_normal_end "monitor_loc_b")
	(cs_fly_to pts_343_large_room_b_door/wait)
)


(script dormant 343_large_room_b
	(sleep_until (volume_test_players tv_act_large_room_b) 1)
	(set b_343_away false)
	(print "attempt checkpoint save...")
	(f_game_save) ; pre wave fight 4 - shaft door 3
	(cs_queue_command_script ai_monitor cs_343_large_room_b)
	(sleep (game_ticks_from_seconds 4))
	; monitor error handling
	; if the monitor does not reach door zone, respawn
	(if (not (f_monitor_arrived tv_beat_3_shutdown_mid_safe 30.0))
		(begin
			(print "error: monitor failed to arrive")
			(f_place_monitor sq_monitor_l_room_b_rec_pre)
			(cs_queue_command_script ai_monitor cs_343_large_room_b)
		)
	)
	(sleep_until b_door_fight_cleared 1)
	; if the monitor does not open the door, unblock player and restart monitor
	(if (f_monitor_opperated_device floor_3_arena_entrance 30) (sleep_forever ))
	(f_door_try_open dm_sec_door_f3_4_fx floor_3_arena_entrance)
	(f_place_monitor sq_monitor_l_room_b_rec_pre)
	(set b_343_away false)
	(print "error: monitor failed to open the door")
	(print "attempt checkpoint save...")
	(f_game_save) ; failsafe post wave fight 4 - shaft door 3
)

; running in fall back montior placement script
(script command_script cs_343_large_room_b_fix
	; (cs_fly_to pts_343_large_room_b_door/p4)
	(cs_fly_to pts_343_large_room_b_door/p5)
	(cs_fly_to pts_343_large_room_b_door/p6)
	(cs_fly_to pts_343_large_room_b_door/wait)
)

(script command_script cs_343_large_room_b
	(cs_fly_to_object_marker floor_3_arena_entrance "monitor_loc_a")
	(wake beat_3_mid_shutdown)
	(cs_face_object true dm_sec_door_f3_4_fx)
	(f_door_try_fail dm_sec_door_f3_4_fx)
	(cs_face_object false dm_sec_door_f3_4_fx)
	(f_unblip_flag fl_nav_library_f_large_door_3)
	(set s_vo_progress_c20 70)
	(cs_fly_to pts_343_large_room_b_door/p0)
	(f_hud_obj_new_noblock obj_c20_survivedoor)
	(set b_343_away true)
	(cs_fly_to pts_343_large_room_b_door/p1)
	(cs_fly_to pts_343_large_room_b_door/p2)
	(cs_pause 4)
	(sleep_until b_door_fight_cleared 1)
	(f_hud_obj_complete_noblock)
	(set b_343_away false)
	(cs_teleport pts_343_large_room_b_door/p4 pts_343_large_room_b_door/p5)
	(cs_fly_to pts_343_large_room_b_door/p5)
	(cs_fly_to pts_343_large_room_b_door/p6)
	(set s_vo_progress_c20 71)
	(cs_fly_to_object_marker floor_3_arena_entrance "monitor_loc_a")
	(cs_face_object true dm_sec_door_f3_4_fx)
	(f_door_try_open dm_sec_door_f3_4_fx floor_3_arena_entrance)
	(cs_face_object false dm_sec_door_f3_4_fx)
	(print "attempt checkpoint save...")
	(f_game_save) ; post wave fight 4 - shaft door 3
	(sleep_until (>= (device_get_position floor_3_arena_entrance) 0.25) 1)
	(f_hud_obj_new_noblock obj_c20_restorelight)
	(cs_fly_to_object_marker floor_3_arena_entrance "monitor_loc_b")
	(cs_fly_to pts_343_large_room_b/p0)
	(cs_fly_to pts_343_large_room_b/p1)
	(cs_fly_to pts_343_large_room_b/p2)
	(cs_fly_to pts_343_large_room_b/p3)
	(cs_fly_to pts_343_large_room_b/wait)
)

(script dormant 343_to_lift3
	(sleep_until (volume_test_players tv_act_343_to_lift3) 1)
	(cs_queue_command_script ai_monitor cs_343_to_lift3)
	; monitor error handling
	; if the door doesn't open, unblock player and restart monitor
	(if (f_monitor_opperated_device floor_3_arena_exit 30) (sleep_forever))
	(f_door_try_open dm_sec_door_f3_5_fx floor_3_arena_exit)
	(f_place_monitor sq_monitor/spawnpoint_d_lift)
	(print "error: monitor failed to open the door")
)

(script command_script cs_343_to_lift3
	(cs_fly_to pts_343_large_room_b/p5)
	(cs_fly_to pts_343_large_room_b/p6)
	(cs_fly_to_object_marker floor_3_arena_exit "monitor_loc_a")
	(set s_vo_progress_c20 80)
	(cs_face_object true dm_sec_door_f3_5_fx)
	(f_door_try_open dm_sec_door_f3_5_fx floor_3_arena_exit)
	(cs_face_object false dm_sec_door_f3_5_fx)
	(sleep_until (>= (device_get_position floor_3_arena_exit) 0.25) 1)
	(f_hud_obj_new_noblock obj_c20_elevator3)
	(cs_fly_to_object_marker floor_3_arena_exit "monitor_loc_b")
	(cs_fly_to pts_343_large_room_b/p7)
)

(script dormant 343_beat_3_outro
	(sleep_until (volume_test_players tv_act_lift3) 1)
	(cs_queue_command_script ai_monitor cs_343_beat_3_outro)
)

(script command_script cs_343_beat_3_outro
	(cs_fly_to pts_343_beat_3_outro/p0)
	(cs_fly_to pts_343_beat_3_outro/p1)
	(cs_fly_to pts_343_beat_3_outro/p2)
	(ai_erase ai_current_actor)
)

;====================================================================================================================================================================================================
; c20 beat 4 monitor
;====================================================================================================================================================================================================
(script dormant 343_hallway_e
	(sleep_until (volume_test_players tv_act_343_hallway_e) 1)
	(if (game_is_cooperative) (object_create_folder fold_coop_floor4))
	(set s_split_dir 0)
	(print "attempt checkpoint save...")
	(f_game_save) ; beat 4 start
	(cs_queue_command_script ai_monitor cs_343_hallway_e_init)
	(sleep_until (not (cs_command_script_running ai_monitor cs_343_hallway_e_init)) 1)
	(sleep_until
		(begin
			(f_monitor_choose_cs_by_player_distance_to_point pts_343_hallway_e_clock/p3 cs_343_hallway_e_clock pts_343_hallway_e_counter/p3 cs_343_hallway_e_counter)
			(not (volume_test_players_all tv_hallway_e_split)) ; exit
		)
		1
	)
	(sleep_until (volume_test_players tv_act_hallway_door_e_op) 1)
	(wake send_lift_3_away)
	(cs_queue_command_script ai_monitor cs_343_hallway_e_door)
	(sleep (game_ticks_from_seconds 4))
	; monitor error handling
	; if the monitor does not reach away destination, activate the encounter
	(if (not (f_monitor_arrived tv_hall_e_343_wait 40))
		(begin
			(set b_343_away true)
			(print "error: monitor failed to leave")
		)
	)
	(sleep_until b_door_fight_cleared 1)
	; if the monitor does not open the door, unblock player and restart monitor
	(if (f_monitor_opperated_device floor_4_door_last_room 45) (sleep_forever ))
	(f_door_try_open dm_sec_door_f4_1_fx floor_4_door_last_room)
	(f_place_monitor sq_monitor_final_recovery)
	(set b_343_away false)
	(print "error: monitor failed to open the door")
)

; exists just incase players are in the elevator when this battle starts, because we need to move it for pathing reasons
(script dormant send_lift_3_away
	(device_set_position elevator_3 0)
	(sleep_until (<= (device_get_position elevator_3) 0.5) 1)
	(print "push co-op players 343_hallway_e")
	(volume_teleport_players_not_inside tv_beat_4_coop_safe fl_coop_lift_3)
)

(script command_script cs_343_hallway_e_init
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set s_split_dir 0)
	(cs_fly_to pts_343_hallway_e_counter/p0)
	(f_hud_obj_new_noblock obj_c20_explore)
)

(script command_script cs_343_hallway_e_clock
	; (print "monitor clockwise")
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set s_split_dir 1)
	(cs_fly_to pts_343_hallway_e_clock/p1)
	(cs_fly_to pts_343_hallway_e_clock/p2)
	(sleep_until (not (volume_test_players_all tv_hallway_e_split)) 1)
	(cs_fly_to pts_343_hallway_e_clock/p3)
	(sleep_until (volume_test_players tv_hallway_e_rejoin) 1)
	(cs_fly_to pts_343_hallway_e_clock/p4)
	(cs_fly_to pts_343_hallway_e_clock/p5)
)

(script command_script cs_343_hallway_e_counter
	; (print "monitor counterclockwise")
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set s_split_dir -1)
	(cs_fly_to pts_343_hallway_e_counter/p1)
	(cs_fly_to pts_343_hallway_e_counter/p2)
	(sleep_until (not (volume_test_players_all tv_hallway_e_split)) 1)
	(cs_fly_to pts_343_hallway_e_counter/p3)
	(sleep_until (volume_test_players tv_hallway_e_rejoin) 1)
	(cs_fly_to pts_343_hallway_e_counter/p4)
	(cs_fly_to pts_343_hallway_e_counter/p5)
)

(script command_script cs_343_hallway_e_door
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(set b_343_away false)
	(cs_fly_to_object_marker floor_4_door_last_room "monitor_loc_a")
	(cs_face_object true dm_sec_door_f4_1_fx)
	(f_door_try_fail dm_sec_door_f4_1_fx)
	(cs_face_object false dm_sec_door_f4_1_fx)
	(print "attempt checkpoint save...")
	(f_game_save) ; pre wave fight 5 - vent door 2
	(set s_vo_progress_c20 90)
	(f_unblip_flag fl_nav_centerroom_a)
	(cs_fly_to pts_343_hallway_e_door/p1)
	(cs_fly_to pts_343_hallway_e_door/p2)
	(cs_fly_to pts_343_hallway_e_door/p3)
	(cs_fly_to pts_343_hallway_e_door/p4)
	(set b_343_away true)
	(f_hud_obj_new_noblock obj_c20_surviveindex)
	(cs_teleport pts_343_hallway_e_door/wait pts_343_hallway_e_door/door_a)
	(sleep (game_ticks_from_seconds 4))
	(sleep_until b_door_fight_cleared 1)
	(f_hud_obj_complete_noblock)
	(cs_teleport pts_343_hallway_e_door/p4 pts_343_hallway_e_door/p3)
	(cs_fly_to pts_343_hallway_e_door/p3)
	(cs_fly_to pts_343_hallway_e_door/p2)
	(cs_fly_to pts_343_hallway_e_door/p1)
	(cs_fly_to_object_marker floor_4_door_last_room "monitor_loc_a")
	(cs_face_object true dm_sec_door_f4_1_fx)
	(set b_opening_final_door true)
	(f_door_try_open dm_sec_door_f4_1_fx floor_4_door_last_room)
	(cs_face_object false dm_sec_door_f4_1_fx)
	(sleep_until (>= (device_get_position floor_4_door_last_room) 0.5) 1)
	(f_hud_obj_new_noblock obj_c20_index)
	(cs_fly_to_object_marker floor_4_door_last_room "monitor_loc_b")
	(cs_fly_to pts_343_hallway_e_door/final)
)

; ====================================================================================
; navpoints
; ====================================================================================

(global cutscene_flag last_blip_flag fl_nav_library_a_switch_1)

(script static void (f_blip_one (cutscene_flag f) (short type))
	(f_unblip_flag last_blip_flag)
	(f_blip_flag f type)
	(set last_blip_flag f)
)

;floor 1 - library a
(script dormant floor_1_library_a_nav_control
	(sleep_until
		(or
			(> (device_get_position floor_1_door_right) 0) ;player has already opened first big door
			(= b_told_of_transit_lift 1) ;when guilty tells the player where to go
		)
	)

	;nav 1
	(if (= (device_get_position floor_1_door_right) 0) ;blip switch if first big door is still closed
		;then
		(begin
			(f_blip_one fl_nav_library_a_switch_1 0)
			(print "fl_nav_library_a_switch_1 blipped")
		)
		;else
		(print "first switch not needed to be blipped")
	)
	(sleep_until (= (device_get_position floor_1_door_right) 1) 1)

	;nav 2 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_a_door_1 0)
	;(sleep_until (volume_test_players tv_navend_library_a_door_1) 1)

	;nav 3 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_a_hall_1 0)
	;(sleep_until (volume_test_players tv_navend_library_a_hall_1) 1)

	;nav 4 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_a_door_2 0)
	;(sleep_until (volume_test_players tv_navend_library_a_door_2) 1)

	;nav 5
	(f_blip_one fl_nav_library_a_door_3 0)
	(sleep_until (volume_test_players tv_navend_library_a_door_3) 1)

	;nav 6 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_a_hall_2 0)
	;(sleep_until (volume_test_players tv_navend_library_a_hall_2) 1)

	;nav 7 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_a_hall_3 0)
	;(sleep_until (volume_test_players tv_navend_library_a_hall_3) 1)

	;nav 8
	(f_blip_one fl_nav_library_a_u_turn 0)
	(sleep_until (volume_test_players tv_navend_library_a_u_turn) 1)

	;nav 9 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_a_hall_4 0)
	;(sleep_until (volume_test_players tv_navend_library_a_hall_4) 1)

	;nav 10 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_a_hall_5 0)
	;(sleep_until (volume_test_players tv_navend_library_a_hall_5) 1)

	;nav 11 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_a_door_4 0)
	;(sleep_until (volume_test_players tv_navend_library_a_door_4) 1)

	;nav 12
	(f_blip_one fl_nav_library_a_switch_2 0)
)

;floor 1 - from end of library a to lift a
(script dormant floor_1_to_lift_a_nav_control
	(sleep_until
		(or
			(= (device_get_position floor_1_door_right_end_closed) 1)
			(volume_test_players tv_nav_smallroom_b)
		)
		1
	)

	;nav 1
	(f_blip_one fl_nav_smallroom_b 0)

	;nav 2
	(sleep_until (= (device_get_position floor_1_middle_entrance_door) 1) 1)
	(f_blip_one fl_nav_smalltunnel_a 0)
	(sleep_until (volume_test_players tv_navend_smalltunnel_a) 1)

	;nav 3
	(f_blip_one fl_nav_largehallway_a 0)
	(sleep_until (volume_test_players tv_navend_largehallway_a) 1)

	;nav 4
	(f_blip_one fl_nav_floor1_lift_a 0)
	(sleep_until (> (device_get_position elevator_1) 0) 1) ;sleep until the elevator starts moving down
	(f_unblip_flag last_blip_flag)

)

;floor 2 - from lift a to library d
(script dormant floor_2_to_library_d_nav_control
	(sleep_until
		(or
			(= (device_get_position elevator_1) 1) ;sleep until the elevator reaches the bottom
			(volume_test_players tv_nav_bottom_lift_a) ;sleep until the player enters the bottom tv
		)
		1
	)

	;nav 1
	(f_blip_one fl_nav_largehallway_b 0)
	(sleep_until (volume_test_players tv_navend_largehallway_b) 1)

	;nav 2
	(f_blip_one fl_nav_centercorridor_b 0)

)

;floor 2 - library d
(script dormant floor_2_library_d_nav_control
	(sleep_until (> (device_get_position floor_2_stacks_entrance_door) 0) 1);sleep until the door opens

	;nav 1
	(f_blip_one fl_nav_library_d_switch_1 0)
	(sleep_until (= (device_get_position floor_2_door_right) 1) 1)

	;nav 2
	(f_blip_one fl_nav_library_d_door_1 0)
	(sleep_until (volume_test_players tv_navend_library_d_door_1) 1)

	;nav 3 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_d_hall_1 0)
	;(sleep_until (volume_test_players tv_navend_library_d_hall_1) 1)

	;nav 4
	(f_blip_one fl_nav_library_d_door_2 0)
	(sleep_until (volume_test_players tv_navend_library_d_door_2) 1)

	;nav 5 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_d_door_3 0)
	;(sleep_until (volume_test_players tv_navend_library_d_door_3) 1)

	;nav 6
	(f_blip_one fl_nav_library_d_door_4 0)
	(sleep_until (volume_test_players tv_navend_library_d_door_4) 1)

	;nav 7 removed - the next nav marker is only about 10m away
	;(f_blip_one fl_nav_library_d_door_5 0)
	;(sleep_until (volume_test_players tv_navend_library_d_door_5) 1)

	;nav 8
	(f_blip_one fl_nav_library_d_switch_2 0)
	(sleep_until (= (device_get_position floor_2_door_right_end) 1) 1) ;sleep until the door opens

	;nav 9
	(f_blip_one fl_nav_smallroom_c 0)
)

;floor 2 - from end of library d to lift b
(script dormant floor_2_end_library_d_to_lift_b
	(sleep_until (volume_test_players tv_navend_smallroom_c) 1)

	;nav 1
	(f_blip_one fl_nav_largeroom_a_switch_1 0)
	(sleep_until (= (device_get_position light_bridge_a) 1) 1)

	;nav 2
	(f_blip_one fl_nav_smallroom_d 0)
	(sleep_until (> (device_get_position floor_2_middle_exit_door) 0) 1)

	;nav 3
	(f_blip_one fl_nav_floor2_lift_b 0)
	(sleep_until (> (device_get_position elevator_2) 0) 1) ;sleep until the elevator starts moving down
	(f_unblip_flag last_blip_flag)

)

;floor 3 - from lift b to library f
(script dormant floor_3_lift_b_to_library_f_nav_control
	(sleep_until
		(or
			(= (device_get_position elevator_2) 1) ;sleep until the elevator reaches the bottom
			(volume_test_players tv_nav_bottom_lift_b) ;sleep until the player enters the bottom tv
		)
		1
	)

	;nav 1
	(f_blip_one fl_nav_largehallway_c_start 0)
	(sleep_until (volume_test_players tv_navend_largehallway_c_start) 1)

	;nav 2
	(f_blip_one fl_nav_largehallway_c_mid 0)
	(sleep_until (volume_test_players tv_navend_largehallway_c_mid) 1)

	;nav 3
	(f_blip_one fl_nav_centercorridor_c 0)

)

;floor 3 - library f (non-legendary)
(script dormant floor_3_library_f_nav_control
	(sleep_until (volume_test_players tv_act_343_jump_scare) 1)
	(sleep_until (>= (device_get_position floor_3_jump_scare_door) 1) 1) ;sleep until the door opens

	;nav 1
	(f_blip_one fl_nav_library_f_large_door_1 0)
	(sleep_until (>= (device_get_position floor_3_doorhalfopen_normal) 1) 1) ;sleep until the door opens

	;nav 2 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_f_door_1 0)
	;(sleep_until (volume_test_players tv_navend_library_f_door_1) 1)

	;nav 3 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_f_hall_1 0)
	;(sleep_until (volume_test_players tv_navend_library_f_hall_1) 1)

	;nav 4
	(f_blip_one fl_nav_library_f_hall_2 0)
	(sleep_until (volume_test_players tv_navend_library_f_hall_2) 1)

	;nav 5 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_f_hall_3 0)
	;(sleep_until (volume_test_players tv_navend_library_f_hall_3) 1)

	;nav 6 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_f_door_2 0)
	;(sleep_until (volume_test_players tv_navend_library_f_door_2) 1)

	;nav 7
	(f_blip_one fl_nav_library_f_door_3 0)
	(sleep_until (volume_test_players tv_navend_library_f_door_3) 1)

	;nav 8 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_f_hall_4 0)
	;(sleep_until (volume_test_players tv_navend_library_f_hall_4) 1)

	;nav 9 <<< removing this as there's too many breadcrumbs
	;(f_blip_one fl_nav_library_f_door_4 0)
	;(sleep_until (volume_test_players tv_navend_library_f_door_4) 1)

	;nav 10
	(f_blip_one fl_nav_library_f_large_door_2 0)
	(sleep_until (= (device_get_position floor_3_door_normal_end) 1) 1) ;sleep until the door opens

	;nav 11
	(f_blip_one fl_nav_library_f_large_door_3 0)
)

;floor 3 - largeroom b to lift a
(script dormant floor_3_largeroom_b_to_lift_a_nav_control
	(sleep_until (= (device_get_position floor_3_door_normal_end) 1) 1) ;sleep until the door opens

	;nav 1
	(f_blip_one fl_nav_library_f_large_door_3 0)
	(sleep_until (= (device_get_position floor_3_arena_entrance) 1) 1) ;sleep until the door opens

	;nav 2 removing - want players not guided to switches in light puzzle room
	;(f_blip_one fl_nav_largeroom_b_switch_1 0)
	;(sleep_until (= (device_get_position light_bridge_d) 1) 1) ;sleep until bridge is activated

	;nav 3 removing - want players not guided to switches in light puzzle room
	;(f_blip_one fl_nav_largeroom_b_switch_2 0)
	;(sleep_until (= (device_get_position light_bridge_e) 1) 1) ;sleep until bridge is activated

	;nav 4
	(f_blip_one fl_nav_largeroom_b_plat_1 0)
	;(sleep_until (= (device_get_position light_bridge_f) 1) 1) ;sleep until bridge is activated
	(sleep_until (volume_test_players tv_navend_largeroom_b_plat_1) 1)

	;nav 5
	(f_blip_one fl_nav_largeroom_b_plat_2 0)
	;(sleep_until (= (device_get_position light_bridge_g) 1) 1) ;sleep until bridge is activated
	(sleep_until (volume_test_players tv_navend_largeroom_b_plat_2) 1)

	;nav 6
	(f_blip_one fl_nav_largeroom_b_plat_3 0)
	(sleep_until (volume_test_players tv_navend_largeroom_b_plat_3) 1)

	;nav 7
	(f_blip_one fl_nav_largeroom_b_plat_4 0)
	(sleep_until (volume_test_players tv_navend_largeroom_b_plat_4) 1)

	;nav 8 - removed: there's another nav marker right after this.
;	(f_blip_one fl_nav_largeroom_b_exit 0)
;	(sleep_until (= (device_get_position floor_3_arena_exit) 1) 1) ;sleep until the door opens

	;nav 9
	(f_blip_one fl_nav_floor_3_lift_a 0)
	(sleep_until (> (device_get_position elevator_3) 0) 1) ;sleep until the elevator starts moving down
	(f_unblip_flag last_blip_flag)

)

;floor 4 - from lift a to center room a
(script dormant floor_4_lift_a_to_centerroom_a_nav_control
	(sleep_until
		(or
			(= (device_get_position elevator_3) 1) ;sleep until the elevator reaches the bottom
			(volume_test_players tv_nav_floor_4_bottom_lift_a) ;sleep until the player enters the bottom tv
		)
		1
	)

	;nav 1
	(f_blip_one fl_nav_largehallway_e 0)
	(sleep_until (volume_test_players tv_navend_largehallway_e) 1)

	;nav 2
	(f_blip_one fl_nav_centerroom_a 0)


	;nav 3
	(sleep_until b_door_fight_cleared 1) ; until fight finishes
	(f_blip_one fl_nav_icon 0)

)

;====================================================================================================================================================================================================
; utility funcitons
;====================================================================================================================================================================================================
(script command_script cs_focus_on_player
	(ai_prefer_target_team ai_current_actor player)
)

(script command_script cs_die_at_place
	(ai_kill_silent ai_current_actor)
)

(script static ai (f_place_monitor (ai monitor_instance))
	(ai_erase ai_monitor)
	(ai_place monitor_instance)
	(set ai_monitor monitor_instance)
	(ai_cannot_die ai_monitor true)
	(object_cannot_take_damage (ai_actors ai_monitor))
	; (f_blip_ai ai_monitor 1) ; for debug
	; (ai_erase ai_monitor)
	ai_monitor
)

(script static void (f_run_command_script_if_new (ai ai_target) (ai_command_script cs_new))
	(if (not (cs_command_script_attached ai_target cs_new))
		(cs_run_command_script ai_target cs_new)
	)
)

(script static void (f_final_chapter)
	; the three chapters were designed to spool out in legacy
	; that's now done through the chapter title data in blamscenario, with automatic timing
	(f_hud_chapter_slow chapter_c20_3_left)
)

; did the monitor arrive within the time allowed
(script static boolean (f_monitor_arrived (trigger_volume arrival_volume) (real fail_seconds))
	;(set max_flight_ticks (game_ticks_from_seconds fail_seconds))
	(sleep_until
		(volume_test_objects arrival_volume ai_monitor)
		1
		(game_ticks_from_seconds fail_seconds)
	)
	(volume_test_objects arrival_volume ai_monitor)
)

(script static boolean (f_monitor_opperated_device (device target_device) (real fail_seconds))
	(sleep_until
		(> (device_get_position target_device) 0)
		1
		(game_ticks_from_seconds fail_seconds)
	)
	(> (device_get_position target_device) 0)
)

; if the door is closed when the monitor arrives, wait until it is open then give roomn for break to breath
(script static void (f_monitor_breakable_door_pause (device target_device))
	(if (< (device_get_position target_device) 0.5)
		(begin
			(sleep_until (> (device_get_position target_device) 0.5) 1)
			(sleep (game_ticks_from_seconds 4.0))
		)
	)
)

; if p0 is closest switch to cs0, it p1 is closest switch to cs1
; if the correct script is running don't switch
; if a switch happens then delay to avoid thrashing
(script static void (f_monitor_choose_cs_by_player_distance_to_point (point_reference p0) (ai_command_script cs0) (point_reference p1) (ai_command_script cs1))
	(if (<= (objects_distance_to_point (players) p0) (objects_distance_to_point (players) p1))
		(if (not (cs_command_script_attached ai_monitor cs0))
			; switch to cs0
			(begin
				(cs_run_command_script ai_monitor cs0)
				(sleep (game_ticks_from_seconds 0.33))
			)
		)
		(if (not (cs_command_script_attached ai_monitor cs1))
			; switch to cs1
			(begin
				(cs_run_command_script ai_monitor cs1)
				(sleep (game_ticks_from_seconds 0.33))
			)
		)
	)
)

(script static void (f_door_try_fail (device dm_fx))
	(print "343 door vignette: attempts to open door, but it will fail")
	(sleep 10); for turn time
	(device_set_position_immediate dm_fx r_door_try_1_dm_pos)
	(sleep (game_ticks_from_seconds r_door_try_1_delay))
	(print "343 door vignette: fails to open door")
	(device_set_position_immediate dm_fx r_door_fail_dm_pos)
	(sleep (game_ticks_from_seconds r_door_fail_delay))
)

(script static void (f_door_try_open (device dm_fx) (device dm_door))
	(print "343 door vignette: attempts to open door and it will succeed")
	(sleep 10); for turn time
	(device_set_position_immediate dm_fx r_door_try_2_dm_pos)
	(sleep (game_ticks_from_seconds r_door_try_2_delay))
	(print "343 door vignette: opens door")
	(device_set_position_immediate dm_fx r_door_open_dm_pos)
	(sleep (game_ticks_from_seconds r_door_open_delay))
	(device_set_position dm_door 1)
)

(script static void (f_door_fail (device dm_fx))
	(print "343 door vignette: attempts to open a broken door")
	(sleep 10); for turn time
	(device_set_position_immediate dm_fx r_door_try_1_dm_pos)
	(sleep (game_ticks_from_seconds r_door_try_1_delay))
	(print "343 door vignette: gives up opening the door")
	(device_set_position_immediate dm_fx r_door_fail_dm_pos)
	(sleep (game_ticks_from_seconds r_door_fail_delay))
)

(script static real (f_ai_living_weight_count (ai ai_val))
	(+ (/ (ai_swarm_count ai_val) 5) (ai_nonswarm_count ai_val))
)

(script static void (f_hud_obj_new_noblock (user_interface_objective uio_new_obj))
	(set uio_cur_obj uio_new_obj)
	(wake update_c20_objective)
)

(script continuous update_c20_objective
	(sleep_forever)
	(f_hud_obj_new uio_cur_obj uio_cur_obj)
)

(script static void (f_hud_obj_complete_noblock)
	(wake complete_c20_objective)
)

(script continuous complete_c20_objective
	(sleep_forever)
	(sleep (game_ticks_from_seconds 2.0))
	(f_hud_obj_complete)
)

; blood gate blipping
; the encounter kicks off this logic and passes a group to be tracked.
(global ai ai_flood_blip_group none)
; (global real r_last_flood_count 0)
(global real r_last_swarm_count 0)
(global real r_last_nonswarm_count 0)

; used to initialize and enable the looping script
(script static void (f_flood_group_blip_gate (ai ai_group))
	(set ai_flood_blip_group ai_group)
	(set r_last_swarm_count 0)
	(set r_last_nonswarm_count 0)
	(wake flood_group_blip_gate)
)

(script continuous flood_group_blip_gate
	(sleep_forever)
	(sleep (game_ticks_from_seconds 3.0))
	; don't start bliping flood until the count is 3 or less
	(sleep_until
		(or
			(<= (f_ai_living_weight_count ai_flood_blip_group) 3)
			b_door_fight_cleared
		)
	1)
	; this algorithm re-blips if the count of swarm or biped inscreases.
	; this can happen when cariers spawn swarm or swarm resurect biped
	(if (not b_door_fight_cleared)
		(sleep_until
			(begin
				(if
					(or
						(> (ai_swarm_count ai_flood_blip_group) r_last_swarm_count)
						(> (ai_nonswarm_count ai_flood_blip_group) r_last_nonswarm_count)
					) ; if either number increases re-blip
					(f_blip_ai ai_flood_blip_group 1)
				)
				(set r_last_swarm_count (ai_swarm_count ai_flood_blip_group))
				(set r_last_nonswarm_count (ai_nonswarm_count ai_flood_blip_group))
				b_door_fight_cleared ; stop this process when the door fight is cleared
			)
		)
	)
	(f_unblip_ai ai_flood_blip_group) ; sometimes we end fight even if there are non-zero straglers
)


; error hacks

(script command_script cs_right_path_3_forward
	(sleep 1) ; no op for compile
)
(script command_script cs_right_path_1
	(sleep 1) ; no op for compile
)


(script dormant lift3_test
		(device_set_position_immediate elevator_3 50)
)

; hs:begin (f_debug_open_sec_door value)
(script static void (f_debug_open_sec_door (real r_open))
	(device_set_position floor_1_middle_entrance_door r_open)
	(device_set_position floor_2_stacks_entrance_door r_open)
)

; (script command_script cs_flood_banger
; 	(sleep_until
; 		(begin
; 			(cs_custom_animation objects\characters\floodcombat_human\floodcombat_human "m52:unarmed:melee_glass:var1" true)
; 			false
; 		)
; 	60) ; loop every two seconds
; )
