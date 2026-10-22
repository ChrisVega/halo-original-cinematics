(global boolean debug true)

(script static void a30_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches ins_lz) (fixup_ins_lz))
		((f_insertion_point_matches ins_mission_first) (fixup_ins_mission_first))
		((f_insertion_point_matches ins_driving_start) (fixup_ins_driving_start))
		((f_insertion_point_matches ins_cave) (fixup_ins_cave))
		((f_insertion_point_matches ins_holdouts) (fixup_ins_holdouts))
		((f_insertion_point_matches ins_cliff) (fixup_ins_cliff))
		((f_insertion_point_matches ins_rubble) (fixup_ins_rubble))
		((f_insertion_point_matches ins_river) (fixup_ins_river))
	)
)

; landing zone
(script static void fixup_ins_lz
	(f_switch_zone_set_blocking landing_zone)
	(a30_initial_profiles blamstartingprofile_lz blamstartingprofile_respawn)
	(f_cinematic_handle_intro_snap cinematics\a30\a30_intro.cinematic)
)

; mission first
(script static void fixup_ins_mission_first
	(f_switch_zone_set_blocking landing_zone)
	(a30_initial_profiles blamstartingprofile_lz blamstartingprofile_respawn)
	(f_insertion_fade_to_gameplay)

	(wake beat1_nav_loop)
	(wake nav_backtracking_loop)
;	(wake flare_rubble_hide)

	(set mark_evade true) ; current objective
)
(script static void fixup_ins_driving_start
	(f_switch_zone_set_blocking landing_zone)
	(a30_initial_profiles blamstartingprofile_cave blamstartingprofile_respawn)
	(f_insertion_fade_to_gameplay)

;	(wake flare_rubble_hide)
	(sleep_forever obj_evade)
	(sleep_forever obj_protect)
	(ai_place sq_foehammer_first)
	(wake objective_cave)
	(wake dialogue_entered_warthog)
	(wake beat1_nav_loop)
	(wake nav_backtracking_loop)

	(set mark_covend true) ; current objective
)

; cave
(script static void fixup_ins_cave
	(f_switch_zone_set_blocking underground)
	(a30_initial_profiles blamstartingprofile_cave blamstartingprofile_respawn)
	(f_insertion_fade_to_gameplay)

;	(wake flare_rubble_hide)
	(music_event sound/music/a30/mus_12_lightbridge_room_enter)
	(wake beat1_nav_loop)
	(wake nav_backtracking_loop)

	(sleep_forever obj_evade)
	(sleep_forever obj_protect)
	(set mark_searchstart true) ; current objective
	(object_create jeep_ins_bravo)
	(set jeep_global jeep_ins_bravo)
	(if (not (> (game_coop_player_count) 2))
		(begin
			(ai_place sq_marines_ins_bravo)
			(f_add_to_follower_squad sq_marines_ins_bravo)
		)
	)
)

; holdouts
(script static void fixup_ins_holdouts
	(f_switch_zone_set_blocking holdouts)
	(a30_initial_profiles blamstartingprofile_holdouts blamstartingprofile_respawn)
	(f_insertion_fade_to_gameplay)

	(wake nav_backtracking_loop)

	(f_ins_start_holdouts)


	(if (not (> (game_coop_player_count) 2))
		(begin
			(ai_place sq_marines_ins_charlie)
			(f_add_to_follower_squad sq_marines_ins_charlie)
		)
	)
)

; cliff
(script static void fixup_ins_cliff
	(f_switch_zone_set_blocking holdouts)
	(a30_initial_profiles blamstartingprofile_holdouts blamstartingprofile_respawn)
	(f_insertion_fade_to_gameplay)

;	(wake flare_rubble_trigger)
	(wake nav_backtracking_loop)
	(wake fields_nav_loop)

	(f_ins_start_holdouts)
)

; rubble
(script static void fixup_ins_rubble
	(f_switch_zone_set_blocking holdouts)
	(a30_initial_profiles blamstartingprofile_holdouts blamstartingprofile_respawn)
	(f_insertion_fade_to_gameplay)

	(wake nav_backtracking_loop)
	(wake fields_nav_loop)

	(f_ins_start_holdouts)
)

; river
(script static void fixup_ins_river
	(f_switch_zone_set_blocking holdouts)
	(a30_initial_profiles blamstartingprofile_holdouts blamstartingprofile_respawn)
	(f_insertion_fade_to_gameplay)

;	(wake flare_rubble_trigger)
	(wake nav_backtracking_loop)
	(wake fields_nav_loop)

	(f_ins_start_holdouts)
)

; when loading into the holdouts open world section at any point, after the cave
(script static void f_ins_start_holdouts
	(set global_cave_bridge_enabled true)
	(sleep_forever obj_evade)
	(sleep_forever obj_protect)
	(set mark_searchstart true) ; current objective

	;turn on lightbridge and turn off bridge control
	(device_set_position_immediate light_bridge_a 1)
	(device_set_power bridge_control 0)
)

(script static void (a30_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_a30_respawn_async respawn)
	(wake a30_initial_profiles_async)
)

(global starting_profile sp_a30_respawn_async blamstartingprofile_lz)
(script dormant a30_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_a30_respawn_async)
)
