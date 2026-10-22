(script static void e10_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches ins_e10_start) (fixup_ins_e10_level_start))
		((f_insertion_point_matches ins_e10_rest_respite) (fixup_ins_e10_rest_respite))
		((f_insertion_point_matches ins_e10_dojo) (fixup_ins_e10_dojo))
		((f_insertion_point_matches ins_e10_geneforge_start) (fixup_ins_e10_geneforge_start))
		((f_insertion_point_matches ins_e10_main_lab_lower) (fixup_ins_e10_main_lab_lower))
		((f_insertion_point_matches ins_e10_tf_revisit) (fixup_ins_e10_tf_revisit))
		((f_insertion_point_matches ins_e10_double_grav_lift) (fixup_ins_e10_double_grav_lift))
		((f_insertion_point_matches ins_e10_final_encounter) (fixup_ins_e10_final_encounter))
	)
)

; beat 1 - alpha
(script static void fixup_ins_e10_level_start
	(f_switch_zone_set_blocking set_1_docking_bay)
	(e10_initial_profiles)
	(f_cinematic_handle_intro_snap cinematics\e10\e10_boarding.cinematic)
)

; beat 2 - bravo
(script static void fixup_ins_e10_rest_respite
	(f_switch_zone_set_blocking set_2_rest_respite)
	(e10_initial_profiles)
	(f_insertion_fade_to_gameplay)

	; set elements should you start here
	(object_create gravlift_a_hunters) ; set the gravlift out of the hanger into an on state so you cant backtrack
	(f_blip_flag fl_rr_entry 0)
	(f_hud_obj_new "obj_signals" "obj_signals")
)

(script static void fixup_ins_e10_dojo
	(f_switch_zone_set_blocking set_2_rest_respite)
	(e10_initial_profiles)
	(f_insertion_fade_to_gameplay)
)

; beat 3 - charlie
(script static void fixup_ins_e10_geneforge_start
	(f_switch_zone_set_blocking set_3_marine_gear_storage_room)
	(e10_initial_profiles)
	(f_insertion_fade_to_gameplay)
)

; beat 4 - delta
(script static void fixup_ins_e10_main_lab_lower
	(f_switch_zone_set_blocking set_4_geneforge_main_lab)
	(e10_initial_profiles)
	(f_insertion_fade_to_gameplay)

	; set elements should you start here
	(set_elements_already_complete) ;set elements should the player turn around (e10.hsc)
)

(script static void fixup_ins_e10_tf_revisit
	(f_switch_zone_set_blocking set_4_geneforge_main_lab)
	(e10_initial_profiles)
	(f_insertion_fade_to_gameplay)

	; set elements should you start here
	(set b_backtracking_through_level true) ; set the backtracking variable
	(set_elements_already_complete) ;set elements should the player turn around (e10.hsc)
	(device_set_power dm_geneforge_ll_door_into_lab 0) ; lock the door into the geneforge lower lab
)

; end of settlement segment
(script static void fixup_ins_e10_double_grav_lift
	(f_switch_zone_set_blocking set_4_geneforge_main_lab)
	(e10_initial_profiles)
	(f_insertion_fade_to_gameplay)

	; set elements should you start here
	(set_elements_already_complete) ;set elements should the player turn around (e10.hsc)
)

; end of settlement segment
(script static void fixup_ins_e10_final_encounter
	(f_switch_zone_set_blocking set_4_geneforge_main_lab)
	(e10_initial_profiles)
	(f_insertion_fade_to_gameplay)
)

(script static void e10_initial_profiles
	; unique for coop
	(player_set_profile start_profile_coop_p0 player0)
	(player_set_profile start_profile_coop_p1 player1)
	(player_set_profile start_profile_coop_p2 player2)
	(player_set_profile start_profile_coop_p3 player3)

	(set sp_e10_respawn_async start_profile_coop_respawn)
	(wake e10_initial_profiles_async)
)

(global starting_profile sp_e10_respawn_async start_profile_solo)
(script dormant e10_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)

	(if
		(not (game_is_cooperative))
		; replace profile
		(unit_add_equipment player0 start_profile_solo true false)
	)

	; set
	(player_set_profile sp_e10_respawn_async)
)