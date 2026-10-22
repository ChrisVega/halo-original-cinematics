(script static void c20_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches insertion_floor1_start) (fixup_ins_floor1_start))
		((f_insertion_point_matches insertion_floor1_middle) (fixup_ins_floor1_middle))
		((f_insertion_point_matches insertion_floor1_lift) (fixup_ins_floor1_lift))
		((f_insertion_point_matches insertion_floor2_start) (fixup_ins_floor2_start))
		((f_insertion_point_matches insertion_floor2_middle) (fixup_ins_floor2_middle))
		((f_insertion_point_matches insertion_floor2_lift) (fixup_ins_floor2_lift))
		((f_insertion_point_matches insertion_floor3_start) (fixup_ins_floor3_start))
		((f_insertion_point_matches insertion_floor3_arena) (fixup_ins_floor3_arena))
		((f_insertion_point_matches insertion_floor3_lift) (fixup_ins_floor3_lift))
		((f_insertion_point_matches insertion_floor4_start) (fixup_ins_floor4_start))
	)
)

; /// rally point alpha ///
(script static void fixup_ins_floor1_start
	(f_switch_zone_set_blocking set_floor_1)
	(c20_initial_profiles player_starting_profile player_respawn_profile)
	(f_cinematic_handle_intro_snap cinematics\c20\c20_intro.cinematic)

	(f_place_monitor sq_monitor/sp_a)
)

; /// debug only ///
(script static void fixup_ins_floor1_middle
	(f_switch_zone_set_blocking set_floor_1)
	(c20_initial_profiles player_starting_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(f_place_monitor sq_monitor/spawnpoint_b)
	(f_hud_obj_new obj_c20_follow obj_c20_follow)
	; devices to set to make sure the level is in the correct state
	(device_group_set floor_1_door_right_end_closed door_floor_1_rightb_group 1)
)

; /// debug only ///
(script static void fixup_ins_floor1_lift
	(f_switch_zone_set_blocking set_floor_1)
	(c20_initial_profiles player_starting_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(f_place_monitor sq_monitor/spawnpoint_b_lift)
	(f_hud_obj_new obj_c20_elevator1 obj_c20_elevator1)
)

; /// rally point bravo ///
(script static void fixup_ins_floor2_start
	(f_switch_zone_set_blocking set_post_elevator_1)
	(c20_initial_profiles player_floor_2_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(f_place_monitor sq_monitor/sp_f2_start)
	(device_set_position_immediate elevator_1 1)
	; (f_hud_obj_new obj_c20_elevator1 obj_c20_elevator1)
)

; /// debug only ///
(script static void fixup_ins_floor2_middle
	(f_switch_zone_set_blocking set_floor_2b)
	(c20_initial_profiles player_floor_2_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(device_set_position floor_2_door_right_end 1)
	(f_place_monitor sq_monitor/sp_f2_middle)
	(f_hud_obj_new obj_c20_explore obj_c20_explore)
	; devices to set to make sure the level is in the correct state
	(device_group_set floor_2_door_right_end door_floor_2_rightb_group 1)
)

; /// debug only ///
(script static void fixup_ins_floor2_lift
	(f_switch_zone_set_blocking set_floor_2b)
	(c20_initial_profiles player_floor_2_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(f_place_monitor sq_monitor/spawnpoint_c_lift)
	(f_hud_obj_new obj_c20_elevator2 obj_c20_elevator2)
	;(device_set_position floor_2_middle_exit_door 1)
)

; /// rally point charlie ///
(script static void fixup_ins_floor3_start
	(f_switch_zone_set_blocking set_elevator_2)
	(c20_initial_profiles player_floor_3_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(f_place_monitor sq_monitor/sp_f3_start)
	(device_set_position_immediate elevator_2 1)
	; (f_hud_obj_new obj_c20_elevator2 obj_c20_elevator2)
)

; /// debug only ///
(script static void fixup_ins_floor3_arena
	(f_switch_zone_set_blocking set_floor_3b)
	(c20_initial_profiles player_floor_3_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(f_door_try_open dm_sec_door_f3_3_fx floor_3_door_normal_end)
	(f_place_monitor sq_monitor/spawnpoint_d_arena)
	(f_hud_obj_new obj_c20_delve obj_c20_delve)
)

; /// debug only ///
(script static void fixup_ins_floor3_lift
	(f_switch_zone_set_blocking set_floor_3b)
	(c20_initial_profiles player_floor_3_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(f_place_monitor sq_monitor/spawnpoint_d_lift)
	(f_hud_obj_new obj_c20_elevator3 obj_c20_elevator3)
)

; /// debug only ///
(script static void fixup_ins_floor4_start
	(f_switch_zone_set_blocking set_floor_4)
	(c20_initial_profiles player_floor_3_profile player_respawn_profile)
	(f_insertion_fade_to_gameplay)

	(f_place_monitor sq_monitor/sp_f4_start)
	(device_set_position_immediate elevator_3 1)
	; (f_hud_obj_new obj_c20_elevator3 obj_c20_elevator3)
)

(script static void (c20_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_c20_respawn_async respawn)
	(wake c20_initial_profiles_async)
)

(global starting_profile sp_c20_respawn_async player_starting_profile)
(script dormant c20_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_c20_respawn_async)
)