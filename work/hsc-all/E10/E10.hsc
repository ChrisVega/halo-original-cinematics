;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;====================== e10-start up ================================================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script startup e10_start
	(ai_allegiance player human)
	(ai_allegiance human player)
	(e10_insertion_point_fixups)
	(f_start_auto_save_loop)

	;wake coop ponrs
	(wake teleport_coop_players_post_hunters)
	(wake teleport_coop_players_r_and_r_gravlift)
	(wake teleport_coop_players_human_museum)
	(wake teleport_coop_players_grav_lift_room)
	(wake teleport_coop_players_final_encounter)

	;wake music master script
	(wake e10_music_controller)

;====================================================================================================================================================================================================
;beat 1 - insertion points - xxxxxxxxxx - catchup script for start insertion point
;====================================================================================================================================================================================================

	(if (f_insertion_point_area_pending ins_e10_start)
		(begin
			(print "insertion point ins_e10_start is loading")
			;wake the encounter triggering scripts for 1 - 5
			(wake dock_intro)
			;(wake dock_second)
			(wake dock_3_clock)
			;(wake dock_12_clock_a)
			(wake dock_12_clock_b)
			(wake dock_9_clock)
			(wake dock_turn)
			(wake airborne_hanger)
			(wake exit_hunters)
			;wake any vo scripts that need to occur
			;wake any music scripts that need to occur
			(wake e10_music_hanger)
			;(wake trigger_open_the_door_johnson)
			;(wake trigger_johnson_opens_path)
			(wake trigger_omg_its_hunters)
			;wake the encounter clean up scripts for 1 - 5
			(wake e10_e2_cleanup)
			(wake e10_e3_cleanup)
			(wake e10_e4_cleanup)
			(wake e10_e5_cleanup)
			; johnson specific scripts
			(wake johnson_in_first_airlock)
			;(wake johnson_hanger_sniper_time)
			(wake johnson_hanger_sniper_time_b)
			(wake johnson_hanger_sniper_time_c)
			(wake johnson_hanger_sniper_time_d)
			(wake johnson_hanger_sniper_time_c2)
			;(wake johnson_goto_hunter_town)
			; chief specific scripts
			(wake chief_in_airlock)
			(wake chief_left_airlock)
			(wake trigger_chief_snuck_in_airlock)
			; spirit dropships
			(wake spirit_dropship_a_ready)
			(wake spirit_dropship_b_ready)
			(wake blip_the_hunters)
			; level specific
			(wake kill_hanger_soft_ceilings)
			(wake did_any_players_sneak_through)
		)
	)

;====================================================================================================================================================================================================
;beat 2 - insertion points - xxxxxxxxxx - catchup script for start insertion point
;====================================================================================================================================================================================================

	;(sleep_until (or (volume_test_players_all tv_change_of_plans_start)(f_insertion_point_script_is_blocked ins_rest_respite)))
	(if (f_insertion_point_area_pending ins_e10_rest_respite)
		(begin
		(print "insertion point ins_e10_rest_respite is loading")
		;wake the encounter triggering scripts for 6 - 9
		(wake start_rest_respite)
		(wake start_rest_respite_hallway)
		(wake start_rest_respite_wave_3)
		(wake start_rest_respite_wave_final)
		(wake skull_encounter_triggered)
		;wake the encounter clean up scripts for 6 - 9
		(wake e10_e6_cleanup)
		(wake e10_e9_cleanup)
		(wake e10_skull_cleanup)
		;wake any vo scripts that need to occur
		(wake trigger_mc_johnson_split_at_rr)
		(wake trigger_sophie_says_hi)
		;wake any music scripts that need to occur
		(wake e10_music_rest_respite)
		;wake the chapter title triggers
		(wake trigger_chapter_title_two)
		; johnson specific scripts
		(wake johnson_goto_1st_sniper_post_rr)
		(wake johnson_goto_2nd_sniper_post_rr)
		(wake spawn_buddy_normal)
		;(wake johnson_perch_teleport_rr)
		; chief specific scripts
		(wake chief_dawdling_timer)
		; level specific scripts
		(wake turn_off_barriers_in_rr);turn off the barriers in the window by johnson
		)
	)

	(if (f_insertion_point_area_pending ins_e10_dojo)
		(begin
		(print "insertion point ins_e10_dojo is loading")
		;wake the encounter triggering scripts for 10 - 11
		(wake start_dojo)
		(wake start_dojo_midpoint)
		;wake the encounter clean up scripts for 10 - 11
		(wake e10_e10_cleanup)
		(wake e10_e11_cleanup)
		;wake any vo scripts that need to occur
		;(wake trigger_entering_the_dojo)
		;wake any music scripts that need to occur
		(wake e10_music_dojo)
		;wake the chapter title triggers

		; johnson specific scripts
		(wake johnson_sniping_at_the_dojo)
		(wake johnson_move_to_gravbridge)
		(wake set_johnsons_kill_bool_dojo)
		(wake spawn_buddy_normal)
		(wake johnson_teleports_past_grav_bridge)
		;(wake is_johnson_in_dojo)

		;wake specific level stuff
		(wake unblip_rr_exit_flag)
		)
	)

;====================================================================================================================================================================================================
;beat 3 - insertion points - xxxxxxxxxx - catchup script for start insertion point
;====================================================================================================================================================================================================

	(if (f_insertion_point_area_pending ins_e10_geneforge_start)
		(begin
		(print "insertion point ins_e10_geneforge_start is loading")
		;wake the encounter triggering scripts for 12
		(wake start_geneforge_start)
		;(wake start_storage_part_2)
		;wake the encounter clean up scripts for 12
		(wake e10_e12_cleanup)
		;wake any vo scripts that need to occur
		(wake trigger_geneforge_testing1)
		(wake trigger_geneforge_testing3)
		(wake trigger_the_human_museum)
		(wake trigger_the_brute_storage_room)
		;wake any music scripts that need to occur
		(wake e10_music_testing_facility)
		;wake the chapter title triggers
		(wake trigger_chapter_title_three)
		; johnson specific scripts
		(wake spawn_buddy_normal)
		(wake stop_chatty_johnson_variable)
		;(wake johnson_heads_to_tf)
		;;level stuff
		(wake careful_of_the_sleepers)
		)
	)

;====================================================================================================================================================================================================
;beat 4 - ins_main_lab_lower insertion point - catchup script for start insertion point
;====================================================================================================================================================================================================

	(if (f_insertion_point_area_pending ins_e10_main_lab_lower)
		(begin
		(print "insertion point ins_e10_main_lab_lower is loading")
		;wake the encounter triggering scripts for 13-16
		(wake species_storage_wv1_triggered)
		(wake species_storage_wv2_triggered)
		(wake cooridor_to_glr_wv2_triggered)
		;wake the encounter clean up scripts for 13-16
		(wake e10_e13_cleanup)
		(wake e10_e14_cleanup)
		(wake e10_e15_cleanup)
		(wake e10_e16_cleanup)
		;wake any vo/cinematic/objectives scripts that need to occur
		(wake trigger_cinematic_four)
		;(wake trigger_vo_brutes_are_tough)
		(wake trigger_vo_ll_encounter_defeated)
		;wake any music scripts that need to occur
		(wake e10_music_lower_lab_ambush)
		; johnson specific scripts
		(wake spawn_buddy_normal)
		;(wake johnson_teleports_post_ll)
		(wake johnson_hallway_walk_post_ll)
		;level specific
		(wake unblip_storage_backtrack)
		(wake unblip_ll_upperlevel_flag)
		)
	)

;====================================================================================================================================================================================================
;beat 4 - ins_testing_facility_revisit insertion point - catchup script for start insertion point
;====================================================================================================================================================================================================

	(if (f_insertion_point_area_pending ins_e10_tf_revisit)
		(begin
		(print "insertion point ins_e10_tf_revisit is loading")
		;wake the encounter triggering scripts for 17-18
		(wake testing_facility_wv1_triggered)
		(wake testing_facility_wv3_triggered)
		;(wake cooridor_to_glr_wv1_triggered)
		(wake cooridor_to_glr_wv2_triggered)
		;wake the encounter clean up scripts for 17-18
		(wake e10_e17_cleanup)
		(wake e10_e18_cleanup)
		;wake any vo/cinematic/objectives  scripts that need to occur
		(wake trigger_obj_geneforge_ul)
		;(wake vo_testing_facility_revisit_encounter_7)
		(wake vo_stasis_chamber_monitors_seen)
		;wake any music scripts that need to occur
		(wake e10_music_tf_revisit)
		; johnson specific scripts
		(wake spawn_buddy_normal)
		(wake unlock_tf_door_backtracking)
		(wake johnson_combat_testing_facility)
		)
	)

;====================================================================================================================================================================================================
;beat 4 - ins_double_grav_lift insertion point - catchup script for start insertion point
;====================================================================================================================================================================================================

	(if (f_insertion_point_area_pending ins_e10_double_grav_lift)
		(begin
		(print "insertion point ins_e10_double_grav_lift is loading")
		;wake the encounter triggering scripts for 19-20
		(wake grav_lift_initial_encounter)
		(wake grav_lift_encounter_triggered)
		;(wake glr_gravlifts_disable)
		;wake any vo/cinematic/objectives  scripts that need to occur

		; johnson specific scripts
		(wake spawn_buddy_normal)
		(wake lock_gravlift_room_door)
		;wake specific level stuff
		(wake shift_blip_at_gravlift)
		)
	)

;====================================================================================================================================================================================================
;beat 4 - ins_final_encounter insertion point - catchup script for start insertion point
;====================================================================================================================================================================================================

	(if (f_insertion_point_area_pending ins_e10_final_encounter)
		(begin
		(print "insertion point ins_e10_final_encounter is loading")
		;wake the encounter triggering scripts for 21
		(wake final_encounter_wv1_triggered)
		;wake any vo/cinematic/objectives  scripts that need to occur
		(wake start_change_of_plans)
		;wake any music scripts that need to occur
		(wake e10_music_final_encounter)
		; johnson specific scripts
		(wake spawn_buddy_normal)
		(wake johnson_teleports_geneforge_final)
		)
	)
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 												e10 - level stuff
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

; --------------------------------------------------------------------------------
;enable/disable the gravlift rooms current gravlifts
; --------------------------------------------------------------------------------
; up grav lifts enabled in gravlift room
(script dormant glr_gravlifts_enable
	(sleep_until (= b_gravlift_to_final_enabled true) 1 (game_ticks_from_seconds 60))
		(if (= b_gravlift_to_final_enabled false)
			(set b_gravlift_to_final_enabled true)
		)
	(effect_new "fx/vignettes/e10/grav_lift_pulse" fl_grav_lift_pulse)
	(sleep (game_ticks_from_seconds .5))
	(object_create gravlift_liftroom_up)
	(object_destroy gravlift_liftroom_down)
	(f_blip_flag fl_glr_gravlift 0)
)

; --------------------------------------------------------------------------------
;johnson being chatty boolean
; --------------------------------------------------------------------------------
; tell turn boolean false to stop johnson from being chatty
(script dormant stop_chatty_johnson_variable
	(sleep_until (volume_test_players tv_johnson_stop_being_chatty) 1)
	(set b_path_forward_is_open false)
)

; --------------------------------------------------------------------------------
;swapping gravbridges when johnson does his hacking thing
; --------------------------------------------------------------------------------
(script dormant dojo_gravbridge_out_of_room_on
	;sleep until johnson hacks the forcefield or a certain amount of time passes for a fallback
	(sleep_until (= b_johnson_hacked_grav_bridge true) 1 (game_ticks_from_seconds 60))
		(if (= b_johnson_hacked_grav_bridge false)
			(set b_johnson_hacked_grav_bridge true)
		)
	(print "grav lifts disabled triggered")
	(object_create gravbridge_1)
	(object_destroy gravbridge_b)
	(device_set_position_immediate dm_grav_bridge_dojo_exit .5) ;start vignette machine grav bridge activation fade in
	(sleep (game_ticks_from_seconds 2))
	(device_set_position_immediate dm_grav_bridge_dojo_exit 1) ;set the exit grav bridge to be on now that it has been activated in case of save state reload
	(device_set_position_immediate dm_grav_bridge_dojo_enter 0) ;set enter grav bridge to be off now that it has been activated in case of save state reload
)

; --------------------------------------------------------------------------------
;unlock the back track door if i am backtracking
; --------------------------------------------------------------------------------
(script dormant unlock_tf_door_backtracking
	(sleep_until (and
				(= b_backtracking_through_level true)
				(volume_test_players tv_unlock_the_backtrack_door)
				)
				1
	)
	(device_set_power dm_johnson_hack_door_tf 1)
)

; --------------------------------------------------------------------------------
; camera shakes
; --------------------------------------------------------------------------------
(script static void pe_camera_shake_s
	(player_effect_set_max_translation .03 .01 .06)
    (player_effect_set_max_rotation 1 3 3)
    (player_effect_start 1 0)
    (sound_impulse_start sound\sfx\ambience\a10\pillarhits none 2)
    (player_effect_stop 1)
 )

 (script static void pe_camera_shake_m
	(player_effect_set_max_translation .06 .02 .12)
    (player_effect_set_max_rotation 2 5 5)
    (player_effect_start 1 0)
    (sound_impulse_start sound\sfx\ambience\a10\pillarhits none 2)
    (player_effect_stop 1)
 )

 (script static void pe_camera_shake_l
	(player_effect_set_max_translation .12 .04 .24)
    (player_effect_set_max_rotation 4 8 8)
    (player_effect_start 1 0)
    (sound_impulse_start sound\sfx\ambience\a10\pillarhits none 2)
    (player_effect_stop 1)
 )

; --------------------------------------------------------------------------------
;command script to put grunts to sleep
; --------------------------------------------------------------------------------
(script command_script cs_sleeping_grunts
	(ai_activity_set ai_current_actor asleep)
)

; --------------------------------------------------------------------------------
;close and lock the grav lift room door when the player enters
; --------------------------------------------------------------------------------
(script dormant lock_gravlift_room_door
	(sleep_until (volume_test_players tv_lock_grav_room_door) 1)
	(f_unblip_all) ;remove all navpoints
	(device_set_position dm_gravlift_room_entry_door 0)
	(set s_music_trigger_e10 191)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_teleports_glr)

	(sleep_until (= (device_get_position dm_gravlift_room_entry_door) 0) 1)
)

; --------------------------------------------------------------------------------
;airlock check for chief - bool swaps based on where he is as a control method
; --------------------------------------------------------------------------------
; chief is in the airlock
; looping script to continually check for players pos before johnson gets through the airlock
(script dormant chief_in_airlock
	(sleep_until (volume_test_players tv_chief_checka_first_airlock) 1) ;sleep unless player enters airlock
	(sleep_until
		(begin
			(if (and
				(= b_chief_in_airlock false)
				(volume_test_players tv_chief_checka_first_airlock)
				)
				(set b_chief_in_airlock true)
				;(print "player is in the airlock")
			)
			(= b_johnson_is_through_airlock true)
		)
	5
	)
)
; chief is not in the airlock
; looping script to continually check for players pos before johnson gets through the airlock
(script dormant chief_left_airlock
	(sleep_until (volume_test_players tv_chief_checka_first_airlock) 1) ;sleep unless player enters airlock
	(sleep_until
		(begin
			(if (and
				(= b_chief_in_airlock true)
				(volume_test_players tv_chief_checkb_first_airlock)
				)
				(set b_chief_in_airlock false)
				;(print "player is not in the airlock")
			)
			(= b_johnson_is_through_airlock true)
		)
	5
	)
)

; --------------------------------------------------------------------------------
;post airlock teleport for any player that somehow squeezed through
; --------------------------------------------------------------------------------
(script dormant did_any_players_sneak_through
	(sleep_until (volume_test_object tv_johnson_in_first_airlock ai_johnson) 1)
	(print "timetoteleport")
	(sleep_until
		(begin
			(if (volume_test_object tv_sneaky_player_check player0) ;player 1 snuck through
				(object_teleport player0 fl_sneaky_player1)
			)
			(if (volume_test_object tv_sneaky_player_check player1) ;player 2 snuck through
				(object_teleport player1 fl_sneaky_player2)
			)
			(if (volume_test_object tv_sneaky_player_check player2) ;player 3 snuck through
				(object_teleport player2 fl_sneaky_player3)
			)
			(if (volume_test_object tv_sneaky_player_check player3) ;player 4 snuck through
				(object_teleport player3 fl_sneaky_player4)
			)
			(= b_johnson_has_hacked_ff true)
		)
	1
	)
)

; --------------------------------------------------------------------------------
; point of no returns (ponr) to teleport the party in e10
; --------------------------------------------------------------------------------

;; post hanger hunter ponr
(script dormant teleport_coop_players_post_hunters
	(sleep_until (volume_test_players tv_ponr_post_hanger) 1)
	(volume_teleport_players_not_inside tv_ponr_post_hanger_safezone fl_coop_teleport_post_hanger)
)
;; r&r gravlift ponr
(script dormant teleport_coop_players_r_and_r_gravlift
	(sleep_until (volume_test_players tv_ponr_r_and_r_gravlift) 1)
	(volume_teleport_players_not_inside tv_ponr_r_and_r_gravlift_safezone fl_coop_teleport_r_and_r)
)
;; post dojo ponr
(script dormant teleport_coop_players_human_museum
	(sleep_until (volume_test_players tv_ponr_human_museum) 1)
	(device_set_power dm_lockin_door_museum 1)
	(device_set_position dm_lockin_door_museum 1)

	(sleep_until (= (device_get_position dm_lockin_door_museum) 0) 1) ;;wait until the door closes
	(volume_teleport_players_not_inside tv_ponr_human_museum_safezone fl_coop_teleport_human_museum)
	(cs_run_command_script ai_johnson clear_commands)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(sleep 1)
	(ai_set_objective ai_johnson obj_johnson_follow)
)
;; entering the glr ponr
(script dormant teleport_coop_players_grav_lift_room
	(sleep_until (volume_test_players tv_ponr_grav_lift_room) 1)

	(sleep_until (= (device_get_position dm_gravlift_room_entry_door) 0) 1) ;;wait until the door closes
	(volume_teleport_players_not_inside tv_ponr_grav_lift_room_safezone fl_coop_teleport_grav_lift_room)
)
;; final encounter ponr
(script dormant teleport_coop_players_final_encounter
	(sleep_until (volume_test_players tv_ponr_final_encounter) 1)

	(sleep_until (= (device_get_position dm_final_encounter_entry) 0) 1) ;;wait until the door closes
	(volume_teleport_players_not_inside tv_ponr_final_encounter_safezone fl_coop_teleport_final_encounter)
)

; --------------------------------------------------------------------------------
;rr - stop dawdling chief and get to it
; --------------------------------------------------------------------------------

;start the timer to trigger the stop dawdling vo in rr
(script dormant chief_dawdling_timer
	(sleep_until (and (= b_chief_dawdles_in_rr_lower 1) (game_safe_to_save)) 1)

	(sleep (game_ticks_from_seconds 50))
	(wake trigger_mc_dawdles_in_rr)
)

; --------------------------------------------------------------------------------
; spirit dropship a - fly away as i move up the ramp
; --------------------------------------------------------------------------------
(script dormant spirit_dropship_a_ready
	(ai_place sq_spirit_dropship_a)
)

(script command_script cs_dropship_a
	(sleep_until (volume_test_players tv_fly_away_dropship_a) 1)
	(f_unblip_all) ;remove all navpoints
	(f_game_save) ;save the game
	(cs_enable_pathfinding_failsafe true) ; this helps with the spirit from getting stuck
	(cs_ignore_obstacles true) ; this helps with the spirit  from getting stuck
	(print "spirit drops ship a flys out of hanger")
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face pts_dropship_a_path/p4 pts_dropship_a_path/p1 3.05) ;hover-up
	(cs_vehicle_speed .25)
	(cs_fly_to_and_face pts_dropship_a_path/p0 pts_dropship_a_path/p1) ;back-out
	(cs_vehicle_speed .75)
	(cs_fly_by pts_dropship_a_path/p2) ;turn and fly away
	(cs_vehicle_speed 1)
	(cs_fly_by pts_dropship_a_path/p3)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

; --------------------------------------------------------------------------------
; spirit dropship b - fly in to drop off troops as i approach
; --------------------------------------------------------------------------------
(script dormant spirit_dropship_b_ready
	(ai_place sq_spirit_dropship_b)
	(ai_place gr_airborne)
	(vehicle_load_magic (unit_get_vehicle sq_spirit_dropship_b/pilot_spawn) "fork_p_r" (ai_actors gr_airborne))
)

(script command_script cs_dropship_b
	(sleep_until (volume_test_players tv_act_airborne) 1)
	(cs_enable_pathfinding_failsafe true) ; this helps with the spirit from getting stuck
	(cs_ignore_obstacles true) ; this helps with the spirit  from getting stuck
	(print "spirit drops ship b flys into hanger to drop off troops")
	(cs_vehicle_speed .65) ;.5
	(cs_fly_to pts_dropship_b_path/b_flight_p0)
	(cs_vehicle_speed .6) ;.5
	(cs_fly_to pts_dropship_b_path/b_flight_p1)
	(cs_vehicle_speed .55) ;.45
	(cs_fly_to pts_dropship_b_path/b_flight_p2)
	(cs_vehicle_speed .45) ;.35
	(cs_fly_to pts_dropship_b_path/b_flight_p3)
	(cs_vehicle_speed .35) ;.25
	(cs_fly_to pts_dropship_b_path/b_flight_p4)
	(cs_vehicle_speed .3) ;.25
	(cs_fly_to pts_dropship_b_path/b_flight_p5)
	(cs_vehicle_speed .25) ;.1
	(cs_fly_to pts_dropship_b_path/b_flight_p6)
	(cs_fly_to_and_face pts_dropship_b_path/p7 pts_dropship_b_path/p8 .5) ;hover-down
	(vehicle_hover (ai_vehicle_get_from_spawn_point sq_spirit_dropship_b/pilot_spawn) true)
	(unit_open (ai_vehicle_get_from_spawn_point sq_spirit_dropship_b/pilot_spawn))
	(cs_pause 1)
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_spirit_dropship_b/pilot_spawn) "fork_p")
	(ai_place gr_hanger_hallway_patrol)
	(wake johnson_goto_hunter_town)
)

; --------------------------------------------------------------------------------
; kill soft ceilings preventing access to level 2 once a player gets up there
; --------------------------------------------------------------------------------
(script dormant kill_hanger_soft_ceilings
	(sleep_until (volume_test_players tv_kill_soft_ceilings) 1)
	(soft_ceiling_enable soft_ceiling_test 0)
)


; --------------------------------------------------------------------------------
; navpoint flags - scripts (as needed)
; --------------------------------------------------------------------------------
(script dormant unblip_rr_exit_flag
	(sleep_until (volume_test_players tv_unblip_rr_exit) 1)
	(f_unblip_all) ;remove all navpoints
	;add additional equipment in the dojo if 3 or more players
	(if (game_is_cooperative)
		(if (>= (game_coop_player_count) 3)
			(begin
				(object_create_folder of_coop_dojo_items)
			)
		)
	)
)

(script dormant shift_blip_at_gravlift
	(sleep_until (volume_test_players tv_shift_blip_glr) 1)
	(f_unblip_all) ;remove all navpoints
	(f_blip_flag fl_geneforge_ul_entry 0)
)

(script dormant unblip_storage_backtrack
	(sleep_until (volume_test_players tv_unblip_storage_backtrack) 1)
	(f_unblip_all) ;remove all navpoints
)

(script dormant blip_the_hunters
	(sleep_until (volume_test_players tv_blip_the_hunters) 1)
	(f_blip_flag fl_hanger_hunters 0)
)

(script dormant blip_the_far_hanger_door
	(sleep_until (volume_test_players tv_blip_the_far_hanger_door) 1)
	(f_blip_flag fl_hanger_far_door 0)
)

(script dormant blip_the_dropships
	(sleep_until (volume_test_players tv_blip_the_dropships) 1)
	(f_unblip_all) ;remove all navpoints
	(f_blip_flag fl_hanger_spirit_dropship 0)
)

(script dormant unblip_ll_upperlevel_flag
	(sleep_until (and
					(volume_test_players tv_lower_lab_upper_level)
					(= b_goto_lowerlab_upperlevel true)
					)
					1
	)
	(f_unblip_all) ;remove all navpoints
)

; removes all navpoints used in the level
(script static void f_unblip_all
	(f_unblip_flag fl_trigger_cine_two)
	(f_unblip_flag fl_hanger_forcefield)
	(f_unblip_flag fl_hanger_far_door)
	(f_unblip_flag fl_hanger_spirit_dropship)
	(f_unblip_flag fl_hanger_hunters)
	(f_unblip_flag fl_hanger_exit)
	(f_unblip_flag fl_rr_entry)
	(f_unblip_flag fl_rr_to_gravlift)
	(f_unblip_flag fl_rr_exit)
	(f_unblip_flag fl_dojo_ramp)
	(f_unblip_flag fl_dojo_gravbridge)
	(f_unblip_flag fl_dojo_gravbridge_path)
	(f_unblip_flag fl_testingfacilty_entry)
	(f_unblip_flag fl_testingfacilty_hack)
	(f_unblip_flag fl_geneforge_ll_entry)
	(f_unblip_flag fl_geneforge_ll_exit)
	(f_unblip_flag fl_storage_door)
	(f_unblip_flag fl_storage_backtrack)
	(f_unblip_flag fl_testingfacilty_exit)
	(f_unblip_flag fl_glr_entry)
	(f_unblip_flag fl_glr_gravlift)
	(f_unblip_flag fl_geneforge_ul_entry)
	(f_unblip_flag fl_geneforge_ul_exit)
	(f_unblip_flag fl_lower_lab_upper_level)
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 												e10 - buddy marine - johnson
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; spawn my buddies / set to be invulnerable / add to my fireteam
(script dormant spawn_buddy_normal
	(cond
		;((f_insertion_point_matches ins_level_start) (begin
			;(ai_place sq_johnson_start)
			;(set ai_johnson sq_johnson_start)
		;))
		;;bravo
		((f_insertion_point_matches ins_e10_rest_respite) (begin
			(ai_place sq_johnson_rr)
			(set ai_johnson sq_johnson_rr)
			(ai_player_add_fireteam_squad player0 ai_johnson)
			(ai_set_objective ai_johnson obj_johnson_follow)
			(print "johnson is with chief - r+r")
		))
		((f_insertion_point_matches ins_e10_dojo) (begin
			(ai_place sq_johnson_dojo)
			(set ai_johnson sq_johnson_dojo)
			(print "johnson is alone by sniper position - dojo")
		))
		;;charlie
		((f_insertion_point_matches ins_e10_geneforge_start) (begin
			(ai_place sq_johnson_gfs)
			(set ai_johnson sq_johnson_gfs)
			(ai_player_add_fireteam_squad player0 ai_johnson)
			(ai_set_objective ai_johnson obj_johnson_follow)
			(print "johnson is with chief - geneforge start")
		))
		;;delta
		((f_insertion_point_matches ins_e10_main_lab_lower) (begin
			(ai_place sq_johnson_ll)
			(set ai_johnson sq_johnson_ll)
			(ai_player_add_fireteam_squad player0 ai_johnson)
			(ai_set_objective ai_johnson obj_johnson_follow)
			(print "johnson is with chief -  geneforge lab lower level")
		))
		((f_insertion_point_matches ins_e10_tf_revisit) (begin
			(ai_place sq_johnson_tfr)
			(set ai_johnson sq_johnson_tfr)
			(ai_player_add_fireteam_squad player0 ai_johnson)
			(ai_set_objective ai_johnson obj_johnson_follow)
			(print "johnson is with chief - testing facility revisit")
		))
		((f_insertion_point_matches ins_e10_double_grav_lift) (begin
			(ai_place sq_johnson_dglr)
			(set ai_johnson sq_johnson_dglr)
			(ai_player_add_fireteam_squad player0 ai_johnson)
			(ai_set_objective ai_johnson obj_johnson_follow)
			(print "johnson is with chief - grav lift room")
		))
		((f_insertion_point_matches ins_e10_final_encounter) (begin
			(ai_place sq_johnson_fe)
			(set ai_johnson sq_johnson_fe)
			(ai_player_add_fireteam_squad player0 ai_johnson)
			(ai_set_objective ai_johnson obj_johnson_follow)
			(print "johnson is with chief - final encounter")
		))
	)
	(set b_beat_4_johnson_spawned true)
	(f_hud_hero_waypoint ai_johnson hero_johnson hero_default_max_dist)
)

(script static void set_elements_already_complete
	(device_set_power dm_johnson_hack_door_tf 1) ;unlock the door johnson hacked earlier
	(set b_first_time_entry_tf true) ; johnson doesnt need to talk about this room again
	(device_set_position_immediate dm_testing_facility_door 0) ;close the door if it is open
	(device_set_power dm_testing_facility_door 0) ; lock the door into the tf that locks earlier
)

;====================================================================================================================================================================================================
;                 beat 1 - johnson stuff
;====================================================================================================================================================================================================

; --------------------------------------------------------------------------------
;                 beat 1 - johnson unlock first door - hangar
; --------------------------------------------------------------------------------
(script command_script cs_johnson_goto_first_door
	(wake open_first_door)
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	; johnson walks to the first door
	(print "johnson tries to go to the first door")
	(ai_set_objective ai_johnson obj_johnson_walk)
	(cs_force_combat_status 1)
	(cs_lower_weapon true)
	(cs_walk true)
	;move to the first door
	(cs_go_by pts_johnson_unlock_hdoor/hack_path0 pts_johnson_unlock_hdoor/hack_path1)
	(cs_go_by pts_johnson_unlock_hdoor/hack_path1 pts_johnson_unlock_hdoor/hack_path2)
	(cs_go_by pts_johnson_unlock_hdoor/hack_path2 pts_johnson_unlock_hdoor/hack_path3)
	(cs_go_by pts_johnson_unlock_hdoor/hack_path3 pts_johnson_unlock_hdoor/hack_path4)
	(cs_go_by pts_johnson_unlock_hdoor/hack_path4 pts_johnson_unlock_hdoor/hack_path5)
	(cs_go_by pts_johnson_unlock_hdoor/hack_path5 pts_johnson_unlock_hdoor/hack_path6)
	(cs_go_by pts_johnson_unlock_hdoor/hack_path6 pts_johnson_unlock_hdoor/hack_path7)
	(cs_go_by pts_johnson_unlock_hdoor/hack_path7 pts_johnson_unlock_hdoor/hack_path8)
	(cs_go_to pts_johnson_unlock_hdoor/hack_path8)
	(cs_face true pts_johnson_unlock_hdoor/hack_path9)

	(sleep (game_ticks_from_seconds 1))
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true)
	(f_attach_hacking_device)
	(wake dialogue_any_way_to_speed_this_up)

	(custom_animation_loop ai_johnson "objects\characters\marine\marine" "using_device_loop" true)
	(device_set_position_immediate dm_control_panel_01 0.5) ;vignette machine

	(sleep_until b_johnson_says_done 1)
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true)
	(device_set_position_immediate dm_control_panel_01 1) ;vignette machine
	(f_destroy_hacking_device)
	(unit_stop_custom_animation ai_johnson)
	(set b_johnson_is_ready true)
	(cs_face false pts_johnson_unlock_hdoor/hack_path9)
	(cs_walk false)
	(cs_lower_weapon false)
	;(ai_set_objective ai_johnson obj_johnson_follow)
)

(script static void f_attach_hacking_device
    (sleep (game_ticks_from_seconds 2.0))
	(print "attach hacking device to johnson")
	(object_create sc_hacking_device)
	(objects_attach ai_johnson "attach_hacking_device" sc_hacking_device "attach")
	(sleep_until ( = (unit_is_playing_custom_animation ai_johnson) false) 1 )
	(print "attach_hacking_device sleep complete")
)

(script static void f_destroy_hacking_device
	(sleep (game_ticks_from_seconds 2.33))
	(object_destroy sc_hacking_device)
	(sleep_until ( = (unit_is_playing_custom_animation ai_johnson) false) 1 )
	(print "destroy_hacking_device sleep complete")
)

(script dormant open_first_door
	(sleep_until (= b_johnson_first_hack_complete true) 1 (game_ticks_from_seconds 60))
		(if (= b_johnson_first_hack_complete false)
			(set b_johnson_first_hack_complete true)
		)
	(f_game_save) ;save the game
	(wake dock_second)
	(wake trigger_johnson_opens_path)
	(device_set_power dm_johnson_hack_door_hanger 1)
	(device_set_position dm_johnson_hack_door_hanger 1)
	(ai_cannot_die ai_johnson false)

	(cs_run_command_script ai_johnson clear_commands)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
)

; --------------------------------------------------------------------------------
;                 beat 1 - johnson enters_the_airlock - hangar
; --------------------------------------------------------------------------------
(script command_script cs_johnson_enters_the_airlock
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(wake spawn_hanger_ambush)
	(cs_go_by pts_johnson_enters_airlock/p0 pts_johnson_enters_airlock/p0)
	(cs_move_towards_point pts_johnson_enters_airlock/p1 .5)
	(ai_cannot_die ai_johnson false)
)

(script dormant spawn_hanger_ambush
	(sleep_until (volume_test_object tv_trigger_johnson_opens_path ai_johnson) 1)
	(ai_place sq_dock_ambush_elite)
	;------- co-op/difficulty setup for encounter --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place sq_dock_ambush_elite2)
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place sq_dock_ambush_elite3)
		)
	)
)

; --------------------------------------------------------------------------------
;                 beat 1 - johnson forcefield unlock - hangar
; --------------------------------------------------------------------------------
;; johnson sent to unlock the forcefield in the hangar
(script dormant johnson_in_first_airlock
	(sleep_until (and
				(= b_chief_in_airlock 0)
				(volume_test_object tv_johnson_in_first_airlock ai_johnson)
				)
				1
	)
	(device_set_power dm_johnson_airlock_door_1a 1)
	(device_set_power dm_johnson_airlock_door_1b 1)

	(sleep_until (= (device_get_position dm_johnson_airlock_door_1a) 0) 1)
	(ai_suppress_combat ai_johnson true)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_goto_forcefield_console)
	(wake elite_ambusher_strikes)

	;sleep until johnson hacks the forcefield or a certain amount of time passes for a fallback
	(sleep_until (= b_johnson_in_position_ff true) 1 (game_ticks_from_seconds 60))
		(if (= b_johnson_in_position_ff false)
			(set b_johnson_in_position_ff true)
		)
	(device_set_position dm_hangar_barrier 1)

	(sleep (game_ticks_from_seconds 1))
	(f_unblip_all) ;remove all navpoints
	(wake blip_the_far_hanger_door)
	(wake blip_the_dropships)
	(object_destroy dm_hangar_barrier) ; destroying for now since collision doesnt currently go away
)

(script command_script cs_goto_forcefield_console
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(ai_set_objective ai_johnson obj_johnson_hanger_schenanigans)
	(cs_walk false)
	(cs_go_by pts_johnson_unlock_ff/p0 pts_johnson_unlock_ff/p0)
	(wake set_door_b_to_no_power)
	(set b_johnson_is_through_airlock true) ; stop the looping script checking for the player
	(cs_go_by pts_johnson_unlock_ff/p1 pts_johnson_unlock_ff/p1)
	(cs_go_by pts_johnson_unlock_ff/p2 pts_johnson_unlock_ff/p2)
	(cs_go_to_and_face pts_johnson_unlock_ff/p3 pts_johnson_unlock_ff/p4)
	(print "johnson is in the zone")

	(sleep (game_ticks_from_seconds .25))

	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true)
	(f_attach_hacking_device)

	(custom_animation_loop ai_johnson "objects\characters\marine\marine" "using_device_loop" true)
	(device_set_position_immediate dm_control_panel_02 0.5) ;vignette machine

	(sleep (game_ticks_from_seconds 1)) ;;was3
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true)

	(device_set_position_immediate dm_control_panel_02 1) ;vignette machine
	(f_destroy_hacking_device)
	(set b_johnson_in_position_ff true)
	(unit_stop_custom_animation ai_johnson)
	(ai_suppress_combat ai_johnson false)
	(wake did_johnson_fall_in_hanger)
	(set s_johnson_hanger_point_checker (+ s_johnson_hanger_point_checker 1));position #1
	(print "fall script has been woken")
	(cs_go_by pts_johnson_db_firstgravlift/p3 pts_johnson_db_firstgravlift/p4)
	(cs_go_by pts_johnson_db_firstgravlift/p4 pts_johnson_db_firstgravlift/p0)
	(cs_move_towards_point pts_johnson_db_firstgravlift/p0 .5)
	;(cs_go_by pts_johnson_db_firstgravlift/p0 pts_johnson_db_firstgravlift/p0)
	(cs_go_by pts_johnson_db_firstgravlift/p1 pts_johnson_db_firstgravlift/p1)
	(cs_go_by pts_johnson_teleport_sniperpost/p1 pts_johnson_teleport_sniperpost/p2)
	(cs_go_to pts_johnson_teleport_sniperpost/p2)
	(set b_johnson_has_hacked_ff true)
	;(ai_cannot_die ai_johnson false)
	(f_game_save) ;save the game
)
(script dormant set_door_b_to_no_power
	;after johnson gets through the 2nd door, kill its power when it closes
	(sleep_until (= (device_get_position dm_johnson_airlock_door_1b) 0) 1)
	(device_set_power dm_johnson_airlock_door_1b 0)
)

; --------------------------------------------------------------------------------
;                  beat 1 - johnson sniper positions - hangar
; --------------------------------------------------------------------------------
;; note - johnson is sent to point a in the script where he hacks open the forcefield
;; johnson sent to his sniper point b in the hanger
(script dormant johnson_hanger_sniper_time_b
	(sleep_until (volume_test_players tv_johnson_goto_hanger_station_b) 1)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(print "johnson heading to sniper point b")
	(cs_run_command_script ai_johnson cs_johnson_hanger_powershot1)
)
(script command_script cs_johnson_hanger_powershot1
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(set s_johnson_hanger_point_checker (+ s_johnson_hanger_point_checker 1));position #2
	(cs_go_by pts_johnson_hanger_grenadeshot1/powershot_pt1 pts_johnson_hanger_grenadeshot1/powershot_pt1)
	(cs_go_by pts_johnson_hanger_grenadeshot1/powershot_pt2 pts_johnson_hanger_grenadeshot1/powershot_pt2)
	(cs_go_by pts_johnson_hanger_grenadeshot1/powershot_pt3 pts_johnson_hanger_grenadeshot1/powershot_pt3)
	(cs_go_by pts_johnson_hanger_grenadeshot1/powershot_pt4 pts_johnson_hanger_grenadeshot1/powershot_pt4)
	(cs_go_by pts_johnson_hanger_grenadeshot1/powershot_pt5 pts_johnson_hanger_grenadeshot1/powershot_pt5)
	(cs_go_to pts_johnson_hanger_grenadeshot1/powershot_pt6)
	(ai_place_cue johnson_accuracy_cue)
	(cs_aim_object true cr_hanger_cover5)

	(sleep (game_ticks_from_seconds 1))
	(cs_shoot true cr_hanger_cover5)
	(print "johnson took the shot and killed some covenant aliens")

	(sleep (game_ticks_from_seconds .5))

	(wake dialogue_johnson_two_for_one)
	(sleep_until (script_finished dialogue_johnson_two_for_one) 1)

	(sleep (game_ticks_from_seconds 2))
	(ai_remove_cue johnson_accuracy_cue)
	;(ai_cannot_die ai_johnson false)
)

;; johnson sent to his sniper point c in the hanger
(script dormant johnson_hanger_sniper_time_c
	(sleep_until (volume_test_players tv_johnson_goto_hanger_station_c) 1)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(print "johnson heading to sniper point c")
	(cs_run_command_script ai_johnson cs_johnson_hanger_sniper_post_c)
)
(script command_script cs_johnson_hanger_sniper_post_c
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(set s_johnson_hanger_point_checker (+ s_johnson_hanger_point_checker 1));position #3
	(cs_go_to pts_johnson_hanger_sniper_c/p0)
	;(ai_cannot_die ai_johnson false)
)

;; johnson sent to his sniper point d in the hanger
(script dormant johnson_hanger_sniper_time_d
	(sleep_until (volume_test_players tv_johnson_goto_hanger_station_d) 1)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(print "johnson heading to sniper point c")
	(cs_run_command_script ai_johnson cs_johnson_hanger_powershot2)
)
(script command_script cs_johnson_hanger_powershot2
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(set s_johnson_hanger_point_checker (+ s_johnson_hanger_point_checker 1));position #4
	(cs_go_to_and_face pts_johnson_hanger_powershot2/p0 pts_johnson_hanger_powershot2/p1)
	(ai_place_cue johnson_accuracy_cue)
	(cs_aim_object true cr_hanger_cover6)

	(sleep (game_ticks_from_seconds 1))
	(cs_shoot true cr_hanger_cover6)
	(print "johnson took the shot and killed some covenant aliens")

	(sleep (game_ticks_from_seconds .5))


	(wake dialogue_johnson_shooting_gallery)
	(sleep_until (script_finished dialogue_johnson_shooting_gallery) 1)

	(sleep (game_ticks_from_seconds 2))
	(ai_remove_cue johnson_accuracy_cue)
	;(ai_cannot_die ai_johnson false)
)

;; johnson sent to his sniper point c in the hanger - part 2
(script dormant johnson_hanger_sniper_time_c2
	(sleep_until (volume_test_players tv_johnson_goto_hanger_station_c2) 1)
	(print "johnson heading to sniper point c")
	(cs_run_command_script ai_johnson cs_johnson_hanger_sniper_post_c2)
)
(script command_script cs_johnson_hanger_sniper_post_c2
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(set s_johnson_hanger_point_checker (+ s_johnson_hanger_point_checker 1));position #5
	(cs_go_to pts_johnson_hanger_sniper_c/p0)
	(ai_disregard (ai_actors sq_spirit_dropship_b/pilot_spawn) true)
	;(ai_cannot_die ai_johnson false)
)

; --------------------------------------------------------------------------------
;                  beat 1 - johnson teleport back onto sniper post if he falls
; --------------------------------------------------------------------------------
(script dormant did_johnson_fall_in_hanger
	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_did_johnson_fall_hanger ai_johnson) 1)
			(print "johnson is in volume")
			(if (= s_johnson_hanger_point_checker 1) ;at position #1
				(ai_teleport ai_johnson pts_johnson_teleport_sniperpost/p2)
			)
			(if (= s_johnson_hanger_point_checker 2) ;at position #2
				(ai_teleport ai_johnson pts_johnson_hanger_grenadeshot1/powershot_pt4)
			)
			(if (= s_johnson_hanger_point_checker 3) ;at position #3
				(ai_teleport ai_johnson pts_johnson_hanger_sniper_c/p0)
			)
			(if (= s_johnson_hanger_point_checker 4) ;at position #4
				(ai_teleport ai_johnson pts_johnson_hanger_powershot2/p0)
			)
			(if (= s_johnson_hanger_point_checker 5) ;at position #5
				(ai_teleport ai_johnson pts_johnson_hanger_sniper_c/p0)
			)
			(= b_johnson_goto_huntertown true)
		)
	1
	)
)

; --------------------------------------------------------------------------------
;                 beat 1 - johnson get to the hunters - hangar
; --------------------------------------------------------------------------------
; run the command script on johnson to go to hunter town
(script dormant johnson_goto_hunter_town
	(sleep_until (or
				(volume_test_players tv_johnson_goto_hunter_town)
				(= (ai_living_count gr_airborne) 0)
				)
				1
	)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_goto_hunter_town)
)

(script command_script cs_johnson_goto_hunter_town
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(set b_johnson_goto_huntertown true)
	; johnson walks to hunter town
	(print "johnson tries to meet up with chief at hunter town")
	;get off the ring
	(cs_go_by pts_johnson_get_off_ring/p0 pts_johnson_get_off_ring/p0)
	(cs_go_by pts_johnson_get_off_ring/p1 pts_johnson_get_off_ring/p1)
	(cs_go_by pts_johnson_get_off_ring/p2 pts_johnson_get_off_ring/p2)
	(cs_go_by pts_johnson_get_off_ring/p3 pts_johnson_get_off_ring/p3)
	(cs_go_by pts_johnson_get_off_ring/p4 pts_johnson_get_off_ring/p4)

	;move to huntertown
	(cs_go_by pts_johnson_huntertown/p0 pts_johnson_huntertown/p0)
	(cs_go_by pts_johnson_huntertown/p1 pts_johnson_huntertown/p1)
	(cs_go_by pts_johnson_huntertown/p2 pts_johnson_huntertown/p2)
	(cs_go_by pts_johnson_huntertown/p3 pts_johnson_huntertown/p3)
	(cs_go_by pts_johnson_huntertown/p4 pts_johnson_huntertown/p4)
	(cs_go_by pts_johnson_huntertown/p5 pts_johnson_huntertown/p5)
	(cs_go_to pts_johnson_huntertown/p6)
	(ai_cannot_die ai_johnson false)
)
; -----------------------------------------------------------------------------------------------------------
;                 beat 1 - johnson sorts out the grav lift after the hunters are dead and exits the hanger
; -----------------------------------------------------------------------------------------------------------
(script command_script cs_johnson_turn_on_exit_gravlift
	(ai_cannot_die ai_johnson true)
	(wake johnson_can_leave_hangar)
	(wake johnson_heads_to_rr)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(cs_force_combat_status 2)
	(cs_go_by pts_johnson_hanger_gravlift/p2 pts_johnson_hanger_gravlift/p2)
	(cs_go_to pts_johnson_hanger_gravlift/p3)
	(cs_face true pts_johnson_hanger_gravlift/p4)

	(sleep (game_ticks_from_seconds 1)) ;;.25
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true)
	(f_attach_hacking_device)

	(custom_animation_loop ai_johnson "objects\characters\marine\marine" "using_device_loop" true)
	(device_set_position_immediate dm_control_panel_03 0.5) ;vignette machine

	(sleep (game_ticks_from_seconds 1)) ;was3
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true)
	(device_set_position_immediate dm_control_panel_03 1) ;vignette machine
	(f_destroy_hacking_device)
	(set b_johnson_hacked_hanger_lift true)
	(unit_stop_custom_animation ai_johnson)
	(cs_face false pts_johnson_hanger_gravlift/p4)

	(sleep (game_ticks_from_seconds .75))
	(cs_go_by pts_johnson_exit_hanger/p0 pts_johnson_exit_hanger/p1)
	(cs_go_by pts_johnson_exit_hanger/p1 pts_johnson_exit_hanger/p2)
	(cs_go_by pts_johnson_exit_hanger/p2 pts_johnson_exit_hanger/p3)
	(cs_go_by pts_johnson_exit_hanger/p3 pts_johnson_exit_hanger/p4)
	(cs_go_by pts_johnson_exit_hanger/p4 pts_johnson_exit_hanger/p5)
	(cs_go_by pts_johnson_exit_hanger/p5 pts_johnson_exit_hanger/p6)
	(cs_go_by pts_johnson_exit_hanger/p6 pts_johnson_exit_hanger/p7)
	(cs_go_by pts_johnson_exit_hanger/p7 pts_johnson_exit_hanger/p8)
	(cs_go_by pts_johnson_exit_hanger/p8 pts_johnson_exit_hanger/p9)
	(cs_go_to pts_johnson_exit_hanger/p10)
	;(cs_go_by pts_johnson_exit_hanger/p9 pts_johnson_exit_hanger/p10)

	(sleep_until (= b_johnson_can_leave_hangar true) 1)
	(cs_go_by pts_johnson_exit_hanger/p10 pts_johnson_exit_hanger/p11)
	(cs_go_by pts_johnson_exit_hanger/p11 pts_johnson_exit_hanger/p11)
	(cs_jump_to_point 0 5)
	(cs_go_by pts_johnson_exit_hanger/p12 pts_johnson_exit_hanger/p12)
	(ai_cannot_die ai_johnson false)
	(f_game_save) ;save the game
)
(script dormant johnson_can_leave_hangar
	(sleep_until (volume_test_players tv_johnson_move_up) 1)
	(set b_johnson_can_leave_hangar true)
)
; --------------------------------------------------------------------------------
;                  beat 1 - johnson heads down the hallway to r&r
; --------------------------------------------------------------------------------
(script dormant johnson_heads_to_rr
	(sleep_until (volume_test_players tv_ponr_post_hanger_safezone) 1)
	(wake johnson_teleports_post_hunter) ;;; incase we need to teleport johnson

	(sleep_until (volume_test_object tv_ponr_post_hanger_safezone ai_johnson) 1)
	(sleep_forever johnson_teleports_post_hunter)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_rr_hallway_a)
)

(script command_script cs_johnson_rr_hallway_a
	(ai_cannot_die ai_johnson true)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(cs_force_combat_status 2)

	(sleep (game_ticks_from_seconds .5))
	(cs_go_by pts_pre_rr_hallway_a/p0 pts_pre_rr_hallway_a/p1)
	(cs_go_by pts_pre_rr_hallway_a/p1 pts_pre_rr_hallway_a/p2)
	(cs_move_towards_point pts_pre_rr_hallway_a/p2 .5)
	;(cs_go_by pts_pre_rr_hallway_a/p2 pts_pre_rr_hallway_a/p3)
	(cs_go_by pts_pre_rr_hallway_a/p3 pts_pre_rr_hallway_a/p4)
	(cs_go_by pts_pre_rr_hallway_a/p4 pts_pre_rr_hallway_a/p8)
	(cs_go_by pts_pre_rr_hallway_a/p8 pts_pre_rr_hallway_a/p9)
	(cs_go_by pts_pre_rr_hallway_a/p9 pts_pre_rr_hallway_a/p10)
	(cs_go_by pts_pre_rr_hallway_a/p10 pts_pre_rr_hallway_a/p13)
	(cs_go_by pts_pre_rr_hallway_a/p13 pts_pre_rr_hallway_a/p14)
	(cs_go_by pts_pre_rr_hallway_a/p14 pts_pre_rr_hallway_a/p15)
	(cs_go_to pts_pre_rr_hallway_a/p15)
	(ai_cannot_die ai_johnson false)
)

; -----------------------------------------------------------------------------------------------------
;                 beat 1 - johnson teleports to the upper deck if he falls after the hunters are dead
; -----------------------------------------------------------------------------------------------------
(script dormant teleport_johnson_to_upper_deck
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_teleport_to_upper_deck)
)

(script command_script cs_johnson_teleport_to_upper_deck
	(print "johnson-teleported back up to the upper deck after the hunters are dead")
	(cs_teleport pts_johnson_hunter_teleport/p0 pts_johnson_hunter_teleport/p0)
)

; --------------------------------------------------------------------------------
;                 beat 1 - failsafe teleport post hunter up the grav lift
; --------------------------------------------------------------------------------
; failsafe - teleport johnson up the lift incase he gets stuck
(script dormant johnson_teleports_post_hunter
	(sleep (game_ticks_from_seconds 15))

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds

	(if (not (volume_test_object tv_ponr_post_hanger_safezone ai_johnson ))
		(cs_run_command_script ai_johnson cs_johnson_teleports_post_hunter)
	)
)
(script command_script cs_johnson_teleports_post_hunter
	(cs_teleport pts_teleport_post_hunter/p0 pts_teleport_post_hunter/p0)
)

;====================================================================================================================================================================================================
;                 beat 2 - johnson stuff
;====================================================================================================================================================================================================

; --------------------------------------------------------------------------------
;                 beat 2 - johnson get to first sniper post - rr
; --------------------------------------------------------------------------------
; run the command script on johnson to go to 1st sniper post
(script dormant johnson_goto_1st_sniper_post_rr
	(sleep_until (volume_test_object tv_mc_johnson_split_at_rr ai_johnson) 1)
	(ai_player_remove_fireteam_squad player0 ai_johnson)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_rr_1st_sniper_post)
	(f_unblip_all) ;remove all navpoints
	(wake unblip_the_rr_bandaid)
	(wake did_johnson_fall_platform1_rr)
)
; cs script to walk him in position
(script command_script cs_johnson_rr_1st_sniper_post
	(ai_cannot_die ai_johnson true)

	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	; johnson walks to 1st sniper post - rr
	(print "johnson tries to walk to sniper post 1 - rr")
	(ai_set_objective ai_johnson obj_johnson_walk)
	(cs_force_combat_status 1)
	(cs_lower_weapon true)
	(cs_walk true)
	(cs_go_by pts_johnson_rr_1st_post/p0 pts_johnson_rr_1st_post/p0)
	(cs_go_by pts_johnson_rr_1st_post/p1 pts_johnson_rr_1st_post/p1)
	;(cs_go_to pts_johnson_rr_1st_post/p2)
	(cs_move_towards_point pts_johnson_rr_1st_post/p2 .5)
	(cs_walk false)
	(cs_lower_weapon false)

	(set b_johnson_at_first_post true)
	; not an ideal or elegant solution but it works
	(device_set_power dm_johnson_rr_door_to_lower_rr 1)
	(device_set_position dm_johnson_rr_door_to_lower_rr 1)
	(f_blip_flag fl_rr_to_gravlift 0)
	(ai_disregard (ai_actors ai_johnson) true)
	(cs_aim true pts_jackal_rr_patrol_b/p0)
	(ai_suppress_combat ai_johnson true)
	(print "johnson combat is suppressed... for now")
	(set s_johnson_rr_point_checker 1)

	(sleep (game_ticks_from_seconds 2))
	(cs_aim true pts_jackal_rr_patrol_a/p1)

	(sleep (game_ticks_from_seconds 2))
	(cs_aim true pts_jackal_rr_patrol_c/p0)

	(sleep (game_ticks_from_seconds 2))
	(cs_aim true pts_jackal_rr_patrol_b/p0)

	;(sleep_until (volume_test_players tv_johnson_at_ready_rr) 1)
	(cs_aim false pts_jackal_rr_patrol_b/p0)
	(ai_set_objective ai_johnson obj_johnson_rr_schenanigans)
	(ai_cannot_die ai_johnson false)
)

(script dormant unblip_the_rr_bandaid
	(sleep_until (volume_test_players tv_unblip_rr_bandaid) 1)
	(f_unblip_all) ;remove all navpoints
)

(script dormant turn_off_barriers_in_rr
	(sleep_until (volume_test_players tv_johnson_at_ready_rr) 1)
	(print "turn off the barriers")
	(device_set_position dm_rr_energy_barrier_window_c 1)
	(device_set_position dm_rr_energy_barrier_window_d 1)
	(sleep_until (= (device_get_position dm_rr_energy_barrier_window_c) 1) 1)
	(object_destroy dm_rr_energy_barrier_window_c) ; destroying for now since collision doesnt currently go away
	(object_destroy dm_rr_energy_barrier_window_d) ; destroying for now since collision doesnt currently go away
)
; detonation fun in r&r
(script command_script cs_johnson_hanger_powershot3
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(ai_place_cue johnson_accuracy_cue)

	(sleep (game_ticks_from_seconds .5))
	(cs_shoot true cr_cover_rr7)

	(sleep (game_ticks_from_seconds .5))


	(wake dialogue_johnson_strike)
	(sleep_until (script_finished dialogue_johnson_strike) 1)

	(sleep (game_ticks_from_seconds 1))
	(ai_suppress_combat ai_johnson false)
	(print "johnson took the shot and killed some covenant aliens")

	(sleep (game_ticks_from_seconds 2))
	(wake dialogue_sophie_says_hi)
	(ai_remove_cue johnson_accuracy_cue)
	(ai_place gr_rest_respite_reins)
	(ai_disregard (ai_actors ai_johnson) false)
	(ai_cannot_die ai_johnson false)
)

; --------------------------------------------------------------------------------
;                 beat 2 - johnson get to 2nd sniper post - rr
; --------------------------------------------------------------------------------
; run the command script on johnson to go to 2nd sniper post
(script dormant johnson_goto_2nd_sniper_post_rr
	(sleep_until (volume_test_players tv_johnson_rr_2nd_sniper_post) 1)
	(f_game_save) ;save the game
	(device_set_power dm_johnson_rr_door_to_post 1)
	(set b_chief_dawdles_in_rr_lower false);reset the variable that will control another vo bit from johnson
	(wake did_johnson_fall_platform2_rr)
	(set s_johnson_rr_point_checker 2)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_rr_2nd_sniper_post)
)

; cs script to run him in position
(script command_script cs_johnson_rr_2nd_sniper_post
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(cs_walk false)
	; johnson runs to 2nd sniper post - rr
	(print "johnson tries to walk to sniper post 2 - rr")
	;(cs_go_to pts_johnson_rr_2nd_spost/p0)
	(cs_move_towards_point pts_johnson_rr_2nd_spost/p0 .5)
	(cs_move_towards_point pts_johnson_rr_2nd_spost/p1 .5)
	(cs_move_towards_point pts_johnson_rr_2nd_spost/p2 .5)
	(cs_move_towards_point pts_johnson_rr_2nd_spost/p3 .5)
	;(cs_go_by pts_johnson_rr_2nd_spost/p4 pts_johnson_rr_2nd_spost/p4)
	(cs_move_towards_point pts_johnson_rr_2nd_spost/p4 .5)
	(ai_cannot_die ai_johnson false)
)

; --------------------------------------------------------------------------------
;                 beat 2 - johnson teleports back onto his perch if he falls
; --------------------------------------------------------------------------------
(script dormant did_johnson_fall_platform1_rr
	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_johnson_perch_teleport1_rr ai_johnson) 1)
			(print "johnson is in volume1")
			(if (= s_johnson_rr_point_checker 1) ;at position #1
				(ai_teleport ai_johnson pts_johnson_tele_rr_sniperpost1/p0)
			)
			(= s_johnson_rr_point_checker 2) ;;when moving to point 2
		)
	1
	)
)

(script dormant did_johnson_fall_platform2_rr
	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_johnson_perch_teleport2_rr ai_johnson) 1)
			(print "johnson is in volume2")
			(if (= s_johnson_rr_point_checker 2) ;at position #2
				(ai_teleport ai_johnson pts_johnson_tele_rr_sniperpost2/p0)
			)
			(= s_johnson_rr_point_checker 3) ;;when heading to the dojo
		)
	1
	)
)

; --------------------------------------------------------------------------------
;                 beat 2 - johnson sniping - dojo
; --------------------------------------------------------------------------------
; run the command script on johnson to go to 1st sniper post
(script dormant johnson_sniping_at_the_dojo
	(sleep_until (and
				(= s_rr_check_for_final_wave 3); move to dojo when enc 6-8 are complete
				(> (object_get_health (object_get_ai ai_johnson)) 0); make sure johnson has health before the script proceeds
				)
				1
	)
	;(sleep_until (= s_rr_check_for_final_wave 3) 1) ; move to dojo when enc 6-8 are complete
	(cs_run_command_script ai_johnson cs_johnson_sniping_at_the_dojo)
)
; cs script to walk him in position
(script command_script cs_johnson_sniping_at_the_dojo
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(ai_suppress_combat ai_johnson true)
	(cs_walk false)
	(set s_johnson_rr_point_checker 3)
	; johnson runs to sniper post - the dojo
	(print "johnson tries to run to sniper post - the dojo")
	(cs_go_by pts_johnson_goto_dojo/p0 pts_johnson_goto_dojo/p0)
	(cs_go_by pts_johnson_goto_dojo/p1 pts_johnson_goto_dojo/p1)
	(cs_go_by pts_johnson_goto_dojo/p2 pts_johnson_goto_dojo/p2)
	(cs_go_by pts_johnson_goto_dojo/p3 pts_johnson_goto_dojo/p3)
	(cs_go_by pts_johnson_goto_dojo/p4 pts_johnson_goto_dojo/p4)
	(cs_go_by pts_johnson_goto_dojo/p5 pts_johnson_goto_dojo/p5)
	(cs_go_by pts_johnson_goto_dojo/p6 pts_johnson_goto_dojo/p6)

	(sleep_until (= b_johnson_combat_dojo_time true) 1)
	(cs_move_towards_point pts_johnson_goto_dojo/p7 .5)

	(sleep_until (= b_combat_in_dojo_is_go true) 1)
	(ai_cannot_die ai_johnson false)
	(ai_suppress_combat ai_johnson false)
	(ai_set_objective ai_johnson obj_johnson_dojo_sniper_post)
)

; --------------------------------------------------------------------------------
;                 beat 2 - set johnsons kill boolean dojo temp
; --------------------------------------------------------------------------------
; keeps johnson from going into combat mode before i arrive
(script dormant set_johnsons_kill_bool_dojo
	(sleep_until (volume_test_players tv_set_johnsons_kill_bool_dojo) 1)
	(print "trigger the kill bool")
	(wake is_johnson_in_dojo)
	(wake dialogue_entering_the_dojo)
	(set b_johnson_combat_dojo_time true) ;this triggers a task in obj_johnson_dojo_sniper_post
)

; --------------------------------------------------------------------------------
;                 beat 2 - johnson move to grav bridge (in dojo) - dojo
; --------------------------------------------------------------------------------
; run the command script on johnson to go to the grav bridge
(script dormant johnson_move_to_gravbridge
	(sleep_until
		(or
			(b_johnson_move_to_gravbridge)
			(b_johnson_teleport_to_gravbridge)
		)
		1
	)

	(if
		(b_johnson_move_to_gravbridge)
		;then
		(begin
			(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
			(cs_run_command_script ai_johnson cs_johnson_move_to_gravbridge)
		)
		;else
		(begin
			(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
			(cs_run_command_script ai_johnson cs_johnson_teleport_to_gravbridge)
		)
	)

	(wake turn_on_gravbridge)
)

(script static boolean b_johnson_move_to_gravbridge
	(and
		(= b_johnson_is_in_dojo true);johnson is in the dojo
		(= b_johnson_can_trigger_gb true);all the enemies are dead
	)
)

(script static boolean b_johnson_teleport_to_gravbridge
	(and
		(= b_johnson_is_in_dojo false); johnson never made it into the dojo
		(= b_johnson_can_trigger_gb true);all the enemies are dead
		(volume_test_players tv_johnson_move_to_gravbridge)
	)
)

; cs script to walk him in position
(script command_script cs_johnson_move_to_gravbridge
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	; johnson runs to sniper post - the dojo
	(print "johnson tries to run to the gravbridge - the dojo")
	(cs_go_by pts_johnson_mind_gap_path/p2 pts_johnson_mind_gap_path/p2)
	(cs_go_to pts_johnson_mind_gap_path/p3)
	(ai_cannot_die ai_johnson false)
	(f_game_save) ;save the game
)

(script dormant turn_on_gravbridge
	(sleep_until (and
				(volume_test_players tv_mind_the_gap);player is up on platform by johnson
				(= (ai_nonswarm_count gr_dojo_reins) 0);all the enemies are dead
				)
				1
	)
	(wake player_has_crossed_gb)
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_turn_on_gravbridge)
	(wake dojo_gravbridge_out_of_room_on)
)

(script command_script cs_johnson_turn_on_gravbridge
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(ai_set_objective ai_johnson obj_johnson_walk)
	(cs_walk true)
	(cs_force_combat_status 1)
	(cs_lower_weapon true)

	(sleep (game_ticks_from_seconds .5))


	(wake dialogue_mind_the_gap)
	(sleep_until (script_finished dialogue_mind_the_gap) 1)

	(cs_go_to pts_johnson_mind_gap_path/p4)
	(cs_face true pts_johnson_mind_gap_path/p5)

	(sleep (game_ticks_from_seconds 1))
	(cs_walk false)
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true)
	(f_attach_hacking_device)
	(custom_animation_loop ai_johnson "objects\characters\marine\marine" "using_device_loop" true)
	(device_set_position_immediate dm_control_panel_4 0.5) ;vignette machine

	(sleep (game_ticks_from_seconds 1.5))


	(wake dialogue_give_me_a_second)
	(sleep_until (script_finished dialogue_give_me_a_second) 1)

	(sleep (game_ticks_from_seconds 2.5))
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true)
	(device_set_position_immediate dm_control_panel_4 1) ;vignette machine
	(f_destroy_hacking_device)
	(cs_face false pts_johnson_mind_gap_path/p5)
	(cs_face_player true)
	(device_set_position_immediate dm_grav_bridge_dojo_enter .25) ;vignette machine that sets the grav bridge you see when you enter the dojo to start fading away for the exit bridge


	(wake dialogue_lets_hustle)
	(sleep_until (script_finished dialogue_lets_hustle) 1)

	(unit_stop_custom_animation ai_johnson)
	(set b_johnson_hacked_grav_bridge true)

	(sleep_until (= b_player_has_crossed_gb true) 1)
	(cs_lower_weapon false)
	(ai_set_objective ai_johnson obj_johnson_follow)
	(cs_go_to pts_johnson_across_gravbridge/p0)
	(cs_go_by pts_johnson_across_gravbridge/p1 pts_johnson_across_gravbridge/p1)
	(cs_jump_to_point 3 0)
	(cs_go_by pts_johnson_across_gravbridge/p2 pts_johnson_across_gravbridge/p2)
	(cs_go_by pts_johnson_across_gravbridge/p3 pts_johnson_across_gravbridge/p3)

	(sleep (game_ticks_from_seconds .5))
	(ai_cannot_die ai_johnson false)
	(f_game_save) ;save the game
)
(script dormant player_has_crossed_gb
	(sleep_until (volume_test_players tv_unblip_gravbridge_navpoint) 1)
	(set b_player_has_crossed_gb true)
)

; --------------------------------------------------------------------------------
;                 beat 2 - johnson teleports to grav bridge (not in dojo) - dojo
; --------------------------------------------------------------------------------

;teleport to gravbridge
(script command_script cs_johnson_teleport_to_gravbridge
	(print "johnson teleports into the glr")
	(ai_cannot_die ai_johnson true)
	(cs_teleport pts_teleport_to_grav_bridge/p0 pts_teleport_to_grav_bridge/p0)
	(f_game_save) ;save the game
)

; --------------------------------------------------------------------------------
;                 beat 2 - johnson teleports past grav bridge in dojo if stuck
; --------------------------------------------------------------------------------
; teleport johnson past the grav bridge after a certain amount of time if he gets stuck
(script dormant johnson_teleports_past_grav_bridge
	(sleep_until (volume_test_players tv_teleport_past_grav_bridge) 1)
	(f_unblip_all) ;remove all navpoints

	(sleep (game_ticks_from_seconds 8)) ;;12

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds

	(if (not (volume_test_object tv_teleport_past_grav_bridge ai_johnson ))
		(cs_run_command_script ai_johnson cs_johnson_teleport_past_grav_bridge)
	)
)

(script command_script cs_johnson_teleport_past_grav_bridge
	(print "johnson teleports past the grav bridge in the dojo")
	(unit_stop_custom_animation ai_johnson)
	(ai_cannot_die ai_johnson false)
	(ai_set_objective ai_johnson obj_johnson_follow)
	(cs_teleport pts_teleport_past_grav_bridge/p0 pts_teleport_past_grav_bridge/p0)
)

; --------------------------------------------------------------------------------
;                 beat 2 - johnson check for the dojo
; --------------------------------------------------------------------------------
(script dormant is_johnson_in_dojo
	(sleep_until (volume_test_object tv_entering_the_dojo ai_johnson) 1)
	(print "johnson is in the dojo")
	(set b_johnson_is_in_dojo true)
)

;====================================================================================================================================================================================================
;                 beat 3 - johnson stuff
;====================================================================================================================================================================================================
; --------------------------------------------------------------------------------
;                 beat 3 - johnson heads to the testing facility
; --------------------------------------------------------------------------------
(script dormant johnson_heads_to_tf
	(sleep_until (or
				(= (ai_nonswarm_count sq_gear_room_sleepers) 0)
				(volume_test_players tv_johnson_catch_up)
				)
				1
	)
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_heads_to_tf_initial)
)

(script command_script cs_johnson_heads_to_tf_initial
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	;(cs_go_by pts_johnson_to_tf_initial/p0 pts_johnson_to_tf_initial/p0)
	;(cs_go_by pts_johnson_to_tf_initial/p1 pts_johnson_to_tf_initial/p1)
	;(cs_go_by pts_johnson_to_tf_initial/p2 pts_johnson_to_tf_initial/p2)
	(cs_go_by pts_johnson_to_tf_initial/p3 pts_johnson_to_tf_initial/p3)
	(cs_walk true)
	(cs_go_to pts_johnson_to_tf_initial/p4)

	(sleep (game_ticks_from_seconds .5))
	(ai_cannot_die ai_johnson false)
	(cs_walk false)
	(sleep_until (volume_test_players tv_geneforge_testing1) 1)
)

; --------------------------------------------------------------------------------
;                 beat 3 - johnson wanders - testing facility
; --------------------------------------------------------------------------------
(script command_script cs_johnson_wanders_testing_facility
	(set b_first_time_entry_tf true)
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(ai_set_objective ai_johnson obj_johnson_walk)
	(cs_force_combat_status 1)
	(cs_lower_weapon true)
	(cs_walk true)
	(print "johnson wanders the testing facility")
	(device_set_power dm_testing_facility_door 1)
	(cs_face true pts_johnson_wander_tf/p1)
	(sleep (game_ticks_from_seconds .5))
	(cs_face false pts_johnson_wander_tf/p1)
	(cs_go_by pts_johnson_wander_tf/p0 pts_johnson_wander_tf/p0)
	(cs_go_by pts_johnson_wander_tf/p1 pts_johnson_wander_tf/p1)
	(cs_go_to pts_johnson_wander_tf/p2)
	(cs_face true pts_johnson_wander_tf/p3)
	;(custom_animation_loop ai_johnson "objects\characters\marine\marine" "alert:rifle:idle" true)

	(sleep (game_ticks_from_seconds .5))
	(cs_look true pts_johnson_look_at_tanks/p0)

	(sleep (game_ticks_from_seconds 2))
	(cs_look true pts_johnson_look_at_tanks/p1)

	(sleep (game_ticks_from_seconds 2))
	(cs_look true pts_johnson_look_at_tanks/p2)

	(sleep (game_ticks_from_seconds 1))
	(cs_look false pts_johnson_look_at_tanks/p2)

	(sleep_until (script_finished "dialogue_geneforge_testing1") 1)
	;(unit_stop_custom_animation ai_johnson)
	(set b_johnson_opendoor_tf true)
	(f_blip_flag fl_testingfacilty_hack 0)
	(ai_cannot_die ai_johnson false)
	;(sleep (game_ticks_from_seconds .5))
	;(ai_player_add_fireteam_squad player0 ai_johnson)
	;(ai_set_objective ai_johnson obj_johnson_follow)
)

; ---------------------------------------------------------------------------------------------------------
;                 beat 3 - johnson opens the door out in testing facility then heads down the hall to sf
; ---------------------------------------------------------------------------------------------------------
(script command_script cs_johnson_opens_door_testing_facility
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	;(ai_player_remove_fireteam_squad player0 ai_johnson)
	; johnson runs to open a door
	(print "johnson tries to open the door out of the testing facility")
	(cs_force_combat_status 2)
	(cs_walk false)
	(wake dialogue_ill_crack_it_open)
	(cs_go_to pts_johnson_open_door_tf/hack_path_p1)
	(cs_face true pts_johnson_open_door_tf/hack_path_p2)

	(sleep (game_ticks_from_seconds 1))

	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true)
	(f_attach_hacking_device)

	(custom_animation_loop ai_johnson "objects\characters\marine\marine" "using_device_loop" true)
	(device_set_position_immediate dm_control_panel_05 0.5) ;vignette machine
	(ai_place sq_pre_storage_hallway)

	(sleep (game_ticks_from_seconds 1)) ;was3
	(set b_path_forward_is_open true)
	;(device_set_power dm_johnson_hack_door_tf 1)
	(f_unblip_all) ;remove all navpoints
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true)
	(device_set_position_immediate dm_control_panel_05 1) ;vignette machine
	(f_destroy_hacking_device)
	(unit_stop_custom_animation ai_johnson)
	(cs_face false pts_johnson_open_door_tf/hack_path_p2)
	(f_blip_flag fl_geneforge_ll_entry 0)
	(set b_johnson_opendoor_tf false) ;reset so on the return trip he doesnt try to re-hack the door again
	(ai_cannot_die ai_johnson false)
	(f_game_save) ;save the game
	(cs_go_by pts_johnson_path_to_sf_initial/p0 pts_johnson_path_to_sf_initial/p1)
	;(cs_go_by pts_johnson_path_to_sf_initial/p1 pts_johnson_path_to_sf_initial/p2)
	(cs_move_towards_point pts_johnson_path_to_sf_initial/p2 .5)
	(sleep (game_ticks_from_seconds .25))
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
)
(script dormant hallway_is_clear
	(sleep_until (>= (ai_nonswarm_count sq_pre_storage_hallway) 1) 1)

	(sleep_until (and
			(<= (ai_nonswarm_count sq_pre_storage_hallway) 0)
			(> (object_get_health (object_get_ai ai_johnson)) 0) ; make sure johnson has health before the script proceeds
			)
			1
	)
	(cs_run_command_script ai_johnson cs_johnson_completes_his_path)
)
(script command_script cs_johnson_completes_his_path
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe false)
	(cs_ignore_obstacles false)
	;;(cs_go_by pts_johnson_path_to_sf_initial/p2 pts_johnson_path_to_sf_initial/p3)
	;(cs_go_by pts_johnson_path_to_sf_initial/p3 pts_johnson_path_to_sf_initial/p4)
	;(cs_go_by pts_johnson_path_to_sf_initial/p4 pts_johnson_path_to_sf_initial/p5)
	(cs_go_to pts_johnson_path_to_sf_initial/p5)
	(cs_force_combat_status 1)
	(ai_suppress_combat ai_johnson true)
	(ai_cannot_die ai_johnson false)
	(f_game_save) ;save the game
	(sleep_until (volume_test_players tv_encounter_12_5) 1)
)
(script dormant wake_tf_exit_door
	(sleep_until (= b_path_forward_is_open true) 1 (game_ticks_from_seconds 60))
		(if (= b_path_forward_is_open false)
			(set b_path_forward_is_open true)
		)
	(device_set_power dm_johnson_hack_door_tf 1)
)

(script command_script cs_johnson_teleport_upper_storage
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds

	(print "johnson-teleports into the upper storage")
	(cs_teleport pts_teleport_into_upper_storage/p0 pts_teleport_into_upper_storage/p0)
)

;====================================================================================================================================================================================================
;                 beat 4 - johnson stuff
;====================================================================================================================================================================================================

; --------------------------------------------------------------------------------
;                 beat 4 - set johnsons placement post cine 4
; --------------------------------------------------------------------------------
; johnson teleports into geneforge lower lab
(script command_script cs_johnson_teleports_cine4
	(print "johnson teleports into genforge after cine4")
	(cs_teleport pt_teleport_johnson_cine4/p0 pt_teleport_johnson_cine4/p0)
)

; -----------------------------------------------------------------------------------
;                 beat 4 - johnson exits the geneforge ll after wave 4 is eliminated
; -----------------------------------------------------------------------------------

(script command_script cs_johnson_exits_gf_ll
	(ai_cannot_die ai_johnson true)
	(cs_force_combat_status 2)
	(cs_go_by pts_johnson_exit_gf_ll/p0 pts_johnson_exit_gf_ll/p0)
	(cs_go_by pts_johnson_exit_gf_ll/p1 pts_johnson_exit_gf_ll/p1)
	(ai_cannot_die ai_johnson false)
	(sleep_until (volume_test_players tv_johnson_teleports_post_ll) 1)
)

; --------------------------------------------------------------------------------
;                 beat 4 - set johnsons placement post low lab combat
; --------------------------------------------------------------------------------
; johnson teleports into geneforge lower lab
;(script dormant johnson_teleports_post_ll
;	(sleep_until (volume_test_players tv_johnson_teleports_post_ll) 1)
;	;(f_unblip_all) ;remove all navpoints
;	;(f_blip_flag fl_storage_door 0)
;	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
;	;(cs_run_command_script ai_johnson cs_johnson_teleports_post_ll)
;)
;(script command_script cs_johnson_teleports_post_ll
;	(print "johnson teleports outside the lower lab")
;	(cs_teleport pts_johnson_teleports_post_ll/p0 pts_johnson_teleports_post_ll/p1)
;)

; --------------------------------------------------------------------------------
;                 beat 4 - johnson moves down the hallway back to the sf
; --------------------------------------------------------------------------------
(script dormant johnson_hallway_walk_post_ll
	(sleep_until (volume_test_players tv_johnson_hallwayto_sf) 1)
	(f_unblip_all) ;remove all navpoints
	(f_blip_flag fl_storage_door 0)
	(set s_hallway_to_sf_control (+ s_hallway_to_sf_control 1)) ;; now at 1 - add 1 to the control johnson moving down the hallway back to the sf

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_moves_through_back_hallway)
)
(script command_script cs_johnson_moves_through_back_hallway
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)

	(sleep_until (= s_hallway_to_sf_control 1) 1)
	(cs_force_combat_status 1)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(wake johnson_hallway_walk_post_ll_b)
	(cs_go_by pts_johnson_paths_back_to_sf/p0 pts_johnson_paths_back_to_sf/p1)
	(cs_go_by pts_johnson_paths_back_to_sf/p1 pts_johnson_paths_back_to_sf/p2)
	(cs_go_by pts_johnson_paths_back_to_sf/p2 pts_johnson_paths_back_to_sf/p3)
	(cs_go_by pts_johnson_paths_back_to_sf/p3 pts_johnson_paths_back_to_sf/p3)

	(sleep_until (and
				(= s_hallway_to_sf_control 2)
				(volume_test_object tv_johnson_hallwayto_sf_b ai_johnson)
				)
				1
	)
	;(ai_set_objective ai_johnson obj_johnson_hallway_to_sf)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
	(ai_cannot_die ai_johnson false)
	(wake johnson_hallway_walk_post_ll_c)
)

(script dormant johnson_hallway_walk_post_ll_b
	(sleep_until (volume_test_players tv_johnson_hallwayto_sf_b) 1)
	(set s_hallway_to_sf_control (+ s_hallway_to_sf_control 1)) ;; now at 2 - add 1 to the control johnson moving down the hallway back to the sf
)

(script dormant johnson_hallway_walk_post_ll_c
	(sleep_until (and
			(<= (ai_nonswarm_count gr_cooridor_enc_14) 0)
			(> (object_get_health (object_get_ai ai_johnson)) 0) ; make sure johnson has health before the script proceeds
			)
			1
	)
	(cs_run_command_script ai_johnson cs_johnson_moves_through_back_hallway_b)
)
(script command_script cs_johnson_moves_through_back_hallway_b
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(wake johnson_joins_the_sf_fight)
	(ai_cannot_die ai_johnson true)
	(cs_force_combat_status 2)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(cs_go_by pts_johnson_paths_back_to_sf/p4 pts_johnson_paths_back_to_sf/p4)
	(cs_go_by pts_johnson_paths_back_to_sf/p5 pts_johnson_paths_back_to_sf/p5)
	(cs_go_by pts_johnson_paths_back_to_sf/p6 pts_johnson_paths_back_to_sf/p6)
	(cs_go_by pts_johnson_paths_back_to_sf/p7 pts_johnson_paths_back_to_sf/p7)
	(cs_go_by pts_johnson_paths_back_to_sf/p8 pts_johnson_paths_back_to_sf/p8)
	(cs_go_by pts_johnson_paths_back_to_sf/p9 pts_johnson_paths_back_to_sf/p9)
	(cs_move_towards_point pts_johnson_paths_back_to_sf/p10 .5)
	;(cs_go_by pts_johnson_paths_back_to_sf/p10 pts_johnson_paths_back_to_sf/p10)
	(cs_go_by pts_johnson_paths_back_to_sf/p11 pts_johnson_paths_back_to_sf/p11)
	(cs_go_by pts_johnson_paths_back_to_sf/p12 pts_johnson_paths_back_to_sf/p12)
	(ai_cannot_die ai_johnson false)
	(sleep_until (volume_test_players tv_johnson_waiting_lower_sf) 1)
)

(script dormant johnson_joins_the_sf_fight
	(sleep_until (volume_test_players tv_johnson_waiting_lower_sf) 1)

	(sleep_until (and
			(volume_test_object tv_johnson_waiting_lower_sf ai_johnson)
			(> (object_get_health (object_get_ai ai_johnson)) 0) ; make sure johnson has health before the script proceeds
			)
			1
	)
	(sleep_until (volume_test_object tv_johnson_waiting_lower_sf ai_johnson) 1)
	(cs_run_command_script ai_johnson cs_johnson_moves_through_back_hallway_c)
)
(script command_script cs_johnson_moves_through_back_hallway_c
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(cs_move_towards_point pts_johnson_paths_back_to_sf/p13 .5)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
	(wake take_hallway_back_to_tf)
	(ai_cannot_die ai_johnson false)
)

; --------------------------------------------------------------------------------
;                 beat 4 - johnson moves down the hallway back to the tf
; --------------------------------------------------------------------------------
(script dormant take_hallway_back_to_tf
	(sleep_until (and
			(= b_backtracking_through_level true)
			(= (ai_nonswarm_count gr_storage_enc15_brutes) 0)
			(= (ai_nonswarm_count gr_storage_enc15_cov) 0)
			(> (object_get_health (object_get_ai ai_johnson)) 0) ; make sure johnson has health before the script proceeds
			)
			1
	)
	(cs_run_command_script ai_johnson cs_johnson_back_to_tf)
)
(script command_script cs_johnson_back_to_tf
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(cs_go_to pts_johnson_back_to_tf/p0)

	;(sleep_until (volume_test_players tv_the_brute_storage_room) 1)
	(cs_go_by pts_johnson_back_to_tf/p1 pts_johnson_back_to_tf/p1)
	(cs_go_by pts_johnson_back_to_tf/p2 pts_johnson_back_to_tf/p2)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
	(ai_cannot_die ai_johnson false)
)

; ------------------------------------------------------------------------------------------------------------
;                 beat 4 - remove johnson from fireteam when he enters combat in the tf during the revisit
; ------------------------------------------------------------------------------------------------------------
(script dormant johnson_combat_testing_facility
	(sleep_until (and b_backtracking_through_level (volume_test_players tv_johnson_combat_testing_facility)) 1)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_testing_facility)
)

; ------------------------------------------------------------------------------------------------------------
;                 beat 4 - remove johnson begins his trek up to the glr
; ------------------------------------------------------------------------------------------------------------
(script dormant johnson_begins_trek_to_glr
		(sleep_until (and
				(= (ai_nonswarm_count gr_testing_facility_wv1_brutes) 0)
				(= (ai_nonswarm_count gr_testing_facility_wv1_cov) 0)
				(= (ai_nonswarm_count gr_testing_facility_wv2_cov) 0)
				(> (object_get_health (object_get_ai ai_johnson)) 0) ; make sure johnson has health before the script proceeds
				)
				1
	)
	(cs_run_command_script ai_johnson cs_johnson_begins_trek_to_glr)
)

(script command_script cs_johnson_begins_trek_to_glr
	(wake buddy_cop_for_glr)
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false) ; this helps with the johnson from getting stuck
	(cs_force_combat_status 2)
	(cs_go_to pts_johnson_path_to_glr/p0)
	(cs_go_by pts_johnson_path_to_glr/p1 pts_johnson_path_to_glr/p1)
	(cs_go_by pts_johnson_path_to_glr/p2 pts_johnson_path_to_glr/p2)

	(sleep_until (= b_chief_to_glr true) 1)
	(cs_go_by pts_johnson_path_to_glr/p3 pts_johnson_path_to_glr/p3)
	(cs_go_by pts_johnson_path_to_glr/p4 pts_johnson_path_to_glr/p4)
	(cs_go_by pts_johnson_path_to_glr/p5 pts_johnson_path_to_glr/p5)
	(cs_go_by pts_johnson_path_to_glr/p6 pts_johnson_path_to_glr/p6)
	(cs_go_by pts_johnson_path_to_glr/p7 pts_johnson_path_to_glr/p7)
	(cs_go_by pts_johnson_path_to_glr/p8 pts_johnson_path_to_glr/p8)
	(cs_go_by pts_johnson_path_to_glr/p9 pts_johnson_path_to_glr/p9)
	(cs_go_by pts_johnson_path_to_glr/p10 pts_johnson_path_to_glr/p10)
	(ai_cannot_die ai_johnson false)
)
(script dormant buddy_cop_for_glr
	(sleep_until (volume_test_players tv_vo_stasis_chamber_monitors_seen) 1)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
)
; --------------------------------------------------------------------------------
;                 beat 4 - set johnsons placement in glr when door locks
; --------------------------------------------------------------------------------
; johnson teleports into glr
(script command_script cs_johnson_teleports_glr
	(print "johnson teleports into the glr")
	(cs_teleport pt_teleport_johnson_glr/p0 pt_teleport_johnson_glr/p0)
)

; --------------------------------------------------------------------------------
;                 beat 4 - tell johnson to got to the panel to enable the gravlift
; --------------------------------------------------------------------------------
(script command_script cs_johnson_turn_on_lift
	(ai_cannot_die ai_johnson true)
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false)
	(ai_set_objective ai_johnson obj_johnson_walk)
	(cs_force_combat_status 1)
	(cs_lower_weapon true)
	(cs_walk true)
	(sleep (game_ticks_from_seconds .5))
	(print "johnson goes to turn on the lift")
	(cs_go_by pts_johnson_enable_gravlift/p2 pts_johnson_enable_gravlift/p2)
	(cs_go_to pts_johnson_enable_gravlift/p0)
	(cs_face true pts_johnson_enable_gravlift/p1)

	(sleep (game_ticks_from_seconds 1.5))
	(cs_walk false)
	(cs_lower_weapon false)
	(wake dialogue_turn_on_the_lift)

	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true)
	(f_attach_hacking_device)

	(custom_animation_loop ai_johnson "objects\characters\marine\marine" "using_device_loop" true)
	(device_set_position_immediate dm_control_panel_06 0.5) ;vignette machine

	(sleep (game_ticks_from_seconds 1)) ;was3
	(set b_gravlift_to_final_enabled true)
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true)
	(device_set_position_immediate dm_control_panel_06 1) ;vignette machine
	(f_destroy_hacking_device)
	(unit_stop_custom_animation ai_johnson)
	(cs_face false pts_johnson_enable_gravlift/p1)
	(cs_go_by pts_johnson_enter_gravlift/p0 pts_johnson_enter_gravlift/p0)
	(cs_go_by pts_johnson_enter_gravlift/p5 pts_johnson_enter_gravlift/p5)
	(cs_go_by pts_johnson_enter_gravlift/p1 pts_johnson_enter_gravlift/p1)
	(cs_go_by pts_johnson_enter_gravlift/p2 pts_johnson_enter_gravlift/p2)
	(cs_move_towards_point pts_johnson_enter_gravlift/p3 .5)
	(cs_move_towards_point pts_johnson_enter_gravlift/p4 .5)
	(cs_jump_to_point 0 5)
	(cs_go_to pts_johnson_enter_gravlift/p6)

	(sleep_until  (volume_test_players tv_post_glr_rejoin_group) 1)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
	(ai_cannot_die ai_johnson false)
)

; --------------------------------------------------------------------------------
;                 beat 4 - set johnsons placement in geneforge / final
; --------------------------------------------------------------------------------
; player forces johnson into the upper geneforge
(script dormant johnson_teleports_geneforge_final
	(sleep_until (volume_test_players tv_teleport_johnson_final) 1)
	(f_unblip_all) ;remove all navpoints

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_teleports_geneforge_final)
)
; johnson teleports into upper geneforge
(script command_script cs_johnson_teleports_geneforge_final
	(print "johnson teleports into the glr")
	(cs_teleport pts_johnson_teleport_final/p0 pts_johnson_teleport_final/p1)
)
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 												e10 - encounters
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; 												e10 - encounters - beat 1
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; e10 chapter - away team
; beat 1 - encounter 1 spawning
; location - hangar
; inserion point - ins_level_start
; zone set - set_1_docking_bay
; description:
;====================================================================================================================================================================================================
(script dormant dock_intro
	(f_play_cinematic cinematics\e10\e10_boarding.cinematic)
	(set b_let_the_games_begin true)
	(ai_place gr_dock_intro_a)
	(cs_run_command_script sq_dockingbay_enc1_1_grunt cs_grunt_a_flees)
	(cs_run_command_script sq_dockingbay_enc1_1_grunt2 cs_grunt_b_flees)
	(cs_run_command_script sq_dockingbay_enc1_1_grunt3 cs_grunt_c_flees)
	(cs_run_command_script sq_dockingbay_enc1_jackal_rein cs_jackal_reins_enters)
	;(sleep_until (volume_test_object tv_elite_close_that_door sq_dockingbay_enc1_jackal_rein) 1)

	;add additional weapons later in the hanger if 3 or more players
	(if (game_is_cooperative)
		(if (>= (game_coop_player_count) 3)
			(begin
				(object_create_folder of_coop_hanger_items)
			)
		)
	)

	(sleep_until (or
				(volume_test_object tv_elite_close_that_door sq_dockingbay_enc1_jackal_rein)
				(= (ai_living_count sq_dockingbay_enc1_jackal_rein) 0)
				)
				1
	)
	;;;; note - dm_johnson_hack_door_hanger is closed in the e10.hsc file (right here) when the encounter triggers
	;;;; but is opened in the audio file (e10_audio.hsc) when johnson hacks it open for a vignette
	(device_set_power dm_johnson_hack_door_hanger 1)
	(device_set_position dm_johnson_hack_door_hanger 0)

	(sleep_until (= (device_get_position dm_johnson_hack_door_hanger) 0) 1)
	(device_set_power dm_johnson_hack_door_hanger 0)

	(sleep_until (<= (ai_nonswarm_count gr_dock_intro_a) 2) 1)
	(print "reins should spawn")
	(ai_place gr_dock_intro_a_wv2)

	(sleep_until (and
				(= (ai_nonswarm_count gr_dock_intro_a) 0)
				(= (ai_nonswarm_count gr_dock_intro_a_wv2) 0)
				)
				1
	)
	; walk player back to the location where the cinematic occurs
	(f_blip_flag fl_trigger_cine_two 0)

	(sleep_until  (volume_test_players tv_trigger_cine_two) 1)
	(f_unblip_all) ;remove all navpoints
	(f_play_cinematic cinematics\e10\e10_copilot.cinematic ps_teleport_players_cine1)
	(ai_place sq_johnson_dockingbay)
	(wake blip_johnson_initial)
	(set ai_johnson sq_johnson_dockingbay)
	;(ai_cannot_die ai_johnson true)
	(wake trigger_chapter_one) ; triggers chapter 1
	(wake dialogue_dockingbay_johnson_post_intro)
)

(script dormant blip_johnson_initial
	(f_hud_hero_waypoint ai_johnson hero_johnson hero_default_max_dist)
)

(script command_script cs_jackal_reins_enters
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_force_combat_status 3)
	(cs_walk false)
	(cs_go_by pts_jackal_reins_pathing_in/p0 pts_jackal_reins_pathing_in/p0)
	(cs_go_by pts_jackal_reins_pathing_in/p1 pts_jackal_reins_pathing_in/p1)
)

(script command_script cs_grunt_a_flees
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_force_combat_status 1)
	(ai_flee_to_point sq_dockingbay_enc1_1_grunt pts_flee_point_a/p0)
)
(script command_script cs_grunt_b_flees
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_force_combat_status 1)
	(ai_flee_to_point sq_dockingbay_enc1_1_grunt2 pts_flee_point_b/p0)
)
(script command_script cs_grunt_c_flees
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_force_combat_status 1)
	(ai_flee_to_point sq_dockingbay_enc1_1_grunt3 pts_flee_point_c/p0)
)

;;;; force the ambushers into the space
(script command_script cs_start_angry_jackal_a
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_force_combat_status 3)
	(cs_go_by pts_jackal_ambusher_a/p0 pts_jackal_ambusher_a/p0)
	(cs_go_by pts_jackal_ambusher_a/p1 pts_jackal_ambusher_a/p1)
)
(script command_script cs_start_angry_jackal_b
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_force_combat_status 3)
	(cs_go_by pts_jackal_ambusher_b/p0 pts_jackal_ambusher_b/p0)
	(cs_go_by pts_jackal_ambusher_b/p1 pts_jackal_ambusher_b/p1)
)
(script command_script cs_start_angry_elite_a
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_force_combat_status 3)
	(cs_go_by pts_elite_ambusher_a/p0 pts_elite_ambusher_a/p0)
	(cs_go_by pts_elite_ambusher_a/p1 pts_elite_ambusher_a/p1)
)
;====================================================================================================================================================================================================
; e10 chapter - away team
; beat 1 - encounter 2 spawning
; location - hangar
; inserion point - ins_level_start
; zone set - set_1_docking_bay
; description:
;====================================================================================================================================================================================================
(script dormant dock_second
	(ai_place  gr_dock_intro_b)
	(ai_vehicle_enter sq_dock_second_grunt_gunner ve_shade-hanger "")

	(sleep (game_ticks_from_seconds .5))
	(cs_run_command_script sq_dock_intro_grunt_a cs_grunt_a_enc2_flees)
	(cs_run_command_script sq_dock_intro_grunt_c cs_grunt_c_enc2_flees)

	(sleep_until (= b_johnson_is_ready true) 1)
	(cs_run_command_script ai_johnson cs_johnson_is_trigger_happy)
)
(script command_script cs_johnson_is_trigger_happy
	(ai_set_objective ai_johnson obj_johnson_follow)
	(cs_face_object true sq_dock_intro_grunt_b)
	(ai_place_cue johnson_accuracy_cue)

	(sleep (game_ticks_from_seconds 1))
	(print "johnson takes aim")
	(cs_aim_object true sq_dock_intro_grunt_b)

	(sleep (game_ticks_from_seconds 1))
	(print "johnson takes the shot")
	(cs_shoot true sq_dock_intro_grunt_b)

	(sleep (game_ticks_from_seconds 2))
	(cs_shoot false sq_dock_intro_grunt_b)
	(ai_remove_cue johnson_accuracy_cue)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
)

(script dormant elite_ambusher_strikes
	(sleep_until (volume_test_object tv_elite_goes_berserk sq_dock_ambush_elite) 1)
	(ai_berserk sq_dock_ambush_elite true)
)

(script command_script cs_grunt_a_enc2_flees
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false) ; this helps with the johnson from getting stuck
	(ai_flee_to_point sq_dock_intro_grunt_a pts_enc2_flee_point_a/p0)
)
;;; this is no longer called but remains in case we want to still use it
(script command_script cs_grunt_b_enc2_flees
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles true) ; this helps with the johnson from getting stuck
	(ai_flee_to_point sq_dock_intro_grunt_b pts_enc2_flee_point_b/p0)
)
(script command_script cs_grunt_c_enc2_flees
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles false) ; this helps with the johnson from getting stuck
	(ai_flee_to_point sq_dock_intro_grunt_c pts_enc2_flee_point_c/p0)
)
;====================================================================================================================================================================================================
; beat 1 - encounter 2 cleanup
;====================================================================================================================================================================================================
(script dormant e10_e2_cleanup
	(sleep_until (volume_test_players tv_end_dock_second) 1)
	(ai_erase gr_dock_intro_b)
	(ai_erase sq_dock_ambush_elite)
	(ai_erase sq_dock_ambush_elite2)
	(ai_erase sq_dock_ambush_elite3)
)

;====================================================================================================================================================================================================
; e10 chapter - away team
; beat 1 - encounter 3 spawning
; location - hangar
; inserion point - ins_level_start
; zone set - set_1_docking_bay
; description:
;====================================================================================================================================================================================================
(script dormant dock_3_clock
    (sleep_until  (volume_test_players tv_encounter_3_pt1) 1)
	(ai_prefer_target (players) true)
    (ai_place gr_dock_3_clock)
	(ai_vehicle_enter sq_dock_gunner_1 ve_shade2-hanger "")
	(wake dock_12_clock_a)
)

(script dormant dock_12_clock_a
	(sleep_until (or
				(<= (ai_living_fraction gr_dock_3_clock) .5)
				(volume_test_players tv_act_dock_12_clock)
				)
				1
	)
	(ai_place gr_dock_12_clock)
	(set b_hanger_12_oclock_has_spawned true)

)

(script dormant dock_12_clock_b
    (sleep_until  (volume_test_players tv_act_dock_12_clock) 1)
	(ai_prefer_target (players) false)
    ;(ai_place gr_dock_12_clock_master)
	(ai_place gr_dock_12_clock_2)
	;(set b_hanger_12_oclock_has_spawned true)
)

(script dormant dock_9_clock
	(sleep_until (= b_hanger_12_oclock_has_spawned true) 1)

	(sleep_until (or
				(volume_test_players tv_act_dock_9_clock)
				(<= (ai_living_fraction gr_dock_12_clock_master) .25)
				)
				1
	)
    (ai_place gr_dock_9_clock)
	(ai_place gr_dock_9_clock_b)
	(sleep_until (= (ai_nonswarm_count gr_dock_9_clock) 0) 1)
	(f_game_save) ;save the game
)

(script dormant dock_turn
    (sleep_until  (volume_test_players tv_act_dock_turn) 1)
    (ai_place gr_dock_turn)
	(ai_vehicle_enter sq_dock_turn_grunts_apex ve_shade3-hanger "")
)

;====================================================================================================================================================================================================
; beat 1 - encounter 3 cleanup
;====================================================================================================================================================================================================

(script dormant e10_e3_cleanup
	(sleep_until (volume_test_players tv_kill_encounter_3) 1)

	(ai_erase gr_dock_3_clock)
	(ai_erase gr_dock_12_clock_master)
	(ai_erase gr_dock_9_clock)
	(ai_erase gr_dock_9_clock_b)
	(ai_erase gr_dock_turn)
)

;====================================================================================================================================================================================================
; e10 chapter - away team
; beat 1 - encounter 4 spawning
; location - hangar
; inserion point - ins_level_start
; zone set - set_1_docking_bay
; description:
;====================================================================================================================================================================================================
;;place the squad in front of incoming spirit
(script dormant airborne_hanger
    (sleep_until  (volume_test_players tv_act_airborne) 1)
	(ai_place gr_airborne_hanger)
	(ai_prefer_target (players) true)
	(ai_vehicle_enter sq_airborne_gunner_grunt ve_shade4-hanger "")
)

;====================================================================================================================================================================================================
; beat 1 - encounter 4 cleanup
;====================================================================================================================================================================================================
(script dormant e10_e4_cleanup
   	(sleep_until (volume_test_players tv_end_airborne) 1)
	(ai_erase gr_airborne)
	(ai_erase gr_airborne_hanger)
	(ai_erase gr_hanger_hallway_patrol)
)

;====================================================================================================================================================================================================
; e10 chapter - away team
; beat 1 - encounter 5 spawning
; location - hangar
; inserion point - ins_level_start
; zone set - set_1_docking_bay
; description:
;====================================================================================================================================================================================================
(script dormant exit_hunters
    (sleep_until  (volume_test_players tv_act_exit_hunters) 1)
    (ai_place gr_exit_hunters)
	;------- co-op/difficulty setup for encounter --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_enc_5_elites_2_3coop)
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_enc_5_snipers_4coop)
		)
	)
	(f_game_save) ;save the game pre-hunter
	(ai_prefer_target (players) true)
	(ai_disregard (ai_actors ai_johnson) true)
	(wake blip_enc5)

	(sleep_until (< (ai_living_count sq_dockingbay_lift_hunter) 2) 1)
	(ai_berserk sq_dockingbay_lift_hunter true)
	(if (= (ai_living_count sq_dockingbay_lift_hunter) 1) ;;; if its one wake the dialogue 1st hunter dead.
		(wake dialogue_first_hunter_is_dead)
	)

	(sleep_until (= (ai_living_count sq_dockingbay_lift_hunter) 0) 1)
	(if (not (volume_test_object tv_johnson_check_upper_deck ai_johnson ))
		(wake teleport_johnson_to_upper_deck)
	)

	(sleep (game_ticks_from_seconds .5))
	(wake dialogue_hunters_are_dead)
	(ai_disregard (ai_actors ai_johnson) false)

	(sleep_until (= (ai_nonswarm_count gr_enc_5_master) 0) 1)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_turn_on_exit_gravlift)

	;(sleep_until (= b_johnson_hacked_hanger_lift true) 1)
	;sleep until johnson hacks the gravlift or a certain amount of time passes for a fallback
	(sleep_until (= b_johnson_hacked_hanger_lift true) 1 (game_ticks_from_seconds 60))
		(if (= b_johnson_hacked_hanger_lift false)
			(set b_johnson_hacked_hanger_lift true)
		)
	(f_blip_flag fl_hanger_exit 0)
	(object_create gravlift_a_hunters) ; make the gravlift out of the hanger available
	;(f_game_save) ;save the game
)

(script dormant blip_enc5
	(sleep_until (< (ai_nonswarm_count gr_enc_5_master) 4) 1)
	(f_blip_ai gr_enc_5_master 1)
)
;====================================================================================================================================================================================================
; beat 1 - encounter 5 cleanup
;====================================================================================================================================================================================================

(script dormant e10_e5_cleanup
	(sleep_until (volume_test_players tv_end_exit_hunters) 1)
	(f_unblip_all) ;remove all navpoints
	(f_blip_flag fl_rr_entry 0)
    (ai_erase gr_exit_hunters)
	(ai_erase gr_enc_5_elites_2_3coop)
	(ai_erase gr_enc_5_snipers_4coop)
	(object_destroy_folder of_coop_hanger_items) ;;destroy the extra coop weapons if they exist
	;add additional weapons in r+r if 3 or more players
	(if (game_is_cooperative)
		(if (>= (game_coop_player_count) 3)
			(begin
				(object_create_folder of_coop_rest_repsite_items)
			)
		)
	)
)

;====================================================================================================================================================================================================
; 												e10 - encounters - beat 2
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; e10 chapter - change of plans
; beat 2 - encounter 6 spawning
; location - rest and respite
; inserion point - ins_rest_respite
; zone set - set_2_rest_respite
; description:
;====================================================================================================================================================================================================

(script dormant start_rest_respite
	(sleep_until (volume_test_players tv_encounter_6) 1)
	(ai_place gr_rest_respite_initial)

	(sleep_until (= (ai_nonswarm_count gr_rest_respite_initial) 0) 1) ;;wait until they are dead
	(set s_rr_check_for_final_wave (+ s_rr_check_for_final_wave 1)) ;; add 1 to the control variable
)

;====================================================================================================================================================================================================
; beat 2 - encounter 6 cleanup
;====================================================================================================================================================================================================

(script dormant e10_e6_cleanup
	(sleep_until (volume_test_players tv_kill_encounter_6) 1)
	(ai_erase gr_rest_respite)
)

;====================================================================================================================================================================================================
; e10 chapter - change of plans
; beat 2 - encounter 7 spawning
; location - rest and respite
; inserion point - ins_rest_respite
; zone set - set_2_rest_respite
; description:
;====================================================================================================================================================================================================
; spawn the 2nd wave when i reach the upper platform or if the first wave falls below a threshold
(script dormant start_rest_respite_hallway
	(sleep_until (or
				(volume_test_players tv_encounter_7_a)
				(volume_test_players tv_encounter_7_b)
				)
				1
	)
	(ai_place gr_rest_respite_hallway)

	(sleep_until (= (ai_nonswarm_count gr_rest_respite_hallway) 0) 1) ;;wait until they are dead
	(set s_rr_check_for_final_wave (+ s_rr_check_for_final_wave 1)) ;; add 1 to the control variable
)

;====================================================================================================================================================================================================
; beat 2 - encounter 7 cleanup
;====================================================================================================================================================================================================

;;; no cleanup needed - you cant exit r&r without killing all enemies

;====================================================================================================================================================================================================
; e10 chapter - change of plans
; beat 2 - encounter 8 spawning
; location - rest and respite
; inserion point - ins_rest_respite
; zone set - set_2_rest_respite
; description:
;====================================================================================================================================================================================================
; spawn the third wave when i reach the upper platform or if the 2nd wave falls below a threshold
(script dormant start_rest_respite_wave_3
	(sleep_until (volume_test_players tv_encounter_8) 1)
	(ai_place gr_rest_respite_wave3)

	;blip the last three enemies in the bloodgate
	(sleep_until (and
				(< (ai_nonswarm_count gr_rest_respite) 2)
				(< (ai_nonswarm_count gr_rest_respite_hallway) 2)
				(< (ai_nonswarm_count gr_rest_respite_wave3) 4)
				)
				1
	)
	(f_blip_ai gr_rest_respite 1)
	(f_blip_ai gr_rest_respite_hallway 1)
	(f_blip_ai gr_rest_respite_wave3 1)

	(sleep_until (= (ai_nonswarm_count gr_rest_respite_wave3) 0) 1) ;;wait until they are dead
	(set s_rr_check_for_final_wave (+ s_rr_check_for_final_wave 1)) ;; add 1 to the control variable
)

;====================================================================================================================================================================================================
; beat 2 - encounter 8 cleanup
;====================================================================================================================================================================================================

;;; no cleanup needed - you cant exit r&r without killing all enemies

;====================================================================================================================================================================================================
; e10 chapter - change of plans
; beat 2 - encounter 9 spawning
; location - rest and respite
; inserion point - ins_rest_respite
; zone set - set_2_rest_respite
; description:
;====================================================================================================================================================================================================
; spawn the final wave that unlocks the door
(script dormant start_rest_respite_wave_final
	(sleep_until (= s_rr_check_for_final_wave 3) 1)
	(device_set_power dm_encounter_9_door 1)
	(ai_place gr_rest_respite_wave_final)
	(f_blip_flag fl_rr_exit 0)
	(wake e10_music_rest_respite_complete)

	(sleep_until (= (ai_nonswarm_count gr_rest_respite_wave_final) 0) 1)
	(f_game_save) ;save the game
)

;====================================================================================================================================================================================================
; beat 2 - encounter 9 cleanup
;====================================================================================================================================================================================================
(script dormant e10_e9_cleanup
	(sleep_until (volume_test_players tv_kill_encounter_9) 1)
	(ai_erase gr_rest_respite_wave_final)
)
;====================================================================================================================================================================================================
; e10 chapter - change of plans
; beat 2 - encounter 10 spawning
; location - the dojo
; inserion point - ins_dojo
; zone set - set_2_rest_respite
; description:
;====================================================================================================================================================================================================

(script dormant start_dojo
	(sleep_until (volume_test_players tv_encounter_10) 1)
	(device_set_position_immediate dm_grav_bridge_dojo_enter 1)
	(ai_disregard (ai_actors ai_johnson) true)
	(ai_place gr_dojo_enc10_wave1)
	(ai_place gr_dojo_enc10_playfight)
	(wake now_we_are_friends)

	(sleep (game_ticks_from_seconds .25))
	(cs_run_command_script sq_dojo_enc10_elite_wave1 slower_elite)
	(cs_run_command_script sq_dojo_enc10_eliteb_wave1 faster_elite)

	(sleep_until (< (ai_nonswarm_count gr_dojo) 1) 1)
	(f_game_save) ;save the game

	(sleep (game_ticks_from_seconds 2))
	(device_set_power dm_monster_door_dojo5 1)
	(device_set_power dm_monster_door_dojo6 1)
	(ai_place gr_specops_enc10_wave2)
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_specops_enc10_2_3coop)
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_specops_enc10_4_coop)
		)
	)

	(sleep (game_ticks_from_seconds 2));
	(wake dialogue_why_is_the_sand_moving) ; why is the sand moving?

	(sleep_until (< (ai_nonswarm_count gr_specops_enc10_master) 1) 1)
	(set b_dojo_spec_ops_are_dead true)
	(f_game_save) ;save the game
)

(script command_script elite_playfighting
	(ai_cannot_die ai_current_actor true)
	;(ai_disregard (ai_actors ai_johnson) true)
)

(script command_script clear_commands
	(sleep 1)
)

(script command_script slower_elite
    (sleep_until
        (begin
			(cs_aim_object true sq_dojo_enc10_eliteb_wave1)
            (sleep 1)
            ;walk around circle
            (cs_go_to pts_combat_circle/p5) ; i get attacked
            (sleep 2)
            (cs_go_to pts_combat_circle/p6)
            (sleep 1)
            (cs_go_to pts_combat_circle/p7)
            (cs_go_to pts_combat_circle/p8)
			(sleep 1)
			(cs_move_towards sq_dojo_enc10_eliteb_wave1/spawnpoint1 true true) ;;i attack -------1 1 2 1
			(sleep 2)
            (cs_go_to pts_combat_circle/p1)
			(cs_go_to pts_combat_circle/p2)
			(sleep 1)
            (cs_go_to pts_combat_circle/p3)
			(sleep 1)
            (cs_go_to pts_combat_circle/p4)
			(sleep 1)
			(cs_go_to pts_combat_circle/p3) ; i get attacked;-------2 1 1 1
			(sleep 2)
			(cs_go_to pts_combat_circle/p2)
			(cs_go_to pts_combat_circle/p1)
			(sleep 1)
			(cs_move_towards sq_dojo_enc10_eliteb_wave1/spawnpoint1 true true) ;;i attack
			(sleep 2)
			(cs_go_to pts_combat_circle/p8)
			(cs_go_to pts_combat_circle/p7)
			(sleep 1)
			(cs_go_to pts_combat_circle/p6) ;------2 1 2 1
			;(sleep 1)
			;(cs_go_to pts_combat_circle/p5)
            true ; exit condition
       )
    )
	(cs_run_command_script sq_dojo_enc10_elite_wave1 slower_elite)
)

(script command_script faster_elite
    (sleep_until
        (begin
			(cs_aim_object true sq_dojo_enc10_elite_wave1)
           	(sleep 1)
			(cs_move_towards sq_dojo_enc10_elite_wave1/spawnpoint true true) ;;i attack
			(sleep 2)
            ;walk around circle
            (cs_go_to pts_combat_circle/p1)
			(sleep 1)
            (cs_go_to pts_combat_circle/p2)
            (cs_go_to pts_combat_circle/p3)
			(sleep 1)
            (cs_go_to pts_combat_circle/p4) ; i get attacked ;----1 1 2 1
			(sleep 2)
            (cs_go_to pts_combat_circle/p5)
            (cs_go_to pts_combat_circle/p6)
			(sleep 1)
            (cs_go_to pts_combat_circle/p7)
			(sleep 1)
            (cs_go_to pts_combat_circle/p8)
			(sleep 1)
			(cs_move_towards sq_dojo_enc10_elite_wave1/spawnpoint true true) ;;i attack ;-----2 1 1 1
			(sleep 2)
			(cs_go_to pts_combat_circle/p7)
			(cs_go_to pts_combat_circle/p6)
			(sleep 1)
			(cs_go_to pts_combat_circle/p5) ; i get attacked
			(sleep 2)
			(cs_go_to pts_combat_circle/p4)
			(cs_go_to pts_combat_circle/p3)
			(sleep 1)
			(cs_go_to pts_combat_circle/p2) ;-----2 1 2 1
			;(sleep 1)
			;(cs_go_to pts_combat_circle/p1)
            true ; exit condition
        )
    )
	(cs_run_command_script sq_dojo_enc10_eliteb_wave1 faster_elite)
)


; set in objective - obj_dojo / task - just_hanging_out
; both elites in the set-up are set to different teams
; to keep everyone from attacking allegiance is set here to allow playfighting
; set when characters load
(script static void ignore_bad_team
	(ai_allegiance covenant brute)
	(ai_allegiance brute covenant)
	(ai_allegiance covenant flood)
	(ai_allegiance flood covenant)
)

; both elites on different teams are now set to be buddies to attack you
; set when any ai in the group can see a player and everyone transitions their objective to attack
(script dormant now_we_are_friends
	(sleep_until (or
				(objects_can_see_object (ai_get_object gr_dojo) player0 45)
				(objects_can_see_object (ai_get_object gr_dojo) player1 45)
				(objects_can_see_object (ai_get_object gr_dojo) player2 45)
				(objects_can_see_object (ai_get_object gr_dojo) player3 45)
				)
				1
	)
	(cs_run_command_script sq_dojo_enc10_elite_wave1 clear_commands)
	(cs_run_command_script sq_dojo_enc10_eliteb_wave1 clear_commands)
	(print "now we are friends has triggered")
	(ai_cannot_die sq_dojo_enc10_eliteb_wave1 false)
	(ai_cannot_die sq_dojo_enc10_elite_wave1 false)
	(ai_set_team sq_dojo_enc10_elite_wave1 covenant)
	(ai_set_team sq_dojo_enc10_eliteb_wave1 covenant)
	;(ai_allegiance flood brute)
	;(ai_allegiance brute flood)

	(sleep 1)
	(ai_vehicle_enter gr_dojo_enc10_playfight ve_ghost-dojo) ;one of the elites decidees to attack you with the ghost
	(ai_disregard (ai_actors ai_johnson) false)
	(set b_combat_in_dojo_is_go true)
)

; specops a command script for bringing them into the scene
(script command_script cs_specops_a_enters_the_scene
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles true) ; this helps with the johnson from getting stuck
	(cs_force_combat_status 3)
	(ai_set_active_camo ai_current_actor true)
	(cs_go_by pts_specops_vpath_a/p0 pts_specops_vpath_a/p0)
	(cs_go_by pts_specops_vpath_a/p1 pts_specops_vpath_a/p1)
	(cs_go_by pts_specops_vpath_a/p2 pts_specops_vpath_a/p2)
	;(cs_go_by pts_specops_vpath_a/p3 pts_specops_vpath_a/p3)
	;(cs_go_to pts_specops_vpath_a/p4)
	;(ai_activity_set ai_current_actor watch)
	(sleep_until (= b_dojo_specops_can_kill true) 1)
)

; specops b command script for bringing them into the scene
(script command_script cs_specops_b_enters_the_scene
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles true) ; this helps with the johnson from getting stuck
	(cs_force_combat_status 3)
	(ai_set_active_camo ai_current_actor true)
	(cs_go_by pts_specops_vpath_b/p0 pts_specops_vpath_b/p0)
	(cs_go_by pts_specops_vpath_b/p1 pts_specops_vpath_b/p1)
	(cs_go_by pts_specops_vpath_b/p2 pts_specops_vpath_b/p2)
	;(cs_go_by pts_specops_vpath_b/p3 pts_specops_vpath_b/p3)
	;(cs_go_to pts_specops_vpath_b/p4)
	;(ai_activity_set ai_current_actor watch)
	(sleep_until (= b_dojo_specops_can_kill true) 1)
)
;====================================================================================================================================================================================================
; beat 2 - encounter 10 cleanup
;====================================================================================================================================================================================================

(script dormant e10_e10_cleanup
	(sleep_until (volume_test_players tv_kill_encounter_10) 1)
	(ai_erase gr_dojo)
	(ai_erase gr_specops_enc10_wave2)
	(ai_erase gr_specops_enc10_2_3coop)
	(ai_erase gr_specops_enc10_4_coop)
	(object_destroy_folder of_coop_rest_repsite_items) ;;destroy the extra coop weapons if they exist
	(object_destroy_folder of_coop_dojo_items) ;;destroy the extra coop weapons if they exist
)

;====================================================================================================================================================================================================
; e10 chapter - change of plans
; beat 2 - encounter 11 spawning
; location - the dojo
; inserion point - ins_dojo
; zone set - set_2_rest_respite
; description:
;====================================================================================================================================================================================================
(script dormant start_dojo_midpoint
	(sleep_until (= b_dojo_spec_ops_are_dead true) 1)
	(ai_place gr_dojo_reins_part1)

	(sleep_until (= (ai_nonswarm_count gr_dojo_reins_part1) 0) 1)
	(f_game_save) ;save the game

	(sleep (game_ticks_from_seconds 2))
	(ai_place gr_dojo_reins_part2)
	(ai_place gr_dojo_reins_snipers)

	;wake script that checks if dojo is cleared now that all encounters have been placed
	(wake e10_music_dojo_end_trigger)

	;blip the last three enemies in the bloodgate
	(sleep_until (< (ai_nonswarm_count gr_dojo_reins_part2_master) 4) 1)
	(f_blip_ai gr_dojo_reins_part2_master 1)
	(set b_johnson_can_trigger_gb true)
	(ai_disregard (ai_actors ai_johnson) true)

	(sleep_until (= (ai_nonswarm_count gr_dojo_reins) 0) 1)
	(ai_disregard (ai_actors ai_johnson) false)
	(wake blip_the_dojo_navpoints)
)

(script dormant blip_the_dojo_navpoints
	(sleep_until (volume_test_object tv_mind_the_gap ai_johnson) 1)
	(f_blip_flag fl_dojo_ramp 0)
	(sleep_until (volume_test_players tv_unblip_dojo_ramp_navpoint) 1)
	(f_unblip_all) ;remove all navpoints
	(f_blip_flag fl_dojo_gravbridge 0)
	(sleep_until (volume_test_players tv_mind_the_gap) 1)
	(f_unblip_all) ;remove all navpoints
	(sleep_until (= b_johnson_hacked_grav_bridge true) 1)
	(f_blip_flag fl_dojo_gravbridge_path 0)
	(sleep_until (volume_test_players tv_unblip_gravbridge_navpoint) 1)
	(f_unblip_all) ;remove all navpoints
)
;====================================================================================================================================================================================================
; beat 2 - encounter 11 cleanup
;====================================================================================================================================================================================================
(script dormant e10_e11_cleanup
	(sleep_until (volume_test_players tv_kill_encounter_11) 1)

	(ai_erase gr_dojo_reins)
)


;====================================================================================================================================================================================================
; 												e10 - encounters - beat 3
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 11-post spawning
; location - geneforge gear room hallway
; inserion point - ins_geneforge_start
; zone set - set_3_marine_gear_storage_room
; description:
;====================================================================================================================================================================================================
(script dormant careful_of_the_sleepers
	(sleep_until (volume_test_players tv_place_gear_room_sleepers) 1)

	;(ai_place gr_geneforge_start)
	(ai_place sq_gear_room_sleepers)
	(wake johnson_heads_to_tf)
)


;====================================================================================================================================================================================================
; e10 chapter - forge reconnaissance
; beat 3 - encounter 12 spawning
; location -
; inserion point - ins_geneforge_start
; zone set - set_3_marine_gear_storage_room
; description:
;====================================================================================================================================================================================================

(script dormant start_geneforge_start
	(sleep_until (volume_test_players tv_encounter_12) 1)
	(ai_place sq_geneforge_start_grunt)
	(wake start_storage_part_2)
)

(script dormant start_storage_part_2
	(sleep_until (volume_test_players tv_encounter_12_5) 1)
	(sleep (game_ticks_from_seconds 2))
	(ai_place sq_geneforge_start_elite)
	(ai_place sq_geneforge_start_jackal)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_storage_facility)
	(ai_suppress_combat ai_johnson false)
	;when the enemies are dead add johnson back to the team

	(sleep_until (= (ai_nonswarm_count gr_geneforge_start) 0)  1)
	(f_game_save) ;save the game
	(ai_set_objective ai_johnson obj_johnson_follow)
	(ai_player_add_fireteam_squad player0 ai_johnson)
)
;====================================================================================================================================================================================================
; beat 3 - encounter 12 cleanup
;====================================================================================================================================================================================================

(script dormant e10_e12_cleanup
	(sleep_until (volume_test_players tv_kill_encounter_12) 1)

	(ai_erase gr_geneforge_start)
	(ai_erase sq_pre_storage_hallway)
	(ai_erase sq_gear_room_sleepers)
)

;====================================================================================================================================================================================================
; 												e10 - encounters - beat 4
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 13 spawning
; location - geneforge main level lower level
; inserion point - ins_main_lab_lower
; zone set - set_4_geneforge_main_lab
; description: chief and johnson learn the truth about what is going on at the lab
;====================================================================================================================================================================================================
;;wave 1 - post cinematic madness
(script dormant geneforge_ll_wv1_trigger
	(ai_set_objective ai_johnson obj_johnson_geneforge_ll)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(set s_geneforge_ll_control_var (+ s_geneforge_ll_control_var 1)) ;; add 1 to the control variable for the waves going off the rails
	(wake geneforge_ll_wv1_control)

 	(ai_place gr_geneforge_ll_wv1)

	(ai_berserk sq_geneforge_ll_wv1_brute true)

	(sleep (game_ticks_from_seconds 5))

	(sleep_until (= (ai_living_count sq_geneforge_ll_wv1_brute) 0)  1)
	(wake vo_first_augmented_brute_dies)

	(sleep_until (= (ai_nonswarm_count gr_geneforge_ll_wv1) 0)  1)
	(wake vo_geneforge_ll_wv1_eliminated)

	(sleep (game_ticks_from_seconds 2.5))
	(set b_geneforge_ll_wv1_complete true)
    (wake geneforge_ll_wv2_trigger)

	(f_game_save) ;save the game
	(set s_johnson_zone_genforge_ll (+ s_johnson_zone_genforge_ll 1)) ;; add 1 to the control variable for johnsons choices when on the rails
)
;;wave 2 - lower level combat - brutes/grunts/elites
(script dormant geneforge_ll_wv2_trigger
	(sleep_until (= b_geneforge_ll_wv1_complete 1) 1)
	(set s_geneforge_ll_control_var (+ s_geneforge_ll_control_var 1)) ;; add 1 to the control variable for the waves going off the rails
	(wake geneforge_ll_wv2_control)
	(ai_place gr_geneforge_ll_wv2)
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_lower_lab_2_3coop_wv2)
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_lower_lab_4coop_wv2)
		)
	)

	(sleep_until (= (ai_nonswarm_count gr_geneforge_ll_wv2_master) 0)  1)
	(f_game_save) ;save the game
	(sleep (game_ticks_from_seconds 2.5))
	(wake geneforge_ll_wv3_trigger)
)
;;wave 3
(script dormant geneforge_ll_wv3_trigger
	;(device_set_power dm_encounter_13_final_wave_door 1)
	(set s_geneforge_ll_control_var (+ s_geneforge_ll_control_var 1)) ;; add 1 to the control variable for the waves going off the rails
	(wake geneforge_ll_wv3a_control)

	(ai_place gr_geneforge_ll_wv3_a)
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_lower_lab_2_3coop_wv3_a)
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_lower_lab_4coop_wv3_a)
		)
	)

	(sleep (game_ticks_from_seconds 2))
	(set s_johnson_zone_genforge_ll (+ s_johnson_zone_genforge_ll 1)) ;; add 1 to the control variable for johnsons choices when on the rails

	(sleep_until (= (ai_nonswarm_count gr_geneforge_ll_wv3_a_master) 0) 1)
	;(ai_set_objective ai_johnson obj_johnson_follow)
	(set s_geneforge_ll_control_var (+ s_geneforge_ll_control_var 1)) ;; add 1 to the control variable for the waves going off the rails
	;(wake geneforge_ll_wv3b_control)
	(f_blip_flag fl_lower_lab_upper_level 0)
	(set b_goto_lowerlab_upperlevel true)
	(ai_place gr_geneforge_ll_wv3_b)
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_lower_lab_2_3coop_wv3_b)
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_lower_lab_4coop_wv3_b)
		)
	)
	(set s_johnson_zone_genforge_ll (+ s_johnson_zone_genforge_ll 1)) ;; add 1 to the control variable for johnsons choices when on the rails

	;blip the last three enemies in the bloodgate
	(sleep_until (< (ai_nonswarm_count gr_geneforge_ll_wv3_master) 4) 1)
	(f_blip_ai gr_geneforge_ll_wv3_master 1)

	(sleep_until (= (ai_nonswarm_count gr_geneforge_ll_wv3_master) 0)  1)
	;(set b_prophet_angry_callouts false)

	(wake trigger_obj_facility_revisit)
	(f_game_save) ;save the game
	(sleep (game_ticks_from_seconds 2.5))
	(wake geneforge_ll_wv4_trigger)
)

;;wave 4 - open the door
(script dormant geneforge_ll_wv4_trigger
	(device_set_power dm_encounter_13_final_wave_door 1)
	(f_unblip_all) ;remove all navpoints
	(set s_johnson_zone_genforge_ll (+ s_johnson_zone_genforge_ll 1)) ;; add 1 to the control variable for johnsons choices when on the rails
	(ai_place gr_geneforge_ll_wv4)
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_lower_lab_2_3coop_wv4)
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_lower_lab_4coop_wv4)
		)
	)

	(sleep_until (= (ai_nonswarm_count gr_geneforge_ll_wv4_master) 0)  1)
	(set b_geneforge_ambush_ends true)
	(f_blip_flag fl_geneforge_ll_exit 0)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_exits_gf_ll); johnson exits the geneforge ll
	(wake vo_geneforge_ll_combat_concludes)
	(f_game_save) ;save the game
)

;;;; off the rails variable triggers to alter objectives should the player deviate from what is intended

;; wave 1 control - player goes to the upper level and sets the encounter otr
(script dormant geneforge_ll_wv1_control
	(sleep_until (and
				(volume_test_players tv_chiefcheck_geneforge_upper)
				(= s_geneforge_ll_control_var 1)
				)
				1
	)
	(set b_geneforge_ll_wv1_otr true)
)
;; wave 2 control - player goes to the upper level and sets the encounter otr
(script dormant geneforge_ll_wv2_control
	(sleep_until (and
				(volume_test_players tv_chiefcheck_geneforge_upper)
				(= s_geneforge_ll_control_var 2)
				)
				1
	)
	(set b_geneforge_ll_wv2_otr true)
)
;; wave 3a control - player goes to the upper level and sets the encounter otr
(script dormant geneforge_ll_wv3a_control
	(sleep_until (and
				(volume_test_players tv_chiefcheck_geneforge_upper)
				(= s_geneforge_ll_control_var 3)
				)
				1
	)
	(set b_geneforge_ll_wv3a_otr true)
)
;; wave 3b control - player goes to the lower level and sets the encounter otr
;; here in case we need it
;(script dormant geneforge_ll_wv3b_control
;	(sleep_until (and
;				(volume_test_players tv_chiefcheck_geneforge_lower)
;				(= s_geneforge_ll_control_var 4)
;				)
;				1
;	)
;	(set b_geneforge_ll_wv3b_otr true)
;)

;====================================================================================================================================================================================================
; beat 4 - encounter 13 cleanup
;====================================================================================================================================================================================================
;; kill off encounter 13 if needed
(script dormant e10_e13_cleanup
    (sleep_until (volume_test_players tv_kill_encounter_13) 1)
	(ai_erase gr_geneforge_ll_wv4_master)
    (ai_erase gr_geneforge_ll_wv3_master)
	(ai_erase gr_geneforge_ll_wv2_master)
	(ai_erase gr_geneforge_ll_wv1)
)

;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 14 spawning
; location - geneforge main level lower level
; inserion point - ins_main_lab_lower
; zone set - set_4_geneforge_main_lab
; description: chief and johnson learn the truth about what is going on at the lab
;====================================================================================================================================================================================================

(script dormant cooridor_to_glr_wv2_triggered
    (sleep_until (volume_test_players tv_encounter_14) 1)

	(ai_place gr_cooridor_enc_14)

	(set b_backtracking_through_level true)
	(device_set_power dm_encounter_15_door 1)
)

;====================================================================================================================================================================================================
; beat 4 - encounter 14 cleanup
;====================================================================================================================================================================================================
;; kill off encounter 5.5 if needed
(script dormant e10_e14_cleanup
    (sleep_until (volume_test_players tv_kill_encounter_14) 1)

	(ai_erase gr_cooridor_enc_14)
)


;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 15 spawning
; location - geneforge species storage (revisit)
; inserion point - ins_main_lab_lower
; zone set - set_4_geneforge_main_lab
; description:
;====================================================================================================================================================================================================
;wave 1
(script dormant species_storage_wv1_triggered

	(sleep_until (and b_backtracking_through_level (volume_test_players tv_encounter_15)) 1)

	(ai_place gr_storage_enc15_brutes)
	(ai_place gr_storage_enc15_cov)
	(wake trigger_wv1_ll_encounter_defeated)

	;(sleep_until (< (ai_living_count gr_storage_enc15_brutes) 4)  1)
    ;(set b_first_augmented_dies true)
)

; set variable when wave 1 concludes
(script dormant trigger_wv1_ll_encounter_defeated
	(sleep_until (and
				(= (ai_nonswarm_count gr_storage_enc15_brutes) 0)
				(= (ai_nonswarm_count gr_storage_enc15_cov) 0)
				)
				1
	)
	(set b_encounter_15_wv1_complete true)
	(f_blip_flag fl_storage_backtrack 0)
)

;====================================================================================================================================================================================================
; beat 4 - encounter 15 cleanup
;====================================================================================================================================================================================================
;; kill off encounter 15 if needed
(script dormant e10_e15_cleanup
    (sleep_until (and b_backtracking_through_level (volume_test_players tv_kill_encounter_15)) 1)

	(ai_erase gr_storage_enc15_brutes)
	(ai_erase gr_storage_enc15_cov)
)

;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 16 spawning
; location - cooridor to testing facilty (revisit)
; inserion point - ins_main_lab_lower
; zone set - set_4_geneforge_main_lab
; description:
;====================================================================================================================================================================================================
;wave 2
(script dormant species_storage_wv2_triggered
	(sleep_until (and b_backtracking_through_level (volume_test_players tv_encounter_16)) 1)
	(f_unblip_all) ;remove all navpoints
	(f_game_save) ;save the game

	(ai_place gr_storage_upper_brutes)
	(ai_place gr_storage_upper_cov)
	(set b_stasis_chamber_cleared false)
)

;====================================================================================================================================================================================================
; beat 4 - encounter 16 cleanup
;====================================================================================================================================================================================================
; kill off encounter 16 if needed
(script dormant e10_e16_cleanup
    (sleep_until (and b_backtracking_through_level (volume_test_players tv_kill_encounter_16)) 1)

	(ai_erase gr_storage_upper_brutes)
	(ai_erase gr_storage_upper_cov)
)

;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 17 spawning
; location - geneforge testing facility (revisit)
; inserion point - ins_testing_facility_revisit
; zone set - set_4_geneforge_main_lab
; description:
;====================================================================================================================================================================================================
;wave 1 +2
(script dormant testing_facility_wv1_triggered
	(sleep_until (and b_backtracking_through_level (volume_test_players tv_encounter_17)) 1)
	(device_set_position_immediate dm_testing_facility_door 0) ;close the door into the tf if it is open
	(ai_place gr_testing_facility_wv1_cov)
	(wake tf_monster_door_control)
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_tf_revisit_2_3coop_wv1cov)
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_tf_revisit_4coop_wv1cov)
		)
	)

	(sleep_until (<= (ai_nonswarm_count gr_tf_revisit_covenant_master) 3)  1)
	(ai_place gr_testing_facility_wv1_brutes)
	(set s_tf_monster_door_control (+ s_tf_monster_door_control 1)) ;monster door check for 1 player - value=1
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(sleep_until (or
				(game_ticks_from_seconds 10)
				(= (ai_nonswarm_count gr_testing_facility_wv1_brutes) 0)
			)
			1
		)
			(ai_place gr_tf_revisit_2_3coop_wv1brutes)
			(set s_tf_monster_door_control (+ s_tf_monster_door_control 1)) ;monster door check for 2-3 players - value=2
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(sleep_until (or
				(game_ticks_from_seconds 20)
				(= (ai_nonswarm_count gr_tf_revisit_2_3coop_wv1brutes) 0)
			)
			1
		)
			(ai_place gr_tf_revisit_4coop_wv1brutes)
			(set s_tf_monster_door_control (+ s_tf_monster_door_control 1)) ;monster door check for 4 players - value=3
		)
	)

	(sleep_until (and
				(< (ai_nonswarm_count gr_tf_revisit_brutes_master) 2)
				(< (ai_nonswarm_count gr_tf_revisit_covenant_master) 2)
				)
				1
	)
	(device_set_power dm_encounter_17_wave_door 1)
	(ai_place gr_testing_facility_wv2_cov)
	(wake johnson_begins_trek_to_glr)

	(sleep_until (< (ai_nonswarm_count gr_testing_facility_wv2_cov) 4))
	(f_blip_flag fl_testingfacilty_exit 0)

	(sleep_until (and
				(= (ai_nonswarm_count gr_tf_revisit_brutes_master) 0)
				(= (ai_nonswarm_count gr_tf_revisit_covenant_master) 0)
				(= (ai_nonswarm_count gr_testing_facility_wv2_cov) 0)
				)
				1
	)
	(set b_tf_ambush_ends true)
	(ai_set_objective ai_johnson obj_johnson_follow)
	(ai_player_add_fireteam_squad player0 ai_johnson)
)

;leave the doors open after the last brutes spawn.  there is an easter egg in one section so im leaving both doors open
(script dormant tf_monster_door_control
	(if (and
		(not (game_is_cooperative))
		(= (game_difficulty_get_real) easy)
	)
	(begin
		(wake control_solo_door1)
		(wake control_solo_door2)
	)
	)
	(if (and
		(not (game_is_cooperative))
		(= (game_difficulty_get_real) normal)
	)
	(begin
		(wake control_solo_door1)
		(wake control_solo_door2)
	)
	)
	(if (or
		(coop_players_2)
		(coop_players_3)
		(= (game_difficulty_get_real) heroic)
	)
	(begin
		(wake control_2_3_players_door1)
		(wake control_2_3_players_door2)
	)
	)
	(if (or
		(coop_players_4)
		(= (game_difficulty_get_real) legendary)
	)
	(begin
		(wake control_4_players_door1)
		(wake control_4_players_door2)
	)
	)
)

; doors stay open for brutes after initial spawning
(script dormant control_solo_door1
(sleep_until (= s_tf_monster_door_control 1))
	(sleep_until (= (device_get_position dm_monster_door_testing_facility1) 1) 1)
	(device_set_power dm_monster_door_testing_facility1 0)
)
(script dormant control_solo_door2
(sleep_until (= s_tf_monster_door_control 1))
	(sleep_until (= (device_get_position dm_monster_door_testing_facility2) 1) 1)
	(device_set_power dm_monster_door_testing_facility2 0)
)

; doors stay open for brutes after 2nd spawning for 2 to 3 players or heroic
(script dormant control_2_3_players_door1
(sleep_until (= s_tf_monster_door_control 2))
	(sleep_until (= (device_get_position dm_monster_door_testing_facility1) 1) 1)
	(device_set_power dm_monster_door_testing_facility1 0)
)
(script dormant control_2_3_players_door2
(sleep_until (= s_tf_monster_door_control 2))
	(sleep_until (= (device_get_position dm_monster_door_testing_facility2) 1) 1)
	(device_set_power dm_monster_door_testing_facility2 0)
)

; doors stay open for brutes after 3rd spawning for 4 players or legendary
(script dormant control_4_players_door1
(sleep_until (= s_tf_monster_door_control 3))
	(sleep_until (= (device_get_position dm_monster_door_testing_facility1) 1) 1)
	(device_set_power dm_monster_door_testing_facility1 0)
)
(script dormant control_4_players_door2
(sleep_until (= s_tf_monster_door_control 3))
	(sleep_until (= (device_get_position dm_monster_door_testing_facility2) 1) 1)
	(device_set_power dm_monster_door_testing_facility2 0)
)

;====================================================================================================================================================================================================
; beat 4 - encounter 17 cleanup
;====================================================================================================================================================================================================
; kill off encounter 17 if needed
(script dormant e10_e17_cleanup
	(sleep_until (and b_backtracking_through_level (volume_test_players tv_kill_encounter_17)) 1)
	(ai_erase gr_testing_facility_wv2_cov)
	(ai_erase gr_tf_revisit_brutes_master)
	(ai_erase gr_tf_revisit_covenant_master)
	(f_game_save) ;save the game
)

;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 18 spawning
; location - geneforge testing facility (revisit)
; inserion point - ins_testing_facility_revisit
; zone set - set_4_geneforge_main_lab
; description:
;====================================================================================================================================================================================================
;cooridor group watching over the testing facility
(script dormant testing_facility_wv3_triggered
    (sleep_until (volume_test_players tv_encounter_18) 1)
	(wake enc18_is_mad)
	(ai_place sq_coor_to_glr)
	(ai_place sq_coor_to_glr_sleepers)
	(f_game_save) ;save the game
)

(script dormant enc18_is_mad
	(sleep_until (volume_test_players tv_encounter_18_berserk) 1)
	(ai_berserk sq_coor_to_glr true)
)
;====================================================================================================================================================================================================
; beat 4 - encounter 18 cleanup
;====================================================================================================================================================================================================
; kill off encounter 18 if needed
(script dormant e10_e18_cleanup
	(sleep_until (and b_backtracking_through_level (volume_test_players tv_kill_encounter_18)) 1)

	(ai_erase sq_coor_to_glr)
	(ai_erase sq_coor_to_glr_sleepers)
)

;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 19 spawning
; location - grav lift room
; inserion point - ins_double_grav_lift
; zone set - set_4_geneforge_main_lab
; description:
;====================================================================================================================================================================================================
(script dormant grav_lift_initial_encounter
    (sleep_until (volume_test_players tv_encounter_19) 1)
	(ai_place gr_grav_lift_room_walkin)

	;add additional weapons in grav lift room if 3 or more players
	(if (game_is_cooperative)
		(if (>= (game_coop_player_count) 3)
			(begin
				(object_create_folder of_grav_lift_room_items)
			)
		)
	)

	(sleep_until (= (ai_nonswarm_count gr_grav_lift_room_walkin) 0)  1)
	(f_game_save) ;save the game

	(sleep (game_ticks_from_seconds 3))

	(set b_gr_initial_wave_dead true)

)


;====================================================================================================================================================================================================
; beat 4 - encounter 19 cleanup
;====================================================================================================================================================================================================


;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 20 spawning
; location - grav lift room
; inserion point - ins_double_grav_lift
; zone set - set_4_geneforge_main_lab
; description:
;====================================================================================================================================================================================================
;wave 1-3
(script dormant grav_lift_encounter_triggered
	(sleep_until (= b_gr_initial_wave_dead 1) 1)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_glr)
	(ai_place sq_grav_lift_room_wv1_brute)
	(ai_place sq_grav_lift_room_wv1_grunts)
	(sleep (game_ticks_from_seconds 2))
	(ai_place sq_grav_lift_room_wv1_brute2)

	(sleep_until (= (ai_nonswarm_count gr_grav_lift_room_wv1) 0) 1)
	(sleep (game_ticks_from_seconds 2.5))
	(ai_place sq_grav_lift_room_wv2_grunts)
	(ai_place sq_grav_lift_room_wv2_brute)
	(ai_place sq_grav_lift_room_wv2_jackal)
	(sleep (game_ticks_from_seconds 2))
	(ai_place sq_grav_lift_room_wv2_brute2)

	(sleep_until (= (ai_nonswarm_count gr_grav_lift_room_wv2) 0) 1)
	(sleep (game_ticks_from_seconds 2.5))
	(ai_place sq_grav_lift_room_wv3_grunts)
	(ai_place sq_grav_lift_room_wv3_brute)
	(ai_place sq_grav_lift_room_wv3_elite)
	(sleep (game_ticks_from_seconds 2))
	(ai_place sq_grav_lift_room_wv3_brute2)

	; blipping the last three foes in this bloodgate
	(sleep_until (< (ai_nonswarm_count gr_grav_lift_room_master) 4) 1)
	(f_blip_ai gr_grav_lift_room_master 1)

	(sleep_until (and
			(= (ai_nonswarm_count gr_grav_lift_room_master) 0)
			(> (object_get_health (object_get_ai ai_johnson)) 0) ; make sure johnson has health before the script proceeds
			)
			1
	)
	(set s_music_trigger_e10 192)
	(wake glr_gravlifts_enable)
	(cs_run_command_script ai_johnson cs_johnson_turn_on_lift); johnson turns on lift and rides it to the upper layer
)

;====================================================================================================================================================================================================
; beat 4 - encounter 20 cleanup
;====================================================================================================================================================================================================

;;; no cleanup needed - you cant exit grav lift room without killing all enemies

;====================================================================================================================================================================================================
; e10 chapter - a brute awakening
; beat 4 - encounter 21 spawning
; location - geneforge lab upper level
; inserion point - ins_final_encounter
; zone set - set_4_geneforge_main_lab
; description:
;====================================================================================================================================================================================================
;wave 1-2
(script dormant final_encounter_wv1_triggered
    (sleep_until (volume_test_players tv_final_encounter) 1)
	(ai_place gr_final_encounter_start) ;;;; spawn pre-waves

	;add additional equipment in the upper lab if 3 or more players
	(if (game_is_cooperative)
		(if (>= (game_coop_player_count) 3)
			(begin
				(object_create_folder of_coop_upperlab_items)
			)
		)
	)

	(sleep_until (volume_test_players tv_johnson_final_encounter) 1) ;johnson gets into position #1
	(ai_set_objective ai_johnson obj_johnson_final_encounter)
	(cs_run_command_script ai_johnson cs_start_final_calm)

	(wake vo_final_encounter_wave1)

	(sleep_until (>= (ai_combat_status gr_final_encounter_start) dangerous) 1)
	(set s_johnson_final_encounter (+ s_johnson_final_encounter 1))
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_vehicle_enter sq_final_gunner_grunta ve_shade_final1 "")
	(ai_vehicle_enter sq_final_gunner_gruntb ve_shade_final2 "")

	(sleep_until (< (ai_nonswarm_count gr_final_encounter_start) 4) 1) ;wait until there are three left
	(f_blip_ai gr_final_encounter_start 1) ;blip the victims

	(sleep_until (= (ai_nonswarm_count gr_final_encounter_start) 0) 1) ; pre-waves are dead
	(f_game_save) ;save the game
	(set s_johnson_final_encounter (+ s_johnson_final_encounter 1)) ;johnson gets into position #2
	(sleep (game_ticks_from_seconds 3)) ;;;; kill pre-wave and pause
	(ai_place gr_final_encounter_wv1_a)
	(ai_prefer_target_team gr_final_encounter_wv1_a player) ;setting ai to prefer team player
	(ai_set_combat_status gr_final_encounter_wv1_a "active") ;setting combat status to active
	(ai_vehicle_enter sq_final_encounter_wv1a_gunner ve_shade_final1 "")
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_final_e_2_3coop_wv1_a)
			(ai_prefer_target_team gr_final_e_2_3coop_wv1_a player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_2_3coop_wv1_a "active") ;setting combat status to active
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_final_e_4coop_wv1_a)
			(ai_prefer_target_team gr_final_e_4coop_wv1_a player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_4coop_wv1_a "active") ;setting combat status to active
		)
	)

	(sleep_until (<= (ai_living_fraction gr_final_encounter_wv1_a) .65) 1);;; at 65% open door 2
	(ai_place gr_final_encounter_wv1_b)
	(ai_prefer_target_team gr_final_encounter_wv1_b player) ;setting ai to prefer team player
	(ai_set_combat_status gr_final_encounter_wv1_b "active") ;setting combat status to active
	(ai_vehicle_enter sq_final_encounter_wv1b_gunner ve_shade_final2 "")
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_final_e_2_3coop_wv1_b)
			(ai_prefer_target_team gr_final_e_2_3coop_wv1_b player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_2_3coop_wv1_b "active") ;setting combat status to active
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_final_e_4coop_wv1_b)
			(ai_prefer_target_team gr_final_e_4coop_wv1_b player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_4coop_wv1_b "active") ;setting combat status to active
		)
	)
	(sleep_until (< (ai_nonswarm_count gr_final_encounter_master) 4) 1) ;wait until there are three left
	(f_blip_ai gr_final_encounter_master 1) ;blip the victims

	(sleep_until (= (ai_nonswarm_count gr_final_encounter_wv1) 0) 1) ; wave 1 is dead
	(f_game_save) ;save the game
	(set s_johnson_final_encounter (+ s_johnson_final_encounter 1)) ;johnson gets into position #3

	(sleep (game_ticks_from_seconds 3))
	(ai_place gr_final_encounter_wv2_a)
	(ai_prefer_target_team gr_final_encounter_wv2_a player) ;setting ai to prefer team player
	(ai_set_combat_status gr_final_encounter_wv2_a "active") ;setting combat status to active
	(ai_vehicle_enter sq_final_encounter_wv2_gunner ve_shade_final2 "")
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_final_e_2_3coop_wv2_a)
			(ai_prefer_target_team gr_final_e_2_3coop_wv2_a player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_2_3coop_wv2_a "active") ;setting combat status to active
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_final_e_4coop_wv2_a)
			(ai_prefer_target_team gr_final_e_4coop_wv2_a player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_4coop_wv2_a "active") ;setting combat status to active
		)
	)
	(wake vo_final_encounter_wave2)

	(sleep_until (<= (ai_living_fraction gr_final_encounter_wv2_a) .5) 1);;; at 50% open door 2
	(ai_place gr_final_encounter_wv2_b)
	(ai_prefer_target_team gr_final_encounter_wv2_b player) ;setting ai to prefer team player
	(ai_set_combat_status gr_final_encounter_wv2_b "active") ;setting combat status to active
	(ai_vehicle_enter sq_final_encounter_wv2b_gunner ve_shade_final1 "")
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_final_e_2_3coop_wv2_b)
			(ai_prefer_target_team gr_final_e_2_3coop_wv2_b player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_2_3coop_wv2_b "active") ;setting combat status to active
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_final_e_4coop_wv2_b)
			(ai_prefer_target_team gr_final_e_4coop_wv2_b player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_4coop_wv2_b "active") ;setting combat status to active
		)
	)
	(wake vo_final_encounter_wave2half)
	(sleep_until (< (ai_nonswarm_count gr_final_encounter_master) 4) 1) ;wait until there are three left
	(f_blip_ai gr_final_encounter_master 1) ;blip the victims

	(sleep_until (= (ai_nonswarm_count gr_final_encounter_wv2) 0) 1) ; wave 2 is dead
	(f_game_save) ;save the game
	(set s_johnson_final_encounter (+ s_johnson_final_encounter 1)) ;johnson gets into position #4
	(sleep (game_ticks_from_seconds 3))
	(set b_final_wave_attacks true)
	(wake vo_final_encounter_wave3)
	(ai_place gr_final_encounter_solo_wv3)
	(ai_prefer_target_team gr_final_encounter_solo_wv3 player) ;setting ai to prefer team player
	(ai_set_combat_status gr_final_encounter_solo_wv3 "active") ;setting combat status to active
	(sleep (game_ticks_from_seconds .5))
	(ai_vehicle_enter sq_final_encounter_wv3_l_gunner ve_shade_final1 "")
	(ai_vehicle_enter sq_final_encounter_wv3_r_gunner ve_shade_final2 "")
	;------- co-op/difficulty setup for wave --------
	(if (or
		(> (game_coop_player_count) 1)
		(= (game_difficulty_get_real) heroic)
		)
		(begin
			(ai_place gr_final_e_2_3coop_wv3)
			(ai_prefer_target_team gr_final_e_2_3coop_wv3 player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_2_3coop_wv3 "active") ;setting combat status to active
		)
	)
	(if (or
		(= (game_coop_player_count) 4)
		(= (game_difficulty_get_real) legendary)
		)
		(begin
			(ai_place gr_final_e_4coop_wv3)
			(ai_prefer_target_team gr_final_e_4coop_wv3 player) ;setting ai to prefer team player
			(ai_set_combat_status gr_final_e_4coop_wv3 "active") ;setting combat status to active
		)
	)

	(sleep_until (< (ai_nonswarm_count gr_final_encounter_master) 4) 1) ;wait until there are three left
	(f_blip_ai gr_final_encounter_master 1) ;blip the victims

	;;unlock the exit door when all the baddies are dead
	(sleep_until (= (ai_nonswarm_count gr_final_encounter_master) 0) 1)
	(set b_final_wave_eliminated true)
	(wake vo_final_encounter_finished)
	(device_set_power dm_final_exit_door 1)
	(f_blip_flag fl_geneforge_ul_exit 0)
	(ai_set_objective ai_johnson obj_johnson_follow)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(f_game_save) ;save the game
)
(script command_script cs_start_final_calm
	(cs_force_combat_status 1)
)
;====================================================================================================================================================================================================
; beat 4 - encounter 21 cleanup
;====================================================================================================================================================================================================

;;; no cleanup needed - last encounter

;====================================================================================================================================================================================================
; 												e10 - encounters - extra
;====================================================================================================================================================================================================
;skull encounter
(script dormant skull_encounter_triggered
    (sleep_until (volume_test_players tv_skull_encounter) 1)

	(ai_place gr_skull_encounter)
)

;====================================================================================================================================================================================================
; beat 4 - encounter skull cleanup
;====================================================================================================================================================================================================
; kill off skull encounter if needed
(script dormant e10_skull_cleanup
	(sleep_until (and b_backtracking_through_level (volume_test_players tv_kill_encounter_skull)) 1)

	(ai_erase gr_skull_encounter)
)