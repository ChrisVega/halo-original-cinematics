(script static void e30_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
 		((f_insertion_point_matches ins_e30_start) (fixup_ins_e30_start))
		((f_insertion_point_matches ins_e30_hydro_enter) (fixup_ins_e30_hydro_enter))
		((f_insertion_point_matches ins_e30_hydro_mid) (fixup_ins_e30_hydro_mid))
		((f_insertion_point_matches ins_e30_grav_lift) (fixup_ins_e30_grav_lift))
		((f_insertion_point_matches ins_e30_hydro_redux) (fixup_ins_e30_hydro_redux))
		((f_insertion_point_matches ins_e30_rr_approach) (fixup_ins_e30_rr_approach))
		((f_insertion_point_matches ins_e30_transit_station) (fixup_ins_e30_transit_station))
		((f_insertion_point_matches ins_e30_dome_station) (fixup_ins_e30_dome_station))
		((f_insertion_point_matches ins_e30_space_1) (fixup_ins_e30_space_1))
		((f_insertion_point_matches ins_e30_space_2) (fixup_ins_e30_space_2))
		((f_insertion_point_matches ins_e30_space_3) (fixup_ins_e30_space_3))
	)
)

; mission start | beat 1 - mission start/rally point alpha
(script static void fixup_ins_e30_start
	(f_switch_zone_set_blocking zs_start_hydro)
	(e30_initial_profiles)
	(f_insertion_fade_to_gameplay)

	(wake init_johnson)
	(wake begin_beat1)
	(wake init_beat1_object_placement)
)

; beat 1 - hydroponic entry
(script static void fixup_ins_e30_hydro_enter
	(f_switch_zone_set_blocking zs_start_hydro)
	(e30_initial_profiles)
	(f_insertion_fade_to_gameplay)

	(wake init_johnson)
	(wake begin_beat1)
	(wake init_beat1_object_placement)
)

; beat 1 - hydroponic mid
(script static void fixup_ins_e30_hydro_mid
	(f_switch_zone_set_blocking zs_hydro_control)
	(e30_initial_profiles)
	(f_insertion_fade_to_gameplay)

	(wake init_johnson)
	(wake begin_beat1)
	(wake init_beat1_mid_object_placement)
)

; beat 2 start - rally point bravo
(script static void fixup_ins_e30_grav_lift
	(f_switch_zone_set_blocking zs_hydro_control)
	(e30_initial_profiles)
	(f_cinematic_handle_intro_snap cinematics\e30\e30_bridge.cinematic)

	(wake init_johnson)
	(wake ins_beat2_catch_up)
	(wake init_beat2_object_placement)
)

; beat 2 - hydroponic redux
(script static void fixup_ins_e30_hydro_redux
	(f_switch_zone_set_blocking zs_hydro_control)
	(e30_initial_profiles)
	(f_insertion_fade_to_gameplay)

	(wake init_johnson)
	(wake begin_beat2)
	(wake init_beat2_mid_object_placement)
)

; beat 2 - rest and respite approach
(script static void fixup_ins_e30_rr_approach
	(f_switch_zone_set_blocking zs_hydro_rest)
	(e30_initial_profiles)
	(f_insertion_fade_to_gameplay)

	(wake init_johnson)
	(wake begin_beat2)
	(wake init_beat2_mid_object_placement)
)

; beat 3 start - rally point charlie
(script static void fixup_ins_e30_transit_station
	(f_switch_zone_set_blocking zs_hydro_rest_transit)
	(e30_initial_profiles)
	(f_insertion_fade_to_gameplay)

	(wake init_johnson)
	(wake begin_beat3)
	(wake init_beat3_object_placement)
	(wake mission_obj_docking_bay)
)

; beat 3 dome station
(script static void fixup_ins_e30_dome_station
	(f_switch_zone_set_blocking zs_transit)
	(e30_initial_profiles)
	(f_insertion_fade_to_gameplay)

	(wake init_johnson)
	(wake ins_dome_station_catch_up)
)

; space battle start - rally point delta
(script static void fixup_ins_e30_space_1
	(f_switch_zone_set_blocking zs_space)
	(player_set_profile start_profile_space)
	(wake e30_space_respawn)
	(f_cinematic_handle_intro_snap cinematics\e30\e30_change.cinematic)

	(wake begin_beat4)
)

; space battle 2
(script static void fixup_ins_e30_space_2
	(f_switch_zone_set_blocking zs_space)
	(player_set_profile start_profile_space)
	(wake e30_space_respawn)
	(f_insertion_fade_to_gameplay)

	(wake ins_space_2_catch_up)
)

; space battle 3
(script static void fixup_ins_e30_space_3
	(f_switch_zone_set_blocking zs_space)
	(player_set_profile start_profile_space)
	(wake e30_space_respawn)
	(f_insertion_fade_to_gameplay)

	(wake ins_space_3_catch_up)
)

(script static void e30_initial_profiles
	; unique for coop
	(player_set_profile start_profile_coop_p0 player0)
	(player_set_profile start_profile_coop_p1 player1)
	(player_set_profile start_profile_coop_p2 player2)
	(player_set_profile start_profile_coop_p3 player3)

	(set sp_e30_respawn_async start_profile_coop_respawn)
	(wake e30_initial_profiles_async)
)

(global starting_profile sp_e30_respawn_async start_profile_solo)
(script dormant e30_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)

	(if
		(and
			(not (game_is_cooperative))
			; replace profile when not carrying over other weapons
			(unit_has_weapon player0 objects\weapons\rifle\assault_rifle\smg.weapon)
			(unit_has_weapon player0 objects\weapons\rifle\battle_rifle\battle_rifle.weapon)
		)
		(unit_add_equipment player0 start_profile_solo true false)
	)

	; set
	(player_set_profile sp_e30_respawn_async)
)

; seraph respawns
(script dormant e30_space_respawn
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)

	(player_set_respawn_vehicle player0 "objects/vehicles/covenant/seraph/seraph.vehicle")
	(player_set_respawn_vehicle player1 "objects/vehicles/covenant/seraph/seraph.vehicle")
	(player_set_respawn_vehicle player2 "objects/vehicles/covenant/seraph/seraph.vehicle")
	(player_set_respawn_vehicle player3 "objects/vehicles/covenant/seraph/seraph.vehicle")
)