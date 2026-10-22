; globals
(global boolean debug true)
(global vehicle outro_dropship none)
(global vehicle global_first_dropship none)

; spawn wave parameters : basic
(global real spawn_scale 1.0)			; scales total spawn counts
(global short min_combat_spawn 2)		; minimum number of combats in a spawn wave
(global short min_carrier_spawn 2)		; minimum number of carriers in a spawn wave
(global short min_infection_spawn 3)	; minimum number of infections in a spawn wave

; spawn scale modifier: co-op
(global real spawn_scale_doubles 1.2)		; legacy
(global real spawn_scale_trios 1.3)
(global real spawn_scale_fours 1.4)

; spawn scale modifier: difficulty
(global real spawn_scale_easy 1)			; legacy
(global real spawn_scale_normal 1)			; legacy
(global real spawn_scale_heroic 1.1)		; legacy
(global real spawn_scale_legendary 1.25)	; legacy

; spawn modifiers: combat forms
(global short combat_spawn_easy 0)			; legacy
(global short combat_spawn_normal 0)		; legacy
(global short combat_spawn_heroic 1)		; legacy
(global short combat_spawn_legendary 1)		; legacy

; spawn modifiers: carrier forms
(global short carrier_spawn_easy 0)			; legacy
(global short carrier_spawn_normal 0)		; legacy
(global short carrier_spawn_heroic 1)		; legacy
(global short carrier_spawn_legendary 1)	; legacy

; spawn modifiers: infection forms
(global short infection_spawn_easy 0)		; legacy
(global short infection_spawn_normal 0)		; legacy
(global short infection_spawn_heroic 1)		; legacy
(global short infection_spawn_legendary 2)	; legacy

; spawn modifiers: co-op
(global short combat_spawn_solo 0)			; legacy
(global short combat_spawn_doubles 1) 		; legacy
(global real combat_spawn_trios 1.5)
(global short combat_spawn_fours 2)

;spawn_limit = spawn_scale * co-op_scale * spawn_scale_difficulty * encounter specific scalar
;min_spawn = basic min_spawn + co-op ammount + difficulty ammount * combat specfic scalar


; flood spawn wave limiters
(global short enc1_4_limiter 0)
(global short enc1_5_limiter 0)
(global short enc3_2_limiter 0)
(global short enc3_4_limiter 0)
(global short enc3_5_limiter 0)
(global short enc3_8_limiter 0)
(global short enc4_2_limiter 0)
(global short enc4_4_limiter 0)
(global short enc4_8_limiter 0)
(global short enc5_1_limiter 0)
(global short enc6_1_limiter 0)
(global short enc6_5_limiter 0)
(global short enc7_5_limiter 0)

; vehicles
(global vehicle sq_outro_dropship_global none)

; startup
(script startup mission
	(d20_insertion_point_fixups)
	(f_start_auto_save_loop)

	; for insertion points further than this, necessary stuff will be prepared in the insertion script instead (like ins_section7)
	(wake sequential_checkpoints)

	; music script
	(wake music_d20)

	; nav points control
	(wake breadcrumbs_nav_points_d20)

	; adjusting minimum spawn counts for flood wave spawners.
	(wake difficulty_scaling)

	(if (f_insertion_point_area_pending insertion_section1)
		(begin
			(wake section1)
		)
	)

	(sleep_until (or (volume_test_players 0_to_1_transition_trigger)(f_insertion_point_script_is_blocked insertion_section3)) 1)
	(if (f_insertion_point_area_pending insertion_section3)
		(begin
			(wake section3)
		)
	)

	(sleep_until (or (volume_test_players section4)(f_insertion_point_script_is_blocked insertion_section4) ) 1)

	; creating enc 4 items. these are needed for the rest of the mission
	(wake create_enc4_items)

	(if (f_insertion_point_area_pending insertion_section4)
		(begin
			(wake section4)
		)
	)

	(sleep_until (or (volume_test_players section5)(f_insertion_point_script_is_blocked insertion_section5)) 1)
	(if (f_insertion_point_area_pending insertion_section5)
		(begin
			(wake section5)
		)
	)

	(sleep_until (or (volume_test_players section6)(f_insertion_point_script_is_blocked insertion_section6)) 1)
	(if (f_insertion_point_area_pending insertion_section6)
		(begin
			(wake section6)
		)
	)

	(sleep_until
		(or
			(volume_test_players section7)
			(f_insertion_point_script_is_blocked insertion_section7)
			(f_insertion_point_script_is_blocked insertion_finale)
		)
	1)

	(if (or (f_insertion_point_area_pending insertion_section7)(f_insertion_point_area_pending insertion_finale))
		(begin
			(wake section7)
		)
	)
)

; blocking checkpoints
(script dormant sequential_checkpoints
	(if (f_insertion_point_area_pending insertion_section3)
		(begin
			(f_save_at_trigger save_point3_1)
			(print "save point requested 3_1")
			(f_save_at_trigger save_point3_2)
			(print "save point requested 3_2")))
	(if (f_insertion_point_area_pending insertion_section4)
		(begin
			(f_save_at_trigger save_point4_1)
			(print "save point requested 4_1")
			(f_save_at_trigger save_point4_2)
			(print "save point requested 4_2")))
	(if (f_insertion_point_area_pending insertion_section5)
		(begin
			(f_save_at_trigger save_point5_1)
			(print "save point requested 5_1")))
)

;- objectives ---------------------------------------------------------------------
(script static void f_objective_start
	(print "objective 1: find a way to the ship's bridge.")
	(f_hud_obj_new "obj_d20_start" "obj_d20_start")
)

(script static void f_objective_jump
	(print "objective 1: jump!")
	(f_hud_obj_new_no_hud_completion "obj_d20_jump" "obj_d20_jump")
)

(script static void f_objective_exterior
	(print "objective 3: fight your way to the gravity lift.")
	(f_hud_obj_new "obj_d20_exterior" "obj_d20_exterior")
)

(script static void f_objective_lift
	(print "objective 4: hold your position under the lift until it re-activates.")
	(f_hud_obj_new "obj_d20_lift" "obj_d20_lift")
)

(script static void f_objective_go_to_bay
	(print "objective 5.1: get to the shuttle bay.")
	(f_hud_obj_new "obj_d20_gobay" "obj_d20_gobay")
)

(script static void f_objective_go_to_bay_no_completion
	(print "objective 5.1: get to the shuttle bay.")
	(f_hud_obj_new_no_hud_completion "obj_d20_gobay" "obj_d20_gobay")
)

(script static void f_objective_ascend
	(print_if debug "objective 5.2 | ascend to a higher deck.")
	(f_hud_obj_new_no_hud_completion "obj_d20_ascend" "obj_d20_ascend")
)

(script static void f_objective_ascend_continue
	(print_if debug "objective 5.3 | continue to ascend.")
	(f_hud_obj_new_no_hud_completion "obj_d20_ascend2" "obj_d20_ascend2")
)

(script static void f_objective_go_to_upper
	(print_if debug "objective 5.1 | ascend to the upper deck.")
	(f_hud_obj_new "obj_d20_ascend3" "obj_d20_ascend3")
)

(script static void f_objective_go_to_uppper_no_completion
	(print_if debug "objective 5.1 | ascend to the upper deck.")
	(f_hud_obj_new_no_hud_completion "obj_d20_ascend3" "obj_d20_ascend3")
)

(script static void f_objective_go_to_bridge_no_completion
	(print_if debug "objective 5.5 | get to the ship's bridge.")
	(f_hud_obj_new_no_hud_completion "obj_d20_muster" "obj_d20_muster")
)

(script static void f_objective_go_to_bridge
	(print_if debug "objective 5.5 | get to the ship's bridge.")
	(f_hud_obj_new "obj_d20_muster" "obj_d20_muster")
)

(script static void f_objective_recover
	(print_if debug "objective 6: recover captain keyes.")
	(f_hud_obj_new "obj_d20_recover" "obj_d20_recover")
)

(script static void f_objective_escape
	(print "objective 8: escape in a banshee.")
	(f_hud_obj_new "obj_d20_escape" "obj_d20_escape")
)

;- breadcrumbs navpoints ----------------------------------------------------------
(global short s_breadcrumb_nav_index 0)

(script dormant breadcrumbs_nav_points_d20
	(print "breadcrumb manager started")
	;canyon nav points that are not called in vo scripts
	(wake nav_canyon_b_control)
	(wake nav_canyon_c_control)
	(wake nav_canyon_d_control)
	(wake navpoint_muster_exit_control)
	(wake navpoint_vehiclebay_exit_control)
	(wake navpoint_passage_hole_control)

	; accross the hole the player has to jump in
	(if (= s_breadcrumb_nav_index 0)
		;then
		(begin
			(print "breadcrumb control - navpoint_canyon_jump pending")
			(sleep_until (>= s_breadcrumb_nav_index 1) 1)
			(f_blip_flag navpoint_canyon_jump 0)
			(sleep_until (>= s_breadcrumb_nav_index 2) 1)
			(f_unblip_flag navpoint_canyon_jump)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 3) 1)

	; in passageway after leaving the water
	(if (<= s_breadcrumb_nav_index 3)
		(begin
			(print "breadcrumb control - navpoint_canyon_entrance pending")
			(sleep_until (>= s_breadcrumb_nav_index 3) 1)
			(f_blip_flag navpoint_canyon_entrance 0)
			(sleep_until (>= s_breadcrumb_nav_index 4) 1)
			(f_unblip_flag navpoint_canyon_entrance)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 5) 1)

	; in start of canyon b
	(if (<= s_breadcrumb_nav_index 5)
		(begin
			(print "breadcrumb control - navpoint_canyon_b pending")
			(sleep_until (>= s_breadcrumb_nav_index 5) 1)
			(f_blip_flag navpoint_canyon_b 0)
			(sleep_until (>= s_breadcrumb_nav_index 6) 1)
			(f_unblip_flag navpoint_canyon_b)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 7) 1)

	; in start of canyon c
	(if (<= s_breadcrumb_nav_index 7)
		(begin
			(print "breadcrumb control - navpoint_canyon_c pending")
			(sleep_until (>= s_breadcrumb_nav_index 7) 1)
			(f_blip_flag navpoint_canyon_c 0)
			(sleep_until (>= s_breadcrumb_nav_index 8) 1)
			(f_unblip_flag navpoint_canyon_c)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 9) 1)

	; in start of canyon d
	(if (<= s_breadcrumb_nav_index 9)
		(begin
			(print "breadcrumb control - navpoint_canyon_d pending")
			(sleep_until (>= s_breadcrumb_nav_index 9) 1)
			(f_blip_flag navpoint_canyon_d 0)
			(sleep_until (>= s_breadcrumb_nav_index 10) 1)
			(f_unblip_flag navpoint_canyon_d)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 11) 1)

	; on grav lift
	(if (<= s_breadcrumb_nav_index 11)
		(begin
			(print "breadcrumb control - navpoint_gravlift pending")
			(sleep_until (>= s_breadcrumb_nav_index 11) 1)
			(f_blip_flag navpoint_gravlift 0)
			(sleep_until (>= s_breadcrumb_nav_index 12) 1)
			(f_unblip_flag navpoint_gravlift)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 13) 1)

	;in muster bay
	(if (<= s_breadcrumb_nav_index 13)
		(begin
			(print "breadcrumb control - navpoint_muster_exit pending")
			(sleep_until (>= s_breadcrumb_nav_index 13) 1)
			(f_blip_flag navpoint_muster_exit 0)
			(sleep_until (>= s_breadcrumb_nav_index 14) 1)
			(f_unblip_flag navpoint_muster_exit)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 15) 1)

	;in shuttle bay 1st time
	(if (<= s_breadcrumb_nav_index 15)
		(begin
			(print "breadcrumb control - navpoint_shuttle_bay 1sy pending")
			(sleep_until (>= s_breadcrumb_nav_index 15) 1)
			(f_blip_flag navpoint_shuttle_bay 0)
			(sleep_until (>= s_breadcrumb_nav_index 16) 1)
			(f_unblip_flag navpoint_shuttle_bay)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 17) 1)

	;in vehicle bay incase player is lost
	(if (<= s_breadcrumb_nav_index 17)
		(begin
			(print "breadcrumb control - navpoint_vehiclebay_exit pending")
			(sleep_until (>= s_breadcrumb_nav_index 17) 1)
			(f_blip_flag navpoint_vehiclebay_exit 0)
			(sleep_until (>= s_breadcrumb_nav_index 18) 1)
			(f_unblip_flag navpoint_vehiclebay_exit)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 19) 1)

	;in passage hole
	(if (<= s_breadcrumb_nav_index 19)
		(begin
			(print "breadcrumb control - navpoint_passage_hole pending")
			(sleep_until (>= s_breadcrumb_nav_index 19) 1)
			(f_blip_flag navpoint_passage_hole 0)
			(sleep_until (>= s_breadcrumb_nav_index 20) 1)
			(f_unblip_flag navpoint_passage_hole)
		)
	)

	(sleep_until (>= s_breadcrumb_nav_index 20) 1)

	;in shuttle bay 2nd time
	(if (<= s_breadcrumb_nav_index 20)
		(begin
			(print "breadcrumb control - navpoint_shuttle_bay 2nd pending")
			(sleep_until (>= s_breadcrumb_nav_index 20) 1)
			(f_blip_flag navpoint_shuttle_bay 0)
			(sleep_until (>= s_breadcrumb_nav_index 21) 1)
			(f_unblip_flag navpoint_shuttle_bay)
		)
	)

	(sleep_until (= b_keyes_cinematic_played 1) 1)

	; after keyes cinematic
	;(if (= s_breadcrumb_nav_index 5)
	;	(begin
	;		(breadcrumbs_activate_team_nav_point_position "default" player 14.65 -101.14 -73.80 "navpoint_5_1" 0.55)
	;		(sleep_until
	;			(or
	;				(< (objects_distance_to_position (players) 14.65 -101.14 -73.80) 2)
	;				(> s_breadcrumb_nav_index 5)
	;			)
	;		)
	;		(breadcrumbs_deactivate_team_nav_point player "navpoint_5_1")
	;		(set s_breadcrumb_nav_index 6)
	;	)
	;)

	; on door leading to hangar
	;(if (= s_breadcrumb_nav_index 6)
	;	(begin
	;		(breadcrumbs_activate_team_nav_point_position "default" player 7.02 -92.22 -74.30 "navpoint_5_2" 0.55)
	;		(sleep_until
	;			(or
	;				(< (objects_distance_to_position (players) 7.02 -92.22 -74.30) 2)
	;				(> s_breadcrumb_nav_index 6)
	;			)
	;		)
	;		(breadcrumbs_deactivate_team_nav_point player "navpoint_5_2")
	;		(set s_breadcrumb_nav_index 7)
	;	)
	;)

	; near end of level towards hangar
	;(if (= s_breadcrumb_nav_index 7)
	;	(begin
	;		(breadcrumbs_activate_team_nav_point_position "default" player -3.99 -80.15 -75.30 "navpoint_6" 0.55)
	;		(sleep_until
	;			(or
	;				(< (objects_distance_to_position (players) -3.99 -80.15 -75.30) 2)
	;				(> s_breadcrumb_nav_index 7)
	;			)
	;		)
	;		(breadcrumbs_deactivate_team_nav_point player "navpoint_6")
	;	)
	;)
)

(global boolean b_keyes_cinematic_played 0)
(global boolean b_player_fell_in_hangar_once 0)
(global cutscene_flag last_blip_flag navpoint_shuttle_bay)
(global boolean b_control_room_vo_played 0)
(global boolean b_banshee_blipped 0)

(script static void (f_blip_one_hangar_flag (cutscene_flag f) (short type))
	(f_unblip_flag last_blip_flag)
	(f_blip_flag f type)
	(set last_blip_flag f)
)

(script static void navpoint_shuttle_1st_to_2nd_floor_control
	(print "navpoint_shuttle_1st_to_2nd_floor_control started")
	;nav 1
	(f_blip_one_hangar_flag navpoint_shuttle_1st_exit 0)

	(sleep_until (volume_test_players tv_navend_shuttle_1st_exit) 1)

	;nav 2
	(f_blip_one_hangar_flag navpoint_shuttle_1st_hall 0)
	(sleep_until (volume_test_players tv_navend_shuttle_1st_hall) 1)

	;nav 3
	(f_blip_one_hangar_flag navpoint_shuttle_2nd_ent 0)
)

(script static void navpoint_shuttle_2nt_to_3rd_floor_control
	(print "navpoint_shuttle_2nt_to_3rd_floor_control started")
	;nav 1
	(f_blip_one_hangar_flag navpoint_shuttle_2nd_exit 0)
	(sleep_until (volume_test_players tv_navend_shuttle_2nd_exit) 1)

	;nav 2
	(f_blip_one_hangar_flag navpoint_shuttle_2nd_hall 0)
	(sleep_until (volume_test_players tv_navend_shuttle_2nd_hall) 1)

	;nav 3
	(f_blip_one_hangar_flag navpoint_shuttle_3rd_ent 0)
)

(script static void navpoint_shuttle_3rd_to_keyes_control
	(print "navpoint_shuttle_3rd_to_keyes_control started")
	;nav 1
	(f_blip_one_hangar_flag navpoint_shuttle_top 0)

	(if (= b_control_room_vo_played 1)
		(begin
			(sleep_until (volume_test_players tv_navend_shuttle_3rd_exit) 1)

			;nav 2
			(f_blip_one_hangar_flag navpoint_keyes_room 0)
			(sleep_until (volume_test_players tv_navend_shuttle_2nd_hall) 1)
		)
	)

)

(script dormant navpoint_control_room_control
	(set b_control_room_vo_played true)
	(f_blip_one_hangar_flag navpoint_keyes_room 0)
	(print "set b_control_room_vo_played 1")
)

;triggered in vo_enc5_1
(script dormant nav_hangar_loop_up
	(f_blip_one_hangar_flag navpoint_shuttle_top 0) ;first hangar navpoint

	(sleep_until (volume_test_players tv_nav_shuttle_1st_floor) 1)

	;loop while b_keyes_cinematic_played is false
	(sleep_until
		(begin
			(cond
				((volume_test_players tv_nav_shuttle_1st_floor) (navpoint_shuttle_1st_to_2nd_floor_control))
				((volume_test_players tv_nav_shuttle_2nd_floor) (navpoint_shuttle_2nt_to_3rd_floor_control))
				((volume_test_players tv_nav_shuttle_3rd_floor) (navpoint_shuttle_3rd_to_keyes_control))
				((volume_test_players tv_navend_shuttle_3rd_exit) (navpoint_shuttle_1st_to_2nd_floor_control))
			)
			b_keyes_cinematic_played ;exit condition
		)
		1 ;run every tick
	)
	(print "script dormant nav_hangar_loop_up over")
)

;triggered in enc6_3
(script dormant navpoint_to_mission_end
	(branch (= b_banshee_blipped 1) (f_navpoint_abort))

	 ; sleep until the door is open
	(sleep_until b_keyes_door_is_open 1)

	;nav 1
	(f_blip_one_hangar_flag navpoint_keyes_room_exit 0)
	(sleep_until (volume_test_players tv_navend_shuttle_3rd_exit) 1)

	;nav 2
	(f_blip_one_hangar_flag navpoint_shuttle_top 0)
	(sleep_until (volume_test_players tv_nav_shuttle_3rd_floor) 1)

	;nav 3
	(f_blip_one_hangar_flag navpoint_shuttle_3rd_ent 0)
	(sleep_until (volume_test_players tv_navend_shuttle_3rd_ent2) 1)

	;nav 4
	(f_blip_one_hangar_flag navpoint_shuttle_2nd_hall 0)
	(sleep_until (volume_test_players tv_navend_shuttle_2nd_hall2) 1)

	;nav 5
	(f_blip_one_hangar_flag navpoint_shuttle_2nd_exit 0)
	(sleep_until (volume_test_players tv_navend_shuttle_2nd_exit2) 1)
	(f_unblip_flag last_blip_flag)
)

;triggered in vo_enc7_2
(script dormant nav_banshee_control
	(f_unblip_flag last_blip_flag)
	(set b_banshee_blipped true)
	(f_blip_object (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint) 0)
)

;navpoint 1 - called in vo_enc1_5
(script dormant nav_canyon_jump_control
	(print "breadcrumb control - nav_canyon_jump_control - started")
	(branch (>= s_breadcrumb_nav_index 3) (f_navpoint_abort))

	(if (<= s_breadcrumb_nav_index 0)
		;then
		(begin
			(set s_breadcrumb_nav_index 1)
			(print "set s_breadcrumb_nav_index 1")
		)
	)

	(sleep_until (volume_test_players jump_safe) 1)
	(if (<= s_breadcrumb_nav_index 1)
		;then
		(begin
			(set s_breadcrumb_nav_index 2)
			(print "set s_breadcrumb_nav_index 2")
		)
	)
	(print "breadcrumb control - nav_canyon_jump_control - ended")
)

;navpoint 2 - called in vo_enc3_0
(script dormant nav_canyon_entrance_control
	(print "breadcrumb control - nav_canyon_entrance_control - started")
	(branch (>= s_breadcrumb_nav_index 5) (f_navpoint_abort))

	(if (<= s_breadcrumb_nav_index 2)
		;then
		(begin
			(set s_breadcrumb_nav_index 3)
			(print "set s_breadcrumb_nav_index 3")
		)
	)

	(sleep_until (volume_test_players enc3_1c) 1)
	(if (<= s_breadcrumb_nav_index 3)
		;then
		(begin
			(set s_breadcrumb_nav_index 4)
			(print "set s_breadcrumb_nav_index 4")
		)
	)
	(print "breadcrumb control - nav_canyon_entrance_control - ended")
)

;navpoint 3 - called in breadcrumbs_nav_points_d20
(script dormant nav_canyon_b_control
	(print "breadcrumb control - nav_canyon_b_control - started")
	(branch (>= s_breadcrumb_nav_index 7) (f_navpoint_abort))

	(sleep_until (volume_test_players tv_nav_canyon_b) 1)
	(if (<= s_breadcrumb_nav_index 4)
		;then
		(begin
			(set s_breadcrumb_nav_index 5)
			(print "set s_breadcrumb_nav_index 5")
		)
	)

	(sleep_until (volume_test_players tv_navend_canyon_b) 1)
	(if (<= s_breadcrumb_nav_index 5)
		;then
		(begin
			(set s_breadcrumb_nav_index 6)
			(print "set s_breadcrumb_nav_index 6")
		)
	)
	(print "breadcrumb control - nav_canyon_b_control - ended")
)

;navpoint 4 - called in breadcrumbs_nav_points_d20
(script dormant nav_canyon_c_control
	(print "breadcrumb control - nav_canyon_c_control - started")
	(branch (>= s_breadcrumb_nav_index 9) (f_navpoint_abort))

	(sleep_until (volume_test_players tv_nav_canyon_c) 1)
	(if (<= s_breadcrumb_nav_index 6)
		;then
		(begin
			(set s_breadcrumb_nav_index 7)
			(print "set s_breadcrumb_nav_index 7")
		)
	)

	(sleep_until (volume_test_players tv_navend_canyon_c) 1)
	(if (<= s_breadcrumb_nav_index 7)
		;then
		(begin
			(set s_breadcrumb_nav_index 8)
			(print "set s_breadcrumb_nav_index 8")
		)
	)
	(print "breadcrumb control - nav_canyon_c_control - ended")
)

;navpoint 5 - called in breadcrumbs_nav_points_d20
(script dormant nav_canyon_d_control
	(print "breadcrumb control - nav_canyon_d_control - started")
	(branch (>= s_breadcrumb_nav_index 11) (f_navpoint_abort))

	(sleep_until (volume_test_players tv_nav_canyon_d) 1)
	(if (<= s_breadcrumb_nav_index 8)
		;then
		(begin
			(set s_breadcrumb_nav_index 9)
			(print "set s_breadcrumb_nav_index 9")
		)
	)

	(sleep_until (volume_test_players tv_navend_canyon_d) 1)
	(if (<= s_breadcrumb_nav_index 9)
		;then
		(begin
			(set s_breadcrumb_nav_index 10)
			(print "set s_breadcrumb_nav_index 10")
		)
	)
	(print "breadcrumb control - nav_canyon_d_control - ended")
)

;navpoint 6 - called in vo_enc3_8
(script dormant nav_gravlift_control
	(print "breadcrumb control - nav_gravlift_control - started")
	(branch (>= s_breadcrumb_nav_index 13) (f_navpoint_abort))

	(if (<= s_breadcrumb_nav_index 10)
		;then
		(begin
			(set s_breadcrumb_nav_index 11)
			(print "set s_breadcrumb_nav_index 11")
		)
	)

	(sleep_until (volume_test_players section4) 1)
	(if (<= s_breadcrumb_nav_index 11)
		;then
		(begin
			(set s_breadcrumb_nav_index 12)
			(print "set s_breadcrumb_nav_index 12")
		)
	)
	(print "breadcrumb control - nav_gravlift_control - ended")
)

;navpoint 7 - called in breadcrumbs_nav_points_d20
(script dormant navpoint_muster_exit_control
	(print "breadcrumb control - navpoint_muster_exit - started")
	(branch (>= s_breadcrumb_nav_index 15) (f_navpoint_abort))

	(sleep_until (volume_test_players section4) 1)
	(print "breadcrumb control - musterbay dawdle timer")
	(sleep (game_ticks_from_seconds 60)) ;give the player a bit to exit the room on thier own

	(if (volume_test_players section4) ;check if they are still in the room
		;then
		(if (<= s_breadcrumb_nav_index 12)
			;then
			(begin
				(set s_breadcrumb_nav_index 13)
				(print "set s_breadcrumb_nav_index 13")
			)
		)
	)

	(sleep_until (volume_test_players tv_navend_muster_exit) 1)
	(if (<= s_breadcrumb_nav_index 13)
		;then
		(begin
			(set s_breadcrumb_nav_index 14)
			(print "set s_breadcrumb_nav_index 14")
		)
	)
	(print "breadcrumb control - navpoint_muster_exit - ended")
)

;navpoint 8 - called in vo_enc4_2
(script dormant navpoint_shuttle_bay_control
	(print "breadcrumb control - navpoint_shuttle_bay_control - started")
	;(branch (>= s_breadcrumb_nav_index 17) (f_navpoint_abort))

	(if (<= s_breadcrumb_nav_index 14)
		;then
		(begin
			(set s_breadcrumb_nav_index 15)
			(print "set s_breadcrumb_nav_index 15")
		)
	)

	(sleep_until (volume_test_players enc5_1) 1)
	(if (<= s_breadcrumb_nav_index 21)
		;then
		(begin
			(set s_breadcrumb_nav_index 22)
			(print "set s_breadcrumb_nav_index 22")
		)
	)
	(print "breadcrumb control - navpoint_shuttle_bay_control - ended")
)

;navpoint 9 - called in breadcrumbs_nav_points_d20
(script dormant navpoint_vehiclebay_exit_control
	(print "breadcrumb control - navpoint_vehiclebay_exit_control - started")
	(branch (>= s_breadcrumb_nav_index 20) (f_navpoint_abort))

	(sleep_until (volume_test_players tv_nav_vehiclebay_exit) 1)
	(if (<= s_breadcrumb_nav_index 16)
		;then
		(begin
			(set s_breadcrumb_nav_index 17)
			(print "set s_breadcrumb_nav_index 17")
		)
	)

	(sleep_until (volume_test_players tv_navend_vehiclebay_exit) 1)
	(if (<= s_breadcrumb_nav_index 17)
		;then
		(begin
			(set s_breadcrumb_nav_index 18)
			(print "set s_breadcrumb_nav_index 18")
		)
	)

	(print "breadcrumb control - navpoint_vehiclebay_exit_control - ended")
)

;navpoint 10 - called in breadcrumbs_nav_points_d20
(script dormant navpoint_passage_hole_control
	(print "breadcrumb control - navpoint_passage_hole_control - started")
	(branch (>= s_breadcrumb_nav_index 22) (f_navpoint_abort))

	(sleep_until (volume_test_players tv_navend_vehiclebay_exit) 1)
	(if (<= s_breadcrumb_nav_index 18)
		;then
		(begin
			(set s_breadcrumb_nav_index 19)
			(print "set s_breadcrumb_nav_index 19")
		)
	)

	(sleep_until (volume_test_players tv_navend_passage_hole) 1)
	(if (<= s_breadcrumb_nav_index 19)
		;then
		(begin
			(set s_breadcrumb_nav_index 20) ;
			(print "set s_breadcrumb_nav_index 20")
		)
	)
	(print "breadcrumb control - navpoint_passage_hole_control - ended")
)

(script static void (f_navpoint_abort)
	(print "aborting navpoint script")
)

;- difficulty setup ---------------------------------------------------------------
(script dormant difficulty_scaling
	;_____ co-op adjustments _____
	(if (game_is_cooperative)
		(begin
			(print_if debug "encounters | difficulty adjust for coop")
			(cond
				((= (game_coop_player_count) 2) (begin (set spawn_scale (* spawn_scale spawn_scale_doubles)) (set min_combat_spawn (+ min_combat_spawn combat_spawn_doubles))))
				((= (game_coop_player_count) 3) (begin (set spawn_scale (* spawn_scale spawn_scale_trios)) (set min_combat_spawn (+ min_combat_spawn combat_spawn_trios))))
				((= (game_coop_player_count) 4) (begin (set spawn_scale (* spawn_scale spawn_scale_fours)) (set min_combat_spawn (+ min_combat_spawn combat_spawn_fours))))
			)
		)
		(print_if debug "encounters | difficulty adjust for solo")
	)

	;_____ difficulty adjustments _____
	(if (= "normal" (game_difficulty_get)) (print_if debug "encounters | difficulty adjust for normal/easy"))

	(if (= "heroic" (game_difficulty_get))
		(begin
			(print_if debug "encounters | difficulty adjust for heroic")
			(set spawn_scale (* spawn_scale spawn_scale_heroic))
			(set min_combat_spawn (+ min_combat_spawn combat_spawn_heroic))
			(set min_carrier_spawn (+ min_carrier_spawn carrier_spawn_heroic))
			(set min_infection_spawn (+ min_infection_spawn infection_spawn_heroic))
		)
	)

	(if (= "legendary" (game_difficulty_get))
		(begin
			(print_if debug "encounters | difficulty adjust for legendary")
			(set spawn_scale (* spawn_scale spawn_scale_legendary))
			(set min_combat_spawn (+ min_combat_spawn combat_spawn_legendary))
			(set min_carrier_spawn (+ min_carrier_spawn carrier_spawn_legendary))
			(set min_infection_spawn (+ min_infection_spawn infection_spawn_legendary))
		)
	)
)

;- mission scripts ----------------------------------------------------------

;======================================================================================================================================================================================================
;===== section 1 ======================================================================================================================================================================================
;===== mission start. cortana teleports the player as close as she can, but now they need to find keyes ===============================================================================================
;======================================================================================================================================================================================================

(script dormant section1
	; unlock progress data
	(submit_incident "ins_d20_section1")
	(submit_incident "unlock_d20")
	(submit_incident_with_custom_string_id "game_activity_begin" "d20")

	(print_if debug "section1")
	(f_play_cinematic cinematics\d20\d20_intro.cinematic)
	(wake chapter_1_objective1_control)
	(f_game_save)

	(wake section1_point_of_no_return)

	; wake next
	(wake enc1_1)
	(wake enc1_1_exploration)
	(wake enc1_2)
	(wake enc1_3)
	(wake enc1_4)
	(wake enc1_5)
	(wake skull_canyonrun)

	(if (> (game_coop_player_count) 2)
		(object_create active_camouflage_levelstart1_coop)
	)

	; wait for the player to drop into the hole
	(sleep_until (volume_test_players 0_to_1_transition_trigger) 1)

	; music
	(set s_music_trigger 40)

	; kill some scripts and sounds first
  	(sleep_forever enc1_1_exploration)
	(sleep_forever migrate_grunt)
	(sleep_forever enc1_5)

	; kill units!
	(ai_erase enc1_5_flood)
	(ai_erase enc1_3_flood)
	(ai_erase enc1_3_cov)
	(ai_erase enc1_2_flood)
	(ai_erase enc1_2_cov)
	(ai_erase enc1_1_flood)

	; destroy objects that are only in the first part of the ship
	(object_destroy_folder ob_folder_ship_part_a)

	(f_game_save)
)

(script dormant chapter_1_objective1_control
	(chapter_d20_1)
	(f_objective_start)
)

(script static void chapter_d20_1
	(print "chapter title 1 - under new management") ;cinematic will have title card
	(f_hud_chapter "chapter_d20_1")
)

(script dormant section1_point_of_no_return

	;pull players out of the ship into the canyon
	(print_if debug "point of no return | players pulled to coolant drop")
	(sleep_until (volume_test_players tv_no_return_coolant_drop) 1)
	(volume_teleport_players_not_inside tv_no_return_coolant_check fl_teleport_coop_coolant)
	(garbage_collect_now)
)

(script dormant enc1_1
	(sleep_until (volume_test_players enc1_1) 1)
	(print_if debug "enc1_1")

	(ai_place enc1_1_flood)

	(wake vo_enc1_1)

	;slides first door open without player being close enough
	(device_set_position small_door24 1)

	; music
	(set s_music_trigger 20)

	;locks first door in place
	(sleep_until (> (device_get_position small_door24) .9) 1)
	(device_set_power small_door24 0)
)

;these check whether the player has walked in all these trigger volumes needed for cortana's vo to trigger
(global boolean enc1_1_door1 false)
(global boolean enc1_1_door2 false)
(global boolean enc1_1_door3 false)
(global boolean enc1_1_door4 false)

(script dormant enc1_1_exploration
	(sleep_until
		(begin
			(if
				(and (not enc1_1_door1) (volume_test_players enc1_1_door1_volume))
				(set enc1_1_door1 true)
			)
			(if (and (not enc1_1_door2) (volume_test_players enc1_1_door2_volume))
				(set enc1_1_door2 true)
			)
			(if (and (not enc1_1_door3) (volume_test_players enc1_1_door3_volume))
				(set enc1_1_door3 true)
			)
			(if (and (not enc1_1_door4) (volume_test_players enc1_1_door4_volume))
				(set enc1_1_door4 true)
			)
			(and
				enc1_1_door1
				enc1_1_door2
				enc1_1_door3
				enc1_1_door4
			)
		)
	1)

	;play cortana vo: "the damage caused by the crash and the flood have sealed off all nearby accessways to the control room. we should find another way in." when player has walked into all the above volumes
	(wake vo_enc1_1_exploration)
)

(script dormant migrate_grunt
	(device_set_position_immediate small_door 1)
	(ai_flee_to_point enc1_2_cov ps_enc1_2_cov/flee_trgt)

	(wake vo_vig1_migrate_grunt)

	;pauses moving the squad group to the next encounter until the grunt makes it to the next encounter or dies.
	(sleep_until
		(or
			(= 0 (ai_nonswarm_count sq_enc1_2_covenant_grunt))
			(volume_test_object grunt_migrate_trigger (ai_get_object sq_enc1_2_covenant_grunt))
		)
	1)

	(print_if (volume_test_object grunt_migrate_trigger (ai_get_object sq_enc1_2_covenant_grunt)) "enc1_2 grunt escaped the pursuit")
	(print_if (= 0 (ai_nonswarm_count sq_enc1_2_covenant_grunt)) "enc1_2 grunt died")

	; move the squad groups in enc1_2 to enc1_3 into the next encounter, and trigger it
	(ai_migrate enc1_2_flood sq_enc1_3_flood_combat_forms)
	(ai_migrate enc1_2_cov sq_sacrifices_enc1_3_cov_grunts)
)

(script dormant checkpoint1_2
	(f_save_at_trigger save1_2)
	(print "save requested 1_2")
)

(script dormant enc1_2
	(sleep_until (volume_test_players enc1_2) 1)
	(print_if debug "enc1_2")
	(wake checkpoint1_2)

	; erase old units
	(ai_erase sq_control_room_infs)

	; place the chasers, disarm (hee hee) the flood
	(ai_place enc1_2_cov)
	(ai_place enc1_2_flood)

	(wake migrate_grunt)
)

(script command_script cs_enc1_2_flood_disarm
	; keep brain
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_enable_moving true)

	; fake missing arms
	(object_set_region_state ai_current_actor l_forearm destroyed)
	(object_set_region_state ai_current_actor l_upperarm destroyed)
	(object_set_region_state ai_current_actor r_forearm destroyed)
	(object_set_region_state ai_current_actor r_upperarm destroyed)

	; so that they can't reanimate..
	; any damage
	(sleep_until (!= (object_get_recent_body_damage ai_current_actor) 0) 1)

	; to dust!
	(effect_new_on_object_marker objects/characters/flood_infection/fx/body_destroyed ai_current_actor body)
	(ai_erase ai_current_actor)
)

(script dormant enc1_3
	;_____ encounter trigger _____
	(sleep_until (volume_test_players enc1_2) 1) ;currently kicked off by entering the same trigger as 1_2, worth watching
	(print_if debug "enc1_3")

	;_____ encounter setup _____
	; place the ai
	(ai_place enc1_3_cov)

	;pausing the spawning of flood to more closely align with legacy feel.
	(sleep_until (volume_test_players v_enc1_3_dropper) 1)
	(ai_place enc1_3_flood)

	(ai_magically_see enc1_3_flood enc1_3_cov)
	(ai_prefer_target_ai enc1_3_cov enc1_3_flood true)

	;_____ combat begins _____
	; sleep until the grunts are dead, then show the flood the players
	(sleep_until (<= (ai_nonswarm_count enc1_3_cov) 0) 1)
	(f_ai_magically_see_players enc1_3_flood)
)

(script dormant enc1_4
	(sleep_until (volume_test_players enc1_4) 1)
	(print_if debug "enc1_4")

	; place the covenant
	(ai_place enc1_4_cov)
	(ai_place enc1_4_flood)

	(ai_prefer_target_ai enc1_4_cov enc1_4_flood true)

	; sleep until one side is dead
	;(sleep_until
		;(or
			;(<= (ai_living_count enc1_4_cov) 0)
			;(<= (ai_living_count enc1_4_flood) 0)
		;)
	;)

	; ; sleep until the player is in the trigger volume
	; (sleep_until (volume_test_players enc1_5) 1)

	; ; make the flood leap and the cov migrate
	; (ai_command_list enc1_4_flood enc1_4_leap)
	; (ai_maneuver enc1_4_cov/migrate)

	(sleep_until
		(or
			(volume_test_players enc1_4_safety)
			(volume_test_players enc1_4_safety2)
		)
	1)

	(ai_prefer_target (players) true)
)

(script dormant enc1_5
	;_____ encounter trigger _____
	(sleep_until (volume_test_players enc1_5) 1)
	(print_if debug "enc1_5")

	;_____ checkpointing _____
	(wake checkpoint1_5)

	;_____ encounter setup _____
	(sleep_forever enc1_1_exploration)

	(sleep_until (> (device_get_position enc1_5_door) .8) 1)
	(wake vo_enc1_5_intro_trigger)

	;_____ combat begins _____
	; allow cortana to talk some before starting the flood. don't wait for her to finish since the flood need a head start.
	(sleep (game_ticks_from_seconds 3.0))

	; fire up the spawner
	(wake enc1_5_spawner)
	(f_ai_magically_see_players enc1_5_flood)

	(wake vo_enc1_5)
)

;called in vo_enc1_5
(script dormant objective_jump
	(f_objective_jump)

	(sleep_until (volume_test_players 0_to_1_transition_trigger) 1)
	(f_hud_obj_complete)
)

(script dormant checkpoint1_5
	(f_save_at_trigger save1_5)
	(print "save requested 1_5")
)

;spawner starts after the player opens the door to hangar and ends when the player proceeds to section 3
(script dormant enc1_5_spawner
	(print_if debug "enc1_5 | spawner enabled")
	(sleep_until
		(begin
			(if
				(and
					(volume_test_players enc1_5_spawner)
					(< enc1_5_limiter (* 60 spawn_scale)) ; 60 ->105
				)
				; these conditions are met. spawn.
				(begin
					; check the combat form count. if it is too low, spawn
					(if (<= (ai_living_count sq_enc1_5_flood_combat_elite)
						(* (+ (/ enc1_5_limiter 20) 1) min_combat_spawn) ; just ask tyson
					)
						; spawn 'em and increment the count
						(begin
							(ai_place sq_enc1_5_flood_combat_elite 1)
							(set enc1_5_limiter (+ enc1_5_limiter 1))
							(print_if debug "enc1_5 | combat form added")
						)
					)
					; check the carrier form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc1_5_flood_carrier) min_carrier_spawn)
						; spawn 'em and increment the count
						(begin
							(ai_place sq_enc1_5_flood_carrier 1)
							(set enc1_5_limiter (+ enc1_5_limiter 1))
							(print_if debug "enc1_5 | carrier form added")
						)
					)
					; check the infection form count. if it is too low, spawn
					(if (<= (ai_living_count sq_enc1_5_flood_infections) (* 2 min_infection_spawn))
						(begin; spawn 'em
							(ai_place sq_enc1_5_flood_infections)
							(print_if debug "enc1_5 | infection form added")
						)
					)
				)
			)
			; pause for a moment
			(sleep (game_ticks_from_seconds 1))

			;exit condition
			false
		)
	1)
)

;======================================================================================================================================================================================================
;===== section 2 ======================================================================================================================================================================================
;===== does not exist. continue to section 3 ==========================================================================================================================================================
;======================================================================================================================================================================================================

;======================================================================================================================================================================================================
;===== section 3 ======================================================================================================================================================================================
;===== player drops into the canyon and needs to find a new way back into the ship ====================================================================================================================
;======================================================================================================================================================================================================

(script dormant section3
	(print_if debug "section3")
	(ai_prefer_target (players) false)

	(wake section3_point_of_no_returns)

	; wake the canyon jump
	(wake jump_player0)
	(wake jump_player1)
	(wake jump_player2)
	(wake jump_player3)

	(if (> (game_coop_player_count) 2)
		(object_create active_camouflage_canyon1_coop)
	)

	(wake enc3_0)
	;(wake i_am_skin_diver)
	(wake enc3_1_vo)
	(wake enc3_1_music)
	(wake enc3_2)
	(wake enc3_3)
	(wake enc3_4)
	(wake enc3_5)
	(wake enc3_6)
	(wake enc3_7)
	(wake enc3_8)
	(wake enc3_9)

	(sleep_forever enc1_5_spawner)
	(print_if debug "enc1_5 | spawner disabled")

	; create items
	(object_create_folder ob_folder_elites1)
	(sleep 2)
	(object_create_folder ob_folder_floodelites1)
	(sleep 2)
	(object_create_folder ob_folder_floodhuman1)
	(sleep 2)
	(object_create_folder ob_folder_grunts1)
	(sleep 2)
	(object_create_folder ob_folder_grunts2)
	(sleep 2)
	(object_create_folder ob_folder_turrets)
)

(script dormant section3_point_of_no_returns

	;no return entering the second to last canyon segment
	(print_if debug "point of no return | players pulled to final canyon")
	(sleep_until (volume_test_players tv_no_return_end_canyon) 1)
	(volume_teleport_players_not_inside tv_no_return_end_canyon_check fl_teleport_coop_end_canyon)

	(garbage_collect_now)

	;delete items no longer needed
	(object_destroy_folder ob_folder_elites1)
	(sleep 2)
	(object_destroy_folder ob_folder_floodelites1)
	(sleep 2)
	(object_destroy_folder ob_folder_floodhuman1)
	(sleep 2)
	(object_destroy_folder ob_folder_grunts1)
)

(script dormant jump_player0
    (sleep_until (volume_test_object jump_safe (player0)) 1)
    (object_cannot_take_damage (player0))
    (sleep_until (volume_test_objects jump_unsafe (player0)) 1)
	(sleep 15)
    (object_can_take_damage (player0))
	(sleep 5)
	(f_game_save)
	(print "save requested jump0")
)
(script dormant jump_player1
    (sleep_until (volume_test_object jump_safe (player1)) 1)
    (object_cannot_take_damage (player1))
    (sleep_until (volume_test_objects jump_unsafe (player1)) 1)
	(sleep 15)
    (object_can_take_damage (player1))
	(sleep 5)
	(f_game_save)
	(print "save requested jump1")
)
(script dormant jump_player2
    (sleep_until (volume_test_object jump_safe (player2)) 1)
    (object_cannot_take_damage (player2))
    (sleep_until (volume_test_objects jump_unsafe (player2)) 1)
	(sleep 15)
    (object_can_take_damage (player2))
	(sleep 5)
	(f_game_save)
	(print "save requested jump2")
)
(script dormant jump_player3
    (sleep_until (volume_test_object jump_safe (player3)) 1)
    (object_cannot_take_damage (player3))
    (sleep_until (volume_test_objects jump_unsafe (player3)) 1)
	(sleep 15)
    (object_can_take_damage (player3))
	(sleep 5)
	(f_game_save)
	(print "save requested jump3")
)



;=========================================================================
;===== canyon: intro to the canyon
;=========================================================================
(script dormant enc3_0
	(sleep_until (volume_test_players enc3_0) 1)
	(print_if debug "enc3_0")
	(wake vo_enc3_0)

	; clear previous encounters
	(ai_erase enc1_1_flood)
	(ai_erase enc1_2_flood)
	(ai_erase enc1_2_cov)
	(ai_erase enc1_3_flood)
	(ai_erase enc1_3_cov)
	(ai_erase enc1_4_flood)
	(ai_erase enc1_4_cov)
	(ai_erase enc1_5_flood)

	;start placing next encounters
	(ai_place enc3_0_flood)
	(sleep 45)
	(ai_place enc3_0_cov)
	(ai_prefer_target_team sq_enc3_0_flood_infection "covenant")
	; reinforcements
	(sleep_until (<= (ai_nonswarm_count enc3_0_flood) 2) 1)
	(ai_place enc3_0_combat_forms_melee)
	(ai_place enc3_0_combat_forms_shooters)

	; additional reins for hard and impossible
	(if
		(or
			(= "heroic" (game_difficulty_get)); "hard"
			(= "legendary" (game_difficulty_get)); "impossible"
		)
		(begin
			; reinforcements
			(sleep_until (<= (ai_nonswarm_count enc3_0_flood) 2) 1)
			(ai_place enc3_0_combat_forms_melee)
			(ai_place enc3_0_combat_forms_shooters)
			(ai_place sq_enc3_0_flood_infection)
		)
	)
)

;called in vo_enc3_0 script
(script dormant objective_exterior
	(f_objective_exterior)

	(sleep_until (volume_test_players enc3_8))
	(f_hud_obj_complete)

)

; skin diver
; (global boolean skin_diver false)
;(script dormant i_am_skin_diver
	;(print_if debug "i_am_skin_diver")
	; place, wait, and set
	; (ai_place med1_flood)
	; (object_set_permutation (list_get (ai_actors med1_flood) 0) "head" ~damaged)
	; (object_set_permutation (list_get (ai_actors med1_flood) 0) "left arm" ~damaged)
	; (object_set_permutation (list_get (ai_actors med1_flood) 1) "" ~damaged)
	; (object_set_permutation (list_get (ai_actors med1_flood) 2) "" ~damaged)
	; (object_set_permutation (list_get (ai_actors med1_flood) 2) "left arm" ~damaged)
	; (object_set_permutation (list_get (ai_actors med1_flood) 3) "" ~damaged)
	; (object_set_permutation (list_get (ai_actors med1_flood) 4) "right arm" ~damaged)
	; (object_set_permutation (list_get (ai_actors med1_flood) 4) "left arm" ~damaged)
	; (sleep_until (= 0 (ai_living_count med1_flood)))
	; (set skin_diver true)
;)

(script dormant enc3_1_vo
	(sleep_until (volume_test_players enc3_1c) 1)
	(wake vo_enc3_1)
)

(script dormant enc3_1_music
	(sleep_until (volume_test_players enc3_1) 1)
	(set s_music_trigger 50)
)

; script command to make the floods use just guns
;(script command_script flood_snipers1
	;(cs_set_style  floodcombat_base_no_melee)
	;(cs_enable_moving false)
;)

;=========================================================================
;===== canyon: flood snipers on the ledge
;=========================================================================
(script dormant enc3_2
	;_____ encounter trigger _____
	(sleep_until (volume_test_players enc3_2) 1)
	(print_if debug "enc3_2")

	;_____ checkpointing _____
	(wake checkpoint3_2)

	;_____ encounter setup _____

	; migrate covenant units from the last encounter.
	(ai_migrate enc3_0_cov sq_enc3_2_covenant_elites)

	; place the adversaries
	(ai_place enc3_2_flood_pool)
	(ai_place enc3_2_cov)
	(ai_place enc3_2_flood_snipers)

	; begin the spawner wave
	(wake enc3_2_spawner)

	; music
	(set s_music_trigger 70)

	;_____ combat begins _____
	(ai_prefer_target_team sq_enc3_2_flood_sniper "player")

	;wait for player to reach the far side of the combat
	(sleep_until (volume_test_players enc3_2b) 1)
	(ai_place sq_enc3_2_flood_suprise) ;lure player to next encounter

	; end the spawner
	(sleep_until (<= (ai_nonswarm_count enc3_2_flood_pool) 0) 1)
	(sleep_forever enc3_2_spawner)
)

;spawner will end if the all cov are dead, the player made it to the pass with the flood are dead, or limit is exhausted.
(script dormant enc3_2_spawner
	(print_if debug "enc3_2 | spawner enabled")
	(sleep_until
		(begin
			; check if there are covenant alive
			(if (< enc3_2_limiter (* 40 spawn_scale)) ; 40 -> 70
				; these conditions are met. spawn.
				(begin
					 ;check the combat form count. if it is too low, spawn (* min_combat_spawn 2)
					 (if (< (ai_living_count sq_enc3_2_flood_rein) (* min_combat_spawn 2))
					 	;spawn 'em and increment the count
						(begin
							(ai_place sq_enc3_2_flood_rein 1)
							(set enc3_2_limiter (+ enc3_2_limiter (ai_living_count sq_enc3_2_flood_rein)))
							(print_if debug "enc3_2 | combat form added")
						)
				 	)

					; check the carrier form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc3_2_flood_carriers) (* min_carrier_spawn 2))
						; spawn 'em and increment the count
						(begin
							(ai_place sq_enc3_2_flood_carriers 1)
							(set enc3_2_limiter (+ enc3_2_limiter (ai_living_count sq_enc3_2_flood_carriers)))
							(print_if debug "enc3_2 | carrier form added")
						)
					)

					; check the infection form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc3_2_flood_infectors) min_infection_spawn)
						; spawn 'em
						(begin
							(ai_place sq_enc3_2_flood_infectors)
							(print_if debug "enc3_2 | infection form added")
						)
					)
				)
			)
			; pause for a moment
			(sleep (game_ticks_from_seconds 1))

			;false
			;end if all the covenant are dead
			(<= (ai_nonswarm_count enc3_2_cov) 0)
		)
	1)
	(print_if debug "enc3_2 | spawner disabled")
)

(script dormant checkpoint3_2
	(f_save_at_trigger save3_2)
	(print "save requested 3_2")
)

;=========================================================================
;===== canyon: pustules, carriers, and infectors
;=========================================================================
(script dormant enc3_3
	(sleep_until (volume_test_players enc3_3) 1)
	(print_if debug "enc3_3")
	(wake checkpoint3_3)

	; kill previous spawner, encounters
	(sleep_forever enc3_2_spawner)

	; music
	(set s_music_trigger 80)

	; sleep till the trigger
	(sleep_until (volume_test_players enc3_3b) 1)

	; try to get rid of some earlier units
	(ai_disposable enc3_0_cov true)
	(ai_disposable enc3_0_flood true)

	; sleep 2 ticks to give time for the disposable units to be removed or
	; players hit the next volume
	(sleep_until (volume_test_players enc3_3c) 1 2)

	(ai_place sq_enc3_3_flood_carriersb)
	(ai_place sq_enc3_3_flood_infectorsb)

	(sleep_until (volume_test_players enc3_3c) 1)
	(ai_place sq_enc3_3_flood_carriersc)
	(ai_place sq_enc3_3_flood_infectorsc)
)

(script dormant checkpoint3_3
	(f_save_at_trigger save3_3)
	(print "save requested 3_3")
)

;=========================================================================
;===== canyon: kaiju fight
;=========================================================================
(script dormant enc3_4
	;_____encounter trigger_____
	(sleep_until (volume_test_players enc3_4) 1)
	(print_if debug "enc3_4")

	;_____checkpointing_____
	(wake checkpoint3_4)

	;_____encounter setup_____
	; music
	(set s_music_trigger 90)
	(wake vo_enc3_4)

	; place the covs, magical sight
	(ai_place enc3_4_cov)
	(ai_place enc3_4_flood_snipers)
	(ai_place enc3_4_flood_starters)
	(ai_magically_see enc3_4_flood enc3_4_cov)

	; start the spawner
	(wake enc3_4_spawner)

	; begin checking for cleaninup the previous encounters
	(wake enc3_4_clean_up)

	;_____combat begins_____
	(ai_prefer_target_ai enc3_4_flood_starters sq_enc3_4_covenant_hunters true) ; flood focus the hunters to progress the encounter

	; wait for the player to move up to the jackal sniper or waits a period of time and continues
	(sleep_until (volume_test_players enc3_4a) 1 (game_ticks_from_seconds 10))
	(ai_prefer_target_team enc3_4_flood_snipers "player") ; flood snipers focus the player
)

(script dormant checkpoint3_4
	(f_save_at_trigger save3_4)
	(print "save requested 3_4")
)

; spawn combat forms until the elites are down to 1 and spawn carriers until the player drops in.
(global boolean enc3_4_spawn_in_water true)
(script dormant enc3_4_spawner
	(print_if debug "enc3_4 | spawner enabled")

	(sleep_until
		(begin
			(if (< enc3_4_limiter (* 30 spawn_scale)) ; 30 -> 52
				(begin
					; check the combat form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc3_4_flood_combat_elite) min_combat_spawn)
						; spawn 'em and increment the count
						(begin
							(print_if debug "enc3_4 | combat form added")
							(ai_place sq_enc3_4_flood_combat_elite 1)
							(set enc3_4_limiter (+ enc3_4_limiter 1))
						)
					)
				)
			)

			; check to see if we need to disable the carrier spawns.
			(if (volume_test_players enc3_4b) (set enc3_4_spawn_in_water false))

			; if we're allowed, spawn carriers in the water
			(if enc3_4_spawn_in_water
				(if (< (ai_nonswarm_count sq_enc3_4_water_flood_carriers) min_carrier_spawn)
					; spawn 'em
					(ai_place sq_enc3_4_water_flood_carriers)
				)
			)

			; pause for a moment
			(sleep (game_ticks_from_seconds 1))

			; stop looping if the amount of elites has been whittled down to 1
			(<= (ai_nonswarm_count sq_enc3_4_covenant_elites) 1)
		)
	1)

	(print_if debug "enc3_4 | spawner disabled")
)

;cleaning up previous encounters to make room for what's next
(script dormant enc3_4_clean_up
	; sleep till the player drops down then also erase some squads
	(sleep_until (volume_test_players enc3_4b) 1)

	;clean up previous encounters
	(ai_erase enc3_3_flood)
	(ai_erase enc3_2_cov)
	(ai_erase enc3_2_flood)
	(ai_erase enc3_2_flood_pool)
	(ai_erase enc3_0_cov)
	(ai_erase enc3_0_flood)
)


;=========================================================================
;===== canyon: shade turret corner
;=========================================================================
(script dormant enc3_5
	(sleep_until (volume_test_players enc3_5) 1)
	(print_if debug "enc3_5")
	(wake checkpoint3_5)

	(ai_migrate sq_enc3_4_covenant_elites sq_enc3_5_covenant_elite)
	(ai_migrate sq_enc3_4_covenant_grunts sq_enc3_5_covenant_grunt)
	(ai_migrate sq_enc3_4_covenant_jackals sq_enc3_5_covenant_grunt)

	; place the covies
	(ai_place enc3_5_cov)
	(ai_place enc3_5_flood_snipers)
	;(cs_go_to_vehicle sq_enc3_5_gunner true enc3_5_turret)
	(ai_vehicle_enter_immediate sq_enc3_5_covenant_elite enc3_5_turret)

	; wake the spawner
	(wake enc3_5_spawner)
	(wake enc3_5_waves)

	(ai_magically_see enc3_5_cov sq_enc3_5_flood_ce)
	(ai_magically_see enc3_5_flood_snipers enc3_5_cov)

	(ai_prefer_target_ai enc3_5_cov enc3_5_flood_wave true)
	(ai_prefer_target_ai enc3_5_flood_snipers enc3_5_cov true)
	(ai_prefer_target_ai enc3_5_flood_wave sq_enc3_5_covenant_grunt true)

	; force activity
	; (ai_link_activation enc3_5_cov enc3_5_flood)
	; (ai_link_activation enc3_5_flood enc3_5_cov)
)

(script dormant enc3_5_spawner
	(print_if debug "enc3_5 | spawner enabled")
	(sleep_until
		(begin
			; check if there are covenant alive
			(if (< enc3_5_limiter (* 15 spawn_scale)) ; 15 -> 26

				; these conditions are met. spawn.
				(begin
					; check the combat form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc3_5_flood_ce) (* 2 min_combat_spawn))
						; spawn 'em and increment the count
						(begin
							; spawn a combat form (squad split in 2 for better objective control)
							(begin_random_count 1
								(ai_place sq_enc3_5_flood_melee 1)
								(ai_place sq_enc3_5_flood_shooter 1)
							)
							(set enc3_5_limiter (+ enc3_5_limiter 1))
							(print_if debug "enc3_5 | combat form added")
						)
					)

					; check the carrier form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc3_5_flood_car) min_carrier_spawn)
						; spawn 'em and increment the count
						(begin
							(ai_place sq_enc3_5_flood_car 1)
							(set enc3_5_limiter (+ enc3_5_limiter 1))
							(print_if debug "enc3_5 | carrier form added")
						)
					)
				)
			)

			; pause for a moment
			(sleep (game_ticks_from_seconds 1))
			false
		)
	1)
	(print_if debug "enc3_5 | spawner disabled")
)

(script dormant checkpoint3_5
	(f_save_at_trigger save3_5)
	(print "save requested 3_5")
)

; have the flood jump the players
(script dormant enc3_5_waves
	(sleep_until (volume_test_players enc3_5a) 1)
	(ai_place enc3_5_flood_wave)

	; second round!
	(sleep_until (volume_test_players enc3_5b) 1)
	(ai_place sq_enc3_5_ambush)

	; third round!
	(sleep_until (volume_test_players enc3_5c) 1)
	(ai_place sq_enc3_5_flood_infectors)
)

;=========================================================================
;===== canyon: jump scares
;=========================================================================
(script dormant enc3_6
	(sleep_until (volume_test_players enc3_6) 1)
	(print_if debug "enc3_6")
	(wake checkpoint3_6)

	; kill the previous spawner
	(sleep_forever enc3_5_spawner)
)

(script dormant checkpoint3_6
	(f_save_at_trigger save3_6)
	(print "save requested 3_6")
)

;=========================================================================
;===== canyon: rockets flood and the last stretch
;=========================================================================
(script dormant enc3_7
	(sleep_until (volume_test_players enc3_7) 1)
	(print_if debug "enc3_7")
	(wake checkpoint3_7)

	; clean ai
	(ai_disposable enc3_5_cov true)
	(ai_erase enc3_4_flood)
	(ai_erase enc3_4_cov)

	;put a tick between erasing and placing
	(sleep 1)
	; place the units
	(ai_place enc3_7_cov)
	(ai_place enc3_7_flood)
	(ai_kill sq_enc3_7_flood_sacrifices)
	(ai_kill sq_enc3_7_cov_sacrifices)

	; sleep until the trigger
	(sleep_until (volume_test_players enc3_7b) 1)

	; trigger second wave
	(ai_place enc3_7b_flood)
	(f_ai_magically_see_players enc3_7b_flood)
)

(script dormant checkpoint3_7
	(f_save_at_trigger save3_7)
	(print "save requested 3_7")
)

;=========================================================================
;===== canyon: the lift
;=========================================================================
(script dormant enc3_8
	;wait until the player enters the trigger for the 3_8 encounter
	(sleep_until (volume_test_players enc3_8) 1)
	(object_set_phantom_power d20_grav_lift_a false)
	(print_if debug "enc3_8")
	(wake checkpoint3_8)

	;prep lift
	(device_set_position_immediate dm_vignette_gravity_lift_up 0)

	;clean up previous encounters
	(ai_erase enc3_5_flood)
	(ai_erase enc3_5_cov)

	;play cortana dialog
	(wake vo_enc3_8)

	;place covenant
	(ai_place enc3_8_cov)

	; begin waiting for chances to renew the covenant and keep them healthy for the player to see them and for the fight ahead.
	(wake enc3_8_renew_covenant)

	;place flood
	(ai_place sq_enc3_8_flood_c_init)
	(ai_place sq_enc3_8_flood_left_m_init)
	(ai_place sq_enc3_8_flood_left_s_init)
	(ai_place sq_enc3_8_flood_right_s_init)

	;spawn co-op(3-4) content
	(if (> (game_coop_player_count) 2)
		(object_create blamequipment_overshield_2_coop)
	)

	(sleep (game_ticks_from_seconds .1))
	(ai_prefer_target_team enc3_8_cov "flood")
	(ai_prefer_target_team enc3_8_flood "covenant")

	(ai_magically_see enc3_8_cov enc3_8_flood)
	(ai_magically_see enc3_8_flood enc3_8_cov)

	;begin flood waves
	(wake enc3_8_spawner)

	;encounter plays out until the player advances to the midway to the lift on the ramp.

	;wait until the player hits the trigger, then drop a final wave.
	(sleep_until (volume_test_players enc3_8b) 1)
	(ai_place enc3_8_flood_final)

	;on higher difficulties make it harder
	(if (= "legendary" (game_difficulty_get))
		(begin
			(print_if debug "legendary difficulty modifier enabled")
			(ai_prefer_target (players) true)
		)
	)

	(f_enc3_8_block_on_bloodgate) ; block until lift is clear

	;swap lift direction to going up and wait for position
	(device_set_position_immediate dm_vignette_gravity_lift_up 1)
	(sleep_until (= (device_get_position dm_vignette_gravity_lift_up) 1) 1)

	;enable lift manager
	(wake enc3_8_lift_manager)

	;start music
	(set s_music_trigger 110)

	; sleep until the time is ripe to lift the player
	(sleep_until (>= lift_counter 10) 1)

	;going up
	(print_if debug "gravity lift activated!")
	(object_create d20_grav_lift_a)
	(object_set_phantom_power d20_grav_lift_a true)

	;turn off lift manager
	(sleep_forever enc3_8_lift_manager)
)

; we need to keep the covenant looking healthier until the player can get to the lift.
(script dormant enc3_8_renew_covenant
	(ai_cannot_die enc3_8_cov true) ; ensure they cannot die until the player can see them

	; wait till the player enters the encounter space and make the covenant mortal and renew them
	(sleep_until (volume_test_players enc3_8a) 1)
	(ai_renew enc3_8_cov)
	(ai_cannot_die enc3_8_cov false)

	; wwait until the player pushes in a little before renewing the covenant
	(sleep_until (volume_test_players grav_lift) 1)
	(ai_renew enc3_8_cov)

	; give the covenant another health boost as the player rounds the upper corner on the ramp
	(sleep_until (volume_test_players enc3_8b) 1)
	(ai_renew enc3_8_cov)

	; give the covenant a final boost as the player reaches the lift
	(sleep_until (volume_test_players enc3_8c) 1)
	(ai_renew enc3_8_cov)
)

(global short s_gate_total 0)

(script static void f_enc3_8_block_on_bloodgate
	(print "enc3_8 bloodgate running *********************************")
	; (debug_scripting_variable 's_gate_total' 1)
	(set s_gate_total 1)
	(sleep_until
		(begin
			(f_blip_unblip_bloodgate enc3_8c_def enc3_8_cov)
			(print "s_gate_total =")
			; (inspect s_gate_total)

			;(<= s_gate_total 0) ; <- time check could happen here as well
			(not (volume_test_objects enc3_8c_def (ai_actors enc3_8_cov))) ; sleep exit condition
		)
		(game_ticks_from_seconds 1) ; sleep interval
	)
	; (breakpoint "cleared cleared")
	(f_unblip_ai enc3_8_cov)
	(print "enc3_8 bloodgate cleared ************************************")
)

(global object_list l_gate_objs (volume_return_objects_by_type enc3_8c 1))
(global short s_gate_objs_size 0)
(global short s_gate_i 0)
(global short s_living_count 0)

(script static void (f_blip_unblip_bloodgate (trigger_volume in_tv) (ai in_ai))
	; (debug_scripting_variable 's_gate_objs_size' 1)
	; (debug_scripting_variable 's_gate_i' 1)
	; (debug_scripting_variable 's_living_count' 1)
	(set s_gate_total 0)
	(set l_gate_objs (ai_actors in_ai))
	(set s_gate_objs_size (list_count l_gate_objs))
	(set s_living_count (ai_living_count in_ai))
	(set s_gate_i 0)
	(sleep_until
		(begin
			(if (and
					(> (object_get_health (list_get l_gate_objs s_gate_i)) 0)
					(volume_test_object in_tv (list_get l_gate_objs s_gate_i))
				)
				(begin ; then
					(f_blip_object (list_get l_gate_objs s_gate_i) 1)
					(set s_gate_total (+ s_gate_total 1))
				)
				(f_unblip_object (list_get l_gate_objs s_gate_i)) ; else
			)
			(set s_gate_i (+ s_gate_i 1))

			(>= s_gate_i (list_count l_gate_objs)) ; exit
		)
		1 ; sleep interval
	)
)


(script dormant checkpoint3_8
	(f_save_at_trigger save3_8)
	(print "save requested 3_8")
)

;called in vo_enc3_8
(script dormant objective_lift
	(f_objective_lift)
)

(script dormant enc3_9
	(sleep_until (volume_test_objects_all grav_lift (players)) 1)
	(print_if debug "enc3_9")

	; clean up
	(ai_erase enc3_7_flood)
	(ai_erase enc3_7_cov)
	(ai_erase enc3_7b_flood)

	(garbage_collect_now)
)

(script dormant enc3_8_spawner
	(print_if debug "enc3_8 | spawner enabled")
	(sleep_until
		(begin
			; check if there are covenant alive
			(if
				(and
					(> (ai_nonswarm_count enc3_8_cov) 0)
					(< enc3_8_limiter (* 40 spawn_scale)) ; 40 -> 70
				)

				; these conditions are met. spawn.
				(begin
					; check the combat form count. if it is too low, spawn

					(if (< (+ (ai_living_count sq_enc3_8_flood_right_s_wave) (ai_living_count sq_enc3_8_flood_left_m_wave)) (* 2 min_combat_spawn))
						(begin_random_count 1
							(begin
								(print_if debug "enc3_8 | combat form (shooter) added")
								(ai_place sq_enc3_8_flood_right_s_wave 1)
								(set enc3_8_limiter (+ enc3_8_limiter 1))
							)
							(begin
								(print_if debug "enc3_8 | combat form (melee) added")
								(ai_place sq_enc3_8_flood_left_m_wave 1)
								(set enc3_8_limiter (+ enc3_8_limiter 1))
							)
						)
					)

					; check the carrier form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc3_8_flood_c_wave) (* 1.5 min_carrier_spawn))
						; spawn 'em and increment the count
						(begin
							(print_if debug "enc3_8 | carrier form added")
							(ai_place sq_enc3_8_flood_c_wave 1)
							(set enc3_8_limiter (+ enc3_8_limiter 1))
						)
					)
					(ai_magically_see enc3_8_cov enc3_8_flood)
					(ai_magically_see enc3_8_flood enc3_8_cov)
				)
			)

			; pause for a moment
			(sleep (game_ticks_from_seconds .5))

			;exit condition
			(volume_test_players enc3_8b)
		)
	1)

	(print_if debug "enc3_8 | spawner disabled")
)

(global short lift_counter 0)
(script dormant enc3_8_lift_manager
	(sleep_until
		(begin
			(if (volume_test_players enc3_8c)
				(begin
					(if (= lift_counter 0)
						(device_set_position_immediate dm_vignette_gravity_lift_up .4);true
						(device_set_position_immediate dm_vignette_gravity_lift_up 0.2);false
					)
					(if (= lift_counter 5)
						(device_set_position_immediate dm_vignette_gravity_lift_up .7);true
					)
					(set lift_counter (+ 1 lift_counter))
				)
				(set lift_counter 0))

			;1 second pause
			(sleep (game_ticks_from_seconds 1))

			;exit condition
			false
		)
	1)
)

;======================================================================================================================================================================================================
;===== section 4 ======================================================================================================================================================================================
;===== player arrives back in the ship after taking the grav lift and must fight their way to keyes ===================================================================================================
;======================================================================================================================================================================================================

(script dormant section4
	; unlock progress data
	(submit_incident "ins_d20_section4")
	(submit_incident "unlock_d20")
	(submit_incident_with_custom_string_id "game_activity_begin" "d20")

	(sleep_until (volume_test_players section4) 1)
	(print_if debug "section4")

	(wake section4_point_of_no_return_lift)
	(wake section4_point_of_no_return_muster)

	(wake skull_blind_manager)

	(wake objective_gobay)

	(sleep_forever enc3_8_spawner)

	;set respawn profile
	(player_set_profile respawnprofile_interior)

	; (deactivate_team_nav_point_flag player waypoint2)
	(wake checkpoint4)

	;(sleep_forever i_am_skin_diver)

	; kill lots of remaining units
	; (ai_erase med1_flood)
	(ai_erase enc3_0_cov)
	(ai_erase enc3_0_flood)

	(ai_erase enc3_2_flood)
	(ai_erase enc3_2_cov)

	(ai_erase enc3_3_flood)

	(ai_erase enc3_4_flood)
	(ai_erase enc3_4_cov)

	(ai_erase enc3_5_cov)
	(ai_erase enc3_5_flood)

	(ai_erase enc3_7_flood)
	(ai_erase enc3_7_cov)
	(ai_erase enc3_7b_flood)

	; it is possible for some indivduals to ride the grav lift
	(ai_disposable enc3_8_cov 1)
	(ai_disposable enc3_8_flood 1)

	; take those items out of the shop
	(object_destroy_folder ob_folder_equipment1)
	(object_destroy_folder ob_folder_elites1)
	(object_destroy_folder ob_folder_floodelites1)
	(object_destroy_folder ob_folder_floodhuman1)
	(object_destroy_folder ob_folder_grunts1)
	(object_destroy_folder ob_folder_turrets)

	; place "ambient" units if you didn't arrive via the insertion point
	(if (not (f_insertion_point_matches insertion_section4)) (ai_place enc4_0))

	; blinds and deafens units to not initially react to chief entering the lift
	(ai_set_blind enc4_0 true)
	(ai_set_deaf enc4_0 true)

	; wake enc
	(wake enc4_1)
	(wake enc4_2)
	(wake enc4_3)
	(wake enc4_4)
	(wake enc4_5)
	(wake enc4_6)
	(wake enc4_7)
	(wake enc4_8)
	(wake enc4_9)

	; put the lid on it after players have entered
	(sleep_until
		(or
			(volume_test_players tv_teleport_coop_lift)
			(f_insertion_point_script_is_blocked insertion_section4)
		)
	1)
	(object_create grav_hullcap)
	(object_set_phantom_power d20_grav_lift_a false)

	; the amount of time before the ambient ai in the room can visually react to chief.
	(sleep (game_ticks_from_seconds 5) )
	(ai_set_blind enc4_0 false)
	(ai_set_deaf enc4_0 false)

	(wake section4_cleanup)
)

(script dormant create_enc4_items
	(print "creating section 4 items")
	(object_create_folder ob_folder_grunts3)
	(sleep 2)
	(object_create_folder ob_folder_floodhuman2)
	(sleep 2)
	(object_create_folder ob_folder_floodelites2)
	(sleep 2)
	(object_create_folder ob_folder_grunts2)
	(sleep 2)
	;(object_create_folder ob_folder_oldplayback)
	(sleep 2)
	(object_create_folder ob_folder_equipment2)
	(sleep 2)
	(object_create_folder ob_folder_elites2)
)

(script dormant checkpoint4
	(f_save_at_trigger save4)
	(print "save requested sec4")
)

(script dormant objective_gobay
	(sleep_until (script_finished "vo_enc4_2") 1)
	(f_objective_go_to_bay_no_completion)
)

(script dormant section4_point_of_no_return_lift
	;no return entering the second to last canyon segment
	(print_if debug "point of no return | players pulled to top of grav lift")
	(sleep_until (volume_test_players tv_teleport_coop_lift) 1)
	(volume_teleport_players_not_inside tv_teleport_coop_lift_check fl_teleport_coop_lift)
	(garbage_collect_now)
)

(script dormant section4_point_of_no_return_muster
	;no return entering the second to last canyon segment
	(print_if debug "point of no return | players pulled to hall after muster")
	(sleep_until (volume_test_players tv_teleport_coop_muster) 1)
	(volume_teleport_players_not_inside tv_teleport_coop_muster_check fl_teleport_coop_muster)
	(garbage_collect_now)
)

(script dormant enc4_1
	(print_if debug "enc4_1")

	; run dialogue
	(wake vo_enc4_1)
	(chapter_d20_2)
	(wake objective_muster)
)

(script static void chapter_d20_2
	(print "chapter title 2 - upstairs, downstairs") ;cinematic will have title card
	;(f_hud_chapter "chapter_d20_1")
)

(script dormant objective_muster
	(f_objective_go_to_bridge)
)


(script dormant checkpoint4_2
	(f_save_at_trigger save4_2)
	(print "save requested 4_2")
)

(script dormant enc4_2
	(sleep_until (volume_test_players enc4_2) 1)
	(print_if debug "enc4_2")
	(wake checkpoint4_2)
	(wake vo_enc4_2)

	; place the first set of carriers
	(ai_place enc4_2_flood)

	; wait for the next trigger
	(sleep_until (volume_test_players enc4_2b) 1)
	(object_create 2_6_elite) ; a body that drop as the player enters the hall, previously on the ground. this is meant to bring awareness to the drop spawner.
	(sleep 1)
	(biped_ragdoll 2_6_elite)

	; trigger the spawn wave
	(wake enc4_2_spawner)
)

(script dormant enc4_2_spawner
	(print_if debug "enc4_2 | spawner enabled")
	(sleep_until
		(begin
			; check the limiter
			(if
				(and
					(< enc4_2_limiter (* 5 spawn_scale)) ; 5 -> 8
					(volume_test_players enc4_2b)
				)

				; these conditions are met. spawn.
				(begin
					; check the carrier form count. if it is too low, spawn
					(if (< (ai_nonswarm_count enc4_2_flood_reinf) min_carrier_spawn)
						; spawn 'em and increment the count
						(begin
							(print "enc4_2 | spawning carrier reinforcements")
							; check to see if a player is looking at the forward flag
							; if he is, spawn behind him. else, spawn in front of him
							; this could result in carriers spawning in front of the player,
							;  if in co-op, if one player is looking forward and others are looking away
							;  but i don't have a clean solution. this is how legacy did it.
							(if (objects_can_see_flag (players) enc4_2_forward 30)
								(ai_place sq_enc4_2_rear_flood_carriers 1)
								(ai_place sq_enc4_2_front_flood_carriers 1)
							)

							; increment counter
							(set enc4_2_limiter (+ enc4_2_limiter 1))
						)
					)
				)
			)

			; simple inf form spawnage
			(if (< (ai_living_count sq_enc4_2_flood_infectors) min_infection_spawn)
				(begin
					(ai_place sq_enc4_2_flood_infectors)
					(print_if debug "enc4_2 | infection form added")
				)
			)

			; pause for a moment
			(sleep (game_ticks_from_seconds 7))

			;exit condition = disabled when the player enters enc4_3
			false
		)
	1)
	(print_if debug "enc4_2 | spawner disabled")
)

;=========================================================================
;===== muster bay: upper and lower bay
;=========================================================================
(script dormant checkpoint4_3
	(f_save_at_trigger save4_3)
	(print "save requested 4_3")
)


(script dormant enc4_3
	(sleep_until (volume_test_players enc4_3) 1)
	(print_if debug "enc4_3")
	(wake checkpoint4_3)
	(wake vo_enc4_3)

	; place the first set
	(ai_place enc4_3_flood1)
	(ai_place enc4_3_flood2)
	(set s_music_trigger 120)

	(if (> (game_coop_player_count) 2)
		(object_create blamequipment_overshield_1_coop)
	)


	; kill the last spawn wave
	(sleep_forever enc4_2_spawner)
	(print_if debug "enc4_2 | spawner disabled")

	;(sleep_until (volume_test_players enc4_3b) 1) - adds nothing here and can be sidestepped to break door on the hanger floor

	; sleep until a) flood are damaged, b) trigger volumes are tripped
	(sleep_until (volume_test_players enc4_3c) 1)

	; sleep until the flood are mostly gone... then wait for the player...
	;(sleep_until (<= (ai_nonswarm_count enc4_3_flood) 2))

	(ai_place enc4_3_flood_wave)
	(sleep 5)
	(device_group_set_immediate enc4_3_door 1)
)

;=========================================================================
;===== muster bay: upper and lower connector hall
;=========================================================================
(script dormant checkpoint4_4
	(f_save_at_trigger save4_4)
	(print "save requested 4_4")
)

(script dormant enc4_4
	(sleep_until (volume_test_players enc4_4) 1)
	(print_if debug "enc4_4")
	(wake checkpoint4_4)

	; start the wave
	(wake enc4_4_spawner)

	(wake vo_keyes_pained_enc4_4)

	(sleep_until (volume_test_players enc4_3c) 1)

	; terminate enc4_4's spawner if it's running
	(sleep_forever enc4_4_spawner)
	(print_if debug "enc4_4 | spawner disabled")

)

(script dormant enc4_4_spawner
	(print_if debug "enc4_4 | spawner enabled")
	(sleep_until
		(begin
			; check if the time is right
			(if
				(and
					(volume_test_players enc4_4)
					(< enc4_4_limiter (* 25 spawn_scale)) ; 25 -> 43
				)

				; these conditions are met. spawn.
				(begin
					; check the combat form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc4_4_fel) min_combat_spawn)
						; spawn 'em and increment the count
						(begin
							(ai_place sq_enc4_4_fel 1)
							(set enc4_4_limiter (+ enc4_4_limiter 1))
							(print_if debug "enc4_4 | cobmat form added")
						)
					)

					; check the carrier form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc4_4_fcar) min_carrier_spawn)
						; spawn 'em and increment the count
						(begin
							(ai_place sq_enc4_4_fcar 1)
							(set enc4_4_limiter (+ enc4_4_limiter 1))
							(print_if debug "enc4_4 | carrier form added")
						)
					)

					; check the infection form count. if it is too low, spawn
					(if (< (ai_living_count sq_enc4_4_flood_infectors) min_infection_spawn)
						; spawn 'em and increment the count
						(begin
							(ai_place sq_enc4_4_flood_infectors)
							(set enc4_4_limiter (+ enc4_4_limiter 1))
							(print_if debug "enc4_4 | infection form added")
						)
					)
				)
			)

			; pause for a moment
			(sleep (game_ticks_from_seconds 1))

			;exit condition - turns off when the player drops to the bottom floor
			false
		)
	1)
)

;=========================================================================
;===== muster bay: lower exit hallway
;=========================================================================
(script dormant checkpoint4_5
	(f_save_at_trigger save4_5)
	(print "save requested 4_5")
)

(script dormant enc4_5
	(sleep_until (volume_test_players enc4_5) 1)
	(print_if debug "enc4_5")
	(wake checkpoint4_5)
	(set s_music_trigger 130)

	; place the first set
	(ai_place enc4_5_flood)
	(sleep 5)

	; sleep until the first wave is dead
	(sleep_until
		(and
			(<= (ai_nonswarm_count enc4_5_flood) 2)
			(not (volume_test_players enc4_5b))
		)
	1)
	(ai_place enc4_5_flood_wave)
)

;=========================================================================
;===== ship dropdown: carrier surprise
;=========================================================================
(script dormant checkpoint4_6
	(f_save_at_trigger save4_6)
	(print "save requested 4_6")
)

(script dormant enc4_6
	(sleep_until (volume_test_players enc4_6) 1)
	(print_if debug "enc4_6")
	(wake checkpoint4_6)

	; place the first set of carriers
	(ai_place enc4_6_flood)
)

;=========================================================================
;===== canteen: lunchroom fight
;=========================================================================
(script dormant checkpoint4_7
	(f_save_at_trigger save4_7)
	(print "save requested 4_7")
)

(script dormant enc4_7
	(sleep_until (volume_test_players enc4_7) 1)
	(print_if debug "enc4_7")
	(wake checkpoint4_7)
	(wake vo_keyes_pained_enc4_7)

	; cleanup
	(object_destroy_folder ob_folder_floodhuman2)
	(object_destroy_folder ob_folder_floodelites2)
	(object_destroy_folder ob_folder_grunts2)
	(object_destroy_folder ob_folder_grunts3)
	;(object_destroy_folder ob_folder_oldplayback)
	(object_destroy_folder ob_folder_equipment2)
	(object_destroy_folder ob_folder_elites2)
	(sleep_forever enc4_4_spawner)

	; place the flood
	(ai_place enc4_7_flood)

	; place the covies
	(ai_place enc4_7_cov)
	; (ai_link_activation enc4_7_cov enc4_7_flood)

	(ai_prefer_target_ai enc4_7_flood enc4_7_cov true)

	; sleep until the combat forms are dead, then advance the covs
	(sleep_until (<= (ai_living_count sq_enc4_7_flood_combat_elites) 0) 1)
	; (ai_maneuver enc4_7_cov)
)

;=========================================================================
;===== canteen: post canteen fight
;=========================================================================
(script dormant checkpoint4_8
	(f_save_at_trigger save4_8)
	(print "save requested 4_8")
)

(script dormant enc4_8
	(sleep_until (volume_test_players enc4_8) 1)
	(print_if debug "enc4_8")
	(wake checkpoint4_8)

	; place the first set of carriers, wake the spawner
	(ai_place enc4_8_flood)

	; sleep, wait for the door
	(sleep_until (volume_test_players enc4_8_spawner) 1)
	; (device_set_position_immediate enc4_8_door 1)
	(wake enc4_8_manager)

	; sleep until the trigger, then kill it
	(sleep_until (volume_test_players section5) 1)
	(sleep_forever enc4_8_manager)
	(print_if debug "enc4_8 | spawner disabled")
)

(script dormant enc4_8_manager
	(print_if debug "enc4_8 | spawner enabled")
	(sleep_until
		(begin
			; sleep until it's safe to spawn
			(sleep_until
				(and
					(volume_test_players enc4_8_spawner)
					(<= enc4_8_limiter (* 6 spawn_scale)) ; 6 -> 10
				)
			1)

			; spawn if necessary
			(if (and
					(<= (ai_nonswarm_count sq_enc4_8_flood_combat_elite) min_combat_spawn)
					(not (volume_test_players enc4_8_spawner_safety)) ;added to ensure players cannot see this squad spawn
				)
				(begin
					(ai_place sq_enc4_8_flood_combat_elite)
					(set enc4_8_limiter (+ enc4_8_limiter 1))
					(print_if debug "enc4_8 | cobmat form (door) added")
				)
			)
			(if (<= (ai_nonswarm_count sq_enc4_8_upper_flood_combat) min_combat_spawn)
				(begin
					(ai_place sq_enc4_8_upper_flood_combat)
					(set enc4_8_limiter (+ enc4_8_limiter 1))
					(print_if debug "enc4_8 | cobmat form (drop in) added")
				)
			)

			;pause for a second
			(sleep (game_ticks_from_seconds .5))

			;exit condition - turns off when the player makes it to section 5
			false
		)
	1)
)

(script dormant checkpoint4_9
	(f_save_at_trigger save4_9)
	(print "save requested 4_9")
)

(script dormant enc4_9
	(sleep_until (volume_test_players enc4_9) 1)
	(print_if debug "enc4_9")
	(wake checkpoint4_9)

	; place the cov
	(ai_place enc4_9_cov)

	; sleep until the trigger, toss!
	; (sleep_until (volume_test_players enc4_9b) 1)
	; (ai_command_list enc4_9_cov/grunts enc4_9_grenade_toss)
)

(script dormant checkpoint5
	(f_save_at_trigger save5)
	(print "save requested sec5")
)

(script dormant section4_cleanup
	(sleep_until
		(or
			(volume_test_players enc5_2)
			(volume_test_players enc5_2b)
			(volume_test_players enc5_4)
		)
	1 )

	(ai_erase enc4_0)
	(ai_erase enc4_2_flood)
	(ai_erase enc4_3_flood1)
	(ai_erase enc4_3_flood2)
	(ai_erase enc4_4_flood)
	(ai_erase enc4_5_flood)
	(ai_erase enc4_6_flood)
	(ai_disposable enc4_7_cov true)
	(ai_disposable enc4_7_flood true)
	(ai_disposable enc4_8_flood true)
	(ai_disposable enc4_9_cov true)

)

;======================================================================================================================================================================================================
;===== section 5 ======================================================================================================================================================================================
;===== player arrives in the hangar and needs to fight up to level 3 ==================================================================================================================================
;======================================================================================================================================================================================================

(script dormant section5
	; unlock progress data
	(submit_incident "ins_d20_section5")
	(submit_incident "unlock_d20")
	(submit_incident_with_custom_string_id "game_activity_begin" "d20")

	; sleepy
	;(sleep_forever enc5_7_manager)

	; sleep until the trigger
	(sleep_until (volume_test_players section5) 1)
	(print_if debug "section5")
	(wake checkpoint5)

	;set objective
	(wake objective_ascend_hangar)
	(wake objective_ascend_loop)
	(wake objective_control_2)

	; wake encs
	(wake enc5_1)
	(wake enc5_2)
	(wake enc5_3)
	(wake enc5_4)
	(wake enc5_5)
	(wake enc5_6)
	(wake enc5_7)

	; vo
	(wake vo_keyes_pained_enc5)

	(sleep_until (volume_test_players tv_navend_keyes_room_exit) 1) ;shut down nav loop once the player makes it to keyes's hallway
	(sleep_forever objective_ascend_loop)
)

;objective for hangar level 3
(script dormant objective_ascend_hangar
	;once the player arrives in the hangar bay on level 2 tell them to get to the third deck.
	(sleep_until (volume_test_players enc5_1) 1)
	(f_objective_go_to_upper)
)

(script dormant objective_control_2
	(sleep_until (volume_test_players tv_nav_shuttle_3rd_floor) 1)
	(f_objective_go_to_bridge)
)

(global short s_hangar_level 2) ; variable to track what floor the player is on defaults to 2 since that's what they came in on.

;if the player falls in solo gameplay we want to ditch our simple objectives and give them more specific ones to help them reach the top floor.
(script dormant objective_ascend_loop
	(if (game_is_cooperative) (sleep_forever)); keep objectives linear in coop

	;begins detailed objectives if the player falls to the bottom floor
	(sleep_until (volume_test_players tv_nav_shuttle_1st_floor) 1)

	;turn off simple objectives if the player falls
	(sleep_forever objective_ascend_hangar)
	(sleep_forever objective_control_2)

	;loop locking in a specific objective until the player reaches any floors above or below their current one.
	;loop completes when the player enters the hall outside of the control room.
	(sleep_until
		(begin
			(cond
				;set objective for floor 3 until the player falls to floor 1, 2, or progresses to the end condition
				((volume_test_players tv_nav_shuttle_3rd_floor) (objecitve_hangar_3_loop) (sleep_until (or (volume_test_players tv_nav_shuttle_1st_floor) (volume_test_players tv_nav_shuttle_2nd_floor) (volume_test_players tv_navend_keyes_room_exit)) 1))
				;set objective for floor 2 until the player falls to floor 1 or progresses 3 or to the end condition
				((volume_test_players tv_nav_shuttle_2nd_floor) (objecitve_hangar_2_loop) (sleep_until (or (volume_test_players tv_nav_shuttle_1st_floor) (volume_test_players tv_nav_shuttle_3rd_floor) (volume_test_players tv_navend_keyes_room_exit)) 1))
				;set objective for floor 1 until the player progresses to floor 2, 3 or to the end condition
				((volume_test_players tv_nav_shuttle_1st_floor) (objecitve_hangar_1_loop) (sleep_until (or (volume_test_players tv_nav_shuttle_2nd_floor) (volume_test_players tv_nav_shuttle_3rd_floor) (volume_test_players tv_navend_keyes_room_exit)) 1))
			)
			(volume_test_players tv_navend_keyes_room_exit) ;exit condition
		)
		1 ;run every tick
	)
)

(script static void objecitve_hangar_1_loop
	(f_objective_ascend)	;set objective
	(set s_hangar_level 1)	;update current floor
)

(script static void objecitve_hangar_2_loop
	(if (= s_hangar_level 1)(f_objective_ascend_continue)(f_objective_go_to_uppper_no_completion)) ;set contextual objective based on previous floor

	(set s_hangar_level 2) ;update current floor
)

(script static void objecitve_hangar_3_loop
	(f_objective_go_to_bridge_no_completion) ;set objective
	(set s_hangar_level 3)	;update current floor
)

;=========================================================================
;===== hangar: initial entry encounter
;=========================================================================
(script dormant enc5_1
	(print_if debug "enc5_1")

	; place the initial ai
	(ai_place sq_enc5_1_init_covenant_elite)

	(ai_place sq_enc5_1_flood_infectors)
	(ai_place sq_enc5_1_floor_2_flood)
	(ai_place sq_enc5_1_upper_flood_combat)

	; tell the covenant to focus on the flood and vice versa
	(wake enc5_1_cov_targeting)

	; start up the 5_1 manager script
	(wake enc5_1_manager)

	; sleep until the player is inside the hangar
	(sleep_until (volume_test_players enc5_1) 1)
	(wake vo_enc5_1)

	; place our lower floor units
	(ai_place sq_enc5_1_floor_covenant_grunts)
	(ai_place sq_enc5_1_floor_1_def_flood)

	; pull our previous squads into
	(ai_migrate enc4_7_flood sq_enc5_1_floor_2_flood)
	(ai_migrate enc4_8_flood sq_enc5_1_floor_2_flood)

	; wait until the player pushes up or time expires and restock the flood 3 flood attack the center
	(sleep_until (volume_test_players enc5_1_spawner_safety) 1 (game_ticks_from_seconds 30))
	(ai_place sq_enc5_1_floor_2_flood)

	(sleep_until
		(or
			(volume_test_players enc5_5) ; player progressed far enough normally
			(volume_test_players enc5_7) ; player skipped to the upper level and tried to walk into the spawn
			(volume_test_players enc5_4)
		)
	1 )

	(ai_disposable sq_enc5_1_floor_covenant_grunts true)
	(ai_disposable sq_enc5_1_floor_1_def_flood true)
	(ai_disposable sq_enc5_1_flood_infectors true)

	(sleep_until
		(or
			(volume_test_players enc5_7) ; player skipped to the upper level and tried to walk into the spawn
			(volume_test_players enc5_5) ; player progressed far enough normally
			(volume_test_players enc5_6)
		)
	1 )

	(ai_disposable sq_enc5_1_gunner_covenant_grunt true)
	(ai_disposable sq_enc5_3_covenant_grunt true)

	; sleep until the player is far enough to end the spawner
	(sleep_until
		(or
			(volume_test_players enc5_5) ; player progressed far enough normally
			(volume_test_players enc5_7) ; player skipped to the upper level and tried to walk into the spawn
		)
	1 )
	(sleep_forever enc5_1_manager)
	(print_if debug "enc5_1 | spawner disabled")

	(sleep_until (volume_test_players enc6_1) 1)
	(ai_disposable enc5_1_cov true)
	(ai_disposable enc5_1_flood true)
)

(script dormant enc5_1_cov_targeting
	(ai_prefer_target_ai enc5_1_cov enc5_1_flood true)
	(ai_prefer_target_ai enc5_1_flood enc5_1_cov true)

	(sleep_until (volume_test_players enc5_1_spawner_safety) 1)

	(ai_prefer_target_ai enc5_1_cov enc5_1_flood false)
	(ai_prefer_target_ai enc5_1_flood enc5_1_cov false)
)

(script dormant enc5_1_manager
	(print_if debug "enc5_1 | spawner enabled")
	(sleep_until
		(begin
			; sleep until the player is inside the volume
			; this volume is called enc7_6, but it seems to be the correct volume to use
			(sleep_until
				(and
					(<= enc5_1_limiter (* 10 spawn_scale)) ;10 -> 17
					(volume_test_players enc7_6)
				)
			1)

			; spawn actors if the flood counts are short
			(if (<= (ai_living_count sq_enc5_1_upper_flood_combat) min_combat_spawn)
				(begin
					(ai_place sq_enc5_1_upper_flood_combat 1)
					(set enc5_1_limiter (+ enc5_1_limiter 1))
					(print_if debug "enc5_1 | cobmat form (upper) added")
				)
			)

			; spawn covies if necessary
			(if (not (volume_test_players enc5_1_spawner_safety)) ; added to ensure co-op can't see squad spawn and to allow the player to push easier to the turret
				(begin
					(if (<= (ai_nonswarm_count sq_enc5_1_gunner_covenant_elite) 1)
						(begin
							(ai_place sq_enc5_1_gunner_covenant_elite 1)
							(set enc5_1_limiter (+ enc5_1_limiter 1))
							(print_if debug "enc5_1 | elite gunner added")
						)
					)
					(if (<= (ai_nonswarm_count sq_enc5_1_gunner_covenant_grunt) 1)
						(begin
							(ai_place sq_enc5_1_gunner_covenant_grunt 1)
							(set enc5_1_limiter (+ enc5_1_limiter 1))
							(print_if debug "enc5_1 | grunt gunner added")
						)
					)
				)
			)

			; pause
			(sleep (game_ticks_from_seconds 1))

			;exit condition - player moves to the enc5_5 volume
			false
		)
	1)
)

(script dormant checkpoint5_2
	(f_save_at_2_triggers save5_2 save5_2b)
	(print "save requested 5_2")
)

(script dormant enc5_2
	(sleep_until
		(or
			(volume_test_players enc5_2)
			(volume_test_players enc5_2b)
		)
	1)

	; begin looking at cleaning up our floor covenant units.
	(ai_disposable sq_enc5_1_floor_covenant_grunts true)

	(print_if debug "enc5_2")
	(wake checkpoint5_2)

	; kill the spawner
	(sleep_forever enc5_1_manager)

	; place the ai
	(ai_place enc5_2_cov)

	(if (= (game_difficulty_get) legendary)
		(begin_random_count 3
			(ai_place sq_enc5_2_flood_cb 2)
			(ai_place sq_enc5_2_flood_cb2 2)
			(ai_place sq_enc5_2_flood_cb3 2)
			(ai_place sq_enc5_2_flood_cb4 2)
		)
		(begin_random_count 2
			(ai_place sq_enc5_2_flood_cb 2)
			(ai_place sq_enc5_2_flood_cb2 2)
			(ai_place sq_enc5_2_flood_cb3 2)
			(ai_place sq_enc5_2_flood_cb4 2)
		)
	)

	(if (> (game_coop_player_count) 2)
		(begin_random_count 1
			(ai_place sq_enc5_2_flood_cb 2)
			(ai_place sq_enc5_2_flood_cb2 2)
			(ai_place sq_enc5_2_flood_cb3 2)
			(ai_place sq_enc5_2_flood_cb4 2)
		)
	)

	(ai_prefer_target_ai enc5_2_cov enc5_2_flood true)

	(sleep_until (volume_test_players enc5_5) 1)
	(ai_disposable enc5_2_cov true)
	(ai_disposable enc5_2_flood true)
)

(script dormant checkpoint5_3
	(f_save_at_2_triggers save5_3 save5_3b)
	(print "save requested 5_3")
)

(script dormant enc5_3
	(sleep_until
		(or
			(volume_test_players enc5_3)
			(volume_test_players enc5_3b)
		)
	1)

	(print_if debug "enc5_3")
	(wake checkpoint5_3)

	; place ai
	(wake place_enc5_3_dropship)

	(sleep_until (volume_test_players enc5_7) 1)
	(ai_disposable enc5_3_cov true)
)

(script dormant place_enc5_3_dropship
	(print "dropship trigger")
	(ai_place sq_enc5_3_covenant_dropship)

	;set variable, to have a reference to the spirit vehicle
	(set global_first_dropship (ai_vehicle_get_from_spawn_point sq_enc5_3_covenant_dropship/pilot_spawn))
)

(script command_script enc5_3_dropship
	;set variable, to have a reference to the spirit vehicle ;already set before, but kept here to be sure
	(set global_first_dropship (ai_vehicle_get_from_spawn_point sq_enc5_3_covenant_dropship/pilot_spawn))

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)

	; entry flight path, flies to each point in sequence
	(cs_teleport pts_enc5_3_flight_path/p0 pts_enc5_3_flight_path/p1)
	(cs_vehicle_speed 0.6)
	(cs_fly_by pts_enc5_3_flight_path/p1)
	(cs_fly_by pts_enc5_3_flight_path/p2)
	(cs_fly_by pts_enc5_3_flight_path/p3)
	(cs_vehicle_speed 0.1)
	(cs_fly_by pts_enc5_3_flight_path/p4)
	(device_set_position hangar_b_bay_door_right 0.5)
	(cs_vehicle_speed 0.2)
	(cs_fly_by pts_enc5_3_flight_path/p5)
	(cs_fly_to pts_enc5_3_flight_path/p6)

	;place squad and stuff inside the spirit
	(ai_place sq_enc5_3_covenant_elites)
	(ai_place sq_enc5_3_covenant_grunt)

	;place on the right side
	(vehicle_load_magic global_first_dropship "fork_p_r" (ai_actors sq_enc5_3_covenant_elites))
	(vehicle_load_magic global_first_dropship "fork_p_r" (ai_actors sq_enc5_3_covenant_grunt))

	;open the spirit's hatches
	(unit_open global_first_dropship)
	(sleep (game_ticks_from_seconds 1))

	(begin_random
		(begin (vehicle_unload global_first_dropship "fork_p_r1") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r2") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r3") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r4") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r5") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r6") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r7") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r8") (sleep 5))
	)
	;close the spririt's hatches
	(sleep (game_ticks_from_seconds 4))
	(unit_close global_first_dropship)

	; fly away and despawn
	(cs_fly_to_and_face pts_enc5_3_flight_path/p10 pts_enc5_3_flight_path/p6)
	(cs_vehicle_speed 1.0)
	(device_set_position hangar_b_bay_door_right 0)

	(cs_fly_to_and_face pts_enc5_3_flight_path/p7 pts_enc5_3_flight_path/p8)
	(cs_fly_to_and_face pts_enc5_3_flight_path/p8 pts_enc5_3_flight_path/p9)

	;scale the dropship for 6 seconds then erase
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant checkpoint5_4
	(f_save_at_trigger save5_4)
	(print "save requested 5_4")
)

(script dormant enc5_4
	(sleep_until (volume_test_players enc5_4) 1)
	(print_if debug "enc5_4")
	(wake checkpoint5_4)

	; place the ai
	(ai_place enc5_4_flood)
	(ai_place enc5_4_cov)

	; pause after spawn then set their perception
	(sleep 1)

	(ai_magically_see enc5_4_flood enc5_4_cov)
	(ai_prefer_target_ai enc5_4_cov enc5_4_flood true)

	(sleep_until (volume_test_players enc5_6) 1)
	(ai_disposable enc5_4_cov true)
	(ai_disposable enc5_4_flood true)
)

(script dormant checkpoint5_5
	(f_save_at_trigger save5_5)
	(print "save requested 5_5")
)

(script dormant enc5_5
	(sleep_until (volume_test_players enc5_5) 1)
	(print_if debug "enc5_5")
	(wake checkpoint5_5)

	; place the ai
	(ai_place enc5_5_cov)
	;(ai_place enc5_5_flood)
	(ai_place sq_enc5_5_flood_hall) ; flood in room
	(ai_place sq_enc5_5_flood_carriers) ; carriers placed in window behind jackals

	(ai_magically_see enc5_5_flood enc5_5_cov)
	(ai_prefer_target_ai enc5_5_flood enc5_5_cov true)
	(ai_prefer_target_ai enc5_5_cov enc5_5_flood true)

	(wake vo_keyes_pained_enc5_5)

	; wait to place follow up squads
	(wake enc5_5_place_flanking_squad)
	(wake enc5_5_place_upper_hall)

	(garbage_collect_now)

	(sleep_until (volume_test_players enc6_1) 1)
	(ai_disposable enc5_5_cov true)
	(ai_disposable enc5_5_flood true)

	; wait until the player has moved past the encounter and turn off the additional spawners.
	(sleep_until b_keyes_cinematic_played 1)
	(sleep_forever enc5_5_place_flanking_squad)
	(sleep_forever enc5_5_place_upper_hall)
)

(script dormant enc5_5_place_flanking_squad
	(sleep_until (volume_test_players enc5_5a) 1)
	(ai_place sq_enc5_5_flood_combat_elite) ; flanking flood

	(ai_magically_see enc5_5_flood enc5_5_cov)
	(ai_prefer_target_ai enc5_5_flood enc5_5_cov true)
	(ai_prefer_target_ai enc5_5_cov enc5_5_flood true)
)

(script dormant enc5_5_place_upper_hall
	(sleep_until (volume_test_players enc5_5b) 1)
	(ai_place sq_enc5_5_flood_combat_elite2) ; hall flood

	(ai_magically_see enc5_5_flood enc5_5_cov)
	(ai_prefer_target_ai enc5_5_flood enc5_5_cov true)
	(ai_prefer_target_ai enc5_5_cov enc5_5_flood true)
)

(script dormant checkpoint5_6
	(f_save_at_trigger save5_6)
	(print "save requested 5_6")
)

(script dormant enc5_6
	(sleep_until (volume_test_players enc5_6) 1)
	(print_if debug "enc5_6")
	(wake checkpoint5_6)
	(wake vo_keyes_pained_enc5_6)

	; place the ai
	(ai_place enc5_6_flood)

	(sleep_until (volume_test_players enc6_1) 1)
	(ai_disposable enc5_6_flood true)

	;(f_ai_magically_see_players enc5_6_flood)
)

(script dormant checkpoint5_7
	(f_save_at_trigger save5_7)
	(print "save requested 5_7")
)

(script dormant enc5_7
	(sleep_until (volume_test_players enc5_7) 1)
	(print_if debug "enc5_7")
	(wake checkpoint5_7)

	; dropship flies in to drop off specop guys
	(wake place_first_dropship)

	(wake chapter_3_test)
	(set s_music_trigger 160)

	; place the ai
	(ai_place enc5_7_flood)
	(ai_migrate enc5_6_flood sq_enc5_7_flood_combat_elite)

	(if (objects_can_see_flag (players) enc5_7_elites 30)
		(ai_place sq_enc5_7_covenant_elitea)
		(ai_place sq_enc5_7_covenant_eliteb)
	)

	(f_ai_magically_see_players enc5_7_flood)

	; wait for the player to press forward, the go on the offensive and place more
	(sleep_until
		(or
			(volume_test_players enc7_2)
			(volume_test_players enc7_2b)
			(volume_test_players enc7_2c)
		)
	1)

	(ai_place sq_enc5_7_flood_combat_elite 3)
	(ai_place sq_enc5_7_flood_carriers 1)


	; wait until the flood are dead, then place the next waypoint
	(sleep_until
		(or
			(<= (ai_living_count enc5_7_flood) 0)
			(volume_test_players enc7_6)
		)
	1)

	; dialogue and mark control room navpoint
	(wake vo_enc5_7)

	(sleep_until (volume_test_players enc6_1) 1)
	(ai_disposable enc5_7_cov true)

	; wait to sleep
	;(sleep_until (volume_test_players enc7_6) 1)
	;(sleep_forever enc5_7_manager)
)

;(global short enc5_7_limiter 0)
;(script dormant enc5_7_manager
	;(sleep_until
		;(begin
			; sleep until it's safe to spawn
			;(sleep_until
				;(and
					;(volume_test_objects_all enc7_6 (players))
					;(<= enc5_7_limiter (* 3 spawn_scale))
				;)
			;)

			; spawn if necessary
			;(if (<= (ai_nonswarm_count enc5_7_flood/reins) (* 2 min_combat_spawn))
			 	;(begin
			 		;(ai_place enc5_7_flood/reins) ; zfannon - not placed?
			 		;(set enc5_7_limiter (+ enc5_7_limiter 1))
			 	;)
			;)
			;false
		;)
	;1)
;)

(script dormant chapter_3_test
	; title
	(sleep_until (volume_test_players enc7_1) 1) ;made this trigger volume bigger than legacy to avoid being able to skip it and hit it on the way back
	(chapter_d20_3)

	; (deactivate_team_nav_point_flag player waypoint5)
)

(script static void chapter_d20_3
	(print "chapter title 3 - the captain") ;cinematic will have title card
	(f_hud_chapter "chapter_d20_3")
)

;(script dormant enc5_7_dropship_delivery;
	;(print "enc5_7_dropship_delivery stub")
	;create the dropship and move it into place
	;(object_create enc5_7_dropship)
	;(object_teleport enc5_7_dropship enc5_7_dropship)

	;create the units and then stuff them into the dropship
	;(ai_place enc5_7_cov/specops)
	;(ai_braindead enc5_7_cov/specops true)
	;(vehicle_load_magic enc5_7_dropship "passenger" (ai_actors enc5_7_cov/specops))

	; start the recording, and wait for the time to disgorge the units
	; (recording_play (unit enc5_7_dropship) enc5_7_dropship)
	;(sleep 640)

	; drop the units
	;(vehicle_unload enc5_7_dropship "passenger")
	;(ai_braindead enc5_7_cov/specops false)

	; sleep the rest of the time, then kill the ship
	;(sleep (recording_time enc5_7_dropship))
	;(object_destroy enc5_7_dropship)
;)

(script dormant place_first_dropship
	(print "dropship trigger")
	(ai_place sq_first_spirit_dropship)

	;set variable, to have a reference to the spirit vehicle
	(set global_first_dropship (ai_vehicle_get_from_spawn_point sq_first_spirit_dropship/pilot_spawn))
)

(script command_script cs_enc5_7_first_spirit_dropship_delivery

	;debug print
	(print "cs_enc5_7_first_spirit_dropship_delivery stub")

	;set variable, to have a reference to the spirit vehicle ;already set before, but kept here to be sure
	(set global_first_dropship (ai_vehicle_get_from_spawn_point sq_first_spirit_dropship/pilot_spawn))

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)

	; entry flight path, flies to each point in sequence
	(cs_teleport pts_first_spirit_dropship_path/p0 pts_first_spirit_dropship_path/p1)
	(cs_vehicle_speed 0.6)
	(cs_fly_by pts_first_spirit_dropship_path/p1)
	(cs_fly_by pts_first_spirit_dropship_path/p2)
	(cs_fly_by pts_first_spirit_dropship_path/p3)
	(cs_vehicle_speed 0.1)
	(cs_fly_by pts_first_spirit_dropship_path/p4)
	(device_set_position hangar_b_bay_door_left .5)
	(cs_vehicle_speed 0.2)
	(cs_fly_by pts_first_spirit_dropship_path/p5)
	(cs_fly_to pts_first_spirit_dropship_path/p6)

	;place squad and stuff inside the spirit
	(ai_place sq_gr_first_dropship)
	;place on the right side
	(vehicle_load_magic global_first_dropship "fork_p_r" (ai_actors sq_spirit_dropship_grunts_b))
	;place on the left side
	(vehicle_load_magic global_first_dropship "fork_p_l" (ai_actors sq_spirit_dropship_grunts_a))
	(vehicle_load_magic global_first_dropship "fork_p_l" (ai_actors sq_spirit_dropship_elites))

	;open the spirit's hatches
	(unit_open global_first_dropship)
	(sleep 30)
	;(vehicle_unload global_first_dropship "")

	(begin_random
		(begin (vehicle_unload global_first_dropship "fork_p_l1") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_l2") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_l3") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_l4") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_l5") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_l6") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_l7") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_l8") (sleep 5))

	)
	(sleep (game_ticks_from_seconds 2))

	(cs_fly_by  pts_first_spirit_dropship_path/p11)
	(cs_fly_to_and_face pts_first_spirit_dropship_path/p9 pts_first_spirit_dropship_path/p10)
	;(cs_fly_to pts_first_spirit_dropship_path/p10)

	(sleep (game_ticks_from_seconds 2))

	(begin_random

		(begin (vehicle_unload global_first_dropship "fork_p_r1") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r2") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r3") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r4") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r5") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r6") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r7") (sleep 5))
		(begin (vehicle_unload global_first_dropship "fork_p_r8") (sleep 5))

	)
	;close the spririt's hatches
	(sleep 120)
	(unit_close global_first_dropship)

	(ai_migrate enc5_1_cov sq_spirit_dropship_elites)

	; fly away and despawn
	(cs_fly_to_and_face pts_first_spirit_dropship_path/p12 pts_first_spirit_dropship_path/p10 0.01)
	(cs_fly_to_and_face pts_first_spirit_dropship_path/p12 pts_first_spirit_dropship_path/p9)
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face pts_first_spirit_dropship_path/p2 pts_first_spirit_dropship_path/p1)
	;(cs_fly_to_and_face pts_first_spirit_dropship_path/p3 pts_first_spirit_dropship_path/p4)
	(device_set_position hangar_b_bay_door_left 0)
	(cs_fly_to_and_face pts_first_spirit_dropship_path/p2 pts_first_spirit_dropship_path/p7)
	(cs_fly_to_and_face pts_first_spirit_dropship_path/p7 pts_first_spirit_dropship_path/p8)

	;scale the dropship for 6 seconds then erase
	(f_dropship_actor_scale_destroy ai_current_actor)
)


;======================================================================================================================================================================================================
;===== section 6 ======================================================================================================================================================================================
;===== player approaches the control room, clears all enemies in the area, reaches keyes, and breaks out of the control room.==========================================================================
;======================================================================================================================================================================================================

(script dormant section6
	; sleep until the player enters the section6 section of the level.
	(sleep_until (volume_test_players section6) 1)
	(print_if debug "section6")

	;sets boolean for having whatched the keyes cinematic to pause encounter pileups.
	(set b_keyes_cinematic_played false)

	;start looking for a checkpoint.
	(wake checkpoint6)

	;update player objective.
	(wake objective_recover)

	;wake encounters before keyes
	(wake enc6_1)
	(wake enc6_2)
	(wake enc6_3)

	;wake encounters after keyes
	(sleep_until b_keyes_cinematic_played 1)
	(wake enc6_4)
	(wake enc6_5)
	(wake skull_pinata)
)

(script dormant objective_recover
	(sleep_until
		(and
			(not (cinematic_in_progress))
			(volume_test_players tv_navend_keyes_room_exit)
		)
	1)

	(f_objective_recover)

	(sleep_until b_keyes_cinematic_played 1)
	(f_hud_obj_complete)
)

(script dormant objective_gobay_2
	(sleep_until
		(or
			(volume_test_players enc6_5_stopper)
			(volume_test_players enc6_3_safe)
		)
	1)

	(f_objective_go_to_bay)

	(sleep_until (volume_test_players tv_nav_shuttle_3rd_floor) 1)
	(f_hud_obj_complete)
)

(script dormant checkpoint6
	(f_save_at_trigger save6)
	(print "save requested sec6")
)

;player approaches a fight where covenant forces are trying to break into the control room.
(script dormant enc6_1
	(sleep_until (volume_test_players enc6_1) 1)
	(print_if debug "enc6_1")
	(wake vo_keyes_pained_enc6_1)

	;opening door to control room to give flood some space to start.
	(device_set_position_immediate dm_keyes_control_door 1)

	; place the ai with a little break to save on performance
	(f_ai_place_over_ticks enc6_1_cov enc6_1_flood none none none none)

	;start up the 6_1 manager script
	(wake enc6_1_manager)

	;waits until the player progresses then cuts off the spawner
	(sleep_until (volume_test_players enc6_2) 1)
	(sleep_forever enc6_1_manager)
	(print_if debug "enc6_1 | spawner disabled")
)

(script dormant enc6_1_manager
	;clean start for our manager
	(set enc6_1_limiter 0)

	(print_if debug "enc6_1 | spawner enabled")
	(sleep_until
		(begin
			;sleep until the player is inside the volume
			(sleep_until (volume_test_players enc6_1) 1)

			;spawn actors if the flood counts are short
			(if (<= (ai_living_count sq_enc6_1_flood_combat_elite) 1) ; no current limit on flood here
				(begin
					(ai_place sq_enc6_1_flood_combat_elite)
					(print_if debug "enc6_1 | cobmat form added")
				)
			)

			;spawn covies if necessary
			(if
				(and
					(<= (ai_nonswarm_count enc6_1_cov) 2)
					(<= enc6_1_limiter 3) ; 3 waves of covenant reinforcements.
				)
				(begin
					;make sure the player is clear of both spawn points
					(if (not (volume_test_players enc6_1b))
						(begin
							(ai_place sq_enc6_1_elites)
							(print_if debug "enc6_1 | elite added")
						)
					)

					;if at this point the count is greater than 2, we placed units, so inc
					(if (> (ai_nonswarm_count enc6_1_cov) 2)
						(set enc6_1_limiter (+ enc6_1_limiter 1))
					)
				)
			)

			;pause if there are too many covenant
			(if (>= (ai_nonswarm_count enc6_1_cov) 4) (sleep (game_ticks_from_seconds 5)))

			;exit condition - if the player progresses to the enc6_2 trigger volume.
			false
		)
	1)

)

;player has pushed in to the conflict outside the bridge and must clear all enemies to move into the bridge.
(script dormant enc6_2
	(sleep_until (volume_test_players enc6_2) 1)
	(print_if debug "enc6_2")

	;begin looking for a checkpoint
	(wake checkpoint6_2)

	;bloodgate
	(device_set_position_immediate dm_keyes_control_door 0)
	(device_set_power dm_keyes_control_door 0)

	; check to make sure we didn't launch any units into the room we can't kill them in then kill them if we did
	(f_delete_hiding_units gr_enc6_1 enc6_3_cin)

	(sleep_until (<= (ai_living_count gr_enc6_1) 3)1)
	(f_blip_ai gr_enc6_1 1)

	;sleep until bloodgate condition is met.
	(sleep_until (= (ai_living_count gr_enc6_1) 0)1)

	;open the door
	(device_set_power dm_keyes_control_door 1)
)

; if an ai in softlock_squad is in the volume volume then delete it.
(global short s_softlock_index 0)
(script static void (f_delete_hiding_units (ai softlock_squad) (trigger_volume volume))
	(set s_softlock_index 0)
    (sleep_until
        (begin
        	(if (volume_test_object volume (list_get (ai_actors softlock_squad) s_softlock_index))
				(ai_erase (object_get_ai (list_get (ai_actors softlock_squad) s_softlock_index)))
        	)
            (set s_softlock_index (+ s_softlock_index 1))

            (>= s_softlock_index (list_count (ai_actors softlock_squad)))
        )
    1)
)

(script dormant checkpoint6_2
	(f_save_at_trigger save6_2)
	(print "save requested 6_2")
)

;the player has arrived at keyes. clean up the last encounter, play the cutscene then prompt to get out.
(script dormant enc6_3
	; sleep until the trigger
	(sleep_until (volume_test_players enc6_3) 1)
	(print_if debug "enc6_3")

	;clean up previous encounter if player somehow got here with enemies remaining.
	(ai_disposable enc6_1_cov true)
	(ai_disposable enc6_1_flood true)

	(sleep_until (volume_test_players enc6_4) 1)
	(set s_music_trigger 170)

	; run the cinematic
	(sleep_until (volume_test_players enc6_3_cin) 1)

	; kill any units who might still be manning the hangar bay and anything beyond that (garbage collection)
	(ai_erase enc4_0)
	(ai_erase enc4_2_flood)
	(ai_erase enc4_3_flood1)
	(ai_erase enc4_3_flood2)
	(ai_erase enc4_4_flood)
	(ai_erase enc4_5_flood)
	(ai_erase enc4_6_flood)
	(ai_erase enc4_7_cov)
	(ai_erase enc4_8_flood)
	(ai_erase enc4_9_cov)

	(ai_erase enc5_1_cov)
	(ai_erase enc5_1_flood)
	(ai_erase enc5_2_cov)
	(ai_erase enc5_2_flood)
	(ai_erase enc5_3_cov)
	(ai_erase enc5_4_cov)
	(ai_erase enc5_4_flood)
	(ai_erase enc5_5_cov)
	(ai_erase enc5_5_flood)
	(ai_erase enc5_6_flood)
	(ai_erase enc5_7_cov)
	(ai_erase sq_gr_first_dropship)
	(ai_erase enc5_7_flood)


	(ai_erase gr_enc6_1)
	(object_destroy_folder ob_folder_floodhuman3)
	(object_destroy_folder ob_folder_flood_hangar)

	(garbage_collect_unsafe) ; attempt to clean up since we are about to make a mess

	(object_create_folder_anew ob_enc6_5_bipeds)
	(object_create_folder_anew ob_enc6_5_floodballs)
	(object_create_folder_anew ob_enc6_5_weapons)

	(set b_cinematic_lower_weapon true)
	(f_play_cinematic cinematics\d20\d20_keyes.cinematic ps_after_cine_teleport)
	(set b_cinematic_lower_weapon false)

	; closing the door to the control room
	(device_set_position_immediate dm_keyes_control_door 0)
	(device_operates_automatically_set dm_keyes_control_door false)

	;log that we've finished cutscene
	(set b_keyes_cinematic_played true)

	;begin looking for a checkpoint
	(wake checkpoint6_3)

	; remove control room marker
	(f_unblip_flag navpoint_keyes_room)

	;begin music
	(set s_music_trigger 190)

	;cortana prompts the player with next steps
	(wake vo_enc6_3)

	;next objective
	(wake objective_gobay_2)

	;waypoint added to get player moving to the end of the level
	(wake navpoint_to_mission_end)
)

(script dormant checkpoint6_3
	(f_game_save)
	(print "save requested 6_3")
)

;player must escape the control room. the covenant lie in wait just out side the door as if on their way to the control room.
(script dormant enc6_4
	; make our exit green and make sure its doesn't close once it opens
	(device_set_power dm_keyes_control_door 1)
	(device_operates_automatically_set dm_keyes_control_door false)
	(device_closes_automatically_set dm_keyes_control_door false)
	(set b_keyes_door_is_open false)

	; spawn our door knockers
	(ai_place sq_enc6_4_gf_back)

	; wait for player to approach the door or for flood waves to wrap up
	(sleep_until
		(or
			b_keyes_door_is_open ; door knockers opened the door
			(>= enc6_5_limiter (- (* 6 spawn_scale) 1)) ; we are on the next to last wave
		)
	1 )

	(set b_keyes_door_is_open true) ; setting the boolean to true incase the door_knocker command script failed to do so and prevent anything dependant on it from breaking.
	(print_if debug "enc6_4")

	; place the spec ops
	(ai_place sq_enc6_4_elite_back)
	(ai_place sq_enc6_4_elite)
	(ai_place sq_enc6_4_gf)
	(ai_place sq_enc6_4_gn)
	(ai_place sq_enc6_4_gr_back)

	; if the player is in the volume surprise them and throw a grenade, otherwise rush in and distract flood for player
	(if (volume_test_players enc6_4)
		(begin
			(device_set_position_immediate dm_keyes_control_door 1)
			(sleep 2)
			(cs_grenade sq_enc6_4_gn true enc6_4_grenade/p0 0)
		)
		(begin ; if player focused on the floor or got held up have the covenant bust in.
			(device_set_position_immediate dm_keyes_control_door 1)
			(sleep 2)
			(cs_run_command_script enc6_4_cov cs_enc6_5_breach_control)
		)
	)

	; covenant break in to control room and flood and covenant turn on each other
	(ai_prefer_target_ai enc6_4_cov enc6_5_flood true)
	(ai_prefer_target_ai enc6_5_flood enc6_4_cov true)

	; infectors run to the covenant and swarm them
	(cs_run_command_script sq_enc6_5_infectors_a cs_enc6_5_swarm_hall)
	(cs_run_command_script sq_enc6_5_infectors_b cs_enc6_5_swarm_hall)

	; in the chaos ignore the player for a couple seconds or if the player sprinted away to our next trigger
	(ai_disregard (players) true)
	(sleep_until (volume_test_players section6) 1 (game_ticks_from_seconds 1.0))
	(ai_disregard (players) false)

	; sleep until the trigger
	(sleep_until (volume_test_players section6) 1)
	(sleep_forever enc6_5_manager)
	(print_if debug "enc6_1 | spawner disabled")
)

(script dormant enc6_5
	(print_if debug "enc6_5")

	; spawn our initial infector waves
	(ai_place enc6_5_flood_rez)

	; wait for player to leave the platform or wait 5 seconds, then spawn the flood
	(sleep_until (not (volume_test_players enc6_5_platform)) 1 (game_ticks_from_seconds 20))

	; wait for the player to progress physically or through kills
	(sleep_until
		(or
			(not (volume_test_players enc6_5_platform)) ; if the player is off the platfom
			(<= (ai_nonswarm_count enc6_5_flood_rez) 4) ; if revived units dropped below our threshold
		)
	1 )

	; wake up
	(wake enc6_5_manager)

	(device_set_position small_door80 1)
	(device_set_position small_door81 1)

	(sleep_until (volume_test_players section6) 1)
	(ai_disposable enc6_5_flood true)

)

(script dormant enc6_5_manager
	(print_if debug "enc6_5 | spawner enabled")
	(sleep_until
		(begin
			; spawn if necessary
			(if
				(and
					(not (volume_test_players enc6_5_stopper)) ; player isn't in the room
					(<= (device_get_position small_door80) .05) ; door is closed
					(<= (ai_nonswarm_count enc6_5_flood_left) (* 2 min_combat_spawn)) ; not enough flood alive
				)
				(begin
					(if (and (<= (game_coop_player_count) 2) (= (game_difficulty_get) normal)) ; 2 or fewer players on normal difficulty
						(ai_place enc6_5_flood_left 2) ; on normal spawn only 2 unit
						(ai_place enc6_5_flood_left 3) ; on heroic and above spawn a full wave
					)
					(set enc6_5_limiter (+ enc6_5_limiter 1))
					(print_if debug "enc6_5 | flood left spawned")
					(sleep 2) ; let the flood spawn
				)
			)

			; spawn if necessary
			(if
				(and
					(not (volume_test_players enc6_5_stopper)) ; player isn't in the room
					(<= (device_get_position small_door81) .05) ; door is closed
					(<= (ai_nonswarm_count enc6_5_flood_right) (* 2 min_combat_spawn)) ; not enough flood alive
				)
				(begin
					(if (and (<= (game_coop_player_count) 2) (= (game_difficulty_get) normal)) ; 2 or fewer players on normal difficulty
						(ai_place enc6_5_flood_right 2) ; on normal spawn only 2 units
						(ai_place enc6_5_flood_right 3) ; on heroic and above spawn a full wave
					)
					(set enc6_5_limiter (+ enc6_5_limiter 1))
					(print_if debug "enc6_5 | flood right spawned")
					(sleep 2) ; let the flood spawn
				)
			)

			; pause between spawns attempts
			(if (and (<= (game_coop_player_count) 2) (= (game_difficulty_get) normal))
				(sleep (game_ticks_from_seconds 2)) ; wait a bit before checking again to avoid spamming spawns
			)

			; exit condition - when the player tracks back to the section 6 volume kill spawner
			; we also check to turn off this spawner in other places if the player escapes
			(or
				(volume_test_players section6) ; player left the encounter area
				(> enc6_5_limiter (* 6 spawn_scale)) ; we've spawn enough waves 6 -> 10
			)
		)
	1)

	(print_if debug "enc6_5 | spawner disabled")
)

(script command_script cs_enc6_5_swarm_left
	(cs_swarm_from ps_infector_targets/p1 0.1)
)

(script command_script cs_enc6_5_swarm_right
	(cs_swarm_from ps_infector_targets/p0 0.1)
)

(script command_script cs_enc6_5_swarm_hall
	(cs_swarm_from ps_infector_targets/p2 0.1)
)

(global boolean b_keyes_door_is_open false)
(global short s_wave_to_knock_on 0)
(script command_script cs_enc6_4_door_knocker
	(set b_keyes_door_is_open false)
	(cond
		((= (game_difficulty_get) normal) (set s_wave_to_knock_on 3))
		((= (game_difficulty_get) heroic) (set s_wave_to_knock_on 4))
		((= (game_difficulty_get) legendary) (set s_wave_to_knock_on 5))
	)

	; if we are playing with more than 2 players, add an additional 2 waves.
	(if (> (game_coop_player_count) 2) (set s_wave_to_knock_on (+ s_wave_to_knock_on 2)))

	; wait until the ideal wave begins then begin to knock on the door
	(sleep_until
		(or
			(>= enc6_5_limiter s_wave_to_knock_on) ; enough waves have spawned
			(volume_test_players enc6_4) ; player gets the near the door
		)
		1 (game_ticks_from_seconds 25) ; 25 seconds have passed
	)

	(cs_shoot_point true ps_door_knocker_targets/p0) ; shoot door
	(print_if debug "cs_enc6_4 | knock knock...")
	(sleep (game_ticks_from_seconds 2))
	(cs_shoot_point false ps_door_knocker_targets/p0) ; stop shooting door

	; wait a random amount time before shooting again
	(begin_random_count 1
		(sleep (game_ticks_from_seconds 1))
		(sleep (game_ticks_from_seconds 2))
		(sleep (game_ticks_from_seconds 3))
	)

	(cs_shoot_point true ps_door_knocker_targets/p0) ; shoot door
	(print_if debug "cs_enc6_4 | knock knock...")
	(sleep (game_ticks_from_seconds 1))
	(cs_shoot_point false ps_door_knocker_targets/p0) ; stop shooting door

	; wait a random amount time before shooting again
	(begin_random_count 1
		(sleep (game_ticks_from_seconds 1))
		(sleep (game_ticks_from_seconds 2))
	)

	(cs_shoot_point true ps_door_knocker_targets/p0) ; shoot door
	(print_if debug "cs_enc6_4 | knock knock...")
	(sleep (game_ticks_from_seconds 1))
	(cs_shoot_point false ps_door_knocker_targets/p0) ; stop shooting door

	; wait a random amount time before shooting again
	(sleep (game_ticks_from_seconds 1))

	(cs_shoot_point true ps_door_knocker_targets/p0) ; shoot door
	(print_if debug "cs_enc6_4 | knock knock...")
	(sleep 1)
	(set b_keyes_door_is_open true)
	(device_set_position_immediate dm_keyes_control_door 1) ; blast the door open

	(print_if debug "enc6_4 | door is open")
)

(script command_script cs_enc6_5_breach_control
	(cs_move_towards_point ps_door_knocker_targets 1.0)
)

;======================================================================================================================================================================================================
;===== section 7 ======================================================================================================================================================================================
;===== player needs to find a way off the covenant ship and there are tons of enemies in the way. banshees fly in and player flies out ================================================================
;======================================================================================================================================================================================================

(script dormant checkpoint7
	(f_save_at_trigger save7)
	(print "save requested sec7")
)

(script dormant section7
	; (object_create enc7_6_shield1)
	; (object_create enc7_6_shield2)
	(sleep_until b_keyes_cinematic_played 1)
	(wake music_trigger_20)
	; sleep until the trigger
	(sleep_until (or (volume_test_players section7) (volume_test_players enc7_2)) 1)
	(print_if debug "section7")
	(wake checkpoint7)

	; place "ambients", wake encs
	(ai_place enc7_0_mix)
	(wake enc7_1)
	(wake enc7_2)
	(wake enc7_3)
	(wake enc7_4)
	(wake enc7_5)
	(wake enc7_6)
	(wake enc7_6_flood)
)

(script dormant checkpoint7_1
	(f_save_at_trigger save7_1)
	(print "save requested 7_1")
)

(script dormant enc7_1
	(sleep_until (volume_test_players enc7_1) 1)
	(print_if debug "enc7_1")
	(wake checkpoint7_1)

	; place the ai
	(ai_place enc7_1_cov)
	(ai_place enc7_1_flood)

	(ai_prefer_target_ai enc7_1_cov enc7_1_flood true)
	(ai_magically_see enc7_1_cov enc7_1_flood)
	(ai_magically_see enc7_1_flood enc7_1_cov)

	; sleep until the player forces an advance, then advance the covies
	(sleep_until (volume_test_players enc5_5) 1)
	(ai_migrate enc7_1_cov sq_enc7_3_cov_jackals)
)

(script dormant checkpoint7_2
	(f_save_at_3_triggers save7_2 save7_2b save7_2c)
	(print "save requested 7_2")
)

(script dormant enc7_2
	;new timing for banshees
	(wake banshee_outro)

	; sleep until the player is inside the volume
	(sleep_until
		(or
			(volume_test_players enc7_2)
			(volume_test_players enc7_2b)
			(volume_test_players enc7_2c)
		)
	1)
	(print_if debug "enc7_2")
	(wake checkpoint7_2)

	; load-in the spirit
	(ai_place sq_outro_dropship)
	(set sq_outro_dropship_global (ai_vehicle_get_from_starting_location sq_outro_dropship/pilot_spawn))

	; test for ending conditions
	(sleep_until
		(or
			(player_in_vehicle (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint))
			(player_in_vehicle (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint))
		)
	1)

	(sleep_forever skull_pinata)

	(print "game over")
	(submit_incident "unlock_d40")
	(submit_incident_with_custom_string_id "game_activity_end_completed" "d20")

	(f_play_cinematic cinematics\d20\d20_outro.cinematic)
	(game_won)
)

(script dormant banshee_outro
	(sleep_until (volume_test_players tv_nav_shuttle_3rd_floor) 1) ; wait until the player returns to the hangar
	(sleep_until (volume_test_players tv_banshee_outro) 1 (game_ticks_from_seconds 30)) ; don't move forward until the player takes too long or moves up
	(sleep_until (or (volume_test_players tv_nav_shuttle_3rd_floor) (volume_test_players tv_banshee_outro)) 1) ; make sure the player is in the hangar

	; bring in the banshees
	(ai_place sq_outro_banshee1)
	(sleep (game_ticks_from_seconds 2))
    (ai_place sq_outro_banshee2)

	(wake vo_enc7_2)
	(wake objective_escape)

	; if the banshee falls out of the hangar fly in a new one so we don't get softlocked
	(wake replace_banshee)
)

(script dormant replace_banshee
	; wait for our banshees to enter the hangar
	(sleep_until
		(and
			(volume_test_object enc5_1 (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint))
			(volume_test_object enc5_1 (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint))
		)
	1 )
	(print_if debug "waiting to restock banshees")

	(sleep_until
		(begin
			(if
				(and
					(not (volume_test_object enc5_1 (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint)))
					(not (volume_test_object enc5_1 (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint)))
				)

				(begin_random_count 1
					; if banshee 1 is no longer in the hangar spawn a new one and wait for it to be in the hangar

					(begin
						(object_destroy (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint)) ; make sure to destroy the old one so we don't have a bunch of banshees flying around
						(sleep 1)
						(ai_place sq_outro_banshee1)
						(print_if debug "restocking banshee 1")
						(sleep_until (volume_test_object enc5_1 (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint)) 1)

						(f_unblip_flag last_blip_flag)
						(f_blip_object (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint) 0)
					)

					(begin
						(object_destroy (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint)) ; make sure to destroy the old one so we don't have a bunch of banshees flying around
						(sleep 1)
						(ai_place sq_outro_banshee2)
						(print_if debug "restocking banshee 2")
						(sleep_until (volume_test_object enc5_1 (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint)) 1)

						(f_unblip_flag last_blip_flag)
						(f_blip_object (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint) 0)
					)

				)
			)

			; exit condition
			false
		)
		(game_ticks_from_seconds 10) ; wait just so we don't instantly have a banshee once the condition is met
	)

)

(script dormant objective_escape
	(f_objective_escape)
)

(script command_script outro_dropship_path

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport bp_outro_dropship_path/p0 bp_outro_dropship_path/p1)
	(cs_vehicle_speed .5)
	(cs_fly_to bp_outro_dropship_path/p1)
	(cs_face true bp_outro_dropship_path/p7)
	(cs_fly_by bp_outro_dropship_path/p2)
	(cs_vehicle_speed .3)
	(cs_fly_by bp_outro_dropship_path/p3)
	(cs_vehicle_speed .3)

	(device_set_position hangar_b_bay_door_left .90)

	; (cs_fly_by bp_outro_dropship_path/p4)
	(cs_fly_by bp_outro_dropship_path/p5)
	(cs_face false bp_outro_dropship_path/p7)
	(cs_fly_to_and_face bp_outro_dropship_path/p6 bp_outro_dropship_path/p7)

	(device_set_position hangar_b_bay_door_left 0)

	(ai_place sq_enc7_4_covenant_grunt)
	(vehicle_load_magic sq_outro_dropship_global "fork" (ai_actors sq_enc7_4_covenant_grunt))

	(unit_open sq_outro_dropship_global)
	(sleep 35)

	(begin_random
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_r1") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_r2") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_r3") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_r4") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_r5") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_r6") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_r7") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_r8") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_l1") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_l2") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_l3") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_l4") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_l5") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_l6") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_l7") (sleep 5))
		(begin (vehicle_unload sq_outro_dropship_global "fork_p_l8") (sleep 5))
	)
	(sleep 120)
	(unit_close sq_outro_dropship_global)
	(vehicle_hover (ai_vehicle_get_from_starting_location sq_outro_dropship/pilot_spawn) true)
)

(script command_script outro_banshee1_path

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport bp_outro_banshee1_path2/p0 bp_outro_banshee1_path2/p1)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint))
	(cs_vehicle_speed 0.01)
	(cs_fly_by bp_outro_banshee1_path2/p1)
	(device_set_position hangar_b_bay_door_left .5)
	(cs_fly_by bp_outro_banshee1_path2/p2)
	(cs_fly_by bp_outro_banshee1_path2/p3)
	(cs_fly_by bp_outro_banshee1_path2/p4)
	(cs_fly_by bp_outro_banshee1_path2/p5)
	(cs_fly_by bp_outro_banshee1_path2/p6)
	(cs_fly_by bp_outro_banshee1_path2/p7)
	(cs_fly_by bp_outro_banshee1_path2/p8)
	(cs_fly_by bp_outro_banshee1_path2/p9)
	(cs_fly_by bp_outro_banshee1_path2/p10)
	(cs_fly_by bp_outro_banshee1_path2/p11)
	(cs_fly_to bp_outro_banshee1_path2/p12 0.01)
	(cs_vehicle_speed 0.0)
	;(ai_braindead sq_outro_banshee1 true)
	(vehicle_hover (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint) true)
	(sleep 1)
	(ai_vehicle_exit sq_outro_banshee1)
	(sleep 30)
	(vehicle_hover (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint) true)
)

(script command_script outro_banshee2_path

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport bp_outro_banshee2_path2/p0 bp_outro_banshee2_path2/p1)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint))
	(cs_vehicle_speed 0.01)
	(cs_fly_by bp_outro_banshee2_path2/p1)
	(cs_fly_by bp_outro_banshee2_path2/p2)
	(cs_fly_by bp_outro_banshee2_path2/p3)
	(cs_fly_by bp_outro_banshee2_path2/p4)
	(device_set_position hangar_b_bay_door_left 0)
	(cs_fly_by bp_outro_banshee2_path2/p5)
	(cs_fly_by bp_outro_banshee2_path2/p6)
	(cs_fly_by bp_outro_banshee2_path2/p7)
	(cs_fly_by bp_outro_banshee2_path2/p8)
	(cs_fly_by bp_outro_banshee2_path2/p9)
	(cs_fly_by bp_outro_banshee2_path2/p10)
	(cs_fly_by bp_outro_banshee2_path2/p11)
	(cs_fly_to bp_outro_banshee2_path2/p12 0.01)
	(cs_vehicle_speed 0.0)
	;(ai_braindead sq_outro_banshee2 true)
	(vehicle_hover (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint) true)
	(sleep 1)
	(ai_vehicle_exit sq_outro_banshee2)
	(sleep 30)
	(vehicle_hover (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint) true)
)

(script dormant checkpoint7_3
	(f_save_at_trigger save7_3)
	(print "save requested 7_3")
)

(script dormant enc7_3
	(sleep_until (volume_test_players enc7_3) 1)
	(print_if debug "enc7_3")
	(wake checkpoint7_3)

	; reveal the barricades
	; (object_create enc7_3_barricade1)
	; (object_create enc7_3_barricade2)

	; place the ai
	(ai_place enc7_3_cov)

	; if the player goes into the hall leading to level 2
	(sleep_until (volume_test_players enc5_5) 1)
	(ai_disposable enc6_4_cov true)
	(ai_disposable enc6_5_flood true)
)

(script dormant enc7_4
	; if the player walked into the back hallway on the first floor...
	(sleep_until
		(or
	 		(volume_test_players enc7_4a)
			(volume_test_players enc7_4b)
		)
	1)

	; try to clean up some of the encounters on the upper level
	(ai_disposable enc6_4_cov true)
	(ai_disposable enc6_5_flood true)

	(ai_disposable enc7_0_mix true)
	(ai_disposable enc7_1_cov true) ; (already should be in 7_3, but just in case)
	(ai_disposable enc7_1_flood true)
	(ai_disposable enc7_3_cov true)
)

(script dormant checkpoint7_5
	(f_save_at_trigger save7_5)
	(print "save requested 7_5")
)

(script dormant enc7_5
	; if the player made it to level 2 and went towards the banshees...
	(sleep_until (volume_test_players enc7_5) 1)
	(print_if debug "enc7_5")
	(wake checkpoint7_5)

	; clean up!
	(ai_disposable enc6_4_cov true)
	(ai_disposable enc6_5_flood true)

	(ai_disposable enc7_1_cov true)
	(ai_disposable enc7_1_flood true)
	(ai_disposable enc7_3_cov true)


)

(script dormant checkpoint7_6
	(f_save_at_trigger save7_6)
	(print "save requested 7_6")
)

(script dormant checkpoint7_6c
	(f_save_at_trigger save7_6c)
	(print "save requested 7_6c")
)

(script dormant enc7_6
	(sleep_until (volume_test_players enc7_6) 1)
	(print_if debug "enc7_6")
	(wake checkpoint7_6)

	; clean up!
	(ai_disposable enc6_4_cov true)
	(ai_disposable enc6_5_flood true)

	; place initials as if its co-op these may not spawn at all.
	(ai_place enc7_6_cov)

	(wake enc7_6_manager)

	; wait till the player drops down, then create units if warranted
	(sleep_until (volume_test_players enc7_6c) 1)
	(ai_place enc7_6_cov)
	(wake checkpoint7_6c)
)

(script dormant enc7_6_flood
	; if the player goes into the hallway leading to level 1
	(sleep_until
		(or
			(volume_test_players enc7_6_fa)
			(volume_test_players enc7_6_fb)
		)
	1)

	; try to clean up some of the encounters on the upper level
	(ai_disposable enc6_4_cov true)
	(ai_disposable enc6_5_flood true)

	(ai_disposable enc7_0_mix true)
	(ai_disposable enc7_1_cov true) ; (already should be in 7_3, but just in case)
	(ai_disposable enc7_1_flood true)
	(ai_disposable enc7_3_cov true)

	(ai_place enc_outro_flood)

	(sleep 5)

	(f_ai_magically_see_players enc_outro_flood)
)

(global short enc7_6_limiter 0)
(script dormant enc7_6_manager
	(sleep_until
		(begin
			; 5l33p un71l k1ll
			(sleep_until
				(and
					(volume_test_objects_all enc7_6 (players))
					(<= enc7_6_limiter (* spawn_scale 8))
				)
			1)

			; place door guards?
			(if (<= (ai_living_count sq_enc7_6_exit_covenant_grunt) 1)
				(begin
					(ai_place sq_enc7_6_exit_covenant_grunt)
					(set enc7_6_limiter (+ enc7_6_limiter 1))
				)
			)

			; place lower elites?
			(if (<= (ai_living_count sq_enc7_6_exit_covenant_elite) 1)
				(begin
					(ai_place sq_enc7_6_exit_covenant_elite)
					(set enc7_6_limiter (+ enc7_6_limiter 1))
				)
			)

			; place upper elites?
			(if (<= (ai_living_count sq_enc7_6_upper_covenant_elite) 1)
				(begin
					(ai_place sq_enc7_6_upper_covenant_elite)
					(set enc7_6_limiter (+ enc7_6_limiter 1))
				)
			)
			false
		)
	1)
)

;======================================================================================================================================================================================================
;===== skulls =========================================================================================================================================================================================
;===== logic for unlocking specific skulls can be found here. catch | blind | pinata ==================================================================================================================
;======================================================================================================================================================================================================

;_____catch_____
(script dormant skull_canyonrun
	(print_if debug "catch skull started.")

	;skip execution if not playing on heroic or legendary
	(if (= "normal" (game_difficulty_get))
		(begin
			(print_if debug "removing canyon run skull | not hard enough.")
			(sleep_forever)
		)
	)
	(print_if debug "canyon run | is hard enough.")

	;skip execution if skull is on to make the run easier
	(if (skull_enabled "skull_boots_off_the_ground")
		(begin
			(print_if debug "removing canyon run skull | cheater skull enabled")
			(sleep_forever)
		)
	)
	(print_if debug "canyon run | no cheat skulls found.")

	;holds script until the player is at the starting line
	(sleep_until (volume_test_players tv_canyon_run_skull_start) 1)
	(print_if debug "canyon run | begin")

	;spawn skull for player that makes it before the timer expires
	(sleep_until (volume_test_players tv_canyon_run_skull) 1 (game_ticks_from_seconds 0192.819912));jk
	(print_if debug "canyon run | begin")

	;if player made it to the other side spawn the skull
	(if (volume_test_players tv_canyon_run_skull)
		(begin
			(object_create skull_canyon_run)
			(print_if debug "canyon run | catch!")
		)
		(print_if debug "canyon run | too slow")
	)
)

;_____blind_____
(script dormant skull_blind_manager
	(print_if debug "blind skull started")

	(object_create skull_blind)
	(print_if debug "blind skull placed")
	(sleep (game_ticks_from_seconds .25))

	;wait until picked up or players progress too far
	(sleep_until (volume_test_players section5) 1)

	(if (>= (object_get_health skull_blind) 0) (object_destroy skull_blind))
	(print_if debug "blind skull cleaned up")

)

;_____pinata______
(global short s_pinata_hits 0) ;number of melees taken
(global short s_pinata_health 5) ;number of melees needed

(script dormant skull_pinata
	(print_if debug "pinata skull started")
	(print_if debug "hit the pinata")

	(if (game_is_cooperative) (set s_pinata_health (* 3 (game_coop_player_count))))

	(sleep_until
			(begin
				(f_did_player_hit_pinata player0)
				(f_did_player_hit_pinata player1)
				(f_did_player_hit_pinata player2)
				(f_did_player_hit_pinata player3)

				(> s_pinata_hits s_pinata_health)
			)
		(game_ticks_from_seconds .5))

	(object_create skull_pinata)
)

(script static void (f_did_player_hit_pinata (player stick_holder))
	(unit_action_test_reset stick_holder)

	(if
		(and
			(volume_test_object tv_pinata (unit stick_holder))
			(unit_action_test_melee stick_holder)
			(objects_can_see_flag stick_holder fl_pinata 30)
		)
		(begin
			(set s_pinata_hits (+ 1 s_pinata_hits))
			(print_if debug "you hit the pinata")

		)
	)
)

;======================================================================================================================================================================================================
;===== shared combat command scripts ==================================================================================================================================================================
;===== command scripts shared in different encounters=============================== ==================================================================================================================
;======================================================================================================================================================================================================

(script command_script cs_carrier_ballup
	(unit_set_stance ai_current_actor "perch_ceiling")
)