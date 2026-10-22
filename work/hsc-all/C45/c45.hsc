(global vehicle v_spirit_vignette none)

(script startup mission_c45
	(c45_insertion_point_fixups)
	(f_start_auto_save_loop)

	(if (f_insertion_point_area_pending ins_section1)
		(begin
			(f_play_cinematic cinematics\c40\c40_intro.cinematic)
			(set s_music_trigger 20)
			(wake section1)
		)
	)
	(if (f_insertion_point_area_pending ins_section2) (wake section2))
	(if (f_insertion_point_area_pending ins_section3) (wake section3))
	(if (f_insertion_point_area_pending ins_section4) (wake section4))
	(if (f_insertion_point_area_pending ins_section5) (wake section5))

	(device_set_position_immediate dm_intro_barriers 0)
)

(global boolean b_debug false)
(global boolean b_pulse_gen1_downed false)
(global boolean b_pulse_gen2_downed false)
(global boolean b_pulse_gen3_downed false)

(global boolean b_general_dawdle_end false)
(global long l_general_dawdle_sleep (game_ticks_from_seconds 360))

(global boolean b_e3_banshee_spawner_end false)
(global boolean b_e50_banshee_spawner_end false)
(global boolean b_e62_banshee_spawner_end false)

(global short s_hud_delay_for_audio (game_ticks_from_seconds 4.0)) ; used to give space between audio and chapters / objectives

(script dormant section1
	; unlock progress data
	(submit_incident "ins_c45_section1")
	(submit_incident "unlock_c45")
	(submit_incident_with_custom_string_id "game_activity_begin" "c40")

	(print_if b_debug "section 1")
	(wake section1_navpoint_loop)

	(wake section1_place)
	(wake section1_cleanup)
	(wake upper_ziggurat_cleanup)

	(wake e1_a)
	(wake e2_b)
	(wake e3_a)
	(wake c3_base_tier_2)
	(wake e5_a)
	(wake e6_a)
	(wake e7_a)
	(wake e7_c)
	(wake e8_a)
)

(script dormant section1_place
	(wake place_large_hallway_a)
	(wake place_ziggurat)
	(wake place_generator_a)
)
(script dormant place_large_hallway_a
	(object_create_folder large_hallway_a_objects)
)
(script dormant place_generator_a
	(sleep_until (volume_test_players tv_e8_trigger) 1)
	(object_create_folder generator_a_weapons)
)
(script dormant place_ziggurat
	(sleep_until (volume_test_players tv_outside_control_room) 1)
	(object_create_folder ziggurat_top_objects)
	(object_create_folder ziggurat_bottom_objects)
	(sleep 1)
	(object_create_folder ziggurat_top_weapons)
	(object_create_folder ziggurat_bottom_weapons)
	(sleep 1)
	(object_create_folder ziggurat_top_equipment)
	(object_create_folder ziggurat_bottom_equipment)
	(sleep 1)
	(object_create_folder ziggurat_bottom_bipeds)
	(sleep 1)
	(object_create_folder ziggurat_bottom_vehicles)
	(object_create  bw_skull_toughluck)
	(if (> (game_coop_player_count) 1) (object_create v_fly_away_2))
	(if (> (game_coop_player_count) 2) (object_create v_fly_away_3))
	(if (> (game_coop_player_count) 3) (object_create v_fly_away_4))

)

(script dormant section1_cleanup
	(sleep_until (volume_test_players tv_e20_a_trigger) 1)
	(object_destroy_folder large_hallway_a_objects)
	(object_destroy_folder ziggurat_top_objects)
	(object_destroy_folder ziggurat_bottom_objects)
	(object_destroy_folder ziggurat_top_weapons)
	(object_destroy_folder ziggurat_bottom_weapons)
	(object_destroy_folder ziggurat_top_equipment)
	(object_destroy_folder ziggurat_bottom_equipment)
	(object_destroy_folder generator_a_weapons)
	(object_destroy dm_control_door_d)
	(object_destroy dm_control_door_c)
	(object_destroy dm_control_door_a)

	(garbage_collect_now)
)

(script dormant e1_a
	(print_if b_debug "cortana says 'look out !!!'")
	(device_set_position_immediate dm_intro_barriers 0.5)
	(wake control_room_vo)
	(device_set_power dm_door_c1 0)
	(ai_place gr_e1_a)
	(wake chapter_1_objective_1)

	(sleep_until (volume_test_players tv_save_checkpoint1) 1)
	(game_save_no_timeout)
)

(script dormant control_room_vo
	(wake dialog_control_room)
	(sleep_until
		(or
			(volume_test_players tv_end_control_room)
			(= (ai_nonswarm_count gr_e1_a) 0)
		)
	1
	)
	(sleep 15)
	(wake dialog_control_room_leaving)
)

(script dormant chapter_1_objective_1
	(sleep_until
		(or
			(volume_test_players tv_end_control_room)
			(= (ai_nonswarm_count gr_e1_a) 0)
		)
	1
	)
	(sleep (game_ticks_from_seconds 2.0))
	(f_hud_chapter chapter_c40_1)
	(sleep (game_ticks_from_seconds 2.0))
	(f_hud_obj_new obj_c40_start obj_c40_start)
)

(script dormant e2_b
	(sleep_until (> (device_get_position dc_control_door_d_cont_b) 0) 1)
	(print_if b_debug "door should open")
	(ai_place gr_e2_all)
	(wake door_cover)
	(wake e2_music_trigger)
	(wake checkpoint_zigg_canyon_banshee)
	(wake checkpoint_zigg)
	(sleep (game_ticks_from_seconds 1))
	(device_set_position dm_control_door_c 1)

	(sleep_until (volume_test_players tv_save_checkpoint2) 1)
	(game_save_no_timeout)
)

(script dormant door_cover
	(sleep_until (= (device_get_position dc_control_door_a_cont_a) 1) 1)
	(device_set_position dm_control_door_a .8)
	(print_if b_debug "door shouldn't open all the way!")
)

(script dormant checkpoint_zigg
	(sleep_until (volume_test_players tv_save_checkpoint_zigg_halfway) 1)
	(print "checkpoint - player made it halfway down the ziggurat")
	(game_save_no_timeout)

	(sleep_until (volume_test_players tv_save_checkpoint_zigg_banshee_ground) 1)
	(print "checkpoint - player made it to banshees area")
	(game_save_no_timeout)
)

(script dormant checkpoint_zigg_canyon_banshee
	; catch a flying player on the way up
	(sleep_until (and (volume_test_players tv_save_checkpoint_zigg_banshee) (any_players_in_vehicle_type s_vehicle_type_banshee)) 1)
	(game_save_no_timeout)

	; wait for the conduit to go down...
	(sleep_until b_pulse_gen1_downed 1)

	; and then get 'em on the way back
	(sleep_until (and (volume_test_players tv_save_checkpoint_zigg_banshee) (any_players_in_vehicle_type s_vehicle_type_banshee)) 1)
	(game_save_no_timeout)
)

(script dormant e3_a
	(sleep_until (volume_test_players tv_e3_trigger) 1)
	(print_if b_debug "encounter e3_a")
	(ai_place sq_e3_a_jmppa)
	(ai_place sq_e3_a_empa)
	(ai_place sq_e3_a_gmpa)
	(sleep_until (= (device_get_position dc_control_door_a_cont_a) 1) 1)
	(f_hud_obj_complete)
	(set s_music_trigger 40)
	(wake force_save_1)
	(sleep_until (volume_test_players tv_save_checkpoint2a) 1)
	(game_save_no_timeout)
)

(script dormant force_save_1 (sleep_until (= (ai_nonswarm_count gr_e2_b) 0) 1) (game_save_no_timeout))

(script dormant c3_base_tier_2
	(sleep_until (volume_test_players tv_canyon3_base_trigger) 1)
	(wake dialog_gen1_marked)
	(wake dialog_general_dawdle)
	(ai_place gr_c3_base_tier_2)
	(ai_erase gr_e2_c)
	(ai_erase gr_e2_b)
	(ai_erase gr_e2_a)

	; dropship squad for the vignette
	(wake ini_spirit_vignette)

	(sleep_until (volume_test_players tv_save_checkpoint3) 1)
	(game_save_no_timeout)

	(sleep_until (volume_test_players tv_save_checkpoint3a) 1)
	(game_save_no_timeout)
)

(script dormant ini_spirit_vignette
	(ai_place sq_spirit_vignette)
	;(set v_spirit_vignette (ai_vehicle_get_from_starting_location sq_spirit_vignette/pilot_spawn))
	(set v_spirit_vignette (ai_vehicle_get_from_spawn_point sq_spirit_vignette/pilot_spawn))

	(ai_place sq_e6_a_empa_vignette)
	(ai_place sq_e6_a_gmna_vignette)

	(vehicle_load_magic v_spirit_vignette "fork" (ai_actors sq_e6_a_empa_vignette))
	(vehicle_load_magic v_spirit_vignette "fork" (ai_actors sq_e6_a_gmna_vignette))

	; wait until a player is looking or the delay passes before having the ship move.  timeout is tuned to just before the nav point appears so the object is guaranteed to be moving when the player is most likely to look
	(sleep 1) ; sleep a frame in case the player is already looking
	(sleep_until (objects_can_see_object (players) v_spirit_vignette 30) 1 (game_ticks_from_seconds 34))
	(cs_run_command_script (object_get_ai (vehicle_driver v_spirit_vignette)) cs_spirit_vignette)
)

; used with squad sq_spirit_vignette
(script command_script cs_spirit_vignette
	; enable failsafes for the scripted flight path
 	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face ps_spirit_vignette/p0 ps_spirit_vignette/p1_face)
	(cs_fly_to_and_face ps_spirit_vignette/p2 ps_spirit_vignette/p4_face)
	(cs_fly_to_and_face ps_spirit_vignette/p3 ps_spirit_vignette/p4_face)
	(unit_open v_spirit_vignette)
	(sleep 30)
	(vehicle_unload v_spirit_vignette "fork")
	(sleep 120)
	(unit_close v_spirit_vignette)
	(cs_fly_to_and_face ps_spirit_vignette/p2 ps_spirit_vignette/p4_face)
	(cs_fly_to_and_face ps_spirit_vignette/p0 ps_spirit_vignette/p1_face)
	(cs_fly_to ps_spirit_vignette/p5)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant upper_ziggurat_cleanup
	(sleep_until (volume_test_players tv_canyon3_land_trigger) 1)
	(ai_erase sq_c3_base_tier_2_emptt)
	(ai_erase sq_c3_base_tier_2_jmptt)
	(ai_erase sq_c3_base_tier_2_gmntt)
	(ai_erase sq_c3_base_tier_2_3gmpc)
	(ai_erase sq_c3_base_tier_2_3jmpc)
	(ai_erase sq_c3_base_tier_2_3empd)
	(ai_erase sq_c3_base_tier_2_2jmpf)
	(ai_erase sq_c3_base_tier_2_2empg)
	(garbage_collect_now)
)
(script dormant e5_a
	(sleep_until (volume_test_players tv_canyon3_spawn_land_trigger) 1)
	(ai_place gr_c3_cov_base)
	(vehicle_load_magic v_c3_wra_a "wraith_d" (ai_actors sq_c3_cov_base_emppa))
	(wake e3_banshee_spawner)
	(sleep 1)
	(wake banshee1_save)
	(sleep 1)
	(sleep_until (objects_can_see_object (players) v_fly_away_1 20) 1)
	(f_hud_obj_new obj_c40_banshee obj_c40_banshee)
	(wake obj_complete_banshee_commandeered)
	(wake dialog_need_banshee)
)

(script dormant obj_complete_banshee_commandeered
	(sleep_until (any_players_in_vehicle_type s_vehicle_type_banshee) 1)
	(f_hud_obj_complete)
)

(script dormant e3_banshee_spawner
	(sleep_until
		(begin
			(if (not b_e3_banshee_spawner_end) ;while
				(begin
					(if (<= (unit_get_health v_fly_away_1) 0)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_fly_away_1 40)) 1)
							(object_destroy v_fly_away_1)
							(object_create v_fly_away_1)
						)
					)
					(if (and
							(> (game_coop_player_count) 1) ; if 2 players
							(<= (unit_get_health v_fly_away_2) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_fly_away_2 40)) 1)
							(object_destroy v_fly_away_2)
							(object_create v_fly_away_2)
						)
					)
					(if (and
							(> (game_coop_player_count) 2) ; if 3 players
							(<= (unit_get_health v_fly_away_3) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_fly_away_3 40)) 1)
							(object_destroy v_fly_away_3)
							(object_create v_fly_away_3)
						)
					)
					(if (and
							(> (game_coop_player_count) 3) ; if 4 players
							(<= (unit_get_health v_fly_away_4) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_fly_away_4 40)) 1)
							(object_destroy v_fly_away_4)
							(object_create v_fly_away_4)
						)
					)
					(sleep 30)
				)
			)
			b_e3_banshee_spawner_end
		)
		1
	)
)

(script dormant banshee1_save
	(sleep_until
		(or
			(vehicle_test_seat_unit_list v_fly_away_1 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_fly_away_2 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_fly_away_3 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_fly_away_4 "banshee_d" (players))
		)
 		1
	)
	(f_unblip_flag fl_fly_away_1)
	(f_unblip_flag fl_fly_away_2)
	(f_unblip_flag fl_fly_away_3)
	(f_unblip_flag fl_fly_away_4)
	(game_save_no_timeout)
	(if (script_finished "dialog_gen1_marked") (wake dialog_gen1_enter_banshee))
)

(script dormant e6_a
	(sleep_until (volume_test_players tv_e6_trigger) 1)

	(wake e6_music_trigger)
	(ai_place gr_e6_a)

	(sleep_until (volume_test_players tv_save_checkpoint5) 1)
	(game_save_no_timeout)
	(wake pulse_gen1_approach)
)

(script dormant pulse_gen1_approach
	(sleep_until (volume_test_players tv_pulse_gen1_approach) 1)
	(wake dialog_gen1_approach)
	(wake dialog_gen1_dally)
	(wake dialog_gen1_leave_before_disabled)
)

(script dormant waypoint_2
	(f_unblip_all)
	(f_blip_flag fl_waypoint_conduit_1b 0)
	(sleep_until (volume_test_players tv_e6_trigger_b) 1)
	(f_unblip_all)
	(sleep_until
		(or
			(volume_test_players tv_e7_trigger_b)
			b_pulse_gen1_downed
		)
		1
	)
)

(script dormant pg1_generator_blips
	(wake pg1_generator_blips_conduit_a)
	(wake pg1_generator_blips_conduit_b)
	(wake pg1_generator_blips_conduit_c)
)

(global real conduit_beam01_damage 0.0)
(script dormant (pg1_generator_blips_conduit_a)
	(if (>= (object_get_health sc_pulse_1_conduit_a) 1)
		(f_blip_flag fl_waypoint_conduit_1c1 1)
	)

	(sleep_until (= (object_get_health sc_pulse_1_conduit_a) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_1c1)
	(set conduit_beam01_damage (+ conduit_beam01_damage 0.25))
	(device_set_position_immediate dm_conduit_room_1a conduit_beam01_damage)
)

(script dormant (pg1_generator_blips_conduit_b)
	(if (>= (object_get_health sc_pulse_1_conduit_b) 1)
		(f_blip_flag fl_waypoint_conduit_1c2 1)
	)

	(sleep_until (= (object_get_health sc_pulse_1_conduit_b) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_1c2)
	(set conduit_beam01_damage (+ conduit_beam01_damage 0.25))
	(device_set_position_immediate dm_conduit_room_1a conduit_beam01_damage)
)

(script dormant (pg1_generator_blips_conduit_c)
	(if (>= (object_get_health sc_pulse_1_conduit_c) 1)
		(f_blip_flag fl_waypoint_conduit_1c3 1)
	)

	(sleep_until (= (object_get_health sc_pulse_1_conduit_c) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_1c3)
	(set conduit_beam01_damage (+ conduit_beam01_damage 0.25))
	(device_set_position_immediate dm_conduit_room_1a conduit_beam01_damage)
)

(script dormant e7_a
	(sleep_until b_pulse_gen1_downed 1)
	(ai_place gr_e7_a)

	(sleep_until (= (ai_nonswarm_count gr_e7_a) 0) 1)
	(game_save_no_timeout)
)

(script dormant sc_pulse_1_conduit_a_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_1_conduit_a) 0) 1)
	(pe_camera_shake_small)
)

(script dormant sc_pulse_1_conduit_b_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_1_conduit_b) 0) 1)
	(pe_camera_shake_small)
)

(script dormant sc_pulse_1_conduit_c_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_1_conduit_c) 0) 1)
	(pe_camera_shake_small)
)

(script dormant e7_c
	(sleep_until (volume_test_players tv_e8_trigger) 1)
	(object_create_folder generator_a_conduits)
	(wake e7_checkpoint_after_2nd_destroyed_conduit)
	(wake sc_pulse_1_conduit_a_camera_shake)
	(wake sc_pulse_1_conduit_b_camera_shake)
	(wake sc_pulse_1_conduit_c_camera_shake)

	(sleep_until
		(and
			(<= (object_get_health sc_pulse_1_conduit_a) 0)
			(<= (object_get_health sc_pulse_1_conduit_b) 0)
			(<= (object_get_health sc_pulse_1_conduit_c) 0)
		)
		1
	)
	(f_hud_obj_new_no_hud_completion obj_c40_1 obj_c40_1)
	(f_hud_obj_complete)
	(plat1_ban)
	(set b_pulse_gen1_downed true)
	(device_set_power dm_door_c1 1)
	(wake dialog_gen1_disabled)

	; we need 1 frame to send our 0.75 damage value to ue
	(sleep 1)
	; setting beam damage to 1 for reloads
	; this will be the 4th time we increment this value
	(set conduit_beam01_damage (+ conduit_beam01_damage 0.25))
	(device_set_position_immediate dm_conduit_room_1a conduit_beam01_damage)
	(sleep 120)
	(f_unblip_all)
	(sleep 150)
	(wake e7_d)

	(sleep_until (volume_test_players tv_save_checkpoint6) 1)
	(game_save_no_timeout)

)
(script dormant e7_checkpoint_after_2nd_destroyed_conduit
	(sleep_until
		(or
			(and
				(<= (object_get_health sc_pulse_1_conduit_a) 0)
				(<= (object_get_health sc_pulse_1_conduit_b) 0)
			)
			(and
				(<= (object_get_health sc_pulse_1_conduit_a) 0)
				(<= (object_get_health sc_pulse_1_conduit_c) 0)
			)
			(and
				(<= (object_get_health sc_pulse_1_conduit_b) 0)
				(<= (object_get_health sc_pulse_1_conduit_c) 0)
			)
		)
	1
	)
	(game_save_no_timeout)
)

(script dormant e7_d
	(sleep_until (volume_test_players tv_e9_trigger) 1)
	(f_unblip_all)
)

(script static void plat1_ban
	(f_clean_banshees tv_plat1_ban_clean)

	(object_create v_ban_plat1_a)
	(if (> (game_coop_player_count) 1) (object_create v_ban_plat1_b))
	(if (> (game_coop_player_count) 2) (object_create v_ban_plat1_c))
	(if (> (game_coop_player_count) 3) (object_create v_ban_plat1_d))
)

(script static void (f_clean_banshees (trigger_volume volume))
	(sleep_until
		(begin
			(object_destroy (list_get (volume_return_objects_by_type volume 2) 0))
			(= (list_count (volume_return_objects_by_type volume 2)) 0)
		)
		1
	)
)

(script dormant e8_a
	(sleep_until
		(and
			b_pulse_gen1_downed
			(volume_test_players tv_e8_trigger)
		)
		1
	)
	(print_if b_debug "targets on the bridge")
	(wake chapter_c40_2)
	(ai_place gr_e8_a)

	(sleep_until (volume_test_players tv_save_checkpoint7) 1)
	(game_save_no_timeout)
)

(script dormant chapter_c40_2
	(sleep_until (volume_test_players tv_act_chapter_2) 1)
	(f_hud_chapter chapter_c40_2)
	(sleep (game_ticks_from_seconds 2))
	(f_hud_obj_new obj_c40_2 obj_c40_2)
)

(script dormant section2

	(wake section2_gen1down_navpoint_loop)

	(sleep_until
		(and
			b_pulse_gen1_downed
			(volume_test_players tv_e20_a_trigger)
		)
		1
	)
	; unlock progress data
	(submit_incident "ins_c45_section2")
	(submit_incident "unlock_c45")
	(submit_incident_with_custom_string_id "game_activity_begin" "c40")

	(print_if b_debug "section 2")
	(set b_e3_banshee_spawner_end true)

	(wake section2_place)
	(wake section2_cleanup)
	(wake section2_encounter_cleanup)
	(wake e20_a)
	(wake e21_a)
	(wake e21_b)
	(wake e22_a)
	(wake e23_b)
	(wake e23_c)
	(wake e20_e23_cleanup)
	(wake e30_a)
	(wake e31_b_flood)
	(wake e33_a)
	(wake e33_b)
	(wake e33_c)
	(wake e33_d)
	(wake e33_z)
	(wake e40_a)
	(wake checkpoint_before_flood_vignette)
	(wake e43_a)
	(wake e43_b)
	(wake e43_c)
	(wake e43_d)
	(wake e44_a)
	(wake e20_music_trigger)
)

(script dormant section2_place
	(wake place_arena_f)
	(wake place_arena_e_d)
)
(script dormant place_arena_f
	(sleep_until (volume_test_players tv_e20_a_trigger) 1)
	(object_create_folder arena_f_bipeds)
	(object_create_folder arena_f_objects)
	(object_create_folder arena_f_weapons)
)

(script dormant place_arena_e_d
	(sleep_until (volume_test_players tv_nav_bridge_exit2) 1)
	(object_create_folder arena_e_bipeds)
	(object_create_folder arena_e_equipment)
	(object_create_folder arena_d_bipeds)
)
(script dormant section2_encounter_cleanup
	(wake section2_post_bridge1_cleanup)
	(wake section2_post_bridge2_cleanup)
)
(script dormant section2_post_bridge1_cleanup
	(sleep_until (volume_test_players tv_e33_c_trigger) 1)
	(ai_erase gr_e30_a)
	(ai_erase gr_e31_a)
	(ai_erase gr_e23_b)
	(ai_erase gr_e22_a)
	(ai_erase gr_e23_a)
	(ai_erase gr_e21_b)
	(ai_erase gr_e21_a)
	(ai_erase gr_e20_a)

	(garbage_collect_now)
)
(script dormant section2_post_bridge2_cleanup
	(sleep_until (volume_test_players tv_e41_c_trigger) 1)
	(ai_erase gr_e33_a)
	(ai_erase gr_e33_b)
	(ai_erase gr_e33_c)
	(ai_erase gr_e33_d)

	(garbage_collect_now)
)
(script dormant section2_cleanup
	(sleep_until (volume_test_players tv_e46_a_trigger) 1)
	(object_destroy_folder arena_f_bipeds)
	(object_destroy_folder arena_f_objects)
	(object_destroy_folder arena_f_weapons)
	(object_destroy_folder arena_e_bipeds)
	(object_destroy_folder arena_e_equipment)
	(object_destroy_folder arena_d_bipeds)
	(object_destroy_folder twin_bridges_vehicles)

	(garbage_collect_now)
)

(script dormant e20_a
	(sleep_until (volume_test_players tv_e20_a_trigger) 1)
	(device_set_position_immediate dm_door_c1 0)
	(device_set_power dm_door_c1 0)
	(volume_teleport_players_not_inside tv_e20_a_trigger fl_coop_exit_zig)
	(print_if b_debug "e20_a active")
	(ai_erase gr_section_1)
	(ai_place gr_e20_a)

	(sleep_until (volume_test_players tv_save_checkpoint8) 1)
	(game_save_no_timeout)
)

(script command_script cs_e20_elite_shoot
	(cs_shoot true bi_e20_vignette)
	(sleep_until (volume_test_players tv_e20_a_trigger2) 1)
	(cs_pause 2.5)
	(cs_action_at_player ai_action_berserk)
)

(script dormant e21_a
	(sleep_until (volume_test_players tv_e21_a_trigger) 1)
	(print_if b_debug "e21_a active")
	(ai_place gr_e21_a)
	(set s_music_trigger 80)
)

(script command_script cs_e21_infection
	(cs_abort_on_damage true)
	(cs_go_to ps_e21_infection/p0 0.1)
	(cs_go_to ps_e21_infection/p1 0.1)
)

(script dormant e21_b
	(sleep_until (volume_test_players tv_e21_b_trigger) 1)
	(print_if b_debug "e21_b active")
	(ai_place gr_e21_b)
)

(script dormant e22_a
	(sleep_until (volume_test_players tv_e22_a_trigger) 1)
	(print_if b_debug "e22_a active")
	(ai_place gr_e22_a)
	(ai_place gr_e22_b)
	(ai_place gr_e23_a)
	(sleep 1)

	(sleep_until (volume_test_players tv_save_checkpoint9) 1)
	(game_save_no_timeout)
)

(script dormant e23_b
	(sleep_until (volume_test_players tv_e23_b_trigger) 1)
	(ai_place gr_e23_b)
	(print_if b_debug "flood tanks!")
)

(script dormant e23_c
	(sleep_until (volume_test_players tv_e23_c_trigger) 1)
	(ai_place gr_e23_c)
	(print_if b_debug "last flood")
)

(script dormant e20_e23_cleanup
	(sleep_until (volume_test_players tv_e23_cleanup_trigger) 1)
	(ai_erase gr_e20_to_e23_arena_f)
	(set s_music_trigger 100)
)

(script dormant e30_a
	(sleep_until (volume_test_players tv_e30_a_trigger) 1)
	(sleep 1)
	(print_if b_debug "e30_a active")
	(ai_place gr_e30_a)
	(ai_place gr_e31_a)
	(device_set_power dm_door_b2 0)
	(device_set_power dm_door_b3 0)
	(sleep 60)
	(ai_erase gr_e8_a)
	(ai_erase gr_e7_a)
	(ai_erase gr_e6_a)
	(wake e30_music_trigger)

	(sleep_until (volume_test_players tv_save_checkpoint20) 1)
	(game_save_no_timeout)
)

(script dormant e31_b_flood
	(ai_place gr_e31_b)
	(ai_place gr_e31_c)
	(ai_place gr_e31_d)
)

(script dormant e33_a
	(sleep_until (volume_test_players tv_e33_a_trigger) 1)
	(print_if b_debug "e33_a active")
	(ai_place gr_e33_a)
	(wake dialog_flood_ambush)
	(wake flood_drop_vignette)

	(sleep_until (volume_test_players tv_save_checkpoint21) 1)
	(game_save_no_timeout)
)

(script dormant flood_drop_vignette
	(sleep_until (volume_test_players tv_e33_b_trigger) 1)
	(player_effect_set_max_translation .06 .02 .12)
    (player_effect_set_max_rotation 2 5 5)
    (player_effect_start 1 0)
	(effect_new "fx/vignettes/c45/flood_drop_glass" fl_arena_e_flood_drop)
	(damage_new "objects/weapons/grenade/frag_grenade/damage_effects/frag_grenade_explosion" fl_arena_e_flood_drop)
	(sound_impulse_start sound/vignettes/c45/vignette_c45_glass_ceiling_explode_01-sound none 1) ;play the sfx for the glass ceiling in the room exploding, dropping down flood
    (player_effect_stop 1)
	(cs_run_command_script gr_e33_a_vignette cs_flood_ceiling_drop)
	(ai_braindead gr_e33_a_vignette false)
)

(script command_script cs_flood_ceiling_drop
	(cs_move_towards_point ps_e33_flood_drop_vignette/p0 .5)
)

(script dormant e33_b
	(sleep_until (volume_test_players tv_e33_b_trigger) 1)
	(print_if b_debug "e33_b")
	(ai_place gr_e33_b)
	; (sleep 5)

	(sleep_until (volume_test_players tv_save_checkpoint22) 1)
	(game_save_no_timeout)
)

(script dormant e33_c
	(sleep_until (volume_test_players tv_e33_c_trigger) 1)
	(print_if b_debug "e33_c active")
	(ai_place gr_e33_c)
)

(script dormant e33_d
	(sleep_until (volume_test_players tv_e33_d_trigger) 1)
	(print_if b_debug "e33_d active")
	(ai_place gr_e33_d)
)

(script dormant e33_z
	(sleep_until (volume_test_players tv_e33_z_trigger) 1)
	(print_if b_debug "e33_z active")
	(ai_place gr_e33_z)
)

(script dormant e40_a
	(sleep_until (volume_test_players tv_e40_a_trigger) 1)
	(print_if b_debug "e40_a active")
	(wake e40_music_trigger)
	(device_set_power dm_door_b2 1)
	(device_set_power dm_door_b3 1)
	(ai_place sq_e40_a_pa)
	(ai_place sq_e40_a_elites)
	(if
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
			(game_is_cooperative)
		)
		(ai_place sq_e40_a_pb)
	)
	(sleep 1)
	(object_create v_e40_a_ban_1)
	(if
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
			(game_is_cooperative)
		)
		(object_create v_e40_a_ban_2)
	)
	(sleep 1)
	(vehicle_load_magic v_e40_a_ban_1 "banshee_d" (ai_actors sq_e40_a_pa))
	(if
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
			(game_is_cooperative)
		)
		(vehicle_load_magic v_e40_a_ban_2 "banshee_d" (ai_actors sq_e40_a_pb))
	)
	(ai_place gr_e41_a)
	(sleep 2)
	(sleep_until (volume_test_players tv_e41_jump_1_trigger) 1)
	(ai_place gr_e41_b)
	(sleep_until (volume_test_players tv_e41_c_trigger) 1)
	(ai_place gr_e41_c)
	(wake e41_music_trigger)
)

(script dormant checkpoint_before_flood_vignette
	(sleep_until (volume_test_players tv_save_checkpoint23) 1)
	(game_save_no_timeout)
)

(script dormant e43_a
	(sleep_until (volume_test_players tv_e43_a_trigger) 1)
	(if (< s_music_trigger 140) (set s_music_trigger 140))
	(print_if b_debug "e43_a active")
	(ai_erase gr_e30_to_e33_section_2)
	(wake infect_eating)
	(wake arena_d_lightbridge_monitor)
)

(script dormant e43_b
	(sleep_until (volume_test_players tv_e43_b_trigger) 1)
	(print_if b_debug "e43_b active")
	(effect_new objects\levels\shared\fx\stub_effect\stub_effect fl_glass_b_flag)
	(sleep 2)
	(ai_place gr_e43_b)
	; (sleep 2)

	(sleep_until (volume_test_players tv_save_checkpoint24) 1)
	(game_save_no_timeout)
)

(script dormant e43_c
	(sleep_until (volume_test_players tv_e43_c_trigger) 1)
	(print_if b_debug "e43_c_triggered")
	(ai_place gr_e43_c)
)

(script dormant e43_d
	(sleep_until (volume_test_players tv_e43_d_trigger) 1)
	(print_if b_debug "e43_d_triggered")
	(set s_music_trigger 150)
	(ai_erase gr_e40_to_e43_c_section_2)
	(ai_place gr_e43_d)
)

(script command_script cs_infect_swarm
	(cs_swarm_to ps_infector_swarm/p1 0.1)
	(ai_braindead sq_e43_a_sb0 true)
)

(script dormant infect_eating

	(sleep_until (volume_test_players tv_e43_a_vignette_trigger) 1)
	(ai_place gr_e43_a)
	(sleep_until (volume_test_players tv_e43_a_player_too_close) 1)
	(ai_braindead sq_e43_a_sb0 false)
	(f_ai_magically_see_players sq_e43_a_sb0)
)


(script dormant e44_a
	(wake e44a_pre_checkpoint)
	(sleep_until (volume_test_players tv_e44_a_trigger) 1)
	(print_if b_debug "e44_a active")
	(ai_place gr_e44_a)
	; (sleep 1)

	(sleep_until (volume_test_players tv_save_checkpoint25) 1)
	(game_save_no_timeout)
)

(script dormant e44a_pre_checkpoint
	(sleep_until (volume_test_players tv_save_checkpoint_24b) 1)
	(game_save_no_timeout)
)

(script command_script cs_e44_jump_down_vignette
	(cs_move_in_direction 90 1 0)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(sleep 150)
)

(script command_script cs_e48_grunt_grenade
	(cs_abort_on_damage true)
	;(sleep (game_ticks_from_seconds 5))
	(sleep_until
		(begin
			(cs_go_to_and_face  ps_e48_grenade_vignette/p0 ps_e48_grenade_vignette/p3)
			(cs_grenade ps_e48_grenade_vignette/p3 1)
			(sleep 1)
			(not (volume_test_players tv_e48_grenade_vignette_trigger))
		) 180)
)

(script dormant e48_grenade_vignette
	(sleep_until (volume_test_players tv_e48_grenade_vignette_trigger) 1)
	(ai_place sq_grunt_vig_grenade)
	(sleep 1)
)

(script dormant section3
	(sleep_until (volume_test_players tv_e46_a_trigger) 1)
	(print_if b_debug "section 3")

	; unlock progress data
	(submit_incident "ins_c45_section3")
	(submit_incident "unlock_c45")
	(submit_incident_with_custom_string_id "game_activity_begin" "c40")
	(wake section3_place)
	(wake section3_cleanup)
	(wake section3_encounter_cleanup)
	(wake section3_outdoors_navpoint_loop)
	(wake e46_a)
	(wake e46_vo)
	(wake e48_grenade_vignette)
	(wake e48_a_sniper)
	(wake e50_a)
	(wake e51_a)
	(wake e52_a)
	(wake e52_c)
	(wake e53_a)
	(wake extra_room)
)

(script dormant section3_place
	(wake place_snowfield_g)
	(wake place_snowfield_e)
	(wake place_spiral)
	(wake place_tarmac_and_generator_b)
)
(script dormant place_snowfield_g
	(sleep_until (volume_test_players tv_e46_a_trigger) 1)
	(object_create_folder snowfield_g_vehicles)
	(object_create_folder snowfield_g_bipeds)
	(object_create_folder snowfield_g_weapons)
	(object_create_folder snowfield_g_equipment)
	(object_create_folder snowfield_g_objects)
	(object_create bw_skull_blackeye)
)
(script dormant place_spiral
	(sleep_until (volume_test_players tv_shine_tower_player_approaching_gate) 1)
	(object_create_folder spiral_objects)
	(object_create_folder spiral_bipeds)
	(object_create_folder spiral_weapons)
	(object_create_folder spiral_equipment)
)
(script dormant place_snowfield_e
	(sleep_until (volume_test_players tv_e50_a_trigger) 1)
	(object_create_folder snowfield_e_equipment)
	(object_create_folder snowfield_e_bipeds)
	(object_create_folder snowfield_e_objects)
	(object_create_folder snowfield_e_vehicles)
)
(script dormant place_tarmac_and_generator_b
	(sleep_until (volume_test_players tv_e51_a_trigger) 1)
	(object_create_folder tarmac_vehicles)
)
(script dormant section3_encounter_cleanup
	(wake section3_snowfield_g_cleanup)
	(wake section3_spiral_cleanup)
)
(script dormant section3_snowfield_g_cleanup
	(sleep_until (volume_test_players tv_e50_a_trigger) 1)
	(ai_erase gr_e46_a)
	(ai_erase gr_e46_b)
	(ai_erase gr_e46_c)

	(garbage_collect_now)
)
(script dormant section3_spiral_cleanup
	(sleep_until (volume_test_players tv_plat2_ban_clean) 1)
	(sleep_forever endless_flood_spawn_in_spiral_pit)
	(ai_erase gr_e48_section_3)

	(garbage_collect_now)
)
(script dormant section3_cleanup
	(sleep_until (volume_test_players tv_nav_blast_door) 1)
	(object_destroy_folder snowfield_g_vehicles)
	(object_destroy_folder snowfield_g_bipeds)
	(object_destroy_folder snowfield_g_weapons)
	(object_destroy_folder snowfield_g_equipment)

	(object_destroy_folder spiral_objects)
	(object_destroy_folder spiral_bipeds)
	(object_destroy_folder spiral_weapons)
	(object_destroy_folder spiral_equipment)

	(object_destroy_folder tarmac_vehicles)

	(garbage_collect_now)
)

(script dormant e46_a
	(sleep_until (volume_test_players tv_e46_a_trigger) 1)
	(print_if b_debug "e46_canyonb active")

	(ai_place gr_e46_a)
	(ai_place gr_e46_b)

	(sleep 1)

	(ai_erase gr_e43_c)
	(ai_erase gr_e43_b)
	(ai_erase gr_e43_a)
	(ai_erase gr_e40_a)
	(ai_erase gr_e41_a)
	(ai_erase gr_e41_b)
	(ai_erase gr_e41_c)
	(ai_erase gr_e33_arena_e)
	(ai_erase gr_e31_d)
	(ai_erase gr_e31_c)
	(ai_erase gr_e31_b)
	(ai_erase gr_e30_a)
	(ai_erase gr_e31_a)
	(ai_erase gr_e23_b)
	(ai_erase gr_e22_a)
	(ai_erase gr_e23_a)
	(ai_erase gr_e21_b)
	(ai_erase gr_e21_a)
	(ai_erase gr_e20_a)

	(sleep_until (volume_test_players tv_save_checkpoint26) 1)
	(game_save_no_timeout)
)

(script dormant e46_vo
	(sleep_until (volume_test_players tv_e46_speech_trigger) 1)
	(print_if b_debug "speaking!")
	(set s_music_trigger 160)
	(wake dialog_gen2_marked)
	(wake objective_3)
	(ai_place gr_e46_c)
)

(script dormant objective_3
	(sleep s_hud_delay_for_audio)
	(f_hud_obj_new obj_c40_1 obj_c40_1)
)

(script dormant e48_a_sniper
	; initial sniper enemies will turn the corner here
	(sleep_until (volume_test_players tv_shine_tower_player_approaching_gate) 1)
	(ai_place gr_e48_a_sniper_shine_entrance)

	; the rest of the encounter can wait until the player is much closer
	(sleep_until (volume_test_players tv_e48_a_s_trigger) 1)
	(print_if b_debug "e48_a_s active")
	(sleep 1)
	(ai_erase gr_e43_d_to_e44_a_section_2)

	; place enemies around the edge of the spiral
	(ai_place gr_e48_a_sniper)

	; place objects/enemies for fight in the center of the spiral, with flood wave manager
	(object_create v_e48_warthog)
	(ai_place gr_e48_a)
	(wake endless_flood_spawn_in_spiral_pit)

	; put team preferences on the snipers and guards so they shoot chief instead of the flood, start own lod maanager and queue up completion checkpoint
	(ai_prefer_target_team gr_e48_a_sniper player)
	(wake lod_manager_gr_e48_section_3)
	(sleep_until (volume_test_players tv_save_checkpoint27) 1)
	(game_save_no_timeout)
)

(script dormant endless_flood_spawn_in_spiral_pit
	(sleep_until
		(begin
			(sleep_until (<= (ai_nonswarm_count sq_e48_a_flood) 1) 1) 	; wait until the squad is nearly exhausted
			(if (not (volume_test_players tv_e48_a_trigger)) 			; and if the can't see the spawner...
				(begin
					; place 4 flood with a random interval between each so they don't look predictable
					(sleep (game_ticks_from_seconds (real_random_range 3 8)))	; wait a random long delay so it isn't tied to the death as closely
					(ai_place sq_e48_a_flood 1)
					(sleep (game_ticks_from_seconds (real_random_range 2.5 6)))	; wait a random medium delay, so they aren't too close
					(ai_place sq_e48_a_flood 1)
				)
			)
			(or (volume_test_players tv_save_checkpoint27) (< (ai_strength gr_e48_a_sniper) .4))	; stop spawning the flood after the player does enough damage to the encounter
		)
		1
	)
)

(script dormant e50_a
	(sleep_until (volume_test_players tv_e50_a_trigger) 1)
	(print_if b_debug "e50_a active- bottom base")

	(device_set_power dc_tun_garage_1_con_a 0)
	(if (> (game_coop_player_count) 2) (object_create v_e50_a_ban_3))
	(if (> (game_coop_player_count) 3) (object_create v_e50_a_ban_4))

	(object_create v_e50_b_ban_2)
	(ai_place sq_e50_b_empb)
	(ai_place gr_e50_a)

	(ai_magically_see sq_e50_a_wraith_pilot sq_e50_a_flo_tank)

	(if
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
			(game_is_cooperative)
		)
		(begin
			(ai_place sq_e50_b_empc)
			(object_create v_e50_b_ban_3)
		)
	)

	(wake e50_banshee_spawner)
	(wake speech_check)
	(sleep 1)
	(wake banshee_save2)
	(sleep 1)
	(wake banshee_music)
	(sleep 1)
)
(script command_script cs_sq_e50_b_empb
	(cs_go_to_vehicle v_e50_b_ban_2)
)

(script command_script cs_sq_e50_b_empc
	(cs_go_to_vehicle v_e50_b_ban_3)
)


(script dormant e50_banshee_spawner
	(sleep_until
		(begin
			(if (not b_e50_banshee_spawner_end) ;while
				(begin
					(if (<= (unit_get_health v_e50_a_ban_1) 0)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_e50_a_ban_1 40)) 1)
							(object_destroy v_e50_a_ban_1)
							(object_create v_e50_a_ban_1)
						)
					)
					(if (and
							(> (game_coop_player_count) 1) ; if 2 players
							(<= (unit_get_health v_e50_a_ban_2) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_e50_a_ban_2 40)) 1)
							(object_destroy v_e50_a_ban_2)
							(object_create v_e50_a_ban_2)
						)
					)
					(if (and
							(> (game_coop_player_count) 2) ; if 3 players
							(<= (unit_get_health v_e50_a_ban_3) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_e50_a_ban_3 40)) 1)
							(object_destroy v_e50_a_ban_3)
							(object_create v_e50_a_ban_3)
						)
					)
					(if (and
							(> (game_coop_player_count) 3) ; if 4 players
							(<= (unit_get_health v_e50_a_ban_4) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_e50_a_ban_4 40)) 1)
							(object_destroy v_e50_a_ban_4)
							(object_create v_e50_a_ban_4)
						)
					)
					(sleep 30)
				)
			)
			b_e50_banshee_spawner_end
		)
		1
	)
)

(global boolean b_speech_check_complete false)

(global boolean b_play_speech true)

(script dormant speech_check
	(sleep_until
		(begin
			(sleep 60)
			(if
				(and
					(volume_test_players tv_speech_210_trigger)
					b_play_speech
				)
				(begin
					(set b_play_speech false)
				)
			)
			b_speech_check_complete
		)
 		1
	)
)

; change this script to look for all banshees the player enters!
(script dormant banshee_save2
	(sleep_until
		(or
			(vehicle_test_seat_unit_list v_e50_a_ban_1 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_e50_a_ban_2 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_e50_a_ban_3 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_e50_a_ban_4 "banshee_d" (players))
		)
 		1
	)
	(game_save_no_timeout)
	(f_unblip_flag fl_waypoint_conduit_2_ban)
)

; change this script to look for all banshees the player enters!
(script dormant banshee_music
	(sleep_until
		(or
			(vehicle_test_seat_unit_list v_e50_a_ban_1 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_e50_a_ban_2 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_e50_a_ban_3 "banshee_d" (players))
			(vehicle_test_seat_unit_list v_e50_a_ban_4 "banshee_d" (players))
		)
 		1
	)
	(set s_music_trigger 170)
)

(script dormant e51_a
	(sleep_until (volume_test_players tv_e51_a_trigger) 1)
	(ai_place gr_e51_a)
	(ai_place gr_e51_b)

	(sleep_until (volume_test_players tv_save_checkpoint29) 1)
	(game_save_no_timeout)
)

; split out into own script so insertion point 4 can have these
(script static void e51_a_place_top_of_tarmac_squads_and_vehicles
	(object_create_folder tarmac_vehicles)
	(ai_place gr_e51_a)
	(ai_place gr_e51_b)

	(cs_run_command_script sq_e51_b_empa cs_sq_e51_b_empa)
)

(script command_script cs_sq_e51_b_empa
	(cs_go_to_vehicle v_e51_ban_1)
)

(script command_script cs_sq_e51_b_empb
	(cs_go_to_vehicle v_e51_ban_2)
)

(script command_script cs_e50_a_gmna
	(cs_go_to_vehicle v_e50_a_tur_1)
)

(script dormant e52_a
	(sleep_until (volume_test_players tv_e52_a_trigger) 1)
	(wake pulse_gen2_approach)
	(print_if b_debug "e52_a active")
	(ai_erase gr_e48_section_3)
	(ai_place gr_e52_a)
	(sleep 1)
	(ai_place gr_e52_b)
	(sleep 2)
	(wake force_save_3)
)

(script dormant pulse_gen2_approach
	(sleep_until (volume_test_players tv_pulse_gen2_approach) 1)
	(wake dialog_gen2_approach)
	(wake dialog_gen2_in_room_dally)
	(wake dialog_gen2_leave_before_disabled)
)

(script dormant force_save_3 (sleep_until (= (ai_nonswarm_count gr_e52_a) 0) 1) (game_save_no_timeout))

(script dormant e52_c
	;(sleep_until (volume_test_players tv_e52_c_trigger) 1)
	(print_if b_debug "infection forms no longer spawn in conduit_b room")
	;(ai_place gr_e52_c)
)
(script dormant sc_pulse_2_conduit_a_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_2_conduit_a) 0) 1)
	(pe_camera_shake_small)

)

(script dormant sc_pulse_2_conduit_b_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_2_conduit_b) 0) 1)
	(pe_camera_shake_small)
)

(script dormant sc_pulse_2_conduit_c_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_2_conduit_c) 0) 1)
	(pe_camera_shake_small)
)

(script dormant e53_a
	; as long as the player is coming before insertion point 4, spawn conduit 2
	(if (f_insertion_point_area_pending ins_section3)
		(begin
			(wake e53_a_conduits)
		)
	)

	(sleep_until b_pulse_gen2_downed 1)

	(set b_speech_check_complete true)
	(wake e5_a_post_conduit)
	(wake e53_a_chasm_door)
)

(script dormant e53_a_conduits
	(sleep_until (volume_test_players tv_e52_a_trigger) 1)
	(object_create_folder generator_b_conduits)
	(wake sc_pulse_2_conduit_a_camera_shake)
	(wake sc_pulse_2_conduit_b_camera_shake)
	(wake sc_pulse_2_conduit_c_camera_shake)

	(sleep_until
			(and
				(<= (object_get_health sc_pulse_2_conduit_a) 0)
				(<= (object_get_health sc_pulse_2_conduit_b) 0)
				(<= (object_get_health sc_pulse_2_conduit_c) 0)
			)
		1
	)
	(f_hud_obj_new_no_hud_completion obj_c40_3 obj_c40_3)
	(f_hud_obj_complete)

	(set b_pulse_gen2_downed 1)
	; we need 1 frame to send our 0.75 damage value to ue
	(sleep 1)
	; setting beam damage state to dead for reloads
	; this will be the 4th time we increment value, settings it to 1
	(set conduit_beam02_damage (+ conduit_beam02_damage 0.25))
	(device_set_position_immediate dm_conduit_room_2a conduit_beam02_damage)

	(game_save_no_timeout)

	; flood reinforcements in the hallway after the conduits
	; not really co-op safe unless we lock the players in the room until this point.
	(ai_place gr_e53_a)

	(sleep_until (= (ai_nonswarm_count gr_e53_a) 0) 1)
	(game_save_no_timeout)
)

(script dormant e5_a_post_conduit
	(wake c40_230_240_250)
	(plat2_ban)
	(sleep 60)
	(wake dialog_gen2_disabled)
	(f_blip_one fl_waypoint_conduit_2p5)
	(wake gen2_nav_leave)

	(sleep_until (volume_test_players tv_save_checkpoint30) 1)
	(game_save_no_timeout)
	(wake dialog_gen2_leaving)
)

(script dormant e53_a_chasm_door
	; enable power to chasm door control
	(device_set_power dc_tun_garage_1_con_a 1)

	;entrance to chasm
	(sleep_until (> (device_group_get dg_tun_garage_1_pos) 0) 1)
	(wake explode_banshee_blocker_door_to_chasm)
	(f_unblip_all)

	; exit from chasm
	(sleep_until (> (device_group_get dg_tun_garage_2_pos) 0) 1)
	(device_group_set dm_chasm_2 dg_tun_garage_2_pos 1)
	(f_unblip_all)
)

(script dormant explode_banshee_blocker_door_to_chasm
	; .5 gets the animation to the point where the player can walk through the center, but not take the banshee
	(device_set_position dm_chasm_1 .5)

	; slight pause so door starts to move before explosion
	(sleep (game_ticks_from_seconds .66))

	; the controls fail!
	;(static electrical shocks appear on the control panel)
	(device_set_position_immediate dm_failed_control_panel_static 0.5) ; send the signal to bp to play the broken sparks
	(sleep (game_ticks_from_seconds 2.0))
	(device_set_position_immediate dm_failed_control_panel_static 1.0) ; set bp to completed state

	; start the chasm music after a pause to give the explosion audio time to breath
	(sleep (game_ticks_from_seconds 1))
	(set s_music_trigger 180)
)

(script dormant gen2_nav_leave
	(sleep_until (volume_test_players tv_gen2_nav_leave_trigger) 1)
	(f_unblip_all)
)

(script dormant pg2_generator_blips
	(wake pg2_generator_blips_conduit_a)
	(wake pg2_generator_blips_conduit_b)
	(wake pg2_generator_blips_conduit_c)
)

(global real conduit_beam02_damage 0.0)
(script dormant (pg2_generator_blips_conduit_a)
	(if (>= (object_get_health sc_pulse_2_conduit_a) 1)
		(f_blip_flag fl_waypoint_conduit_2c1 1)
	)

	(sleep_until (= (object_get_health sc_pulse_2_conduit_a) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_2c1)
	(set conduit_beam02_damage (+ conduit_beam02_damage 0.25))
	(device_set_position_immediate dm_conduit_room_2a conduit_beam02_damage)
)

(script dormant (pg2_generator_blips_conduit_b)
	(if (>= (object_get_health sc_pulse_2_conduit_b) 1)
		(f_blip_flag fl_waypoint_conduit_2c2 1)
	)

	(sleep_until (= (object_get_health sc_pulse_2_conduit_b) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_2c2)
	(set conduit_beam02_damage (+ conduit_beam02_damage 0.25))
	(device_set_position_immediate dm_conduit_room_2a conduit_beam02_damage)
)

(script dormant (pg2_generator_blips_conduit_c)
	(if (>= (object_get_health sc_pulse_2_conduit_c) 1)
		(f_blip_flag fl_waypoint_conduit_2c3 1)
	)

	(sleep_until (= (object_get_health sc_pulse_2_conduit_c) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_2c3)
	(set conduit_beam02_damage (+ conduit_beam02_damage 0.25))
	(device_set_position_immediate dm_conduit_room_2a conduit_beam02_damage)
)

(script static void plat2_ban
	(f_clean_banshees tv_plat2_ban_clean)

	(object_create v_ban_plat2_a)
	(if (> (game_coop_player_count) 1) (object_create v_ban_plat2_b))
	(if (> (game_coop_player_count) 2) (object_create v_ban_plat2_c))
	(if (> (game_coop_player_count) 3) (object_create v_ban_plat2_d))
)

; for extra rooms skull challenge opposite from the 2nd generator in snowfield, above the tarmac

(script dormant extra_room
	; the extra room is intentionally disabled from insertion 4 because
	; it is too close to the insertion point and feels anti-climatic
	(if (f_insertion_point_area_pending ins_section3)
		(begin
			; create the switch and power it on
			(object_create dc_extra_room_control)
			(device_set_power dc_extra_room_control 1)

			; wait until player finds and presses the switch...
			(sleep_until (= (device_get_position dc_extra_room_control) 1) 1)

			; power on the door and cleanup the switch
			(device_set_power dc_extra_room_control 0) ; remove the prompt
			(device_set_power dm_door_gen4 1)

			; activate extra room entrance/exit handling and the first encounter
			(wake extra_room_entrance_monitor_thread)
			(wake e_extra_room_arena)

			; activate extra room music handlers
			(wake extra_room_music_manager)
			(wake extra_room_backtrack_music_manager)
			(wake extra_room_banshee_music_manager)
		)
	)
)

(global boolean b_extra_room_arena_finished false)
(global boolean b_extra_room_hallway_finished false)
(global boolean b_extra_room_generator_finished false)
(global boolean extra_room_completed false)

; because the extra room is a cul-de-sac, this script flips between handling entrance and exit until the room is completed
(script dormant extra_room_entrance_monitor_thread
	(sleep_until
		(begin
			(if (not extra_room_completed) ; while the room is not completed (and therefore has enemies)
				(begin
					(sleep_until (volume_test_players tv_extra_room_1_entrance) 1) 	; wait for player entrance, then handle it
					(extra_room_handle_entrance)

					(sleep_until (volume_test_players tv_extra_room_1_exit) 1) 		; players are now inside extra room, so wait for exit
					(extra_room_handle_exit)
				)
			)
			extra_room_completed	; extra room script marks completed, at which point no more enemies will spawn and entrance/exit handling stops
		)
		1
	)
)

(script static void extra_room_handle_entrance
	; teleport all players not already in the past the one-way door for co-op
	(volume_teleport_players_not_inside tv_extra_room_co_op_no_teleport_volume fl_extra_room_enter_teleport_location)
	(sleep 1)

	; cleanup banshees and spawn new ones on platform so everyone can get down
	(extra_plat_ban)

	; all ai now prefer players for targeting so the mixed squads in the challenge room work together against the player
	(ai_prefer_target (players) true)

	; erase the sprial squads if they are still there, and clear lod settings for anyone in the extra room in case this is a re-entry
	(ai_erase gr_e48_section_3)
	(ai_clear_lod gr_e_extra)
)

(script static void extra_room_handle_exit
	; co-op teleport all players not already in the exit hallway to the hallway
	(volume_teleport_players_not_inside tv_extra_room_co_op_no_teleport_volume fl_extra_room_exit_teleport_location)
	(sleep 1)

	; remove ai player targeting preference for normal mission behavior
	(ai_prefer_target (players) false)

	; force extra room squads to low lod
	(ai_force_low_lod gr_e_extra)

	; checkpoint
	(game_save_no_timeout)
)

; the first of the three extra room encounters, the arena
(script dormant e_extra_room_arena
	; wait for player to enter extra room, then start the challenge
	(sleep_until (volume_test_players tv_extra_room_1_entrance) 1)
	(ai_place gr_e_extra_a)

	; after the room clear...
	(sleep_until (= (ai_nonswarm_count gr_e_extra_a) 0))
	(set s_music_trigger 250)
	(set b_extra_room_arena_finished true)

	;create the switch for the next room
	(object_create dc_extra_room_arena_to_hallway_control)

	; start the next room script, which depends on the switch we just created
	(wake e_extra_room_hallway)

	; checkpoint
	(game_save_no_timeout)
)

; the second of the three extra room encounters, the hallway

(script dormant e_extra_room_hallway
	; when the player presses the switch, spawn the enemies, open the door, and cleanup the switch
	(sleep_until (= (device_get_position dc_extra_room_arena_to_hallway_control) 1) 1)
	(device_set_power dc_extra_room_arena_to_hallway_control 0) ; remove the prompt
	(ai_place gr_e_extra_b)
	(device_set_power dm_unnamed_37 1)

	; wait for the player to start the hallway by opening the door
	(sleep_until (>= (device_get_position dm_unnamed_37) .9) 1)

	; wait for the room clear...
	(sleep_until (= (ai_nonswarm_count gr_e_extra_b) 0))
	(set s_music_trigger 270)
	(set b_extra_room_hallway_finished true)

	;create the switch for the next room
	(object_create dc_extra_room_hallway_to_generator_control)

	; start the next room script, which depends on the switch we just created
	(wake e_extra_room_generator)

	; checkpoint
	(game_save_no_timeout)
)

; the third of the three extra room encounters, the generator room
(script dormant e_extra_room_generator
	; when the player presses the switch, open the door, cleanup the switch, and spawn the enemies
	(sleep_until (= (device_get_position dc_extra_room_hallway_to_generator_control) 1) 1)
	(device_set_power dc_extra_room_hallway_to_generator_control 0) ; remove the prompt
	(ai_place gr_e_extra_c)
	(device_set_power dm_unnamed_38 1)

	; wait for the player to start the generator by opening the door
	(sleep_until (> (device_get_position dm_unnamed_38) 0) 1)

	; wait for the room clear...
	(sleep_until (= (ai_nonswarm_count gr_e_extra_c) 0))
	(set s_music_trigger 290)
	(set b_extra_room_generator_finished true)

	; this will be used to stop the entrance/exit optimizations, since enemies are all dead now
	(set extra_room_completed true)

	;create skull and start the skull grant script
	(object_create bw_skull_mythic)

	; checkpoint
	(game_save_no_timeout)
)

(script static void extra_plat_ban
	(f_clean_banshees tv_extraplat_ban_clean)

	(object_create v_ban_extraplat_a)
	(if (> (game_coop_player_count) 1) (object_create v_ban_extraplat_b))
	(if (> (game_coop_player_count) 2) (object_create v_ban_extraplat_c))
	(if (> (game_coop_player_count) 3) (object_create v_ban_extraplat_d))
)

(script dormant c40_230_240_250
	(sleep_until (volume_test_players tv_c40_230_240_250_trigger) 1)
	(print_if b_debug "update....")

	(sleep 1)
	(f_hud_chapter chapter_c40_3)
	(sleep (game_ticks_from_seconds 2))
	(f_hud_obj_new "obj_c40_4" "obj_c40_4")
)


(script dormant section4

	(wake section4_navpoint_loop)
	(sleep_until
		(and
			b_pulse_gen2_downed
			(volume_test_players tv_tunnel_trigger)
		)
		1
	)

	; unlock progress data
	(submit_incident "ins_c45_section4")
	(submit_incident "unlock_c45")
	(submit_incident_with_custom_string_id "game_activity_begin" "c40")

	(print_if b_debug "section 4")
	(wake dialog_gen3_canyon)
	(set b_e50_banshee_spawner_end true)
	(wake section4_place)
	(wake section4_cleanup)
	(wake e57_a)
	(wake e59_a)
	(wake e59_b)
	(wake e59_c)
	(wake e59_music_trigger)
	(wake e59_c_ghost)
	(wake e59_e_door_open)
	(wake e60_a)
	(wake e60_d)
	(wake e60_e)
)
(script dormant section4_place
	(wake place_chasm)
	(wake place_snowfield_c)
)
(script dormant section4_cleanup
	(sleep_until (volume_test_players tv_e59_e_door_trigger) 1)
	(object_destroy_folder chasm_objects)
	(object_destroy_folder chasm_equipment)
	(object_destroy_folder chasm_bipeds)
	(object_destroy_folder snowfield_c_objects)
	(object_destroy_folder snowfield_c_vehicles)
)
(script dormant place_chasm
	(sleep_until (volume_test_players tv_nav_blast_door) 1)
	(object_create_folder chasm_objects)
	(object_create_folder chasm_equipment)
	(object_create_folder chasm_bipeds)
)
(script dormant place_snowfield_c
	(sleep_until (volume_test_players tv_e59_e_door_trigger) 1)
	(object_create_folder snowfield_c_objects)
	(object_create_folder snowfield_c_vehicles)
)

(script dormant e57_a
	(sleep_until (volume_test_players tv_tunnel_trigger) 1)
	(print_if b_debug "e57_a active")
	(ai_erase gr_e51_a)
	(ai_place gr_e57_a)
	(sleep 2)
	(ai_place gr_e58_a)
)

(script dormant e59_a
	(sleep_until (volume_test_players tv_e59_a_trigger) 1)
	(ai_erase gr_e50_to_e53_section_3)
	(ai_place gr_e59_a)
	(ai_erase gr_e58_a)
	(object_destroy v_e57_tur_a)
	(object_destroy v_e51_tur_1)
	(object_destroy v_e51_tur_2)
	(object_destroy v_e51_tur_3)
	(object_destroy v_e51_tur_4)
	(object_destroy v_e51_ban_1)
	(object_destroy v_e51_ban_2)
	(object_destroy v_ban_plat2_a)
	(object_destroy v_ban_plat2_b)
	(object_destroy v_ban_plat2_c)
	(object_destroy v_ban_plat2_d)
	(object_destroy v_e50_a_tur_1)
	(object_destroy v_e50_a_ban_1)
	(object_destroy v_e50_a_ban_2)
	(object_destroy v_e50_a_ban_3)
	(object_destroy v_e50_a_ban_4)
	(object_destroy v_e50_b_wra_1)
	(object_destroy v_e50_b_ban_2)
	(object_destroy v_e50_b_ban_3)
	(device_set_power dm_door_gen2 0)

	(sleep_until (volume_test_players tv_save_checkpoint31) 1)
	(game_save_no_timeout)
)

(script dormant e59_b
	(sleep_until (volume_test_players tv_e59_b_trigger) 1)
	(ai_place gr_e59_b)
	(sleep 150)
)

(script dormant e59_c
	(sleep_until (volume_test_players tv_e59_c_trigger) 1)
	(ai_place gr_e59_c)
	(sleep 300)

	(sleep_until (volume_test_players tv_save_checkpoint32) 1)
	(game_save_no_timeout)
	(wake place_g3_vignette)
)

;new boading skill check encounter
(script dormant e59_c_ghost
	(sleep_until (volume_test_players tv_e59_d_trigger) 1)
	(ai_erase gr_e57_to_e58_section_4)
	(ai_place gr_e59_c_ghost)

	(object_create v_largetunnel_ghost1)
	(if (> (game_coop_player_count) 1) (object_create v_largetunnel_ghost2))
	(if (> (game_coop_player_count) 2) (object_create v_largetunnel_ghost3))
	(if (> (game_coop_player_count) 3) (object_create v_largetunnel_ghost4))

)

(script dormant e59_e_door_open
	(sleep_until (volume_test_players tv_e59_e_door_trigger) 1)
	(device_set_power dm_chasm_tunnel 1)
)

(script dormant place_g3_vignette
	(ai_place gr_g3_vignette)
	(sleep_until (or (= (ai_nonswarm_count sq_flood_g3_vignette) 0) (< (ai_nonswarm_count sq_e65_a_s2_vignette) 3)))
	(cs_run_command_script sq_e65_a_s2_vignette/sentinel_0 cs_g3_vignette_sentinels)
	(sleep 120)
	(cs_run_command_script sq_e65_a_s2_vignette/sentinel_1 cs_g3_vignette_sentinels)
	(sleep 120)
	(cs_run_command_script sq_e65_a_s2_vignette/sentinel_2 cs_g3_vignette_sentinels)
	(sleep 120)
	(cs_run_command_script sq_e65_a_s2_vignette2/sentinel_3 cs_g3_vignette_sentinels)
	(sleep 120)
	(cs_run_command_script sq_e65_a_s2_vignette2/sentinel_4 cs_g3_vignette_sentinels)
	(sleep 1200)
	(object_destroy gr_g3_vignette)
)

(script command_script cs_g3_vignette_sentinels
	(print "sentinels cs")
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_fly_to ps_g3_vignette/p8_s_go_to .25)
	(cs_fly_to ps_g3_vignette/p7_s_go_to .25)
	(cs_fly_to ps_g3_vignette/p6_s_go_to .25)
	(cs_fly_to ps_g3_vignette/p5_s_go_to .25)
	(cs_fly_to ps_g3_vignette/p3_s_go_to .25)
	(object_destroy gr_g3_vignette)
	(cs_pause 1)
	(ai_kill ai_current_actor)
)

(script command_script cs_g3_vignette_rocket_flood
	(print "rocket flood cs")
	(cs_move_towards_point ps_g3_vignette/p4_f_go_to 0.5)
	(cs_go_to ps_g3_vignette/p0_f_rocket)
	(cs_shoot true sq_e65_a_s2_vignette)
	(cs_pause 3)
	(cs_shoot true sq_e65_a_s2_vignette)
	(cs_pause 4)
	(cs_shoot true sq_e65_a_s2_vignette)
	(cs_pause 5)
	(cs_shoot false)
	(cs_pause 5)
	(ai_kill ai_current_actor)
	(print "rocket flood dead")
)

(script command_script cs_g3_vignette_shotgun_flood
	(print "shotgun flood cs")
	(cs_move_towards_point ps_g3_vignette/p4_f_go_to 0.5)
	(cs_go_to ps_g3_vignette/p2_f_shotgun)
	(cs_pause 5)
	(cs_shoot false)
	(cs_pause 8)
	(ai_kill ai_current_actor)
	(print "shotgun flood dead")
)

(script command_script cs_g3_vignette_assault_flood
	(print "assault flood cs")
	(cs_move_towards_point ps_g3_vignette/p4_f_go_to 0.5)
	(cs_go_to ps_g3_vignette/p1_f_assault)
	(cs_pause 5)
	(cs_shoot false)
	(cs_pause 10)
	(ai_kill ai_current_actor)
	(print "assault flood dead")
)

(script dormant e60_a
	(sleep_until (volume_test_players tv_e60_a_trigger) 1)
	(print_if b_debug "e60_a active")
	(wake chapter_4_objective_5)
	(ai_erase gr_e59_a_to_e59_c_section_4)
	(ai_place gr_e60_a)
	(ai_place gr_e60_banshee)
	(sleep 1)
	(vehicle_load_magic v_c_banshee_1 "banshee_d" (ai_actors sq_e60_banshee_empa))
	(sleep 5)
	(ai_place gr_e60_c)
	(wake e60_music_trigger)

	(sleep_until (volume_test_players tv_save_checkpoint33) 1)
	(game_save_no_timeout)
)

(script dormant chapter_4_objective_5
	(sleep_until (volume_test_players tv_nav_snowfield_c))
	(set s_music_trigger 200)
	(f_hud_chapter chapter_c40_4)
	(sleep (game_ticks_from_seconds 2.0))
	(f_hud_obj_complete)
	(sleep (game_ticks_from_seconds 10.0))
	(f_hud_obj_new obj_c40_3 obj_c40_3)
)

(script dormant e60_d
	(sleep_until (volume_test_players tv_e60_a_trigger) 1)
	(sleep_until (<= (ai_nonswarm_count gr_e60_c) 5) 1)
	(print_if b_debug "e60_d- here comes the army!")
	(ai_place gr_e60_d)
)

(script dormant e60_e
	(sleep_until (volume_test_players tv_e60_a_trigger) 1)
	(sleep_until (<= (ai_nonswarm_count gr_e60_d) 5) 1)
	(print_if b_debug "e60_e- here comes more!!!")
	(ai_place gr_e60_e)
	(sleep 10)
)

(script dormant section5

	(wake section5_navpoint_loop)
	(wake section5_banshee_navpoint_loop)
	(wake section5_place)
	(wake section5_encounter_cleanup)

	(sleep_until (volume_test_players tv_e61_a_trigger) 1)
	(print_if b_debug "section 5")

	(ai_erase gr_e59_c_ghost)
	(wake e61_a)
	(wake e62_a)
	(wake e62_b)
	(wake e62_c)
	(wake e62_d)
	(wake e62_e)
	(wake e65_a)
	(wake e66_a)
	(wake end)

	(sleep_until b_pulse_gen3_downed 1)
	(sleep_until (script_finished "dialog_gen3_disabled") 1) ; ensures final dialogue finishes before cinematic triggers
	(sleep (game_ticks_from_seconds 2))

	(submit_incident "unlock_d20")
	(submit_incident_with_custom_string_id "game_activity_end_completed" "c40")

	(f_play_cinematic cinematics\c40\c40_outro.cinematic)
	(game_won)
)
(script dormant section5_place
	(wake place_snowfield_b)
	(wake place_snowfield_a)
	(wake place_generator_c)
)
(script dormant section5_encounter_cleanup
	(wake section5_snowfield_c_encounter_cleanup)
)
(script dormant section5_snowfield_c_encounter_cleanup
	(sleep_until (volume_test_players tv_e62_a_trigger) 1)
	(ai_erase gr_e60_e)
	(ai_erase gr_e60_d)
	(ai_erase gr_e60_a)
	(ai_erase gr_e60_c)

	(garbage_collect_now)
)
(script dormant place_snowfield_b
	(sleep_until (volume_test_players tv_e61_a_trigger) 1)
	(object_create_folder snowfield_b_equipment)
	(object_create_folder snowfield_b_bipeds)
)
(script dormant place_snowfield_a
	(sleep_until (volume_test_players tv_e61_a_trigger) 1)
	(object_create_folder snowfield_a_objects)
	(object_create_folder snowfield_a_vehicles)
)
(script dormant place_generator_c
	(object_create_folder generator_c_weapons)
	(object_create_folder generator_c_equipment)
	(object_create_folder generator_c_bipeds)
)
(script dormant e61_a
	(sleep_until (volume_test_players tv_e61_a_trigger) 1)
	(ai_place gr_e61_a)
	(ai_place gr_e61_b)

	(sleep_until (volume_test_players tv_save_checkpoint33a) 1)
	(game_save_no_timeout)
)

(script dormant e62_a
	(sleep_until (volume_test_players tv_e62_a_trigger) 1)
	(if (> (game_coop_player_count) 2) (object_create v_e62_a_ban_3))
	(if (> (game_coop_player_count) 3) (object_create v_e62_a_ban_4))
	(ai_place gr_e62_a)
	(vehicle_load_magic v_e62_a_wra_1 "wraith_d" (ai_actors sq_e62_a_wpa))
	(vehicle_load_magic v_e62_a_wra_2 "wraith_d" (ai_actors sq_e62_a_wpb))
	(sleep 30)
	(wake e62_banshee_spawner)
	(wake banshee_save3)
)

(script dormant e62_banshee_spawner
	(sleep_until
		(begin
			(if (not b_e62_banshee_spawner_end) ;while
				(begin
					(if (<= (unit_get_health v_e62_a_ban_1) 0)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_e62_a_ban_1 40)) 1)
							(object_destroy v_e62_a_ban_1)
							(object_create v_e62_a_ban_1)
						)
					)
					(if (and
							(> (game_coop_player_count) 1) ; if 2 players
							(<= (unit_get_health v_e62_a_ban_2) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_e62_a_ban_2 40)) 1)
							(object_destroy v_e62_a_ban_2)
							(object_create v_e62_a_ban_2)
						)
					)
					(if (and
							(> (game_coop_player_count) 2) ; if 3 players
							(<= (unit_get_health v_e62_a_ban_3) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_e62_a_ban_3 40)) 1)
							(object_destroy v_e62_a_ban_3)
							(object_create v_e62_a_ban_3)
						)
					)
					(if (and
							(> (game_coop_player_count) 3) ; if 4 players
							(<= (unit_get_health v_e62_a_ban_4) 0)
						)
						(begin
							(sleep_until (not (objects_can_see_flag (players) fl_e62_a_ban_4 40)) 1)
							(object_destroy v_e62_a_ban_4)
							(object_create v_e62_a_ban_4)
						)
					)
					(sleep 30)
				)
			)
			b_e62_banshee_spawner_end
		)
		1
	)
)

(script dormant banshee_save3
	(sleep_until (any_players_in_vehicle_type s_vehicle_type_banshee) 1)
	(game_save_no_timeout)
)

(script dormant e62_b
	(sleep_until (volume_test_players tv_e62_b_trigger) 1)
	(print_if b_debug "flood attacking!!!")
	(ai_place gr_e62_b)
)

(script dormant e65_a
	(sleep_until (volume_test_players tv_e65_a_trigger) 1)
	(print_if b_debug "e65_a active")
	(wake e65_a_spawner)
	(sleep 1)
	(wake e65_music_trigger)

	(sleep_until (volume_test_players tv_save_checkpoint34) 1)
	(game_save_no_timeout)
	(wake pulse_gen3_approach)
)

(script dormant pulse_gen3_approach
	(sleep_until (volume_test_players tv_pulse_gen3_approach) 1)
	(wake dialog_gen3_approach)
	(wake dialog_gen3_in_room_dally)
	(wake dialog_gen3_leave_before_disabled)
)

(global boolean b_e65_a_spawner_complete false)

(global short s_e65_a_total 5)

(global short s_e65_a_limiter 0)

(script dormant e65_a_spawner
	(sleep_until
		(begin
			(sleep 30)
			(print_if b_debug "sentinel spawner")
			(if
				(and
					(< (ai_nonswarm_count sq_e65_a_s) 5)
					(< s_e65_a_limiter s_e65_a_total)
				)
				(begin
					(print_if b_debug "+1 sentinel")
					(ai_place sq_e65_a_s 1)
					(sleep 3)
					(set s_e65_a_limiter (+ s_e65_a_limiter 1))
				)
			)
			b_e65_a_spawner_complete
		)
 		1
	)
)

(script dormant e66_a
	(sleep_until (volume_test_players tv_e66_a_trigger) 1)
	(print_if b_debug "e66_a active- need to get big sentinels from jason")
	(wake e66_a_spawner)
	(set b_e65_a_spawner_complete true)
)

(global boolean b_e66_a_spawner_complete false)

; spawner is setup with 3 enemies per spawn, so each wave has 3 sentinels
(global short s_e66_a_wave_total 4)		; after the player kills 12 sentinels, stop spawning more
(global short s_e66_a_wave_counter 0)

(script dormant e66_a_spawner
	(sleep_until
		(begin
			(sleep (game_ticks_from_seconds 1.5))					; buffer between spawns so sentinels can clear vents
			(print_if b_debug "major sentinel spawner")
			(if
				(and
					(< (ai_nonswarm_count sq_e66_a_s) 5)				; keep 4-7 sentinels in the room at all times
					(< s_e66_a_wave_counter s_e66_a_wave_total)
				)
				(begin
					(print_if b_debug "+1 sentinel")
					(ai_place sq_e66_a_s)
					(sleep 3)
					(set s_e66_a_wave_counter (+ s_e66_a_wave_counter 1))
				)
			)
			b_e66_a_spawner_complete
		)
 		1
	)
)

(script dormant e62_c
	(sleep_until (volume_test_players tv_e62_a_trigger) 1)
	(ai_place gr_e62_c)
	(sleep 2)
)

(script dormant e62_d
	(sleep_until (volume_test_players tv_e62_a_trigger) 1)
	(ai_place gr_e62_d)
	(sleep 2)
)

(script dormant e62_e
	(sleep_until (volume_test_players tv_e62_a_trigger) 1)
	(ai_place gr_e62_e)
	(sleep 2)
)

(script dormant sc_pulse_3_conduit_a_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_3_conduit_a) 0) 1)
	(pe_camera_shake_small)
)

(script dormant sc_pulse_3_conduit_b_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_3_conduit_b) 0) 1)
	(pe_camera_shake_small)
)

(script dormant sc_pulse_3_conduit_c_camera_shake
	(sleep_until (<= (object_get_health sc_pulse_3_conduit_c) 0) 1)
	(pe_camera_shake_small)
)

(script dormant end
	(sleep_until (volume_test_players tv_e66_a_trigger) 1)
	(object_create_folder generator_c_conduits)

	(wake sc_pulse_3_conduit_a_camera_shake)
	(wake sc_pulse_3_conduit_b_camera_shake)
	(wake sc_pulse_3_conduit_c_camera_shake)

	(sleep_until
		(and
			(<= (object_get_health sc_pulse_3_conduit_a) 0)
			(<= (object_get_health sc_pulse_3_conduit_b) 0)
			(<= (object_get_health sc_pulse_3_conduit_c) 0)
		)
		1
	)
	(f_hud_obj_new_no_hud_completion "obj_c40_5" "obj_c40_5")
	(f_hud_obj_complete)
	(set b_pulse_gen3_downed true)
	(wake dialog_gen3_disabled)
	(set b_e62_banshee_spawner_end true)
	(set b_general_dawdle_end true)
	; we need 1 frame to send our 0.75 damage value to ue
	(sleep 1)
	; setting beam damage state to dead for reloads
	; this will be the 4th time we increment value, settings it to 1
	(set conduit_beam03_damage (+ conduit_beam03_damage 0.25))
	(device_set_position_immediate dm_conduit_room_3a conduit_beam03_damage)

	(sleep 60)
	(set b_e66_a_spawner_complete true)
	(ai_kill gr_e66_a)
)

(script dormant pg3_generator_blips
	(wake pg3_generator_blips_conduit_a)
	(wake pg3_generator_blips_conduit_b)
	(wake pg3_generator_blips_conduit_c)
)

(global real conduit_beam03_damage 0.0)
(script dormant (pg3_generator_blips_conduit_a)
;;; commented out code condition for if we want to blip the generator when the player looks at it
;;; requires removing the code from waking through cortana's voice lines.
;	(sleep_until 	(and
;						(volume_test_players tv_pulse_3_conduit_a)
;						(objects_can_see_object (players) sc_pulse_3_conduit_a 5)
;					)
;	1)
	(if (>= (object_get_health sc_pulse_3_conduit_a) 1)
		(f_blip_flag fl_waypoint_conduit_3c1 1)
	)

	(sleep_until (= (object_get_health sc_pulse_3_conduit_a) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_3c1)
	(set conduit_beam03_damage (+ conduit_beam03_damage 0.25))
	(device_set_position_immediate dm_conduit_room_3a conduit_beam03_damage)
)

(script dormant (pg3_generator_blips_conduit_b)
;;; commented out code condition for if we want to blip the generator when the player looks at it
;;; requires removing the code from waking through cortana's voice lines.
;	(sleep_until 	(and
;						(volume_test_players tv_pulse_3_conduit_b)
;						(objects_can_see_object (players) sc_pulse_3_conduit_b 5)
;					)
;	1)

	(if (>= (object_get_health sc_pulse_3_conduit_b) 1)
		(f_blip_flag fl_waypoint_conduit_3c2 1)
	)

	(sleep_until (= (object_get_health sc_pulse_3_conduit_b) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_3c2)
	(set conduit_beam03_damage (+ conduit_beam03_damage 0.25))
	(device_set_position_immediate dm_conduit_room_3a conduit_beam03_damage)
)

(script dormant (pg3_generator_blips_conduit_c)
;;; commented out code condition for if we want to blip the generator when the player looks at it
;;; requires removing the code from waking through cortana's voice lines.
;	(sleep_until 	(and
;						(volume_test_players tv_pulse_3_conduit_c)
;						(objects_can_see_object (players) sc_pulse_3_conduit_c 5)
;					)
;	1)

	(if (>= (object_get_health sc_pulse_3_conduit_c) 1)
		(f_blip_flag fl_waypoint_conduit_3c3 1)
	)

	(sleep_until (= (object_get_health sc_pulse_3_conduit_c) 0) 1)
	(f_unblip_flag fl_waypoint_conduit_3c3)
	(set conduit_beam03_damage (+ conduit_beam03_damage 0.25))
	(device_set_position_immediate dm_conduit_room_3a conduit_beam03_damage)
)

(global boolean b_gen1_marked false)

(script static void waypoint_1
	(set b_gen1_marked true)
	(f_blip_one fl_waypoint_conduit_1a)
	(wake player_at_gen1)
)
(script dormant player_at_gen1
	(sleep_until (volume_test_players tv_plat1_ban_clean) 1)
	(set b_gen1_marked false)
)

(script static void (f_unblip_all)
	(f_unblip_flag fl_fly_away_1)
	(f_unblip_flag fl_fly_away_2)
	(f_unblip_flag fl_fly_away_3)
	(f_unblip_flag fl_fly_away_4)
	(f_unblip_flag fl_waypoint_conduit_1a)
	(f_unblip_flag fl_waypoint_conduit_1b)
	(f_unblip_flag fl_waypoint_conduit_1c1)
	(f_unblip_flag fl_waypoint_conduit_1c2)
	(f_unblip_flag fl_waypoint_conduit_1c3)
	(f_unblip_flag fl_waypoint_conduit_1d)
	(f_unblip_flag fl_waypoint3)
	(f_unblip_flag fl_waypoint_conduit_2p1)
	(f_unblip_flag fl_waypoint_conduit_2p2)
	(f_unblip_flag fl_waypoint_conduit_2_ban)
	;(f_unblip_flag fl_waypoint_conduit_2p3)
	;(f_unblip_flag fl_waypoint_conduit_2p4)
	(f_unblip_flag fl_waypoint_conduit_2p5)
	(f_unblip_flag fl_waypoint_conduit_2c1)
	(f_unblip_flag fl_waypoint_conduit_2c2)
	(f_unblip_flag fl_waypoint_conduit_2c3)
	(f_unblip_flag fl_waypoint_conduit_3p1)
	(f_unblip_flag fl_waypoint_conduit_3p2)
	(f_unblip_flag fl_waypoint_conduit_3p3)
	(f_unblip_flag fl_waypoint_conduit_3p4)
	(f_unblip_flag fl_waypoint_conduit_3p5)
	(f_unblip_flag fl_waypoint_conduit_3_ban)
	(f_unblip_flag fl_waypoint_conduit_3p6)
	(f_unblip_flag fl_waypoint_conduit_3p7)
	(f_unblip_flag fl_waypoint_conduit_3p8)
	(f_unblip_flag fl_waypoint_conduit_3c1)
	(f_unblip_flag fl_waypoint_conduit_3c2)
	(f_unblip_flag fl_waypoint_conduit_3c3)
)

 (script static void pe_camera_shake_large
	(player_effect_set_max_translation .06 .02 .12)
    (player_effect_set_max_rotation 2 5 5)
    (player_effect_start 1 0)
    (player_effect_stop 1)
 )

 (script static void pe_camera_shake_small
	(player_effect_set_max_translation .03 .01 .06)
    (player_effect_set_max_rotation 1 3 3)
    (player_effect_start 1 0)
    (player_effect_stop 1)
 )

(global cutscene_flag last_blip_flag fl_waypoint3)
(global cutscene_flag current_blip_flag fl_waypoint3)
(global boolean b_nav_active false)
(global short s_nav_point_delay (game_ticks_from_seconds 1))
(global real s_unblip_distance 1)
(global real s_blip_distance 3)

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

(script static boolean (f_nav_ai_dist_check (cutscene_flag f) (ai encounter_squad )(real d))

	(and
		(<= (ai_nonswarm_count encounter_squad) 0)
		(> (objects_distance_to_flag (players) f) d)
	)
)

(script static boolean (f_nav_tv_distance_check (cutscene_flag f)(trigger_volume tv_nav)(real d))

	(and
		(> (objects_distance_to_flag (players) f) d)
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
(script static boolean (f_nav_ai_tv_bool_dist_check (cutscene_flag f) (ai encounter_squad )(trigger_volume tv_nav)(boolean b_test)(real d))

	(and
		(<= (ai_nonswarm_count encounter_squad) 0)
		(volume_test_players tv_nav)
		(> (objects_distance_to_flag (players) f) d)
		(= b_test true)
	)
)
(script static boolean (f_nav_bool_check (cutscene_flag f)(boolean b_test)(real d))

	(and
		(> (objects_distance_to_flag (players) f) d)
		(= b_test true)
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
(script static boolean (f_navend_volume_check (cutscene_flag f) (trigger_volume tv_nav))
	(and
		(= last_blip_flag f)
		(= b_nav_active true)
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

(script dormant section1_navpoint_loop
	(sleep_until
	(begin
		(section1_nav_control)
		b_pulse_gen1_downed ;exit condition
	)1)
)
(script dormant section2_gen1down_navpoint_loop

	(sleep_until b_pulse_gen1_downed 1)

	(sleep_until
	(begin
		(section2_gen1down_nav_control)
		(volume_test_players tv_e46_a_trigger)
	)1)
)
(script dormant section3_outdoors_navpoint_loop

	(sleep_until
	(begin
		(section3_outdoors_nav_control)
		b_pulse_gen2_downed
	)1)
)
(script dormant section4_navpoint_loop

	(sleep_until b_pulse_gen2_downed 1)

	(sleep_until
	(begin
		(section4_nav_control)
		(volume_test_players tv_nav_snowfield_c)
	)1)
)
(script dormant section5_navpoint_loop

	(sleep_until
	(begin
		(section5_nav_control)
		(any_players_in_vehicle_type s_vehicle_type_banshee)
	)1)
)
(script dormant section5_banshee_navpoint_loop

	(sleep_until (and (any_players_in_vehicle_type s_vehicle_type_banshee) (volume_test_players tv_nav_snowfield_a)) 1)

	(sleep_until
	(begin
		(section5_banshee_nav_control)
		b_pulse_gen3_downed
	)1)
)
(script static void section1_nav_control
	(cond

		;first generator nav point is blipped through narrative
		((= b_gen1_marked true)																						(f_blip_one fl_waypoint_conduit_1a))
		((f_navend_volume_check fl_waypoint_conduit_1a tv_plat1_ban_clean)											(f_unblip_one fl_waypoint_conduit_1a))

		((f_nav_ai_tv_dist_check fl_nav_control_exit gr_e1_a tv_nav_control_room s_blip_distance)					(f_blip_one fl_nav_control_exit))
		((f_navend_distance_check fl_nav_control_exit s_unblip_distance)											(f_unblip_one fl_nav_control_exit))

		((f_nav_ai_tv_dist_check fl_nav_hall_exit gr_e2_all tv_nav_hall s_blip_distance)							(f_blip_one fl_nav_hall_exit))
		((f_navend_distance_check fl_nav_hall_exit s_unblip_distance)												(f_unblip_one fl_nav_hall_exit))

		((f_nav_ai_tv_dist_check fl_waypoint_conduit_1b gr_e6_a_vignette_all tv_plat1_ban_clean s_blip_distance)	(f_blip_one fl_waypoint_conduit_1b))
		((f_navend_distance_check fl_waypoint_conduit_1b s_unblip_distance)											(f_unblip_one fl_waypoint_conduit_1b))
	)
)
(script static void section2_gen1down_nav_control
	(cond

		((f_nav_ai_tv_dist_check fl_waypoint_conduit_1d gr_e7_a tv_plat1_runpast_guard s_blip_distance)			(f_blip_one fl_waypoint_conduit_1d))
		((f_navend_distance_check fl_waypoint_conduit_1d s_unblip_distance)										(f_unblip_one fl_waypoint_conduit_1d))

		((f_nav_tv_distance_check fl_waypoint3 tv_plat1_ban_clean s_blip_distance)								(f_blip_one fl_waypoint3))
		((f_navend_distance_check fl_waypoint3 s_unblip_distance)												(f_unblip_one fl_waypoint3))

		((f_nav_ai_tv_dist_check fl_nav_arena_f_hall gr_e8_a tv_save_checkpoint7 s_blip_distance)				(f_blip_one fl_nav_arena_f_hall))
		((f_navend_distance_check fl_nav_arena_f_hall s_unblip_distance)										(f_unblip_one fl_nav_arena_f_hall))

		((f_nav_ai_tv_dist_check fl_nav_arena_f_start gr_e21_all tv_nav_arena_f_start s_blip_distance)			(f_blip_one fl_nav_arena_f_start))
		((f_navend_distance_check fl_nav_arena_f_start s_unblip_distance)										(f_unblip_one fl_nav_arena_f_start))

		((f_nav_tv_distance_check fl_nav_arena_f_exit tv_nav_arena_f_exit s_blip_distance)						(f_blip_one fl_nav_arena_f_exit))
		((f_navend_distance_check fl_nav_arena_f_exit s_unblip_distance)										(f_unblip_one fl_nav_arena_f_exit))

		((f_nav_tv_distance_check fl_nav_bridge_start tv_nav_bridge_start s_blip_distance)						(f_blip_one fl_nav_bridge_start))
		((f_navend_distance_check fl_nav_bridge_start s_unblip_distance)										(f_unblip_one fl_nav_bridge_start))

		((f_nav_tv_distance_check fl_nav_bridge_exit tv_nav_bridge_exit s_blip_distance)						(f_blip_one fl_nav_bridge_exit))
		((f_navend_distance_check fl_nav_bridge_exit s_unblip_distance)											(f_unblip_one fl_nav_bridge_exit))

	)
	(cond
		((f_nav_tv_distance_check fl_nav_arena_e_start tv_nav_arena_e_start s_blip_distance)					(f_blip_one fl_nav_arena_e_start))
		((f_navend_distance_check fl_nav_arena_e_start s_unblip_distance)										(f_unblip_one fl_nav_arena_e_start))

		((f_nav_tv_distance_check fl_nav_arena_e_1 tv_nav_arena_e_1 s_blip_distance)							(f_blip_one fl_nav_arena_e_1))
		((f_navend_distance_check fl_nav_arena_e_1 s_unblip_distance)											(f_unblip_one fl_nav_arena_e_1))

		((f_nav_tv_distance_check fl_nav_arena_e_2 tv_nav_arena_e_2 s_blip_distance)							(f_blip_one fl_nav_arena_e_2))
		((f_navend_distance_check fl_nav_arena_e_2 s_unblip_distance)											(f_unblip_one fl_nav_arena_e_2))

		((f_nav_tv_or_and_dist_check fl_nav_arena_e_3 tv_nav_arena_e_3 tv_nav_arena_e_4 s_blip_distance)		(f_blip_one fl_nav_arena_e_3))
		((f_navend_distance_check fl_nav_arena_e_3 s_unblip_distance)											(f_unblip_one fl_nav_arena_e_3))

		((f_nav_tv_distance_check fl_nav_arena_e_bridge tv_nav_arena_e_bridge s_blip_distance)					(f_blip_one fl_nav_arena_e_bridge))
		((f_navend_distance_check fl_nav_arena_e_bridge s_unblip_distance)										(f_unblip_one fl_nav_arena_e_bridge))

		((f_nav_tv_distance_check fl_nav_arena_e_bridge2 tv_nav_bridge_exit2 s_blip_distance)					(f_blip_one fl_nav_arena_e_bridge2))
		((f_navend_distance_check fl_nav_arena_e_bridge2 s_unblip_distance)										(f_unblip_one fl_nav_arena_e_bridge2))

		((f_nav_tv_distance_check fl_nav_arena_d_start tv_nav_arena_d_start s_blip_distance)					(f_blip_one fl_nav_arena_d_start))
		((f_navend_distance_check fl_nav_arena_d_start s_unblip_distance)										(f_unblip_one fl_nav_arena_d_start))

		((f_nav_ai_tv_dist_check fl_nav_arena_d_exit gr_e43_b tv_nav_arena_d s_blip_distance)					(f_blip_one fl_nav_arena_d_exit))
		((f_navend_distance_check fl_nav_arena_d_exit s_unblip_distance)										(f_unblip_one fl_nav_arena_d_exit))

		((f_nav_ai_tv_dist_check fl_nav_arena_d_elevator gr_e43_c tv_nav_arena_d_elevator s_blip_distance)		(f_blip_one fl_nav_arena_d_elevator))
		((f_navend_distance_check fl_nav_arena_d_elevator s_unblip_distance)									(f_unblip_one fl_nav_arena_d_elevator))

		((f_nav_ai_tv_dist_check fl_nav_arena_c_exit gr_e44_a tv_nav_arena_c s_blip_distance)					(f_blip_one fl_nav_arena_c_exit))
		((f_navend_distance_check fl_nav_arena_c_exit s_unblip_distance)										(f_unblip_one fl_nav_arena_c_exit))
	)
)

(script static void section3_outdoors_nav_control
	(cond
		((f_nav_tv_distance_check fl_waypoint_conduit_2p1 tv_nav_conduit2_trigger s_blip_distance)				(f_blip_one fl_waypoint_conduit_2p1))
		((f_navend_distance_check fl_waypoint_conduit_2p1 s_unblip_distance)									(f_unblip_one fl_waypoint_conduit_2p1))

		((f_nav_tv_distance_check fl_nav_spiral_lower2 tv_nav_spiral_lower2 s_blip_distance)					(f_blip_one fl_nav_spiral_lower2))
		((f_navend_distance_check fl_nav_spiral_lower2 s_unblip_distance)										(f_unblip_one fl_nav_spiral_lower2))

		((f_nav_tv_distance_check fl_nav_spiral_upper1 tv_nav_spiral_upper s_blip_distance)						(f_blip_one fl_nav_spiral_upper1))
		((f_navend_distance_check fl_nav_spiral_upper1 s_unblip_distance)										(f_unblip_one fl_nav_spiral_upper1))

		((f_nav_tv_distance_check fl_nav_waypoint_conduit_2p3 tv_nav_tarmac s_blip_distance)					(f_blip_one fl_nav_waypoint_conduit_2p3))
		((f_navend_distance_check fl_nav_waypoint_conduit_2p3 s_unblip_distance)								(f_unblip_one fl_nav_waypoint_conduit_2p3))
	)
)

(script static void section4_nav_control
	(cond

		;first generator nav point is blipped through narrative
		((f_navend_distance_check fl_waypoint_conduit_2p5 s_unblip_distance)									(f_unblip_one fl_waypoint_conduit_2p5))

		((f_nav_tv_distance_check fl_waypoint_conduit_3p1 tv_nav_tarmac 5)										(f_blip_one fl_waypoint_conduit_3p1))
		((f_navend_distance_check fl_waypoint_conduit_3p1 s_unblip_distance)									(f_unblip_one fl_waypoint_conduit_3p1))

		((f_nav_tv_distance_check fl_waypoint_conduit_3p2 tv_conduit3_nav_trigger1 s_blip_distance)				(f_blip_one fl_waypoint_conduit_3p2))
		((f_navend_distance_check fl_waypoint_conduit_3p2 s_unblip_distance)									(f_unblip_one fl_waypoint_conduit_3p2))

		((f_nav_tv_distance_check fl_nav_blast_door tv_nav_blast_door s_blip_distance)							(f_blip_one fl_nav_blast_door))
		((f_navend_distance_check fl_nav_blast_door s_unblip_distance)											(f_unblip_one fl_nav_blast_door))

		((f_nav_tv_distance_check fl_waypoint_conduit_3p3 tv_nav_chasm s_blip_distance)							(f_blip_one fl_waypoint_conduit_3p3))
		((f_navend_distance_check fl_waypoint_conduit_3p3 s_unblip_distance)									(f_unblip_one fl_waypoint_conduit_3p3))

		((f_nav_tv_distance_check fl_nav_chasm_tunnel_exit tv_nav_chasm_tunnel s_blip_distance)					(f_blip_one fl_nav_chasm_tunnel_exit))
		((f_navend_distance_check fl_nav_chasm_tunnel_exit s_unblip_distance)									(f_unblip_one fl_nav_chasm_tunnel_exit))
	)
)
(script static void section5_nav_control
	(cond

		((f_nav_tv_distance_check fl_waypoint_conduit_3p4 tv_nav_snowfield_c s_blip_distance)					(f_blip_one fl_waypoint_conduit_3p4))
		((f_navend_distance_check fl_waypoint_conduit_3p4 s_unblip_distance)									(f_unblip_one fl_waypoint_conduit_3p4))

		((f_nav_tv_distance_check fl_waypoint_conduit_3p5 tv_nav_snowfield_b s_blip_distance)					(f_blip_one fl_waypoint_conduit_3p5))
		((f_navend_distance_check fl_waypoint_conduit_3p5 s_unblip_distance)									(f_unblip_one fl_waypoint_conduit_3p5))

		((f_nav_tv_distance_check fl_waypoint_conduit_3_ban tv_nav_snowfield_a s_blip_distance)					(f_blip_one fl_waypoint_conduit_3_ban))
		((any_players_in_vehicle_type s_vehicle_type_banshee) 													(f_unblip_one fl_waypoint_conduit_3_ban))
	)
)
(script static void section5_banshee_nav_control
	(cond

		((f_nav_tv_distance_check fl_waypoint_conduit_3p6 tv_nav_snowfield_a s_blip_distance)					(f_blip_one fl_waypoint_conduit_3p6))
		((f_navend_distance_check fl_waypoint_conduit_3p6 10)													(f_unblip_one fl_waypoint_conduit_3p6))

		((f_nav_tv_distance_check fl_waypoint_conduit_3p8 tv_nav_snowfield_b s_blip_distance)					(f_blip_one fl_waypoint_conduit_3p8))
		((f_navend_distance_check fl_waypoint_conduit_3p8 5)													(f_unblip_one fl_waypoint_conduit_3p8))
	)
)

 ; /////////////////////////////////////////////
 ; lod managers		; todo - co-op teleport not yet handled
 ; /////////////////////////////////////////////




; /////////section 3/////////////////////////

	; elevator tunnel -> bunker: 		(volume_test_players tv_e46_speech_trigger)
		; bunker -> elevator tunnel:	(volume_test_players tv_save_checkpoint25)
	; bunker -> shine tower: 			(volume_test_players tv_e48_a_s_trigger)
		; shine tower -> bunker: 		(volume_test_players tv_shine_tower_player_approaching_gate)
	; shine tower -> tarmac: 			(volume_test_players tv_save_checkpoint27)
		; tarmac -> shine tower: 		(volume_test_players tv_shine_tower_tarmac_reentry)

; bunker - low lod in the spiral area, erase squad when entering tarmac
(script dormant lod_manager_gr_e46_a_to_e46_c_section_3

	; todo these triggers are overlapping and the "or" check will keep flipping between them
	(print_if b_debug "lod_manager_gr_e46_a_to_e46_c_section_3 - is awake - bunker")
	(sleep_until
		(begin
			(sleep_until (or (volume_test_players tv_e48_a_s_trigger) (volume_test_players tv_save_checkpoint25)) 1) 						; players have moved to spiral or returned to elevator tunnel
			(print_if b_debug "lod_manager_gr_e46_a_to_e46_c_section_3 - forcing bunker encounter to low lod")
			(ai_force_low_lod gr_e46_a_to_e46_c_section_3)

			(sleep_until (or (volume_test_players tv_shine_tower_player_approaching_gate) (volume_test_players tv_e46_speech_trigger)) 1) 				; players have returned from the spiral or the elevator tunnel
			(print_if b_debug "lod_manager_gr_e46_a_to_e46_c_section_3 - clearing bunker encounter to normal lod")
			(ai_clear_lod gr_e46_a_to_e46_c_section_3)

			; erase squad when player enters the tarmac

			(volume_test_players tv_save_checkpoint27)
		)
		1
	)

	(print_if b_debug "lod_manager_gr_e46_a_to_e46_c_section_3 - erasing bunker encounter because player entered tarmac")

	(ai_erase gr_e46_a_to_e46_c_section_3)

	(print_if b_debug "lod_manager_gr_e46_a_to_e46_c_section_3 - has stopped")
)

; shine tower - low lod in the tarmac area, erase squad when in the conduit or extra skull room
(script dormant lod_manager_gr_e48_section_3
	(print_if b_debug "lod_manager_gr_e48_section_3 - is awake - shine tower")
	(sleep_until
		(begin
			(sleep_until (or (volume_test_players tv_save_checkpoint27) (volume_test_players tv_shine_tower_player_approaching_gate)) 1) 	; players have moved to tarmac or gone back to bunker
			(print_if b_debug "lod_manager_gr_e48_section_3 - forcing shine tower encounter to low lod")
			(ai_force_low_lod gr_e48_section_3)

			(sleep_until (or (volume_test_players tv_shine_tower_tarmac_reentry) (volume_test_players tv_e48_a_s_trigger)) 1) 				; players have returned from tarmac or returned from bunker
			(print_if b_debug "lod_manager_gr_e48_section_3 - clearing shine tower snipers to normal lod")
			(ai_clear_lod gr_e48_section_3)

			; erase squad when player enters the second conduit room or the extra room

			(or (volume_test_players tv_save_checkpoint29) (volume_test_players tv_extra_room_1_entrance))
		)
		1
	)

	(print_if b_debug "lod_manager_gr_e48_section_3 - erasing shine tower snipers because player entered conduit2 or extra room")

	(ai_erase gr_e48_section_3)

	(print_if b_debug "lod_manager_gr_e48_section_3 - has stopped")
)

;====================================================================================================================================================================================================
; bridge monitors
; light bridges interpolate through space due to an animation issue, killing everything below them
; thus, we use two device machines, one for collision (the real one, invisible) and a vignette machine for the visual.
;
; to use, configure the device control to use a device group, but do not hook the bridge itself up to the device group.
; let the script listen to the group changes and create/destroy collision as it toggles the visuals accordingly.
;====================================================================================================================================================================================================

(script dormant arena_d_lightbridge_monitor
	(print "lightbridge monitor started")
	(branch (volume_test_players tv_e46_a_trigger) (lightbridge_monitor_over)) ;end script when player reaches point of no return

	(sleep_until
		(begin
			(f_toggle_lightbridge_on_group_change dm_lightbridge_collision dm_lightbridge_visual dg_lightbridge_position)

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