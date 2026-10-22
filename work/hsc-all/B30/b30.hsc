;====================================================================================================================================================================================================
; global variables ==================================================================================================================================================================================
;====================================================================================================================================================================================================
(global vehicle v_dropship_lid none)
(global vehicle v_dropship_last none)
(global vehicle v_foehammer_beach none)
(global vehicle v_foehammer_evac none)

(global boolean b_pelicans_unload false)
(global boolean b_warthog_created false)
(global boolean b_shafta_seen false)
(global boolean b_shafta_door_locked_seen false)
(global boolean b_shafta_unlocked false) ;this variable is for tracking having used the control at the bottom of shaftb
(global boolean b_shafta_switched false) ;this variable is for tracking having used the control at the bottom of shafta
(global boolean b_foehammer_pickup_begin false)


(global boolean b_arch_ambush false)
(global boolean b_play_ledge_cinematic true)
(global short s_warthog_main_objective_index 0) ; index of objective to defeat enemies at location, wait for player, etc.
(global short s_warthog_zone_transition_index 0) ; index to objective used to loading zones; does not equal to indexing of zones
(global short s_warthog_zone_transition_init 4) ; index used for sleep_untils not to trigger logic too much
(global short s_required_zone_trans_index 1) ; required zone transition index by the main objectives (zones needed to be loaded)
(global short s_warthog_next_objective_index 1)

(global boolean b_backup_lid false)
(global boolean b_door_cinematic_played false)

; variables related to the navpoints:
(global boolean b_valley_entrance_seen false)
(global boolean b_shaft_b_dawdled false)
;(global boolean b_shafta_has_np false)
(global boolean b_valley_entered false)
(global boolean b_shaft_a_navpoint_shown false)
(global boolean b_navpoint_loop_running false)

; (global boolean b_shafta_corridor_a2_a3_on false)	;tracks the state of the nav marker leading down the shaft from room a2 to a3
; (global boolean b_shafta_corridor_a3_a4_on false)	;tracks the state of the nav marker leading down the shaft from room a3 to a4
; (global boolean b_shafta_corridor_a4_a5_on false)	;tracks the state of the nav marker leading down the shaft from room a4 to a5

;(global cutscene_flag fl_primary_flag navpoint_main_facility)
;(global cutscene_flag fl_transient_flag navpoint_main_facility)
(global cutscene_flag fl_active_flag navpoint_main_facility)
(global object active_object none)

; startup script ========================================

(script startup b30_start
	(ai_allegiance human player)
	(ai_allegiance player human)
	(b30_insertion_point_fixups)
	(wake roaming_game_save)

	(wake b30_rally_point_unlocks)

	(if (f_insertion_point_area_pending insertion_beach_lz) (wake start_mission))
	(if (f_insertion_point_area_pending insertion_shaft_a_inactive) (wake mission_shaftb) (wake set_shafta_already_seen))
	(if (f_insertion_point_area_pending insertion_shaft_b) (wake mission_return_to_shafta))
	(if (f_insertion_point_area_pending insertion_shaft_a_active) (wake mission_shafta_inside))
	(if (f_insertion_point_area_pending insertion_silent_cartographer) (wake mission_shafta_exit))

	;* debug insertion point intialization has been disabled.

	(if (f_insertion_point_area_pending insertion_debug_hunterbowl) (wake mission_shaftb))
	(if (f_insertion_point_area_pending insertion_debug_shaft_b_hunters) (wake mission_shaftb))
	(if (f_insertion_point_area_pending insertion_debug_shaft_a_hunters) (wake mission_return_to_shafta) (set b_shafta_unlocked true))
	(if (f_insertion_point_area_pending insertion_debug_pelican_crash) (wake mission_return_to_shafta) (set b_shafta_unlocked true))

	; perfcheck insertion points catch up
	(if (f_insertion_point_area_pending insertion_perf_hunterbowl)
		(wake mission_shafta_exit)
		; else:
		(set b_shafta_switched true)
	)*;
)

;====================================================================================================================================================================================================
; beat 1: start mission:
;
; mission begins with a landing from foe hammer in the landing zone and a counterattack against the covenant.
; after securing the area, foe hammer drops a warthog, which the master chief uses to reach shaft a along the beach,
; where the covenant activates the security protocol and locks the door further into the facility.
;====================================================================================================================================================================================================
(script dormant start_mission
; map initialization
    (f_play_cinematic cinematics\b30\b30_intro.cinematic)
	(submit_incident_with_custom_string_id "game_activity_begin" "b30")
	(wake chapter_insertion)
    (wake place_beach_craig_dead_marines)
	(set s_b30_music_request 20)
    (effect_new "objects\levels\halo1\solo\b30\fx\beach_intro_explos\beach_intro_explos" fl_explos_beach_intro) ;-------------------- beach intro explos

; player initialization
    (ai_place start_pelican_left)
	(ai_place start_pelican_right)
    (unit_enter_vehicle_immediate player0 (ai_vehicle_get_from_starting_location start_pelican_left/spawn_point) "pelican_p_l05")
	(unit_enter_vehicle_immediate player1 (ai_vehicle_get_from_starting_location start_pelican_right/spawn_point) "pelican_p_l05")
	(unit_enter_vehicle_immediate player2 (ai_vehicle_get_from_starting_location start_pelican_left/spawn_point) "pelican_p_r05")
	(unit_enter_vehicle_immediate player3 (ai_vehicle_get_from_starting_location start_pelican_right/spawn_point) "pelican_p_r05")
    ; time players spend seated before unload
	(wake play_vo_beach_encounter_start) ; waking early for timing
    (sleep (game_ticks_from_seconds 2))
    (set b_pelicans_unload true)
    (f_hud_obj_new "obj_b30_lz" "obj_b30_lz") ; clear the landing beach of hostiles

;enemy initilization

; placers
    (wake place_lz_enemies)
	(wake place_valley)
    (wake place_valley_crack)
	(wake place_beach_crack)
    (wake place_beach_slab_pass)
    (wake place_shaft_a_beach)
    (wake place_shaft_a_door)

; trackers
	(wake arch_ambush_trigger)
	(wake shafta_entered_first_time_np)
	(wake shafta_seen)
	(wake foe_hammer_drop)
	(wake foehammer_warthog_delivered)
	(wake beach_crack_cleared)
	(wake jackals_to_valley_lid)
	(wake set_warthog_objective_1)
	(wake set_warthog_objective_2)

; narrative
	(wake trigger_vo_post_beach_encounter)
	(wake trigger_vo_shaft_a_outside)
	(wake trigger_vo_shaft_a_interior)
	(wake trigger_vo_shaft_a_door_warning)
	(wake trigger_vo_shaft_a_door_locked)
	(wake trigger_vo_ufo_remark)
	(wake trigger_vo_path_valley)
	(wake trigger_vo_hunter_bowl)

;co-op initialization
    (if (game_is_cooperative)
		(begin
			(wake multiplayer_placement_shafta_entrance)
			(wake multiplayer_placement_beach_crack)
			(wake multiplayer_placement_valley_lid)
		)
	)

    (print "checkpoint start")
	(f_game_save)

; cleaners
	(sleep_until b_shafta_unlocked 1)

		;some of the placers have internal logic that needs to be slept
    	(sleep_forever place_valley)
		(sleep_forever place_valley_crack)
		(sleep_forever place_beach_crack)
    	(sleep_forever place_beach_slab_pass)
    	(sleep_forever place_shaft_a_beach)
    	(sleep_forever place_shaft_a_door)

		;sleep trackers
		(sleep_forever arch_ambush_trigger)
		(sleep_forever shafta_entered_first_time_np)

		(sleep_forever foe_hammer_drop)
		(sleep_forever beach_crack_cleared)
		(sleep_forever jackals_to_valley_lid)
		(sleep_forever set_warthog_objective_1)
		(sleep_forever set_warthog_objective_2)


		; this one is an unfortunate exception tied to vo rather than the script here. see play_vo_door_is_locked and remove_entrance_navpoint.
		(sleep_forever put_np_valley_and_vo)

		;clean up remaining ai
    	(wake cleanup_lz_enemies)
		(wake cleanup_valley)
    	(wake cleanup_valley_crack)
		(wake cleanup_beach_crack)
    	(wake cleanup_beach_slab_pass)
    	(wake cleanup_shaft_a_beach)
    	(wake cleanup_shaft_a_door)
)


(script dormant place_beach_craig_dead_marines
	(object_create b30_warthog_beach_craig)
	(object_create b30_biped_marine_armored_4)
	(object_create b30_biped_marine_armored_5)
	(object_create b30_biped_marine_armored_6)
	(object_create b30_biped_marine_armored_7)
)

; todo waypoints?
(script dormant put_navpoints_beach_lz_cw
	(f_starting_navpoints beach_2d put_navpoints_beach_lz_ccw breadcrumbs_beach_cw1)
)

(script dormant put_navpoints_beach_lz_ccw
	(f_starting_navpoints beach_1 put_navpoints_beach_lz_cw breadcrumbs_beach_ccw1)
)

;todo fix the unblip.
(script static void (f_starting_navpoints (trigger_volume volume) (script to_sleep) (cutscene_flag flag))
	(sleep_until (volume_test_players volume) 1)
	(f_unblip_object v_beach_lz_warthog)
	(sleep_forever to_sleep)
	(set_navpoint flag)
	(set b_shaft_a_navpoint_shown true)
)

(script dormant set_shafta_already_seen
	(set b_shafta_seen true)
	(set b_shafta_door_locked_seen true)
)

(script dormant place_lz_enemies
    (ai_place sq_gr_beach_arch)
	(ai_place sq_gr_beach_lz)
)

(script dormant place_beach_slab_pass
	(sleep_until
		(or
			(volume_test_players beach_1)
			(volume_test_players beach_3)
		)
	1)
	(ai_place sq_gr_beach_pass)
	(ai_place sq_gr_beach_slab)

)

(script dormant place_shaft_a_beach
	(sleep_until
		(or
			(volume_test_players beach_3)
			(volume_test_players beach_5)
		)
	1)

	(ai_place sq_gr_shaft_a_entrance)
	(ai_place dropship_shafta_beach)
)

(script dormant place_valley_crack
	(sleep_until
		(volume_test_players crack_arrival_trigger)
	1)
	(ai_place sq_gr_valley_crack)
)


(script dormant place_beach_crack
	(sleep_until
		(or
			(volume_test_players beach_crack_trigger)
			(volume_test_players beach_4)
		)
	1)
	(ai_place sq_gr_beach_crack)

; this looks fragile
	(sleep_until (= s_warthog_main_objective_index 3) 1)
	(set s_warthog_main_objective_index 4)
)

(script dormant place_valley
	(sleep_until
		(volume_test_players valley_entrance)
	1)
	(ai_place sq_gr_valley_mouth)
	(ai_place sq_gr_valley_lid_hunters)
	(ai_place sq_gr_valley_canyon)
	(wake bowl_hunters_are_dead)
)
(script dormant bowl_hunters_are_dead
	(sleep_until (= (ai_living_count sq_gr_valley_lid_hunters) 0) 1)
	(print "hunters in the bowl are dead")
	(f_game_save)
)

(script dormant beach_crack_cleared
	(sleep_until (> (ai_nonswarm_count sq_gr_beach_crack) 0) 1)
	(sleep_until (= (ai_nonswarm_count sq_gr_beach_crack) 0) 1)
	(print "checkpoint beach crack")
	(f_game_save)
)

(script dormant place_shaft_a_door
	(sleep_until
		(volume_test_players shafta_entrance)
	1)

	(if (= b_shafta_unlocked false)
		(begin
			(ai_place locker_elite)
			(ai_place sq_gr_shaft_a_locked)
			(wake players_arrive_shafta)
		)
	)
)

(script dormant arch_ambush_trigger
	(sleep_until
		(or ;activate the ambush if it's the player or the marines.
			(volume_test_players beach_lz_base)
			(volume_test_objects beach_lz_base (ai_actors sq_gr_marine_beach_lz))
		)
	1)
	(set b_arch_ambush true)
)

(script dormant foe_hammer_drop
	(sleep_until (> (ai_nonswarm_count sq_gr_beach_arch) 0) 1)

	(sleep_until (< (ai_nonswarm_count sq_gr_beach) 4) 1)
	(f_blip_ai sq_gr_beach 1)

	(sleep_until
		(and
			(<= (ai_nonswarm_count sq_gr_beach) 0)
			(volume_test_players beach_lz_base)
		)
	1)

	(set s_b30_music_request 30)
	(sleep (game_ticks_from_seconds 3))
	(print "checkpoint start")
	(f_game_save)

	; places foe hammer which runs command script below
	(ai_place foe_hammer_warthog_drop)
	; assign our dropship variable
	(set v_foehammer_beach (ai_vehicle_get_from_starting_location foe_hammer_warthog_drop/foe_spawn1))
)

(script dormant foehammer_warthog_delivered
	(sleep_until b_warthog_created 1)

	;reserve the drivers seat to encourage player to get in
	(ai_vehicle_reserve_seat v_beach_lz_warthog "warthog_d" true)

	; place navpoint on warthog if player hasn't entered it yet and hasn't progressed on foot
	(if (and
			(not (player_in_vehicle v_beach_lz_warthog))
			(= b_shafta_seen false)
			(= b_navpoint_loop_running false)
		)
		(f_blip_object v_beach_lz_warthog 0)
	)

	; prioritizes unique marines getting into warthog if alive, else pushes other marines to warthog drop zone
	(if (>= (ai_nonswarm_count unique_beach_lz) 1)
		(ai_vehicle_enter unique_beach_lz v_beach_lz_warthog)
		(begin ;else
			(ai_set_objective left_marine_beach_lz push_to_drop3)
			(ai_set_objective right_marine_beach_lz push_to_drop3)
		)
	)

	(sleep_until (player_in_vehicle v_beach_lz_warthog) 1)
	(f_unblip_object v_beach_lz_warthog)
	(set_navpoint breadcrumbs_beach_ccw1)
	(sleep_forever put_navpoints_beach_lz_ccw)
	(sleep_forever put_navpoints_beach_lz_cw)
	(set s_warthog_main_objective_index 0)
	(wake warthog_logic_control)

	;after the player has gotten in the warthog, allow the seat to be taken by anyone again so marines can hop in if they weren't already
	(ai_vehicle_reserve_seat v_beach_lz_warthog "warthog_d" false)
)

(script dormant shaft_a_inactive_placements
	(wake place_valley)
    (wake place_valley_crack)
	(wake place_beach_crack)
)

(script dormant cleanup_lz_enemies
	(sleep_until
		(or
			b_shafta_door_locked_seen
			b_shafta_unlocked
		)
	1)
	(print "clean up beach enemies")
	(sleep_forever foe_hammer_drop)
	(sleep_forever foehammer_warthog_delivered)
	(ai_erase sq_gr_beach_arch)
	(ai_erase sq_gr_beach_lz)
)

(script dormant cleanup_shaft_a_beach
	(sleep_until b_shafta_unlocked 1)
	(print "cleanup shaft a beach")
	(ai_erase sq_gr_shaft_a_entrance)
)

(script dormant cleanup_valley

	(sleep_until b_shafta_unlocked 1)
	(print "clean up valley")
	(ai_erase sq_gr_valley_mouth)
	(ai_erase sq_gr_valley_lid_hunters)
	(ai_erase sq_gr_valley_canyon)
)

(script dormant cleanup_beach_slab_pass
	(sleep_until
		(or
			b_shafta_door_locked_seen
			b_shafta_unlocked
		)
	1)
	(sleep_forever set_warthog_objective_1)
	(ai_erase sq_gr_beach_pass)
	(ai_erase sq_gr_beach_slab)
)

(script dormant cleanup_valley_crack
	(sleep_until b_shafta_unlocked 1)
	(print "clean up valley crack")
	(ai_erase sq_gr_valley_crack)
)

(script dormant cleanup_shaft_a_door
	(sleep_until b_shafta_unlocked 1)
	(print "clean up shaft a door")
	(ai_erase  locker_elite)
	(ai_erase sq_gr_shaft_a_locked)
)

(script dormant cleanup_beach_crack
	(sleep_until b_shafta_unlocked 1)
	(print "clean up beach crack")
	(sleep_forever place_beach_crack)
	(ai_erase sq_gr_beach_crack)
)

(script dormant players_arrive_shafta
	(sleep_until
		(or
			(<= (ai_nonswarm_count sq_gr_shaft_a_locked) 1)
			(volume_test_players shafta_entrance_fat)
		)
		1
	)

	(if
		(< s_warthog_main_objective_index 3)
		(set s_warthog_main_objective_index 3)
	)

	(sleep_until (volume_test_players shafta_door_warning) 1)

	(sleep_until
		(or
			(= (ai_nonswarm_count sq_gr_shaft_a_locked) 0)
			(volume_test_players shafta_slam)
		)
		1
		(game_ticks_from_seconds 4)
	)

	; slamming shut, want to better allow for this later so things progress as expected
	; (sleep (game_ticks_from_seconds 0.5))
	(device_set_position shaft_a_door_controled 0)

	(sleep (game_ticks_from_seconds 1))
	(if
		; didn't make it through
		(not (volume_test_players shafta_window_inv))
		(begin
			; locked, you'll meet the elite later
			(set b_shafta_door_locked_seen true)
		)
	)
)

(script dormant jackals_to_valley_lid
	(sleep_until (volume_test_players valley_mouth) 1)
	(f_ai_magically_see_players sq_gr_valley_mouth)
)

(script dormant shafta_entered_first_time_np
	(sleep_until
		(or
        ; todo: fix this. should only be a single area.
			(volume_test_players exit_cartographer_trigger1)
			(volume_test_players exit_cartographer_trigger2)
			(volume_test_players exit_cartographer_trigger3)
		)
	1)
	(sleep_forever navpoint_beach_loop_1)
	(set b_navpoint_loop_running false)
	(f_unblip_all)
	(f_blip_flag navpoint_locked_door 0)
)

(script dormant shafta_seen
	(sleep_until
		(volume_test_players beach_3)
	1)
	(set b_shafta_seen true)
)

(script dormant set_warthog_objective_1
	(sleep_until (or (> (ai_nonswarm_count sq_gr_beach_pass) 0) (> (ai_nonswarm_count sq_gr_beach_slab) 0)) 1)
	(sleep_until (and (= (ai_nonswarm_count sq_gr_beach_pass) 0) (= (ai_nonswarm_count sq_gr_beach_slab) 0)) 1)
	(if (< s_warthog_main_objective_index 1)
		(set s_warthog_main_objective_index 1))
)

(script dormant set_warthog_objective_2
	(sleep_until (> (ai_nonswarm_count sq_gr_shaft_a_entry) 0) 1)
	(sleep_until (= (ai_nonswarm_count sq_gr_shaft_a_entry) 0) 1)

	(if (< s_warthog_main_objective_index 2)
		(set s_warthog_main_objective_index 2))
)

(script dormant obj_find_map_room
	(f_hud_obj_new "obj_b30_map" "obj_b30_map")
)

;====================================================================================================================================================================================================
; beat 2: mission shaft b:
;
; the mission begins after the security protocol is activated and the door to shaft a is locked.
; the master chief is then asked to leave shaft a and try to find the security system's override, which is located in shaft b.
; therefore, he must leave shaft a and continue along the beach to fight his way through the interior of the island to shaft b,
; where, thanks to the hollow panel he closes the security protocol and reopens the door to shaft a.

; cesar note: this doesn't account for the possibility that the player never goes to see shaft a's door lock.
; we still want to keep beat 1's encounters going until the player makes that possibility irrelevant (actually engaging with shaft b's controls)
;====================================================================================================================================================================================================

(script dormant mission_shaftb
	(submit_incident_with_custom_string_id "game_activity_begin" "b30")
	(sleep_until (volume_test_players valley_back) 1)

	; placers
	(wake place_shaft_b_entrance)
	(wake place_shaft_b_hunters)

	; trackers
	(wake shaft_b_navpoints_swap)
    (wake shafta_unlocked)
	(wake shaft_b_hunters_cleared)

	; cleaners
	(wake cleanup_shaft_b_entrance)
	(wake cleanup_shaft_b_hunters)

	; vo music and sfx
    (wake vo_beat_two)
	(wake chatter_hunter_shaft_b)
	(wake shaft_b_entrance_music_trigger)
)

(script dormant shafta_unlocked
	(sleep_until
	  ; this sleep until waits the shaftb switch that unlocks the sc in shaft a is used
	  (= (device_get_position shaftb_control) 1)
	1)
    (print "security disabled")
	(if (< s_warthog_main_objective_index 7)
		(set s_warthog_main_objective_index 7))

    (f_play_cinematic cinematics\b30\b30_door.cinematic ps_shaftb_teleport_points)
	(set b_door_cinematic_played true)
	(wake chapter_down)
	(sleep 10)
	(f_set_shafta_unlocked)
	(set s_b30_music_request 71)
	(print "checkpoint shaft b console")
	(f_game_save)
)

(script static void f_set_shafta_unlocked
	(set b_shafta_unlocked true)
	(device_set_position shaft_a_door_controled 1)
)

;todo navpoint rework
(script dormant shaft_b_navpoints_swap
	(sleep_until (and b_shafta_door_locked_seen (volume_test_players shaftb_entrance)) 1)
	(f_unblip_flag navpoint_sub_station)
	(sleep_until (volume_test_players shaftb_control_hall ) 1)
	(f_blip_flag navpoint_security_room 0)
	(sleep_until (volume_test_players shaftb_control_entrance) 1)
	(f_unblip_flag navpoint_security_room)
)

(script dormant place_shaft_b_entrance
	(ai_place sq_gr_shaftb_entrance)

)

(script dormant place_shaft_b_hunters
	(sleep_until
		(volume_test_players shaft_b_wide_trigger)
	1)
	(ai_place sq_gr_shaft_b_hunters)
	(sleep_until (= (ai_nonswarm_count sq_gr_shaft_b_hunters) 0)  1)
	(f_game_save) ;save the game
)

(script dormant shaft_b_hunters_cleared
	(sleep_until (> (ai_nonswarm_count wide_hunters) 0) 1)
	(sleep_until (<= (ai_nonswarm_count wide_hunters) 0) 1)
	(print "checkpoint shaft b wide")
    (f_game_save)

)

(script command_script cs_hunter_left_pointset
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_go_to blampointset_left_hunter/p0)
)

(script command_script cs_hunter_right_pointset
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_go_to blampointset_right_hunter/p0)
)

(script dormant cleanup_shaft_b_hunters
	(sleep_until
		(and
			b_shafta_unlocked
			(volume_test_players begin_zone_set:set_shafta_inside)
		)
		1
	)
	(sleep_forever shaft_b_hunters_cleared)
	(ai_erase wide_hunters)
)

(script dormant cleanup_shaft_b_entrance
	(sleep_until
		; sleep until player enters the area around sc unlock controls
		(volume_test_players shaftb_control_entrance)
	1)
    (ai_erase sq_gr_shaftb_entrance)
)

;todo fix the blip
(script dormant remove_entrance_navpoint
	(sleep_until (volume_test_players shafta_platform) 1)
	(f_unblip_flag navpoint_main_facility)

	(if (and b_valley_entrance_seen (not b_shaft_b_dawdled))
		(begin
			(f_unblip_all)
			(wake put_np_valley_and_vo)
		)
	)
)

; pulled this function out of the audio script file for this mission
(script dormant check_valley_entrance
	(sleep_until (volume_test_players valley_entrance) 1)
	(set b_valley_entered true)
)

;todo fix the blip
(script dormant put_np_valley_and_vo
	(wake check_valley_entrance)
	(f_unblip_all)
	(f_blip_flag navpoint_path_entrance 0)

	(sleep_until b_valley_entered 1)
	(f_unblip_all)
	(f_blip_flag navpoint_jackal_forest 0)

	(sleep_until (volume_test_players valley_mouth) 1)
	(f_unblip_all)
	(sleep (* 30 4))
	(f_blip_flag navpoint_sub_station 0)
	(sleep_until (volume_test_players shaftb_entrance_ramp) 1)
)

;this needs to be in a dorman script because it has a sleep
(script dormant obj_door_is_locked
	(f_hud_obj_new "obj_b30_override" "obj_b30_override") ; find the main facility security override
)

;====================================================================================================================================================================================================
; beat 3: mission return to shaft a:
;
; the mission begins after closing the security protocol and re-unlocking the door to shaft a.
; the master chief must now return to the facility in shaft a via the landing zone.
; upon leaving shaft b, the player learns that the foe hammer bravo-22 has been shot down and that the landing zone needs to be cleared of covenant units again.
; at the same time, it is possible to use the heavy weapons that were on board bravo-22.
;====================================================================================================================================================================================================
(script dormant mission_return_to_shafta
	(sleep_until b_shafta_unlocked 1)
	(submit_incident_with_custom_string_id "game_activity_begin" "b30")
	(wake check_shaft_a_doors_unlocked)

	; place the downed pelican, units and equipment on the beach --------------------------------------------------------------------------------------- downed pelican
	(wake placed_downed_pelican)
	(if (game_is_cooperative) (wake multiplayer_placement_wreckage))

	; vo music
	(wake vo_beat_three)
	(wake shaft_b_inv_elite_music)
	(wake shaft_b_inv_exit_music)

	;placers
	(wake place_shaft_b_exit)
	(wake place_shaft_b_inv)
	(wake place_dropship_lid)
	(wake place_shaft_a_entrance_again)

	;trackers
	(wake dropship_lid_cleared)

	;cleaners
	(wake cleanup_shaft_b_inv)
	(wake cleanup_shaft_b_exit)
	(wake cleanup_dropship_lid)
	(sleep_forever vo_beat_two)
)

(script dormant navpoints_to_shafta_awake
	(f_navpoints_to_shafta)
)

;todo fix the blip
(script static void f_navpoints_to_shafta
	(f_unblip_all)
	(f_blip_flag navpoint_sub_station 0)
	(sleep_until (volume_test_players shaftb_entrance_ramp) 1)
	(f_unblip_flag navpoint_sub_station)
	(set_navpoint breadcrumbs_beach_cw1)
	(wake navpoint_beach_loop_2)
	(sleep_until
		(and
			(or ; one of the triggers at the entrance to the cartographer is hit
  				(volume_test_players exit_cartographer_trigger1)
				(volume_test_players exit_cartographer_trigger2)
				(volume_test_players exit_cartographer_trigger3))
			b_shafta_unlocked)
	1)
	(sleep_forever navpoint_beach_loop_2)
	(f_unblip_all)
	(f_blip_flag navpoint_locked_door 0)
	(sleep_until (volume_test_players shafta_lock_door) 1)
	(f_unblip_flag navpoint_locked_door)
)
(script dormant shaft_b_dawdle_nav_point
	(f_dawdle_shaft_b_navpoint)
)
(script static void f_dawdle_shaft_b_navpoint
	;if the dawdle line for shaft b plays (play_vo_dawdle_shaftb in b30_audio.hsc), disable the breadcrumbing and just nav point directly to shaft b
	(set b_shaft_b_dawdled true)
	(f_blip_flag navpoint_sub_station 0)
	(sleep_until (volume_test_players shaftb_entrance_ramp) 1)
	(f_unblip_flag navpoint_sub_station)
)
(script dormant check_shaft_a_doors_unlocked
	; make sure the doors are open when going into the cartographer (depending on b_shafta_unlocked being true).
	; when starting from an insertion point in shaft b, when the player presses the button, it actually locks the doors. pressing it again does nothing.
	; when starting from that insertion point, we don't know whether the player is going to press the button => let's make sure the doors are open either way
	; disabling the button at that insertion point altogeher dosn't work
	(sleep_until
		(and
        ; todo fix this. should be a single area
			(or ; one of the triggers at the entrance to the cartographer is hit
  				(volume_test_players exit_cartographer_trigger1)
				(volume_test_players exit_cartographer_trigger2)
				(volume_test_players exit_cartographer_trigger3)
			)
			(= b_shafta_unlocked true) ; and the global bool flagging that the doors should be unlocked is set to true
		)
	1)
	; open sesame:
	(print "unlocking shaft a door")
	(device_set_position shaft_a_door_controled 1)
)

(script dormant placed_downed_pelican
	; create objects in the downed pelican area
	; this is likley not happening at insertion points when needed
	; works for shaft b ins, not certain about others
	(object_create b30_scenery_pelican_crashed)
	(device_set_position_immediate dm_vfx_crashsite 0.5) ; activate crashsite vignette machine
	;(effect_new "objects\levels\halo1\solo\b30\fx\pelican_crash_site\pelican_crash_site" fl_pelican_crash_intro)
	(object_create b30_warthog_pelican_crashed)
	(object_create b30_downed_marine1)
	(object_create b30_downed_marine2)
	(object_create b30_downed_marine3)
	(object_create b30_weapons_assault_rifle_0)
	(object_create b30_weapons_assault_rifle_1)
	(object_create b30_weapons_assault_rifle_2_pelican)
	(object_create b30_equipment_frag_grenade_9)
	(object_create b30_equipment_frag_grenade_10)
	(object_create b30_equipment_frag_grenade_11)
	(object_create b30_equipment_frag_grenade_12)
	(object_create b30_weapons_pistol_3_pelican)
	(object_create b30_weapons_rocket_launcher_6)
	(object_create b30_weapons_assault_rifle_6)
	(object_create b30_weapons_pistol_11)
	(object_create b30_weapons_rocket_launcher_5)
	(object_create_folder fo_downed_pelican_equipment)
	(object_create_folder fo_downed_pelican_damage_effects)
)

(script dormant place_shaft_b_exit
	(sleep_until (volume_test_players shaftb_entrance_inv) 1)
	(ai_place sq_gr_downed)

)

(script dormant place_shaft_b_inv
	(sleep_until (volume_test_players shaftb_control_hall) 1)
	(ai_place sq_gr_shaft_b_elites)

)

(script dormant place_shaft_a_entrance_again
	(sleep_until
		(and
			(volume_test_players shafta_beach)
			(= b_shafta_unlocked true)
		)
	1)
	; place entrance_again platform units
	(ai_place sq_gr_shafta_active)

	; despawn any units that were on the platfrom before but not engaged with
	(ai_erase left_platform_grunt)
	(ai_erase right_platform_grunt)
	(ai_erase platform_elite)

	(sleep_until (= (ai_nonswarm_count sq_gr_shafta_active) 0)  1)
	(f_game_save) ;save the game
)

(script dormant place_dropship_lid
	(sleep_until
		(and
			(volume_test_players valley_back)
			(= b_shafta_unlocked true)
		)
	1)
	; enable debug printing from the global fork script
	(set b_debug_fork true)
	; place the dropship which executes command script cs_dropship_lid
	(ai_place sq_gr_valley_lid_inv)
	; assign our dropship variable
	(set v_dropship_lid (ai_vehicle_get_from_starting_location sq_dropship_lid/pilot_spawn))

	(vehicle_load_magic v_dropship_lid "fork" (ai_actors sq_gr_dropship_left))
	(vehicle_load_magic v_dropship_lid "fork" (ai_actors sq_gr_dropship_right))
)

(script dormant dropship_lid_cleared
	(sleep_until (> (ai_nonswarm_count sq_gr_valley_lid_inv) 0) 1)
    (sleep_until (<= (ai_nonswarm_count sq_gr_valley_lid_inv) 0) 1)
	(if (< s_warthog_main_objective_index 8)
		(set s_warthog_main_objective_index 8))
	(print "checkpoint lid dropship cleared")
	(f_game_save)
)

(script dormant cleanup_dropship_lid
    (sleep_until (and
        ; todo fix this
			(or ; one of the triggers at the entrance to the cartographer is hit
  				(volume_test_players exit_cartographer_trigger1)
				(volume_test_players exit_cartographer_trigger2)
				(volume_test_players exit_cartographer_trigger3)
			)
		    (= b_shafta_unlocked true)
			) 1)
    (sleep_forever dropship_lid_cleared)
    (ai_erase sq_gr_valley_lid_inv)
)

(script dormant cleanup_shaft_b_inv
    (sleep_until (volume_test_players shafta_entrance_fat) 1)
	(ai_erase sq_gr_shaft_b_elites)
)

(script dormant cleanup_shaft_b_exit
    (sleep_until (volume_test_players shafta_entrance_fat) 1)
	(ai_erase sq_gr_downed)
)


(script dormant cleanup_shaft_a_entrance_again
    (sleep_until (or
    ;todo fix this
		(volume_test_players map_room)
		(volume_test_players map_room2)
	)1)
    (ai_erase sq_gr_shafta_active)
)


;this needs to be in a dorman script because it has a sleep
(script dormant obj_after_door_unlocked
	(f_hud_obj_new "obj_b30_findsilent" "obj_b30_findsilent")
)

;====================================================================================================================================================================================================
; beat 4: mission shaft a inside:
;
; the mission begins at the open door in shaft a, where the master chief goes deeper into the facility.
; inside the facility, he must fight through a large number of covenant units, including hunters,
; and on the lowest floor of the facility, they activate the silent cartographer using a holo-panel.
;====================================================================================================================================================================================================

(script dormant mission_shafta_inside
	(sleep_until
		(and
			(= b_shafta_unlocked true)
			(volume_test_players shafta_lock_door)
		)
		1
	)
	(submit_incident_with_custom_string_id "game_activity_begin" "b30")
	; this elite shouldn't be there when going back to shafta
	(ai_erase locker_elite)
	(sleep_until (volume_test_players shafta_ledge_approach_trigger) 1)
	(wake place_shaft_a_main)
	(wake play_m04_sc_cin03_ledge)
	(wake handle_player_skip_cinematic)
	(wake shaft_a_down_navpoint_loop)
	(wake vo_beat_four)
	(wake map_holopanel)

	(wake chapter_override)
	; place units in shaft a main if the door is unlocked when the player approaches

	(if (game_is_cooperative) (wake multiplayer_placement_shafta))

	;tracker

	;no cleanup since these squads are supposed to be here until the end of the mission.
	(sleep_forever vo_beat_three)
)

(script dormant play_m04_sc_cin03_ledge
	; sleep until player enters the ledge area
	(sleep_until (volume_test_players shafta_ledge_trigger) 1)

	(if b_play_ledge_cinematic
		(begin
			(f_play_cinematic cinematics\b30\b30_ledge.cinematic ps_teleport_players_ledge)
			(set s_b30_music_request 120)
			(print "checkpoint shaft a ledge cinematic")
			(f_game_save)
		)
	)

	(set b_play_ledge_cinematic false)
)


(script dormant handle_player_skip_cinematic
	(sleep_until (volume_test_players shafta_inv_6) 1)
	(print "we're skipping the ledge cinematic")
	(if b_play_ledge_cinematic
		(set s_b30_music_request 100)
	)
	(set b_play_ledge_cinematic false)
)

(script dormant map_holopanel
	(sleep_until
		; sleep until player enters the area around shaft a holo control panel
		(volume_test_players shafta_switch)
	1)
	(wake obj_activate_cartographer)
	(device_group_change_only_once_more_set shafta_switch_position true)
	(sleep_until
	  ; this sleep until waits the shafta switch that activates the map room is used
	  (= (device_group_get shafta_switch_position) 1)
	1)

	(print "you have activated the silent cartographer map panel!" )
	(set b_shafta_switched true)
	(device_group_set_immediate shafta_power_group 0)
	(f_unblip_all)
	(set b_cinematic_lower_weapon true)
	(f_play_cinematic cinematics\b30\b30_map.cinematic ps_silent_cartographer_teleport)
	(set b_cinematic_lower_weapon false)
)

(script dormant place_shaft_a_main
	; test for unlock done previously, no need for it here
	(sleep_until
		(and
			(volume_test_players shafta_window_inv)
			(= b_shafta_unlocked true)
		)
	1)
	(f_warthog_logic_clean_up)

	(ai_place sq_gr_shaft_a_u)
	(ai_place sq_gr_shaft_a_beam)
	(ai_place sq_gr_shaft_a_ante)
	(ai_place sq_gr_shaft_a_ante_rein)

	(wake postsave_shaft_a_h_and_j)
	(wake cleared_shafta_u)
	(wake cleared_shaft_a_ante)
	(wake cleared_shaft_a_beam)

	(sleep 15)
	(ai_activity_set shaft_a_floor_grunt/spawnpoint4 asleep)
	(ai_activity_set shaft_a_floor_grunt/spawnpoint7 asleep)
)
(script dormant postsave_shaft_a_h_and_j
	(sleep_until (= (ai_nonswarm_count sq_gr_shaft_a_u) 0)  1)
	(f_game_save) ;save the game
)
(script dormant obj_activate_cartographer
	(f_hud_obj_new "obj_b30_activate" "obj_b30_activate")
)
(script dormant cleared_shafta_u
	(sleep 30)
	(sleep_until
		(or
			(volume_test_players shafta_inv_4)
			(= (ai_nonswarm_count sq_gr_shaft_a_u) 0)
		)
	1)
	(print "checkpoint shaft a u")
	(f_game_save)
)

(script dormant cleared_shaft_a_ante
	(sleep 30)
	(sleep_until (= (ai_nonswarm_count sq_gr_shaft_a_ante) 0) 1)
	(print "checkpoint shaft a ante")
	(f_game_save)
)

(script dormant cleared_shaft_a_beam
	(sleep 30)
	(sleep_until
		(or
			(volume_test_players shafta_u_entry)
			(= (ai_nonswarm_count sq_gr_shaft_a_beam) 0)
		)
	1)
	(print "checkpoint shaft a beam")
	(f_game_save)
)

;====================================================================================================================================================================================================
; beat 5: mission shaft a exit:
;
; this mission begins after activating silent cartographer, where the master chief's task is to leave the facility
; and shoot his way through the covenant to the surface, where foe hammer will arrive to pick him up and the level ends.
;====================================================================================================================================================================================================
(script dormant mission_shafta_exit
	; if starting in the silent cartographer insertion point,
	; this variable is set up in b30_insertion.hsc file

	(sleep_until b_shafta_switched 1)
	(submit_incident_with_custom_string_id "game_activity_begin" "b30")
	(wake shaft_a_up_navpoint_loop)
	(wake place_shaft_a_inv)
	(wake exit_shaft_a_inv)

	; narrative - music vo
	(sleep_forever vo_beat_four)
	(wake vo_beat_five)
	(wake music_trigger_16)
	(wake music_trigger_17)
	(wake music_trigger_18)

	; place drop ship and last inv group wait until player sees it and fly away


	(print "checkpoint shaft a cartographer")
	(f_game_save)
)

(script dormant place_shaft_a_inv
	(sleep_until
		(and
			; are they at the silent cartographer and have they flicked the switch?
			(volume_test_players shafta_switch)
			(= b_shafta_switched true)
		)
	1)

	(wake place_sq_gr_shafta_jig)
	(wake place_sq_gr_shafta_beam_inv)
	(wake place_sq_gr_shafta_ramp_mind_inv)
	(wake place_sq_gr_shafta_u_inv)
	(wake place_locker_elite)

	(wake shaft_a_ante_checkpoint)
	(wake shaft_a_mind_inv_save)
	(wake progress_save_shafta_room_a2)

	(sleep_until (volume_test_players shafta_enable_locker_elite) 1)
	(f_game_save)
	(print "checkpoint shaft a locker elite")
	(ai_braindead yellow_elite false)
	(f_ai_magically_see_players yellow_elite)

	(sleep_until (<= (ai_nonswarm_count yellow_elite) 0) 1)
	(print "checkpoint shaft a locker elite cleared")
	(f_game_save)
)

(script dormant exit_shaft_a_inv
	(sleep_until
		(and
			(volume_test_players shafta_entrance)
			(= b_shafta_switched true)
		)
	1)

	(set b_debug_fork true)

	(wake exit_shaft_a_encounter)
	(wake exit_shaft_a_foehammer_pickup)

	; entering foehammer's pelican ends level and triggers cutscene
	(sleep_until
		(vehicle_test_seat_unit_list v_foehammer_evac "" (players))
	1)

	(submit_incident_with_custom_string_id "game_activity_end_completed" "b30")
	(f_final_cinematic)
	(game_won)

)

(script dormant exit_shaft_a_encounter
	(ai_place sq_dropship_last)
	(ai_place sq_gr_shafta_entrance_inv)
)

(script dormant exit_shaft_a_foehammer_pickup

	;wait until sq_dropship_last has left
	(sleep_until b_foehammer_pickup_begin 1)

	; foe hammer arrives at platform outside shaft a
	(ai_place foe_hammer_pickup)

	(set v_foehammer_evac (ai_vehicle_get_from_starting_location foe_hammer_pickup/foe_hammer_evac))

	(ai_disregard v_foehammer_evac true)
	(ai_disregard (ai_actors foe_hammer_pickup) true)
)

(script static void f_final_cinematic
	(print "you hop in your foe hammer and fly away")
	(f_play_cinematic cinematics\b30\b30_outro.cinematic)
)

(script dormant place_sq_gr_shafta_jig
	(sleep_until (volume_test_players shafta_inv_3) 1)
	(ai_place sq_gr_shafta_jig)
	(wake cleared_sq_gr_shafta_jig)


)
(script dormant cleared_sq_gr_shafta_jig
	(sleep 30)
	(sleep_until (= (ai_nonswarm_count sq_gr_shafta_jig) 0) 1)
	(print "checkpoint shaft a jig inv")
	(f_game_save)
)

(script dormant place_sq_gr_shafta_beam_inv
	(sleep_until (volume_test_players shafta_inv_5) 1)
	(ai_place sq_gr_shafta_beam_inv)
	(wake cleared_sq_gr_shafta_beam_inv)

)

(script dormant cleared_sq_gr_shafta_beam_inv
	(sleep 30)
	(sleep_until (= (ai_nonswarm_count sq_gr_shafta_beam_inv) 0) 1)
	(print "checkpoint shaft a beam inv")
	(f_game_save)
)

(script dormant place_sq_gr_shafta_ramp_mind_inv
	(sleep_until (volume_test_players shafta_inv_1) 1)
	(ai_place sq_gr_shafta_ramp_inv)
	(ai_place sq_gr_shafta_mind_inv)
	(wake cleared_sq_gr_shafta_ramp_mind_inv)
)

(script dormant cleared_sq_gr_shafta_ramp_mind_inv
	(sleep 30)
	(sleep_until
			(and
			(= (ai_nonswarm_count sq_gr_shafta_ramp_inv) 0)
			(= (ai_nonswarm_count sq_gr_shafta_mind_inv) 0))
	1)
	(print "checkpoint shaft a mind inv")
	(f_game_save)
)

(script dormant place_sq_gr_shafta_u_inv
	(sleep_until (volume_test_players shafta_inv_4) 1)
	(ai_place sq_gr_shafta_u_inv)
	(wake cleared_sq_gr_shafta_u_inv)
)

(script dormant cleared_sq_gr_shafta_u_inv
	(sleep 30)
	(sleep_until (= (ai_nonswarm_count sq_gr_shafta_u_inv) 0) 1)
	(print "checkpoint shaft a u inv")
	(f_game_save)
)

(script dormant progress_save_shafta_room_a2
	(sleep 30)
	(sleep_until (volume_test_players shafta_room_a2) 1)
	(print "checkpoint progress save locker elite")
	(f_game_save)
)

(script dormant place_locker_elite
	(sleep_until (volume_test_players shafta_inv_6) 1)
	; waiting for you on the way back up if you didn't squeeze through the first time
	;(if
		;b_shafta_door_locked_seen
		(ai_place yellow_elite)
	;)
)

(script dormant shaft_a_ante_checkpoint
	(sleep_until (volume_test_players shafta_ante_inv_checkpoint) 1)
	(print "checkpoint shaft a ante")
	(f_game_save)
)

(script dormant shaft_a_mind_inv_save
	(sleep_until (volume_test_players shafta_mind) 1)
	(print "checkpoint shaft a mind inv")
	(f_game_save)
)

;this needs to be in a dorman script because it has a sleep
(script dormant obj_leave_map_room
	(f_hud_obj_new "obj_b30_return" "obj_b30_return")
)

(script dormant obj_rendezvous
	(f_hud_obj_new "obj_b30_leave" "obj_b30_leave")
)

(global short s_shafta_down_index 0)
(global cutscene_flag last_blip_flag np_shaft_a_inv_3)
(global cutscene_flag current_blip_flag np_shaft_a_inv_3)
(global boolean b_nav_active false)
(global short s_nav_point_delay (game_ticks_from_seconds 1))
(global real s_unblip_distance 1)
(global real s_blip_distance 3)

(script dormant shaft_a_down_navpoint_loop
		(sleep_until
		(begin
			(shaft_a_down_nav_control)
			b_shafta_switched ;exit condition
		)
		1;run every 1 tick
	)
)

(script dormant shaft_a_up_navpoint_loop
		(sleep_until
		(begin
			(shaft_a_up_nav_control)
			(volume_test_players shafta_platform) ;exit condition
		)
		1;run every 1 tick
	)
)


(script static void shaft_a_down_nav_control

	(cond
		((f_nav_ai_aivolume_tv_check np_shaft_a_connector_a2_a3 sq_gr_shaft_a_beam shafta_room_a2) 					(f_blip_one np_shaft_a_connector_a2_a3))
		((f_navend_distance_check np_shaft_a_connector_a2_a3 s_unblip_distance)										(f_unblip_one np_shaft_a_connector_a2_a3))
		;secret shaft drop down clear
		((f_navend_volume_check np_shaft_a_connector_a2_a3 tv_shaft_a_a2_np_alt)									(f_unblip_one np_shaft_a_connector_a2_a3))

		((f_nav_ai_tv_check np_shaft_a_connector_a3_a4 sq_gr_shaft_a_u shafta_room_a3)								(f_blip_one np_shaft_a_connector_a3_a4))
		((f_navend_distance_check np_shaft_a_connector_a3_a4 s_unblip_distance)										(f_unblip_one np_shaft_a_connector_a3_a4))

		((f_nav_tv_distance_check np_shaft_a_exit_8 tv_shaft_a_np_jig_1 s_blip_distance)							(f_blip_one np_shaft_a_exit_8))
		((f_navend_distance_check np_shaft_a_exit_8 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_8))

		((f_nav_tv_distance_check np_shaft_a_exit_a3 tv_shaft_a_np_jig_2 s_blip_distance)							(f_blip_one np_shaft_a_exit_a3))
		((f_navend_distance_check np_shaft_a_exit_a3 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_a3))
	)
	(cond
		((f_nav_tv_distance_check np_shaft_a_a4_a5_1 tv_np_shaft_a_a4_1_trigger s_blip_distance)					(f_blip_one np_shaft_a_a4_a5_1))
		((f_navend_distance_check np_shaft_a_a4_a5_1 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_1))

		((f_nav_tv_distance_check np_shaft_a_a4_a5_2 tv_np_shaft_a_a4_1_trigger s_blip_distance)					(f_blip_one np_shaft_a_a4_a5_2))
		((f_navend_distance_check np_shaft_a_a4_a5_2 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_2))


		((f_nav_tv_distance_check np_shaft_a_a4_a5_3 tv_np_shaft_a_np_a4_3_trigger s_blip_distance )				(f_blip_one np_shaft_a_a4_a5_3))
		((f_navend_distance_check np_shaft_a_a4_a5_3 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_3))

		((f_nav_tv_distance_check np_shaft_a_a4_a5_4 tv_np_shaft_a_a4_2_trigger s_blip_distance)					(f_blip_one np_shaft_a_a4_a5_4))
		((f_navend_distance_check np_shaft_a_a4_a5_4 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_4))

		((f_nav_tv_distance_check np_shaft_a_a4_a5_5 tv_np_shaft_a_np_a4_4_trigger s_blip_distance)					(f_blip_one np_shaft_a_a4_a5_5))
		((f_navend_distance_check np_shaft_a_a4_a5_5 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_5))

		((f_nav_tv_distance_check np_shaft_a_a4_a5_6 tv_shaft_a_room_floor_a4 s_blip_distance)						(f_blip_one np_shaft_a_a4_a5_6))
		((f_navend_distance_check np_shaft_a_a4_a5_6 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_6))

		;alt route to a5
		((f_navend_volume_check np_shaft_a_a4_a5_6 tv_shaft_a_np_alt_a4_a5)											(f_unblip_one np_shaft_a_a4_a5_6))
	)
	(cond
		((f_nav_tv_distance_check np_shaft_a_a4_a5_7 tv_shaft_a_np_ramp s_blip_distance)							(f_blip_one np_shaft_a_a4_a5_7))
		((f_navend_distance_check np_shaft_a_a4_a5_7 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_7))

		((f_nav_ai_aivolume_tv_check np_a5_exit_a sq_gr_shaft_a_ante tv_chamber_a5)									(f_blip_one np_a5_exit_a))
		((f_navend_distance_check np_a5_exit_a s_unblip_distance)													(f_unblip_one np_a5_exit_a))

		((f_nav_tv_distance_check np_shaft_a_bottom tv_shaft_a_np_map_room_b s_blip_distance)						(f_blip_one np_shaft_a_bottom))
		((f_navend_distance_check np_shaft_a_bottom s_unblip_distance)												(f_unblip_one np_shaft_a_bottom))

		((f_nav_tv_distance_check np_shaft_a_bottom tv_shaft_a_np_map_room_a s_blip_distance)						(f_blip_one np_shaft_a_bottom))
		((f_navend_distance_check np_shaft_a_bottom s_unblip_distance)												(f_unblip_one np_shaft_a_bottom))
	)

)

(script static void shaft_a_up_nav_control
	(cond

		((f_nav_tv_distance_check np_shaft_a_exit_1 shafta_switch s_blip_distance)									(f_blip_one np_shaft_a_exit_1))
		((f_navend_distance_check np_shaft_a_exit_1 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_1))

		((f_nav_tv_distance_check np_shaft_a_exit_2 tv_shaft_a_np_map_room_a s_blip_distance)						(f_blip_one np_shaft_a_exit_2))
		((f_navend_distance_check np_shaft_a_exit_2 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_2))

		((f_nav_tv_distance_check np_shaft_a_exit_3 tv_shaft_a_np_exit_3 s_blip_distance)							(f_blip_one np_shaft_a_exit_3))
		((f_navend_distance_check np_shaft_a_exit_3 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_3))

		((f_nav_tv_or_and_dist_check np_shaft_a_exit_4 tv_shaft_a_np_exit_4 tv_shaft_a_np_exit_5 s_blip_distance)	(f_blip_one np_shaft_a_exit_4))
		((f_navend_distance_check np_shaft_a_exit_4 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_4))

		((f_nav_tv_distance_check np_shaft_a_exit_5 tv_shafta_ramp s_blip_distance)									(f_blip_one np_shaft_a_exit_5))
		((f_navend_distance_check np_shaft_a_exit_5 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_5))


		((f_nav_tv_distance_check np_shaft_a_connector_a4_a5 tv_np_shaft_a_a4_a5 s_blip_distance)					(f_blip_one np_shaft_a_connector_a4_a5))
		((f_navend_distance_check np_shaft_a_connector_a4_a5 s_unblip_distance)										(f_unblip_one np_shaft_a_connector_a4_a5))
	)
	(cond
		((f_nav_tv_distance_check np_shaft_a_a4_a5_5  tv_shaft_a_room_floor_a4 s_blip_distance)						(f_blip_one np_shaft_a_a4_a5_5))
		((f_navend_distance_check np_shaft_a_a4_a5_5 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_5))

		((f_nav_tv_distance_check np_shaft_a_a4_a5_4  tv_np_shaft_a_np_a4_exit s_blip_distance)						(f_blip_one np_shaft_a_a4_a5_4))
		((f_navend_distance_check np_shaft_a_a4_a5_4 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_4))

		((f_nav_tv_distance_check np_shaft_a_a4_a5_3  tv_np_shaft_a_a4_2_trigger s_blip_distance)					(f_blip_one np_shaft_a_a4_a5_3))
		((f_navend_distance_check np_shaft_a_a4_a5_3 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_3))

		((f_nav_tv_distance_check np_shaft_a_a4_a5_2 tv_np_shaft_a_np_a4_3_trigger s_blip_distance)					(f_blip_one np_shaft_a_a4_a5_2))
		((f_navend_distance_check np_shaft_a_a4_a5_2 s_unblip_distance)												(f_unblip_one np_shaft_a_a4_a5_2))

		((f_nav_tv_distance_check np_shaft_a_exit_a3  tv_np_shaft_a_a4_1_trigger_exit s_blip_distance)				(f_blip_one np_shaft_a_exit_a3))
		((f_navend_distance_check np_shaft_a_exit_a3 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_a3))

		((f_nav_tv_distance_check np_shaft_a_exit_8 tv_shaft_a_np_jig_2 s_blip_distance)							(f_blip_one np_shaft_a_exit_8))
		((f_navend_distance_check np_shaft_a_exit_8 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_8))
	)
	(cond
		((f_nav_ai_tv_check np_shaft_a_exit_a3 sq_gr_shafta_mind_inv tv_np_shaft_a_a4_1_trigger_exit)				(f_blip_one np_shaft_a_exit_a3))
		((f_navend_distance_check np_shaft_a_exit_a3 s_unblip_distance)												(f_unblip_one np_shaft_a_exit_a3))

		((f_nav_ai_tv_check np_shaft_a_room_a3 sq_gr_shafta_u_inv shafta_room_a3)									(f_blip_one np_shaft_a_room_a3))
		((f_navend_distance_check np_shaft_a_room_a3 s_unblip_distance)												(f_unblip_one np_shaft_a_room_a3))

		((f_nav_ai_tv_check np_shaft_a_inv_3 sq_gr_shafta_beam_inv shafta_room_a2)									(f_blip_one np_shaft_a_inv_3))
		((f_navend_distance_check np_shaft_a_inv_3 s_unblip_distance)												(f_unblip_one np_shaft_a_inv_3))

		((volume_test_players shafta_inv_6)																			(f_blip_one navpoint_locked_door))
		((f_navend_distance_check navpoint_locked_door 0.5)															(f_unblip_one navpoint_locked_door))

		((f_nav_ai_tv_check np_shaft_a_exit_10 yellow_elite shafta_window)											(f_blip_one np_shaft_a_exit_10))
		((f_navend_distance_check np_shaft_a_exit_10 3)																(f_unblip_one np_shaft_a_exit_10))
	)

)

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
(script static void (f_unblip_one (cutscene_flag f))
	(set last_blip_flag f)
	(f_unblip_flag last_blip_flag)
	(set b_nav_active false)
)

(script static boolean (f_nav_ai_tv_check (cutscene_flag f) (ai encounter_squad )(trigger_volume tv_nav))

	(and
		(<= (ai_nonswarm_count encounter_squad) 0)
		(volume_test_players tv_nav)
	)
)

(script static boolean (f_nav_ai_tv_dist_check (cutscene_flag f) (ai encounter_squad )(trigger_volume tv_nav)(real d))

	(and
		(<= (ai_nonswarm_count encounter_squad) 0)
		(volume_test_players tv_nav)
		(> (objects_distance_to_flag (players) f) d)
	)
)

(script static boolean (f_nav_ai_aivolume_tv_check (cutscene_flag f) (ai encounter_squad )(trigger_volume tv_nav))

	(and

		(or
			(<= (ai_nonswarm_count encounter_squad) 0)
			(not (volume_test_objects tv_nav encounter_squad))
		)
		(volume_test_players tv_nav)
	)
)

(script static boolean (f_nav_tv_distance_check (cutscene_flag f)(trigger_volume tv_nav)(real d))

	(and
		(> (objects_distance_to_flag (players) f) d)
		(volume_test_players tv_nav)
	)
)

(script static boolean (f_nav_tv_or_and_dist_check (cutscene_flag f)(trigger_volume tv_nav1)(trigger_volume tv_nav2)(real d))

	(and
		(> (objects_distance_to_flag (players) f) d)
		(or
			(volume_test_players tv_nav1)
			(volume_test_players tv_nav2)
		)
	)
)

;===============================
; ==== chapter title scripts ====
;===============================

(script dormant chapter_insertion

	(f_hud_chapter insertion)
)

(script dormant chapter_down

	(f_hud_chapter down)
)

(script dormant chapter_override

	(f_hud_chapter override)
)

;========================
; ==== unlock scripts ====
;========================

(script dormant b30_rally_point_unlocks

	(wake b30_unlock_rally_point_bravo)
	(wake b30_unlock_rally_point_charlie)
	(wake b30_unlock_next_level)
)

(script dormant b30_unlock_rally_point_bravo
	(sleep_until
		(or
			(f_insertion_point_script_is_blocked insertion_shaft_a_inactive)
			(volume_test_players shafta_entrance_fat)
		)
	1)

	(f_unlock_insertion_point_with_incident_name "ins_b30_shaft_a_inactive")
)

(script dormant b30_unlock_rally_point_charlie
	(sleep_until
		(volume_test_players shafta_ledge_approach_trigger)
	1)

	(f_unlock_insertion_point_with_incident_name "ins_b30_shaft_a_active")
)

(script dormant b30_unlock_next_level
	(sleep_until
		(vehicle_test_seat_unit_list v_foehammer_evac "" (players))
	1)

	(f_unlock_insertion_point_with_incident_name "unlock_b40")
)

;===================================================================================================================================
; === nav points helper function ===================================================================================================
;===================================================================================================================================

; unblip all flags
(script static void (f_unblip_all)
	(f_unblip_object v_beach_lz_warthog)
	(f_unblip_flag navpoint_main_facility)
	(f_unblip_flag navpoint_sub_station)
	(f_unblip_flag navpoint_path_entrance)
	(f_unblip_flag navpoint_jackal_forest)
	(f_unblip_flag navpoint_locked_door)
	(f_unblip_flag navpoint_security_room)
	(f_unblip_flag breadcrumbs_beach_ccw1)
	(f_unblip_flag breadcrumbs_beach_ccw2)
	(f_unblip_flag breadcrumbs_beach_cw1)
	(f_unblip_flag breadcrumbs_beach_cw2)
	(f_unblip_flag np_shaft_a_inv_3)
	(f_unblip_flag np_shaft_a_room_a3)
	(f_unblip_flag navpoint_shafta_inv_4)
)

(script static void (set_navpoint (cutscene_flag flag))
	(f_blip_flag flag 0)
	(set fl_active_flag flag)
)

(script static void (set_transient_navpoint (cutscene_flag flag))
	(f_blip_flag flag 0)
	(set fl_active_flag flag)
)

(script static void (set_primary_navpoint (cutscene_flag flag))
	(f_blip_flag flag 0)
	(set fl_active_flag flag)
)

(script static void (set_navpoint_on_object (object object))
	(f_blip_object object 0)
	(set active_object object)
)

(script static void (f_navpoints_double_gate (trigger_volume volume1) (trigger_volume volume2) (cutscene_flag flag1) (cutscene_flag flag2))
	(sleep_until (or (volume_test_players volume1) (volume_test_players volume2)) 1)
	(f_unblip_all)
	(if (volume_test_players volume1)
		(set_navpoint flag1)
		(set_navpoint flag2)) ; else
)

(script static void (f_navpoints_triple_gate (trigger_volume volume1) (trigger_volume volume2) (trigger_volume volume3) (cutscene_flag flag1) (cutscene_flag flag2) (cutscene_flag flag3))
	(sleep_until (or (volume_test_players volume1) (volume_test_players volume2) (volume_test_players volume3)) 1)
	(f_unblip_all)
	(cond
		((volume_test_players volume1) (set_navpoint flag1))
		((volume_test_players volume2) (set_navpoint flag2))
		((volume_test_players volume3) (set_navpoint flag3)))
)

(script dormant navpoint_beach_loop_1
	(set b_navpoint_loop_running true)
	(sleep_until
		(begin
			(cond
				((= fl_active_flag breadcrumbs_beach_ccw1) (f_navpoints_double_gate breadcrumb_ccw1_trigger navpoints_cw_trigger navpoint_main_facility breadcrumbs_beach_cw1))
				((= fl_active_flag breadcrumbs_beach_cw1) (f_navpoints_double_gate beach_crack_trigger navpoints_ccw_trigger breadcrumbs_beach_cw2 breadcrumbs_beach_ccw1))
				((= fl_active_flag breadcrumbs_beach_cw2) (f_navpoints_double_gate beach_shafta_trigger downed_trigger navpoint_main_facility breadcrumbs_beach_cw1))
				((= fl_active_flag navpoint_main_facility) (f_navpoints_double_gate valley_arrival_trigger beach_1 breadcrumbs_beach_cw2 breadcrumbs_beach_ccw1))
			)
			false) 1)
)

(script dormant navpoint_beach_loop_2
	(sleep_until
		(begin
			(cond
				((= fl_active_flag breadcrumbs_beach_ccw1) (f_navpoints_double_gate breadcrumb_ccw1_trigger navpoints_ccw_trigger navpoint_main_facility breadcrumbs_beach_ccw2))
				((= fl_active_flag breadcrumbs_beach_ccw2) (f_navpoints_double_gate beach_1 beach_2c breadcrumbs_beach_ccw1 breadcrumbs_beach_cw1))
				((= fl_active_flag breadcrumbs_beach_cw1) (f_navpoints_triple_gate beach_backward_trigger beach_crack_trigger valley_back breadcrumbs_beach_ccw2 breadcrumbs_beach_cw2 breadcrumbs_beach_cw2))
				((= fl_active_flag breadcrumbs_beach_cw2) (f_navpoints_triple_gate beach_shafta_trigger downed_trigger downed_trigger_2 navpoint_main_facility breadcrumbs_beach_cw1 breadcrumbs_beach_cw1))
				((= fl_active_flag navpoint_main_facility) (f_navpoints_double_gate valley_arrival_trigger beach_1 breadcrumbs_beach_cw2 breadcrumbs_beach_ccw1))
			)
			false) 1)
)

(script dormant roaming_game_save
	; for b30's less structured exploration, attempt a standard save (with 8 second safety timeout) after zone set transitions
	; which is a good player progression mark of deliberate roaming around the island
	(sleep_until
		(begin
			; zone set switching
			(sleep_until (= (current_zone_set_fully_active) -1) 1)
			; zone set switched
			(sleep_until (!= (current_zone_set_fully_active) -1) 1)

			; save if safe
			(game_save)
			(print "roaming_game_save")
			(sleep_until (not (game_saving)) 1)

			; 30 second cooloff
			(sleep (game_ticks_from_seconds 30))

			false
		)
		(game_ticks_from_seconds 1.0)
	)
)

;====================================================================================================================================================================================================
; command scripts: ===================================================================================================================================================================================
;====================================================================================================================================================================================================

(script command_script cs_specops_5_a_camo
    (ai_set_active_camo ai_current_actor true) ;forcing the camo use so they arent so visible when we bring them in the scene
)

;===========================
; ==== dropship scripts ====
;===========================
(script command_script cs_dropship_beach
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(sleep (game_ticks_from_seconds 3))
	; entry flight path, flies to each point in sequence
	(cs_vehicle_speed 0.25)
	(cs_fly_by ps_dropship_beach_flightpath/p0)
	(cs_vehicle_speed 1)
	(cs_fly_to ps_dropship_beach_flightpath/p1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	; play sfx for spirit warp out sequence
	(sound_impulse_start sound\vehicles\tuning_fork\spirit_warp_out (ai_vehicle_get ai_current_actor) 1)
	(cs_fly_by ps_dropship_beach_flightpath/p2)

	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script command_script cs_dropship_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_fly_by ps_dropship_lid_flightpath/p0)
	(cs_vehicle_speed 0.5)
	(cs_fly_by ps_dropship_lid_flightpath/p1)
	(cs_vehicle_speed 0.2)
	(cs_fly_by ps_dropship_lid_flightpath/p2)

	; open hatches, wait one second, unload all passengers with the global function, wait three seconds for them to exit, and then close hatches
	(unit_open v_dropship_lid)
	(sleep 30)
	(f_unload_fork_all v_dropship_lid)
	(sleep 120)
	(unit_close v_dropship_lid)
	(cs_fly_by ps_dropship_lid_flightpath/p6)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_dropship_lid_flightpath/p3)
	(cs_fly_by ps_dropship_lid_flightpath/p4)
	(cs_fly_by ps_dropship_lid_flightpath/p5)
	; play sfx for spirit warp out sequence
	(sound_impulse_start sound\vehicles\tuning_fork\spirit_warp_out (ai_vehicle_get ai_current_actor) 1)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script command_script cs_last_dropship
	(set v_dropship_last (ai_vehicle_get_from_starting_location sq_dropship_last/pilot_spawn))

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(unit_open v_dropship_last)
	(sleep (game_ticks_from_seconds 15))

	(unit_close v_dropship_last)
	(sleep (game_ticks_from_seconds 2))

	;area is clear for foehammer to arrive
	(set b_foehammer_pickup_begin true)

	(cs_vehicle_speed 0.25)
	(cs_fly_by ps_dropship_last_flightpath/p1)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_dropship_last_flightpath/p2)
	(cs_fly_by ps_dropship_last_flightpath/p3)
	(cs_fly_to ps_dropship_last_flightpath/p4 1)
	(print "last dropship flyby")
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 90)
	; play sfx for spirit warp out sequence
	(sound_impulse_start sound\vehicles\tuning_fork\spirit_warp_out v_dropship_last 0)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

;=========================================================================================================================
; global fork section ====================================================================================================
;=========================================================================================================================

; everything below is copied from global_fork.hsc as we do not yet support additional script source files for scenarios
(global boolean b_debug_fork false)

; == load parameters ==
; left, right, default, left_full, right_full, full
(script static void (f_load_fork (vehicle fork) (string load_side) (ai load_squad_01) (ai load_squad_02) (ai load_squad_03) (ai load_squad_04))
	(ai_place load_squad_01)
	(ai_place load_squad_02)
	(ai_place load_squad_03)
	(ai_place load_squad_04)
	(sleep 1)

	(cond
		; left
		((= load_side "left")
			(begin
				(if b_debug_fork (print "load fork left..."))
				(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_l")
				(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_l")
				(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_l")
				(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_l")
			)
		)
		; right
		((= load_side "right")
			(begin
				(if b_debug_fork (print "load fork right..."))
				(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_r")
				(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_r")
				(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_r")
				(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_r")
			)
		)
		; dual
		((= load_side "dual")
			(begin
				(if b_debug_fork (print "load fork dual..."))
				(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_l")
				(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_l")
				(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_r")
				(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_r")
			)
		)

		((= load_side "any")
			(begin
				(if b_debug_fork (print "load fork any..."))
				(ai_vehicle_enter_immediate load_squad_01 fork "fork_p")
				(ai_vehicle_enter_immediate load_squad_02 fork "fork_p")
				(ai_vehicle_enter_immediate load_squad_03 fork "fork_p")
				(ai_vehicle_enter_immediate load_squad_04 fork "fork_p")
			)
		)
	)
)

; call this script when the fork is in place to drop off all the ai
(script static void (f_unload_fork (vehicle fork) (string drop_side))
	(if b_debug_fork (print "opening fork..."))
	(unit_open fork)
	(sleep 30)

	; determine how to unload the phantom
	(cond
		((= drop_side "left")
			(begin
				(f_unload_fork_left fork)
				(sleep 75)
			)
		)

		((= drop_side "right")
			(begin
				(f_unload_fork_right fork)
				(sleep 75)
			)
		)

		((= drop_side "dual")
			(begin
				(f_unload_fork_all fork)
				(sleep 75)
			)
		)
	)

	(if b_debug_fork (print "closing fork..."))
	(unit_close fork)
)

(script static void (f_unload_fork_left	(vehicle fork))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_l1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l8")
			(sleep (random_range 0 10))
		)
	)
)

(script static void (f_unload_fork_right (vehicle fork))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_r1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r8")
			(sleep (random_range 0 10))
		)
	)
)

(script static void (f_unload_fork_all	(vehicle fork))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_l1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l8")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r8")
			(sleep (random_range 0 10))
		)
	)
)


;===========================
; ==== starting pelican ====
;===========================
(script command_script cs_start_pelican_left
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; reserve player seats
	(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "pelican_p_l05" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "pelican_p_r05" true)

	(ai_place sq_gr_left_marine_beach_lz)
	(ai_vehicle_enter_immediate sq_gr_left_marine_beach_lz (ai_vehicle_get ai_current_actor) "pelican_p_r")

	;landing gear set to down
	(object_set_function_variable (ai_vehicle_get ai_current_actor) "landing_gear" 0.7 0.1)

	(cs_fly_to_and_face start_pelican_left_flightpath/td start_pelican_left_flightpath/td_face 0.1)

	(sleep_until b_pelicans_unload 1)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l05")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r05")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l04")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r04")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l03")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r03")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l02")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r02")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r01")

	(sleep 200)
	(cs_vehicle_speed 0.3)
	; play sfx for pelican takeoff and flyby sweetener
	(sound_impulse_start sound\vehicles\pelican\pelican_takeoff (ai_vehicle_get ai_current_actor) 0)
	(sound_impulse_start sound\vehicles\pelican\pelican_flyby_sweetener (ai_vehicle_get ai_current_actor) 0)

	;landing gear set to up
	(object_set_function_variable (ai_vehicle_get ai_current_actor) "landing_gear" 0 10)
	(unit_open (ai_vehicle_get ai_current_actor))

	(cs_fly_by start_pelican_left_flightpath/p0)
	(cs_vehicle_speed 1)
	(cs_fly_by start_pelican_left_flightpath/p1)
	(cs_fly_by start_pelican_left_flightpath/p2)
	(cs_fly_by start_pelican_left_flightpath/p3)
	(cs_fly_by start_pelican_left_flightpath/p4)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 90)
	; play sfx for pelican fly out sequence
	(sound_impulse_start sound\vehicles\pelican\pelican_fly_out (ai_vehicle_get ai_current_actor) 0)
	(cs_fly_by start_pelican_left_flightpath/p5)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script command_script cs_start_pelican_right
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; reserve player seats
	(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "pelican_p_l05" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "pelican_p_r05" true)

	(ai_place sq_gr_right_marine_beach_lz)
	(ai_vehicle_enter_immediate sq_gr_right_marine_beach_lz (ai_vehicle_get ai_current_actor) "pelican_p_r")

	;landing gear set to down
	(object_set_function_variable (ai_vehicle_get ai_current_actor) "landing_gear" 0.8 0.1)

	(cs_fly_to_and_face start_pelican_right_flightpath/td start_pelican_right_flightpath/td_face 0.1)

	(sleep_until b_pelicans_unload 1)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l05")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r05")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l04")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r04")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l03")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r03")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l02")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r02")
	(sleep 10)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r01")

	(sleep 300)
	(cs_vehicle_speed 0.3)

	;landing gear set to up
	(object_set_function_variable (ai_vehicle_get ai_current_actor) "landing_gear" 0 10)
	(unit_open (ai_vehicle_get ai_current_actor))

	(cs_fly_by start_pelican_right_flightpath/p0)
	; play sfx for pelican takeoff
	(sound_impulse_start sound\vehicles\pelican\pelican_takeoff (ai_vehicle_get ai_current_actor) 0)
	(cs_vehicle_speed 1)
	(cs_fly_by start_pelican_right_flightpath/p1)
	(cs_fly_by start_pelican_right_flightpath/p2)
	(cs_fly_by start_pelican_right_flightpath/p3)
	(cs_fly_by start_pelican_right_flightpath/p4)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 90)
	; play sfx for pelican fly out sequence
	(sound_impulse_start sound\vehicles\pelican\pelican_fly_out (ai_vehicle_get ai_current_actor) 0)
	(cs_fly_by start_pelican_right_flightpath/p5)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

;=====================================
; ==== foe hammer warthog delivery ===
;=====================================
(script command_script cs_fh_warthog_drop
	(sleep 1)
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(submit_incident_with_custom_string_id game_activity_end_completed b30_task1)

	(unit_open (ai_vehicle_get_from_squad ai_current_squad 0))

	; spawn the warthog and attach it to the dropship
	(f_load_pelican_cargo_vehicle (ai_vehicle_get_from_squad ai_current_squad 0) v_beach_lz_warthog)

	(print "the inflection point")

	; ======= foe hammer enters here ===================
	; play sfx for pelican flyby sweetener
	(sound_impulse_start sound\vehicles\pelican\pelican_flyby_sweetener (ai_vehicle_get_from_squad ai_current_squad 0) 0)
	(cs_vehicle_speed 1.0)
	; ==========
	; pelican flies in from behind cliff
	(cs_fly_by fh_drop_path/p0 1.0)
	(cs_fly_by fh_drop_path/p1)
	(cs_fly_by fh_drop_path/p2)
	; pelican tail whips into warthog drop location
	; play sfx for pelican landing sequence
	(sound_impulse_start sound\vehicles\pelican\pelican_fly_in (ai_vehicle_get_from_squad ai_current_squad 0) 0)
	(cs_fly_by fh_drop_path/p3)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face fh_drop_path/p4 fh_drop_path/p4_aim 1.0)

	; ========= dropoff warthog =====================
	(sleep (game_ticks_from_seconds 2)) ;wait after unload
   	(sound_impulse_start sound\vehicles\pelican\pelican_fly_in (ai_vehicle_get_from_squad ai_current_squad 0) 0)
	; drop the warthog
	(sleep_until (= (volume_test_players jeep_delivery) false) 1)
	(f_unload_pelican_cargo	(ai_vehicle_get_from_squad ai_current_squad 0))
	(wake stop_warthog_when_player_exits)
	(set b_warthog_created true)

	; ==========
	; pelican reacts to dropping warthog

	(cs_fly_to_and_face fh_drop_path/p4_up fh_drop_path/p5_5 1.0)
	; ==========
	; pelican flies out to the ocean
	(cs_vehicle_speed 1.0)
	(cs_fly_by fh_drop_path/p5_5)
	; play sfx for pelican takeoff
	(sound_impulse_start sound\vehicles\pelican\pelican_takeoff (ai_vehicle_get_from_squad ai_current_squad 0) 0)
	(cs_fly_by fh_drop_path/p5_7)
	(cs_fly_by fh_drop_path/p6)
	(cs_vehicle_speed 0.1)
	; play sfx for pelican fly out sequence
	(sound_impulse_start sound\vehicles\pelican\pelican_fly_out (ai_vehicle_get_from_squad ai_current_squad 0) 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 90)
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face fh_drop_path/p7 fh_drop_path/p7_aim 10.0)

	; ==========
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script command_script cs_fh_pickup
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(unit_open (ai_vehicle_get_from_squad ai_current_squad 0))

	(f_blip_object v_foehammer_evac 0) ; set navpoint on pelican

	(cs_fly_to_and_face fh_pickup_path/turn_point fh_pickup_path/set_down_face 0.1)
	(cs_vehicle_speed 0.4)

	;open the hatch
	(unit_close (ai_vehicle_get_from_squad ai_current_squad 0))

	(if (!= s_b30_music_current 180) (set s_b30_music_request 180)) ; if player has not yet cleared encounter, trigger safety music
		(ai_allegiance human player)
	(ai_allegiance player human)
	(cs_fly_to_and_face fh_pickup_path/set_down fh_pickup_path/set_down_face 0.1)
	(f_unblip_object v_foehammer_evac) ; remove navpoint on pelican to avoid confusion with pickup navpoint
	(f_blip_flag fl_pickup_nav 0)
	(sleep_until
		(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad ai_current_squad 0) "" (players))
	1)

	(f_unblip_flag fl_pickup_nav) ; remove the navpoint from the flag after the player has entered it
)

;=========================================================================================================================
; === warthog logic and command scripts ==================================================================================
;=========================================================================================================================

(script dormant warthog_logic_control
	; loop through objectives to be taken around the island
	; there might be a skip in the objectives
	(sleep_until (begin
		; wait until non-player character takes the driver's seat and player is inside the vehicle
		(sleep_until (f_can_ai_drive_warthog) 1)
		(f_warthog_main_objective_swap)
		(sleep_until (<= s_warthog_next_objective_index s_warthog_main_objective_index) 1)
		(set s_warthog_next_objective_index (+ s_warthog_main_objective_index 1))
		(> s_warthog_main_objective_index 9))
	1)
	(f_warthog_logic_clean_up)
)

; stop the warthog when player exits the warthog and let it go when a player is seated
(script dormant stop_warthog_when_player_exits
	(sleep_until
		(begin
			(if (not (player_in_vehicle v_beach_lz_warthog))
				(cs_run_command_script (object_get_ai (vehicle_driver v_beach_lz_warthog)) cs_warthog_idle)
			)
			(<= (object_get_health v_beach_lz_warthog) 0)
		)
	1)
)

; check that non-player character takes the driver's seat
(script static boolean (f_can_ai_drive_warthog)
	(and
		(f_marine_is_driver)
		(player_in_vehicle v_beach_lz_warthog)
	)
)

(script static boolean f_marine_is_driver
	(not (or
		(= (vehicle_driver v_beach_lz_warthog) none)
		(= (vehicle_driver v_beach_lz_warthog) player0)
		(= (vehicle_driver v_beach_lz_warthog) player1)
		(= (vehicle_driver v_beach_lz_warthog) player2)
		(= (vehicle_driver v_beach_lz_warthog) player3)
	))
)

; each of these functions calls a dormant script to set the warthog objective
; because the amount of allowed function calls is limited in a single script
; see this error: logblamengine: error: thread warthog_logic_control stack overflow. terminating thread
(script static void (f_warthog_main_objective_swap)
	(cond
		((= s_warthog_main_objective_index 0)
			(wake f_set_warthog_objective_0)
		)
		((= s_warthog_main_objective_index 1)
			(wake f_set_warthog_objective_1)
		)
		((= s_warthog_main_objective_index 2)
			(wake f_set_warthog_objective_2)
		)
		((= s_warthog_main_objective_index 3)
			(wake f_set_warthog_objective_3)
		)
		((= s_warthog_main_objective_index 4)
			(wake f_set_warthog_objective_4)
		)
		((= s_warthog_main_objective_index 5)
			(wake f_set_warthog_objective_5)
		)
		((= s_warthog_main_objective_index 6)
			(wake f_set_warthog_objective_6)
		)
		((= s_warthog_main_objective_index 7)
			(wake f_set_warthog_objective_7)
		)
		((= s_warthog_main_objective_index 8)
			(wake f_set_warthog_objective_8)
		)
		((= s_warthog_main_objective_index 9)
			(wake f_set_warthog_objective_9)
		)
	)
)

;need to have dormant tasks for these or the script will error for running too many functions

(script dormant f_set_warthog_objective_0
	; clear the beach slab and pass
	(f_check_and_set_warthog_objective aiobjective_drive_beach_slab cs_warthog_dummy "main objective index is: 0" 1)
)

(script dormant f_set_warthog_objective_1
	; clear the platform at shaft a
	(f_check_and_set_warthog_objective aiobjective_drive_shafta cs_warthog_dummy "main objective index is: 1" 2)
)

(script dormant f_set_warthog_objective_2
	; wait for the player to find the shaft a door
	(f_check_and_set_warthog_objective none cs_warthog_wait "main objective index is: 2" 2)
)

(script dormant f_set_warthog_objective_3
	; clear valley entrance
			(f_check_and_set_warthog_objective aiobjective_drive_beach_crack cs_warthog_dummy "main objective index is: 3" 5)
)

(script dormant f_set_warthog_objective_4
	; clear the platform at shaft a
			(f_check_and_set_warthog_objective aiobjective_drive_valley_lid cs_warthog_dummy "main objective index is: 4" 6)
)

(script dormant f_set_warthog_objective_5
	; clear valley mouth
	(f_check_and_set_warthog_objective aiobjective_drive_valley_mouth cs_warthog_dummy "main objective index is: 5" 6)
)

(script dormant f_set_warthog_objective_6
	; handle point to park the warthog
	(print "main objective index is: 6")
	(set s_required_zone_trans_index 6)
	(sleep_until (= s_warthog_zone_transition_index s_required_zone_trans_index) 1)
	(sleep_until (begin
		(cs_run_command_script (object_get_ai (vehicle_driver v_beach_lz_warthog)) cs_warthog_follow_point)
		(ai_set_objective (ai_get_squad (object_get_ai (vehicle_driver v_beach_lz_warthog))) none)
		(f_can_ai_drive_warthog))
	1)
	(sleep (* 30 5))
	(cs_run_command_script (object_get_ai (vehicle_driver v_beach_lz_warthog)) cs_warthog_wait)
)

(script dormant f_set_warthog_objective_7
	; clear valley lid inverse
	(f_check_and_set_warthog_objective aiobjective_drive_valley_lid cs_warthog_dummy "main objective index is: 7" 6)
)

(script dormant f_set_warthog_objective_8
	; clear shaft a platform again
	(f_check_and_set_warthog_objective aiobjective_drive_shafta cs_warthog_dummy "main objective index is: 8" 7)
)

(script dormant f_set_warthog_objective_9
	; last task, entry to shaft a
	(f_check_and_set_warthog_objective none cs_warthog_wait "main objective index is: 9" 3) ; the zone transition will be later set to 2 as the objective circles the island cw
	(set s_warthog_main_objective_index 10)
)


;check and set the warthog objective, wait for the zone transition to complete if needed
(script static void (f_check_and_set_warthog_objective (string_id objective) (ai_command_script script_to_run) (string debug_text) (short required_subtask))
	(set s_required_zone_trans_index required_subtask)
	(if (not (= s_warthog_zone_transition_index required_subtask)) ; safeguard from sleeps at the start
		(sleep_until (begin
			(f_warthog_zone_transition_swap)
			(= s_warthog_zone_transition_index required_subtask))
		1)
	)
	(f_set_ai_objective objective script_to_run debug_text)
)

(script static void f_warthog_zone_transition_swap
	; set objectives to get to the navmesh border
	(cond
		((= s_warthog_zone_transition_index 0) (begin
			(f_set_warthog_objective aiobjective_lz_to_slab cs_warthog_dummy 0 "zone transition index is: 0")
		))
		((= s_warthog_zone_transition_index 1) (begin
			(f_set_warthog_objective aiobjective_slab_to_shafta cs_warthog_dummy 1 "zone transition index is: 1")
		))
		((= s_warthog_zone_transition_index 2) (begin
			(f_set_warthog_objective aiobjective_shafta_to_crack cs_warthog_dummy 2 "zone transition index is: 2")
		))
		((= s_warthog_zone_transition_index 3) (begin
			(f_set_warthog_objective aiobjective_crack_to_shaftb cs_warthog_dummy 3 "zone transition index is: 3")
		))
		((= s_warthog_zone_transition_index 4) (begin
			(f_set_warthog_objective aiobjective_shaftb_to_lz cs_warthog_dummy 4 "zone transition index is: 4")
		))
		((= s_warthog_zone_transition_index 5) (begin
			(f_set_warthog_objective aiobjective_crack_to_valley cs_warthog_dummy 5 "zone transition index is: 5")
		))
		((= s_warthog_zone_transition_index 6) (begin
			(f_set_warthog_objective aiobjective_valley_to_crack cs_warthog_dummy 6 "zone transition index is: 6")
		))
		((= s_warthog_zone_transition_index 7) (begin
			(f_set_warthog_objective aiobjective_crack_to_shafta cs_warthog_dummy 7 "zone transition index is: 7")
		))
		((= s_warthog_zone_transition_index 8) (begin
			(f_set_warthog_objective aiobjective_shaftb_to_beach cs_warthog_dummy 8 "zone transition index is: 8")
		))
		((= s_warthog_zone_transition_index 9) (begin
			(f_set_warthog_objective aiobjective_shaftb_to_valley cs_warthog_dummy 9 "zone transition index is: 9")
		))
		((= s_warthog_zone_transition_index 10) (begin
			(f_set_warthog_objective aiobjective_shafta_to_beach cs_warthog_dummy 10 "zone transition index is: 10")
		))
	)
	(sleep_until (not (= s_warthog_zone_transition_init s_warthog_zone_transition_index)) 1)
)

(script static void (f_set_warthog_objective (string_id objective) (ai_command_script script_to_run) (short index) (string debug_text))
	(set s_warthog_zone_transition_init index)
	(f_set_ai_objective objective script_to_run debug_text)
)

(script static void (f_set_ai_objective (string_id objective) (ai_command_script script_to_run) (string debug_text))
	; wait for the driver and a player to be onboard to run the objective
	(sleep_until (f_can_ai_drive_warthog) 1)

	(print debug_text)
	(cs_run_command_script (object_get_ai (vehicle_driver v_beach_lz_warthog)) script_to_run)
	(ai_set_objective (ai_get_squad (object_get_ai (vehicle_driver v_beach_lz_warthog))) objective)
)

(script continuous set_warthog_zone_transition_index
	; set objectives to get to the navmesh border
	(cond
		((or (volume_test_players drive_trigger_lz_to_slab) (volume_test_players drive_trigger_slab_to_shafta_i)) (begin
			(if (not (= s_warthog_zone_transition_index 1)) (begin
				(set s_warthog_zone_transition_index 1)
				(print "set zone transition index to: 1")))
		))
		((or (volume_test_players drive_trigger_slab_to_shafta) (volume_test_players drive_trigger_shafta_to_beach) (volume_test_players drive_trigger_shafta_and_crack_i))(begin
			(if (not (= s_warthog_zone_transition_index 2)) (begin
				(set s_warthog_zone_transition_index 2)
				(print "set zone transition index to: 2")))
		))
		((or (volume_test_players drive_trigger_shafta_and_crack) (volume_test_players drive_trigger_crack_to_shaftb_i)) (begin
			(if (and (>= s_warthog_main_objective_index 3) (<= s_warthog_main_objective_index 7))
				(if (not (= s_warthog_zone_transition_index 5)) (begin
					(set s_warthog_zone_transition_index 5)
					(print "set zone transition index to: 5")))
				(if (not (= s_warthog_zone_transition_index 3)) (begin
					(set s_warthog_zone_transition_index 3) ; else
					(print "set zone transition index to: 3"))))
		))
		((or (volume_test_players beach_crack_trigger) (volume_test_players drive_trigger_shaftb_to_lz_i))(begin
			(if (not (= s_warthog_zone_transition_index 4)) (begin
				(set s_warthog_zone_transition_index 4)
				(print "set zone transition index to: 4")))
		))
		((or (volume_test_players drive_trigger_shaftb_to_lz) (volume_test_players drive_trigger_lz_to_slab_i)) (begin
			(if (not (= s_warthog_zone_transition_index 0)) (begin
				(set s_warthog_zone_transition_index 0)
				(print "set zone transition index to: 0")))
		))
		((volume_test_players drive_trigger_crack_and_valley) (begin
			(if (and (>= s_warthog_main_objective_index 4) (<= s_warthog_main_objective_index 7))
				(if (not (= s_warthog_zone_transition_index 6)) (begin
					(set s_warthog_zone_transition_index 6)
					(print "set zone transition index to: 6")))
				(if (> s_warthog_main_objective_index 7) ; else if
					(if (not (= s_warthog_zone_transition_index 7)) (begin
						(set s_warthog_zone_transition_index 7)
						(print "set zone transition index to: 7")))
					(if (not (= s_warthog_zone_transition_index 3)) (begin ; else
						(set s_warthog_zone_transition_index 3)
						(print "set zone transition index to: 3")))))
		))
		((volume_test_players drive_trigger_shaftb_to_valley) (begin
			(if (not (= s_warthog_zone_transition_index 6)) (begin
				(set s_warthog_zone_transition_index 6)
				(print "set zone transition index to: 6"))
			)
		))
		((volume_test_players drive_trigger_shaftb_wide) (begin
			(if (not (= s_warthog_zone_transition_index 8)) (begin
				(set s_warthog_zone_transition_index 8)
				(print "set zone transition index to: 8"))
			)
		))
		((or (volume_test_players drive_trigger_shaftb_beach_up) (volume_test_players drive_trigger_shaftb_to_beach) (volume_test_players downed_trigger_2)) (begin
			(if (not (= s_warthog_zone_transition_index 9)) (begin
				(set s_warthog_zone_transition_index 9)
				(print "set zone transition index to: 9"))
			)
		))
		((volume_test_players shafta_entrance_fat) (begin
			(if (not (= s_warthog_zone_transition_index 10)) (begin
				(print "set zone transition index to: 10")
				(set s_warthog_zone_transition_index 10))
			)
		))
	)
)

(script continuous warthog_zone_transition_swap
	(sleep_until (volume_test_players downed_trigger) (game_ticks_from_seconds 2))
	(if (= s_warthog_zone_transition_index 9)
		(set s_warthog_zone_transition_index 4)
	)
)

(script command_script cs_warthog_dummy
	(sleep 1)
)

(script command_script cs_warthog_idle
	(sleep_until (begin ; keep setting this until the player enters the car again or kicks out the driver out of the driver seat
		(cs_vehicle_speed 0)
		(or (player_in_vehicle v_beach_lz_warthog) (= (vehicle_driver v_beach_lz_warthog) none)))
	1)
)

(script command_script cs_warthog_wait
	(sleep_until (begin ; keep setting this until the player enters the car again or kicks out the driver out of the driver seat
		(cs_vehicle_speed 0)
		(not (or (= s_warthog_main_objective_index 2) (= s_warthog_main_objective_index 6) (>= s_warthog_main_objective_index 9))))
	1)
)

(script command_script cs_warthog_follow_point
	(cs_vehicle_speed 0.5)
	(cs_go_to ps_drive_shaftb/p0)
)

(script static void f_warthog_logic_clean_up
	(sleep_forever warthog_zone_transition_swap)
	(sleep_forever set_warthog_zone_transition_index)
	(sleep_forever warthog_logic_control)
	(sleep_forever stop_warthog_when_player_exits)
)


(script command_script cs_smack_elite
	(cs_stow true)
	(cs_abort_on_combat_status 5)
	(cs_abort_on_damage true)
	(cs_enable_moving false)
	(cs_look true aipatrol_lookpoint_elite/p0)
	(sleep_until false 1000)
)

;===================================================================================================================================================================================================
;====================================================================================================================================================================================================
; multiplayer decisions ==============================================================================================================================================================================
;====================================================================================================================================================================================================
;===================================================================================================================================================================================================

;===================================================================================================================================================================================================
; placement =========================================================================================================================================================================================
;===================================================================================================================================================================================================

(script dormant multiplayer_placement_shafta_entrance
    (cond
        ((= (list_count (players)) 2) (f_place_equip_shafta_entrance_for_2))
        ((= (list_count (players)) 3) (f_place_equip_shafta_entrance_for_3))
        ((= (list_count (players)) 4) (f_place_equip_shafta_entrance_for_4))
    )
)

(script dormant multiplayer_placement_beach_crack
    (cond
        ((= (list_count (players)) 2) (f_place_equip_beach_crack_for_2))
        ((= (list_count (players)) 3) (f_place_equip_beach_crack_for_3))
        ((= (list_count (players)) 4) (f_place_equip_beach_crack_for_4))
    )
)

(script dormant multiplayer_placement_wreckage
    (cond
        ((= (list_count (players)) 2) (f_place_equip_wreckage_for_2))
        ((= (list_count (players)) 3) (f_place_equip_wreckage_for_3))
        ((= (list_count (players)) 4) (f_place_equip_wreckage_for_4))
    )
)

(script dormant multiplayer_placement_valley_lid
	(sleep_until
		(volume_test_players valley_entrance)
	1)
    (cond
        ((= (list_count (players)) 2) (f_place_equip_valley_lid_for_2))
        ((= (list_count (players)) 3) (f_place_equip_valley_lid_for_3))
        ((= (list_count (players)) 4) (f_place_equip_valley_lid_for_4))
    )
)

(script dormant multiplayer_placement_shafta
	(sleep_until
		(and
			(volume_test_players shafta_window_inv)
			b_shafta_unlocked
		)
	1)
    (cond
        ((= (list_count (players)) 2) (f_place_equip_shafta_for_2))
        ((= (list_count (players)) 3) (f_place_equip_shafta_for_3))
        ((= (list_count (players)) 4) (f_place_equip_shafta_for_4))
    )
)

;=============================================================

(script static void f_place_equip_shafta_entrance_for_2
	(print "no equipment set for 2 player co-op at shaft a entrance")
)

(script static void f_place_equip_shafta_entrance_for_3
	(object_create bp_overshield_1_coop)
)

(script static void f_place_equip_shafta_entrance_for_4
	(object_create bp_overshield_1_coop)
)

;=============================================================

(script static void f_place_equip_wreckage_for_2
    (object_create b30_weapons_assault_rifle_2_pelican_m2)
    (object_create b30_equipment_frag_grenade_13_m2)
	(object_create b30_weapons_pistol_12_m2)
)

(script static void f_place_equip_wreckage_for_3
	(object_create b30_weapons_assault_rifle_2_pelican_m2)
    (object_create b30_equipment_frag_grenade_13_m2)
	(object_create b30_weapons_pistol_12_m2)
    (object_create b30_weapons_assault_rifle_2_pelican_m3)
    (object_create b30_equipment_frag_grenade_13_m3)
	(object_create b30_weapons_pistol_12_m3)
	(object_create b30_weapons_rocket_launcher_5_m3)
)

(script static void f_place_equip_wreckage_for_4
	(object_create b30_weapons_assault_rifle_2_pelican_m2)
    (object_create b30_equipment_frag_grenade_13_m2)
	(object_create b30_weapons_pistol_12_m2)
    (object_create b30_weapons_assault_rifle_2_pelican_m3)
    (object_create b30_equipment_frag_grenade_13_m3)
	(object_create b30_weapons_pistol_12_m3)
	(object_create b30_weapons_rocket_launcher_5_m3)
    (object_create b30_weapons_assault_rifle_2_pelican_m4)
    (object_create b30_equipment_frag_grenade_13_m4)
	(object_create b30_weapons_assault_rifle_2_m4)
	(object_create b30_weapons_pistol_12_m4)
)

;=============================================================

(script static void f_place_equip_valley_lid_for_2
	(object_create b30_weapons_assault_rifle_13_m3)
)

(script static void f_place_equip_valley_lid_for_3
	(f_place_equip_valley_lid_for_2)
	(object_create b30_weapons_assault_rifle_13_m3)
	(object_create bp_overshield_2_coop)
	(object_create bp_overshield_3_coop)
	(object_create bp_overshield_6_coop)
	(object_create bp_overshield_7_coop)
)

(script static void f_place_equip_valley_lid_for_4
	(f_place_equip_valley_lid_for_3)
	(object_create b30_weapons_assault_rifle_13_m4)
	(object_create b30_weapons_pistol_15_m4)
	(object_create bp_overshield_2_coop)
	(object_create bp_overshield_3_coop)
	(object_create bp_overshield_6_coop)
	(object_create bp_overshield_7_coop)
)

;=============================================================

(script static void f_place_equip_beach_crack_for_2
	(object_create b30_equipment_frag_grenade_35_m2)
)

(script static void f_place_equip_beach_crack_for_3
	(f_place_equip_beach_crack_for_2)
	(object_create b30_equipment_frag_grenade_35_m3)
	(object_create b30_weapons_pistol_10_m3)
)

(script static void f_place_equip_beach_crack_for_4
	(f_place_equip_beach_crack_for_3)
	(object_create b30_equipment_frag_grenade_35_m4)
	(object_create b30_weapons_pistol_10_m4)
)

;=============================================================

(script static void f_place_equip_shafta_for_2
	(object_create b30_equipment_frag_grenade_stolen_m2)
    (object_create b30_weapons_assault_rifle_stolen_m2)
	(object_create b30_weapons_pistol_3_m2)
)

(script static void f_place_equip_shafta_for_3
	(f_place_equip_shafta_for_2)
	(object_create b30_equipment_frag_grenade_stolen_m3)
    (object_create b30_weapons_assault_rifle_stolen_m3)
	(object_create b30_weapons_pistol_3_m3)
	(object_create pistol_stolen_m3)
	(object_create bp_activecamo_coop)
	(object_create bp_overshield_5_coop)

)

(script static void f_place_equip_shafta_for_4
	(f_place_equip_shafta_for_3)
	(object_create b30_equipment_frag_grenade_stolen_m4)
    (object_create b30_weapons_assault_rifle_stolen_m4)
	(object_create b30_weapons_pistol_3_m4)
	(object_create pistol_stolen_m4)
	(object_create bp_activecamo_coop)
	(object_create bp_overshield_5_coop)
)

;=============================================================
;=============================================================
