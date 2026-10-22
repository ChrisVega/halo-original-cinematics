(script static void b40_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches ins_b1_start) (fixup_ins_b1_start))
		((f_insertion_point_matches ins_b1_bridge) (fixup_ins_b1_bridge))
		((f_insertion_point_matches ins_b1_elevator) (fixup_ins_b1_elevator))
		((f_insertion_point_matches ins_b2_start) (fixup_ins_b2_start))
		((f_insertion_point_matches ins_b2_middle) (fixup_ins_b2_middle))
		((f_insertion_point_matches ins_b2_scorpion) (fixup_ins_b2_scorpion))
		((f_insertion_point_matches ins_b2_postchasm) (fixup_ins_b2_postchasm))
		((f_insertion_point_matches ins_b3_start) (fixup_ins_b3_start))
		((f_insertion_point_matches ins_b4_start) (fixup_ins_b4_start))
		((f_insertion_point_matches ins_spiral) (fixup_ins_spiral))
	)
)

; /// rally point alpha /// ;
(script static void fixup_ins_b1_start
	(f_switch_zone_set_blocking one)
	(b40_initial_profiles blamstartingprofile blamstartingprofilerespawn)
	(f_cinematic_handle_intro_snap cinematics\b40\b40_intro.cinematic)
)

; editor only
(script static void fixup_ins_b1_bridge
	(f_switch_zone_set_blocking one)
	(b40_initial_profiles blamstartingprofile blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)

	(place_b1_objects)
)

; editor only
(script static void fixup_ins_b1_elevator
	(f_switch_zone_set_blocking one)
	(b40_initial_profiles blamstartingprofile blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)

	; need warthog
	(object_create_if_necessary ext_a_pelican_whog)
)

; editor only
(script static void fixup_ins_b2_start
	(f_switch_zone_set_blocking one)
	(b40_initial_profiles blamstartingprofile blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)

	; need warthog
	(object_create_if_necessary ext_a_pelican_whog)
)

; editor only
(script static void fixup_ins_b2_middle
	(f_switch_zone_set_blocking three)
	(b40_initial_profiles blamstartingprofile blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)
)

; /// rally point bravo /// ;
(script static void fixup_ins_b2_scorpion
	(f_switch_zone_set_blocking two)
	(b40_initial_profiles blamstartingprofilescorpion blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)

	; only place the objects in snowfields b and c so that snowfield a doesn't have enemy vehicles
	(place_b2_objects_snowfield_b_and_c_only)

	; ensure warthog exists
	(object_create_if_necessary ext_a_pelican_whog)

	; lock backwards doors so players can't reach interiors
	(device_set_position_immediate dm_hexdoor_bridge_a 0) ; bridge_a, to level start
	(device_set_position_immediate dm_hexdoor_arena_b 0) ; bridge_a, to arena_b/elevator top
	(device_set_position_immediate dm_hexdoor_snwfld_a 0) ; snowfield_a, to elevator bottom

	(device_set_power dm_hexdoor_bridge_a 0)
	(device_set_power dm_hexdoor_arena_b 0)
	(device_set_power dm_hexdoor_snwfld_a 0)

	; messaging
	(wake play_rally_point_bravo_objective_nonblocking)
)

; /// rally point charlie /// ;
(script static void fixup_ins_b2_postchasm
	(f_switch_zone_set_blocking three)
	(b40_initial_profiles blamstartingprofilepostchasm blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)

	; the door locks behind us, so place only the tarmac and leave the chasm empty
	(place_b3_objects_tarmac_only)

	; create marines vehicles for players starting partway through the mission
	(ai_place ext_b_postchasm_marines)
	(object_create_if_necessary ins_postchasm_tank)
	(object_create_if_necessary ins_postchasm_warthog)
	(object_create_if_necessary ins_postchasm_tank_wraith)

	; close and power down the door leading backward to the chasm
	(device_set_position_immediate large_door_canyon_1 0)
	(device_set_power large_door_canyon_1 0)

	; messaging
	(wake play_rally_point_charlie_objective_nonblocking)
)

; editor only
(script static void fixup_ins_spiral
	(f_switch_zone_set_blocking four)
	(b40_initial_profiles blamstartingprofilepostchasm blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)

	; needed for the cave sequence, this is one of the guns needed to test the encounter
	(wake enc_ext_b_b_spiral_turrets_c)
	(wake mission_b2_bunker_navpoints)
	(wake vo_snowfield_g_intro_trigger)

	; configure object state
	(place_b4_objects_spiral_bunker) ; ensure the full object complement as if you came from tarmac

	; create marine followers to test the encounter
	; this mimics the contents of enc_ext_b_b_marines, without the hunters
	(ai_place ext_b_marines)
	(sleep 1)
	(f_add_squad_to_fireteam_followers ext_b_marines)
)

; /// rally point delta /// ;
(script static void fixup_ins_b3_start
	(f_switch_zone_set_blocking four)
	(b40_initial_profiles blamstartingprofileb3start blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)

	; lock the door bunker door behind the player
	(f_powerdown_bunker_entrance)

	; messaging
	(wake play_rally_point_delta_objective_nonblocking)
)


; /// rally point echo /// ;
(script static void fixup_ins_b4_start
	(f_switch_zone_set_blocking five)
	(b40_initial_profiles blamstartingprofileb4start blamstartingprofilerespawn)
	(f_insertion_fade_to_gameplay)

	; spawn the zig objects before the trigger so it's part of the level load
	(place_b5_zig_objects)

	; messaging
	(wake play_rally_point_echo_objective_nonblocking)
)

(script static void (b40_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_b40_respawn_async respawn)
	(wake b40_initial_profiles_async)
)

(global starting_profile sp_b40_respawn_async blamstartingprofile)
(script dormant b40_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_b40_respawn_async)
)