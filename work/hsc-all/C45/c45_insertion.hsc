(script static void c45_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches ins_section1) (fixup_ins_section1))
		((f_insertion_point_matches ins_section2) (fixup_ins_section2))
		((f_insertion_point_matches ins_section3) (fixup_ins_section3))
		((f_insertion_point_matches ins_section4) (fixup_ins_section4))
		((f_insertion_point_matches ins_section5) (fixup_ins_section5))
	)
)

; /// rally point alpha /// ;
(script static void fixup_ins_section1
	(f_switch_zone_set_blocking five)
	(c45_initial_profiles profile_starting profile_respawn)
	(f_cinematic_handle_intro_snap cinematics\c40\c40_intro.cinematic)
)

; /// rally point bravo /// ;
(script static void fixup_ins_section2
	(f_switch_zone_set_blocking five)
	(c45_initial_profiles profile_ins_section2 profile_respawn)
	(f_insertion_fade_to_gameplay)
	(f_hud_obj_new obj_c40_2 obj_c40_2)

	(destroy_pulse_generator_1_conduits)

	(device_set_power dm_door_c1 0)
	(device_set_position_immediate dm_door_c1 0)
)

; /// rally point charlie /// ;
(script static void fixup_ins_section3
	(f_switch_zone_set_blocking four_c)
	(c45_initial_profiles profile_ins_section3 profile_respawn)
	(f_insertion_fade_to_gameplay)
	(f_hud_obj_new obj_c40_2 obj_c40_2)

	(destroy_pulse_generator_1_conduits)

	(device_set_power dm_unnamed_36 0)
	(device_set_position_immediate dm_unnamed_36 0)
)

; /// rally point delta /// ;
(script static void fixup_ins_section4
	(f_switch_zone_set_blocking four_b)
	(c45_initial_profiles profile_ins_section4 profile_respawn)
	(f_insertion_fade_to_gameplay)
	(f_hud_obj_new obj_c40_4 obj_c40_4)

	(destroy_pulse_generator_1_conduits)
	(destroy_pulse_generator_2_conduits)

	; wake the conduit and chasm transition handler
	(wake e53_a)
	(wake extra_room)

	(e51_a_place_top_of_tarmac_squads_and_vehicles)
	(ai_erase gr_e51_erase_for_ins4) ; clear the guys in front of the door when using insertion point
)

; debug only
(script static void fixup_ins_section5
	(f_switch_zone_set_blocking two_c)
	(c45_initial_profiles profile_ins_section4 profile_respawn)
	(f_insertion_fade_to_gameplay)

	(destroy_pulse_generator_1_conduits)
	(destroy_pulse_generator_2_conduits)
)


; ///// insertion helpers ///// ;
(script static void destroy_pulse_generator_1_conduits
	(set b_pulse_gen1_downed true)

	(object_destroy sc_pulse_1_conduit_a)
	(object_destroy sc_pulse_1_conduit_b)
	(object_destroy sc_pulse_1_conduit_c)
)

(script static void destroy_pulse_generator_2_conduits
	(set b_pulse_gen2_downed true)

	(object_destroy sc_pulse_2_conduit_a)
	(object_destroy sc_pulse_2_conduit_b)
	(object_destroy sc_pulse_2_conduit_c)
)

(script static void (c45_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_c45_respawn_async respawn)
	(wake c45_initial_profiles_async)
)

(global starting_profile sp_c45_respawn_async profile_starting)
(script dormant c45_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_c45_respawn_async)
)