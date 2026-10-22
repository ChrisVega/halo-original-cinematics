(global boolean debug true)

(script static void b30_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches insertion_beach_lz) (fixup_ins_beach_lz))
		((f_insertion_point_matches insertion_shaft_a_inactive) (fixup_ins_shaft_a_inactive))
		((f_insertion_point_matches insertion_shaft_b) (fixup_ins_shaft_b))
		((f_insertion_point_matches insertion_shaft_a_active) (fixup_ins_shaft_a_active))
		((f_insertion_point_matches insertion_silent_cartographer) (fixup_ins_silent_cartographer))

		; perfcheck insertion points
		((f_insertion_point_matches insertion_perf_hunterbowl) (fixup_ins_perf_hunterbowl))

		; debug insertion points
		((f_insertion_point_matches insertion_debug_hunterbowl) (fixup_ins_debug_hunterbowl))
		((f_insertion_point_matches insertion_debug_shaft_b_hunters) (fixup_ins_debug_shaft_b_hunters))
		((f_insertion_point_matches insertion_debug_shaft_a_hunters) (fixup_ins_debug_shaft_a_hunters))
		((f_insertion_point_matches insertion_debug_pelican_crash) (fixup_ins_debug_pelican_crash))
	)
)

; starting zone
(script static void fixup_ins_beach_lz
	(f_switch_zone_set_blocking set_lz_beach)
	(b30_initial_profiles rallypointalphaprofile player_starting_profile_respawn)
	(f_cinematic_handle_intro_snap cinematics\b30\b30_intro.cinematic)
)

; shaft a inactive / locked
(script static void fixup_ins_shaft_a_inactive
	(f_switch_zone_set_blocking set_shafta_inside)
	(b30_initial_profiles rallypointbravoprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(wake players_arrive_shafta)

	; narrative - music vo scripts
	(wake play_vo_door_is_locked)
	(if (= false (script_started "play_vo_move_down_beach")) (wake play_vo_move_down_beach))
	(if (= false (script_started "trigger_vo_ufo_remark")) (wake trigger_vo_ufo_remark))
	(if (= false (script_started "trigger_vo_path_valley")) (wake trigger_vo_path_valley))
	(if (= false (script_started "trigger_vo_hunter_bowl")) (wake trigger_vo_hunter_bowl))

	(wake shaft_a_inactive_placements)
	(device_set_position shaft_a_door_controled 0)

	(object_create_anew v_rally_point_bravo_warthog)
	(ai_place sq_rally_point_bravo_marines)
	(ai_player_add_fireteam_squad player0 sq_rally_point_bravo_marines)
)

; shaft b
(script static void fixup_ins_shaft_b
	(f_switch_zone_set_blocking set_shaftb_inside)
	(b30_initial_profiles blamstartingprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(device_set_power shaftb_control 0)
	(f_set_shafta_unlocked)
)

; shaft a active / unlocked
(script static void fixup_ins_shaft_a_active
	(f_switch_zone_set_blocking set_shafta_inside)
	(b30_initial_profiles rallypointcharlieprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(device_set_power shaftb_control 0)
	(f_set_shafta_unlocked)

	(wake placed_downed_pelican)
	(if (game_is_cooperative) (wake multiplayer_placement_wreckage))
)

; silent cartographer
(script static void fixup_ins_silent_cartographer
	(f_switch_zone_set_blocking set_shafta_inside)
	(b30_initial_profiles blamstartingprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(f_set_shafta_unlocked)
	(device_set_power shafta_control 0)
	(device_set_position shaftb_control 1)
	(set b_shafta_switched true)
)

; perfcheck hunterbowl
(script static void fixup_ins_perf_hunterbowl
	(f_switch_zone_set_blocking set_valley)
	(b30_initial_profiles blamstartingprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set b_shafta_switched true)
)

(script static void fixup_ins_debug_hunterbowl
	(f_switch_zone_set_blocking set_valley)
	(b30_initial_profiles blamstartingprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)
)

(script static void fixup_ins_debug_shaft_b_hunters
	(f_switch_zone_set_blocking set_shaftb_inside)
	(b30_initial_profiles blamstartingprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)
)

(script static void fixup_ins_debug_shaft_a_hunters
	(f_switch_zone_set_blocking set_shafta_beach)
	(b30_initial_profiles blamstartingprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)

	(set b_shafta_switched true)
)
(script static void fixup_ins_debug_pelican_crash
	(f_switch_zone_set_blocking set_shaftb_beach)
	(b30_initial_profiles blamstartingprofile player_starting_profile_respawn)
	(f_insertion_fade_to_gameplay)
)

(script static void (b30_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_b30_respawn_async respawn)
	(wake b30_initial_profiles_async)
)

(global starting_profile sp_b30_respawn_async rallypointalphaprofile)
(script dormant b30_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_b30_respawn_async)
)