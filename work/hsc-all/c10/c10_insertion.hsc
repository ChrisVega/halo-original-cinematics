(script static void c10_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches insertion_0_swamp_a) (fixup_ins_0_swamp_a))
		((f_insertion_point_matches insertion_1_level_a) (fixup_ins_1_level_a))
		((f_insertion_point_matches insertion_preflood) (fixup_ins_preflood))
		((f_insertion_point_matches insertion_postflood) (fixup_ins_postflood))
		((f_insertion_point_matches insertion_3_level_b) (fixup_ins_3_level_b))
		((f_insertion_point_matches insertion_4_swamp_b) (fixup_ins_4_swamp_b))
	)
)

; section swamp_a
; rally point - alpha
(script static void fixup_ins_0_swamp_a
	(f_switch_zone_set_blocking swamp_a)
	(c10_initial_profiles blamstartingprofile blamstartingprofile_respawn_a)
	(f_cinematic_handle_intro_snap cinematics\c10\c10_intro.cinematic)

	; configure elevators
	(c10_bring_lift_a_up_to_swamp_a)
	(c10_bring_lift_b_up_to_level_a)
)

; section level_a
; rally point - bravo
(script static void fixup_ins_1_level_a
	(f_switch_zone_set_blocking swamp_a)
	(c10_initial_profiles blamstartingprofile_level_a blamstartingprofile_respawn_a)
	(f_insertion_fade_to_gameplay)
	(set s_music_trigger_c10 30)

	(f_hud_obj_new "dia_c10_find" "obj_c10_find")

	; configure elevators
	(c10_bring_lift_b_up_to_level_a)
	(wake lift_a_switch_monitor)
)

; debug only - spawns right in front of prison cutscene trigger
(script static void fixup_ins_preflood
	(f_switch_zone_set_blocking swamp_a)
	(c10_initial_profiles blamstartingprofile_level_a blamstartingprofile_respawn_a)
	(f_insertion_fade_to_gameplay)

	(f_hud_obj_new "dia_c10_find" "obj_c10_find")

	; configure elevators
	(c10_bring_lift_b_up_to_level_a)
	(wake lift_a_switch_monitor)
	(wake bridge_b_monitor)
)
; debug only - spawns right outside prison but after the flood is revealed so you can skip the encounter
(script static void fixup_ins_postflood
	(f_switch_zone_set_blocking level_a)
	(c10_initial_profiles blamstartingprofile_level_a blamstartingprofile_respawn_a)
	(f_insertion_fade_to_gameplay)

	(f_hud_obj_new "dia_c10_escape" "obj_c10_escape")

	(control_table_post_cutscene)

	(set b_flood_revealed true)
	(set b_flood_reveal_room_open true) ; set during the prison encounter that this insertion point skips; needed so navpoints pick up after the encounter
	(wake start_flood_revealed)

	; configure elevators
	(c10_bring_lift_b_up_to_level_a)
	(device_group_set_immediate doors_flood_reveal_power 1)
	(device_set_power lift_a_cont_b 0)
	(object_create lift_a_falling)
	(object_destroy lift_a)

	(wake bridge_b_monitor)
)
; section level_b
; rally point - charlie
(script static void fixup_ins_3_level_b
	(f_switch_zone_set_blocking level_b)
	(c10_initial_profiles blamstartingprofile_level_b blamstartingprofile_respawn_b)
	(f_insertion_fade_to_gameplay)

	(f_hud_obj_new "dia_c10_escape" "obj_c10_escape")
)

; section swamp_b
; debug only - spawns at the bottom of lift_d
(script static void fixup_ins_4_swamp_b
	(f_switch_zone_set_blocking swamp_b)
	(c10_initial_profiles blamstartingprofile_level_b blamstartingprofile_respawn_b)
	(f_insertion_fade_to_gameplay)
)


; helpers

; bring lift_a up to swamp_a (with spooky offset) - it starts at level_a to support the level_a insertion point
(script static void c10_bring_lift_a_up_to_swamp_a
	(device_set_position_immediate lift_a 0.25)
	(device_group_set_immediate lift_a_position 0.25)
)

; bring lift_b up to level_a - it starts at level_b to support the level_b insertion point
(script static void c10_bring_lift_b_up_to_level_a
	(device_set_position_immediate lift_b 1)
	(device_group_set_immediate lift_b_position 1)
)

; bring lift_d up to swamp_b so players don't fall - it starts at level_b because that is the least change
(script static void c10_bring_lift_d_up_to_swamp_b
	(device_set_position_immediate lift_d 1)
	(device_group_set_immediate lift_d_position 1)
)

(script static void (c10_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_c10_respawn_async respawn)
	(wake c10_initial_profiles_async)
)

(global starting_profile sp_c10_respawn_async blamstartingprofile)
(script dormant c10_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_c10_respawn_async)
)