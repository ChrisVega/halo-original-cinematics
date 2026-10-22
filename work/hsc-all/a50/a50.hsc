(global boolean b_captain_rescued false)
(global boolean b_hangar_door_should_open false)
(global boolean b_hangar_pelican_dialogue_over false)
(global boolean b_gravpad_reins_dialogue_over false)
(global boolean b_control_reinforcement_spawned false)
(global boolean b_dropship_departed false)
(global boolean b_stick_to_the_right_navpoint false)
(global boolean b_stick_to_the_left_navpoint false)
(global boolean b_sneak_up_canyon_navpoint false)
(global boolean b_up_around_bend_navpoint false)
(global boolean b_start_ship_navpoints false)
(global boolean b_head_back_for_evac false)
(global boolean b_the_mission_has_begun false)
(global boolean b_starting_at_insertion_area_3 false)
(global boolean b_starting_at_insertion_area_4 false)
(global boolean b_canyon_nav_2_triggered false)
(global boolean b_canyon_nav_3_triggered false)
(global boolean b_canyon_nav_4_triggered false)
(global boolean b_highground_encounter_cleared false)
(global boolean b_ship_nav_2_triggered false)
(global boolean b_ship_nav_3_triggered false)
(global boolean b_ship_nav_4_triggered false)
(global boolean b_ship_nav_5_triggered false)
(global boolean b_ship_nav_6_triggered false)
(global boolean b_ship_nav_7_triggered false)
(global boolean b_area4_pelican true)
(global boolean b_area4_area4_covenant_reins true)


(global boolean b_gravity_wave false)
(global boolean b_gravity_pad_waves_done false)
(global short s_grav_wave_count 0)
(global short s_grav_wave_max_normal 6)
(global short s_grav_wave_max_heroic 8)
(global short s_grav_wave_max_legendary 10)
(global short s_grav_wave_add_coop_1_2 0)
(global short s_grav_wave_add_coop_3_4 2)
(global short s_grav_squad_add_coop_3_4 1)
(global short s_grav_wave_max 0)
(global short s_grav_wave_size_min 1)
(global short s_grav_wave_squad_max 2)
(global short s_grav_wave_squad_count 0)

(global boolean b_fireteam_hold_position true)
(global ai ai_player_fireteam none)
(global ai ai_fireteam_marines none)
(global ai ai_fireteam_johnson none)
(global ai ai_fireteam_keyes none)
(global ai ai_fireteam_fill none)

(global vehicle v_pelican_arrival none)

(global short s_conversation_id -1)

; wake triggers on start
(script startup a50_start
	(ai_allegiance player human)
	(ai_allegiance human player)
	(a50_insertion_point_fixups)
	(f_start_auto_save_loop)

	(wake music_a50) ; music script

	;-- nav points --------------------------------------------------------------
	(wake canyon_nav_points)
	(wake canyon_nav_points_part_2)
	(wake canyon_nav_points_part_3)
	(wake canyon_nav_points_part_4)
	(wake ship_navpoints)
	(wake ship_navpoints_part_2)
	(wake ship_navpoints_part_3)
	(wake ship_navpoints_part_4)
	(wake ship_navpoints_part_5)
	(wake ship_navpoints_part_6)
	(wake ship_navpoints_part_7)

	;give sniper to all players but only when we start playing.
	(device_group_set gravity_lift_lid lid_position_group 1)

	(ai_allegiance player human)
	(ai_allegiance human player)

	(if (f_insertion_point_area_pending insertion_area1)
		(begin
			(f_play_cinematic cinematics\a50\a50_intro.cinematic)
			(wake start_mission)
			(f_place_pelican_arrival_spawner)
			(wake enc_area2)
		)
	)

 	(sleep_until (or (volume_test_players area3_trigger) (f_insertion_point_script_is_blocked insertion_area3)) 1)
	(if (f_insertion_point_area_pending insertion_area3) (wake enc_area3))


 	(sleep_until (or (volume_test_players area4_trigger) (f_insertion_point_script_is_blocked insertion_area4)) 1)
	(if (f_insertion_point_area_pending insertion_area4) (wake enc_area4))

 	(sleep_until (or (volume_test_players area5_trigger) (f_insertion_point_script_is_blocked insertion_area5)) 1)
	(if (f_insertion_point_area_pending insertion_area5) (wake enc_area5))

 	(sleep_until (or (volume_test_players gravity_trigger) (f_insertion_point_script_is_blocked insertion_gravity_room)) 1)
	(if (f_insertion_point_area_pending insertion_gravity_room) (wake enc_gravity_room))

 	(sleep_until (or (volume_test_players grav_muster_top_hall) (f_insertion_point_script_is_blocked insertion_grav_mus_hall)) 1)
	(if (f_insertion_point_area_pending insertion_grav_mus_hall) (wake enc_grav_mus_hall))

 	(sleep_until (or (volume_test_players muster_bay_top_entrance) (f_insertion_point_script_is_blocked insertion_grav_mus_hall)) 1)
	(if (f_insertion_point_area_pending insertion_grav_mus_hall) (wake enc_muster_bay))

 	(sleep_until (or (volume_test_players hangar_trigger) (f_insertion_point_script_is_blocked insertion_hangar)) 1)
	(if (f_insertion_point_area_pending insertion_hangar) (wake enc_hangar))

 	(sleep_until (or (volume_test_players control_migration) (f_insertion_point_script_is_blocked insertion_control)) 1)
	(if (f_insertion_point_area_pending insertion_control) (wake enc_control))

 	(sleep_until (or (volume_test_players prison_trigger) (f_insertion_point_script_is_blocked insertion_prison)) 1)
	(if (f_insertion_point_area_pending insertion_prison) (wake enc_prison))

	(sleep_until (or b_captain_rescued (f_insertion_point_script_is_blocked insertion_control_revisited)) 1)
 	(sleep_until (or (volume_test_players prison_trigger) (f_insertion_point_script_is_blocked insertion_control_revisited)) 1)
	(if (f_insertion_point_area_pending insertion_control_revisited) (wake enc_control_revisited))

 	(sleep_until (or (volume_test_players hangar_migration) (f_insertion_point_script_is_blocked insertion_hangar_revisited)) 1)
	(if (f_insertion_point_area_pending insertion_hangar_revisited) (wake enc_hangar_revisited))

)

;====================================================================================================================================================================================================
; a50 chapter scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant trigger_chapter_one
	(f_hud_chapter mission_start)
)

(script dormant trigger_chapter_two
	(sleep_until (volume_test_players tv_trigger_chapter_two) 1) ; trigger chapter two when players are moving up the gravlift
	(f_hud_chapter gravity_lift)
)

(script dormant trigger_chapter_three
	(f_hud_chapter_slow sir_left)
)

;====================================================================================================================================================================================================
; a50 missionlevel scripts ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant start_mission
	(wake area1_save_trigger)
	(wake vo_initial_orders)
	(wake vo_tutorial_camo)
	(wake trigger_chapter_one)
)

;place the initial marines on level start
(script static void f_place_pelican_arrival_spawner
	(print "::pelican arrival spawner::")
	(ai_place pelican_arrival_spawner)
)

(script command_script cs_pelican_arrival
	(print_if debug "foehammer flying in")
	;prep for a clean flight
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; set the vehicle global
	(set v_pelican_arrival (ai_vehicle_get ai_current_actor))

	; reserve player seats
	(ai_vehicle_reserve_seat v_pelican_arrival "pelican_p_l05" true)
	(ai_vehicle_reserve_seat v_pelican_arrival "pelican_p_r05" true)
	(ai_vehicle_reserve_seat v_pelican_arrival "pelican_p_l04" true)
	(ai_vehicle_reserve_seat v_pelican_arrival "pelican_p_r04" true)

	;allow player to enter in specific seats in the vehicle but not exit vehicle till we make them
	(vehicle_set_player_interaction v_pelican_arrival "pelican_p" false false)
	(vehicle_set_player_interaction v_pelican_arrival "pelican_d" false false)
	(vehicle_set_player_interaction v_pelican_arrival "pelican_g" false false)
	(vehicle_set_player_interaction v_pelican_arrival "pelican_lc" false false)
	(vehicle_set_player_interaction v_pelican_arrival "pelican_e" false false)
	(vehicle_set_player_interaction v_pelican_arrival "pelican_p_l05" true false)
	(vehicle_set_player_interaction v_pelican_arrival "pelican_p_r05" true false)
	(vehicle_set_player_interaction v_pelican_arrival "pelican_p_l04" true false)
	(vehicle_set_player_interaction v_pelican_arrival "pelican_p_r04" true false)

	;put players in the pelican
	(unit_enter_vehicle_immediate player0 v_pelican_arrival "pelican_p_l05")
	(unit_enter_vehicle_immediate player1 v_pelican_arrival "pelican_p_r05")

	(unit_enter_vehicle_immediate player2 v_pelican_arrival "pelican_p_l04")
	(unit_enter_vehicle_immediate player3 v_pelican_arrival "pelican_p_r04")

	;place marines into the pelican as close to cinematic as possible.
	(ai_place_in_vehicle ai_fireteam_johnson v_pelican_arrival "pelican_p_l03")
	(ai_place_in_vehicle ai_fireteam_marines v_pelican_arrival "pelican_p")
	(ai_place_in_vehicle ai_fireteam_fill v_pelican_arrival "pelican_p")

	;move to landing
	(cs_teleport pelican_arrival_pts/p1 pelican_arrival_pts/p0)

	;(cs_fly_by pelican_arrival_pts/p0)
	;(cs_fly_by pelican_arrival_pts/p1)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face pelican_arrival_pts/p2 pelican_arrival_pts/p0 0.1)

	;unload occupants
	(sleep (game_ticks_from_seconds 2))
	(vehicle_unload v_pelican_arrival "pelican_p_l05")
	(vehicle_unload v_pelican_arrival "pelican_p_r05")
	(sleep (game_ticks_from_seconds 0.33))
	(vehicle_unload v_pelican_arrival "pelican_p_l04")
	(vehicle_unload v_pelican_arrival "pelican_p_r04")
	(sleep (game_ticks_from_seconds 0.33))
	(vehicle_unload v_pelican_arrival "pelican_p_l03")
	(vehicle_unload v_pelican_arrival "pelican_p_r03")
	(sleep (game_ticks_from_seconds 0.33))
	(vehicle_unload v_pelican_arrival "pelican_p_l02")
	(vehicle_unload v_pelican_arrival "pelican_p_r02")
	(sleep (game_ticks_from_seconds 0.33))
	(vehicle_unload v_pelican_arrival "pelican_p_l01")
	(vehicle_unload v_pelican_arrival "pelican_p_r01")

	;mark mission start
	(set b_the_mission_has_begun true)

	(wake marines_clear_lz)

	(print "give johnson a nameplate")
	(wake nav_nameplate_johnson)

	;set initial objecitve
	(wake set_board_objective) ;set the board objective once area 2 encounter concludes

	(sleep (game_ticks_from_seconds 3))
	(unit_open v_pelican_arrival) ; will actually close the pelican, and that's ok.

	;fly away
	(cs_vehicle_speed 0.3)

	; play sfx for pelican takeoff and flyby sweetener
	(sound_impulse_start sound\vehicles\pelican\pelican_takeoff v_pelican_arrival 0)
	(sound_impulse_start sound\vehicles\pelican\pelican_flyby_sweetener v_pelican_arrival 0)
	(cs_fly_by pelican_arrival_pts/p0)
	(cs_vehicle_speed 1)
	(cs_fly_by pelican_arrival_pts/p3)
	(cs_fly_by pelican_arrival_pts/p4)
	; play sfx for pelican fly out sequence
	(sound_impulse_start sound\vehicles\pelican\pelican_fly_out v_pelican_arrival 0)
	(sleep (game_ticks_from_seconds 2)) ; adding delay to let the sound continue playing before it's destroyed

	;clean up pelican
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant nav_nameplate_johnson
	(sleep (game_ticks_from_seconds 1))
	(f_hud_hero_waypoint ai_fireteam_johnson hero_johnson hero_default_max_dist)
	)

(script dormant area1_save_trigger
	(sleep_until (volume_test_players area1_save_trigger) 1)
	(f_game_save)
)

;johnson directs the marines where they need to go and then moves up
(script dormant marines_clear_lz

	(cs_run_command_script ai_fireteam_johnson cs_area1_exit_pelican_johnson)
	(cs_run_command_script ai_fireteam_fill cs_area1_exit_pelican_marine)

	(sleep_until (< (list_count (vehicle_riders v_pelican_arrival)) 2) 1)

	(print_if debug "fireteam | flashlights enabled at mission start")
	(f_ai_set_integrated_flashlight ai_player_fireteam true)

	(cs_run_command_script ai_fireteam_marines cs_area1_exit_pelican_marine)

	(sleep_until (volume_test_players area2_trigger) 1 (game_ticks_from_seconds 15))

	(cs_action ai_fireteam_johnson true ps_area1_poi/stage_right ai_action_point)
	(cs_run_command_script ai_fireteam_marines cs_area1_stage_right)

	(cs_action ai_fireteam_johnson true ps_area1_poi/stage_left ai_action_point)
	(cs_run_command_script ai_fireteam_fill cs_area1_stage_left)
	(cs_run_command_script ai_fireteam_johnson cs_area1_stage_left)

	(sleep_until (volume_test_players canyon_nav_reached1) 1)


	;(sleep (game_ticks_from_seconds 1))
	;(cs_run_command_script ai_fireteam_johnson cs_johnson_exit_pelican)

	;(print_if debug "fireteam | flashlights enabled at mission start")
	;(f_ai_set_integrated_flashlight ai_player_fireteam true)

	;(sleep (game_ticks_from_seconds 3))

	;(f_fireteam_set_objective ai_objective_enc_area2_mar)

	;(cs_run_command_script ai_fireteam_johnson cs_johnson_point_lz_right)

)

;====================================================================================================================================================================================================
; encounter : area2 ==============================================================================================================================================
; insertion : insertion_area1
;====================================================================================================================================================================================================

(script dormant enc_area2
	;_____rally point_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")

	(submit_incident_with_custom_string_id "game_activity_begin" "a50")

	;_____fireteam prep_____
	(wake area2_migrate_marines)

	;_____checkpointing_____
	;set starting checkpoint
	(f_game_save)

	;_____encounter trigger_____
	;wait until the player has begun playing
	(sleep_until b_the_mission_has_begun 1)

	;_____encounter setup_____

	; difficulty adjustments
	(if (= (game_difficulty_get) legendary)
		(wake area2_grunt_enter_turrets_legendary) ; already place grunt in turrets in legendary
		(wake reserve_turrets)
	)

	; place ai
	(ai_place area2_wave_1)

	;_____encounter begins_____
	;wait for the player to begin pushing into the encounter.
	(sleep_until (volume_test_players area2_trigger) 1)

	;grunt runs for turret if not legendary
	(if (!= (game_difficulty_get) legendary) (wake area2_gun_runner)); spawn the gun runner (unless we're on legendary in which case we already filled all of the turrets)

	(wake vo_area2_enter) ; precombat vo

	;_____combat begins_____
	(sleep_until (f_area2_combat_started) 1) ; sleep until combat is initiated (or all enemies are dead)
	(print_if debug "area2 combat started!")
	(f_pause_auto_save_loop)

	;once combat begins, wake everyone up
	(ai_activity_abort area2_wave_1)

	;place covenant reinforcements.
	(sleep_until
		(or
			(volume_test_players area2_trigger_b)
			(and
				(volume_test_players area2_trigger_a)
				(< (ai_living_fraction area2_encounter) .8)
			)
		)
	1)
	(ai_place area2_wave_2)
	(ai_vehicle_reserve area2_turret_b false)
	(ai_magically_see area2_wave_2 ai_player_fireteam)

	(sleep (game_ticks_from_seconds 1))

	(if (> (ai_living_count area2_turret_gunner_b) 0) (cs_go_to_vehicle area2_turret_gunner_b true area2_turret_b))

	(sleep_until
		(or
			(volume_test_players area2_trigger_c)
			(and
				(volume_test_players area2_trigger_a)
				(< (ai_living_count area2_encounter) 1)
			)
		)
	1)

	;place a follow up squad on the ledge
	(ai_place area2_back_squads)

	;wait until all covenant are dead
	(sleep_until (<= (ai_nonswarm_count area2_encounter) 0) 1)
	(f_unpause_auto_save_loop)

	;end encounter dialog
	(wake vo_area2_finish)

)

(script dormant area2_grunt_enter_turrets_legendary
	(ai_vehicle_enter area2_turret_gunner_a area2_turret_a)
	(ai_vehicle_enter area2_turret_gunner_b area2_turret_b)
)

(script dormant reserve_turrets
	(ai_vehicle_reserve area2_turret_a true)
	(ai_vehicle_reserve area2_turret_b true)
)

(script dormant area2_gun_runner
	(ai_place area2_gun_runner)
	(print_if debug "gun runner spawned")
	(sleep (game_ticks_from_seconds 20))

	(sleep_until
		(and
			(< (ai_living_count area2_turret_gunner_a) 1)
			(f_area2_combat_started)
		)
	1)

	(cs_run_command_script area2_gun_runner go_to_area2_turret_a)

	(if (> (ai_living_count area2_gun_runner) 0)
		(begin
			(wake vo_area2_grunt_warning)
			(f_blip_ai area2_gun_runner 1)
			(sleep_until (> (ai_vehicle_count area2_gun_runner) 0) 1)

		)
	)

	;wait for the ai_vehicle_reserve to be effective
	(sleep 1)

	(ai_disregard area2_turret_a true)
)

(script command_script go_to_area2_turret_a
	(cs_go_to_and_face ps_gun_runner/gun ps_gun_runner/p1)
	(ai_vehicle_reserve area2_turret_a false)
	(ai_vehicle_enter_immediate ai_current_actor area2_turret_a "")

)

; returns whether any actor in area2_wave_1 is in combat, or all actors in area2_wave_1 are dead
(script static boolean f_area2_combat_started
	;*(or
		(and ; legacy | check to see if all the players stayed in the starting location but triggered the covenant
			(volume_test_players_all area1_save_trigger)
			(= (ai_combat_status area2_encounter) certain)
		)
		(volume_test_players area2_trigger_b) ; legacy | player progressed far enough into the encounter
		((= (ai_living_count area2_encounter) 0))
	)*;

	(or
		(and
			(volume_test_players area2_trigger_a)
			(< (ai_nonswarm_count area2_encounter) 10)
		)
		(volume_test_players area2_trigger_b)
		(= (ai_nonswarm_count area2_encounter) 0)
		(>= (ai_combat_status area2_encounter) "dangerous")
	)
)

(script dormant area2_migrate_marines
	(sleep_until b_stick_to_the_right_navpoint 1)

	(f_fireteam_leave_player)
	(ai_disregard ai_player_fireteam true)

	(f_fireteam_set_objective ai_objective_enc1_2_area2_mar)

	(cs_action ai_fireteam_johnson true ps_area2_poi/area2_path ai_action_point)
	(cs_run_command_script ai_fireteam_fill cs_area2_ready_upper)
	(cs_run_command_script ai_fireteam_johnson cs_area2_ready_upper)
	(cs_run_command_script ai_fireteam_marines cs_area2_ready_lower)

	;wait until the covenant are fighting back
	(sleep_until (f_area2_combat_started) 1)

	(cs_run_command_script ai_fireteam_fill cs_area2_attack_upper)
	(cs_run_command_script ai_fireteam_johnson cs_area2_attack_upper)

	(sleep (game_ticks_from_seconds 1.5))
	(ai_magically_see ai_player_fireteam area2_encounter)

	;(f_fireteam_join_player)
	(ai_disregard ai_player_fireteam false)
	;trigger battle music and vo
	(set s_music_trigger 30)
	(wake vo_area2_encounter_start)

)

(script command_script cs_area2_jump_left
	(cs_go_to (ai_nearest_point ai_current_actor area2_jump_down) .5)
	(cs_action (ai_nearest_point ai_current_actor area2_jump_down) ai_action_dive_forward)
)

(script command_script cs_area2_jump_right
	(cs_go_to (ai_nearest_point ai_current_actor area2_jump_down) .5)
	(cs_action (ai_nearest_point ai_current_actor area2_jump_down) ai_action_dive_forward)
)

(script dormant cleanup_enc_area2
	(sleep_until (volume_test_players area3_trigger_b) 1)
	(ai_erase area2_encounter)
)

(script dormant set_board_objective
	(print "new objective | fight your way to the covenant battlecruiser")
	(f_hud_obj_new "obj_a50_board" "obj_a50_board")
)
;====================================================================================================================================================================================================
; encounter : area3 ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_area3
	(print_if debug "area3 | area started")
	;setting insertion point
	(set b_starting_at_insertion_area_3 true)

	;_____fireteam prep_____

	;(wake area2_marines_follow_side)
	(wake area3_migrate_marines)
	(ai_disregard ai_player_fireteam true)


	;_____encounter prep_____
	(print_if debug "area3 | encounter preping...")
	;update the nav
	(set b_canyon_nav_2_triggered true)

	; cue ai placement scripts
	(wake area3_place_intial_squads)
	(wake area3_place_front_squads)
	(wake area3_place_second_squads)
	(wake area3_place_reinforcement_squads)

	; cue our turret systems
	(wake area3_place_legendary_turrets)
	(wake area3_basic_turret_manager)
	(wake area3_legendary_turret_manager)

	; a helpful save once our initial elites die
	(wake area3_mid_save)

	;cleanup the last encounter and save
	(wake cleanup_enc_area2)
	(f_game_save)

	;cortana cautions player and marines wait to engage
	(wake vo_area3_approach)
	;(wake marine_go_to_area3)

	(print_if debug "area3 | encounter prepped")

	;_____combat begins_____
	(sleep_until (= (f_area3_combat_started) true) 1)
	(print_if debug "area3 | combat starting")

	(ai_activity_abort area3_encounter)		; stop all the covenant from being distracted
	(ai_disregard ai_player_fireteam false)	; now they can see the marines

	(f_pause_auto_save_loop)	; we want to preseve the stealth start so we are pausing this till combats over

	(sleep_until (> (ai_living_count area3_reinforcements) 1) 1) ; wait for our last units to spawn
	(print_if debug "area3 | final squad")
	(wake area3_vo_music_trigger)

	;_____combat ends_____
	;sleep until the combat is over
	(sleep_until
		(or
			(= 0 (ai_living_count area3_elites_reins))
			(= 0 (ai_living_count area3_encounter))
			(volume_test_players area4_trigger)
		)
	1)
	(print_if debug "area3 | encounter complete")
	(f_unpause_auto_save_loop) ; combat's over so turning back on

	(f_game_save)

)

; place turrets for legendary only and man it
(script dormant area3_place_legendary_turrets
	(if (not (= (game_difficulty_get) "legendary")) (sleep_forever))
	(print_if debug "area3 | placing legendary turret b")

	(object_create area3_turret_b)

	(ai_vehicle_enter area3_turret_gunner_b area3_turret_b "")
)

; continues to put grunts into the turrets as long as there are turrets and gunners
(script dormant area3_basic_turret_manager
	(print_if debug "area3 | checking basic turret manager...")
	(if	(not (or (= (game_difficulty_get) "normal") (= (game_difficulty_get) "heroic"))) (sleep_forever))

	(print_if debug "area3 | basic turret manager enabled")
	(sleep_until
		(begin
			(ai_vehicle_enter area3_turret_gunner_a area3_turret_a "")
			(sleep (game_ticks_from_seconds 10))

			; exit condition
			(or
				(volume_test_players area4_trigger)	; player progressed
				(< (ai_living_count area3_turret_gunner_a) 1) ; no more gunners
				(<= (unit_get_health area3_turret_a) .25)	; no more turret
			)
		)
	1)
	(print_if debug "area3 | basic turret manager disabled")
)

; continues to put gunners into the turrets as long as there are turrets
(script dormant area3_legendary_turret_manager
	(print_if debug "area3 | checking legendary turret manager...")
	(if (not (= (game_difficulty_get) "legendary")) (sleep_forever))

	(print_if debug "area3 | legendary turret manager enabled")
	(sleep_until
		(begin
			(ai_vehicle_enter area3_turret_gunner_a area3_turret_a "")
			(ai_vehicle_enter area3_turret_gunner_b area3_turret_b "")

			(if
				(and ; no more gunners
					(< (ai_living_count area3_turret_gunner_a) 1)
					(< (ai_living_count area3_turret_gunner_b) 1)
				)
				(begin_random
					(if (is_turret_operable area3_turret_a) (ai_vehicle_enter area3_encounter area3_turret_a ""))
					(if (is_turret_operable area3_turret_b) (ai_vehicle_enter area3_encounter area3_turret_b ""))
				)
			)

			(sleep (game_ticks_from_seconds 10))

			; exit condition
			(or
				(volume_test_players area4_trigger)	; player progressed
				(and (<= (unit_get_health area3_turret_a) .25) (<= (unit_get_health area3_turret_b) .25))	; no more turrets
			)
		)
	1)

	(print_if debug "area3 | turret manager enabled")
)

; placing our starting group
(script dormant area3_place_intial_squads
	(print_if debug "area3 | placing initial squads")
	(ai_place area3_initial_squads)
)

; placing our investigating squads
(script dormant area3_place_front_squads
	(sleep_until
		(or
			(< (ai_living_count area3_jackals_hill_left) 1)
			(< (ai_living_count area3_turret_gunner_a) 1)
			(< (ai_living_count area3_grunts_ledge) 1)
			(volume_test_players area3_trigger_a)
		)
	1)
	(print_if debug "area3 | placing front squads")

	(ai_place area3_front_squads)
)

; place our hidden squads if they haven't aready been triggered
(script dormant area3_place_second_squads
	(sleep_until
		(or
			(volume_test_players area3_trigger_a) ; player progresses
			(> (ai_living_count area3_squads_2) 0) ; squad got spawned
			(volume_test_object area3_elite_trigger area3_elites_front) ; if our patrol elite made it this far then spawn also spawn
		)
	1)

	(print_if debug "area3 | placing hidden elite and back grunts")
	(ai_place area3_squads_2)
)

; spawn our squads patroling from the next area
(script dormant area3_place_reinforcement_squads
	(sleep_until
		(or
			(volume_test_players area3_trigger_b) ; if the player went around the hill
			(player_in_vehicle area3_turret_a)  ; if the player went over the hill and manned a turret
			(and
				(= (game_difficulty_get) "legendary") ; turret only exists on legendary
				(player_in_vehicle area3_turret_b) ; if the player went over the hill and manned a turret
			)
		)
	1)
	(print_if debug "area3 | placing reinforcements")
	(ai_place area3_reinforcements)
)

; our helpful save if we kill the elites at the start
(script dormant area3_mid_save
	(sleep_until (volume_test_players area3_trigger_a) 1)
	(sleep_until (and (< (ai_living_count area3_elites_front) 1) (< (ai_living_count area3_elites_hiding) 1) )1)

	(print_if debug "area3 | attempting mid save now that elites are dead")

	(f_game_save)
)

(script dormant area3_migrate_marines
	; does not let the marines leave area 2 until the encounter is over.
	(sleep_until (< (ai_nonswarm_count area2_encounter) 1) 1)
	(ai_disregard ai_player_fireteam true)

	; have the marines join the player so they will follow them around
	(f_fireteam_migrate_join_and_follow fireteam_area3_johnson fireteam_area3_marines fireteam_area3_fill ai_fireteam_keyes)

	; if the player begins to step out of area 2 move the marines to wait at the door for the player to progress
	(sleep_until (volume_test_players area3_trigger) 1)

	(f_fireteam_leave_player)

	(cs_run_command_script ai_fireteam_johnson cs_area2_exit_johnson)
	(cs_run_command_script ai_fireteam_marines cs_area2_exit_marine)
	(cs_run_command_script ai_fireteam_fill cs_area2_exit_marine)

	; once the player moves up the path a little marines move forward and wait for combat
	(sleep_until (volume_test_players area2_follow_player_side) 1)

	(print_if debug "fireteam | moving fireteam to encounter - area 3")
	(f_fireteam_set_objective ai_objective_enc3_area3_mar)

	(f_ai_set_integrated_flashlight ai_player_fireteam false)

	(cs_run_command_script ai_fireteam_johnson cs_area3_ready_johnson)
	(sleep (game_ticks_from_seconds .5))
	(cs_run_command_script ai_fireteam_marines cs_area3_ready_marine)
	(cs_run_command_script ai_fireteam_fill cs_area3_ready_marine)

	(sleep_until (= (f_area3_combat_started) true) 1)
	(ai_disregard ai_player_fireteam false)

	(f_ai_set_integrated_flashlight ai_player_fireteam false)

	(sleep (game_ticks_from_seconds 1.5))
	(wake vo_area3_encounter_start)
)

; tells the grunts in the turrets where to aim to give the player a better shot at killing them while in stealth.
; waiting naturally takes too long and isn't as fun
(script command_script cs_area3_turret_aim_locations
	(cs_enable_targeting true)

	(cs_abort_on_damage true)
	(cs_enable_moving true)

	(sleep_until
		(begin
			(begin_random
				(cs_face true patrol_area3_turret_targets/p0)
				(cs_face true patrol_area3_turret_targets/p1)
				(cs_face true patrol_area3_turret_targets/p2)
				(sleep (game_ticks_from_seconds 2))
				(cs_face true patrol_area3_turret_targets/p3)
				(sleep (game_ticks_from_seconds 10))
				(cs_face true patrol_area3_turret_targets/p4)
				(sleep (game_ticks_from_seconds 5))
			)

			; exit condition
			(= (f_area3_combat_started) true)
		)
	1)
)

; returns true if we have met the conditions for combat to start
(script static boolean f_area3_combat_started
	(and
		(volume_test_players area3_marine_trigger) ; volume is the size of the entire encounter
		(or
			(= (ai_living_count area3_encounter) 0)
			(>= (ai_combat_status area3_encounter) "dangerous")
		)
	)
)

(script dormant area3_vo_music_trigger
	(sleep_until
		(or
			(= (ai_living_count area3_encounter) 0)
			(volume_test_players area4_trigger_c)
		)
	1)

	(sleep_until (volume_test_players area4_trigger_b) 1)
	(wake vo_area3_ends)
	(set s_music_trigger 60)
)

;====================================================================================================================================================================================================
; encounter : area4 ==============================================================================================================================================
;====================================================================================================================================================================================================

; player enters into the area and attempts to stealthfully move through the area.
; increase the number of active turrets and number of patrols making stealth more difficult
; drop ships assist the player with extra marines if there is space and covenant ones if the player is spotted.
(script dormant enc_area4
	(print_if debug "area4 | starting area4")
	(set b_starting_at_insertion_area_4 true)
	(set b_canyon_nav_3_triggered true)

	;_____fireteam prep_____
	(print_if debug "area4 | fireteam prepping...")
	(f_fireteam_migrate_join_and_follow fireteam_area4_johnson fireteam_area4_marines fireteam_area4_fill ai_fireteam_keyes)
	(wake area4_migrate_marines)

	(print_if debug "area4 | fireteam prepped")

	;_____co-op setup_____
	(print_if debug "area4 | co-op prepping...")
	(if (game_is_cooperative)
		(begin
			;place co-op camo for more than 2 players
			(if (> (game_coop_player_count) 2) (object_create activecamo1_1))
		)
	)

	(if (not (game_is_cooperative)) (wake ini_area4_marine_reins))
	(print_if debug "area4 | co-op prepped")

	;_____initialize encounter______
	(print_if debug "area4 | encounter prepping...")

	(wake area4_place_initial_squads)
	(wake area4_place_second_squads)

	(wake area4_place_grunts_m)
	(wake ini_area4_reins)

	(wake area4_wait_for_player_fork)

	(wake area4_music_trigger)

	;(ai_activity_set area4_grunts_sleeping asleep)
	;(ai_activity_set area4_grunts_sleeping2 asleep)

	(wake ini_area4_dropship)
	;(wake ini_area4_grunts_m)
	(wake area4_turrets_spawning)
	(wake area4_turret_manager)

	(print_if debug "area4 | encounter prepped")

	;_____checkpointing_____
	(print_if debug "area4 | initial checkpointing")
	(f_game_save)

	;_____encounter start_____
	(print_if debug "area4 | encounter beginning...")

	; stealth starting
	(print_if debug "area4 | stealthing...")
	(sleep_until (volume_test_players area4_trigger_a) 1)

	; combat begins
	(sleep_until (= (f_area4_combat_started) true) 1)
	(print_if debug "area4 | combat started")
	(f_pause_auto_save_loop)

	(wake vo_area4_encounter_start)

	;(wake ini_area4_squad_2) ; active after players chose one direction
	(sleep_until (volume_test_players area4_reins_trigger) 1)

	(wake area4_music_vo_end_triggers)

	; wait until all enemies are dead
	(sleep_until (< (ai_nonswarm_count area4_encounter) 1) 1)
	(print_if debug "area4 | encounter ended")

	(f_migrate_squad_to_fireteam_marines marines_m)
	(f_migrate_squad_to_fireteam_fill marines_b)

	(f_unpause_auto_save_loop) ; combat's over so turning back on

	(f_game_save)
)

; controls the staging and precombat behavior of the marines and eventually have them join the encounter.
(script dormant area4_migrate_marines
	(print_if debug "area4 | fireteam waiting to move to area4")

	; wait until the player has crested the hill and can see the next encounter area
	(sleep_until (volume_test_players area4_trigger_b) 1)

	(f_fireteam_leave_player) ; drop the fireteam to allow them to move on their own

	(print_if debug "fireteam | moving fireteam to encounter - area 4")
	(f_fireteam_set_objective ai_objective_enc4_area4_mar)

	(ai_disregard ai_player_fireteam true) ; we are hiding the fireteam squads from the covenant until the combat begins

	; move the fireteam up to the player where they wait in cover until the combat begins
	(cs_run_command_script ai_fireteam_johnson cs_area4_ready_johnson)
	(sleep (game_ticks_from_seconds 1))
	(cs_run_command_script ai_fireteam_marines cs_area4_ready_marine)
	(sleep (game_ticks_from_seconds .5))
	(cs_run_command_script ai_fireteam_fill cs_area4_ready_marine)

	; having the fireteam not target the next encounter until we want them to
	(ai_set_blind ai_player_fireteam true)
	(ai_set_deaf ai_player_fireteam true)

	(print_if debug "area4 | marines waiting to engage or move up")

	; combat starts and we move the fireteam into the fight.
	(sleep_until (f_area4_combat_started) 1)
	(print_if debug "area4 | marines beginning combat")

	(ai_disregard ai_player_fireteam false)

	(ai_set_blind ai_player_fireteam false)
	(ai_set_deaf ai_player_fireteam false)

	(f_ai_set_integrated_flashlight ai_player_fireteam true)

)

(script dormant area4_place_initial_squads
	(print_if debug "area4 | placing intial squads")
	(ai_place area4_squad_initial)

	; begin looking for a checkpoint once the initial squad is killed
	(sleep_until (< (ai_living_fraction area4_squad_initial) 0.75) 1)
	(f_game_save)
)

(script dormant area4_place_second_squads
	(print_if debug "area4 | waiting for second squads trigger...")
	(sleep_until
		(or
			(volume_test_players area4_marines_ledge_trigger)
			(volume_test_players area4_marines_middle_trigger)
		)
	1)

	(print_if debug "area4 | placing second squads")
	(ai_place area4_elites_q)
	(ai_place area4_grunts_q)

	(if (< (ai_living_count area4_encounter) 7)
		(begin
			(print_if debug "area4 | placing conditional second squads")
			(ai_place area4_grunts_k)
		)
	)

	; begin looking for a checkpoint once the second squad is killed
	(sleep_until (< (ai_living_fraction area4_squad_second) 0.75) 1)
	(f_game_save)
)

(script dormant area4_place_grunts_m
	(print_if debug "area4 | waiting for grunts_m trigger...")
	(sleep_until
		(or
			(volume_test_players area4_grunts_m_trigger)
			(volume_test_objects area4_grunts_m_trigger (ai_actors marines_all))
		)
	1)

	(if (< (ai_living_count area4_encounter) 8)
		(begin
			(print_if debug "area4 | placing grunts_m")
			(ai_place area4_grunts_m)

			; if we put the grunts down begin looking for a checkpoint once they are wiped out.
			(sleep_until (< (ai_living_fraction area4_grunts_m) 0.75) 1)
			(f_game_save)
		)
	)
)

(script dormant ini_area4_reins
	(print_if debug "area4 | waiting for reinforcements trigger...")
	(sleep_until (volume_test_players area4_reins_trigger) 1)

	(print_if debug "area4 | placing reinforcements")
	(ai_place area4_elites_reins)

	(if (< (ai_living_count area4_encounter) 7)
		(begin
			(print_if debug "area4 | placing additional reinforcements")
			(ai_place area4_grunts_reins)
		)
	)

	; begin looking for a checkpoint once these squads are wiped.
	(sleep_until (< (ai_living_fraction area4_reinforcements) 0.75) 1)
	(f_game_save)
)

; sets the direction the player intially chose once for vo and for marine flow
(global boolean area4_player_went_right false)
(global boolean area4_player_went_left false)
(script dormant area4_wait_for_player_fork
	(sleep_until
		(or
			(volume_test_players area4_marines_ledge_trigger)
			(volume_test_players area4_marines_middle_trigger)
		)
	1)
	(print_if debug "area4 | player direction established...")
	(if (= (f_area4_get_player_side) 1)
		(begin
			(print_if debug "area4 | player went right, marines are going left")
			(set area4_player_went_right true)
		)
		(begin
			(print_if debug "area4 | player went left, marines are going right")
			(set area4_player_went_left true)
		)
	)
)

; returns a short telling us where the player is and favors player the right side to align with vo
(script static short (f_area4_get_player_side)
	(cond
		((volume_test_players area4_location_1) 1)
		((volume_test_players area4_location_2) 2)
		(true 0)
	)
)

(global vehicle v_dropship none)
(global vehicle v_pelican none)

(script dormant ini_area4_marine_reins
	(sleep_until (= (f_area4_combat_started) true) 1) ; wait until combat begins and the covenant know the player is there

 	(sleep_until (or	;check to see if the player meets conditions for reinforcements or bypassed encounter
					(and
						b_area4_pelican
						(< (ai_living_count area4_encounter) 11)
						(< (ai_living_count marines_all) 4) ; johnson can't die, and this gets us back to 8 max.
					)
					(volume_test_players area5_trigger)
				)
	1)

	(if (volume_test_players area5_trigger) (sleep_forever)) ;if they bypassed the encounter cut off reinforcements.

	;load up area4_marines based on who is missing
	(if (< (ai_living_count ai_fireteam_fill) 1) (ai_place marines_b))
	(if (< (ai_living_count ai_fireteam_marines) 1) (ai_place marines_m))

	(cond
		((< (f_area4_get_player_side) 2) (ai_place area4_pelican_a))  ; if the players are on the right or on both halves spawn the left pelican
		((>= (f_area4_get_player_side) 2) (ai_place area4_pelican_b)) ; if the players are on the left spawn the right pelican
	)

	; once we get our marine reinforcements try for a save
	(f_game_save)
)

(script command_script cs_area4_pelican_a
	(set b_area4_area4_covenant_reins false) ;ensures the dropship doesn't arrive while the pelican is dropping off marines
	; enable failsafes for the scripted flight path

	(set v_pelican (ai_vehicle_get ai_current_actor))
 	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die v_pelican true)

	(ai_vehicle_enter_immediate area4_marines v_pelican "")

	(unit_open v_pelican) ; closes door

	; entry flight path, flies to each point in sequenc
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_area4_pelican_a_flightpath/p0)
	(cs_fly_by ps_area4_pelican_a_flightpath/p2)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_area4_pelican_a_flightpath/p5 ps_area4_pelican_a_flightpath/p6 0)
	(cs_fly_to_and_face ps_area4_pelican_a_flightpath/p1 ps_area4_pelican_a_flightpath/p6 0.01)

	(unit_close v_pelican) ; opens door, trust me
	(sleep (game_ticks_from_seconds 3))
	(vehicle_unload v_pelican "pelican_p")

	(sleep_until (<= (list_count (vehicle_riders v_pelican)) 2) 1 (game_ticks_from_seconds 15.0)) ; wait till everyone is out or failsafe time expired
	(sleep (game_ticks_from_seconds 3))
	(unit_open v_pelican) ; closes door

	(print_if debug "reinforcements | flashlights enabled at area4 reinforcements start")
	(f_ai_set_integrated_flashlight area4_marines true)

	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_area4_pelican_a_flightpath/p2)
	(cs_fly_by ps_area4_pelican_a_flightpath/p3)
	(cs_fly_to ps_area4_pelican_a_flightpath/p4)

	(object_cannot_die v_pelican false)

	(f_dropship_actor_scale_destroy ai_current_actor)

	(set b_area4_area4_covenant_reins true)	;allows the dropship to reinforce again.
)

(script command_script cs_area4_pelican_b
	(set b_area4_area4_covenant_reins false) ;ensures the dropship doesn't arrive while the pelican is dropping off marines
	; enable failsafes for the scripted flight path

	(set v_pelican (ai_vehicle_get ai_current_actor))
 	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die v_pelican true)

	(ai_vehicle_enter_immediate area4_marines v_pelican "")

	(unit_open v_pelican) ; closes door

	; entry flight path, flies to each point in sequenc
	(cs_vehicle_speed 1.0)
	(cs_teleport ps_area4_pelican_b_flightpath/p0 ps_area4_pelican_b_flightpath/p1)
	(cs_fly_by ps_area4_pelican_b_flightpath/p1)
	(cs_fly_by ps_area4_pelican_b_flightpath/p2)
	(cs_fly_by ps_area4_pelican_b_flightpath/p3)
	(cs_fly_by ps_area4_pelican_b_flightpath/p4)
	(cs_fly_by ps_area4_pelican_b_flightpath/p5)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_area4_pelican_b_flightpath/p6 ps_area4_pelican_b_flightpath/p8 0)
	(cs_fly_to_and_face ps_area4_pelican_b_flightpath/p7 ps_area4_pelican_b_flightpath/p8 0.01)

	(unit_close v_pelican) ; opens door, trust me
	(sleep (game_ticks_from_seconds 3))
	(vehicle_unload v_pelican "pelican_p")

	(sleep_until (<= (list_count (vehicle_riders v_pelican)) 2) 1 (game_ticks_from_seconds 15.0)) ; wait till everyone is out or failsafe time expired
	(sleep (game_ticks_from_seconds 3))
	(unit_open v_pelican) ; closes door

	(print_if debug "reinforcements | flashlights enabled at area4 reinforcements start")
	(f_ai_set_integrated_flashlight area4_marines true)

	(cs_fly_by ps_area4_pelican_b_flightpath/p6)

	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_area4_pelican_b_flightpath/p5)
	(cs_fly_to ps_area4_pelican_b_flightpath/p4)
	(cs_fly_to ps_area4_pelican_b_flightpath/p3)
	(cs_fly_to ps_area4_pelican_b_flightpath/p2)
	(cs_fly_to ps_area4_pelican_b_flightpath/p1)
	(cs_fly_to ps_area4_pelican_b_flightpath/p0)

	(object_cannot_die v_pelican false)
	(f_dropship_actor_scale_destroy ai_current_actor)

	(set b_area4_area4_covenant_reins true)	;allows the dropship to reinforce again.
)

(script dormant ini_area4_dropship
	(sleep_until (= (f_area4_combat_started) true) 1) ; wait until combat begins and the covenant know the player is there

	(sleep (game_ticks_from_seconds 5)) ; helps with timing to not immedeately have a drop ship appear if the player exits stealth

	(sleep_until (and ; wait until our reinforce condition is met.
					b_area4_area4_covenant_reins
					(< (ai_living_count area4_encounter) 6)
				)
	1)
	(deploy_area4_dropship)
)

(script static void deploy_area4_dropship

	(ai_place area4_dropship)
	(set v_dropship (ai_vehicle_get_from_starting_location area4_dropship/pilot_spawn))

	(f_load_fork v_dropship "any" area4_squad_dropship none none none)
)

(script command_script cs_area4_dropship
	(set b_area4_pelican false) ;ensures the pelican doesn't fly in while the spirit is dropping off troops

	; enable failsafes for the scripted flight path
 	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequenc
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_area4_dropship_flightpath/p1)
	(f_blip_ai ai_current_actor 5)
	(cs_vehicle_speed 0.5)
	(cs_fly_by ps_area4_dropship_flightpath/p2)
	(set s_music_trigger 71)

	(cs_fly_to ps_area4_dropship_flightpath/p3 1)
	(unit_open v_dropship)
	(f_unload_fork_all v_dropship)
	(sleep (game_ticks_from_seconds 6))
	(unit_close v_dropship)
	(cs_fly_to_and_face  ps_area4_dropship_flightpath/p4 ps_area4_dropship_flightpath/p2 1)

	(cs_fly_by ps_area4_dropship_flightpath/p1)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_area4_dropship_flightpath/p0)

	(f_unblip_ai ai_current_actor)

	(f_dropship_actor_scale_destroy ai_current_actor)


	(set b_area4_pelican true); allows the pelican to reinforce
)

(global vehicle v_area4_turret_a none)
(global vehicle v_area4_turret_b none)
(global vehicle v_area4_turret_c none)
(global vehicle v_area4_turret_d none)
(global vehicle v_area4_turret_e none)

(global short s_limit_number_of_turrets 0)
(global short s_current_number_of_turrets 0)
(global boolean b_can_spawn_turret true)

; places turrets randomly adding more turrets for difficulties higher than normal and with co-op higher than 2 players
(script dormant area4_turrets_spawning
	(print_if debug "area4 | placing turrets...")
	(cond
		((difficulty_normal) (if (> (game_coop_player_count) 2) (set s_limit_number_of_turrets 4) (set s_limit_number_of_turrets 3)))
		((difficulty_heroic) (if (> (game_coop_player_count) 2) (set s_limit_number_of_turrets 5) (set s_limit_number_of_turrets 4)))
		((difficulty_legendary) (set s_limit_number_of_turrets 5))
	)

	(begin_random
		(if b_can_spawn_turret
			(begin
				(ai_place area4_turret_gunner_a)
				(set v_area4_turret_a (ai_vehicle_get_from_starting_location area4_turret_gunner_a/turret))
				;(object_create area4_turret_a)
				(ai_vehicle_enter area4_turret_gunner_a v_area4_turret_a "")
				(set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				(if (= s_current_number_of_turrets s_limit_number_of_turrets) (set b_can_spawn_turret false))
				(print_if debug "area4 | turret_a placed")
			)
		)
		(if b_can_spawn_turret
			(begin
				(ai_place area4_turret_gunner_b)
				(set v_area4_turret_b (ai_vehicle_get_from_starting_location area4_turret_gunner_b/turret))
				;(object_create area4_turret_b)
				(ai_vehicle_enter area4_turret_gunner_b area4_turret_b)
				(set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				(if (= s_current_number_of_turrets s_limit_number_of_turrets)(set b_can_spawn_turret false))
				(print_if debug "area4 | turret_b placed")
			)
		)
		(if b_can_spawn_turret
			(begin
				(ai_place area4_turret_gunner_c)
				(set v_area4_turret_c (ai_vehicle_get_from_starting_location area4_turret_gunner_c/turret))
				;(object_create area4_turret_c)
				(ai_vehicle_enter area4_turret_gunner_c area4_turret_c)
				(set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				(if (= s_current_number_of_turrets s_limit_number_of_turrets)(set b_can_spawn_turret false))
				(print_if debug "area4 | turret_c placed")
			)
		)
		(if b_can_spawn_turret
			(begin
				(ai_place area4_turret_gunner_d)
				(set v_area4_turret_d (ai_vehicle_get_from_starting_location area4_turret_gunner_d/turret))
				;(object_create area4_turret_d)
				(ai_vehicle_enter area4_turret_gunner_d area4_turret_d)
				(set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				(if (= s_current_number_of_turrets s_limit_number_of_turrets)(set b_can_spawn_turret false))
				(print_if debug "area4 | turret_d placed")
			)
		)
		(if b_can_spawn_turret
			(begin
				(ai_place area4_turret_gunner_e)
				(set v_area4_turret_e (ai_vehicle_get_from_starting_location area4_turret_gunner_e/turret))
				;(object_create area4_turret_e)
				(ai_vehicle_enter area4_turret_gunner_e area4_turret_e)
				(set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				(if (= s_current_number_of_turrets s_limit_number_of_turrets)(set b_can_spawn_turret false))
				(print_if debug "area4 | turret_e placed")
			)
		)
	)
)

; loops every at a set interval and attempts to forecefully man turrets with the available gunners, but will use anyone in the encounter on legendary
(script dormant area4_turret_manager
	(print_if debug "area4 | turret manager enabled")

	(sleep_until
		(begin
			(print_if debug "area4 | manning turrets...")
			(if (is_turret_operable v_area4_turret_a) (begin (print_if debug "area4 | ... left") (ai_vehicle_enter area4_turret_gunner_a v_area4_turret_a "")))
			(if (is_turret_operable v_area4_turret_b) (begin (print_if debug "area4 | ... right") (ai_vehicle_enter area4_turret_gunner_b v_area4_turret_b "")))
			(if (is_turret_operable v_area4_turret_c) (begin (print_if debug "area4 | ... left back") (ai_vehicle_enter area4_turret_gunner_c v_area4_turret_c "")))
			(if (is_turret_operable v_area4_turret_d) (begin (print_if debug "area4 | ... back") (ai_vehicle_enter area4_turret_gunner_d v_area4_turret_d "")))
			(if (is_turret_operable v_area4_turret_e) (begin (print_if debug "area4 | ... right back") (ai_vehicle_enter area4_turret_gunner_e v_area4_turret_e "")))

			(sleep (game_ticks_from_seconds 30))

			(if (= (game_difficulty_get) "legendary")
				(begin_random
					(if (< (ai_living_count area4_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area4_encounter v_area4_turret_a "")
							(sleep (game_ticks_from_seconds 30))
						)
					)
					(if (< (ai_living_count area4_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area4_encounter v_area4_turret_b "")
							(sleep (game_ticks_from_seconds 30))
						)
					)
					(if (< (ai_living_count area4_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area4_encounter v_area4_turret_c "")
							(sleep (game_ticks_from_seconds 30))
						)
					)
					(if (< (ai_living_count area4_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area4_encounter v_area4_turret_d "")
							(sleep (game_ticks_from_seconds 30))
						)
					)
					(if (< (ai_living_count area4_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area4_encounter v_area4_turret_e "")
							(sleep (game_ticks_from_seconds 30))
						)
					)

				)
			)

			; exit_condition
			(or
				(< (ai_nonswarm_count area4_encounter) 1)	; if the whole encounter is wiped
				(and ; if we are not legendary and all the gunners are dead.
					(!= (game_difficulty_get) "legendary")
					(< (ai_nonswarm_count area4_turret_gunners) 1)
				)
			)
		)
	1)

	(print_if debug "area4 | turret manager disabled")

	; give the player a save here now that we aren't forcing turrets
	(f_game_save)
)

(script dormant area4_music_trigger
	(sleep_until (>= (ai_combat_status area4_encounter) certain) 1)
	(set s_music_trigger 70)
)

(script dormant area4_music_vo_end_triggers
	(sleep_until
		(or
			(and ; all area 4 encounters are cleared
				(= (ai_nonswarm_count area4_encounter) 0)
				(script_finished "ini_area4_dropship")
				(= (ai_nonswarm_count area4_squad_dropship) 0)
			)
			; player moves past encounter
				(volume_test_players area4_vo_music_end_trigger)
		)

	1)

	(wake vo_area4_end)
	(print_if debug "objective complete | fight your way to the covenant battlecruiser")
	(f_hud_obj_complete)

	(if

		(and
			(= (ai_nonswarm_count area4_encounter) 0)
			(script_finished "ini_area4_dropship")
			(= (ai_nonswarm_count area4_squad_dropship) 0)
		)
		(begin
			(set s_music_trigger 80)
			(set b_highground_encounter_cleared true)
		)
	)
)

; returns true if we have met the conditions for combat to start
(script static boolean f_area4_combat_started
	(and
		(volume_test_players area4_trigger) ; volume is the size of the entire encounter
		(>= (ai_combat_status area4_encounter) "clear_los")
	)
)

; tells the grunts in the turrets where to aim to give the player a better shot at killing them while in stealth.
; waiting naturally takes too long and isn't as fun
; attached to the task as a command script
(script command_script cs_area4_turret_aim_locations
	(cs_enable_targeting true)

	(cs_abort_on_damage true)
	(cs_abort_on_alert true)
	(cs_enable_moving true)

	(sleep_until
		(begin
			(begin_random_count 1
				(cs_face true patrol_area4_turret_targets/p0)
				(cs_face true patrol_area4_turret_targets/p1)
				(cs_face true patrol_area4_turret_targets/p2)
				(cs_face true patrol_area4_turret_targets/p3)
				(cs_face true patrol_area4_turret_targets/p4)
				(cs_face true patrol_area4_turret_targets/p5)
				(cs_face true patrol_area4_turret_targets/p6)
				(cs_face true patrol_area4_turret_targets/p7)
				(cs_face true patrol_area4_turret_targets/p8)
				(cs_face true patrol_area4_turret_targets/p9)
			)
			(begin_random_count 1
				(sleep (game_ticks_from_seconds 1))
				(sleep (game_ticks_from_seconds 2))
				(sleep (game_ticks_from_seconds 3))
				(sleep (game_ticks_from_seconds 5))
				(sleep (game_ticks_from_seconds 8))
				(sleep (game_ticks_from_seconds 13))
			)

			; exit condition
			(= (f_area4_combat_started) true)
		)
	1)
)



;====================================================================================================================================================================================================
; encounter : area5 ==============================================================================================================================================
;====================================================================================================================================================================================================

(global boolean b_area5_waves_finished false)

;spawn and load pelican
(script static void (f_ini_area5_pelican (ai pelican_to_spawn))
	(ai_place pelican_to_spawn)
	(set v_pelican (ai_vehicle_get_from_squad pelican_to_spawn 0))

	;*(ai_place area5_marines)
	(vehicle_load_magic v_pelican "pelican_p_l01" (ai_get_object area5_marines/spawnpoint))
	(vehicle_load_magic v_pelican "pelican_p_l02" (ai_get_object area5_marines/spawnpoint1))
	(vehicle_load_magic v_pelican "pelican_p_l03" (ai_get_object area5_marines/spawnpoint2))
	(vehicle_load_magic v_pelican "pelican_p_r01" (ai_get_object area5_marines/spawnpoint3))
	(vehicle_load_magic v_pelican "pelican_p_r02" (ai_get_object area5_marines/spawnpoint4))
	;(vehicle_load_magic v_pelican "pelican_p_r03" (ai_get_object area5_marines/spawnpoint5))
	;(vehicle_load_magic v_pelican "pelican_p_r04" (ai_get_object area5_marines/spawnpoint6))
	*;
)

;fly in and drop off marines at the end of the gravlift encounter
(script command_script cs_area5_pelican
	; enable failsafes for the scripted flight path
	(set v_pelican (ai_vehicle_get ai_current_actor))

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	(unit_open v_pelican) ; closes pelican

	(ai_place area5_marines)
	(vehicle_load_magic v_pelican "pelican_p_l01" (ai_get_object area5_marines/spawnpoint))
	(vehicle_load_magic v_pelican "pelican_p_l02" (ai_get_object area5_marines/spawnpoint1))
	(vehicle_load_magic v_pelican "pelican_p_l03" (ai_get_object area5_marines/spawnpoint2))
	(vehicle_load_magic v_pelican "pelican_p_r01" (ai_get_object area5_marines/spawnpoint3))
	(vehicle_load_magic v_pelican "pelican_p_r02" (ai_get_object area5_marines/spawnpoint4))
	;(vehicle_load_magic v_pelican "pelican_p_r03" (ai_get_object area5_marines/spawnpoint5))
	;(vehicle_load_magic v_pelican "pelican_p_r04" (ai_get_object area5_marines/spawnpoint6))

	; entry flight path, flies to each point in sequenc
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_area5_pelican_flightpath/p0)
	(cs_fly_by ps_area5_pelican_flightpath/p1)
	(cs_fly_to_and_face ps_area5_pelican_flightpath/p2 ps_area5_pelican_flightpath/p3 1)
	(cs_vehicle_speed 0.5)
	;(cs_face true ps_area5_pelican_flightpath/p3)
	(unit_close v_pelican) ; opens pelican
	(cs_fly_to_and_face ps_area5_pelican_flightpath/p4 ps_area5_pelican_flightpath/p3 0.6)

	(vehicle_unload v_pelican "pelican_p")

	(sleep (game_ticks_from_seconds 8))

	(print_if debug "reinforcements | flashlights enabled at area5 reinforcements start")
	(f_ai_set_integrated_flashlight area5_marines true)


	;(sleep_until (not (vehicle_test_seat v_pelican "pelican_p")) 1)
	(wake ini_marines_to_pad)

	(unit_open v_pelican) ; closes pelican
	(cs_fly_to_and_face ps_area5_pelican_flightpath/p2 ps_area5_pelican_flightpath/p3 1)
	;(cs_face true ps_area5_pelican_flightpath/p3)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_area5_pelican_flightpath/p6 1)
	(cs_fly_by ps_area5_pelican_flightpath/p5)

	(f_dropship_actor_scale_destroy ai_current_actor)
)

;waits to trigger grunt reinforcements
(script dormant ini_area5_dropship
	(sleep_until (volume_test_players area5_dropship_trigger) 1)
	(sleep_until (< (ai_living_count area5_encounter) 3) 1)
	(deploy_area5_dropship)

)

;spawn the grunt spirit
(script static void deploy_area5_dropship
	(wake vo_area5_dropship_arrival)
	(ai_place area5_dropship)
	(set v_dropship (ai_vehicle_get_from_starting_location area5_dropship/pilot_spawn))
	(f_load_fork v_dropship "any" area5_drop none none none)
)

;fly in the grunt dropship
(script command_script cs_area5_dropship
	; enable failsafes for the scripted flight path
 	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(f_blip_ai ai_current_actor 5)

	(ai_place_in_vehicle area5_turret_gunners area5_dropship)

	; entry flight path, flies to each point in sequence
	;get out of the spawn area
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face ps_area5_dropship_flightpath/p8 ps_area5_dropship_flightpath/p0 1)
	(cs_fly_by ps_area5_dropship_flightpath/p0)

	;fly around left side of gravlift
	(cs_vehicle_speed 0.8)
	(cs_fly_by ps_area5_dropship_flightpath/p1)
	(cs_fly_by ps_area5_dropship_flightpath/p2)
	(cs_fly_by ps_area5_dropship_flightpath/p9)

	;fly to lz
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_area5_dropship_flightpath/p3 ps_area5_dropship_flightpath/p4 1)
	(set s_music_trigger 91)

	;drop troops off
	(sleep (game_ticks_from_seconds 3))
	(unit_open v_dropship)
	(f_unload_fork_all v_dropship)
	(sleep (game_ticks_from_seconds 6))
	(unit_close v_dropship)

	;fly away
	(cs_vehicle_speed 0.8)
	(cs_fly_to_and_face ps_area5_dropship_flightpath/p10 ps_area5_dropship_flightpath/p4 1)
	(cs_fly_to_and_face ps_area5_dropship_flightpath/p11 ps_area5_dropship_flightpath/p5 1)
	(cs_fly_by ps_area5_dropship_flightpath/p5)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_area5_dropship_flightpath/p7)
	(cs_fly_to ps_area5_dropship_flightpath/p6 5)

	(f_unblip_ai ai_current_actor)

	(f_dropship_actor_scale_destroy ai_current_actor)
)

;if encounter 4 is not going kill off the ai.
(script dormant ini_area4_cleanup_kill
	(if (< (ai_combat_status area4_encounter) "active")
		(ai_disposable area4_encounter true) ; swapping to dispoable as enemies could all die right in front of you just because you progressed
	)
)

(global boolean b_ready_to_lift_to_ship false) ; used to get player to lift for marines
(global boolean b_lift_pelican false)	; used in the objective editor to move marines into the lift task
(global boolean b_lift_fill false)		; used in the objective editor to move marines into the lift task
(global boolean b_lift_marines false)	; used in the objective editor to move marines into the lift task
(global boolean b_lift_johnson false)	; used in the objective editor to move johnson into the lift task
;update the marines objective and get them to the pad.
(script dormant ini_marines_to_pad
	; tell the marines not use the lift
	(set b_lift_pelican false)
	(set b_lift_fill false)
	(set b_lift_marines false)
	(set b_lift_johnson false)

	; drop fireteam so they don't follow
	(f_fireteam_leave_player)

	; move the fireteam to muster at the bottom of the lift
	(print_if debug "fireteam | adding fireteam to area5 maneuver lift")
	(f_fireteam_set_objective ai_objective_maneuver_area5_lift)

	;sleep until all the marines are in place or 10 seconds have passed (roughly the time to run there unobstructed)
	(sleep_until
		(and
			(volume_test_objects_all tv_gravlift_marine_muster (ai_actors area5_marines))
			(volume_test_objects_all tv_gravlift_marine_muster (ai_actors ai_fireteam_johnson))
			(and (volume_test_objects_all tv_gravlift_marine_muster (ai_actors ai_fireteam_fill))(> (ai_living_count ai_fireteam_fill) 0))
			(and (volume_test_objects_all tv_gravlift_marine_muster (ai_actors ai_fireteam_marines))(> (ai_living_count ai_fireteam_marines) 0))
		)
	1 (game_ticks_from_seconds 10))

	(set b_ready_to_lift_to_ship true) ; lure player to lift
	;sleep until the player is in place
	(sleep_until (volume_test_players tv_gravlift_marine_muster) 1)

	;destroy the old lift and swap to marine lift
	(object_destroy gravity_lift_a_to_ground)
	(object_create gravity_lift_a_to_ship)


	;pause for effect
	(sleep (game_ticks_from_seconds 2))

	;lift marines
	(if (> (ai_living_count ai_fireteam_marines) 0)
		(begin
			(set b_lift_marines true)

			(print_if debug "fireteam | marines flashlights disabled in area5")
			(f_ai_set_integrated_flashlight ai_fireteam_marines false)

			(cs_run_command_script ai_fireteam_marines cs_go_to_center)
			(sleep (game_ticks_from_seconds 2))
		)
	)

	;lift fill
	(if (> (ai_living_count ai_fireteam_fill) 0)
		(begin
			(set b_lift_fill true)

			(print_if debug "fireteam | fill flashlights disabled in area5")
			(f_ai_set_integrated_flashlight ai_fireteam_marines false)

			(cs_run_command_script ai_fireteam_fill cs_go_to_center)
			(sleep (game_ticks_from_seconds 2))
		)
	)

	;lift pelican
	(if (> (ai_living_count area5_marines) 0)
		(begin
			(set b_lift_pelican true)

			(print_if debug "fireteam | area5_marines flashlights disabled in area5")
			(f_ai_set_integrated_flashlight area5_marines false)

			(cs_run_command_script area5_marines cs_go_to_center)
			(sleep (game_ticks_from_seconds 2))
		)
	)

	;lift johnson
	(if (> (ai_living_count ai_fireteam_johnson) 0)
		(begin
			(set b_lift_johnson true)

			(print_if debug "fireteam | johnson flashlights disabled in area5")
			(f_ai_set_integrated_flashlight ai_fireteam_johnson false)

			(cs_run_command_script ai_fireteam_johnson cs_go_to_center)
			(sleep (game_ticks_from_seconds 2))
		)
	)

	;lift player
	(sleep (game_ticks_from_seconds 2))
	(object_create gravity_lift_player_to_ship)


	;wait until the player gets to the top of the lift.
	(sleep_until (volume_test_players gravity_trigger) 1)

	;move the area5 marines to join the fireteam
	(f_migrate_squad_to_fireteam_fill area5_marines)

)

(script command_script cs_go_to_center
	(cs_move_towards_point ps_area5_grav_center/p0 0.5)
)

;randomly spawn turrets based on difficulty
(script dormant area5_turrets_spawning
	(set b_can_spawn_turret true)
	(set s_current_number_of_turrets 0)
	(cond
		((difficulty_normal) (set s_limit_number_of_turrets 3))
		((difficulty_heroic) (set s_limit_number_of_turrets 4))
		((difficulty_legendary) (set s_limit_number_of_turrets 5)))

	(begin_random
		(if b_can_spawn_turret
			(begin (ai_place area5_turret_gunner_a)
				   (object_create area5_turret_a)
				   (ai_vehicle_enter_immediate area5_turret_gunner_a area5_turret_a)
				   (set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				   (if (= s_current_number_of_turrets s_limit_number_of_turrets)
					   (set b_can_spawn_turret false)
				   )
			)
		)
		(if b_can_spawn_turret
			(begin (ai_place area5_turret_gunner_b)
				   (object_create area5_turret_b)
				   (ai_vehicle_enter_immediate area5_turret_gunner_b area5_turret_b)
				   (set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				   (if (= s_current_number_of_turrets s_limit_number_of_turrets)
					   (set b_can_spawn_turret false)
				   )
			)
		)
		(if b_can_spawn_turret
			(begin (ai_place area5_turret_gunner_c)
				   (object_create area5_turret_c)
				   (ai_vehicle_enter_immediate area5_turret_gunner_c area5_turret_c)
				   (set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				   (if (= s_current_number_of_turrets s_limit_number_of_turrets)
					   (set b_can_spawn_turret false)
				   )
			)
		)
		(if b_can_spawn_turret
			(begin (ai_place area5_turret_gunner_d)
				   (object_create area5_turret_d)
				   (ai_vehicle_enter_immediate area5_turret_gunner_d area5_turret_d)
				   (set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				   (if (= s_current_number_of_turrets s_limit_number_of_turrets)
					   (set b_can_spawn_turret false)
				   )
			)
		)
		(if b_can_spawn_turret
			(begin (ai_place area5_turret_gunner_e)
				   (object_create area5_turret_e)
				   (ai_vehicle_enter_immediate area5_turret_gunner_e area5_turret_e)
				   (set s_current_number_of_turrets (+ 1 s_current_number_of_turrets))
				   (if (= s_current_number_of_turrets s_limit_number_of_turrets)
					   (set b_can_spawn_turret false)
				   )
			)
		)
	)

	(wake vo_area5_turret)
	(wake vo_area5_turret_response)
)
; (and (> (unit_get_health area5_turret_d) 0) (not (vehicle_test_seat area5_turret_d "")) (not (vehicle_overturned area5_turret_d)))

;encounter under the grav lift.
(script dormant enc_area5
	(set b_canyon_nav_4_triggered true)

	;_____fireteam prep_____
	(f_fireteam_migrate_join_and_follow fireteam_area5_johnson fireteam_area5_marines fireteam_area5_fill ai_fireteam_keyes)
	(wake area5_fireteam_migration)

	;_____co-op setup_____


	;_____checkpointing_____
	;chapter card
	(wake trigger_chapter_two)
	(wake area5_objectives)
	(f_game_save)

	;_____initialize encounter_____
	;set lift vfx to down.
	(device_set_position_immediate dm_vignette_grav_lift_pulse_controller 0.5)

	;place shade turrets
	(wake area5_turrets_spawning)
	(wake area5_grav_wave_manager)

	;place covenant
	(ai_place area5_initial_guard)

	;kill enemies in area4
	(wake ini_area4_cleanup_kill)
	(wake ini_area5_dropship)

	;_____combat starts_____
	(wake area5_turret_manager)
	;wait until the player enters the area near the entrance of the arena.
	(sleep_until (volume_test_players area5_music_trigger) 1)
	(set s_music_trigger 90)

	;wait until player pushes farther into the arena before beginning waves.
	(sleep_until (volume_test_players area5_dropship_trigger) 1) ; added sleep condition here because waves were started too early

	; bloodgate begins after the waves are done spawning
	(sleep_until (= b_area5_waves_finished true) 1)
	(f_hide_n_seek_safety area5_encounter)

	; bloodgate ends
	(sleep_until (< (ai_nonswarm_count area5_encounter) 1) 1)
	(f_game_save)

	;pause for a breath then spawn hunters
	(sleep (game_ticks_from_seconds 5))
	(sleep_until (objects_can_see_flag (players) canyon_navpoint5 30) 1 (game_ticks_from_seconds 5)) ; wait for players to look at the lift or 5 more seconds pass
	(f_spawn_hunter_wave)

	;wait for hunters to land and turn off lifts downward push.
	(sleep_until
		(or
			(volume_test_objects canyon_nav_reached5 (ai_actors area5_hunters))
			(<= (ai_nonswarm_count area5_hunters) 0) ; in case they get killed before landing
		)
		1
	)
	(object_set_phantom_power gravity_lift_a_to_ground false)

	;magic sight and players and cue the music
	(set s_music_trigger 100)
	(wake vo_area5_hunters_arrival)
	(ai_magically_see ai_player_fireteam area5_hunters)
	(sleep (game_ticks_from_seconds 2))

	;mark the hunters bloodgate
	(f_hide_n_seek_safety area5_encounter)

	;wait until the hunters are dead then checkpoint
	(sleep_until (= (ai_nonswarm_count area5_encounter) 0) 1)

	(f_game_save)
	(set s_music_trigger 110)

	(wake vo_area5_end)

	;wait for everyone to stop talking.
	(sleep_until b_gravpad_reins_dialogue_over 1)

	;flips the gravlift vfx, remove down lift and put in uplift.
	(device_set_position_immediate dm_vignette_grav_lift_pulse_controller 1)

	(f_ini_area5_pelican area5_pelican)
)

(script dormant area5_objectives
	(sleep_until (volume_test_players area5_music_trigger) 1)

	(print_if debug "updated objective | eliminate covenant threat")
	(f_hud_obj_new "obj_a50_covstartlift" "obj_a50_covstartlift")

	(sleep_until (>= area5_wave_count 2) 1)
	(print_if debug "updated objective | eliminate covenant reinforcements")
	(f_hud_obj_new_no_hud_completion "obj_a50_covmidlift" "obj_a50_covmidlift")

	(sleep_until (script_started "vo_area5_hunters_arrival") 1)
	(sleep (game_ticks_from_seconds 2))
	(print_if debug "updated objective | finish off covenant threat")
	(f_hud_obj_new_no_hud_completion "obj_a50_covendlift" "obj_a50_covendlift")

	(sleep_until (< (ai_nonswarm_count area5_encounter) 1) 1)
	(print "new objective | board the covenant battle cruiser")
	(f_hud_obj_new "obj_a50_boardend" "obj_a50_boardend")
)

; controls the staging and precombat behavior of the fireteam and eventually has them join the fight.
(script dormant area5_fireteam_migration
	; wait until the player has entered the stealth part of the combat.
	(sleep_until (volume_test_players area5_marines_approach) 1)

	(ai_disregard (ai_actors ai_player_fireteam) true) ; covenant ignore fireteam so they don't break stealth

	(f_fireteam_leave_player) ; drop the fireteam to allow them to move on their own.

	(print_if debug "fireteam | moving fireteam to encounter - area 5")
	(f_fireteam_set_objective ai_objective_enc5_7_area5_mar) ; move them to the next encounter objective

	; move fireteam into position and wait
	(cs_run_command_script ai_fireteam_johnson cs_area5_ready_johnson)
    (cs_run_command_script ai_fireteam_marines cs_area5_ready_marine)
	(cs_run_command_script ai_fireteam_fill cs_area5_ready_marine)

	; combat starts
	(sleep_until (f_area5_combat_started) 1)

	(ai_disregard (ai_actors ai_player_fireteam) false) ; covenant no longer ignore the fireteam

	(f_ai_set_integrated_flashlight ai_player_fireteam true)
)

(global short area5_wave_count 0)
(global short area5_wave_max 4) ; legacy default
(global short s_grav_wave_squads_max 2) ; if you go beyond 3 grunts and jackals may spawn on each other's heads
(script dormant area5_grav_wave_manager
	; set our limiters
	(set b_area5_waves_finished false)
	(set area5_wave_count 0)

	; adjust the max based on difficulty
	(cond
		((= (game_difficulty_get) "normal")(set area5_wave_max 4))		; legacy
		((= (game_difficulty_get) "heroic")(set area5_wave_max 6))		; new
		((= (game_difficulty_get) "legendary")(set area5_wave_max 8))	; legacy
	)

	; adjust squads in wave for 3-4 player co-op
	(if (> (game_coop_player_count) 2) (set s_grav_wave_squads_max 3))

	; wait until the player triggers the spawner
	(sleep_until (volume_test_players area5_dropship_trigger) 1)
	(print_if debug "area5 | wave generator enabled")

	; begin looping...
	(sleep_until
		(begin
			(sleep_until (< (ai_nonswarm_count area5_wave) 2) 1)

			; attempt to give the player a checkpoint before the wave after the first wave
			(if (> area5_wave_count 1) (f_game_save))

			(print_if debug "area5 | spawning wave...")
			(f_spawn_gravity_wave)

			(set area5_wave_count (+ area5_wave_count 1))
			(print_if debug "area5 | wave spawned!")

			; pause for a beat
			(sleep (game_ticks_from_seconds 4))

			; exit condition
			(>= area5_wave_count area5_wave_max)
		)
	1)

	(print_if debug "area5 | wave generator disabled")

	(set b_area5_waves_finished true)
)

(global short s_grav_wave_jackal_count 0)
(global short s_grav_wave_grunt_count 0)

(script static void f_spawn_gravity_wave
	(set s_grav_wave_jackal_count 0)
	(set s_grav_wave_grunt_count 0)

	; hint at incoming wave with a grav pulse
	(device_set_position_immediate dm_vignette_grav_lift_pulse_controller 0)

	(sleep (game_ticks_from_seconds 3)) ; pause to react
	(device_set_position_immediate dm_vignette_grav_lift_pulse_controller .7)

	; generate wave...
	(sleep_until
		(begin
			(begin_random
				(if (< (+ s_grav_wave_jackal_count s_grav_wave_grunt_count) s_grav_wave_squads_max)
					(begin
						(print_if debug "area5 | adding grunt to wave")
						(set s_grav_wave_grunt_count (+ 1 s_grav_wave_grunt_count))
					)
				)

				(if (< (+ s_grav_wave_jackal_count s_grav_wave_grunt_count) s_grav_wave_squads_max)
					(begin
						(print_if debug "area5 | adding jackal to wave")
						(set s_grav_wave_jackal_count (+ 1 s_grav_wave_jackal_count))
					)
				)
			)

			; exit condition
			(>= (+ s_grav_wave_jackal_count s_grav_wave_grunt_count) s_grav_wave_squads_max)
		)
	1)

	; spawn wave
	(ai_place area5_wave_jackals (* s_grav_wave_jackal_count 2))
	(begin_random_count 1 (sleep (game_ticks_from_seconds .25))(sleep (game_ticks_from_seconds .3))(sleep (game_ticks_from_seconds .4)))
	(ai_place area5_wave_grunts (* s_grav_wave_grunt_count 3))
	(begin_random_count 1 (sleep (game_ticks_from_seconds .35))(sleep (game_ticks_from_seconds .5))(sleep (game_ticks_from_seconds .65)))
	(ai_place area5_wave_elites)

	(ai_magically_see ai_player_fireteam area5_wave)
)

(script static void f_spawn_hunter_wave
	; hint at incoming wave with a grav pulse
	(device_set_position_immediate dm_vignette_grav_lift_pulse_controller 0)

	(sleep (game_ticks_from_seconds 3)) ; pause to react
	(device_set_position_immediate dm_vignette_grav_lift_pulse_controller .7)

	(ai_place area5_hunters)
)

(script static void (f_hide_n_seek_safety (ai current_target))
	(sleep_until (<= (ai_nonswarm_count current_target) 3) 1)
	(f_blip_ai current_target 1)

)

(script dormant area5_turret_manager
	(print_if debug "area5 | turret manager enabled")
	(sleep_until
		(begin
			(print_if debug "area5 | manning turrets...")
			(if (is_turret_operable area5_turret_a) (begin (print_if debug "area5 | ... left") (ai_vehicle_enter area5_turret_gunner_a area5_turret_a "")))
			(if (is_turret_operable area5_turret_b) (begin (print_if debug "area5 | ... right") (ai_vehicle_enter area5_turret_gunner_b area5_turret_b "")))
			(if (is_turret_operable area5_turret_c) (begin (print_if debug "area5 | ... left back") (ai_vehicle_enter area5_turret_gunner_c area5_turret_c "")))
			(if (is_turret_operable area5_turret_d) (begin (print_if debug "area5 | ... back") (ai_vehicle_enter area5_turret_gunner_d area5_turret_d "")))
			(if (is_turret_operable area5_turret_e) (begin (print_if debug "area5 | ... right back") (ai_vehicle_enter area5_turret_gunner_e area5_turret_e "")))

			(sleep (game_ticks_from_seconds 30))

			(if (= (game_difficulty_get) "legendary")
				(begin_random
					(if (< (ai_living_count area5_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area5_wave area5_turret_a "")
							(sleep (game_ticks_from_seconds 30))
						)
					)
					(if (< (ai_living_count area5_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area5_wave area5_turret_b "")
							(sleep (game_ticks_from_seconds 30))
						)
					)
					(if (< (ai_living_count area5_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area5_wave area5_turret_c "")
							(sleep (game_ticks_from_seconds 30))
						)
					)
					(if (< (ai_living_count area5_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area5_wave area5_turret_d "")
							(sleep (game_ticks_from_seconds 30))
						)
					)
					(if (< (ai_living_count area5_turret_gunners) 1)
						(begin
							(ai_vehicle_enter area5_wave area5_turret_e "")
							(sleep (game_ticks_from_seconds 30))
						)
					)

				)
			)

			; exit_condition
			(= b_area5_waves_finished true)
		)
	1)

	(print_if debug "area5 | turret manager disabled")
)

(script static boolean (is_turret_operable (vehicle turret))
	(and (> (unit_get_health turret) .25) (not (vehicle_test_seat turret "")) (not (vehicle_overturned turret)))
)

(script static boolean f_turrets_are_empty
	(and
		(not (vehicle_test_seat area5_turret_a ""))
		(not (vehicle_test_seat area5_turret_b ""))
		(not (vehicle_test_seat area5_turret_c ""))
		(not (vehicle_test_seat area5_turret_d ""))
		(not (vehicle_test_seat area5_turret_e ""))
	)
)

(script static boolean f_area5_combat_started
	(>= (ai_combat_status area5_initial_guard) dangerous)
)

;====================================================================================================================================================================================================
; encounter : gravity room ==============================================================================================================================================
;====================================================================================================================================================================================================



;gravity room encounter starts
(script dormant enc_gravity_room
	;_____rally point_____
	(print_if debug "rally point | a50 - unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_a50_gravity_room")

	(submit_incident_with_custom_string_id "game_activity_begin" "a50")

	;_____co-op setup_____
	(if (game_is_cooperative)
		(begin
			;pull all players to the room.
			(wake point_of_no_return_gravity_room)

			;set updated respawn profile
			(player_set_profile blam_profile_respawn_interior)

			;place extra camo
			(if (> (game_coop_player_count) 2) (object_create activecamo2_1))
		)
	)

	;_____fireteam prep_____
	(f_fireteam_migrate_join_and_follow fireteam_gravity_room_johnson fireteam_gravity_room_marines fireteam_gravity_room_fill ai_fireteam_keyes)
	(print_if debug "fireteam | flashlights disabled in gravity room")
	(f_ai_set_integrated_flashlight ai_player_fireteam false)
	(f_fireteam_leave_player)
	(print_if debug "fireteam | moving fireteam to encounter - gravity room")
	(f_fireteam_set_objective ai_objective_enc8_grav_pad_mar)

	;_____encounter setup______
	(object_set_physics gravity_lift_lid false)
	(sleep (game_ticks_from_seconds 1))

	(wake gravity_pad_wave_manager)
	(wake gravity_marines_revive)

	;put the lid in place and shut off lift
	(device_group_set gravity_lift_lid lid_position_group 0)
	(object_set_phantom_power gravity_lift_a_to_ship false)
	(object_set_phantom_power gravity_lift_player_to_ship false)
	(object_destroy gravity_lift_a_to_ship)
	(object_destroy gravity_lift_player_to_ship)

	(sleep 1)
	(object_set_physics gravity_lift_lid true)

	; load the top of the lift zone set because we can't go back down the lift.
	(switch_zone_set "set_lift_top")

	;clean up last encounter
	(ai_disposable area5_encounter true)

	;marine setup
	(sleep (game_ticks_from_seconds 0.07))
	(ai_renew marines_all)

	;create muster bay crates, doors, equipment and bodies
	(object_create_folder muster_hall_wraiths)
	(object_create_folder muster_hall_crates)
	(object_create_folder muster_hangar_hall_crates)
	(object_create_folder muster_hall_bodies)
	(object_create_folder of_muster_room_doors)
	(object_create_folder of_hangar_third_doors)
	(object_create_folder of_muster_room_eq)

	;_____start encounter_____
	(f_game_save)
	(wake set_rescue_objective)
	(wake vo_gravroom_start)

	(sleep (game_ticks_from_seconds 15))

	;_____begin combat_____
	(ai_place stealth_ini)
	(sleep (game_ticks_from_seconds 0.33))

	(ai_set_combat_status stealth_ini dangerous)

	(sleep_until ; wait until the marine knows, the elite is dead or time has passed to get the party started
		(or
			(and (>= (ai_combat_status ai_fireteam_marines) definite) (< (ai_living_fraction ai_player_fireteam) 1)) ; marines are alerted
			(<= (ai_living_count stealth_ini) 0)
		)
		1 (game_ticks_from_seconds 10)
	)

	;enable waves
	(set b_gravity_wave true)

	;_____wrap up combat_____
	(sleep_until ( = b_gravity_pad_waves_done true) 1)

	(wake vo_gravroom_end)
	(f_game_save)

	;_____move marines to door_____
	(sleep_until (script_finished "vo_gravroom_end") 1)

	(f_fireteam_leave_player)

	(wake vo_musterbay_locked_door_trigger)
	(sleep (game_ticks_from_seconds 5))

	(device_one_sided_set gravity_door_lf false)
	(device_one_sided_set gravity_door_lr false)

	(device_set_power grav_mus_hall_door 1)

	(sleep_until (volume_test_players tv_mus_grunt_bait) 1 (game_ticks_from_seconds 15))
	(ai_place grunts_all)
)

(script dormant point_of_no_return_gravity_room
	(sleep_until (volume_test_players tv_coop_teleport_grav_room) 1)

	(volume_teleport_players_not_inside gravity_trigger fl_teleport_coop_grav_lift)
)

;muster hall encounter prep
(script dormant enc_grav_mus_hall
	(set b_ship_nav_2_triggered true)

	(print "::spawns encounters::")
	(ai_place grav_mus_hall_encounter)
	(wake enc_grav_mus_hall_rear)
)

;exit encounter
(script dormant enc_grav_mus_hall_rear

	(sleep_until (volume_test_players grav_muster_top_hall) 1)
	(sleep_until (not (volume_test_players grav_leftrear_safe)) 1)
	(f_game_save)

	(ai_place grav_mus_hall_rear_encounter)
)


;_____objectives_____
;updates the player's objective
(script dormant set_rescue_objective
	(print "new objective | locate the ship's brig")
	(f_hud_obj_new "obj_a50_rescue" "obj_a50_rescue")
)

;_____waves_____
;manages enemy door waves
(script dormant gravity_pad_wave_manager

	;set wave count based on difficulty
	(cond
		( (= (game_difficulty_get) "normal") (set s_grav_wave_max s_grav_wave_max_normal))
		( (= (game_difficulty_get) "heroic") (set s_grav_wave_max s_grav_wave_max_heroic))
		( (= (game_difficulty_get) "legendary") (set s_grav_wave_max s_grav_wave_max_legendary))
	)

	;add additional waves if co-op
	(if (game_is_cooperative)
		(if (< (game_coop_player_count) 3) (set s_grav_wave_max (+ s_grav_wave_max s_grav_wave_add_coop_1_2)))
		(if (>= (game_coop_player_count) 3)
			(begin
				(set s_grav_wave_max (+ s_grav_wave_max s_grav_wave_add_coop_3_4))
				(set s_grav_wave_squad_max (+ s_grav_wave_squad_max s_grav_squad_add_coop_3_4))
			)
		)
	)

	; wait until we are ready for waves
	(sleep_until (= b_gravity_wave true) 1)

	(print_if debug "enc gravity pad | wave generator enabled")

	;while we have not spawned enough waves loop...
	(sleep_until
		(begin
			(begin_random ; spawn waves in doors not repeating a door until all are exhausted
				;left front door
				(if (and b_gravity_wave (not (volume_test_players grav_leftfront_safe)) (= (device_get_position gravity_door_lf) 0))
					(begin
						(print_if debug "enc gravity pad | left front")
						(f_gravity_pad_wave_spawn sq_grav_left_front_grunts sq_grav_left_front_grunts_b sq_grav_left_front_jackals sq_grav_left_front_elites 2)	; spawn squads in wave
						(set s_grav_wave_count (+ 1 s_grav_wave_count))	; increment our wave count
						(if (= s_grav_wave_count s_grav_wave_max) (set b_gravity_wave false))	; cancel future waves if we are at max
						(inspect s_grav_wave_count)	; debug out our current wave
						(ai_renew ai_player_fireteam)
						(sleep_until (<= (ai_living_count sg_grav_left_front) 1) 30 (game_ticks_from_seconds 15))
					)
				)

				;left rear door
				(if (and b_gravity_wave (not (volume_test_players grav_leftrear_safe)) (= (device_get_position gravity_door_lr) 0))
					(begin
						(print_if debug "enc gravity pad | left rear")
						(f_gravity_pad_wave_spawn sq_grav_left_rear_grunts sq_grav_left_rear_grunts_b sq_grav_left_rear_jackals sq_grav_left_rear_elites 2)
						(set s_grav_wave_count (+ 1 s_grav_wave_count))
						(if (= s_grav_wave_count s_grav_wave_max) (set b_gravity_wave false))
						(inspect s_grav_wave_count)
						(sleep_until (<= (ai_living_count sg_grav_left_rear) 1) 30 (game_ticks_from_seconds 15))
						(ai_renew ai_player_fireteam)
					)
				)

				;right front door
				(if (and b_gravity_wave (not (volume_test_players grav_rightfront_safe)) (= (device_get_position gravity_door_rf) 0))
					(begin
						(print_if debug "enc gravity pad | right front")
						(f_gravity_pad_wave_spawn sq_grav_right_front_grunts sq_grav_right_front_grunts_b sq_grav_right_front_jackals sq_grav_right_front_elites 2)
						(set s_grav_wave_count (+ 1 s_grav_wave_count))
						(if (= s_grav_wave_count s_grav_wave_max) (set b_gravity_wave false))
						(inspect s_grav_wave_count)
						(sleep_until (<= (ai_living_count sg_grav_right_front) 1) 30 (game_ticks_from_seconds 15))
						(ai_renew ai_player_fireteam)
					)
				)

				;right rear door
				(if (and b_gravity_wave (not (volume_test_players grav_rightrear_safe)) (= (device_get_position gravity_door_rr) 0))
					(begin
						(print_if debug "enc gravity pad | right rear")
						(f_gravity_pad_wave_spawn sq_grav_right_rear_grunts sq_grav_right_rear_grunts_b sq_grav_right_rear_jackals sq_grav_right_rear_elites 2)
						(set s_grav_wave_count (+ 1 s_grav_wave_count))
						(if (= s_grav_wave_count s_grav_wave_max) (set b_gravity_wave false))
						(inspect s_grav_wave_count)
						(sleep_until (<= (ai_living_count sg_grav_right_rear) 1) 30 (game_ticks_from_seconds 15))
						(ai_renew ai_player_fireteam)
					)
				)
			)

			;exit condition
			(= b_gravity_wave false)
		)
	1)
	(print_if debug "enc gravity pad | wave generator disabled")

	;wait until all enemies are cleared
	(f_hide_n_seek_safety gravity_pad_encounter)
	(sleep_until (< (ai_nonswarm_count gravity_pad_encounter) 1) 1)

	; checkpoint before last wave
	(f_game_save)
	(print_if debug "enc gravity pad | door waves cleared")

	; pause for moment then spawn the final wave from the tank door and open the door
	(sleep (game_ticks_from_seconds 5))
	(print_if debug "enc gravity pad | tank door")
	(ai_place sg_grav_tank_door)

	(device_set_power gravity_bay_door 1)
	(device_set_position gravity_bay_door 1)

	; mark our final bloodgate
	(f_hide_n_seek_safety gravity_pad_encounter)

	;give a little time for the enemies to come out or they are all dead
	;(sleep_until (<= (ai_living_count gravity_pad_encounter) 0) 1 (game_ticks_from_seconds 10))

	(sleep_until (<= (ai_nonswarm_count gravity_pad_encounter) 0) 1)

	;waves are done wrap up.
	(print_if debug "enc gravity pad | all clear")
	(set b_gravity_pad_waves_done true)
)

;takes a group 4 spawners and a short then spawns a number of the squads up to the limit.
(global short wave_spawn_count 0)
(script static void (f_gravity_pad_wave_spawn (ai grunts_a)(ai grunts_b)(ai jackals)(ai elites)(short wave_spawn_limit))
	(print_if debug "enc gravity pad | spawning...")
	(set wave_spawn_count 0)

	(sleep_until ; while we haven't spawned enough squads loop...
		(begin
			(begin_random ; randomly select which squad to spawn without repeating unless all are exhausted
				(if (< wave_spawn_count wave_spawn_limit) ; as long as we haven't matched or exceeded the limit...
					(begin
						(print_if debug "enc gravity pad | grunts")
						(set wave_spawn_count (+ 1 wave_spawn_count)) ; increment our counter of squads towards the maximum
						(ai_place grunts_a)
						(ai_magically_see grunts_a ai_fireteam_fill)
					)
				)
				(if (< wave_spawn_count wave_spawn_limit)
					(begin
						(print_if debug "enc gravity pad | jackals")
						(set wave_spawn_count (+ 1 wave_spawn_count))
						(ai_place jackals)
						(ai_magically_see jackals ai_fireteam_fill)
					)
				)
				(if (< wave_spawn_count wave_spawn_limit)
					(begin
						(print_if debug "enc gravity pad | grunts")
						(set wave_spawn_count (+ 1 wave_spawn_count))
						(ai_place grunts_b)
						(ai_magically_see grunts_b ai_fireteam_fill)
					)
				)
				(if (< wave_spawn_count wave_spawn_limit)
					(begin
						(print_if debug "enc gravity pad | elite")
						(set wave_spawn_count (+ 1 wave_spawn_count))
						(ai_place elites)
						(ai_magically_see elites ai_fireteam_fill)
					)
				)
			)

			; exit condition
			(>= wave_spawn_count wave_spawn_limit)
		)
	1)
	(print_if debug "enc gravity pad | wave spawned")
)

; heal and restock marines that are alive at certain wave counts until the encounter is over
(script dormant gravity_marines_revive
	(sleep_until (or (= 2 s_grav_wave_count) (= b_gravity_pad_waves_done true)) (game_ticks_from_seconds 2))
	(print_if debug "enc gravity pad | marines refreshed")
	(ai_renew ai_player_fireteam)

	(sleep_until (or (= 4 s_grav_wave_count) (= b_gravity_pad_waves_done true)) (game_ticks_from_seconds 2))
	(print_if debug "enc gravity pad | marines refreshed")
	(ai_renew ai_player_fireteam)

	(sleep_until (or (= 6 s_grav_wave_count) (= b_gravity_pad_waves_done true)) (game_ticks_from_seconds 2))
	(print_if debug "enc gravity pad | marines refreshed")
	(ai_renew ai_player_fireteam)

	(sleep_until (or (= 8 s_grav_wave_count) (= b_gravity_pad_waves_done true)) (game_ticks_from_seconds 2))
	(print_if debug "enc gravity pad | marines refreshed")
	(ai_renew ai_player_fireteam)

	(sleep_until (or (= 10 s_grav_wave_count) (= b_gravity_pad_waves_done true)) (game_ticks_from_seconds 2))
	(print_if debug "enc gravity pad | marines refreshed")
	(ai_renew ai_player_fireteam)

)



;_____command scripts_____
;make the camo elite go berserk on entrance
(script command_script cs_init_strealth_intro
	(sleep (game_ticks_from_seconds 0.17))

	(ai_set_active_camo ai_current_actor true)

	(ai_magically_see ai_current_actor ai_fireteam_fill)

	(ai_prefer_target_ai ai_current_actor ai_fireteam_fill true)

	(sleep (game_ticks_from_seconds 3))

	(cs_move_towards_point (ai_nearest_point ai_current_actor initial_stealth_elite_intro) 1)

	(cs_action_at_player ai_action_berserk)

	;(ai_disregard ai_fireteam_johnson true)

	;(cs_move_towards ai_fireteam_fill true)

)
;enemies prefer marines
(script command_script cs_target_marines
	(ai_prefer_target_team ai_current_actor human)
)
;enemies prefer player
(script command_script cs_target_player
	(ai_prefer_target_team ai_current_actor player)
)

;marines move to lower tank door waiting to be given access to muster room
(script command_script cs_gravity_pad_go_to_door
	(cs_ignore_obstacles true)
	(cs_move_towards_point ps_gravity_pad_destination/p0 0.5)
	(cs_go_by ps_gravity_pad_destination/p1 ps_gravity_pad_destination/p2 1)
	(cs_go_by ps_gravity_pad_destination/p2 ps_gravity_pad_destination/p3 1)
	(cs_go_by ps_gravity_pad_destination/p3 ps_gravity_pad_destination/p4 1)
	(cs_go_to_and_face ps_gravity_pad_destination/p5 ps_gravity_pad_destination/p5)

	;updating this when we cover encounters
	;(ai_set_objective ai_current_squad aiobjective_gravity_pad_door) ; wait_for_open_mus_bay_door
)

;====================================================================================================================================================================================================
; encounter : muster hall ==============================================================================================================================================
;====================================================================================================================================================================================================

; put a nav on how to get the marines unblocked
(script dormant muster_door_navpoint
	(sleep_until (volume_test_players muster_view_door) 1)
	(wake vo_musterbay_unlock_door_prompt) ; johnson is always alive so we always want to play this
)

; encounter in hall leading from top floor to bottom floor
(script dormant enc_muster_hall
	(sleep_until
		(or
			(volume_test_players mus_hangar_ledgehall) ; check entering top door
			(volume_test_players muster_floor_trigger) ; check entering bottom door
		)
	1)

	; checkpoint
	(f_game_save)

	; place units
	(ai_place muster_hall_encounter)
)

; handle the marines involvement in the encounter
(script dormant marines_muster_bay
	(sleep_until (= (device_get_position muster_bay_control) 1) 1) ; wait for the player to press the button for the door.
	(device_set_power muster_bay_door 1) ; power the door

	(sleep_until (> (device_get_position muster_bay_door) 0) 1) ; wait for the door to open
	(device_set_power muster_bay_control 0)

	; marines join the fireteam
	(f_fireteam_join_player)

	(ai_renew ai_player_fireteam) ; freshen the marines
)

(script dormant enc_muster_hangar_hall
	(sleep_until (volume_test_players muster_hangar_hall_trigger) 1)
	(ai_place muster_hangar_hall_encounter)
)

(script dormant enc_muster_bay
	(print_if debug "enc10 | encounter started...")

	;_____fireteam prep_____
	(f_fireteam_migrate_join_and_follow fireteam_grav_mus_hall_johnson fireteam_grav_mus_hall_marines fireteam_grav_mus_hall_fill ai_fireteam_keyes)
	(f_fireteam_leave_player)

	;_____checkpointing_____
	(f_game_save)

	;_____encounter setup_____
	; place covenant
	(ai_place muster_ini_encounter) ; lower units
	(wake place_muster_ledge)	; ledge units

	; begin looking to pull previous encounters to the muster bay
	(wake grav_mus_hall_joins_muster_bay)

	; prep marines
	(wake muster_door_navpoint)
	(wake marines_muster_bay)

	; prep next encounters
	(wake enc_muster_hall) ; encounter leading from top to bottom
	(wake enc_muster_hangar_hall) ; encounter after this leading to the hangar

	;_____encounter begins_____
	; wait until the player has dropped down and the bottom units are reduced
	(sleep_until (volume_test_players muster_floor_trigger) 1); player is on bottom floor

	; wait a beat after the player enters the space
	(sleep (game_ticks_from_seconds 2))

	; mark bloodgate
	(f_hide_n_seek_safety enc_muster_bay)

	; wait for the bloodgate to complete
	(sleep_until (< (ai_nonswarm_count enc_muster_bay) 1) 1) ; (top, hall, and bottom)

	;unlocking doors to exit the muster hall
	(device_one_sided_set muster_door_l7 false)
	(device_one_sided_set muster_door_l8 false)
	(device_one_sided_set muster_door_l9 false)

	; checkpointing again
	(f_game_save)

	; wait until the door opens before our marines play there lines
	(sleep_until (> (device_get_position muster_bay_door) 0) 1) ; wait for the door to open

	; give the marines a second to enter the room or combat to cool off
	(sleep (game_ticks_from_seconds 2))

	(wake vo_musterbay_door_open) ; this is the all clear sir line
)

; place the covenant on the top floor
(script dormant place_muster_ledge
	; always place our elites
	(ai_place ledge_elites_back)
	(ai_place ledge_elites_side)

	; place 2 of the 3 supporting squads
	(if
		(or
			(= (game_difficulty_get) legendary)
			(> (game_coop_player_count) 2)
		)
		(begin ; place everyone on high difficulty or 3-4 player co-op
			(ai_place ledge_grunts_middle)
			(ai_place ledge_jackals_back)
			(ai_place ledge_jackals_side)
		)
		(begin_random_count 2 ; place only some squads on lower difficulty or 1 - 2 player co-op
			(ai_place ledge_grunts_middle)
			(ai_place ledge_jackals_back)
			(ai_place ledge_jackals_side)
		)
	)
)

(script dormant grav_mus_hall_joins_muster_bay
	; wait for player to progress to the encounter
	(sleep_until (volume_test_players muster_bay_top_entrance) 1)
	(print_if debug "enc10 | migrating enc9 to enc10")

	; move our previous elites to our side elites
	(ai_migrate muster_elites ledge_elites_side)
	(ai_migrate sidehall_elites_right ledge_elites_side)

	; move the previous jackals and grunts into the back grunt squad and jackal squad
	(ai_migrate grav_mus_hall_rear_encounter ledge_grunts_middle)
	(ai_migrate sidehall_jackal_left ledge_grunts_middle)
	(ai_migrate muster_grunts ledge_jackals_side)
	(ai_migrate sidehall_grunts_right ledge_jackals_side)
)

;====================================================================================================================================================================================================
; encounter : hangar ==============================================================================================================================================
;====================================================================================================================================================================================================

(global boolean b_hangar_floor_1_waves_complete false)
; hangar drop ships
; the hangar door animation contains opening and closing, so we set the position to .5
; to have it stay open for the duration of the pelican/drop ship
(script static void (f_open_hangar_door)
	(device_set_position dm_hangar_bay_door 1)
)

(script static void (f_close_hangar_door)
	(device_set_position dm_hangar_bay_door 0)
)

; spirit
; handles the initial spirit
(script dormant ini_hover_hangar_dropship
 	(ai_place hangar_dropship_a)

	; the rest of the wave behavior is managed in cs_hangar_dropship
	(sleep_until (<= (ai_nonswarm_count hangar_dropship_a) 0) 1)
	(set b_dropship_departed true)
)

; commmand script to fly out the initial spirit
(script command_script cs_hangar_dropship
	(cs_ignore_obstacles true)

	; have the spirit hover in place until we open the door and see it.
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)
	(sleep_until (> (device_get_position hangar_first_floor_entr) 0) 1)

	; open the large shield door of the hangar
	(f_open_hangar_door)

	; close the spirit side doors and wait for them to close
	(unit_close (ai_vehicle_get ai_current_actor))
	(sleep (game_ticks_from_seconds 1))

	; stop hovering and take off
	(vehicle_hover (ai_vehicle_get ai_current_actor) false)

	(cs_enable_pathfinding_failsafe true) ; enable failsafes for the scripted flight path
	(cs_vehicle_speed 1)

	(cs_fly_by ps_hangar_dropship_a_flightpath/p0)
	(cs_fly_by ps_hangar_dropship_a_flightpath/p1)
	(cs_fly_by ps_hangar_dropship_a_flightpath/p2)

	(cs_vehicle_speed 0.6)
	(cs_ignore_obstacles true)

	; if its co-op or legendary we don't get reinforcements from foehammger so shut the door.
	(if
		(or
			(game_is_cooperative)
			(= (game_difficulty_get) legendary)
		)
		(f_close_hangar_door)
	)

	(cs_fly_by ps_hangar_dropship_a_flightpath/p3)
	(cs_fly_by ps_hangar_dropship_a_flightpath/p4)

	; despose of the spirit
	(f_dropship_actor_scale_destroy ai_current_actor)

)

; pelican a
; run the setup for the first pelican reinforcements on level 1
(script dormant ini_hangar_pelican_a
	(print_if debug "hangar | starting pelican a reinforcements ...")

	; do not allow reinforcements on legendary
	(if (= (game_difficulty_get) "legendary") (begin (print_if debug "hangar | sleeping pelican a reinforcements due to legendary") (sleep_forever)))

	; wait for the hangar door to open!
	(sleep_until (> (device_get_position hangar_first_floor_entr) 0) 1)

	; wait for the player to meet the marines remaining requirements
	(sleep_until
		(or
			(<= (ai_living_count marines_all) 3) ; we want to limit the max amount of marines here to 8, we get 5 with the reinforcements here
			b_hangar_floor_1_waves_complete
		)
	1)

	(if b_hangar_floor_1_waves_complete
		(begin
			(print_if debug "hangar | sleeping pelican a reinforcements due to waves complete")
			(f_close_hangar_door) ; close the door
			(sleep_forever)
		)
	) ; if we completed the waves then we are stopping the reinforcements

	; if players are not in the trigger volume then cancel our reinforcements. we only want these if the player has just entered the hangar with low amount of marines
	(if (not (volume_test_players hangar_pelican_a_trigger))
		(begin
			(print_if debug "hangar | sleeping pelican a reinforcements due player not in volume")
			(f_close_hangar_door) ; close the door
			(sleep_forever)
		)
	)

	; begin vo for incoming reinforcements and wait for conversation to end
	(wake vo_hangar_pelican_call)
	(sleep_until b_hangar_pelican_dialogue_over 1)

	(print_if debug "hangar | calling in pelican a reinforcements")
	(deploy_hangar_pelican_a)
)

; places the first pelican and reinforcement marine squad
(script static void deploy_hangar_pelican_a
	(ai_place hangar_pelican_a)
	(set v_pelican (ai_vehicle_get_from_squad hangar_pelican_a 0))

	(ai_place_in_vehicle hangar_marines_reins hangar_pelican_a)
)

; command script for the initial pelican reinforcements at the start of the hangar encounter
(script command_script cs_hangar_pelican_a
	(set v_pelican (ai_vehicle_get ai_current_actor))

	; enable failsafes for the scripted flight path
 	(cs_enable_pathfinding_failsafe false)
	(cs_ignore_obstacles true)
	(ai_cannot_die ai_current_squad true)

	(unit_open v_pelican) ; close the door to start

	; entry flight path, flies to each point in sequence
	(cs_teleport ps_hangar_pelican_a_flightpath/spawnpoint ps_hangar_pelican_a_flightpath/spawn_facing_point)

	;open the hangar door
	(f_open_hangar_door)

	(cs_fly_by ps_hangar_pelican_a_flightpath/spawn_facing_point)
	(cs_vehicle_speed 0.7)
	(cs_fly_to_and_face ps_hangar_pelican_a_flightpath/p1 ps_hangar_pelican_a_flightpath/p8 0.1)

	(cs_vehicle_speed 0.4)
	(cs_fly_to_and_face ps_hangar_pelican_a_flightpath/p3 ps_hangar_pelican_a_flightpath/landing_facing_point 0.1)
	(cs_fly_to_and_face ps_hangar_pelican_a_flightpath/p4 ps_hangar_pelican_a_flightpath/landing_facing_point 0.1)
	(sleep (game_ticks_from_seconds 1))

	(unit_close v_pelican)
 	(sleep (game_ticks_from_seconds 2))
	(vehicle_unload v_pelican "pelican_p_l05")
	(vehicle_unload v_pelican "pelican_p_r05")
	(sleep (game_ticks_from_seconds 0.5))

	(vehicle_unload v_pelican "pelican_p_l04")
	(vehicle_unload v_pelican "pelican_p_r04")
	(sleep (game_ticks_from_seconds 0.5))

	(vehicle_unload v_pelican "pelican_p_l03")
	(vehicle_unload v_pelican "pelican_p_r03")
	(sleep (game_ticks_from_seconds 0.5))

	(vehicle_unload v_pelican "pelican_p_l02")
	(vehicle_unload v_pelican "pelican_p_r02")
	(sleep (game_ticks_from_seconds 0.5))

	(vehicle_unload v_pelican "pelican_p_l01")
	(vehicle_unload v_pelican "pelican_p_r01")
	(sleep (game_ticks_from_seconds 3))

	(unit_open v_pelican)
	(sleep (game_ticks_from_seconds 1))

	(cs_vehicle_speed 1)
	(cs_fly_by ps_hangar_pelican_a_flightpath/p3)
	(cs_fly_by ps_hangar_pelican_a_flightpath/p1 1)
	(cs_fly_by ps_hangar_pelican_a_flightpath/spawn_facing_point)
	(cs_fly_by ps_hangar_pelican_a_flightpath/lastpoint 1)

	;close the hangar door
	(f_close_hangar_door)

	(ai_disposable ai_player_fireteam false)

	(f_migrate_squad_to_fireteam_fill hangar_marines_reins)

	(f_fireteam_set_objective ai_objective_enc14_15_hangar_mar)

	(sleep (game_ticks_from_seconds 2))

	(f_dropship_actor_scale_destroy ai_current_actor)
)

; pelican b
; run the setup for the second pelican reinforcments on level 2
(script dormant ini_hangar_pelican_b
	(print_if debug "hangar | starting pelican b reinforcements ...")

	; do not allow reinforcements on legendary
	(if (= (game_difficulty_get) "legendary") (begin (print_if debug "hangar | sleeping pelican b reinforcements due to legendary") (sleep_forever)))

	; wait until the player has completed the 1st floor and has progressed to the second
	(sleep_until b_hangar_door_should_open 1)

	(sleep_until (volume_test_players hangar_second_reins_trigger) 1) ; wait until the player reaches the path on level 2

	; enable the nav loop for the switch and wait for the device to be used
	(wake f_hangar_b_console_loop)
	(sleep_until (= (device_get_position hangar_door_b_control) 1) 1)

	; disable the nav leading the player to the switch and turn it off
	(sleep_forever f_hangar_b_console_loop)
	(f_unblip_object hangar_door_b_control)
	(device_set_power hangar_door_b_control 0)

	; ensure pelican a isn't somehow alive so we avoid a foehammer paradox
	(sleep_until (< (ai_living_count hangar_pelican_a) 1) 1)
	(f_game_save)

	(print_if debug "hangar | calling in pelican b reinforcements")
	(deploy_hangar_pelican_b)
)

; places the second pelican and reinforcement marine squad
(script static void deploy_hangar_pelican_b
	(ai_place hangar_pelican_b)
	(set v_pelican (ai_vehicle_get_from_squad hangar_pelican_b 0))

	(ai_place_in_vehicle hangar_marines_reins2 hangar_pelican_b)
)

; command script for the second floor pelican reinforcements
(script command_script cs_hangar_pelican_b
	(set v_pelican (ai_vehicle_get ai_current_actor))

	; enable failsafes for the scripted flight path
 	(cs_enable_pathfinding_failsafe false)
	(cs_ignore_obstacles true)
	(ai_cannot_die ai_current_squad true)

	(unit_open v_pelican) ; close pelican

	(cs_teleport ps_hangar_pelican_b_flightpath/spawnpoint ps_hangar_pelican_b_flightpath/spawnpoint)
	;open the hangar door
	(f_open_hangar_door)

	(cs_vehicle_speed 0.75)
	; entry flight path, flies to each point in sequence
	(cs_fly_to_and_face ps_hangar_pelican_b_flightpath/p1 ps_hangar_pelican_b_flightpath/p5 0.5)

	(cs_vehicle_speed 0.4)
	(cs_fly_to_and_face ps_hangar_pelican_b_flightpath/p6 ps_hangar_pelican_b_flightpath/p5 0.5)

	(cs_fly_to_and_face ps_hangar_pelican_b_flightpath/p2 ps_hangar_pelican_b_flightpath/p4 0.5)
	(sleep (game_ticks_from_seconds 1))

	(unit_close v_pelican) ; open and unload
 	(sleep (game_ticks_from_seconds 3))
	(vehicle_unload v_pelican "pelican_p")
	(sleep (game_ticks_from_seconds 3))

	(unit_open v_pelican) ; close and leave
	(ai_disposable ai_player_fireteam false)

	(f_migrate_squad_to_fireteam_fill hangar_marines_reins2)

	(f_fireteam_set_objective ai_objective_enc14-15_hangar_mar)

	(cs_fly_to_and_face ps_hangar_pelican_b_flightpath/p6 ps_hangar_pelican_b_flightpath/p5 1)

	(cs_vehicle_speed 0.7)
	(cs_fly_to_and_face ps_hangar_pelican_b_flightpath/p1 ps_hangar_pelican_b_flightpath/p5 1)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_hangar_pelican_b_flightpath/lastpoint 0.1)

	;close the hangar door
	(f_close_hangar_door)

	(sleep (game_ticks_from_seconds 2))
	;(ai_erase ai_current_squad)
	(ai_cannot_die ai_current_squad false)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

; begins loop for reinforcement nav marker
(script dormant f_hangar_b_console_loop
	(sleep_until (f_blip_foehammer_b_console) 1)
)

; loop body for the pelican b nav marker and switch
(script static boolean f_blip_foehammer_b_console
	; check to see if the player can reinforce and manage the button/nav accordingly.
	(if (player_can_call_foehammer_b)
		(begin
			(f_blip_object hangar_door_b_control 0)
			(device_set_power hangar_door_b_control 1)
			false
		)
		(begin
			(f_unblip_object hangar_door_b_control)
			(device_set_power hangar_door_b_control 0)
			false
		)
	)
)

; checks to ensure we meet the criteria for reinforcements
(script static boolean player_can_call_foehammer_b
	;could add a check to see if we've already used the console, but using the console sleeps the function that runs this check anyway, so...
	(and
		(< (objects_distance_to_object (players) hangar_door_b_control) 20)
		(<= (ai_living_count ai_player_fireteam) 3) ;we want to keep the marines limited to 8 max here. 5 come in to reinforce
	)
)

; encounter scripts

; encounter 14 - level 1 wave encounter
(global short s_hangar_floor_1_current_wave 0)
(global boolean b_hangar_floor_1_support_ended false)
(script dormant hangar_floor_1
	(print_if debug "enc14 | beginning...")

	;_____wave 1_____
	(sleep_until (f_hangar_combat_started) 1)
	(print_if debug "hangar | combat started")
	(f_game_save)

	(set s_hangar_floor_1_current_wave 1)
	(print_if debug "enc14 | wave 1 begins")

	; renew marines
	(ai_renew marines_all)

	; give marines a head start on the next location before we spawn the wave
	(sleep (game_ticks_from_seconds 3))

	; update objective
	(print_if debug "updated objective | eliminate covenant threat")
	(f_hud_obj_new_no_hud_completion "obj_a50_covstartship" "obj_a50_covstartship")

	; spawn the wave
	(wake spawn_hangar_floor_1_wave_a)

	;_____wave 2_____
	(sleep_until (volume_test_players tv_hangar_floor_1_wave_b) 1 (game_ticks_from_seconds 30))


	(set s_hangar_floor_1_current_wave 2)
	(print_if debug "enc14 | wave 2 begins")

	(if (= (game_difficulty_get) "normal")(f_game_save))

	; give marines a head start on the next location before we spawn the wave
	(sleep_until (< (ai_nonswarm_count enc_hangar_floor_1) 3) 1 (game_ticks_from_seconds 15))

	; update objective
	(print_if debug "updated objective | eliminate covenant reinforcements")
	(f_hud_obj_new_no_hud_completion "obj_a50_covmidship" "obj_a50_covmidship")

	; spawn the wave
	(wake spawn_hangar_floor_1_wave_b)

	;_____wave 3_____
	(sleep_until (volume_test_players tv_hangar_floor_1_wave_d) 1 (game_ticks_from_seconds 30))


	(set s_hangar_floor_1_current_wave 3)
	(print_if debug "enc14 | wave 3 begins")

	(f_game_save)

	; give marines a head start on the next location before we spawn the wave
	(sleep_until (< (ai_nonswarm_count enc_hangar_floor_1) 3) 1 (game_ticks_from_seconds 10))

	; renew marines
	(ai_renew marines_all)

	; spawn the wave
	(wake spawn_hangar_floor_1_wave_d)

	;_____wave 4_____
	(sleep_until (volume_test_players tv_hangar_floor_1_wave_e) 1 (game_ticks_from_seconds 20))


	(set s_hangar_floor_1_current_wave 4)
	(print_if debug "enc14 | wave 4 begins")

	(if (= (game_difficulty_get) "normal")(f_game_save))

	; give marines a head start on the next location before we spawn the wave
	(sleep_until (< (ai_living_count enc_hangar_floor_1) 6) 1)

	; spawn the wave
	(wake spawn_hangar_floor_1_wave_e)

	;_____wave 5_____
	(sleep_until (volume_test_players tv_hangar_floor_1_wave_f) 1 (game_ticks_from_seconds 20))

	(set s_hangar_floor_1_current_wave 5)
	(print_if debug "enc14 | wave 5 begins")

	; give marines a head start on the next location before we spawn the wave
	(sleep_until (< (ai_nonswarm_count enc_hangar_floor_1) 3) 1 (game_ticks_from_seconds 5))

	; renew marines
	(ai_renew marines_all)

	; spawn the wave
	(wake spawn_hangar_floor_1_wave_f)

	; wait for our waves to hit a lower limit
	(sleep_until (< (ai_nonswarm_count enc_hangar_floor_1) 3) 1)

	(print_if debug "enc14 | completed")
	(set b_hangar_floor_1_waves_complete true)

	(f_game_save)

)

; encounter 15 - boss fight
(script dormant ini_hangar_hall_open
	(print_if debug "enc15 | waiting...")

	(sleep_until b_hangar_floor_1_waves_complete 1)
	(f_game_save)

	(print_if debug "enc15 | beginning...")

	(sleep (game_ticks_from_seconds 2))

	; update objectives
	(print_if debug "updated objective | finish off covenant threat")
	(f_hud_obj_new_no_hud_completion "obj_a50_covendship" "obj_a50_covendship")

	; place our hunters in a way that more resembles legacy's fallbacks
	(f_spawn_hangar_hunters)

	(set s_music_trigger 170)
	(sleep (game_ticks_from_seconds 1))

	;blip the remaining enemies when we drop to 3
	(f_hide_n_seek_safety enc_hangar)

	; wait until all of the floor 1 enemies are dead
	(sleep_until (= (ai_nonswarm_count enc_hangar) 0) 1)
	(set s_music_trigger 180)

	(sleep (game_ticks_from_seconds 3))

	(wake vo_hangarbay_end)

	; wait until cortana can open our doors
	(sleep_until b_hangar_door_should_open 1 (game_ticks_from_seconds 25)) ; time out after 26 seconds to prevent soft blocks

	; open seaseme
	(f_open_hangar_exit)

	; update objectives
	(print_if debug "new objective | ascend to a higher deck")
	(f_hud_obj_new "obj_a50_ascend" "obj_a50_ascend")

	; checkpointing
	(f_game_save)
)

; encounter 16 - hall leading to level 2
(script dormant enc_hangar_lefthall
	(print_if debug "enc16 | waiting...")
	; wait until our next door is open and we've pushed into it.

	(sleep_until
		(or
			(and	; golden path
				b_hangar_door_should_open
				(volume_test_players hangar_l_hall_trigger)
			)
			(volume_test_players hangar_second_trigger_a) ; player made it to level 2 and back tracked into the hall
		)
	1)

	(print_if debug "enc16 | beginning...")
	(f_game_save)
	; there should be no second floor enemies by this point so this is just to do a safety check.
	(ai_disposable hangar_second_encounter true)

	; spawn our initial squads
	(ai_place grunts_w)
	(ai_place hangar_f_2_hall_corner)

	; move any floor 1 troops into the hall and flank the player
	(ai_migrate enc_hangar_floor_1 grunts_w)

	; spawn our stealth units at the end of the hall
	(ai_place hangar_f_2_hall_pillar_1)
	(ai_place hagar_f_2_hall_pillar_2)

	; wait until the player clears the entire hall or pushes far enough in
	(sleep_until
		(and
			(< (ai_nonswarm_count enc_hangar_floor_2_hall) 1)
			(volume_test_players hangar_left_hall_pillars)
		)
	1)

	; a handy save
	(f_game_save)

	(print_if debug "enc16 | completed")
)

; encounter 17 - hangar floor 2
(script dormant enc_hangar_floor_2
	(print_if debug "enc17 | waiting...")

	(sleep_until (volume_test_players hangar_left_hall_pillars) 1)
	(print_if debug "enc17 | beginning...")
	(f_game_save)

	; spawn our squads to meet the player at the door
	(f_spawn_random_squads rein_2_a_grunts none rein_2_a_jackals rein_2_a_elites none)

	; wait for the door to the second floor to open (either by fleeing jackals or the player) then spawn the squad along the path to walk in.
	(sleep_until (> (device_get_position hangar_second_door_e) 0) 1)
	(f_spawn_random_squads rein_2_i_grunts none rein_2_i_jackals rein_2_i_elites none)

	; wait until the player crosses the mid way and spawn a new wave in front of them around the corner
	(sleep_until (volume_test_players hangar_exit_trigger) 1)
	(f_spawn_random_squads rein_2_i_grunts none rein_2_i_jackals rein_2_i_elites none)

	; wait for the player to get to the end of the path then conditionally spawn some more units
	(sleep_until (volume_test_players hangar_second_trigger_b) 1)

	; if the player cleared the last squads then spawn a group on the other side of the door
	(if (< (ai_living_count enc_hangar_floor_2) 7) (f_spawn_random_squads rein_2_q_grunts none rein_2_q_jackals rein_2_q_elites none))

	(sleep_until (< (ai_nonswarm_count enc_hangar_floor_2) 1) 1)
	(f_game_save)

	(print_if debug "enc17 | completed")
)

; encounter 18 - hall leading to level 3
(script dormant enc_hangar_righthall
	(print_if debug "enc18 | waiting...")

	(sleep_until
		(or
			(volume_test_players hangar_second_trigger_b) ; golden path
			(volume_test_players hangar_third_trigger_a) ; player skipped to level 3 and back tracking into the hall
		)
	1)
	(print_if debug "enc18 | beginning...")
	(f_game_save)

	; place grunts at the start
	(ai_place grunts_a)

	; wait for player to push in and spawn the jackals around the corner
	(sleep_until (volume_test_players hangar_second_right_hall) 1)
	(ai_place jackals_c)

	; wait for player to move a little farther in and spawn the last of our units in the encounter
	(sleep_until (volume_test_players hangar_third_safe_a) 1)
	(ai_place grunts_g)
	(ai_place elites_c1)

	(ai_disposable enc_hangar_floor_1 true) ; clean up enc 14 and 15 - there should be no floor 1 squads left, but better safe than sorry
	(ai_disposable enc_hangar_floor_2_hall true) ; clean up enc 16 - we are on to the next hall, so if you somehow snuck by, clean them up

	(ai_magically_see enc_hangar_floor_3_hall ai_player_fireteam)

	(sleep_until (< (ai_nonswarm_count enc_hangar_floor_3_hall) 1) 1)
	(f_game_save)

	(print_if debug "enc18 | completed")
)

; encounter 19
(script dormant enc_hangar_level_3
	(print_if debug "enc19 | waiting...")

	(sleep_until (volume_test_players hangar_third_trigger_a) 1)
	(print_if debug "enc19 | beginning...")
	(f_game_save)

	; place units around the corner and the far end of the hall
	(f_spawn_random_squads grunts_e_third grunts_e_third jackals_e_third none none)
	(f_spawn_random_squads grunts_i_third none jackals_i_third elites_i_third none)

	; wait for player to push to the corner
	(sleep_until (volume_test_players hangar_third_trigger_b) 1)
	(ai_place elites_e_third)

	(ai_migrate enc_hangar_floor_3_hall elites_e_third) ; pull enc 18 to enc 19

	; spawn one ahead of them
	(f_spawn_random_squads grunts_i_third none jackals_i_third elites_i_third none)

	; wait for the player to get across the middle of the bridge then conditionally spawn a squad a head
	(sleep_until (volume_test_players hangar_third_trigger_c) 1)
	(f_game_save)

	(ai_disposable enc_hangar_floor_2 true) ; clean up encounter 17 - you shouldn't be able to see them from this position anyways

	(if (< (ai_living_count enc_hangar_floor_3) 7) (f_spawn_random_squads grunts_i_third none jackals_i_third elites_i_third none))

	; once the player reaches the end give them one more squad
	(sleep_until (volume_test_players hangar_third_trigger_d) 1)
	(f_spawn_random_squads grunts_m_third none jackals_m_third elites_m_third none)

	(ai_disposable enc_hangar_floor_3_hall true) ; clean up enc 18 - these should be migrated at this point but just in case.

	(sleep_until (< (ai_nonswarm_count enc_hangar_floor_3) 1) 1)
	(f_game_save)


	(print_if debug "enc19 | completed")
)

(global short s_currently_supported_wave 0)
(script dormant hangar_floor_1_upper_supports
	; wait for combat to begin before we start uppoer support squads
	(sleep_until (f_hangar_combat_started) 1)
	(print_if debug "hangar | beginning level 2 support")

	; begin support loop
	(sleep_until
		(begin
			; check to see if we need to spawn squads
			(if
				(and
					(f_current_wave_needs_support) ; if the current wave is one that we want to support
					(not (= s_currently_supported_wave s_hangar_floor_1_current_wave)) ; if we are not already supporting the wave
				)
				(begin
					; update our currently supported wave
					(set s_currently_supported_wave s_hangar_floor_1_current_wave)
					(print_if debug "hangar | spawning level 2 support for current wave")

					; spawn a support wave
					(begin_random_count 1
						(f_spawn_random_squads rein_2_a_grunts rein_2_e_grunts rein_2_a_jackals rein_2_e_jackals hangar_f_2_current_squad)
						(f_spawn_random_squads rein_2_i_grunts rein_2_q_grunts rein_2_i_jackals rein_2_o_jackals hangar_f_2_current_squad)
						(f_spawn_random_squads rein_2_q_grunts rein_2_q_jackals rein_2_i_jackals rein_2_q_elites hangar_f_2_current_squad)
						(if (> (game_difficulty_get) normal)
							(f_spawn_random_squads rein_2_a_elites rein_2_e_elites rein_2_i_elites rein_2_q_elites hangar_f_2_current_squad) ; heroic + legendary
							(f_spawn_random_squads rein_2_a_grunts rein_2_e_grunts rein_2_a_jackals rein_2_e_jackals hangar_f_2_current_squad) ; easy + normal
						)
					)

					; wait until the squad has been reduced or time has passed
					(sleep_until (< (ai_nonswarm_count hangar_f_2_current_squad) 3) 1 (game_ticks_from_seconds 30))

					; migrate the squad to floor squad
					(print_if debug "hangar | level 2 support joining curret wave")
					(cs_run_command_script hangar_f_2_current_squad cs_migrate_to_hangar_floor_1)

				)
			)

			; exit condition
			b_hangar_floor_1_support_ended
		)
	(game_ticks_from_seconds 1))

	(print_if debug "hangar | ending level 2 support")
)

; returns true if the current wave requires upper level support
(script static boolean f_current_wave_needs_support
	(or
		(= 2 s_hangar_floor_1_current_wave)
		(= 3 s_hangar_floor_1_current_wave)
		(= 4 s_hangar_floor_1_current_wave)
	)
)

; command scripts
; move upper squads to lower floor
(script command_script cs_migrate_to_hangar_floor_1
	(print_if debug "hangar | unit migrating to floor 1 current squad")

	(ai_migrate ai_current_actor hangar_f_1_current_squad)
)

; have our hunters move in if we spawned the failsafes
(script command_script cs_move_hunters_down
	(cs_move_towards_point (ai_nearest_point ai_current_actor ps_hangar_drop_point) 1)
)

; squad spawn scripts

(global short s_squad_counter 0)
(global short s_squad_limit 2)
; take a number of squads
(script static void (f_spawn_random_squads (ai squad_1) (ai squad_2) (ai squad_3) (ai squad_4) (ai target_squad))

	(print_if debug "hangar | spawning random squad...")
	(set s_squad_counter 0) ; reset our number of squads spawned

	(sleep_until ; while we haven't spawned enough squads loop...
		(begin
			(begin_random ; randomly iterate and spawn a squad not repeating until all are used and migrates the squad to the target squad if it exists
				(if (and (< s_squad_counter s_squad_limit) (!= squad_1 none))
					(begin
						(ai_place squad_1)
						(set s_squad_counter (+ 1 s_squad_counter))
						(if (!= target_squad none) (ai_migrate squad_1 target_squad))
						(print_if debug "hangar | squad 1 placed")
					)
				)
				(if (and (< s_squad_counter s_squad_limit) (!= squad_2 none))
					(begin
						(ai_place squad_2)
						(set s_squad_counter (+ 1 s_squad_counter))
						(if (!= target_squad none) (ai_migrate squad_2 target_squad))
						(print_if debug "hangar | squad 2 placed")
					)
				)
				(if (and (< s_squad_counter s_squad_limit) (!= squad_3 none))
					(begin
						(ai_place squad_3)
						(set s_squad_counter (+ 1 s_squad_counter))
						(if (!= target_squad none) (ai_migrate squad_3 target_squad))
						(print_if debug "hangar | squad 3 placed")
					)
				)
				(if (and (< s_squad_counter s_squad_limit) (!= squad_4 none))
					(begin
						(ai_place squad_4)
						(set s_squad_counter (+ 1 s_squad_counter))
						(if (!= target_squad none) (ai_migrate squad_4 target_squad))
						(print_if debug "hangar | squad 4 placed")
					)
				)
			)

			; if we spawned enough squads break out.
			(>= s_squad_counter s_squad_limit)
		)
	1)

	(print_if debug "hangar | spawning random squad complete")
)

(script dormant ini_hangar_initial
	(print_if debug "hangar | initializing starter squads")

	(ai_place rein_2_ledge_elites_a)
	(f_spawn_random_squads rein_1_i_grunts rein_1_i_grunts_2 rein_1_i_jackals rein_1_i_elites hangar_f_1_current_squad)

	(sleep (game_ticks_from_seconds 0.07))

	(ai_magically_see ai_player_fireteam hangar_f_1_current_squad)
)

(script dormant spawn_hangar_floor_1_wave_a
	(print_if debug "hangar | initializing wave 1 squads")

	(f_spawn_random_squads rein_1_a_grunts rein_1_i_grunts_2 rein_1_i_jackals rein_1_i_elites hangar_f_1_current_squad)
	(sleep (game_ticks_from_seconds 0.07))
	(f_spawn_random_squads rein_1_e_grunts rein_1_e_grunts_2 rein_1_e_jackals rein_1_e_elites hangar_f_1_current_squad)
	(sleep (game_ticks_from_seconds 0.07))

	(ai_magically_see hangar_f_1_current_squad ai_player_fireteam)
)

(script dormant spawn_hangar_floor_1_wave_b
	(print_if debug "hangar | initializing wave 2 squads")

	; attempt to spawn wave normally out of sight or fallback to a second floor spawn and keep the action moving
	(cond
		((and (not (volume_test_players han_back_l_safe)) (= (device_get_position han_bot_l_door) 0)) (f_spawn_random_squads rein_1_q_grunts rein_1_q_grunts_2 rein_1_q_jackals rein_1_q_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_q_fallback))
	)

	(sleep (game_ticks_from_seconds 0.07))

	; attempt to spawn wave normally out of sight or fallback to a second floor spawn and keep the action moving
	(cond
		((and (not (volume_test_players han_back_r_safe)) (= (device_get_position han_bot_r_door) 0)) (f_spawn_random_squads rein_1_q_grunts rein_1_a_grunts_2 rein_1_a_jackals rein_1_a_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_a_fallback))
	)

	(sleep (game_ticks_from_seconds 0.07))

	(ai_magically_see hangar_f_1_current_squad ai_player_fireteam)
)

(script dormant spawn_hangar_floor_1_wave_d
	(print_if debug "hangar | initializing wave 3 squads")

	; attempt to spawn wave normally out of sight or fallback to a second floor spawn and keep the action moving
	(cond
		((and (not (volume_test_players han_back_l_safe)) (= (device_get_position han_bot_l_door) 0)) (f_spawn_random_squads rein_1_q_grunts rein_1_q_grunts_2 rein_1_q_jackals rein_1_q_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_q_fallback))
	)

	(sleep (game_ticks_from_seconds 2)) ; waiting so we don't pile up on each other here.

	; attempt to spawn wave normally out of sight or fallback to a second floor spawn and keep the action moving
	(cond
		((and (not (volume_test_players han_back_l_safe)) (= (device_get_position han_bot_l_door) 0)) (f_spawn_random_squads rein_1_q_grunts rein_1_q_grunts_2 rein_1_q_jackals rein_1_q_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_q_fallback))
	)

	(sleep (game_ticks_from_seconds 0.07))

	(ai_magically_see hangar_f_1_current_squad ai_player_fireteam)
)

(script dormant spawn_hangar_floor_1_wave_e
	(print_if debug "hangar | initializing wave 4 squads")

	; attempt to spawn wave normally out of sight or fallback to a second floor spawn and keep the action moving
	(cond
		((and (not (volume_test_players han_back_r_safe)) (= (device_get_position han_bot_r_door) 0)) (f_spawn_random_squads rein_1_q_grunts rein_1_a_grunts_2 rein_1_a_jackals rein_1_a_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_a_fallback))
	)

	(sleep (game_ticks_from_seconds 0.07))

	; attempt to spawn wave normally out of sight or fallback to a second floor spawn and keep the action moving
	(cond
		((and (not (volume_test_players entr_safe)) (= (device_get_position hangar_first_floor_entr) 0)) (f_spawn_random_squads rein_1_y_grunts rein_1_y_grunts_2 rein_1_y_jackals rein_1_y_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_y_fallback))
	)

	(sleep (game_ticks_from_seconds 0.07))

	(ai_magically_see hangar_f_1_current_squad ai_player_fireteam)
)

(script dormant spawn_hangar_floor_1_wave_f
	(print_if debug "hangar | initializing wave 5 squads")

	; attempt to spawn wave normally out of sight or fallback to a second floor spawn and keep the action moving
	(cond
		((and (not (volume_test_players han_back_r_safe)) (= (device_get_position han_bot_r_door) 0)) (f_spawn_random_squads rein_1_q_grunts rein_1_a_grunts_2 rein_1_a_jackals rein_1_a_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_a_fallback))
	)

	(sleep (game_ticks_from_seconds 0.07))

	; attempt to spawn wave normally out of sight or fallback to a second floor spawn and keep the action moving
	(cond
		((and (not (volume_test_players entr_safe)) (= (device_get_position hangar_first_floor_entr) 0)) (f_spawn_random_squads rein_1_y_grunts rein_1_y_grunts_2 rein_1_y_jackals rein_1_y_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_y_fallback))
	)

	(sleep (game_ticks_from_seconds 0.07))

	(cond
		((and (not (volume_test_players han_back_l_safe)) (= (device_get_position han_bot_l_door) 0)) (f_spawn_random_squads rein_1_q_grunts rein_1_q_grunts_2 rein_1_q_jackals rein_1_q_elites hangar_f_1_current_squad))
		(true (ai_place rein_1_q_fallback))
	)

	(sleep (game_ticks_from_seconds 0.07))

	(ai_magically_see hangar_f_1_current_squad ai_player_fireteam)
)

; spawns the hunters for the hangar
(script static void f_spawn_hangar_hunters
	(cond
		((and (not (volume_test_players han_back_l_safe)) (= (device_get_position han_bot_l_door) 0)) (ai_place hunters_l)) ; if the players aren't next to the spawn and the door is closed place hunters left.
		((and (not (volume_test_players han_back_r_safe)) (= (device_get_position han_bot_r_door) 0)) (ai_place hunters_r)) ; if the players aren't next to the spawn and the door is closed place hunters right.
		((and (not (volume_test_players entr_safe)) (= (device_get_position hangar_first_floor_entr) 0)) (ai_place hunters_entr)) ; if the players aren't in the entrance hall and the door is closed place the hunters at the entrance.
		(true (ai_place hangar_hunters)) ; if all else fails place them on the second floor and drop them down
	)
)

; operate hangar exit for insertions
(script static void f_open_hangar_exit
	(device_set_power hangar_exit 1)
	(device_set_position hangar_exit 1)
	(device_one_sided_set hangar_second_door_e false) ; level 2 monster closets set to 1 way in case the player tried to skip and to keep ai from back tracking
	(device_one_sided_set han_bot_r_door2 false) ; level 2 monster closets set to 1 way in case the player tried to skip and to keep ai from back tracking
)

(script static void f_close_hangar_exit
	;(device_set_power hangar_exit 0)
	(device_operates_automatically_set hangar_exit 0)
	(device_set_position hangar_exit 0)
)

(script dormant hangar_music_trigger
	(sleep_until (volume_test_players hangar_entrance) 1)
	(set s_music_trigger 160)
)

(global short s_area5_marine_index 0)
(script dormant area5_marine_point_of_no_return
	(sleep_until
		(begin
			; if the marine isn't in our check volume then teleport the marine at the index to the point at the same index
			(if (not (volume_test_object hangar_no_return_check (list_get (ai_actors ai_player_fireteam) s_area5_marine_index)))
				(begin
					(object_teleport_to_ai_point (list_get (ai_actors ai_player_fireteam) s_area5_marine_index) (ai_point_set_get_point ps_area5_marine_no_return s_area5_marine_index))
					(print_if debug "hangar ponr | teleporting marine to point of no return")
				)
			)

			; increment our index now that we've processed the marine at the current index
			(set s_area5_marine_index (+ s_area5_marine_index 1))

			; exit condition - all marines have been teleported past the point of no return
			(>= s_area5_marine_index (ai_living_count ai_player_fireteam))
		)
		1
	)
)

; main encounter script

; this script handles progression through the hangar and its multiple encounter (14 - 19)
(script dormant enc_hangar
	(print_if debug "hangar | setting up the hangar encounters...")
	(set b_ship_nav_3_triggered true)

	;_____co-op setup_____
	(if (game_is_cooperative)
		(begin
			(print_if debug "hangar | setting up co-op content...")
			;place co-op equipment
			(if (> (game_coop_player_count) 2)(object_create overshield_1_1))

			;inhibit backtracking
			(sleep_until (volume_test_players hangar_trigger) 1)

			;pull all players to the room.
			(volume_teleport_players_not_inside hangar_no_return_check fl_teleport_coop_hangar)
		)
	)

	(if (not (game_is_cooperative))
		(begin
			(print_if debug "hangar | setting up solo content...")
			; queue up marine reinforcements
			(wake ini_hangar_pelican_a)
			(wake ini_hangar_pelican_b)
		)
	)

	;_____fireteam prep_____
	(print_if debug "hangar | setting up the fireteam...")
	(f_fireteam_migrate_join_and_follow fireteam_hangar_johnson fireteam_hangar_marines fireteam_hangar_fill ai_fireteam_keyes)
	(f_fireteam_leave_player)
	(f_fireteam_set_objective ai_objective_enc14-15_hangar_mar)

	;_____encounter setup_____
	(print_if debug "hangar | setting up encounter content...")

	;inhibit backtracking
	(sleep_until (volume_test_players hangar_trigger) 1)

	;closes the door leading to the muster station to prevent backtracking to far.
	(device_set_power hangar_first_floor_backtrack_door 1)
	(device_set_position_immediate hangar_first_floor_backtrack_door 0)
	(device_operates_automatically_set hangar_first_floor_backtrack_door true)

	; if you openned the door for the marines previously and they are not behind the player
	; we are pulling the marines forward so they don't allow the player to backtrack when we don't want them to do so.
	(if
		(and
			(> (device_get_position muster_bay_door) 0) ; we freed the marines
			(not (volume_test_objects_all hangar_no_return_check (ai_actors ai_player_fireteam)))	; they aren't near the player when they move to the hangar
		)
		(begin
			;(ai_teleport ai_player_fireteam ps_transfer_ssz_dbz/p2) ; get the fireteam past the door
			(wake area5_marine_point_of_no_return)
		)
	)

	; toss our marines back into the fireteam so they can go where ever we go now.
	(if (not (> (device_get_position muster_bay_door) 0)) ; we did not free the marines
		(ai_disposable ai_player_fireteam true)
	)

	(device_set_power hangar_first_floor_backtrack_door 0) ; turn off our backtrackdoor now that everyone is pulled forward

	; making room for a bunch of crates and some bodies
	(object_destroy_folder muster_hall_crates)
	(object_destroy_folder gravity_room_muster_hall_crates)
	(object_destroy_folder gravity_room_crates)
	(object_destroy_folder muster_hall_bodies)
	(object_destroy_folder grav_lift_bodies)
	(object_destroy_folder muster_hall_wraiths)
	(object_destroy_folder grav_room_wraiths)

	; clean up encounters now behind our point of no return
	(ai_disposable grav_mus_hall_encounter true)
	(ai_disposable muster_waves_encounter true)
	(ai_disposable muster_ledge_encounter true)
	(ai_disposable muster_hall_encounter true)
	(ai_disposable muster_hangar_hall_encounter true)

	; checkpointing
	(f_game_save)

	; place squads and queue up covenant reinforcements
	(wake ini_hangar_initial)

	; prepare the spirit flyout
	(wake ini_hover_hangar_dropship)

	; ready the music
	(wake hangar_music_trigger)

	(print_if debug "hangar | set up complete")

	;_____encounter begins_____
	(sleep_until (volume_test_players hangar_entrance) 1) ; wait until the player has entered into the hangar

	; encounter 14
	; begin to wait for reinforcements
	(wake hangar_floor_1)
	(wake hangar_floor_1_upper_supports)

	; encounter 15
	;spawn the hunters, ping them and show the last objective
	(wake ini_hangar_hall_open)

	; encounter 16
	(wake enc_hangar_lefthall)

	; encounter 17
	(wake enc_hangar_floor_2)

	; encounter 18
	(wake enc_hangar_righthall)

	;encounter 19
	(wake enc_hangar_level_3)

	; wait for the player to get to the top of the hangar
	(sleep_until (volume_test_players hangar_third_trigger_a) 1)

	(f_fireteam_join_player)
	(f_fireteam_follow_player)

	(f_game_save)
)

(script static boolean f_hangar_combat_started
	(or
		(>= (ai_combat_status enc_hangar) certain) ; do the covenant know the player is there?
		(= (volume_test_players hangar_entrance) 0) ; did the player leave the entrance by pushing in or backing up?
	)
)


;====================================================================================================================================================================================================
; encounter : control ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_control_follow_player
	(ai_disregard ai_player_fireteam true) ; hide the fireteam from perception so they don't trip combat

	; wait until the player goes left or right, they can't get around this one.
	(sleep_until
		(or
			(volume_test_players tv_control_main_door) ; left/straight forward
			(volume_test_players tv_control_observation_door) ; right
		)
	1)

	; set which direction the player went and tell the marines to go the opposite door in the task.
	(if (volume_test_players tv_control_observation_door) (set b_to_control_main true))
	(if (volume_test_players tv_control_main_door) (set b_to_control_observation true))

	; save now that the marines know where to go
	(f_game_save)

	; move the fireteam to the objective
	(f_fireteam_set_objective ai_objective_enc20_22_control_mar)
	(f_fireteam_leave_player) ; have the marines leave the fireteam to make sure they don't stick to the player

	; the player can enter undetected and we want to wait for them to be observed.
	(sleep_until (f_control_combat_started) 1)

	; let the encounter see the fireteam
	(ai_disregard ai_player_fireteam false)


)

(script dormant audio_cue_control_room
	(sleep_until (volume_test_players control_follow_player_trigger) 1)
	(set s_music_trigger 190)
)

(script dormant audio_cue_to_prison
	(sleep_until (volume_test_players control_prison_follow_player_trigger) 1)
	(set s_music_trigger 200)
)

(global boolean b_to_control_observation false)
(global boolean b_to_control_main false)
(global boolean b_control_jackals_placed true)
(script dormant enc_control
	;_____rally point_____
	(print_if debug "rally point | a50 - unlocking rally point charlie")
	(f_unlock_insertion_point_with_incident_name "ins_a50_control")

	(submit_incident_with_custom_string_id "game_activity_begin" "a50")

	;_____co-op setup_____
	(if (game_is_cooperative)
		(begin
			;update the respawn profile for the players
			(player_set_profile blam_profile_respawn_interior)
		)
	)

	;_____set encounter nav_____
	(set b_ship_nav_4_triggered true)
	(sleep_forever f_hangar_b_console_loop); making sure we expunge our guilty conscience before moving on.

	;_____checkpointing_____
	(f_game_save)

	;_____fireteam prep_____
	(f_fireteam_migrate_join_and_follow fireteam_control_johnson fireteam_control_marines fireteam_control_fill ai_fireteam_keyes)

	;_____encounter setup_____
	(ai_place control_first_encounter)
	(ai_activity_set grunts_k asleep)
	(ai_activity_set grunts_m asleep)

	(wake enc_control_follow_player)
	(wake audio_cue_control_room)

	;_____combat begins______



	; the player can enter undetected and we want to wait for them to be observed.
	(sleep_until (f_control_combat_started) 1)

	(if (volume_test_players control_no_return_trigger) (cs_action_at_player pad_elites_major true ai_action_taunt)) ; taunt the player if it wont get us in trouble

	;bloodgate begins

	;wait for 4 or less enemies, no support elites
	(sleep_until (or
					(and
						(= (ai_nonswarm_count control_elites_left) 0)
						(= (ai_nonswarm_count control_elites_right) 0)
				 	)
					(<= (ai_nonswarm_count control_encounter) 4)
				 )
   	1)

	;place jackals now that elites are dead if we can't see them spawn
	(if (and (not (volume_test_players tv_control_observation_door)) (= (device_get_position hangar_door_c16) 0))
		(ai_place jackals_reins)
		(set b_control_jackals_placed false) ; if the spawn was blocked mark it and move on
	)

	(f_hide_n_seek_safety control_encounter)

	;bloodgate ends
	(sleep_until (= (ai_nonswarm_count control_encounter) 0) 1)

	;_____checkpointing post-combat_____
	(f_game_save)

	;_____player direction_____
	(sleep (game_ticks_from_seconds 2))
	(wake vo_bridge_cleared)

	(sleep_until (script_started "vo_bridge_cleared") 1)
	(sleep (game_ticks_from_seconds 4))

	(print_if debug "new objective | rescue captain keyes from the ship's brig")
	(f_hud_obj_new "obj_a50_rescuekeyes" "obj_a50_rescuekeyes")

	(set b_ship_nav_5_triggered true)

	(sleep_until (script_finished "vo_bridge_cleared") 1)

	;_____enemy breadcrumbing_____

	;place grunts to guide player out of the control room
	(ai_place grunts_reins)
	(if (not b_control_jackals_placed) (ai_place jackals_reins_b)) ; place our jackals here if they were blocked earlier

	(set b_control_reinforcement_spawned true)

	(device_group_set_immediate control_power_group 1.0)

	(wake audio_cue_to_prison)

	; wait until the grunt reinforcements are dead before the marines rejoin.
	; if the player goes around then the marines will hang back until they are killed or told to join in the next encounter
	(sleep_until (< (ai_nonswarm_count grunts_reins) 1) 1)
	(f_fireteam_join_player)
	(f_fireteam_follow_player)

)

; the player has a brief moment to attempt to stealth into this encounter
; until they are aware, keep patroling/sleeping and keep the marines from charging in.
(script static boolean f_control_combat_started
	(or
		(> (ai_combat_status control_first_encounter) alert) ; the enemy sees the player
		(< (ai_nonswarm_count grunts_k) 1) ; the player takes out a whole grunt squad
		(< (ai_nonswarm_count grunts_m) 1) ; the player takes out a whole grunt squad
		(< (ai_nonswarm_count pad_elites_major) 1) ; the player takes out the zealot
	)
)

(global short s_control_marine_index -1) ; tracks which point the marine is going to
(script command_script cs_marines_to_control_main
	(branch (f_control_combat_started) (f_print_abort_message "enc20 | aborting marine positioning for combat"))

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	(set s_control_marine_index (+ s_control_marine_index 1)) ; increment our marine index as the fall into the script

	; go to the point at the index then face the nearest poi marker
	(cs_go_to_and_face (ai_point_set_get_point ps_control_main_marines s_control_marine_index) ps_control_poi/p0_control_room)

	(cs_crouch true 1)

	(sleep_until (f_control_combat_started) 1)

)

(script command_script cs_marines_to_control_observation
	(branch (f_control_combat_started) (f_print_abort_message "enc20 | aborting marine positioning for combat"))

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	(cs_go_by ps_control_poi/p2_approach ps_control_poi/p3_junction 0.5)
	(cs_go_by ps_control_poi/p3_junction ps_control_obs_marines/p0 0.5)
	(cs_go_to ps_control_poi/p4_observation 0)
	(set s_control_marine_index (+ s_control_marine_index 1)) ; increment our marine index as the fall into the script

	; go to the point at the index then face the nearest poi marker
	(cs_go_to_and_face (ai_point_set_get_point ps_control_obs_marines s_control_marine_index) ps_control_poi/p0_control_room)
	;(cs_face true (ai_nearest_point ai_current_actor ps_control_poi))


	(cs_crouch true 1)

	(sleep_until (f_control_combat_started) 1)
)

;====================================================================================================================================================================================================
; encounter : prison ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant place_marines_a
	(sleep_until (volume_test_players tv_cella_entry) 1)

	; don't spawn this marine in co-op to keep traffic down
	(if (not (game_is_cooperative))
		(begin
			(ai_place mar_nocap_cell_a)
			(pose_prisoners mar_nocap_cell_a)
			(set_ai_inactive mar_nocap_cell_a true)
		)
	)

	(sleep_until (= (device_group_get brig2_control_group) 1) 1)

	(device_set_power brig2_control 0)
	(print_if debug "jail a opened !")

	; turning on our marines brain if its not co-op
	(if (not (game_is_cooperative))
		(begin

			(set_ai_inactive mar_nocap_cell_a false)
			(stop_posing_prisoners mar_nocap_cell_a)

			;add marine to fireteam
			(f_migrate_squad_to_fireteam_fill mar_nocap_cell_a)

			; set marines objective based on if we saved the captain yet or not
			;(if b_captain_rescued () ())
		)
	)
)

(script dormant place_marines_b
	(sleep_until (volume_test_players tv_cellb_entry) 1)
	(ai_place new_cov_prisoner)

	; don't spawn this marine in co-op to keep traffic down
	(if (not (game_is_cooperative))
		(begin
			(ai_place mar_nocap_cell_b)
			(pose_prisoners mar_nocap_cell_b)
			(set_ai_inactive mar_nocap_cell_b true)
		)
	)

	; we still want to allow the player to open the cells for the terminal
	(sleep_until (= (device_group_get brig_control_group) 1) 1)

	(device_set_power brig_control 0)
	(print_if debug "jail b opened !")

	; turning on our marines brain if its not co-op
	(if (not (game_is_cooperative))
		(begin
			(set_ai_inactive mar_nocap_cell_b false)
			(stop_posing_prisoners mar_nocap_cell_b)
			;add marine to fireteam
			(f_migrate_squad_to_fireteam_fill mar_nocap_cell_b)

			; set marines objective based on if we saved the captain yet or not
			;(if b_captain_rescued () ())
		)
	)
)

(script static void (set_ai_inactive (ai squad) (boolean set_active))
	(ai_disregard (ai_actors squad) set_active)
	(ai_braindead squad set_active)
)

(script dormant place_marines_c_and_captain
	(sleep_until (volume_test_players prison_to_prison_control_trigger) 1)

	(ai_place captain)
	(ai_place mar_nocap_cell_c)
	(pose_prisoners mar_nocap_cell_c)

	(set_ai_inactive captain true)
	(set_ai_inactive mar_nocap_cell_c true)


	(sleep_until (= (ai_nonswarm_count enc_prison_break_in) 0) 1)

	(set ai_fireteam_keyes captain)

	(print_if debug "give keyes a nameplate")
	(wake nav_nameplate_keyes)

	(sleep_until (= (device_group_get brig_keyes_control_group) 1) 1)
	(device_set_power brig_keyes_control 0)

	(if (< s_conversation_id 14)
		(set s_conversation_id 14)
	)
	(print_if debug "jail captain opened !")

	; wait until the cinematic then delete the shield doors
	(sleep_until (cinematic_in_progress) 1)
	(object_destroy_folder brig_keyes_shield_doors)
)

(script dormant nav_nameplate_keyes
	(sleep (game_ticks_from_seconds 1))
	(f_hud_hero_waypoint ai_fireteam_keyes hero_keyes hero_default_max_dist)
)

(script dormant place_breakout_squads
	(f_fireteam_leave_player)

	(set_ai_inactive captain false) ; turn on keyes's brain

	; swap unarmed prisoners for armed ones
	(ai_erase mar_nocap_cell_c)
	(ai_place prison_post_breakout)

	; arm keyes and position him
	(unit_add_equipment captain/spawnpoint marine_needler true true)
	(object_teleport_to_ai_point ai_fireteam_keyes ps_after_cine_teleport/p_keyes)

	; move our rescue party into position and arm the prisoners
	(f_arm_the_marine_captives ai_fireteam_fill) ; give our unarmed marines after the cutscene some weapons they "found on the ground"
	(f_arm_the_marine_captives ai_fireteam_marines) ; give our unarmed marines after the cutscene some weapons they "found on the ground"
	(object_teleport_to_ai_point ai_fireteam_johnson ps_after_cine_teleport/p_johnson)
	(ai_teleport ai_fireteam_marines ps_after_cine_teleport/p_marines)
	(ai_teleport ai_fireteam_fill ps_after_cine_teleport/p_fill)

	(game_save)

	;have fireteam join form up and join the player
	(f_migrate_squad_to_fireteam_fill fill_post_breakout)
	(f_migrate_squad_to_fireteam_marines marines_post_breakout)

	(f_fireteam_leave_player)

	(sleep (game_ticks_from_seconds 0.5)) ; wait for fireteam to leave player

	; setting tasks instead of objective to ensure keyes and johnson are sorted properly.
	(print_if debug "moving fireteam to breakout objective")
	(ai_set_task ai_fireteam_keyes ai_objective_enc23_prison_mar keyes_start)
	(ai_set_task ai_fireteam_johnson ai_objective_enc23_prison_mar johnson_start)
	(ai_set_task ai_fireteam_marines ai_objective_enc23_prison_mar marines_start)
	(ai_set_task ai_fireteam_fill ai_objective_enc23_prison_mar fodder_start)


	; if we have too many fill marines split them in half to use them better in the prison
	(if (> (list_count (ai_actors ai_fireteam_fill)) s_prison_b_fill_threshold) (f_create_overfill_squad))

	(ai_set_task fireteam_prison_b_overfill ai_objective_enc23_prison_mar overfill_start)
)

; gives unarmed units in a squad weapons
(global short s_armed_index 0) ; tracks how many units we've given weapons
(script static void (f_arm_the_marine_captives (ai squad))
	(set s_armed_index 0)
	; loop
	(sleep_until
		(begin ; attempt to arm marines while we have people we haven't armed
			(if (unit_has_weapon (unit (list_get (ai_actors squad) s_armed_index)) objects\weapons\melee\unarmed\unarmed.weapon) ; if you don't have a weapon you get one
				(begin_random_count 1
					(unit_add_equipment (unit (list_get (ai_actors squad) s_armed_index)) marine_needler true true) ; grant a needler
					(unit_add_equipment (unit (list_get (ai_actors squad) s_armed_index)) marine_plasma_rifle true true) ; grant a plasma rifle
				)
			)
			(set s_armed_index (+ s_armed_index 1)) ; incrememnt our index to mark an attempt at arming a marine

			; exit condition, while the amount of people armed does not excede the total number of people that could be armed.
			(> s_armed_index (ai_living_count squad))
		)
	1)
)

(script dormant prison_cell_d_hall_follow_player
	(sleep_until (volume_test_players prison_cell_d_hall_trigger) 1)
	(set s_music_trigger 210)
)

(script dormant rescued_prison_control_follow_player
	(sleep_until
		(and
			(volume_test_players prison_entrance_follow_player_trigger)
			(= b_captain_rescued true))
	1)
	(f_migrate_squad_to_fireteam_fill fireteam_prison_b_overfill)

	(f_fireteam_join_player)
	(f_fireteam_follow_player)
)

(script dormant set_escape_objective
	(print_if debug "new objective | return to the ship's hangar")
	(f_hud_obj_new "obj_a50_escape" "obj_a50_escape")
)

; move covenant in the prison farther back in as the player progresses with the final destination being in keyes cell block
(script dormant cov_prison_a_migration

	; pulls our previous encounter (a few grunts in the hall) to the prison checkpoint
	(sleep_until (volume_test_players prison_trigger) 1)
	(ai_migrate control_encounter grunts_checkpoint)

	; pulls everyone from the check point into the prison lobby
	(sleep_until (volume_test_players prison_control_to_prison_hallway_trigger) 1)
	(ai_migrate prison_in_checkpoint_cov elites_prison_block_b)

	; pulls everyone in the prison into the final cell block
	(sleep_until (volume_test_players vo_stealth_elite_keyes_trigger) 1)
	(ai_migrate prison_in_checkpoint_cov grunts_ini) ; we probably don't need this one, but adding for safety
	(ai_migrate prison_in_lobby_cov grunts_ini)
)

(script dormant enc_prison
	(set b_ship_nav_5_triggered true)

	;_____fireteam prep_____
	(f_fireteam_migrate_join_and_follow fireteam_prison_johnson fireteam_prison_marines fireteam_prison_fill fireteam_prison_keyes)

	;_____co-op setup_____
	(if (game_is_cooperative)
		(begin
			;place co-op equipment
			(if (> (game_coop_player_count) 2)(object_create activecamo3_1))

			;inhibit backtracking
			(sleep_until (volume_test_players prison_trigger) 1)

			;closes the door leading to the muster station to prevent backtracking to far.
			(device_one_sided_set control_door_a true)
			(device_one_sided_set control_door_b true)
			(device_one_sided_set control_door_c true)

			;pull all players to the room.
			(volume_teleport_players_not_inside prison_no_return_check fl_teleport_coop_prison)
		)
	)

	;_____encounter setup part a_____
	(device_set_power brig_keyes_control 0)

	; place marines
	(wake place_marines_a)
	(wake place_marines_b)

	(wake prison_cell_d_hall_follow_player)
	(wake enc_prison_part_a_cov)

	(wake cov_prison_a_migration)

	(wake vo_prison)

	;_____combat begins_____

	; player has entered the captains cell block
	(sleep_until (volume_test_players prison_after_reyes_saved_trigger) 1)

	(wake vo_prison_keyes)

	; wait until bloodgate completes
	(sleep_until (= (ai_nonswarm_count enc_prison_break_in) 0) 1)

	(device_set_power brig_keyes_control 1) ; enable prison switch

	; wait for player to free keyes
	(sleep_until (= (device_group_get brig_keyes_control_group) 1) 1)
	(print_if debug "keyes saved !")

	;_____combat ends_____
	(set b_cinematic_lower_weapon true)
	(f_play_cinematic cinematics\a50\a50_brig.cinematic ps_after_cine_teleport)
	(device_set_position_immediate cellblock_d_maindoor 0) ; close the door so we don't see the stealth elites pushing up

	; chapter and objective update
	(wake trigger_chapter_three)
	(wake set_escape_objective)

	(wake vo_prison_freed_keyes)

	;_____checkpointing_____
	(f_game_save)
	(set b_captain_rescued true)

	;_____encounter setup part b_____
	(ai_disposable enc_hangar_floor_3 true) ; removing the final squads from the hangar encounter 19

	; swapout our squads and regroup in the cell block
	(wake place_breakout_squads)
	(wake enc_prison_part_b_cov)

	(wake rescued_prison_control_follow_player)

	; modifying doors for players
	(device_one_sided_set hangar_door_c9 true) ; cell block a now a monster closet

	(device_set_power cellblock_d_maindoor7 1) ; opening lower cell block b for flanking
	(device_set_power cellblock_d_maindoor4 1)

	; adjust cover
	(object_destroy_folder prison_before) ; remove old crates
	(object_create_folder prison_after) ; place new ones like a barricade

	;_____combat begins_____

	; a helpful checkpoint rewarding exploring
	(wake breakout_cell_b_checkpoint)

	; give the player a chance to catch their breath
	(sleep_until (< (ai_nonswarm_count enc_prison_break_out) 3) 1)
	(f_game_save)

	; wait for player to leave prison
	(sleep_until (volume_test_players prison_entrance_follow_player_trigger) 1)

	;make sure everyone is dead
	(sleep_until (< (ai_nonswarm_count enc_prison_break_out) 1) 1)

	(f_game_save) ; will save once all is clear

	;_____combat ends_____
)

; manages the covenant spawning as the player progresses into the prison
(script dormant enc_prison_part_a_cov
	; set our starter units
	(ai_place grunts_a_prison)

	; player progresses towards security
	(sleep_until (volume_test_players prison_entrance_follow_player_trigger) 1)
	(ai_place new_elite_guard)
	(ai_place jackals_c_prison)
	(ai_place grunts_checkpoint)


	; player has progressed to the security checkpoint or has eliminated enough gaurds
	(sleep_until
		(or
			(volume_test_players prison_hallway_to_prison_entrance_trigger)
			(< (ai_nonswarm_count prison_in_checkpoint_cov) 2)
		)
	1)
	(ai_place jackals_i_prison)

	(sleep_until ; wait until either the player has pushed forward or killed the first group. very helpful at higher difficulties
		(or
			(volume_test_players prison_control_to_prison_hallway_trigger)
			(< (ai_nonswarm_count prison_in_checkpoint_cov) 1)
		)
	1 )
	(f_game_save)

	(ai_place elites_prison_block_a)
	(ai_place jackals_s_prison)

	; player has entered the prison lobby
	(sleep_until (volume_test_players prison_control_to_prison_hallway_trigger) 1)
	(ai_place elites_prison_block_b)

	; place our lobby units and migrate our last group to buff them if any survive
	(ai_migrate prison_in_checkpoint_cov prison_in_lobby_cov)

	(ai_magically_see prison_in_lobby_cov ai_fireteam_johnson)
	(if (= (game_difficulty_get) "normal") (ai_prefer_target ai_player_fireteam true))

	(sleep_until (volume_test_players prison_to_prison_control_trigger) 1)
	(ai_place prison_in_block_c)

	(wake place_marines_c_and_captain)

	; player is progress towards keyes
	(sleep_until (volume_test_players prison_save_trigger) 1)
	(f_game_save)

	(ai_prefer_target ai_player_fireteam false)

	; player has entered the captains cell block
	(sleep_until (volume_test_players prison_after_reyes_saved_trigger) 1)

	; bloodgate begins
	(f_hide_n_seek_safety enc_prison_break_in)

	; bloodgate ends
	(sleep_until (= (ai_nonswarm_count enc_prison_break_in) 0) 1)

	(device_set_power brig_keyes_control 1) ; enable prison switch

)

(global boolean b_prison_break_started false)
(script dormant enc_prison_part_b_cov
	;place our squads
	(ai_place prison_culling_stealth)

	; wait until the player begin to push out of the prison block
	(sleep_until (volume_test_players prison_after_reyes_saved_trigger) 1)
	(set b_prison_break_started true)

	; wait until the player either pushed through the stealth elites, or fell back
	(sleep_until (not (volume_test_players prison_after_reyes_saved_trigger)) 1)
	(wake prison_kamikaze_waves)

	(sleep_until (volume_test_players vo_stealth_elite_keyes_trigger) 1)
	(ai_place prison_sniper)
	(ai_place prison_barricade_elites_a)

	(sleep_until (volume_test_players prison_cell_d_hall_trigger) 1)
	(ai_place prison_blocking_jackals)
	(ai_migrate prison_out_culling_cov prison_out_lobby_cov) ; move our cullers out to the lobby

	(sleep_until (volume_test_players prison_to_prison_control_trigger) 1)

	(f_game_save)

	(ai_place prison_out_elites_upper)
	(ai_place prison_support_jackal)
	(ai_place prison_support_grunt)

	(sleep_until
		(or
			(volume_test_players tv_lobby_exit)
			(< (ai_living_count enc_prison_break_out) 6)
		)
	1)

	(f_game_save)

	(ai_place prison_out_rein_a)


	(sleep_until
		(or
			(volume_test_players prison_control_to_prison_hallway_trigger)
			(< (ai_nonswarm_count prison_out_rein_a) 1)
		)
	1)
	(f_game_save)

	(ai_place prison_out_finale)
)

(global short s_kamikaze_count 0)
(global short s_kamikaze_max 0)
(script dormant prison_kamikaze_waves
	; set count on difficulty
	(cond
		((= (game_difficulty_get) "normal") (set s_kamikaze_max 2))
		((= (game_difficulty_get) "heroic") (set s_kamikaze_max 2))
		((= (game_difficulty_get) "legendary") (set s_kamikaze_max 4))
	)

	(print_if debug "prison break | starting spawner")
	;loop till player pushed up or exhausted
	(sleep_until
		(begin
			(sleep_until ; if we need a wave or the player progressed cont..
				(or
					(< (ai_living_count prison_grunt_kamikaze) 1)
					(volume_test_players prison_cell_d_hall_trigger)
				)
			1 )

			; only spawn a wave if the player didn't progress
			(if (not (volume_test_players prison_cell_d_hall_trigger))
				(begin
					(print_if debug "prison break | spawning kamikaze wave")
					(ai_place prison_grunt_kamikaze)
					(sleep (game_ticks_from_seconds 0.17))
					(ai_magically_see prison_grunt_kamikaze ai_fireteam_keyes)

					(set s_kamikaze_count (+ s_kamikaze_count 1))
				)
			)

			(sleep (game_ticks_from_seconds 1))

			;exit condition
			(or
				(volume_test_players prison_cell_d_hall_trigger)
				(>= s_kamikaze_count s_kamikaze_max)
			)
		)
	1)

	(print_if debug "prison break | stopping spawner")
)

(script dormant breakout_cell_b_checkpoint
	(sleep_until
		(or
			(volume_test_players tv_cellblock_b)
			(volume_test_players prison_to_prison_control_trigger)
		 )
	1)
	(f_game_save)
)

(script command_script cs_prison_grunts_bait
	(cs_go_to ps_prison_grunt_bait/p_lure 1)
	(sleep_until (objects_can_see_object (players) grunts_ini 30) 1)
)

(script command_script cs_retreat_to_back
	(ai_flee_from_object ai_current_actor player0)
)

(script command_script cs_hide_in_prison
	(cs_abort_on_damage true)
	(ai_activity_set ai_current_actor crouch)
)

(script command_script cs_move_tod_dias
	(cs_go_to_and_face ps_prison_grunt_bait/p_taunt ps_prison_grunt_bait/p_trap)
	(cs_action_at_object cellblock_d_maindoor ai_action_shakefist)
)

(script command_script cs_prison_taunt_player
	(cs_action_at_object cellblock_d_maindoor ai_action_shakefist)
)

(script command_script cs_grenade_marines
	(cs_go_to_and_face ps_prison_grunt_bait/p_throw ps_prison_grunt_bait/p_grenade)
	(cs_grenade ps_prison_grunt_bait/p_grenade 1)
)

(script command_script cs_kamikaze_grunt
	(ai_grunt_kamikaze ai_current_actor)
)

(script command_script cs_animate_keyes_sit
	(custom_animation_loop ai_current_actor "objects\characters\marine\marine" "ma50_keyes_prison:idle" true)

	(sleep_until (= b_captain_rescued true) 1)
	(cs_stop_custom_animation)
)

(global short s_prisoner_index 0)
(script static void (pose_prisoners (ai squad))
	(print_if debug "prison | posing prisoners")

	(set s_prisoner_index 0)

	(sleep_until ;loop until all marines have been given an animation
        (begin
			(begin_random ; give each marine an animation without repeating unless we've used everything once.
				(begin
					(custom_animation_loop (unit (list_get (ai_actors squad) s_prisoner_index)) "objects\characters\marine\marine" "ma50_keyes_prison:idle" true)
					(set s_prisoner_index (+ s_prisoner_index 1))
				)
				(begin
					(custom_animation_loop (unit (list_get (ai_actors squad) s_prisoner_index)) "objects\characters\marine\marine" "m52:09_troopers_hostage_marine02_idle" true)
					(set s_prisoner_index (+ s_prisoner_index 1))
				)
				(begin
					(custom_animation (unit (list_get (ai_actors squad) s_prisoner_index)) "objects\characters\marine\marine" "m52:09_troopers_hostage_marine03" true)
					(set s_prisoner_index (+ s_prisoner_index 1))
				)
				(begin
					(custom_animation_loop (unit (list_get (ai_actors squad) s_prisoner_index)) "objects\characters\marine\marine" "m52:09_troopers_hostage_marine01_idle" true)
					(set s_prisoner_index (+ s_prisoner_index 1))
				)
				(begin
					(custom_animation_loop (unit (list_get (ai_actors squad) s_prisoner_index)) "objects\characters\marine\marine" "ma15:cryo_marine:escape:idle_door" true)
					(set s_prisoner_index (+ s_prisoner_index 1))
				)
				(begin
					(custom_animation_loop (unit (list_get (ai_actors squad) s_prisoner_index)) "objects\characters\marine\marine" "global_injured:unarmed:gut_lyingdown:var1" true)
					(set s_prisoner_index (+ s_prisoner_index 1))
				)
			)

            (>= s_prisoner_index (list_count (ai_actors squad)))
        )
    1)
	(print_if debug "prison | prisoners are posed")
)

(script static void (stop_posing_prisoners (ai squad))
	(print_if debug "prison | liberating prisoners")
    (set s_prisoner_index 0)
    (sleep_until
        (begin
			(custom_animation (unit (list_get (ai_actors squad) s_prisoner_index)) "objects\characters\marine\marine" "combat:unarmed:idle" true)

            (set s_prisoner_index (+ s_prisoner_index 1))

            (>= s_prisoner_index (list_count (ai_actors squad)))
        )
    1)
	(print_if debug "prison | prisoners liberated")
)

(global short s_prison_b_fill_threshold 3) ; minimum size the fill squad needs to be for us to want to split
(global short s_fill_squad_to_move 0) ; how many units we want to move
(global short s_overfill_index 0) ; how many units we've moved
(script static void f_create_overfill_squad
	(print_if debug "fireteam | attempting to create overfill squad")

	(set s_overfill_index 0) ; ensure a clean start
	(set s_fill_squad_to_move (/ (list_count (ai_actors ai_fireteam_fill)) 2)) ; figure out how many people to move

	(if (> s_fill_squad_to_move 0) ; if there are actually people to move then move them.
		(begin
			; loop
			(sleep_until ; add the 1st unit in the fill squad to overfill while we haven't added more than we planned to move
				(begin
					(ai_migrate (object_get_ai (list_get (ai_actors ai_fireteam_fill) 0)) fireteam_prison_b_overfill) ; add unit to overfill squad
					(set s_overfill_index (+ 1 s_overfill_index)) ; track how many we've moved
					(print_if debug "fireteam | marines added to overfill squad")
					(sleep 1)

					; exit condition, as long as we've not moved more than we planned
					(>= s_overfill_index s_fill_squad_to_move)
				)
			1)
		)
	)


)
;====================================================================================================================================================================================================
; encounter : control revisited ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant rescued_control_follow_player
	(sleep_until (volume_test_players control_prison_follow_player_trigger) 1)

	; drop the fireteam into the encounter
	; if you don't they dog pile the player on the ramps and it feels bad
	(f_fireteam_leave_player)
	(f_fireteam_set_objective ai_objective_enc25_control_revisited_mar)
)

(script dormant rescued_post_control_follow_player
	(sleep_until (= (ai_nonswarm_count enc_control_revisited) 0) 1) ; wait until the stealth elites are killed

	(sleep_until (volume_test_players control_follow_player_trigger) 1) ; wait for the player to begin to exit

	; get the fireteam back with the player to exit
	(f_fireteam_join_player)
	(f_fireteam_follow_player)
)

(script dormant enc_control_revisited
	(set b_ship_nav_6_triggered true)

	;_____co-op setup_____
	(wake control_revisited_no_return)

	;_____fireteam prep_____
	(f_fireteam_migrate_join_and_follow fireteam_control_2_johnson fireteam_control_2_marines fireteam_control_2_fill fireteam_control_2_keyes)

	;_____initialize room_____
	(device_one_sided_set control_door_a true)
	(device_one_sided_set control_door_b true)
	(device_one_sided_set control_door_c true)
	(device_one_sided_set hangar_door_c16 true)
	(device_one_sided_set control_door_d true) 	;this is the door the player will come through
	(device_one_sided_set control_door_e true)	;this is the door the player will come through
	(device_group_set_immediate control_power_group 1.0) ;ensure the power is on from the insertion point
	(device_operates_automatically_set control_door_e true)

	;_____checkpointing_____
	(f_game_save)

	;_____initialize encounter_____
	(wake rescued_control_follow_player)

	(sleep 1)
	(ai_place stealth_elites_control)
	(sleep_until (>= (ai_nonswarm_count stealth_elites_control) 1) 1) ; wait to ensure our stealth elite squads have spawned

	(wake vo_keyes_stealth_elites)

	(sleep_until
		(or
			(>= (ai_combat_status stealth_elites_control) visible) ; elites saw an enemy
			(<= (ai_nonswarm_count stealth_elites_control) 0) ; elites died without seeing an enemy
		)
		1
	) ; wait for cortana to call out the elites
	(sleep (game_ticks_from_seconds 6)) ; timing the waypoint so it doesn't immediately give away the elites

	; mark our bloodgate
	(f_hide_n_seek_safety stealth_elites_control)

	;_____combat begins_____
	(sleep_until (= (ai_nonswarm_count stealth_elites_control) 0) 1)

	; wait for cortana to tell the player to clear the area
	(sleep_until (script_finished "vo_keyes_stealth_elites") 1)
	(sleep (game_ticks_from_seconds 1)) ; pause so combat doesn't stomp on the vo

	(ai_place control_grunts_return)

	(device_one_sided_set control_door_a false)
	(device_one_sided_set control_door_b false)
	(device_one_sided_set control_door_c false)
	(device_one_sided_set control_door_d false)
	(device_one_sided_set control_door_e false)
	(device_one_sided_set hangar_door_c16 false)

	; move our previous encounter into the grunts section
	(ai_migrate_persistent enc_prison_break_out control_grunts_return) ; persistant so we can attempt to clean up
	(ai_disposable enc_prison_break_out true) ; start looking for a chance to clean them up.

	(wake rescued_post_control_follow_player)

	;_____checkpointing post-combat_____
	(sleep_until (= (ai_living_count enc_control_revisited) 0) 1)
	(f_game_save)
)

(script dormant control_revisited_no_return
	(if (game_is_cooperative)
		(begin
			;inhibit backtracking
			(sleep_until (volume_test_players control_no_return_trigger) 1)

			;pull all players to the room.
			(volume_teleport_players_not_inside control_no_return_check fl_teleport_coop_control)
		)
	)
)

;====================================================================================================================================================================================================
; encounter : hangar revisited ==============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_hangar_revisited

	;_____fireteam prep_____
	(f_fireteam_migrate_join_and_follow fireteam_hangar_2_johnson fireteam_hangar_2_marines fireteam_hangar_2_fill fireteam_hangar_2_keyes)

	(print_if debug "new objective | activate terminal to drop hangar shields")
	(f_hud_obj_new "obj_a50_terminalshield" "obj_a50_terminalshield")

	; if the player skipped by the grunts in the control room migrate them here to follow
	(ai_migrate enc_control_revisited grunts_return)

	(wake mark_switch_in_hangar)

	(ai_place grunts_return)
	(ai_place hangar_elites_return)
	(wake vo_entering_hangar)

	(f_game_save)

	(device_set_power extraction_control 1)
	(sleep_until (volume_test_players hangar_control_approach_trigger) 1)
	(set s_music_trigger 270)
	(sleep_until (= (device_group_get extraction_control_group) 1) 1)
	(f_play_cinematic cinematics\a50\a50_outro.cinematic)

	;_____rally point_____
	(print_if debug "rally point | a50 - unlocking next level b30: the silent cartographer")
	(f_unlock_insertion_point_with_incident_name "unlock_b30")
	(f_unlock_insertion_point_with_incident_name "ins_b30_beach_lz")

	(submit_incident_with_custom_string_id "game_activity_end_completed" "a50")

	(game_won)
)

(script dormant mark_switch_in_hangar
	(sleep_until (volume_test_players tv_unblip_ship_nav_13_b) 1)
	(set b_ship_nav_7_triggered true)
)

(script dormant shuttle_door_switch_trigger
	(sleep_until (volume_test_players shuttle_door_switch_trigger) 1)
	(print "::if covenat from hangar_cov_second_floor/elites_ledge_a enter:, waits 7.5 seconds, closes hangar_door_b_power and starts shuttle_bay_door_closed convo::")
)

;====================================================================================================================================================================================================
; encounter command scripts =========================================================================================================================================================================
;====================================================================================================================================================================================================

(script static void (f_print_abort_message (string message))
	(print_if debug "script aborted...")
	(print_if debug message)
)

(script command_script cs_enable_camo
	(sleep (game_ticks_from_seconds 0.17))
	(ai_set_active_camo ai_current_actor true)
)

(script command_script cs_grunt_asleep
	(ai_activity_abort ai_current_actor)
	(sleep (game_ticks_from_seconds 0.17))
	(ai_activity_set ai_current_actor asleep)
)

(script command_script cs_lights_off
	(unit_set_integrated_flashlight ai_current_actor false)
)

(script command_script cs_lights_on
	(unit_set_integrated_flashlight ai_current_actor true)
)

;====================================================================================================================================================================================================
; marine maneuvers =========================================================================================================================================================================
;====================================================================================================================================================================================================

; area1 maneuvers

; used to iterate through point sets as actors enter a command script
(global short s_area1_exit_pelican_marine -1)
(global short s_area1_staged_left -1)

; moves johnson forward to the tree and has him muster the fireteam.
(script command_script cs_area1_exit_pelican_johnson
	(branch (volume_test_players area2_trigger) (f_print_abort_message "area1 | aborting pelican exit johnson"))

	(unit_set_integrated_flashlight ai_current_actor true)

	; go to tree and face the pelican then wave for marines.
	(cs_go_to_and_face ps_area1_exit_pelican_johnson/p0 ps_area1_exit_pelican_johnson/p1)
	(cs_custom_animation "objects\characters\marine\marine" "global_alert:rifle:wave" true)

	; wait until the animation is over then ensure the actor is not animating.
	(sleep_until (<= (unit_get_custom_animation_time ai_current_actor) 0) 1)
	(cs_stop_custom_animation)
)

; move the marine squads to the tree muster point next to johnson.
; the first marine in the script will cover their face from the jetwash and watch the pelican fly away before catching up to the rest.
(script command_script cs_area1_exit_pelican_marine
	(cs_enable_pathfinding_failsafe true)
	(branch (volume_test_players area2_trigger) (f_print_abort_message "area1 | aborting pelican exit marine"))
	(set s_area1_exit_pelican_marine (+ s_area1_exit_pelican_marine 1))
	(inspect s_area1_exit_pelican_marine)
	(unit_set_integrated_flashlight ai_current_actor true)

	(if (= s_area1_exit_pelican_marine 0)
		(begin
			(cs_go_to_and_face ps_area1_exit_pelican_marines/p0 ps_area1_poi/pelican)
			(begin_random_count 1
				(cs_custom_animation "objects\characters\marine\marine" "global_alert:rifle:cover_dust" true)
				(cs_custom_animation "objects\characters\marine\marine" "global_alert:rifle:cover_dust:var1" true)
				(cs_custom_animation "objects\characters\marine\marine" "global_alert:rifle:cover_dust:var2" true)
			)
			(sleep_until (<= (unit_get_custom_animation_time ai_current_actor) 0) 1)
			(cs_stop_custom_animation)
			(cs_enable_looking true)

			(cs_go_to ps_area1_exit_pelican_marines/p4 0)
		)
		(begin
			(cs_go_to_and_face (ai_point_set_get_point ps_area1_exit_pelican_marines s_area1_exit_pelican_marine) ps_area1_poi/johnson_muster)
		)
	)
)

; move a few marines to the left guiding the player forward.
; occasionally the marines will pivot to face the player using their flashlight to get the player's attention and pull them foward
; command script runs until aborted by player progression
(script command_script cs_area1_stage_left
	(branch (volume_test_players canyon_nav_reached1) (f_print_abort_message "area1 | aborting stage left"))
	(set s_area1_staged_left (+ s_area1_staged_left 1))

	; move to position and look in the direction we want the player to go
	(cs_go_to_and_face (ai_point_set_get_point ps_area1_stage_left s_area1_staged_left) ps_area1_poi/area2_entrance)

	; sneak
	(cs_crouch true 1)

	; loop and sometimes look at the player getting the player's attention with the flashlight
	(sleep_until
		(begin
			(f_maneuver_marine_attract_player ai_current_actor)
			false
		)
	1)
)

; move a few marines to the left guiding the player forward.
; occasionally the marines will pivot to face the player using their flashlight to get the player's attention and pull them foward
; command script runs until aborted by player progression
(global short s_area1_staged_right -1)
(script command_script cs_area1_stage_right
	(branch (volume_test_players canyon_nav_reached1) (f_print_abort_message "area1 | aborting stage right"))
	(set s_area1_staged_right (+ s_area1_staged_right 1))

	; move to position and look in the direction we want the player to go
	(cs_go_to_and_face (ai_point_set_get_point ps_area1_stage_right s_area1_staged_right) ps_area1_poi/area2_entrance)

	; sneak
	(cs_crouch true 1)

	; loop and sometimes look at the player getting the player's attention with the flashlight
	(sleep_until
		(begin
			(f_maneuver_marine_attract_player ai_current_actor)
			false
		)
	1)
)

; area2 maneuvers

; used to iterate through point sets as actors enter a command script
(global short s_area2_ready_lower -1)
(global short s_area2_ready_upper 0) ; starts at 0 because we are skipping the first point
(global short s_area2_attack_upper -1)
(global short s_area2_exit_marine -1)

; marine squads wait outside of the encounter ready to move in once combat starts
(script command_script cs_area2_ready_lower
	(branch (= (f_area3_combat_started) true) (f_print_abort_message "area2 | aborting ready lower"))
	(set s_area2_ready_lower (+ s_area2_ready_lower 1))

	; turn off flashlight to get closer to the covenant
	(unit_set_integrated_flashlight ai_current_actor false)

	; go to the ambush point and crouch
	(cs_go_to_and_face (ai_point_set_get_point ps_area2_ready_lower s_area2_ready_lower) ps_area2_poi/area2_path)
	(cs_crouch true 1)

	; wait until combat begins
	(sleep_until (= (f_area3_combat_started) true) 1)
)

; marine squads follow the player to the highground and prepares to fire down on the covenant when combat starts
(script command_script cs_area2_ready_upper
	(branch (volume_test_players area2_trigger_a) (f_print_abort_message "area2 | aborting ready upper"))

	; move to the entrance to the high ground and find a point to crouch at and wait for combat
	(cs_go_by ps_area2_ready_upper/p0 (ai_point_set_get_point ps_area2_ready_upper s_area2_ready_upper) 1)
	(set s_area2_ready_upper (+ s_area2_ready_upper 1))

	; turn off flashlight to get closer to the covenant
	(unit_set_integrated_flashlight ai_current_actor false)

	; go to the ambush point and crouch
	(cs_go_to_and_face (ai_point_set_get_point ps_area2_ready_upper s_area2_ready_upper) ps_area2_poi/area2_pit)
	(cs_crouch true 1)

	; wait until the player jumps down into the encounter area
	(sleep_until (volume_test_players area2_trigger_a) 1)
)

; marine squads in the upper area move forward and shoot down on the covenant and then leap down into the fight.
(script command_script cs_area2_attack_upper
	(set s_area2_attack_upper (+ s_area2_attack_upper 1))

	; no more sneaking around
	(cs_crouch false 1)

	; go to our featured grassy knoll and shoot at the covenant
	(cs_go_to_and_face (ai_point_set_get_point ps_area2_attack_upper s_area2_attack_upper) ps_area2_poi/area2_pit)
	(cs_shoot true area2_encounter)

	; wait until the player enters the encounter area or time has passed
	(sleep_until (volume_test_players area2_trigger_a) 1 (game_ticks_from_seconds 3))

	; continue to shoot down for a little longer
	(sleep (game_ticks_from_seconds 7))

	; leap down into the fight
	(cs_ignore_obstacles true)
	(cs_go_to ps_area2_poi/area2_drop 300)
)

; post combat have johnson move to a visible spot and sometimes motion the player forward
; command scripts runs until aborted by player progress or encounter combat
(script command_script cs_area2_exit_johnson
	(branch (or (volume_test_players area2_follow_player_side) (f_area3_combat_started)) (f_print_abort_message "area2 | aborting exit johnson"))
	(cs_ignore_obstacles true)

	; have johnson move to a spot where the player can easily see him
	(cs_go_to ps_area2_exit_johnson/p0 .5)

	; sometime johnson will face the player and wave at them to get the player to move over to him and progress
	(sleep_until
		(begin
			(begin_random
				(begin ; wait at rock
					(cs_face_player true)
					(sleep (game_ticks_from_seconds 3))
				)
				(begin ; get players attention
					(unit_set_integrated_flashlight ai_current_actor false)
					(cs_action_at_player ai_action_wave)
					(unit_set_integrated_flashlight ai_current_actor true)
					(cs_face_player true)
					(sleep (game_ticks_from_seconds 15))
				)
			)

			false
		)
	1)
)

; post combat have marines move to a visible spot and sometimes attract the player's attention to lure them forward
; command scripts runs until aborted by player progress or encounter combat
(script command_script cs_area2_exit_marine
	(branch (or (volume_test_players area2_follow_player_side) (f_area3_combat_started)) (f_print_abort_message "area2 | aborting exit marines"))
	(set s_area2_exit_marine (+ s_area2_exit_marine 1))

	; get into position
	(cs_go_to (ai_point_set_get_point ps_area2_exit_marines s_area2_exit_marine) 1)
	(cs_crouch true 1)

	; loop occasionally looking at the player and luring them over
	(sleep_until
		(begin
			(f_maneuver_marine_attract_player ai_current_actor)

			false
		)
	1)
)

; area3 maneuvers

; used to iterate through point sets as actors enter a command script
(global short s_area3_prepped_marine -1)

; johnson moves forward and takes cover before the next encounter and occasionally peaks around the corner.
(script command_script cs_area3_ready_johnson
	(branch (= (f_area3_combat_started) true) (f_print_abort_message "area3 | aborting ready johnson"))

	; turn off light and sneak forward into position
	(unit_set_integrated_flashlight ai_current_actor false)
	(cs_go_to_and_face ps_area3_ready_johnson/p0_johnson_stop ps_area3_ready_johnson/p1_target)

	; animated into position
	(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:left_crouch_closed:enter" true)

	; loop here sometimes looking around the corner at the covenant
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:left_crouch_closed:idle" true)
					(sleep (game_ticks_from_seconds 2))
				)
				(sleep (game_ticks_from_seconds 3))
				(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:left_crouch_closed:peek" true)
			)

			; wait until combat starts
			(= (f_area3_combat_started) true)
		)
	1)

	; exit animation and enable flashlight
	(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:left_crouch_closed:exit" true)
	(unit_set_integrated_flashlight ai_current_actor true)
)

; marines move into ready positions before the next encoutner and occasionally lure the player over by looking at them with a flashlight
; command script runs until aborted by combat
(script command_script cs_area3_ready_marine
	(branch (= (f_area3_combat_started) true) (f_print_abort_message "area3 | aborting ready marines"))
	(set s_area3_prepped_marine (+ s_area3_prepped_marine 1))

	; move into position
	(cs_go_to_and_face (ai_point_set_get_point ps_area3_ready_marines s_area3_prepped_marine) ps_area3_ready_johnson/p1_target)
	(cs_crouch true 1)

	; loop and occasionally lure the player over by looking at them with a flashlight.
	(sleep_until
		(begin
			(f_maneuver_marine_attract_player ai_current_actor)

			false
		)
	1)
)

; area4 maneuvers

; used to iterate through point sets as actors enter a command script
(global short s_area4_prepped_marine -1)

; move marines up and have them hide in position and wait for combat
(script command_script cs_area4_ready_marine
	(branch (= (f_area4_combat_started) true) (f_print_abort_message "area4 | aborting ready marines"))
	(set s_area4_prepped_marine (+ s_area4_prepped_marine 1))

	; move into position and look at encounter
	(cs_go_to_and_face (ai_point_set_get_point ps_area4_ready_marines s_area4_prepped_marine) ps_area4_ready_johnson/p1_target)

	; turn off the flashlight to hide
	(unit_set_integrated_flashlight ai_current_actor false)

	; begin their idle hide animation
	(custom_animation_loop ai_current_actor "objects\characters\marine\marine" "crouch:rifle:idle" true)

	; wait for combat to begin
	(sleep_until (= (f_area4_combat_started) true) 1)

	; stop their animating
	(cs_stop_custom_animation)

	; enable flashlight and have them move in
	(unit_set_integrated_flashlight ai_current_actor true)

)

; johnson moves forward and takes cover before the next encounter and occasionally peaks around the corner.
(script command_script cs_area4_ready_johnson
	(branch (= (f_area4_combat_started) true) (f_print_abort_message "area4 | aborting ready johnson"))

	; turn off flashlight and move into position
	(unit_set_integrated_flashlight ai_current_actor false)
	(cs_go_to_and_face ps_area4_ready_johnson/p0_johnson_stop ps_area4_ready_johnson/p1_target)

	; animated into the hiding spot
	(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:left_crouch_closed:enter" true)

	; loop and sometimes peak out at the covenant
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:left_crouch_closed:idle" true)
					(sleep (game_ticks_from_seconds 2))
				)
				(sleep (game_ticks_from_seconds 3))
				(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:left_crouch_closed:peek" true)
			)

			;wait for combat to begin
			(= (f_area4_combat_started) true)
		)
	1)

	; exit animation from hiding spot
	(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:left_crouch_closed:exit" true)

	; enable flashlight no more hiding
	(unit_set_integrated_flashlight ai_current_actor true)
)

; area5 maneuvers

; used to iterate through point sets as actors enter a command script
(global short s_area5_prepped_marine -1)
(global short s_area5_exit_pelican_marines -1)

; johnson moves forward and takes cover before the next encounter and occasionally peaks around the corner.
(script command_script cs_area5_ready_johnson
	(branch (= (f_area5_combat_started) true) (f_print_abort_message "area5 | aborting ready johnson"))

	; turn off flashlight and move forward into position
	(unit_set_integrated_flashlight ai_current_actor false)
	(cs_go_to_and_face ps_area5_ready_johnson/p0_johnson_stop ps_area5_ready_johnson/p1_target)

	; animate into hiding position
	(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:right_crouch_closed:enter" true)

	; loop occasionally looking out at the covenant
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:right_crouch_closed:idle" true)
					(sleep (game_ticks_from_seconds 2))
				)
				(sleep (game_ticks_from_seconds 3))
				(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:right_crouch_closed:peek" true)
			)

			; wait for combat
			(= (f_area5_combat_started) true)
		)
	1)

	; exit animation and move into the fight
	(cs_custom_animation "objects\characters\marine\marine" "bunker:rifle:any:right_crouch_closed:exit" true)

	; turn on flashlight
	(unit_set_integrated_flashlight ai_current_actor true)
)

; marines stack up before the encoutner and wait with lights off for combat to begin
(script command_script cs_area5_ready_marine
	(branch (= (f_area5_combat_started) true) (f_print_abort_message "area5 | aborting ready marines"))
	(set s_area5_prepped_marine (+ s_area5_prepped_marine 1))

	; move to their spot and wait for combat
	(cs_go_to_and_face (ai_point_set_get_point ps_area5_ready_marines s_area5_prepped_marine) ps_area5_ready_johnson/p1_target)

	; lights off to hide
	(unit_set_integrated_flashlight ai_current_actor false)

	; begin an idle hide animation
	(cs_custom_animation_loop "objects\characters\marine\marine" "crouch:rifle:idle" true)

	; wait for combat
	(sleep_until (= (f_area5_combat_started) true) 1)

	; stop animating
	(cs_stop_custom_animation)
)

; as marines exit the pelican to join at the grav lift have 2 of them either scan the aftermath of the fight, or stare up and gawk at the ship above
; scripts are on the spawn placement
(script command_script cs_area5_exit_pelican_marines

	; wait to get off the pelican
	(sleep_until (< (list_count (vehicle_riders v_pelican)) 2) 1)
	(set s_area5_exit_pelican_marines (+ s_area5_exit_pelican_marines 1))

	; move to our position
	(cs_go_to_and_face (ai_point_set_get_point ps_area5_exit_pelican_marines s_area5_exit_pelican_marines) ps_area5_poi/ship)

	; choose to do one of these things
	(begin_count 1
		(custom_animation ai_current_actor "objects\characters\marine\marine" "global_alert:rifle:look_up_ship" true)
		(custom_animation ai_current_actor "objects\characters\marine\marine" "global_alert:rifle:survey_environment" true)
	)

	; wait until their are done animating
	(sleep_until (<= (unit_get_custom_animation_time ai_current_actor) 0) 1)

	; stop animating and move to join the rest of the marines
	(cs_stop_custom_animation)

)

; shared behavior for marines to idle in spots where we want to lure the player
(script static void (f_maneuver_marine_attract_player (ai marine))
	(begin_random
		(begin
			(cs_face_player marine true)
			(sleep (game_ticks_from_seconds 3))
			(cs_face_player marine false)
		)
		(sleep (game_ticks_from_seconds 2))
		(sleep (game_ticks_from_seconds 10))
	)
)

;====================================================================================================================================================================================================
; navpoints ==============================================================================================================================================
;====================================================================================================================================================================================================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; canyon nav points ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;insertion_area_1 - canyon nav-point script
(script dormant canyon_nav_points
	(sleep_until (= b_the_mission_has_begun 1) 1)

	(f_blip_flag canyon_navpoint1 0) ;(insertion_area_1)
	(sleep_until (volume_test_players canyon_nav_reached1) 1)
	(f_unblip_all)

	(sleep_until b_stick_to_the_right_navpoint 1)
	(f_blip_flag canyon_navpoint1_b 0)

	(sleep_until (or
					(volume_test_players tv_unblip_canyon_nav_1_b) ; moves into position
					(volume_test_players area2_trigger_a) ; player ignored the guidance, stealth was optional
				)
	1)
	(f_unblip_all)

	(set b_canyon_nav_2_triggered true)
)

;insertion_area_3 - canyon nav-point script
(script dormant canyon_nav_points_part_2
	(sleep_until (= b_canyon_nav_2_triggered 1) 1)

	(sleep_until (or
				(= b_up_around_bend_navpoint true)
				(= b_starting_at_insertion_area_3 true)
				)
				1
	)

	(f_blip_flag canyon_navpoint2 0) ;(insertion_area_3)

	(sleep_until (volume_test_players tv_unblip_canyon_nav_2) 1)
	(sleep (game_ticks_from_seconds .25)) ; align with vo saying stop!
	(f_unblip_all)

	(sleep_until (or
					(script_finished "vo_area3_approach") ; align with vo calling out where enemies are
					(volume_test_players tv_unblip_canyon_nav_2_b)
				)
	1 )
	(f_blip_flag canyon_navpoint2_b 0)

	(sleep_until (volume_test_players tv_unblip_canyon_nav_2_b) 1)
	(f_unblip_all)

	(set b_canyon_nav_3_triggered true)
)

;insertion_area_4 - canyon nav-point script
(script dormant canyon_nav_points_part_3
	(sleep_until (= b_canyon_nav_3_triggered 1) 1)

	(sleep_until
		(or
			(= b_sneak_up_canyon_navpoint true)
			(= b_starting_at_insertion_area_4 true)
		)
		1
	)

	(f_blip_flag canyon_navpoint3 0) ;(insertion_area_4)

	(sleep_until (volume_test_players canyon_nav_reached3) 1)
	(f_unblip_all)

	(sleep_until
		(or
			(= b_stick_to_the_left_navpoint true) ; based on vo triggering / variable not tripped using inesrtion point must enter combat to trigger
			(volume_test_players tv_unblip_canyon_nav_3_c) ; if the player stealthed or skipped the encounter
		)
	1)
	(if (not (volume_test_players tv_unblip_canyon_nav_3_c)) (f_blip_flag canyon_navpoint3_b 0))

	(sleep_until
		(or
			(volume_test_players tv_unblip_canyon_nav_3_b) ; player went to the navpoint
			(volume_test_players area4_marines_ledge_trigger) ; player ignored the nav point and went over the hill towards the bridge
			(<= (ai_nonswarm_count area4_encounter) 2) ; the player fought and reduced the encounter to 2 or less enemies
			(volume_test_players tv_unblip_canyon_nav_3_c) ; if the player stealthed or skipped the encounter
		)
		1
	)
	(f_unblip_all)

	(sleep_until
		(or
			(<= (ai_nonswarm_count area4_encounter) 2) ; the player fought and reduced the encounter to 2 or less enemies
			(volume_test_players tv_unblip_canyon_nav_3_c) ; if the player stealthed or skipped the encounter
		)
	1)
	(if (not (volume_test_players tv_unblip_canyon_nav_3_c)) (f_blip_flag canyon_navpoint3_c 0))

	(set b_canyon_nav_4_triggered true)
)

;insertion_area_5 - canyon nav-point script
(script dormant canyon_nav_points_part_4
	(sleep_until (= b_canyon_nav_4_triggered 1) 1)

	(sleep_until (volume_test_players tv_unblip_canyon_nav_3_c) 1) ;players start pre-tvolume
	(f_unblip_all)
	(f_blip_flag canyon_navpoint4 0) ;(insertion_area_5)

	(sleep_until (volume_test_players canyon_nav_reached4) 1)
	(f_unblip_all)
	(sleep_until b_ready_to_lift_to_ship 1) ; all marines are in position and waiting for player
	(f_blip_flag canyon_navpoint5 0)

	(sleep_until (volume_test_players tv_gravlift_marine_muster) 1) ; player at lift bottom
	(f_unblip_all)

	(sleep_until (!= (object_get_health gravity_lift_player_to_ship) -1) 1) ; player lift has been created
	(f_blip_flag canyon_navpoint5 0)

	(sleep_until (volume_test_players canyon_nav_lift_reached) 1) ; player is in lift
	(f_unblip_all)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ship nav points ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;insertion gravity_room - ship nav-point script
(script dormant ship_navpoints
	(sleep_until (= b_start_ship_navpoints 1) 1)

	(f_blip_flag ship_navpoint0 0); new navpoint to lead you up the corridors

	(sleep_until (volume_test_players tv_unblip_ship_nav_0) 1) ;(insertion grav_mus_hall)
	(f_unblip_all)
	(sleep (game_ticks_from_seconds .5))

	(set b_ship_nav_2_triggered true)
)

;insertion_grav_mus_hall - ship nav-point script
(script dormant ship_navpoints_part_2
	(sleep_until (= b_ship_nav_2_triggered 1) 1)

	(f_blip_flag ship_navpoint1 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_1) 1)
	(f_unblip_all)

	(sleep_until (volume_test_players muster_view_door) 1)
	(f_blip_flag ship_navpoint1_b 0)

	; currently not doing waves in muster bay its now a blood gate.
	; if you don't get the marines you can still proceed, we just wont give you this nav marker.
	(sleep_until
		(or
			(volume_test_players ship_nav_reached1)
			(> (device_get_position muster_bay_door) 0)
		)
		1
	)
	(f_unblip_all)
	(sleep_until
		(or
			(volume_test_players ship_nav_reached1)
			(<= (ai_nonswarm_count enc_muster_bay) 0)
		)
		1
	)
	(f_blip_flag ship_navpoint2 0)

	(sleep_until (volume_test_players ship_nav_reached1) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint3 0)

	(sleep_until (volume_test_players ship_nav_reached2) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint4 0)

	(sleep_until (volume_test_players ship_nav_reached3) 1)
	(f_unblip_all)
	(sleep (game_ticks_from_seconds .5))

	(set b_ship_nav_3_triggered true)
)

;insertion_hanger - ship nav-point script
(script dormant ship_navpoints_part_3
	(sleep_until (= b_ship_nav_3_triggered 1) 1)

	(f_blip_flag ship_navpoint5 0)

	(sleep_until (volume_test_players ship_nav_reached4) 1)
	(f_unblip_all)

	(sleep_until (> (device_get_position hangar_exit) .5) 1) ;hunters need to be dead before this occurs (insertion_hanger)
	(f_blip_flag ship_navpoint6 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_6) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint6_b 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_6_b) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint6_c 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_6_c) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint6_d 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_6_d) 1)
	(f_unblip_all)


	(print_if debug "updated objective | ascend to the upper deck")
	(f_hud_obj_new_no_hud_completion "obj_a50_ascendupper" "obj_a50_ascendupper")

	(f_blip_flag ship_navpoint7 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_7) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint7_a 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_7_a) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint7_b 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_7_b) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint7_c 0)

	(sleep_until (volume_test_players ship_nav_reached6) 1)
	(print_if debug "new objective | locate the ship's brig")
	(f_hud_obj_new "obj_a50_rescue" "obj_a50_rescue")
	(f_unblip_all)
	(f_blip_flag ship_navpoint8 0)

	(sleep_until (volume_test_players ship_nav_reached7) 1)
	(f_unblip_all)
	(sleep (game_ticks_from_seconds .5))

	(set b_ship_nav_4_triggered true)
)

;insertion_control - ship nav-point script
(script dormant ship_navpoints_part_4
	(sleep_until (= b_ship_nav_4_triggered 1) 1)

	(f_blip_flag ship_navpoint8_b 0) ;(insertion_control)

	(sleep_until (volume_test_players tv_unblip_ship_nav_8_b) 1)
	(f_unblip_all)

	(sleep_until (and b_control_reinforcement_spawned (= (ai_nonswarm_count control_encounter) 0)) 1)

	(set b_ship_nav_5_triggered true)
)

;insertion_prison - ship nav-point script
(script dormant ship_navpoints_part_5
	(sleep_until (= b_ship_nav_5_triggered 1) 1)

	(f_blip_flag ship_navpoint9 0) ;(insertion_prison)

	(sleep_until (volume_test_players ship_nav_reached8) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint9_b 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_9_b) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint10 0)

	(sleep_until (volume_test_players ship_nav_reached9) 1)
	(f_unblip_all)
	(sleep_until (and b_captain_rescued (volume_test_players prison_after_reyes_saved_trigger)) 1)

	(sleep_until b_head_back_for_evac 1) ;based on vo triggering
	(f_blip_flag ship_navpoint11 0)

	(sleep_until (volume_test_players ship_nav_reached10) 1)
	(f_unblip_all)
	(f_blip_flag ship_navpoint11_b 0)

	(sleep_until (volume_test_players tv_unblip_ship_nav_11_b) 1)
	(f_unblip_all)
	;(f_blip_flag ship_navpoint12 0) ;; commented out since its behind the trigger for the next section of the game and there will be 2 navpoints onscreen otherwise

	;(sleep_until (volume_test_players tv_unblip_ship_nav_12) 1)
	;(f_unblip_all)
	(sleep (game_ticks_from_seconds .5))

	(set b_ship_nav_6_triggered true)
)

;insertion_control_revisited- ship nav-point script
(script dormant ship_navpoints_part_6
	(sleep_until (= b_ship_nav_6_triggered 1) 1)

	(f_blip_flag ship_navpoint13 0) ;(insertion_control_revisited)

	; wait until the player has approached the control room.
	(sleep_until (volume_test_players control_prison_follow_player_trigger) 1)
	; wait to hide our navpoint until
	(sleep_until
		(or
			(>= (ai_combat_status stealth_elites_control) visible) ; the stealth elites status is correct (aligns with vo)
			(volume_test_players tv_unblip_ship_nav_13) ; the player got near the door (safety check in case the player got too clsoe to the door)
		)
		1
	) ; wait until the stealth elites combat status is triggered

	(f_unblip_all) ; turn off waypoint

	; wait to blip the next waypoint until the bloodgate is complete (align with vo calling out the room is clear)
	(sleep_until (= (ai_living_count stealth_elites_control) 0) 1)

	(sleep_until (script_finished "vo_keyes_stealth_elites") 1 (game_ticks_from_seconds 10)) ; wait until the vo is done to give the player the next nav marker or enough time has passed as a fall back
	(sleep_until (> (ai_living_count control_grunts_return) 0) 1) ; wait the next enemies to drop to ready the door

	(f_blip_flag ship_navpoint13 0) ; put our marker back on the door

	; wait for player to reach the door
	(sleep_until (volume_test_players tv_unblip_ship_nav_13) 1)

	(f_unblip_all) ; turn off waypoint
	(f_blip_flag ship_navpoint13_b 0) ; give us the next waypoint

	(sleep_until (volume_test_players tv_unblip_ship_nav_13_b) 1)
	(f_unblip_all)
	(sleep (game_ticks_from_seconds .5))

	(set b_ship_nav_7_triggered true)
)

;insertion_hanger_revisited- ship nav-point script
(script dormant ship_navpoints_part_7
	(sleep_until (= b_ship_nav_7_triggered 1) 1)

	(f_blip_flag ship_navpoint14 0) ;(insertion_hanger_revisited)

	; we don't want to unblip our last nav marker to end the level
)

; removes all navpoints used in the level
(script static void f_unblip_all
	(f_unblip_flag canyon_navpoint1)
	(f_unblip_flag canyon_navpoint1_b)
	(f_unblip_flag canyon_navpoint2)
	(f_unblip_flag canyon_navpoint2_b)
	(f_unblip_flag canyon_navpoint3)
	(f_unblip_flag canyon_navpoint3_b)
	(f_unblip_flag canyon_navpoint3_c)
	(f_unblip_flag canyon_navpoint4)
	(f_unblip_flag canyon_navpoint5)

	(f_unblip_flag ship_navpoint0)
	(f_unblip_flag ship_navpoint1)
	(f_unblip_flag ship_navpoint1_b)
	(f_unblip_flag ship_navpoint2)
	(f_unblip_flag ship_navpoint3)
	(f_unblip_flag ship_navpoint4)
	(f_unblip_flag ship_navpoint5)
	(f_unblip_flag ship_navpoint6)
	(f_unblip_flag ship_navpoint6_b)
	(f_unblip_flag ship_navpoint6_c)
	(f_unblip_flag ship_navpoint6_d)
	(f_unblip_flag ship_navpoint7)
	(f_unblip_flag ship_navpoint7_a)
	(f_unblip_flag ship_navpoint7_b)
	(f_unblip_flag ship_navpoint7_c)
	(f_unblip_flag ship_navpoint8)
	(f_unblip_flag ship_navpoint8_b)
	(f_unblip_flag ship_navpoint9)
	(f_unblip_flag ship_navpoint9_b)
	(f_unblip_flag ship_navpoint10)
	(f_unblip_flag ship_navpoint11)
	(f_unblip_flag ship_navpoint11_b)
	(f_unblip_flag ship_navpoint12)
	(f_unblip_flag ship_navpoint13)
	(f_unblip_flag ship_navpoint13_b)
	(f_unblip_flag ship_navpoint14)
)

;=========================================================================================================================
; fireteams ==============================================================================================================
;=========================================================================================================================



(script static void (f_fireteam_migrate_to_squads (ai johnson) (ai marines) (ai filler) (ai keyes))
	(ai_player_set_fireteam_no_max player0)

	(print_if debug "fireteam | migrating to new squads")
	(ai_migrate_persistent ai_fireteam_johnson johnson)
	(ai_migrate_persistent ai_fireteam_keyes keyes)
	(ai_migrate_persistent ai_fireteam_marines marines)
	(ai_migrate_persistent ai_fireteam_fill filler)

	(print_if debug "fireteam | setting fireteam squad variables")
	(set ai_fireteam_johnson johnson)
	(set ai_fireteam_keyes keyes)
	(set ai_fireteam_marines marines)
	(set ai_fireteam_fill filler)
)

;helper that takes the encounter or areas squads and converts them to the fireteam squads with objectives
(script static void (f_fireteam_migrate_join_and_follow (ai johnson) (ai marines) (ai filler) (ai keyes))
	(ai_player_set_fireteam_no_max player0)

	(f_fireteam_migrate_to_squads johnson marines filler keyes)

	(f_fireteam_join_player)

	(f_fireteam_follow_player)
)

(script static void f_fireteam_join_player

	(print_if debug "fireteam | all squads have joined the fireteam")
	(ai_player_add_fireteam_squad player0 ai_fireteam_johnson)
	(ai_player_add_fireteam_squad player0 ai_fireteam_keyes)
	(ai_player_add_fireteam_squad player0 ai_fireteam_marines)
	(ai_player_add_fireteam_squad player0 ai_fireteam_fill)
)

;all members of the fireteam drop from the fireteam group but remain in the variables to gather later.
(script static void f_fireteam_leave_player
	(print_if debug "fireteam | all squads have left the fireteam")
	(ai_player_remove_fireteam_squad player0 ai_fireteam_johnson)
	(ai_player_remove_fireteam_squad player0 ai_fireteam_keyes)
	(ai_player_remove_fireteam_squad player0 ai_fireteam_marines)
	(ai_player_remove_fireteam_squad player0 ai_fireteam_fill)
)

;move all members of the fireteam to a specific objective
(script static void (f_fireteam_set_objective (string_id next_objective))
	(print_if debug "fireteam | moved fireteam to new objective")
	(ai_set_objective ai_fireteam_johnson next_objective)
	(ai_set_objective ai_fireteam_keyes next_objective)
	(ai_set_objective ai_fireteam_marines next_objective)
	(ai_set_objective ai_fireteam_fill next_objective)
)

;move all members of the fireteam to follow the player
(script static void f_fireteam_follow_player
	(f_fireteam_set_objective ai_objective_fireteam)
	(print_if debug "fireteam | now in the fireteam objective")
)

;helper to add backfill squads to the fireteam fill squad, add them to the fireteam, and give them the objective.
(script static void (f_migrate_squad_to_fireteam_fill (ai squad))
	(begin
			(print_if debug "fireteam | adding new squad to existing fireteam fill")
			(ai_migrate_persistent squad ai_fireteam_fill)

			(print_if debug "fireteam | readding fireteam filler to player fireteam")
			(ai_player_add_fireteam_squad player0 ai_fireteam_fill)

			(print_if debug "fireteam | setting fireteam filler to fireteam objective")
			(ai_set_objective ai_fireteam_fill ai_objective_fireteam)
	)
)

;helper to add backfill squads to the fireteam marine squad, add them to the fireteam, and give them the objective.
(script static void (f_migrate_squad_to_fireteam_marines (ai squad))
	(begin
			(print_if debug "fireteam | adding new squad to existing fireteam marines")
			(ai_migrate_persistent squad ai_fireteam_marines)

			(print_if debug "fireteam | readding fireteam filler to player fireteam")
			(ai_player_add_fireteam_squad player0 ai_fireteam_marines)

			(print_if debug "fireteam | setting fireteam filler to fireteam objective")
			(ai_set_objective ai_fireteam_marines ai_objective_fireteam)
	)
)




;=========================================================================================================================
; bsp trasnfer section ===================================================================================================
;=========================================================================================================================

;landing zone 1 to landing zone 2
(script static void (f_transfer_lz1_lz2 (ai squad))
	(cs_run_command_script squad cs_transfer_lz1_lz2)
)

(script command_script cs_transfer_lz1_lz2
	(cs_go_to ps_transfer_lz1_lz2/p0)
	(cs_go_to ps_transfer_lz1_lz2/p1)
	(cs_go_to ps_transfer_lz1_lz2/p2)
	(cs_go_to ps_transfer_lz1_lz2/p3)
)

(script static void (f_transfer_lz2_lz1 (ai squad))
	(cs_run_command_script squad cs_transfer_lz2_lz1)
)

(script command_script cs_transfer_lz2_lz1
	(cs_go_to ps_transfer_lz1_lz2/p3)
	(cs_go_to ps_transfer_lz1_lz2/p2)
	(cs_go_to ps_transfer_lz1_lz2/p1)
	(cs_go_to ps_transfer_lz1_lz2/p0)
)

;landig zone 2 to gravity lift zone 1
(script static void (f_transfer_lz2_glz1 (ai squad))
	(print_if debug "attempting to move to zone set 2")
	(cs_run_command_script squad cs_transfer_lz2_glz1)
)

(script command_script cs_transfer_lz2_glz1
	(cs_enable_pathfinding_failsafe true) ; this helps with the johnson from getting stuck
	(cs_ignore_obstacles true) ; this helps with the johnson from getting stuck

	(print_if debug "moving to zone set 2")

	(cs_go_to ps_transfer_lz2_glz1/p0)
	(cs_go_to ps_transfer_lz2_glz1/p1)
	(cs_go_to ps_transfer_lz2_glz1/p2)
)

;gravity lift 1 to gravity lift 2
(script static void (f_transfer_glz1_glz2 (ai squad))
	(cs_run_command_script squad cs_transfer_glz1_glz2)
)

(script command_script cs_transfer_glz1_glz2
	(cs_go_to ps_transfer_glz1_glz2/p0)
	(cs_go_to ps_transfer_glz1_glz2/p1)
	(cs_go_to ps_transfer_glz1_glz2/p2)
	(cs_go_to ps_transfer_glz1_glz2/p3)
)

(script static void (f_transfer_glz2_glz1 (ai squad))
	(cs_run_command_script squad cs_transfer_glz2_glz1)
)

(script command_script cs_transfer_glz2_glz1
	(cs_go_to ps_transfer_glz1_glz2/p3)
	(cs_go_to ps_transfer_glz1_glz2/p2)
	(cs_go_to ps_transfer_glz1_glz2/p1)
	(cs_go_to ps_transfer_glz1_glz2/p0)
)

;;
; elevator takes care of bringing npcs from gravity lift zone 2 to ship start zone. this transfer isn't reversible.
;;

;ship start to dropship bay
(script static void (f_transfer_ssz_dbz (ai squad))
	(cs_run_command_script squad cs_transfer_ssz_dbz)
)

(script command_script cs_transfer_ssz_dbz
	(cs_go_to ps_transfer_ssz_dbz/p0)
	(cs_go_to ps_transfer_ssz_dbz/p1)
)

(script static void (f_transfer_dbz_ssz (ai squad))
	(cs_run_command_script squad cs_transfer_dbz_ssz)
)

(script command_script cs_transfer_dbz_ssz
	(cs_go_to ps_transfer_ssz_dbz/p1)
	(cs_go_to ps_transfer_ssz_dbz/p0)
)

;ship start to dropship bay, entrance 2
(script static void (f_transfer_ssz2_dbz2 (ai squad))
	(cs_run_command_script squad cs_transfer_ssz2_dbz2)
)

(script command_script cs_transfer_ssz2_dbz2
	(cs_go_to ps_transfer_ssz2_dbz2/p0)
	(cs_go_to ps_transfer_ssz2_dbz2/p1)
)

(script static void (f_transfer_dbz2_ssz2 (ai squad))
	(cs_run_command_script squad cs_transfer_dbz2_ssz2)
)

(script command_script cs_transfer_dbz2_ssz2
	(cs_go_to ps_transfer_ssz2_dbz2/p1)
	(cs_go_to ps_transfer_ssz2_dbz2/p0)
)

; dropship bay to detention center
(script static void (f_transfer_dbz_dcz (ai squad))
	(cs_run_command_script squad cs_transfer_dbz_dcz)
)

(script command_script cs_transfer_dbz_dcz
	(cs_go_to ps_transfer_dbz_dcz/p0)
	(cs_go_to ps_transfer_dbz_dcz/p1)
)

(script static void (f_transfer_dcz_dbz (ai squad))
	(cs_run_command_script squad cs_transfer_dbz_ssz)
)

(script command_script cs_transfer_dcz_dbz
	(cs_go_to ps_transfer_dbz_dcz/p1)
	(cs_go_to ps_transfer_dbz_dcz/p0)
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
                (ai_place_in_vehicle load_squad_01 fork "fork_p_l")
                (ai_place_in_vehicle load_squad_02 fork "fork_p_l")
                (ai_place_in_vehicle load_squad_03 fork "fork_p_l")
                (ai_place_in_vehicle load_squad_04 fork "fork_p_l")
            )
        )
        ; right
        ((= load_side "right")
            (begin
                (if b_debug_fork (print "load fork right..."))
                (ai_place_in_vehicle load_squad_01 fork "fork_p_r")
                (ai_place_in_vehicle load_squad_02 fork "fork_p_r")
                (ai_place_in_vehicle load_squad_03 fork "fork_p_r")
                (ai_place_in_vehicle load_squad_04 fork "fork_p_r")
            )
        )
        ; dual
        ((= load_side "dual")
            (begin
                (if b_debug_fork (print "load fork dual..."))
                (ai_place_in_vehicle load_squad_01 fork "fork_p_l")
                (ai_place_in_vehicle load_squad_02 fork "fork_p_l")
                (ai_place_in_vehicle load_squad_03 fork "fork_p_r")
                (ai_place_in_vehicle load_squad_04 fork "fork_p_r")
            )
        )
        ((= load_side "any")
            (begin
                (if b_debug_fork (print "load fork any..."))
                (ai_place_in_vehicle load_squad_01 fork "fork_p")
                (ai_place_in_vehicle load_squad_02 fork "fork_p")
                (ai_place_in_vehicle load_squad_03 fork "fork_p")
                (ai_place_in_vehicle load_squad_04 fork "fork_p")
            )
        )
    )
)
; call this script when the fork is in place to drop off all the ai
(script static void (f_unload_fork (vehicle fork) (string drop_side))
    (if b_debug_fork (print "opening fork..."))
    (unit_open fork)
    (sleep (game_seconds_from_ticks 1))
    ; determine how to unload the phantom
    (cond
        ((= drop_side "left")
            (begin
                (f_unload_fork_left fork)
                (sleep (game_ticks_from_seconds 2.5))
            )
        )
        ((= drop_side "right")
            (begin
                (f_unload_fork_right fork)
                (sleep (game_ticks_from_seconds 2.5))
            )
        )
        ((= drop_side "dual")
            (begin
                (f_unload_fork_all fork)
                (sleep (game_ticks_from_seconds 2.5))
            )
        )
    )
    (if b_debug_fork (print "closing fork..."))
    (unit_close fork)
)
(script static void (f_unload_fork_left (vehicle fork))
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
(script static void (f_unload_fork_all  (vehicle fork))
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
