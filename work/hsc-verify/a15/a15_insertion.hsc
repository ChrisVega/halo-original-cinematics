(script static void a15_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches ins_start) (fixup_ins_start))
		((f_insertion_point_matches ins_cafeteria) (fixup_ins_cafeteria))
		((f_insertion_point_matches ins_flank) (fixup_ins_flank))
		((f_insertion_point_matches ins_airlock2) (fixup_ins_airlock2))
		((f_insertion_point_matches ins_stairs) (fixup_ins_stairs))
		((f_insertion_point_matches ins_cryo) (fixup_ins_cryo))
	)
)

;rally point alpha
(script static void fixup_ins_start
	(f_switch_zone_set_blocking zs_01)
	(a15_initial_profiles profile_weaponless profile_weaponless)
	(f_cinematic_handle_intro_snap cinematics\a10\a10_intro_normal.cinematic)

	; unlock insertion points that the player is starting from for co-op scenarios
	(submit_incident "ins_a10_start")
)


;rally point bravo
(script static void fixup_ins_cafeteria
	(f_switch_zone_set_blocking zs_02)
	(a15_initial_profiles profile_weaponless profile_weaponless)
	(f_cinematic_handle_intro_snap cinematics\a10\a10_bridge.cinematic)

	(wake mission_bridge)
	(pre_stairs_load)
	(device_set_power dm_bridge_door_2 0)
	(device_set_position_immediate dm_bridge_door_2 0)

	(device_set_power dm_crossfire_door_2 0)
	(device_set_position_immediate dm_crossfire_door_2 0)

	; unlock insertion points that the player is starting from for co-op scenarios
	(submit_incident "ins_a10_cafeteria")

	(set global_intercom true)
	(hide_radar_grenades)
	(if (not b_bypass_tutorials) (wake tutorial_grenades))
)

(script static void fixup_ins_flank
	(f_switch_zone_set_blocking zs_02)
	(a15_initial_profiles profile_armed profile_respawn_weapons)
	(pre_stairs_load)
	(f_insertion_fade_to_gameplay)

	(fireteam_setup)

	; unlock insertion points that the player is starting from for co-op scenarios
	(submit_incident "ins_a10_cafeteria")

	(set global_intercom true)
	(hide_radar_grenades)
)

(script static void fixup_ins_airlock2
	(f_switch_zone_set_blocking zs_02)
	(a15_initial_profiles profile_armed profile_respawn_weapons)
	(pre_stairs_load)
	(f_insertion_fade_to_gameplay)

	(set global_intercom true)
	(hide_radar_grenades)

	(set s_navpoint_index 10)
)

;rally point charlie
(script static void fixup_ins_stairs
	(f_switch_zone_set_blocking zs_03)
	(a15_initial_profiles profile_armed profile_respawn_weapons)
	(set s_navpoint_index 12)
	(pre_tunnel_load)
	; loading in pre and post stairs objects to match playing from start
	(pre_stairs_load)
	(f_insertion_fade_to_gameplay)

	(device_set_position_immediate dm_bsp3_door_a 0)
	(device_set_power dm_bsp3_door_a 0)
	(device_set_position_immediate dm_bsp3_door_b 0)
	(device_set_power dm_bsp3_door_b 0)

	(object_destroy dm_airlock_2_tick_2)

	(set global_intercom true)
	(hide_radar_grenades)
	(f_hud_obj_new "dia_a10_escape" "obj_a10_escape")
	(if (not b_bypass_tutorials) (wake tutorial_grenades))

)

(script static void fixup_ins_cryo
	(f_switch_zone_set_blocking zs_04)
	(a15_initial_profiles profile_armed profile_respawn_weapons)
	(post_tunnel_load)
	; loading in pre and post stairs objects to match playing from start
	(pre_stairs_load)
	(f_insertion_fade_to_gameplay)

	(set global_intercom true)
)

(script static void (a15_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_a15_respawn_async respawn)
	(wake a15_initial_profiles_async)
)

(global starting_profile sp_a15_respawn_async profile_weaponless)
(script dormant a15_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_a15_respawn_async)
)