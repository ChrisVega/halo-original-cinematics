;====================================================================================================================================================================================================
; global variables ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean mark_lz_dropship false)
(global boolean mark_lz_banshee false)
(global boolean cont_banshee_kill false)

(global boolean b_debug_fork false)
(global boolean b_debug_gameplay true)
(global boolean b_ship_safe_load true)
(global boolean lz_time_out false)

(global boolean global_ai_greetplayer false)

(global boolean b_first_arrival_played false)
(global boolean b_first_wave_1_calledout false)
(global boolean b_first_wave_2_calledout false)
(global boolean b_first_wave_3_calledout false)
(global boolean b_first_wave_4_calledout false)
(global boolean b_first_wave_5_calledout false)
(global boolean b_first_wave_6_calledout false)
(global boolean global_first_wave_1 false)
(global boolean global_first_wave_2 false)
(global boolean global_first_wave_3 false)
(global boolean global_first_wave_4 false)
(global boolean global_first_wave_5 false)
(global boolean global_first_wave_6 false)

(global boolean global_first_marines_nav false)
(global boolean global_ai_playfight false)
(global boolean global_marines_follow_player false)
(global boolean marines_follow_underground false)
(global short num_surviving_marines 0)
(global boolean b_warthog_delivery false)

(global boolean global_search_follow_player false)
(global boolean global_first_marine_attack false)
(global boolean global_first_marine_defend false)

(global boolean global_river_wave_1_attack false)

(global boolean global_cave_control_hint false)
(global boolean global_cave_bridge_enabled false)

(global boolean global_cliff_start false)
(global boolean global_cliff_marine_active false)
(global boolean global_cliff_welcome false)
(global boolean global_cliff_all_killed false)
(global boolean global_cliff_exit false)
(global boolean global_cliff_end false)

(global boolean global_rubble_start false)
(global boolean global_rubble_welcome false)
(global boolean global_rubble_contact false)
(global boolean global_rubble_waves_start false)
(global boolean global_rubble_all_killed false)
(global boolean global_rubble_exit false)
(global boolean global_rubble_end false)

(global boolean global_rubble_wave_2 false)
(global boolean global_rubble_wave_3 false)
(global boolean global_rubble_wave_4 false)
(global boolean global_rubble_wave_5 false)

(global boolean global_rubble_wave_1_attack false)
(global boolean global_rubble_wave_2_attack false)
(global boolean global_rubble_wave_3_attack false)
(global boolean global_rubble_wave_4_attack false)
(global boolean global_rubble_wave_5_attack false)

(global boolean global_river_start false)
(global boolean global_river_welcome false)
(global boolean global_river_marine_active false)
(global boolean global_river_contact false)
(global boolean global_river_all_killed false)
(global boolean global_river_exit false)
(global boolean global_river_end false)

(global boolean global_river_wave_1 false)
(global boolean global_river_wave_2 false)
(global boolean global_river_wave_3 false)
(global boolean global_river_wave_1_defend false)
(global boolean global_river_wave_2_defend false)
(global boolean global_river_wave_3_defend false)

(global boolean global_first_end false)

(global boolean global_lifepods_flew false)

(global boolean global_two_marine_rescued false)

(global boolean mark_evade false)
(global boolean mark_higher false)
(global boolean mark_protect false)
(global boolean mark_covstart false)
(global boolean mark_covmid false)
(global boolean mark_covend false)
(global boolean mark_warthog false)
(global boolean mark_controls false)
(global boolean mark_searchstart false)
(global boolean mark_searchfirst false)
(global boolean mark_search false)
(global boolean mark_search2 false)
(global boolean mark_search3 false)
(global boolean mark_search4 false)

(global long delay_dawdle (* 30 15))
(global long delay_fail (* 30 180))
(global long delay_calm (* 30 3))
(global long delay_lost (* 30 90))
(global long delay_late (* 30 45))
(global long delay_attack_marines_river (* 30 20))

(global vehicle lz_cship_global none)
(global vehicle cship_global none)
(global vehicle cship1_global none)
(global vehicle mid_ship_global none)
(global vehicle foehammer_global none)
(global vehicle jeep_global none)

;(global object_list cliff_marines_list none)
(global object cliff_marines_curr none)
(global short cliff_marines_total 0)
(global short cliff_marines_curr_index 0)

(global boolean cliff_pelican_l01 false)
(global boolean cliff_pelican_l02 false)
(global boolean cliff_pelican_l03 false)
(global boolean cliff_pelican_l04 false)
(global boolean cliff_pelican_l05 false)
(global boolean cliff_pelican_r01 false)
(global boolean cliff_pelican_r02 false)
(global boolean cliff_pelican_r03 false)
(global boolean cliff_pelican_r04 false)
(global boolean cliff_pelican_r05 false)

(global boolean followers_in_warthog false)
(global boolean global_follow_player_on_foot true)
(global short s_player_area_current 0)
; 0 unset
; 1 start area including holdout0
; 2 between holdout0 and lightbridge cave
; 3 cave
; 4 connector: between holdouts 1-3 and cave
; 5 holdout 1: rubble
; 6 holdout 2: river
; 7 holdout 3: cliff
(global short s_callout 0)

(global short s_player_distance_cliff -1)
(global short s_player_distance_river -1)
(global short s_player_distance_rubble -1)
;if the holdout is over, set the distance of the point as max
(global short s_distance_max 32767)

(global boolean b_leave_holdout_early_progress false)
(global short s_holdout_progress 0)

(global short s_followers_count 2)
(global short s_warthog_followers_index 0)
(global short s_current_follower_index 0)
(global short s_current_follower_killed 0)
(global short s_wait_for_other_follower_time 10)
(global boolean b_all_followers_in_warthog false)


;====================================================================================================================================================================================================
; objectives ================================================================================================================================================
;====================================================================================================================================================================================================
(script static void f_objectives_a30
	(print "objectives ready.")
	(wake obj_evade)
	(wake obj_higher)
	(wake obj_protect)
	(wake obj_covstart)
	(wake obj_covmid)
	(wake obj_searchstart)
	(wake obj_covend)
	(wake obj_warthog)
	(wake obj_searchfirst)
	(wake obj_controls)
	(wake obj_search1)
	(wake obj_search2)
	(wake obj_search3)
	(wake obj_search4)
)

(script dormant obj_evade
	(sleep_until mark_evade 1)
	(sleep (game_ticks_from_seconds 1.0)) ; wait for hud to be ready when using insertion points
	(print "showing objective: obj_a30_evade")
	(f_hud_obj_new "obj_a30_evade" "obj_a30_evade")
)

(script dormant obj_higher
	(sleep_until mark_higher 1)
	(sleep (game_ticks_from_seconds 1.0)) ;
	(print "showing objective: obj_a30_higher")
	(f_hud_obj_new_no_hud_completion "obj_a30_higher" "obj_a30_higher")
)

(script dormant obj_protect
	(sleep_until mark_protect 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_protect")
	(f_hud_obj_new_no_hud_completion "obj_a30_protect" "obj_a30_protect")
)

(script dormant obj_covstart
	(sleep_until mark_covstart 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_covstart")
	(f_hud_obj_new "obj_a30_covstart" "obj_a30_covstart")
)

(script dormant obj_covmid
	(sleep_until mark_covmid 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_covmid")
	(f_hud_obj_new_no_hud_completion "obj_a30_covmid" "obj_a30_covmid")
)

(script dormant obj_covend
	(sleep_until mark_covend 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_covend")
	(f_hud_obj_new_no_hud_completion "obj_a30_covend" "obj_a30_covend")
)

(script dormant obj_warthog
	(sleep_until mark_warthog 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_warthog")
	(f_hud_obj_new "obj_a30_warthog" "obj_a30_warthog")
)

(script dormant obj_searchstart
	(sleep_until mark_searchstart 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_searchstart")
	(if mark_warthog
		(f_hud_obj_new "obj_a30_searchstart" "obj_a30_searchstart")
		(f_hud_obj_new_no_hud_completion "obj_a30_searchstart" "obj_a30_searchstart")
	)
)

(script dormant obj_controls
	(sleep_until mark_controls 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_controls")
	(f_hud_obj_new_no_hud_completion "obj_a30_controls" "obj_a30_controls")
)

(script dormant obj_searchfirst
	(sleep_until mark_searchfirst 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_searchstart")
	(if mark_controls
		(f_hud_obj_new "obj_a30_searchstart" "obj_a30_searchstart")
		(f_hud_obj_new_no_hud_completion "obj_a30_searchstart" "obj_a30_searchstart")
	)
)

(script dormant obj_search1
	(sleep_until mark_search 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_search1")
	(f_hud_obj_new "obj_a30_search1" "obj_a30_search1")
)

(script dormant obj_search2
	(sleep_until mark_search2 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_search2")
	(f_hud_obj_advance "obj_a30_search2" true)
)

(script dormant obj_search3
	(sleep_until mark_search3 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_search3")
	(f_hud_obj_advance "obj_a30_search3" true)
)

(script dormant obj_search4
	(sleep_until mark_search4 1)
	(sleep (game_ticks_from_seconds 1.0))
	(print "showing objective: obj_a30_search4")
	(f_hud_obj_advance "obj_a30_search4" true)
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

;====================================================================================================================================================================================================
; checkpoints ================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant save_mission_start
	(f_game_save)
)

(script dormant save_first_arrival
	(f_game_save)
	(print "mission segment: first arrival")
   	;(mcc_mission_segment "02_first_arrival") ; see hceek base_a30.hsc for the other old mission segments
)

(script dormant save_first_welcome
	(f_game_save)
	(print "mission segment: first arrival - welcome")
)

(script dormant save_first_wave_1
	(f_game_save)
	(print "mission segment: first arrival - wave 1")
)

(script dormant save_first_wave_2
	(f_game_save)
	(print "mission segment: first arrival - wave 2")
)

(script dormant save_first_wave_3
	(f_game_save)
	(print "mission segment: first arrival - wave 3")
)

(script dormant save_first_wave_4
	(f_game_save)
	(print "mission segment: first arrival - wave 4")
)

(script dormant save_first_wave_5
	(f_game_save)
	(print "mission segment: first arrival - wave 5")
)

(script dormant save_first_wave_6
	(f_game_save)
	(print "mission segment: first arrival - wave 6")
)

(script dormant save_first_waiting
	(f_game_save)
	(print "mission segment: first arrival - pelican and warthog")
)

(script dormant save_cave_floor_enter
	(sleep_until (volume_test_players cave_encounter_cp_trigger) 1)
	(f_game_save)
	(print "mission segment - cave")
)

(script dormant save_cave_bridge
	(sleep_until (volume_test_players after_lightbridge_trigger) 1)
	(f_game_save)
	(print "mission segment - cave bridge")
)

(script dormant save_cave_floor_exit
	(f_game_save)
	(print "mission segment - cave floor exit")
)

(script dormant save_cliff_arrival
	(f_game_save)
	(print "mission segment - cliff")
)

(script dormant save_cliff_welcome
	(f_game_save)
	(print "mission segment - cliff welcome")
)

(script dormant save_cliff_rescued
	(f_game_save)
	(print "mission segment - cliff rescued")
)

(script dormant save_cliff_killed
	(f_game_save)
	(print "mission segment - cliff killed")
)

(script dormant save_rubble_arrival
	(f_game_save)
	(print "mission segment - rubble")
)

(script dormant save_rubble_welcome
	(f_game_save)
	(print "mission segment - rubble welcome")
)

(script dormant save_rubble_wave_1
	(f_game_save)
	(print "mission segment - rubble wave 1")
)

(script dormant save_rubble_wave_2
	(f_game_save)
	(print "mission segment - rubble wave 2")
)

(script dormant save_rubble_wave_3
	(f_game_save)
	(print "mission segment - rubble wave 3")
)

(script dormant save_rubble_wave_4
	(f_game_save)
	(print "mission segment - rubble wave 4")
)

(script dormant save_rubble_rescued
	(f_game_save)
	(print "mission segment - rubble rescued")
)

(script dormant save_river_arrival
	(f_game_save)
	(print "mission segment - river")
)

(script dormant save_river_welcome
	(f_game_save)
	(print "mission segment - river welcome")
)

(script dormant save_river_wave_1
	(f_game_save)
	(print "mission segment - river wave 1")
)

(script dormant save_river_wave_2
	(f_game_save)
	(print "mission segment - river wave 2")
)

(script dormant save_river_wave_3
	(f_game_save)
	(print "mission segment - river wave 3")
)

(script dormant save_river_wave_4
	(f_game_save)
	(print "mission segment - river wave 4")
)

(script dormant save_river_rescued
	(f_game_save)
	(print "mission segment - river rescued")
)