(script static void d20_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches insertion_section1) (fixup_ins_section1))
		((f_insertion_point_matches insertion_section3) (fixup_ins_section3))
		((f_insertion_point_matches insertion_section4) (fixup_ins_section4))
		((f_insertion_point_matches insertion_section5) (fixup_ins_section5))
		((f_insertion_point_matches insertion_section6) (fixup_ins_section6))
		((f_insertion_point_matches insertion_section7) (fixup_ins_section7))
		((f_insertion_point_matches insertion_finale) (fixup_ins_finale))
	)
)

; section 1
(script static void fixup_ins_section1
	(f_switch_zone_set_blocking ship_part_a)
	(d20_initial_profiles blamstartingprofile_section1 respawnprofile_default)
	(f_cinematic_handle_intro_snap cinematics\d20\d20_intro.cinematic)
)

; section 3
(script static void fixup_ins_section3
	(f_switch_zone_set_blocking canyon)
	(d20_initial_profiles blamstartingprofile_section3 respawnprofile_default)
	(f_insertion_fade_to_gameplay)
)

; section 4
(script static void fixup_ins_section4
	(f_switch_zone_set_blocking ship_part_b)
	(d20_initial_profiles blamstartingprofile_section4 respawnprofile_interior)
	(f_insertion_fade_to_gameplay)

	(f_objective_lift)
)

; section 5
(script static void fixup_ins_section5
	(f_switch_zone_set_blocking ship_part_b)
	(d20_initial_profiles blamstartingprofile_section5 respawnprofile_interior)
	(f_insertion_fade_to_gameplay)

	(f_objective_go_to_bay)
)

; section 6
(script static void fixup_ins_section6
	(f_switch_zone_set_blocking ship_part_b)
	(d20_initial_profiles blamstartingprofile_section5 respawnprofile_interior)
	(f_insertion_fade_to_gameplay)

	(f_objective_go_to_bridge)
)

; section 7
(script static void fixup_ins_section7
	(f_switch_zone_set_blocking ship_part_b)
	(d20_initial_profiles blamstartingprofile_section5 respawnprofile_interior)
	(f_insertion_fade_to_gameplay)

	(wake objective_gobay_2)
	(set b_keyes_cinematic_played true)
)

; finale
(script static void fixup_ins_finale
	(f_switch_zone_set_blocking ship_part_b)
	(d20_initial_profiles blamstartingprofile_section5 respawnprofile_interior)
	(f_insertion_fade_to_gameplay)
)

(script static void (d20_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_d20_respawn_async respawn)
	(wake d20_initial_profiles_async)
)

(global starting_profile sp_d20_respawn_async blamstartingprofile_section1)
(script dormant d20_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_d20_respawn_async)
)