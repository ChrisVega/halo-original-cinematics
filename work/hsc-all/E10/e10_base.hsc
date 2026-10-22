;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;================================================== e10 - base script  ==============================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================


;====================================================================================================================================================================================================
; global vars ==============================================================================================================================================
;====================================================================================================================================================================================================

;every global variable used in the scripts
(global ai ai_johnson none)
(global boolean b_go_to_edge_ignore_player false)
(global boolean b_go_to_edge false)
(global boolean b_spreadout false)
(global boolean b_debug_gameplay true)
(global boolean b_geneforge_ll_wv1_complete false)
(global boolean b_encounter_5_complete false)
;(global boolean b_first_augmented_brute_killed false)
(global boolean b_first_augmented_dies false)
(global boolean b_encounter_15_wv1_complete false)
(global boolean b_stasis_chamber_cleared false)
;(global boolean b_prophet_angry_callouts false)
(global boolean b_beat_4_johnson_spawned false)
(global boolean b_path_forward_is_open false)
(global boolean b_backtracking_through_level false)
(global boolean b_johnson_combat_dojo_time false)
(global boolean b_johnson_opendoor_tf false)
(global boolean b_johnson_takes_high_ground false)
(global boolean b_gr_initial_wave_dead false)
(global boolean b_first_time_entry_tf false)
(global boolean b_chief_in_airlock false)
(global boolean b_chief_dawdles_in_rr_lower false)
(global boolean b_dojo_spec_ops_are_dead false)
(global boolean b_johnson_says_done false)
(global boolean b_johnson_can_trigger_gb false)
(global boolean b_johnson_first_hack_complete false)
(global boolean b_johnson_at_first_post false)
(global boolean b_johnson_sees_cov_combat false)
(global boolean b_johnson_is_in_dojo false)
(global boolean b_johnson_in_position_ff false)
(global boolean b_dojo_specops_can_kill false)
(global boolean b_johnson_is_through_airlock false)
(global boolean b_johnson_hacked_grav_bridge false)
(global boolean b_johnson_hacked_hanger_lift false)
(global boolean b_hanger_12_oclock_has_spawned false)
(global boolean b_geneforge_ll_wv1_otr false)
(global boolean b_geneforge_ll_wv2_otr false)
(global boolean b_geneforge_ll_wv3a_otr false)
(global boolean b_geneforge_ll_wv3b_otr false)
(global boolean b_hanger_hunters_begin false)
(global boolean b_somethings_moving_on_sand false)
(global boolean b_ambush_cinematic_concludes false)
(global boolean b_geneforge_ambush_ends false)
(global boolean b_tf_ambush_ends false)
(global boolean b_final_wave_attacks false)
(global boolean b_final_wave_eliminated false)
(global boolean b_let_the_games_begin false)
(global boolean b_chief_to_glr false)
(global boolean b_combat_in_dojo_is_go false)
(global boolean b_johnson_goto_huntertown false)
(global boolean b_goto_lowerlab_upperlevel false)
(global boolean b_gravlift_to_final_enabled false)
(global boolean b_johnson_is_ready false)
;(global boolean b_johnson_prepares_the_hack false)
(global boolean b_johnson_has_hacked_ff false)
(global boolean b_johnson_can_leave_hangar false)
(global boolean b_player_has_crossed_gb false)
(global short s_hallway_to_sf_control 0)
(global short s_geneforge_ll_control_var 0)
(global short s_rr_check_for_final_wave 0)
(global short s_johnson_zone_genforge_ll 0)
(global short s_johnson_final_encounter 0)
(global short s_music_trigger_e10 0)
(global short s_johnson_hanger_point_checker 0)
(global short s_johnson_rr_point_checker 0)
(global short s_tf_monster_door_control 0)

;====================================================================================================================================================================================================
; default_save_loop ==============================================================================================================================================
;====================================================================================================================================================================================================
; (script startup default_save_loop
; 	(wake f_debug_global_save_loop)
; )

;====================================================================================================================================================================================================
; objectives ================================================================================================================================================
;====================================================================================================================================================================================================


; beat 1 - level start
(script dormant trigger_obj_signals
	(f_hud_obj_new "obj_signals" "obj_signals")
)

; beat 3 - find the command center
(script dormant trigger_obj_geneforge_ll
	(f_hud_obj_new "obj_geneforge_ll" "obj_geneforge_ll")
)

; beat 4 - survive the brute onslaught
(script dormant trigger_obj_geneforge_survive
	(f_hud_obj_new "obj_geneforge_survive" "obj_geneforge_survive")
)

; beat 4 - revisit the testing facility
(script dormant trigger_obj_facility_revisit
	(f_hud_obj_new "obj_facility_revisit" "obj_facility_revisit")
)

; beat 4 - get to the generforge upper level
(script dormant trigger_obj_geneforge_ul
    (sleep_until (volume_test_players tv_objective_geneforge_ul) 1)
	(set b_chief_to_glr true)
	(f_hud_obj_new "obj_geneforge_ul" "obj_geneforge_ul")
	(f_unblip_all) ;remove all navpoints
	(f_blip_flag fl_glr_entry 0)
)


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 											e20 - chapter titles
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; beat 1
(script dormant trigger_chapter_one
	(f_hud_chapter chapter_e10_1)
	(wake trigger_obj_signals)
	(submit_incident_with_custom_string_id "game_activity_begin" "e10")
)

; beat 2
(script dormant trigger_chapter_two
	(f_hud_chapter chapter_e10_2)
)
; trigger chapter 2
(script dormant trigger_chapter_title_two
	(sleep_until (volume_test_players tv_trigger_chapter_two) 1)

	(wake trigger_chapter_two)

	(print_if b_debug_gameplay "insertion point: ins_e10_rest_respite unlocked")
	(submit_incident "ins_e10_rest_respite")

	(submit_incident_with_custom_string_id "game_activity_begin" "e10")
)

; beat 3
(script dormant trigger_chapter_three
	(f_hud_chapter chapter_e10_3)
)
; trigger chapter 3
(script dormant trigger_chapter_title_three
	(sleep_until (volume_test_players tv_trigger_chapter_three) 1)
	(f_blip_flag fl_testingfacilty_entry 0)
	(wake trigger_chapter_three)
	(print_if b_debug_gameplay "insertion point: ins_e10_geneforge_start unlocked")
	(submit_incident "ins_e10_geneforge_start")
	(submit_incident_with_custom_string_id "game_activity_begin" "e10")
	(wake trigger_obj_geneforge_ll)
)

; beat 4
(script dormant trigger_chapter_four
	(f_hud_chapter chapter_e10_4)
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 											e10 - vo/cinematics
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; beat 1 - vo
;====================================================================================================================================================================================================
;; johnson splits off on his own path
(script dormant trigger_johnson_opens_path
	(sleep_until (or
				(volume_test_players tv_trigger_johnson_opens_path)
				(= (ai_nonswarm_count sq_dock_second_jackal) 0)
				)
				1
	)
	(print "johnson is on the case")
	(wake dialogue_johnson_opens_path)
)

;; cheif get out of the airlock please.  loops johnsons vo line if chief decides to sit in the space as a reminder
(script dormant trigger_chief_snuck_in_airlock
 	;sleep unless player and johnson enters the airlock
	(sleep_until (and
				(volume_test_players tv_chief_checka_first_airlock)
				(volume_test_object tv_chief_checka_first_airlock ai_johnson)
				)
				1
	)
	; trigger the line initially when you enter the airlock
	(f_md_3d_play 0 ai_johnson m12_02320 "johnson: your comms down, chief? i need you to stay back until i drop that shield."); x

	; loop the line every 15 seconds if you sit in the airlock as a reminder
	(sleep_until
		(begin
			(if (and
				(= b_chief_in_airlock true)
				(volume_test_object tv_johnson_in_first_airlock ai_johnson)
				)
				(f_md_3d_play 0 ai_johnson m12_02320 "johnson: your comms down, chief? i need you to stay back until i drop that shield."); x
			)
			(= b_johnson_is_through_airlock true)
		)
	(game_ticks_from_seconds 15)
	)
)

;; the group runs into a pair of hunters
(script dormant trigger_omg_its_hunters
	(sleep_until (volume_test_players tv_omg_its_hunters) 1)
	(if (> (ai_living_count gr_exit_hunters) 0) (wake dialogue_omg_its_hunters)) ; checks if hunters are still alive before saying omg hunters
	(f_unblip_all) ;remove all navpoints
)

;====================================================================================================================================================================================================
; beat 2 - vo
;====================================================================================================================================================================================================
;; the group splits up at r+r
(script dormant trigger_mc_johnson_split_at_rr
	;(sleep_until (volume_test_object tv_mc_johnson_split_at_rr ai_johnson) 1)
	(sleep_until b_johnson_at_first_post 1)
	(wake dialogue_mc_johnson_first_split)
	(f_game_save) ;save the game
)

;; the group splits up at r+r
(script dormant trigger_sophie_says_hi
	(sleep_until (volume_test_players tv_sophie_says_hi) 1)
	(set b_chief_dawdles_in_rr_lower true);set the variable that will control another vo bit from johnson

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_hanger_powershot3)
)

;; mc dawdles in r&r
(script dormant trigger_mc_dawdles_in_rr
	(sleep_until (= b_chief_dawdles_in_rr_lower 1) 1)
	(wake dialogue_mc_dawdles_in_rr)
)

;; the group enters the dojo
;(script dormant trigger_entering_the_dojo
;	(sleep_until (volume_test_object tv_entering_the_dojo ai_johnson) 1)
	;(wake dialogue_entering_the_dojo)
;)

;====================================================================================================================================================================================================
; beat 3 - vo
;====================================================================================================================================================================================================
;; the group enters the human museum
(script dormant trigger_the_human_museum
	(sleep_until (volume_test_players tv_the_human_museum) 1)
	(wake dialogue_the_human_museum)
)

(script dormant trigger_geneforge_testing1
	(sleep_until (volume_test_players tv_geneforge_testing1) 1)
	(sleep_until (volume_test_object tv_geneforge_testing1 ai_johnson) 1)
	(f_unblip_all) ;remove all navpoints
	(wake dialogue_geneforge_testing1)

	(sleep_until (and
				(= b_first_time_entry_tf false)
				(volume_test_object tv_geneforge_testing1 ai_johnson)
				(> (object_get_health (object_get_ai ai_johnson)) 0)
				)
				1
	)

	;(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_wanders_testing_facility)
)

(script dormant trigger_geneforge_testing3
	(sleep_until (and b_johnson_opendoor_tf (volume_test_players tv_geneforge_testing3)) 1)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_opens_door_testing_facility)
	(wake wake_tf_exit_door)
	(wake hallway_is_clear)
)

(script dormant trigger_the_brute_storage_room
	;(sleep_until (volume_test_players tv_the_brute_storage_room) 1)
	(sleep_until (volume_test_object tv_vo_what_is_all_this ai_johnson) 1)

	(wake dialogue_the_brute_storage_room)
)
;====================================================================================================================================================================================================
; beat 4 - vo/cinematics
;====================================================================================================================================================================================================
;; johnson remarks about the first brute death
;(script dormant trigger_vo_brutes_are_tough
 ;   (sleep_until b_first_augmented_dies 1)
;	(wake vo_first_augmented_brute_dies)
;)

;; johnson and chief make remarks when wave 1 concludes
(script dormant trigger_vo_ll_encounter_defeated
	(sleep_until b_encounter_15_wv1_complete 1)

	(wake vo_stasis_chamber_main_encounter_eliminated)

	(sleep (game_ticks_from_seconds 45))

	(set b_stasis_chamber_cleared true)
)

;========================================
;beat 4 - chief and johnson learn about what is going on with the brutes
;========================================
(script dormant trigger_cinematic_four
	(sleep_until (volume_test_players tv_cinematic_four) 1)
	(f_play_cinematic cinematics\e10\e10_forge.cinematic ps_teleport_players_cine4)
	(object_create_folder of_dead_elite_geneforge)
	(print "playing forge cinematic")
	(wake trigger_chapter_four)
	(wake trigger_obj_geneforge_survive)
	(device_set_position_immediate dm_geneforge_ll_door_into_lab 0)
	(device_set_power dm_geneforge_ll_door_into_lab 0)
	(f_unblip_all) ;remove all navpoints
	(wake geneforge_ll_wv1_trigger)
	(print_if b_debug_gameplay "insertion point: ins_e10_main_lower_lab unlocked")
	(submit_incident "ins_e10_main_lower_lab")
	(set b_ambush_cinematic_concludes true)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_teleports_cine4)

	(sleep (game_ticks_from_seconds 2))
	(wake vo_shoot_our_way_out)
)

;========================================
;beat 4 - chief and johnson discover a signal - end of level
;========================================
(script dormant start_change_of_plans
	(sleep_until (volume_test_players tv_change_of_plans_start) 1)
	(f_unblip_all) ;remove all navpoints
	;end ps5 activity
	(submit_incident_with_custom_string_id "game_activity_end_completed" "e10")
	;unlock e20
	(submit_incident "unlock_e20")
	;unlock the first insertion point fore20
	(print_if b_debug_gameplay "insertion point:ins_e20_start unlocked")
	(submit_incident "ins_e20_start")
	(f_play_cinematic cinematics\e10\e10_signals.cinematic)
	(print "playing change of plans cinematic")
	(game_won)
)