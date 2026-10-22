(script static void d40_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches insertion_start) (fixup_ins_start))
		((f_insertion_point_matches insertion_bridge) (fixup_ins_bridge))
		((f_insertion_point_matches insertion_cryo) (fixup_ins_cryo))
		((f_insertion_point_matches insertion_tube) (fixup_ins_tube))
		((f_insertion_point_matches insertion_engine) (fixup_ins_engine))
		((f_insertion_point_matches insertion_warthog) (fixup_ins_warthog))
		((f_insertion_point_matches insertion_split) (fixup_ins_split))
		((f_insertion_point_matches insertion_longsword) (fixup_ins_longsword))
	)
)

(script static void fixup_ins_start
	(f_switch_zone_set_blocking set_1_ship_bottom)
	(d40_initial_profiles profile_start profile_respawn)
	(f_cinematic_handle_intro_snap cinematics\d40\d40_intro.cinematic)
)

(script static void fixup_ins_bridge
	(f_switch_zone_set_blocking set_1_ship_bottom)
	(d40_initial_profiles profile_start profile_respawn)
	(f_cinematic_handle_intro_snap cinematics\d40\d40_bridge.cinematic)

	(wake enc2_5_cine)
)

(script static void fixup_ins_cryo
	(f_switch_zone_set_blocking set_1_ship_bottom)
	(d40_initial_profiles profile_start profile_respawn)
	(f_insertion_fade_to_gameplay)
)

(script static void fixup_ins_tube
	(f_switch_zone_set_blocking set_1_ship_bottom)
	(d40_initial_profiles profile_start profile_respawn)
	(f_insertion_fade_to_gameplay)
)

(script static void fixup_ins_engine
	(f_switch_zone_set_blocking set_1_ship_bottom)
	(d40_initial_profiles profile_start profile_respawn)
	(f_insertion_fade_to_gameplay)

	(device_set_position_immediate dm_blast_door_hall 0)
	(wake enc4_3)
)

(script static void fixup_ins_warthog
	(f_switch_zone_set_blocking set_3_race_start)
	(d40_initial_profiles profile_run profile_run)
	(f_insertion_fade_to_gameplay)

	(object_create_folder v_hog_run)
	(device_set_position_immediate unsc_cargo_elevator_device 1)
)

(script static void fixup_ins_split
	(f_switch_zone_set_blocking set_3_race_start)
	(d40_initial_profiles profile_run profile_run)
	(f_insertion_fade_to_gameplay)

	(object_create_folder v_hog_run)
	; 5m left
	(set s_timer_seconds_elapsed (- s_timer_seconds (* 5 60)))
	(wake manage_timer)
	(wake check_player_in_warthog)
	(wake update_race_point_loop)
	(wake enc6_1_9_trigger)
	(object_create v_split_wh)
	; navigation
	(f_exclusive_blip_flag fl_wart_run_5_foehammer 0)
	(wake nav_wart_run)
)

(script static void fixup_ins_longsword
	(f_switch_zone_set_blocking set_4_race_end)
	(d40_initial_profiles profile_run profile_run)
	(f_insertion_fade_to_gameplay)

	(object_create_folder v_hog_run)
	; 1.5m left
	(set s_timer_seconds_elapsed (- s_timer_seconds (* 1.5 60)))
	(wake manage_timer)
	(wake enc7_1_trigger)
)

(script static void (d40_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_d40_respawn_async respawn)
	(wake d40_initial_profiles_async)
)

(global starting_profile sp_d40_respawn_async profile_start)
(script dormant d40_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_d40_respawn_async)
)