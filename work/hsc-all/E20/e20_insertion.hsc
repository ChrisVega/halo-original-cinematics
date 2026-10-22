(script static void e20_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches ins_e20_start) (fixup_ins_e20_start))
		((f_insertion_point_matches ins_e20_settlement_end) (fixup_ins_e20_settlement_end))
		((f_insertion_point_matches ins_e20_prison_start) (fixup_ins_e20_prison_start))
		((f_insertion_point_matches ins_e20_prison_armory) (fixup_ins_e20_prison_armory))
		((f_insertion_point_matches ins_e20_pre_bridge) (fixup_ins_e20_pre_bridge))
		((f_insertion_point_matches ins_e20_landing_structure) (fixup_ins_e20_landing_structure))
		((f_insertion_point_matches ins_e20_path_to_control_room) (fixup_ins_e20_path_to_control_room))
		((f_insertion_point_matches ins_e20_final_encounter) (fixup_ins_e20_final_encounter))
	)
)

; mission start
(script static void fixup_ins_e20_start
	(f_switch_zone_set_blocking set_start)
	(e20_initial_profiles player_starting_profile_start player_starting_profile_respawn)
	(f_cinematic_handle_intro_snap cinematics\e20\e20_dome.cinematic)

	(set mark_signal true) ; current objective
)

; end of settlement segment
(script static void fixup_ins_e20_settlement_end
	(f_switch_zone_set_blocking set_start)
	(e20_initial_profiles player_starting_profile_set_end player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set mark_survive true) ; current objective
)

; entrance to prison
(script static void fixup_ins_e20_prison_start
	(f_switch_zone_set_blocking set_prison)
	(e20_initial_profiles player_starting_profile_prison player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set mark_prison true) ; current objective
)

; rescuing the captives
(script static void fixup_ins_e20_prison_armory
	(f_switch_zone_set_blocking set_prison)
	(e20_initial_profiles player_starting_profile_prison player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set mark_prison true) ; current objective
)

; end of arena segment
(script static void fixup_ins_e20_pre_bridge
	(f_switch_zone_set_blocking set_prison)
	(e20_initial_profiles player_starting_profile_gbridge player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set mark_prison true) ; current objective
)

; after grav bridge and old arena
(script static void fixup_ins_e20_landing_structure
	(f_switch_zone_set_blocking set_lodge)
	(e20_initial_profiles player_starting_profile_gbridge player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set mark_clear true) ; current objective
)

; on path to control room
(script static void fixup_ins_e20_path_to_control_room
	(f_switch_zone_set_blocking set_lodge)
	(e20_initial_profiles player_starting_profile_gbridge player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set mark_clear true) ; current objective
)

; entering control room
(script static void fixup_ins_e20_final_encounter
	(f_switch_zone_set_blocking set_lodge)
	(e20_initial_profiles player_starting_profile_gbridge player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set mark_clear true) ; current objective
)

(script static void (e20_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_e20_respawn_async respawn)
	(wake e20_initial_profiles_async)
)

(global starting_profile sp_e20_respawn_async player_starting_profile_start)
(script dormant e20_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_e20_respawn_async)
)