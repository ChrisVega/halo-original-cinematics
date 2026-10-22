;====================================================================================================================================================================================================
; variables
;====================================================================================================================================================================================================
(global boolean b_debug false)							; when true, the mission and audio scripts will print status to the log

; tower gauntlet debug, use these instead of b_debug for end of mission debugging
(global boolean b_gauntlet_wave_debug false)			; when true, tower gauntlet waves print status to the log
(global boolean b_gauntlet_res_debug false)				; when true, tower gauntlet wave resurrection monitors print status to the log
(global boolean b_gauntlet_blip_debug false)			; when true, the tower gauntlet blipper
(global boolean b_gauntlet_win_debug false)				; when true, the tower gauntlet win condition script will print status to the log

(global boolean b_pick_up_destination_set false)

(global boolean b_flood_revealed false)
(global boolean b_flood_reveal_room_open false)

(global boolean b_lab_d_visited false)
(global boolean b_lab_c_visited false)
(global boolean b_mission_is_completing false)

(global boolean b_pre_flood_breadcrumb true) 			; when false, breadcrumb navpoints before the flood don't appear
(global boolean b_elevator_switches_toggle false) 		; when true, elevator switches toggle between the elevator and off-platform versions of the switch, instead of both switches remaining active at all times



(global object obj_crazymarine none)

;====================================================================================================================================================================================================
; startup script + insertion wakes
;====================================================================================================================================================================================================

(script startup c10_start
	; set up allegiences
	(ai_allegiance player human)
	(ai_allegiance sentinel human)
	(ai_allegiance player sentinel)
	(c10_insertion_point_fixups)
	(f_start_auto_save_loop)

	(if (f_insertion_point_area_pending insertion_0_swamp_a)
		(begin
			(f_play_cinematic cinematics\c10\c10_intro.cinematic)
			(wake start_mission)

			;
			(ai_place pelican)
			(wake handle_pelican_insertion)

			(vehicle_hover (ai_vehicle_get_from_spawn_point pelican/spawnpoint) true)
			(device_set_position_immediate dm_vignette_pelican_rain 1) ; ensure the pelican bay rain is dripping


			(sleep_until (= (cinematic_in_progress) false) 1)
			(cs_run_command_script pelican pelican_unload_and_go_away)
		)
	)

	(begin
		(if (f_insertion_point_area_pending insertion_1_level_a) (wake start_level_a))
		(if (f_insertion_point_area_pending insertion_preflood) (wake start_flood_revealed))
		(if (f_insertion_point_area_pending insertion_3_level_b) (wake start_level_b))
		(if (f_insertion_point_area_pending insertion_4_swamp_b) (wake start_swamp_b))
	)

	(wake c10_music_controller)
	(wake c10_rally_point_unlocks)
)

(script dormant start_mission
	; swamp_a
	(sleep_until (volume_test_players mission_start) 1)
	(submit_incident_with_custom_string_id "game_activity_begin" "c10")
	(f_hud_chapter chapter_lost)
	(wake f_obj_nonblocking_find)

	(wake set_crashed_pelican_weapons_based_on_difficulty) ; smg's spawn by default, this swaps them for shotguns on easy
	(wake swamp_a_covenant) ; wakes first enemy encounter
	(wake swamp_enc2) ; wakes second enemy encounter
	(wake lift_a_switch_monitor)
	(wake c10_music_triggers_ins_0)

	(sleep (game_ticks_from_seconds 10))
	(wake start_mission_navpoints)

)

(script dormant start_level_a
	; level_a
	(sleep_until (volume_test_players int_a_trigger) 1)

	(f_game_save)
	(print_if b_debug "starting level_a")

	(wake checkpoint_and_erase_lift_a_bottom) ; brings co-op players to the swamp
	(wake lift_a_bottom) ; wakes enemies between bottom of lift_a and the prison
	(wake lab_a_bot) ; wakes lab_a covenant encounter
	(wake crazy_marine)
	(wake level_a_navpoints)
	(wake c10_music_triggers_ins_1)
	(wake bridge_b_monitor)
)

(script dormant start_flood_revealed
	; flood_revealed
	(if (f_insertion_point_area_pending insertion_preflood) ;only wake the cinematic and prison if the player came in before the postflood insertion point
		(begin

			(wake control_table_cinematic_handler)
			(wake control_table)
		)
	)

	(sleep_forever checkpoint_and_erase_lift_a_bottom) ; remove the checkpoint script for lift_a

	(wake since_floodroom_checkpoints)
	(wake post_prison_hallway)
	(wake bay_b_revisited)
	(wake lab_a_revisited)
	(wake bay_a_revisited)
	(wake lift_b_top_placement)
	(wake c10_music_triggers_lift_b)
	(wake checkpoint_and_erase_inside_sterilizers)
	(wake flood_revealed_navpoints)
	(wake setup_level_a_changes_after_flood_reveal)
	(wake lift_b_switch_monitor)
	(wake c10_music_triggers_ins_2)
)

(script dormant start_level_b
	; level_b
	(sleep_until (volume_test_players int_lift_infector_trigger) 1)

	(f_game_save)

	(wake checkpoint_and_erase_after_broken_lightbridge_puzzle)
	(wake checkpoint_and_erase_before_final_bay)
	(wake lift_b_bottom_placement)
	(wake bay_c)
	(wake floor_b_fork_checkpoint)
	(wake lab_d_or_lab_c)
	(wake bay_d)
	(wake lab_e)
	(wake bay_e)
	(wake int_b_lift)
	(wake level_b_navpoints)
	(wake c10_music_triggers_ins_3)
	(wake bridge_e_monitor)

)

(script dormant start_swamp_b
	; swamp_b

	; we do not wait and checkpoint in the elevator shaft when using the debug insertion point
	(if (not (f_insertion_point_matches insertion_4_swamp_b))
		(begin
			(sleep_until (volume_test_players tv_cleanup_lift_d_shaft_entrance) 1) ; when the player's lift leaves the room
			(wake checkpoint_and_erase_inside_lift_d_shaft)
		)
	)

	(wake swamp_b) ; main continuation

	; navigation and objectives
	(wake swamp_b_navpoints)


	; top of lift chapter titles
	(sleep_until (volume_test_players swamp_b_trigger_initial) 1)
	(wake f_obj_nonblocking_complete_surface)
	(f_hud_chapter chapter_friends)

	(sleep_until b_pick_up_destination_set 1) ; wait for the foehammer line
	(wake f_obj_nonblocking_marines_new)
)

;====================================================================================================================================================================================================
; swamp_a
;====================================================================================================================================================================================================
(script dormant handle_pelican_insertion
	(unit_enter_vehicle_immediate player0 (ai_vehicle_get_from_spawn_point pelican/spawnpoint) "pelican_p_l05")
	(unit_enter_vehicle_immediate player1 (ai_vehicle_get_from_spawn_point pelican/spawnpoint) "pelican_p_l04")
	(unit_enter_vehicle_immediate player2 (ai_vehicle_get_from_spawn_point pelican/spawnpoint) "pelican_p_r05")
	(unit_enter_vehicle_immediate player3 (ai_vehicle_get_from_spawn_point pelican/spawnpoint) "pelican_p_r04")

	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point pelican/spawnpoint) "pelican_p_l05" false false)
	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point pelican/spawnpoint) "pelican_p_l04" false false)
	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point pelican/spawnpoint) "pelican_p_r05" false false)
	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point pelican/spawnpoint) "pelican_p_r04" false false)
)

(script command_script pelican_unload_and_go_away
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	(sleep (game_ticks_from_seconds 2.5))

	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l05")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r05")
	(sleep (game_ticks_from_seconds 0.7))
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l04")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_r04")

	; grunts in the forest will actually aggro the pelican as it flies away, interrupting their patrol.
	; actually incredibly neat, but not good since we need them to find the player.  so make everyone ignore the pelican.
	(ai_disregard ai_current_actor true)

	(sleep (game_ticks_from_seconds 3.5))
	(vehicle_hover (ai_vehicle_get_from_spawn_point pelican/spawnpoint) false)


	(cs_vehicle_speed 0.3)
	(sound_impulse_start sound\vehicles\pelican\pelican_takeoff (ai_vehicle_get ai_current_actor) 0)
	(device_set_position_immediate dm_vignette_pelican_rain 0) ; clean up pelican bay rain with the jet flare

	(cs_fly_by ps_pelican_go_away/p0)
	(cs_vehicle_speed 0.8)
	(cs_fly_by ps_pelican_go_away/p1)
	(sound_impulse_start sound\vehicles\pelican\pelican_flyby_sweetener (ai_vehicle_get ai_current_actor) 0) ; b30 plays this sweetner with the takeoff, but it seemed to match the switch
	(cs_fly_by ps_pelican_go_away/p2)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.5 (game_ticks_from_seconds 10)) ; don't scale down to the usual 1% because the night flares get too close together

	; it is important that at least 6 seconds pass between the initial scale change and the ai_erase, or the systemic audio will cut off abruptly.
	; fortunately, this sequence takes ~30 seconds so it is not remotely a concern unless someone adjusts the points.
	(cs_fly_by ps_pelican_go_away/p3)
	(cs_fly_by ps_pelican_go_away/p4)

	; play fly out sound and erase pelican
	; commented out because this is the sound of the pelican breaking the sound barrier, and foehammer stays in a holding pattern to support chief so this isn't appropriate
	;(sound_impulse_start sound\vehicles\pelican\pelican_fly_out pelican_fly_out_noise_position 0) ; that said, if you use the pelican instead of this crate, the audio cuts out when we erase.

	(ai_erase ai_current_squad)
)

(script dormant set_crashed_pelican_weapons_based_on_difficulty
	(if (= (game_difficulty_get_real) easy) ; need to use get_real here because this is easy-only.  game_difficulty_get is syntatic sugar for detecting heroic/legendary since it returns "normal" when the difficulty is set to easy.
		(begin
			; make shotguns
			(object_create_anew easy_shotgun_1)
			(object_create_anew easy_shotgun_2)

			;remove smgs
			(object_destroy blamweapon_pelicansmg1)
			(object_destroy blamweapon_pelicansmg2)
			(object_destroy blamweapon_pelicansmg3)
			(object_destroy blamweapon_pelicansmg4)
		)
	)
)

(script dormant swamp_a_covenant
	(wake play_vo_pelican_radio)

	(f_game_save)

	(ai_place sq_gr_swamp_a_covenant)
	(ai_place sq_gr_enc1_swamp_a)

	(sleep_until (volume_test_players enc_swamp_a_trigger_01) 1)
	(f_game_save)

	; first scripted encounter - fake unsc combat blows up grunts on the hillside, and the squad near the crashed spirit flees instead of fights
	(wake play_crashed_spirit_hillside_explosion)
	(wake place_swamp_a_flood_hints)
)

(global boolean b_hillside_flee_started false)
(script dormant play_crashed_spirit_hillside_explosion
	(set b_hillside_flee_started false)

	(device_set_position_immediate dm_vignette_hilltop_combat 0.5) ; this kicks off blueprint at the start.)
	(effect_new "fx/vignettes/c10/hilltop_explo/hilltop_tracers" rocketeers_tracers_position)

	; begin 2 second delay for tracer visuals, this is hardcoded in blueprint
	(sleep (game_ticks_from_seconds 0.5)) 												; a quarter second in, make the squad on the ground
	(cs_run_command_script sq_gr_swamp_a_covenant_flee cs_react_to_hillside_explosion)

	(sleep (game_ticks_from_seconds 1.5)) 												; finish 2 second dleay
	(device_set_position_immediate dm_vignette_hilltop_combat 1) 						; enter completed state
	(ai_place sq_rocketeers_grunt)														; place explosion targets

	(sleep (game_ticks_from_seconds 1))
	(f_explode_rocketeer_grunts)														; boom

	; make squads near crashed spirit flee in response to the explosion after a slight delay
	(sleep (game_ticks_from_seconds 1.25))
	(set b_hillside_flee_started true)
)



; used by the fleeing encounter
(script command_script cs_react_to_hillside_explosion
	(cs_enable_dialogue true)

	; freeze where you are, look at the hillside and shoot at the <monsters> up there
	(cs_enable_moving false)
	(cs_look true ps_crashed_spirit_look/p0)
	(cs_shoot_point true ps_crashed_spirit_look/p0)

	(sleep_until b_hillside_flee_started 1)						; wait for the boom... then stop shooting and run
	(cs_shoot false)
	(cs_enable_moving true)

	; flee to a random point to distribute the actors around the field.  if all 4 go to the same point, the radius is too small
	(ai_flee_to_point sq_dropship_grunts (f_get_random_point_in_point_set ps_crashed_spirit_flee)) ; only send the grunts fleeing, the jackal goes into a slow walk and it doesn't look great.
	(f_ai_magically_see_players ai_current_squad)	; for resuming combat after flee
)

(script static void f_explode_rocketeer_grunts
	(damage_new "objects/weapons/grenade/frag_grenade/damage_effects/frag_grenade_explosion" rocketeers_explosion_position0) ; this is what kils the grunts and applies impulse - can we spin off an invisible version and use it here instead?
	(damage_object (ai_get_object sq_rocketeers_grunt) backpack 9999)
	(sleep (game_ticks_from_seconds 0.25))
	(damage_new "objects/weapons/grenade/frag_grenade/damage_effects/frag_grenade_explosion" rocketeers_explosion_position1) ; don't move the position flags, unreal can ignore them and level design will just juggle the bodies in blam with them.

)

(script dormant swamp_enc2
	(wake swamp_enc2_entrance)
	(ai_place sq_gr_swamp_a_enc2)
	(sleep_until (volume_test_players enc_swamp_a_trigger_02) 1)
	(wake entrance_tracers_flee_vignette)

	(sleep_until (= (ai_living_count sq_gr_swamp_a_enc2) 0) 1)
	(game_save_no_timeout)
)

(global real r_entrance_grunt_1_cs_delay 1.95) ; how long before triggering the first grunt's cs script
(global real r_entrance_grunt_2_cs_delay 2.15) ; how long before triggering the second grunt's cs script
(global real r_bp_explosion_duration 2.55) ; this is the delay between the tracer machine being triggered + .5 seconds for the shade explosion + .05 for blueprint timing
(script dormant entrance_tracers_flee_vignette
	(ai_flee_to_point sq_firstlift_flee (f_get_random_point_in_point_set ps_swamp_a_entrance_flee))

	(sleep (game_ticks_from_seconds 1))

	(wake entrance_vignette_cs_timings)
	(device_set_position_immediate dm_vignette_entrance_tracers 0.5) ; 0.5 now activates vfx machines by default

	(sleep (game_ticks_from_seconds r_bp_explosion_duration))
	(sleep (game_ticks_from_seconds 0.15))
	(damage_object entranceshade body 9999)
	(damage_new "objects/weapons/grenade/frag_grenade/damage_effects/frag_grenade_explosion" turret_explosion_position)
	;(damage_new "objects/weapons/grenade/frag_grenade/damage_effects/frag_grenade_explosion" turret_explosion_position2)
	(sleep (game_ticks_from_seconds 0.35))
	(device_set_position_immediate dm_vignette_entrance_tracers 1) ; enter finished state
	;(ai_flee_to_point sq_firstlift_flee (f_get_random_point_in_point_set ps_swamp_a_entrance_flee))
)

(script dormant entrance_vignette_cs_timings
	(wake entrance_vignette_play_grunt_1)
	(wake entrance_vignette_play_grunt_2)
)

(script dormant entrance_vignette_play_grunt_1
	(sleep (game_ticks_from_seconds r_entrance_grunt_1_cs_delay))
	(cs_run_command_script sq_firstlift_fall cs_entrance_grunt_1)
)

(script dormant entrance_vignette_play_grunt_2
	(sleep (game_ticks_from_seconds r_entrance_grunt_2_cs_delay))
	(cs_run_command_script sq_firstlift_crouch cs_entrance_grunt_2)
)

	(script command_script cs_entrance_grunt_1
		(cs_enable_dialogue false)					; too many of them talking
		(cs_action ps_swamp_a_entrance_action/p0 ai_action_dive_forward)
		(sleep (game_ticks_from_seconds 0.35))
		(ai_flee_to_point ai_current_actor (f_get_random_point_in_point_set ps_swamp_a_entrance_flee))
	)

	(script command_script cs_entrance_grunt_2
		(cs_enable_dialogue false)				; too many of them talking
		(cs_action ps_swamp_a_entrance_action/p0 ai_action_warn)
		(sleep (game_ticks_from_seconds 0.35))
		(ai_flee_to_point ai_current_actor (f_get_random_point_in_point_set ps_swamp_a_entrance_flee))
	)


(script dormant swamp_enc2_entrance
	(sleep_until (volume_test_players int_a_trigger_elevator_a_arrival) 1)
	; forcing vignette machine off for tracers so they don't re-trigger on checkpoint reload
	(device_set_position_immediate dm_vignette_entrance_tracers 0)
	(device_group_set lift_a lift_a_position 0)
	(sleep_until (= (device_group_get lift_a_position) 0) 1)
	(wake f_whats_the_matter_aint_you_elevated_before)
	(f_game_save)
)

(script dormant f_whats_the_matter_aint_you_elevated_before
	; give 'em time to figure it out on their own.  and we had to share the rock.
	(sleep (game_ticks_from_seconds 12))
	; if the lift is still at the top and the player hasn't made it underground, hint is needed
	(if (and (= (device_group_get lift_a_position) 0) (not (volume_test_players tv_player_is_underground)))
		(begin ; then
			(f_unblip_all)
			(f_blip_flag navpoint_3b_lift_a_control 0)
			(sleep_until (> (device_group_get lift_a_position) 0) 1) ; turn off once the player makes it underground
			(f_unblip_all)
		)
	)
)

;====================================================================================================================================================================================================
; swamp_a flood hints - aka sasquatch sightings
;====================================================================================================================================================================================================

; these placement script(s) control when the characters spawn
; since none of these characters are to engage in combat, the spawn *points* for each character themseleves
; should each have an associated command_script in their "placement script" field that tells them what to
; do once spawned.  these command scripts should go below the placement script for clarity.
(script dormant place_swamp_a_flood_hints
	(wake place_swamp_a_flood_hints_crashsite)
	(wake place_swamp_a_flood_hints_log_incident)
)

; crashsite
(script dormant place_swamp_a_flood_hints_crashsite
	; high on the right cliff, between the flame trail and big tree before the crashed spirit
	(ai_place sq_crashsite_flood)
	(ai_disregard (ai_actors sq_crashsite_flood) true)
	(object_cannot_take_damage (ai_actors sq_crashsite_flood))

	; above crashsite, to the right just after the crashed spirit
	(ai_place sq_oom1_flood)
	(ai_disregard (ai_actors sq_oom1_flood) true)
	(object_cannot_take_damage (ai_actors sq_oom1_flood))

	; above crashsite, to the right just after the crashed spirit, a little farther down than sq_oom1
	(ai_place sq_oom2_flood)
	(ai_disregard (ai_actors sq_oom2_flood) true)
	(object_cannot_take_damage (ai_actors sq_oom2_flood))
)

(script command_script cs_crashsite_flood_elite
	(cs_ignore_obstacles true)

	(sleep (game_ticks_from_seconds 2))
	(cs_go_to ps_crashsite_flood_elite_path/p0)
	(cs_go_to ps_crashsite_flood_elite_path/p1)
	(ai_erase ai_current_squad)
)

(script command_script cs_oom1_flood_elite
	(cs_ignore_obstacles true)

	(sleep_until (volume_test_players inc_log) 1)
	(sleep (game_ticks_from_seconds 3))
	(cs_go_to ps_oom1_flood_elite_path/p0)
	(cs_go_to ps_oom1_flood_elite_path/p1)
	(ai_erase ai_current_squad)
)

(script command_script cs_oom2_flood_elite
	(cs_ignore_obstacles true)

	(sleep_until (volume_test_players inc_log) 1)
	(sleep (game_ticks_from_seconds 4))
	(cs_go_to ps_oom1_flood_elite_path/p1)
	(ai_erase ai_current_squad)
)

; log incident
(script dormant place_swamp_a_flood_hints_log_incident
	; log incident, above the jackals just after the crashsite
	(ai_place sq_tree_flood)
	(ai_disregard (ai_actors sq_tree_flood) true)
	(object_cannot_take_damage (ai_actors sq_tree_flood))

	; log incident, right of log, high in forest
	(ai_place sq_oom3_flood)
	(ai_disregard (ai_actors sq_oom3_flood) true)
	(object_cannot_take_damage (ai_actors sq_oom3_flood))
	(object_create ss_oom3_flood) ; create sound scenery object for scream
	(wake vig_oom3_flood_elite_scream)

	; log incident, end of log, near shade turret
	(ai_place sq_oom5_flood)
	(ai_disregard (ai_actors sq_oom5_flood) true)
	(object_cannot_take_damage (ai_actors sq_oom5_flood))
	(object_create ss_oom5_flood) ; create sound scenery object for scream
	(wake vig_oom5_flood_elite_scream)

	; flood hint 4 - log incident, left of log down low, jumps into forest
	; handled last here because it has a conditional placement - players in the forest could otherwise stumble upon it
	(sleep_until (volume_test_players inc5) 1)
	(ai_place sq_oom4_flood)
	(ai_disregard (ai_actors sq_oom4_flood) true)
	(object_cannot_take_damage (ai_actors sq_oom4_flood))

	; destroy sound scenery objects
	(object_destroy ss_oom3_flood)
	(object_destroy ss_oom5_flood)
)

(script command_script cs_tree_flood_elite
	(cs_ignore_obstacles true)

	(sleep_until
		(or
			(volume_test_players inc2) 									; sprint timing - don't let players get too close
			(and														; walk timing, tuned for player who either knows to look or gets lucky
				(volume_test_players inc_log)
				(objects_can_see_object (players) ai_current_squad 30)
			)
		)
	1)

	(sleep (game_ticks_from_seconds 2.0))
	(cs_walk true)
	(cs_move_towards_point ps_tree_flood_elite_path/p0 0.5)
	(ai_erase ai_current_squad)
)

(script command_script cs_oom3_flood_elite
	(cs_ignore_obstacles true)

	; these guys will move if they're not frozen first, so freeze them looking at the player
	(cs_look_player true)
	(ai_braindead ai_current_actor true)

	; after the player perceives them, pause for beat...
	(sleep_until (and (volume_test_players inc6) (objects_can_see_object (players) ai_current_squad 30)) 1)
	(set b_start_oom3_scream true) ; this is used to trigger scream sfx in c10_audio.hsc
	(sleep (game_ticks_from_seconds 2))

	; then unfreeze...
	(ai_braindead ai_current_actor false)
	(cs_look_player false)

	; and disappear into shadow
	(cs_go_to ps_oom3_flood_elite_path/p0)
	(cs_go_to ps_oom3_flood_elite_path/p1)
	(cs_go_to ps_oom3_flood_elite_path/p2)
	(ai_erase ai_current_squad)
)

(script command_script cs_oom4_flood_elite
	(cs_ignore_obstacles true)

	(sleep_until (volume_test_players inc4) 1)
	(cs_move_in_direction 180 3 0)
	(ai_erase ai_current_squad)
)

(script command_script cs_oom5_flood_elite
	(cs_ignore_obstacles true)

	(sleep_until (volume_test_players inc5) 1)
	(cs_go_to ps_oom5_flood_elite_path/p0)
	(set b_start_oom5_scream true) ; this is used to trigger scream sfx in c10_audio.hsc
	(cs_go_to ps_oom5_flood_elite_path/p1)
	(ai_erase ai_current_squad)
)

;====================================================================================================================================================================================================
; level_a
;====================================================================================================================================================================================================

(script dormant checkpoint_and_erase_lift_a_bottom
	; sleep until a player is detected on floor 1 and the elevator is exactly at the bottom
	(sleep_until (and
					(volume_test_players tv_lift_a_bottom_entrance)
					(= (device_get_position lift_a) 1)
				)
	1 )

	; then teleport all players not on floor 1 to the elevator platform
	(volume_teleport_players_not_inside tv_lift_a_bottom_teleport_volume flag_cleanup_lift_a_bottom_teleport_location)

	; then, erase the enemies in the swamp above
	(wake kill_all_swamp_a)

	; and finally, checkpoint
	(game_save_no_timeout)
)

(script dormant kill_all_swamp_a
	(ai_erase sq_gr_swamp_a_covenant)
	(ai_erase sq_gr_enc1_swamp_a)
	(ai_erase sq_rocketeers_grunt)
	(ai_erase sq_crashsite_flood)
	(ai_erase sq_oom1_flood)
	(ai_erase sq_oom2_flood)
	(ai_erase sq_tree_flood)
	(ai_erase sq_oom3_flood)
	(ai_erase sq_oom5_flood)
	(ai_erase sq_oom4_flood)
	(ai_erase sq_gr_swamp_a_enc2)
)

(script dormant lift_a_bottom
	(sleep_until (volume_test_players lift_a_bottom_trigger) 1)

	(ai_place sq_gr_lift_a_bottom)
	(ai_place sq_gr_bay_a_bottom)
)

(script dormant lab_a_bot
	(sleep_until (volume_test_players bay_a_lab_a_bot_trigger) 1)
	(f_game_save)
	(ai_place sq_gr_lab_a_bottom)
	;(wake play_music_lab_a_exit)
	(wake first_floor_checkpoints)
)

(script command_script cs_stand_there___menacingly
	(sleep_until false (game_ticks_from_seconds 9999)); wait forever so they don't pop, don't show up on tracker, etc
)


(script dormant first_floor_checkpoints
	(sleep_until (volume_test_players hall_d_bottom_trigger) 1)
	(f_game_save)
	(sleep_until (volume_test_players bay_b_trigger) 1)
	(f_game_save)
	(sleep_until (volume_test_players control_table_cinematic_trigger) 1)
	(f_game_save)
)

(script dormant since_floodroom_checkpoints
	(sleep_until (volume_test_players control_table_trigger) 1)
	(f_game_save)
	(sleep (game_ticks_from_seconds 60))
	(sleep_until (not (volume_test_players control_table_trigger)) 1)
	(f_game_save)
	(sleep_until (volume_test_players bay_b_trigger) 1)
	(f_game_save)
)

(script dormant crazy_marine
	(sleep_until (volume_test_players crazy_marine_trigger) 1)
	(ai_place sq_lab_b_bot_crazymarine)
	(set obj_crazymarine (ai_get_object sq_lab_b_bot_crazymarine))
	(unit_set_maximum_vitality sq_lab_b_bot_crazymarine 12 0)
	(unit_set_current_vitality sq_lab_b_bot_crazymarine 12 0)

	; this contains all of crazy marine's custom animations and dialogue
	; if thespian kills this actor, body cleanup is handled in the last line of the thespian performance script
	(thespian_performance_setup_and_begin "tp_crazy_marine" "" 1)

	(sleep_until
		(or
			(= (ai_living_count sq_lab_b_bot_crazymarine) 0)
			b_flood_revealed
		)
	1)
	(object_create skull_thatsjustwrong)

	; wait until players are away before removing his body
	(sleep_until (and (< 10 (objects_distance_to_object (players) obj_crazymarine)) (not (objects_can_see_object (players) obj_crazymarine 45))) 1)
	(object_destroy obj_crazymarine)
)

;====================================================================================================================================================================================================
; flood_revealed
;====================================================================================================================================================================================================

(script dormant control_table_cinematic_handler
	(sleep_until (volume_test_players control_table_cinematic_trigger) 1)
	(f_unblip_all) ; remove navpoints before the cinematic plays, otherwise it lingers there on the screen

	; ensure the bridge is off so it doesn't block the combat movie - the cutscene checkpoints so this needs to be in before the checkpoint for feb ur.
	(device_group_set_immediate bridge_b_position 0)

	; play the cinematic and load the level_a zone set
	(f_switch_zone_set_blocking level_a) ; access to the swamp_a bsp is now restricted, so unload it, and load the elevator_b bsp
	(f_play_cinematic cinematics\c10\c10_reveal.cinematic ps_post_reveal_cine)

	; everything done after the cinematic ends needs to go from this static so the insertion point can make use of it... except the chapter title, since it has an implicit sleep.
	(control_table_post_cutscene)

	; chapter title should pop when the cinematic ends, but the objective needs to wait until the doors start opening to let tension build
	(f_hud_chapter chapter_flood)
)

(script static void control_table_post_cutscene
	; swap out the standard door for the bursting door after the cutscene so the flood can break through it later.
	(object_destroy dm_prison_entrance_cinematic)
	(object_create_anew control_door_bashed_a_burst)

	; notify the blueprint layer the cutscene is over so bp-only things can respond to the state change
	(wake control_table_vignette_trigger)
)

; this brings the lights up after the cutscene
(script dormant control_table_vignette_trigger
	(device_set_position_immediate dm_vignette_flood_reveal 0.5)
	; (print_if (= (device_get_position dm_vignette_flood_reveal) 0.5) "dm_vignette_flood_reveal fired")
)

; this is the primary prison encounter script.  please do not add sleeps here without design review, or you'll wreck the timing
(script dormant control_table
	(sleep_until (volume_test_players control_table_trigger) 1)
	(set b_flood_revealed true)

	; clean up and setup
	(sleep_forever play_vo_pelican_radio) ; stops pelican radio vo, no longer possible to get back to swamp_a
	(object_destroy biped_marine_3) ; removes marine corpse outside of control table room

	; post cutscene time to look around and loot
	(wake prison_teaser_squad)				; draw the player to the table with the motion tracker
	(sleep (game_ticks_from_seconds 6))		; calm before the storm
	(set s_music_trigger_c10 90) 			; music rises
	(sleep (game_ticks_from_seconds 7))     ; wait for the crash

	; begin waves
	(f_prison_spawn_wave_1)
	(f_prison_wait_for_wave_clear_with_spacing 2.5)

	(f_prison_spawn_wave_2)
	(f_prison_wait_for_wave_clear_with_spacing 2.5)

	(f_prison_spawn_wave_3)
	(f_prison_wait_for_wave_clear_with_spacing 2.5) ; prison final wave adds a little of its own spacing too

	(set s_music_trigger_c10 100)
	(f_prison_spawn_wave_final)
	(wake c10_music_trigger_11)

	; wait until the door is open, then a beat, then pop the objective with a nav (which is tied to the bool)
	(sleep (game_ticks_from_seconds 4.5)) ; door is tuned for a 4 second open in content, so aim here is a .5 -> 1 second padding after the door before objective/nav
	(wake f_obj_nonblocking_escape)
	(set b_flood_reveal_room_open true) ; used by nav in the hallway, also used to place the encounter
)

(script dormant prison_teaser_squad
	; place the squad below the table
	(ai_place sq_prison_teaser)

	; mark them disposable after the first door opens in case the new spawns need them
	(sleep_until (= (device_get_position control_door_b) 1) 1)
	(ai_disposable sq_prison_teaser true)

	; and erase them if the player ever leaves the table (because they will no longer be able to see them)
	(sleep_until (not (volume_test_players tv_prison_teaser)) 1)
	(ai_erase sq_prison_teaser)
)

; ///////////////////////////////////////////////
; prison wave settings - configures time between waves
; ///////////////////////////////////////////////
(global short s_prison_wave_timeout 30)

; waits for clear, using timeouts, with optional additional spacing
(script static void (f_prison_wait_for_wave_clear_with_spacing (real r_additional_wave_spacing))
	(sleep_until (<= (ai_living_count sq_gr_prison_b_infection) 20) 1 (game_ticks_from_seconds s_prison_wave_timeout))
	(sleep_until (<= (ai_living_count sq_gr_prison_b_infection) 10) 1 (game_ticks_from_seconds s_prison_wave_timeout))
	(sleep (game_ticks_from_seconds r_additional_wave_spacing))
)

; ///////////////////////////////////////////////
; prison wave spawns - configures what's in each wave
; ///////////////////////////////////////////////

(script static void f_prison_spawn_wave_1
	(device_set_position control_door_b 1)
	(ai_place sq_first_infection)
	(cs_run_command_script sq_first_infection cs_swarm_into_prison_1st)

	; no heroic or legendary-only behavior
)

(script static void f_prison_spawn_wave_2
	; door, all difficulties
	(device_set_position door_reveal_3 1)
	(ai_place sq_right_room_infection2)
	(cs_run_command_script sq_right_room_infection2 cs_swarm_into_prison_2nd)

	; both vents on same side as door, heroic and legendary
	(if (or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
	 	)
		(begin
			(sleep (game_ticks_from_seconds 1.5))
			(ai_place sq_vent_1_infection)
			(ai_place sq_vent_3_infection)
		)
	)

	; no legendary-only behavior
)

(script static void f_prison_spawn_wave_3
	; door, all difficulties
	(device_set_position door_reveal_2 1)
	(ai_place sq_left_room_infection)
	(cs_run_command_script sq_left_room_infection cs_swarm_into_prison_3rd)

	; both vents on same side as door, heroic and legendary
	(if (or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
	 	)
		(begin
			(sleep (game_ticks_from_seconds 1.5))
			(ai_place sq_vent_2_infection)
			(ai_place sq_vent_4_infection)
		)
	)

	; opposite door, legendary only
	(if (= (game_difficulty_get) legendary)
		(begin ; then (legendary)
			(sleep (game_ticks_from_seconds 2.5)) ; let the original door and vent get clear
			(device_set_position door_reveal_4 1)
			(ai_place sq_right_room_infection)
			(cs_run_command_script sq_right_room_infection cs_swarm_into_prison_4th)
		)
	)
)

(script static void f_prison_spawn_wave_final
	; on legendary, blow open the old cinematic door first
	(if (= (game_difficulty_get) legendary)
		(begin ; then (legendary)
			(device_set_position door_reveal_1 1)
			(ai_place sq_last_flood_extra)
			(ai_place sq_left_room_infection2)
			(cs_run_command_script sq_left_room_infection2 cs_swarm_into_prison_5th) ; have the swarms push against the door for effect

			; then, wait for the door to open...
			(sleep (game_ticks_from_seconds 4))
			(cs_run_command_script sq_last_flood_extra cs_elites_enter_extra) ; and have the combat forms push through
			;(sleep (game_ticks_from_seconds 0.5)) ; and give the usual door a beat of padding before opening
		)
		(begin ; else (easy - heroic)
			(sleep (game_ticks_from_seconds 3.5)) ; when it's only one door, wait a little longer than usual before opening final door to give it some weight
		)
	)

	(device_set_position control_door_bashed_a_burst 1)
	(ai_place sq_gr_prison_last_wave)
	(wake prison_wave_final_short_pause_before_enter)

)

(script dormant prison_wave_final_short_pause_before_enter
	(sleep (game_ticks_from_seconds 5)) ; wait 4 for the door and 1 extra one so the extra squad enters at the same time
	(cs_run_command_script sq_last_flood_elite cs_elites_enter)
)

; ///////////////////////////////////////////////
; prison wave command scripts
; ///////////////////////////////////////////////

(script command_script cs_swarm_into_prison_1st
	(cs_swarm_to ps_prison_flood_swarm_points/p0 2)
	(f_ai_magically_see_players ai_current_squad)
)

(script command_script cs_swarm_into_prison_2nd
	(cs_swarm_to ps_prison_flood_swarm_points/p1 2)
	(f_ai_magically_see_players ai_current_squad)
)

(script command_script cs_swarm_into_prison_3rd
	(cs_swarm_to ps_prison_flood_swarm_points/p2 2)
	(f_ai_magically_see_players ai_current_squad)
)

(script command_script cs_swarm_into_prison_4th
	(cs_swarm_to ps_prison_flood_swarm_points/p3 2)
	(f_ai_magically_see_players ai_current_squad)
)

 (script command_script cs_swarm_into_prison_5th
	(cs_swarm_to ps_prison_flood_swarm_points/p4 2)
	(f_ai_magically_see_players ai_current_squad)
)

(script command_script cs_elites_enter
	(cs_go_to ps_prison_elites_enter_room/p0)
)

(script command_script cs_elites_enter_extra
	(cs_go_to ps_prison_elites_enter_room/p1)
)

(script command_script cs_elites_enter_bay_e_0
	(cs_ignore_obstacles true)
	(cs_go_to ps_bay_e_elites_enter_room/p1)
	(cs_go_to ps_bay_e_elites_enter_room/p0)
	(cs_abort_on_alert true)
	(cs_go_to ps_bay_e_elites_guard/p0)
)

(script command_script cs_elites_enter_bay_e_1
	(cs_ignore_obstacles true)
	(cs_go_to ps_bay_e_elites_enter_room/p1)
	(cs_go_to ps_bay_e_elites_enter_room/p0)
	(cs_abort_on_alert true)
	(cs_go_to ps_bay_e_elites_guard/p1)
)

(script command_script cs_elites_enter_bay_e_2
	(cs_ignore_obstacles true)
	(cs_go_to ps_bay_e_elites_enter_room/p1)
	(cs_go_to ps_bay_e_elites_enter_room/p0)
	(cs_abort_on_alert true)
	(cs_go_to ps_bay_e_elites_guard/p2)
)

(script command_script cs_elites_enter_bay_e_3
	(cs_ignore_obstacles true)
	(cs_go_to ps_bay_e_elites_enter_room/p1)
	(cs_go_to ps_bay_e_elites_enter_room/p0)
	(cs_abort_on_alert true)
	(cs_go_to ps_bay_e_elites_guard/p3)
)


; ///////////////////////////////////////////////
; level-a after prison
; ///////////////////////////////////////////////
(script dormant post_prison_hallway
	(if (f_insertion_point_area_pending insertion_preflood) ; only place flood in the hallway if the player came in from before the cutscene
		(begin
			(sleep_until b_flood_reveal_room_open 1)
			(sleep_until (volume_test_players control_table_b_trigger) 1)
			(ai_place sq_gr_bay_b2_flood)
		)
	)
)

(script dormant bay_b_revisited
	; start playfighting, the ai task will move to real fighting once the player actually enters
	(sleep_until (and
					(volume_test_players bay_b_trigger_playfight)
					(= b_flood_revealed true)
				)
	1 )

	(ai_place sq_gr_bay_b1_flood)
	(ai_place sq_gr_bay_b_covenant)

	; combat movie, so don't get distracted by the player until everyone's done
	(ai_prefer_target_team sq_gr_bay_b1_flood covenant)
	(ai_prefer_target_team sq_gr_bay_b_covenant flood)

	; when the player actually enters bay b...
	(sleep_until (volume_test_players bay_b_trigger) 1)

	; mark prison squads as disposable so the garbage collector can clean them up once all co-op players are gone
	(ai_disposable sq_gr_prison_flood true)
)

(script dormant lab_a_revisited
	(sleep_until (and
					(or (volume_test_players hall_c_top_trigger)
						(volume_test_players hall_c_bottom_trigger)
					)
					(= b_flood_revealed true)
				)
	1 )

	(ai_place sq_gr_lab_a_floodelite)
	(ai_place sq_gr_lab_a_infection)
)

(script dormant bay_a_revisited
	(sleep_until (and
					(or
						(volume_test_players hall_b_bottom_infector_trigger)
						(volume_test_players hall_b_top_infector_trigger)
					)
					(= b_flood_revealed true)
				)
	1 )

	(ai_place sq_gr_tinylabs_flood)
	(ai_place sq_gr_bay_a_flood)
	(ai_place sq_gr_bay_a_covenant)

	; keep the encounter from getting overwhelming by making the covie eaters want to eat the covies, and make everyone else want to eat the spartans.
	; this is most important for the infection forms not getting stuck under the geo if the player heads to the falling lift.
	(ai_prefer_target_team sq_bay_a_bot1_floodelite player) ; spartan eater flood target players
	(ai_prefer_target_ai sq_gr_bay_a_flood_covie_eaters sq_gr_bay_a_jump_down true) ; covie eater flood target jumpdown grunts first
	(ai_prefer_target_ai sq_gr_bay_a_covenant sq_gr_bay_a_flood_covie_eaters true) ; but all covenant prefer flood

	(sleep_until (and
					(volume_test_players tv_bay_a_revisted)
					(= b_flood_revealed true)
				)
	1 )

	; after the jumpdown squad is dead, make the covie eaters attack the ones on the ledge
	(sleep_until (= (ai_nonswarm_count sq_gr_bay_a_jump_down) 0) 1)
	(ai_prefer_target_ai sq_gr_bay_a_flood_covie_eaters sq_gr_bay_a_covenant true) ; pivot covie eater focus to jackals up top
	(ai_magically_see_object sq_gr_bay_a_flood_covie_eaters sq_gr_bay_a_covenant)
)

;====================================================================================================================================================================================================
; flood_revealed - level changes - changes to level a doors and devices that occur after flood is revealed
;====================================================================================================================================================================================================

(script dormant setup_level_a_changes_after_flood_reveal
	(sleep_until (= b_flood_revealed true) 1)

	(device_group_set_immediate doors_flood_reveal_power 1)
	(wake replace_elevator_a_with_falling_elevator)
	(wake prevent_backtracking_after_flood_reveal)

	(ai_erase sq_carnage_infection_form) ; vignette moment on the way in, just better to save the ai budget here.
)

(script dormant replace_elevator_a_with_falling_elevator
	(object_destroy lift_a) ; remove the normal lift that the player used to go down
	(object_destroy lift_a_cont_b) ; remove the normal lift control panel
	(object_destroy lift_a_cont_b_offplat) ; remove the normal lift control panel that's off the platform

	(object_create lift_a_falling) ; create the falling lift
	(object_create lift_a_falling_control_offplat)
	(device_set_power lift_a_falling_control_offplat 1)

	; trigger ambush and music when lift_a_falling reaches final position
	(sleep_until ( = (device_group_get lift_a_falling_position) 1) 1) ; this gets when the button is pressed, but the vignette is in blueprint so haloscript can't see it and needs a manual wait.
	(wake lift_a_falling_switch_monitor_vignette)
	(sleep (game_ticks_from_seconds 5)) ; wait until lift vignette is done playing
	(set s_music_trigger_c10 120)
)

(script dormant prevent_backtracking_after_flood_reveal
	; bay b
	(device_group_set_immediate bridge_b_position 0) ; ensure the bridge is off so it doesn't block the combat movie.  use the position and let the bridge monitor update the postion
	;(device_set_power post_helmet_door_2 0) ; crazy marine lower floor, so there are only valid exits from bay b

	; prevent backtracking to lab a after entering bay a (only leaves path to (trick) elevator_a or shotgun/sterilizer rooms)
	; (device_one_sided_set post_lifta_door_1 true) ; handled in content
	(device_one_sided_set post_lifta_door_2 true)

	; if the player jumps down in bay a on the way back to the false elevator without activating this bridge, they will have to backtrack to the prison to get back on the 2nd floor.
	; since the flood is putting a lot of pressure on the player, it's easy to forget, so we should just enable automatically.  this should also increase the chance the player
	; sees the falling elevator instead of directly finding the shotgun room and missing the vignette.
	(device_set_power bridge_a 1)
	(device_set_position bridge_a 1)
)

;====================================================================================================================================================================================================
; level_b
;====================================================================================================================================================================================================

(script dormant kill_all_level_a
	(ai_erase sq_gr_lift_a_bottom)
	(ai_erase sq_gr_bay_a_bottom)
	(ai_erase sq_gr_lab_a_bottom)
	(ai_erase sq_carnage_infection_form)
	(ai_erase sq_gr_lab_b_bot_crazymarine)
	(ai_erase sq_vent_1_infection)
	(ai_erase sq_vent_2_infection)
	(ai_erase sq_vent_3_infection)
	(ai_erase sq_vent_4_infection)
	(ai_erase sq_gr_bay_b2_flood)
	(ai_erase sq_gr_bay_b1_flood)
	(ai_erase sq_gr_bay_b_covenant)
	(ai_erase sq_gr_lab_a_floodelite)
	(ai_erase sq_gr_lab_a_infection)
	(ai_erase sq_gr_tinylabs_flood)
	(ai_erase sq_gr_bay_a_flood)
	(ai_erase sq_gr_bay_a_covenant)

	; these are the top of lift_b and should only be erased after the player steps into bay_c
	(sleep_until (volume_test_players int_lift_infector_trigger) 1)
	(sleep_forever lift_b_top_placement) ; there's a checkpoint waiting in this script naturally tha we don't want to fire if these get erased, which is likely
	(ai_erase sq_gr_lift_b_floodelite)
	(ai_erase sq_gr_lift_b_infection_top)
)

(script dormant checkpoint_and_erase_inside_sterilizers
	; wait until one player enters the sterilizer room after the shotgun hallway
	(sleep_until (volume_test_players tv_cleanup_sterilizer_midpoint) 1)

	; this is emotionally the end of first floor, so check for achievement here.
	; yes, there is technically a room left, but it's a continuous elevator shaft to level.
	; so favor the player here.
	(achievement_hitless_run_check)

	; set the respawn profile so co-op players respawn with shotguns from this point forward
	(player_set_profile blamstartingprofile_respawn_b)

	; then teleport all players not in the volume past the one-way door for co-op
	(volume_teleport_players_not_inside tv_cleanup_sterilizer_teleport_volume flag_cleanup_sterilzer_teleport_location)

	; close and unpower the door behind the players so no one can backtrack
	(device_set_position_immediate bsp1_device_22 0)
	(device_set_power bsp1_device_22 0)

	; and finally, force save here.
	(game_save_immediate)

	; erase all squads on level_a after a couple seconds so they don't immediately disappear on the motion tracker
	(sleep (game_ticks_from_seconds 4))
	(wake kill_all_level_a)
)

(script static void achievement_hitless_run_check
	(if (f_insertion_point_matches insertion_0_swamp_a)
		(begin
			(if (player_has_never_taken_damage player0)
				(submit_incident_with_cause_player "has_not_been_hit" player0)
			)
			(if (player_has_never_taken_damage player1)
				(submit_incident_with_cause_player "has_not_been_hit" player1)
			)
			(if (player_has_never_taken_damage player2)
				(submit_incident_with_cause_player "has_not_been_hit" player2)
			)
			(if (player_has_never_taken_damage player3)
				(submit_incident_with_cause_player "has_not_been_hit" player3)
			)
		)
	)
)

(script dormant lift_b_top_placement
	(sleep_until (volume_test_players int_lift_top_placement_trigger) 1)
	(ai_place sq_gr_lift_b_floodelite)
	(ai_place sq_gr_lift_b_infection_top)
	(sleep_until (= (ai_living_count sq_gr_lift_b_floodelite) 0) 1)
	(f_game_save)
)

(script dormant lift_b_bottom_placement
	; break door when the player is riding the elevator
	(if (not (f_insertion_point_matches insertion_3_level_b)) ;this insertion point is past the elevator ride so dont spawn the encounter is in the elevator shaft
		(begin
			(ai_place sq_gr_lift_b_infection)
			;(ai_place sq_gr_lift_b_infection) ; double spawn looks *incredible*
			(ai_place sq_gr_lift_b)
		)
	)

	(sleep_until (= (ai_living_count sq_gr_lift_b) 0) 1)
	(game_save_no_timeout) ; use no timeout and don't bother checking the infectors.
)

(script dormant bay_c
	(wake bay_c_marines_vignette)
	(sleep_until (volume_test_players int_b_bay_a_trigger) 1)
	(f_game_save)
	(ai_place gr_bay_c_flood)

	(sleep 1)
	; it's no fun when the ranged unit one-shots the marines, so let the melee and infectors have at 'em first
	(ai_prefer_target_team gr_bay_c_flood_melee human)
	(ai_prefer_target_team gr_bay_c_flood_ranged player)

	; don't let the infectors leave the wall early
	(ai_set_blind gr_bay_c_infection true)
	(ai_set_deaf gr_bay_c_infection true)
	(sleep_until (volume_test_players int_lift_infector_trigger1) 1)
	(sleep (game_ticks_from_seconds 2.5))
	(ai_set_blind gr_bay_c_infection false)
	(ai_set_deaf gr_bay_c_infection false)

	(sleep_until (= (ai_living_count gr_bay_c_flood) 0) 1)
	(f_game_save)
)

(global boolean b_player_has_entered_bay_c false)
(script dormant bay_c_marines_vignette
	; without this, if the player gets close enough to trigger the door while fighting the elevator_b enemies, they will miss the marines
	(wake bay_c_entrance_monitor)

	; wait until chief starts to open the door to the bay
	(sleep_until (> (device_get_position bsp1_device_24) 0) 1)

	; then, open the one-way door to let the marines in and leave it open...
	(device_closes_automatically_set bsp3_device_21 false) ; make the one-sided door not operate automatically
	(device_set_position bsp3_device_21 1) ; start opening the one-sided door to let marines in

	; wait until the player is in the room and the door is mostly open before placing marines so they don't get caught on it
	(sleep_until (and b_player_has_entered_bay_c (>= (device_get_position bsp3_device_21) .8)) 1)
	(ai_place gr_bay_c_marines)

	(sleep 1)
	(f_ai_set_integrated_flashlight gr_bay_c_marines true)

	; don't let the flood eat the marines while they are running off the ledge,
	; and don't let the player kill the melee guys
	(ai_disregard (ai_actors sq_bay_c_marines) true)
	(ai_cannot_die sq_bay_c_jumpers true)

	; it takes 6.5 seconds for the marines to walk from their spawn to the bay floor...
	; so wait a few seconds for the marines to get inside the bay and then allow the door to close automatically again
	; allow the melee flood to start targeting the marines at this point
	(sleep (game_ticks_from_seconds 3))
	(device_closes_automatically_set bsp3_device_21 true)

	; then wait until the marines hit the floor, then make sure the marines fight everyone and get eaten
	(sleep (game_ticks_from_seconds 3.5))
	(ai_disregard (ai_actors sq_bay_c_marines) false)
	(units_set_current_vitality (ai_actors sq_bay_c_marines) 10 0)

	; give the melee units 3 more seconds to kill the marines, then call everyone for dinner
	(sleep (game_ticks_from_seconds 3))
	(ai_prefer_target_team gr_bay_c_flood human)

	; peaceful rest awaits ye jumper whosoever hath completed your mission
	(sleep_until (= (ai_living_count sq_bay_c_marines) 0) 1)
	(ai_cannot_die sq_bay_c_jumpers false)
)

(script dormant bay_c_entrance_monitor
	(sleep_until (volume_test_players tv_lightbridge_obj) 1)
	(set b_player_has_entered_bay_c true)
)

(script dormant floor_b_fork_checkpoint
	(sleep_until (or
		(volume_test_players int_b_hall_a)
		(volume_test_players int_b_hall_b_trigger_b)
		(volume_test_players int_b_hall_b_trigger))
	1)
	(f_game_save)
	(wake int_b_hall_a_one_way_checkpoint)
	(sleep_until (or
		(volume_test_players int_b_hall_e_continuousspawner_trigger2)
		(volume_test_players int_bay_d))
	1)
	(f_game_save)
	(sleep_until (or
		(volume_test_players int_b_hall_f_trigger_b)
		(volume_test_players int_b_hall_f_trigger))
	1)
	(f_game_save)
	(sleep_until (or
		(volume_test_players int_b_hall_g_trigger_b)
		(volume_test_players int_b_hall_g_trigger))
	1)
	(f_game_save)
	(sleep_until (= (device_get_power bridge_e) 1) 1)
	(f_game_save)
	(sleep_until (volume_test_players int_b_lift_d_trigger)	1)
	(f_game_save)
	(sleep_until (= (not (device_group_get lift_d_position)) 1) 1)
	(f_game_save)
)

(script dormant int_b_hall_a_one_way_checkpoint
	(sleep_until (volume_test_players int_b_hall_a_b) 1)
	(if (not (= (ai_living_count sq_gr_lab_d) 0))
		(f_game_save)
	)
)

(script dormant lab_d_or_lab_c
	(sleep_until (or (volume_test_players int_b_hall_a_trigger_b)
					 (volume_test_players int_b_hall_a_trigger)
					 (volume_test_players int_b_hall_b_trigger_b)
					 (volume_test_players int_b_hall_b_trigger)) 1)
	(cond
		((and (or (volume_test_players int_b_hall_a_trigger_b)
				  (volume_test_players int_b_hall_a_trigger))
			  (= b_lab_d_visited false))
		 (wake int_b_lab_d))
		((and (or (volume_test_players int_b_hall_b_trigger_b)
				  (volume_test_players int_b_hall_b_trigger))
			  (= b_lab_c_visited false))
		 (wake int_b_lab_c))
	)
)

(script dormant int_b_lab_d
	(ai_place sq_gr_tiny_lab_top)
	(ai_place sq_gr_tiny_lab_bot)
	(ai_place sq_gr_lab_d)

	; trigger an explosion at the elbow of the corridor
	(set b_lab_d_visited true)

	(if (= b_lab_c_visited false)
		(begin
			(sleep_until (or (volume_test_players int_b_hall_b_trigger_b)
							 (volume_test_players int_b_hall_b_trigger)) 1)
			(wake int_b_lab_c)))
)

(script dormant int_b_lab_c
	(ai_place sq_gr_lab_c)

	(set b_lab_c_visited true)

	(if (= b_lab_d_visited false)
	(begin
		(sleep_until (or (volume_test_players int_b_hall_a_trigger_b)
						 (volume_test_players int_b_hall_a_trigger)) 1)
		(wake int_b_lab_d)))
)

(script dormant bay_d
	(sleep_until (or (volume_test_players int_b_hall_e_infector_doors1_trigger)
					 (volume_test_players int_b_hall_c_trigger)
					 (volume_test_players int_b_hall_c_trigger_b)) 1)
	(ai_place sq_gr_tinylab_e_f)
	(ai_place sq_gr_bay_d)
)

(script command_script cs_swarm_into_tinylab_e_f
	(cs_swarm_to ps_tinylab_e_f_enter/p0 1)
	(f_ai_magically_see_players ai_current_squad)
)

(script dormant lab_e
	(sleep_until (or (volume_test_players int_b_hall_f_trigger)
					 (volume_test_players int_b_hall_f_trigger_b)) 1)
	(ai_place sq_gr_tinylab_l_m)
	(ai_place sq_gr_lab_e_flood)

	; stop lab_d or lab_c script since it could still be running (waiting for the player to backtrack to the other side of bay_c)
	(sleep_forever int_b_lab_c)
	(sleep_forever int_b_lab_d)

	; the checkpoint should be stopped as the backwards lab_c is stopped as well
	(sleep_forever int_b_hall_a_one_way_checkpoint)
)

(script command_script cs_swarm_into_tinylab_l_m
	(cs_swarm_to ps_tinylab_l_m_enter/p0 1)
	(f_ai_magically_see_players ai_current_squad)
)

(script dormant bay_e
	(sleep_until (or (volume_test_players int_b_hall_g_trigger)
					 (volume_test_players int_b_hall_g_trigger_b)) 1)
	(ai_place sq_gr_bay_e)

	(sleep_until (or
					(= (device_group_get bridge_e_position) 1)
					(volume_test_players tv_bay_e_bridgespawn)) 1)
	(ai_place sq_gr_bay_e_bridge)

	(sleep_until (and
					(= (ai_living_count sq_gr_bay_e) 0)
					(= (ai_living_count sq_gr_bay_e_bridge) 0)) 1)
	(f_game_save) ; don't use no timeout since we're about to hit the bottom of the lift
)


(script dormant checkpoint_and_erase_after_broken_lightbridge_puzzle
	; wait until one player enters the lab after the broken lightbridge puzzle
	(sleep_until (volume_test_players tv_cleanup_post_broken_lightbridge_lab_entrance) 1)

	; then teleport all players not in volume past the one-way door for co-op
	(ponr_player_not_in_tv_tele
		tv_cleanup_post_broken_lightbridge_teleport_volume
		flag_cleanup_post_broken_lightbridge_teleport_location0
		flag_cleanup_post_broken_lightbridge_teleport_location1
		flag_cleanup_post_broken_lightbridge_teleport_location2
		flag_cleanup_post_broken_lightbridge_teleport_location3
	)

	; then erase all squads the player has left behind, since players cannot backtrack
	(ai_erase sq_gr_lift_b)
	(ai_erase sq_gr_lift_b_infection)
	(ai_erase sq_gr_tiny_lab_top)
	(ai_erase sq_gr_tiny_lab_bot)
	(ai_erase sq_gr_lab_d)

	; close the one-way door behind the players - set to one-sided so it doesn't respond to ai, and close immediately so co-op can't backtrack
	(device_one_sided_set bsp3_device_21 true)
	(device_set_position_immediate bsp3_device_21 0)

	(f_game_save)

	; wait a couple seconds and then erase the squad in the previous bay so they don't immediately disappear on the motion tracker.
	(sleep (game_ticks_from_seconds 4))
	(ai_erase gr_bay_c)
)

(script static void (ponr_player_not_in_tv_tele (trigger_volume tv) (cutscene_flag f_player0) (cutscene_flag f_player1) (cutscene_flag f_player2) (cutscene_flag f_player3))
		;check if player 0 needs to teleported
	(if
		(not
			(volume_test_object tv player0)
		)
		;then
		(begin
			(print_if b_debug "teleporting player 0")
			(object_teleport player0 f_player0)
		)
	)

	;check if player 1 needs to teleported
	(if
		(not
			(volume_test_object tv player1)

		)
		;then
		(begin
			(print_if b_debug "teleporting player 1")
			(object_teleport player1 f_player1)
		)
	)
	;check if player 2 needs to teleported
	(if
		(not
			(volume_test_object tv player2)
		)
		;then
		(begin
			(print_if b_debug "teleporting player 2")
			(object_teleport player2 f_player2)
		)
	)
	;check if player 3 needs to teleported
	(if
		(not
			(volume_test_object tv player3)
		)
		;then
		(begin
			(print_if b_debug "teleporting player 3")
			(object_teleport player3 f_player3)
		)
	)

)

(script dormant checkpoint_and_erase_before_final_bay
	; wait until one player enters the lab after the broken lightbridge puzzle
	(sleep_until (volume_test_players tv_cleanup_pre_final_bay_bay_entrance) 1)

	; then teleport all players not in volume past the one-way door for co-op
	(ponr_player_not_in_tv_tele
		tv_cleanup_pre_final_bay_teleport_volume
		flag_cleanup_pre_final_bay_teleport_location0
		flag_cleanup_pre_final_bay_teleport_location1
		flag_cleanup_pre_final_bay_teleport_location2
		flag_cleanup_pre_final_bay_teleport_location3
	)

	; then erase all squads the player has left behind, since players cannot backtrack
	(ai_erase sq_gr_lab_c)
	(ai_erase sq_gr_tinylab_e_f)
	(ai_erase sq_gr_bay_d)
	(ai_erase sq_gr_tinylab_l_m)

	; close the one-way door behind the players - leave it powered in case of any bugs, and close immediately so co-op can't backtrack
	(device_set_position_immediate bsp4_device_16 0)

	(f_game_save)

	; wait a couple seconds and then erase the squad in the previous lab so they don't immediately disappear on the motion tracker.
	(sleep (game_ticks_from_seconds 4))
	(ai_erase sq_gr_lab_e_flood)
)

(script dormant checkpoint_and_erase_inside_lift_d_shaft
	; sleep until a player hits the bottom of the elevator shaft (high enough, must use elevator)
	(sleep_until (volume_test_players tv_cleanup_lift_d_shaft_entrance) 1)

	; then teleport all players who aren't in the elevator shaft above the platform
	(volume_teleport_players_not_inside tv_cleanup_lift_d_shaft_teleport_volume flag_cleanup_lift_d_shaft_teleport_location)

	; lock the door back to lower level so players don't experience the unloaded seam, just in case
	(device_set_position_immediate last_bashed 0)
	(device_set_power last_bashed 0)

	; save the game
	(game_save_no_timeout)

	; erase anything left on level_b (kill_all_level_b ai_disposable's the lift_c squads that could be on the elevator)
	(sleep (game_ticks_from_seconds 2))
	(wake kill_all_level_b)
)

(script dormant kill_all_level_b
	(sleep_forever bay_c)
	(sleep_forever lift_b_top_placement)

	(ai_erase sq_gr_lift_b_infection)
	(ai_erase sq_gr_lift_b)
	(ai_erase gr_bay_c)
	(ai_erase sq_gr_tiny_lab_top)
	(ai_erase sq_gr_tiny_lab_bot)
	(ai_erase sq_gr_lab_d)
	(ai_erase sq_gr_lab_c)
	(ai_erase sq_gr_tinylab_e_f)
	(ai_erase sq_gr_bay_d)
	(ai_erase sq_gr_tinylab_l_m)
	(ai_erase sq_gr_lab_e_flood)
	(ai_erase sq_gr_bay_e)
	(ai_erase sq_gr_bay_e_bridge)
	(ai_disposable sq_gr_lift_c true) ; these can be on the elevator ride up, so don't erase in someone's face
)

(script dormant int_b_lift
	(sleep_until (volume_test_players int_b_lift_d_trigger) 1)
	(wake lift_d_switch_monitor)
	(ai_place sq_gr_lift_c)
)

;====================================================================================================================================================================================================
; swamp_b
;====================================================================================================================================================================================================

(script dormant swamp_b
	; vo before surface
	(wake play_vo_start_swamp_b)	; to facilitate testing from final dev insertion point
	(wake play_vo_echo_extraction)
	(wake play_vo_marines)
	(wake play_vo_tower_backtrack)

	(wake place_and_configure_swamp_b_marines)

	(sleep_until (volume_test_players tv_player_on_surface_swamp_b) 1)
	(wake swamp_b_pelican_and_guilty_flights) ; needs to be after the zone set transition

	; swamp run
	(wake swamp_b1)
	(wake swamp_b2)
	(wake swamp_b3)

	; tower gauntlet
	(wake swamp_b_gauntlet)
	(wake place_sentinels)

	; ///// winning /////
	(f_wait_for_game_win)
)

(script dormant place_sentinels
	(sleep_until (volume_test_players swamp_b_trigger_3) 1)
	(ai_place sq_gr_sentinels)
)

(global boolean b_last_wave_complete false)		; used by swamp_b_gauntlet to signal the mission can end
(script static void f_wait_for_game_win
	(print_if b_gauntlet_win_debug "test: wrap up waiting for mission end bool")
	(sleep_until b_last_wave_complete 1)
	(print_if b_gauntlet_win_debug "test: wrap up, bool received")


	(set s_music_trigger_c10 210)

	(print_if b_gauntlet_win_debug "test: wrap up waiting on blipper or timeout")
	(sleep_until (script_finished "final_wave_bloodgate_blipper") 1 (game_ticks_from_seconds (+ r_bloodgate_blipper_interval 0.1))) 	; the bloodgate blipper could be iterating units when this hits, so wait for it to finish (timeout just after one full loop of it) before unblipping

	; cleaning up blips and killing remaining guys likely to be in the bloodgate
	(print_if b_gauntlet_win_debug "test: wrap up cleanup")
	(ai_kill sq_gr_gauntlets)

	; start outro vo
	(wake play_vo_last_wave_killed)

	; wait for outro vo
	(print_if b_gauntlet_win_debug "test: wrap up waiting for vo line")
	(sleep_until (and
					(volume_test_players swamp_b_trigger_final)			; ensure at least one player is in front of the tower instead of hiding in the woods
					(script_finished "play_vo_last_wave_killed")		; ensures last mission dialogue finishes playing
				)
	1 (game_ticks_from_seconds 8.0)) 									; don't take longer than 9 seconds (including follow up pause) to end the mission, even if dubbo's line is still playing

	(sleep (game_ticks_from_seconds 1.0))								; give dubbo's line a beat before we cut to black
	; level end + cinematic
	(print_if b_gauntlet_win_debug "test: wrap up playing cinematic")
	(set b_mission_is_completing true) ; to drive navpoints
	(submit_incident_with_custom_string_id "game_activity_end_completed" "c10")
	(f_play_cinematic cinematics\c10\c10_outro.cinematic)
	(print_if b_gauntlet_win_debug "test: wrap up cinematic complete")
	(game_won)
)

; ////// push squads //////

(script dormant swamp_b1
	; first wave of push ai
	(sleep_until (volume_test_players swamp_b_trigger_1) 1)
	(f_game_save)

	(print_if b_debug "spawning initial flood wave")
	(ai_place sq_gr_initial)
	(ai_place sq_gr_swamp_b1)

	(sleep_until
		(begin
			(if (= (ai_living_count sq_gr_swamp_b1) 0)
				(begin
					(print_if b_debug "swamp_b1 is dead, spawning more")
					(sleep (game_ticks_from_seconds 4.0))
					(ai_place sq_gr_swamp_b1)
				)
			)
			; keep spawning the above in waves until the player moves deeper into the swamp hitting a trigger
			(volume_test_players swamp_b_trigger_2)
		)
		1
	)
)

(script dormant swamp_b2
	; start spawning the second push wave.
	(sleep_until (volume_test_players swamp_b_trigger_2) 1)

	(ai_place sq_gr_swamp_b2)
	(sleep_until
		(begin
			(if (= (ai_living_count sq_gr_swamp_b2) 0)
				(begin
					(print_if b_debug "swamp_b2 is dead, spawning more")
					(sleep (game_ticks_from_seconds 3.0))
					(ai_place sq_gr_swamp_b2)
				)
			)
			; keep spawning the above in waves until the player moves deeper into the swamp hitting a trigger
			(volume_test_players swamp_b_trigger_3)
		)
		1
	)
)

(script dormant swamp_b3
	; start spawning the third push wave
	(sleep_until (volume_test_players swamp_b_trigger_3) 1)
	(print_if b_debug "spawning swamp_b3")
	(ai_place sq_gr_swamp_b3)
)

; ////// tower gauntlet //////

; so qa can easily enable in build
(script static void f_enable_gauntlet_debug
	(set b_gauntlet_wave_debug true)
	(set b_gauntlet_res_debug true)
	(set b_gauntlet_blip_debug true)
	(set b_gauntlet_win_debug true)
)

; these are the final waves at the tower
(script dormant swamp_b_gauntlet
	(sleep_until (volume_test_players swamp_b_trigger_4) 1)

	; checkpoint
	(f_game_save)
	(print_if b_debug "starting gauntlet")

	(f_run_gauntlet_waves)
)

(script command_script cs_migrate_bipeds_after_trigger
	; run in autonomous mode so normal behaviors happen
	(cs_enable_dialogue true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving true)

	; if not an infection form, wait to hit the trigger volume then join the bloodgate.  otherwise, cs should exit
	(if (not (= (unit ai_current_actor) none))	 	; infection forms have no units, so if we have no unit...
		(begin ; then we must not be an infection form
			; sleep until we get close enough, then join the bloodgate squad and blip
			(sleep_until (volume_test_object swamp_b_trigger_final_bloodgate ai_current_actor) 1)
			(ai_migrate ai_current_actor sq_gauntlet_bloodgate)
		)
	)
)

(script static void (f_monitor_and_migrate_resurrections (ai squad))
	(sleep_until
		(begin
			(cs_run_command_script squad cs_migrate_bipeds_after_trigger)

			(= (ai_living_count squad) 0) ; exit condition, when all units are dead (infection forms can resurrect, and carriers/tanks/combat forms can spawn infection forms... which resurrect, so check both)
		)
		(game_ticks_from_seconds 1.0)				; ; loop interval - every 1.5 seconds...
	)
)

; split to static for organization
;
;	setup stuff
;	intro
;	  - (wave 1, guards) 								- as you enter 			- mix of normies, including some unsc ammo.  no upgrades
;	section 1
;		- (wave 2, elites melee)	 					- right side 			- elite forms, 3:1 melee to drain ammo, no upgrades allowed, no plasma rifles allowed
;		; flyby starts
;		- (wave 3, infection) 							- left side 			- infection forms, to res and lull.  legendary adds right side.  rest
;
;	checkpoint
;	section 2
;		- (wave 4, marines guns) 						- left side + center 	- marine forms, 2:1 ranged to give ammo for rest of fight and get you moving around 	; few upgrades on higher difficulties
;		- (wave 5, elite pr + infection) 				- right side + center 	- infection + elite plasma rifle wave (few upgrades) to kill sentinel help (and res)	; few upgrades on higher difficulties
;
;	checkpoint
;	final
;		- (last wave, upgraded elite melee, marine)		- all sides 			- squad cell mix of forms, elites upgraded, try infection								; many upgrades on all difficulties
;
;
;

(global boolean b_wave_flyby false)

; tuning variables, how many enemies can be in light before the next wave spawns.  higher numbers means more aggressive pacing; lower numbers mean rest
(global short s_threshold_wave1 	2)
(global short s_threshold_wave2 	3)
(global short s_threshold_wave3 	4)
(global short s_threshold_wave4 	4)
(global short s_threshold_wave5 	4)
; the last wave is a true bloodgate, so is always 0.

; global wave thresholds
(global real r_wave_clear_threshold 0.33)
(global real r_wave_safety_timeout_sec 45) ; if the squad takes longer than this timer to reach 40%, just move to watching the bloodgate

(script static void f_run_gauntlet_waves
	; wave setup
	(wake resurrection_monitor_bloodgate) 	; start the bloodgate resurrection monitor for all waves so that bloodgate squad resurrections are counted and able to be blipped
	(wake tower_arms_infection_cleaner) 	; every n seconds, sweep the tower arms for stuck infection forms and destroy them

	; ////// wave 1 //////
	(print_if b_gauntlet_wave_debug "test: //////// starting wave 1 //////////")
	(f_swamp_b_gauntlet_wave_1)

	; mark first-half of swamp_b gauntlet squads disposable for cleanup
	(ai_disposable sq_gr_swamp_b1 true)
	(ai_disposable sq_gr_swamp_b2 true)

	; ////// wave 2 //////
	(print_if b_gauntlet_wave_debug "test: //////// starting wave 2 //////////")


	(f_swamp_b_gauntlet_wave_2)

	; mark the last swamp gauntlet wave (which spawns near the tower) and the first wave disposable to clear stragglers
	(ai_disposable sq_gr_swamp_b3 true)
	(ai_disposable sq_gr_gauntlet1 true)

	; ////// mid point lull //////
	(print_if b_gauntlet_wave_debug "test: //////// checkpoint lull #1 //////////")
	(game_save_no_timeout)

	(set b_wave_flyby true)

	; ////// wave 3 //////
	(print_if b_gauntlet_wave_debug "test: //////// starting wave 3 //////////")
	(f_swamp_b_gauntlet_wave_3)

	; mark the second wave disposable
	(ai_disposable sq_gr_gauntlet2 true)

	; and force cleanup any remaining gauntlet guys
	(ai_erase sq_gr_initial)
	(ai_erase sq_gr_swamp_b1)
	(ai_erase sq_gr_swamp_b2)
	(ai_erase sq_gr_swamp_b3)

	; ////// wave 4 //////
	(print_if b_gauntlet_wave_debug "test: //////// starting wave 4 //////////")
	(f_swamp_b_gauntlet_wave_4)

	; ////// wave 5 //////
	(print_if b_gauntlet_wave_debug "test: //////// starting wave 5 //////////")
	(f_swamp_b_gauntlet_wave_5)

	; ////// mid point lull 2 //////
	(print_if b_gauntlet_wave_debug "test: //////// checkpoint lull #2 //////////")
	(game_save_no_timeout)

	; key change here

	; mark the third wave disposable
	(ai_disposable sq_gr_gauntlet3 true)

	; ////// wave final //////
	(print_if b_gauntlet_wave_debug "test: //////// starting wave 5 //////////")
	(f_swamp_b_gauntlet_wave_last)
)

(global boolean b_blip_waves false)				; the point at which the waves begin blipping things
(global real r_bloodgate_blipper_interval 2.0)
; refresh blips on enemies who make it into the bloodgate squad until end of mission as a catch-all for resurrections
(script dormant final_wave_bloodgate_blipper
	(print_if b_gauntlet_blip_debug "test: final wave blipper is waiting for bool to start blipping")
	(sleep_until b_blip_waves 1)
	(print_if b_gauntlet_blip_debug  "test: final wave blipper can start blipping")

	(sleep_until
		(begin
			(print_if b_gauntlet_blip_debug "test: blipper gonna blip")
			(f_blip_ai sq_gauntlet_bloodgate 1) ; refresh blips the whole bloodgate squad
			(print_if b_gauntlet_blip_debug "test: blipper finished")
			(sleep (game_ticks_from_seconds r_bloodgate_blipper_interval))

			b_last_wave_complete ; exit condition, stop adding blips when the wave reports complete
		) 1)

	(print_if b_gauntlet_blip_debug "test: final wave blipper is done")
)

; ////// wave statics //////

(global real r_initial_squad_count 0)
(script static void (f_run_gauntlet_wave (ai squad) (short s_wave_threshold) (boolean b_is_final_wave))
	; reset initial squad count
	(set r_initial_squad_count 0)

	; create the wave
	(f_blocking_ai_place_and_make_tower_marines_magically_see squad)

	; store the initial count
	(set r_initial_squad_count (ai_living_count squad))

	(if (> r_initial_squad_count 0)
	(begin
			(print_if b_gauntlet_wave_debug "test: watching for the squad")
			; once the squad reachs x% of original strength (either from death or from migrating to bloodgate squad), start watching the bloodgate
			(sleep_until (<= (/ (ai_living_count squad) r_initial_squad_count) r_wave_clear_threshold) 1 (game_ticks_from_seconds r_wave_safety_timeout_sec))
		)
	)

	; final wave difference - we blip it. we blip it good.
	(if b_is_final_wave
		(begin
			(set b_blip_waves true)					; this will make migrations to bloodgate blip immediately and trigger re-ups of blips for resurrected units
		)
	)

	; wait for the bloodgate to clear the wave's threshold to end the wave
	(print_if b_gauntlet_wave_debug "test: watching the bloodgate")
	(sleep_until (<= (ai_nonswarm_count sq_gauntlet_bloodgate) s_wave_threshold) 1) ; end wave after threshold for non-swarmers is met
	(print_if b_gauntlet_wave_debug "test: bloodgate pass")
)

; setup like this so we can test from the command line with scripts disabled
(script static void f_swamp_b_gauntlet_wave_1
	(wake resurrection_monitor_wave_1)
	(f_run_gauntlet_wave sq_gr_gauntlet1 s_threshold_wave1 false)
)

(script dormant resurrection_monitor_wave_1
	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 1 started")

	(f_monitor_and_migrate_resurrections sq_gr_gauntlet1)

	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 1 stopped")
)



(script static void f_swamp_b_gauntlet_wave_2
	(wake resurrection_monitor_wave_2)
	(f_run_gauntlet_wave sq_gr_gauntlet2 s_threshold_wave2 false)
)

(script dormant resurrection_monitor_wave_2
	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 2 started")

	(f_monitor_and_migrate_resurrections sq_gr_gauntlet2)

	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 2 stopped")
)



(script static void f_swamp_b_gauntlet_wave_3
	(wake resurrection_monitor_wave_3)
	(f_run_gauntlet_wave sq_gr_gauntlet3 s_threshold_wave3 false)
)

(script dormant resurrection_monitor_wave_3
	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 3 started")

	(f_monitor_and_migrate_resurrections sq_gr_gauntlet3)

	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 3 stopped")
)

(script static void f_swamp_b_gauntlet_wave_4
	(wake resurrection_monitor_wave_4)
	(f_run_gauntlet_wave sq_gr_gauntlet4 s_threshold_wave4 false)
)

(script dormant resurrection_monitor_wave_4
	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 4 started")

	(f_monitor_and_migrate_resurrections sq_gr_gauntlet4)

	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 4 stopped")
)

(script static void f_swamp_b_gauntlet_wave_5
	(wake resurrection_monitor_wave_5)
	(f_run_gauntlet_wave sq_gr_gauntlet5 s_threshold_wave5 false)
)

(script dormant resurrection_monitor_wave_5
	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 5 started")

	(f_monitor_and_migrate_resurrections sq_gr_gauntlet5)

	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 5 stopped")
)

(script static void f_swamp_b_gauntlet_wave_last
	(wake final_wave_bloodgate_blipper)		; once we f_run_gauntlet_wave begins blipping, this will periodically refresh blips on the bloodgate squad for those who are already in it
	(wake resurrection_monitor_wave_last)
	(f_run_gauntlet_wave sq_gr_lastwave 0 true) ; last wave needs to be a bloodgate

	(print_if b_gauntlet_wave_debug "test: ////// wave 5 ended ////////////")
	(set b_last_wave_complete true)
)

(script dormant resurrection_monitor_wave_last
	(f_monitor_and_migrate_resurrections sq_gr_lastwave)
	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 5 squad stopped")
)

; wave 5 resurrection manager for the bloodgate needs to re-blip infection forms who joined the bloodgate, ejected, and then reinfected a biped
; so it'll need to run continuously until all forms of infection are removed.
(script dormant resurrection_monitor_bloodgate
		(sleep_until
			(begin
				(sleep_until (or	; only monitor the bloodgate squad when...
								(>= (ai_living_count sq_gauntlet_bloodgate) 1)		; someone's in it, therefore could cause infection
								(f_all_resurrection_monitors_are_finished)						; we are actually done once the bloodgate is empty
							)
				1 )

				; then run monitoring - this will exit when the combined count in the bloodgate squad drops below 0 (when the bloodgate can no longer cause reinfection)
				(print_if b_gauntlet_res_debug "test: running bloodgate monitor")
				(f_monitor_and_migrate_resurrections sq_gauntlet_bloodgate)


				(and	; exit condition - we are done monitoring when nothing is left that can cause infection
					(>= (ai_living_count sq_gauntlet_bloodgate) 1)		; bloodgate squad could have combat forms or carriers (remix) that spawn more infection forms
					(f_all_resurrection_monitors_are_finished)
				)
			)
	1 )


	(print_if b_gauntlet_res_debug "test: resurrection monitor for wave 5 bloodgate stopped")
)

; ////// wave helpers //////

; places a squad, blocks for 1 frame, then sets up magic sight for the tower marines to see the newly placed squad
(script static void (f_blocking_ai_place_and_make_tower_marines_magically_see (ai squad))
	(ai_place squad)
	(sleep 3) ; seeing a "failed to find clump" error message that suggests waiting "a few" frames before applying magic sight
	(ai_magically_see sq_swamp_b_tower_marines squad)
)

(script static boolean f_all_resurrection_monitors_are_finished
	(or
		(and
			(script_finished "resurrection_monitor_wave_1")
			(script_finished "resurrection_monitor_wave_2")
			(script_finished "resurrection_monitor_wave_3")
			(script_finished "resurrection_monitor_wave_4")
			(script_finished "resurrection_monitor_wave_5")
		)
		b_last_wave_complete	; safety for when the game ends
	)
)

(global short s_inf_cleaner_index 0)
(global object_list l_infection_forms_in_volume (players))
(global boolean b_inf_cleaner_locked false)

(script static void (f_cleanup_infection_forms_in_volume (trigger_volume tv_cleanup_volume))
	(sleep_until (= b_inf_cleaner_locked false) 1)
	(set b_inf_cleaner_locked true)
	(set s_inf_cleaner_index 0)

	(set l_infection_forms_in_volume (volume_return_objects_by_type tv_cleanup_volume 2048))
	(sleep_until
		(begin
			(object_destroy (list_get l_infection_forms_in_volume s_inf_cleaner_index)) ; "kill the infection form in the list at the given index
			(set s_inf_cleaner_index (+ s_inf_cleaner_index 1))

			(>= s_inf_cleaner_index (list_count l_infection_forms_in_volume))
		) 1)

	(set b_inf_cleaner_locked false)
)

(script dormant tower_arms_infection_cleaner

	(sleep_until
		(begin
			(f_cleanup_infection_forms_in_volume tv_tower_cleanup_left)
			(f_cleanup_infection_forms_in_volume tv_tower_cleanup_right)

			(sleep (game_ticks_from_seconds 3.0)) ; every 3 seconds, sweep the outside tower arms for infection forms

			b_mission_is_completing ; exit condition
		)
	1 )
)


;====================================================================================================================================================================================================
; swamp_b marines
;====================================================================================================================================================================================================

(global real r_wounded_marine_vitality 25)
(script static void f_set_wounded_marine_health_based_on_difficutly
	(if (= (game_difficulty_get_real) easy)
		(begin
			(set r_wounded_marine_vitality 75) ; marines should help carry the player on easy
		)
	)

	; use the default setting for normal/heroic so that heroic feels harder

	(if (= (game_difficulty_get) legendary)
		(begin
			(set r_wounded_marine_vitality 50) ; legendary needs some beef above to keep up with the enemy damage
		)
	)
)

(script static void (f_wound_marine (ai marine))
	(unit_set_maximum_vitality marine r_wounded_marine_vitality 0)
	(unit_set_current_vitality marine r_wounded_marine_vitality 0)
)

(script dormant place_and_configure_swamp_b_marines
	(sleep_until (volume_test_players tv_swamp_b_marine_spawn) 1)	; if marines are placed before the zone set trigger, they will fall through the ground.

	; spawn marine backup
	(ai_place sq_gr_swamp_b_marines_dubbo)
	(ai_place sq_gr_swamp_b_marines_mortals)

	(wake swamp_b_marine_manager)
	(sleep 1)

	(f_set_wounded_marine_health_based_on_difficutly)

	; some of you must die, and that is a sacrifice i am willing to make (aiming for 3-4 making it in normal/heroic, with at least 2 getting eaten in front of your face)
	; (f_wound_marine sq_swamp_bmarines0) 	; leave 2 at full strength, one with ar and one with shotgun
	(f_wound_marine sq_swamp_bmarines1)
	(f_wound_marine sq_swamp_bmarines2)
	(f_wound_marine sq_swamp_bmarines3)
	(unit_set_maximum_vitality sq_swamp_bdubbo 200 0)		; dubbo kills ancient precursor parasites...
	(unit_set_current_vitality sq_swamp_bdubbo 200 0)		; and doesn't afraid of anything

	; enable flashlights for the marines
	(f_ai_set_integrated_flashlight sq_gr_swamp_b_marines true)
)

(global ai sq_tower_marines sq_swamp_b_tower_marines) 	; this is the destination squad the marines who survive the gauntlet will migrate to at the end of the encounter.  if you change this value, don't forget to update the aiobjective gate at the top of the graph or they can't find their task.

; catchup tuning
; fireteam marines have an outer radius from their fireteam leader set by r_cs_catchup_distance at which point they will leave combat so they can sprint to catchup.
; there is an inner radius they must return to in order to reenter combat, defined as (r_cs_catchup_distance - r_anti_hysteresis_distance) so they don't flick back and forth.
(global real r_cs_catchup_distance 8.0) 		; the distance at which marines in fireteams will supress combat (so they can sprint) and catchup
(global real r_anti_hysteresis_distance 1.0)

(script dormant swamp_b_marine_manager
	; configure fireteam settings for the swamp

	(ai_set_fireteam_absorber sq_tower_marines false) 			; don't let players absorb people from the destination squad


	; pick up dubbo early to handle looking/following during his vo delivery
	(sleep_until 	(or
						(volume_test_players tv_swamp_b_marine_dubbo_follow)
						(ai_allegiance_broken human player)			; dubbo will need firing points to avenge his bretheren
					)
	1 )

	(ai_player_add_fireteam_squad player0 sq_swamp_bdubbo)



	; wait for the player to cross the pillar before adding the rest
	(sleep_until (volume_test_players tv_swamp_b_marine_initial) 1)

	; solo case - add all regular marines to player0 leaving player0 with all marines following.  (the wise and powerful dubbo is already there)
	(ai_player_add_fireteam_squad player0 sq_swamp_bmarines0)
	(ai_player_add_fireteam_squad player0 sq_swamp_bmarines1)
	(ai_player_add_fireteam_squad player0 sq_swamp_bmarines2)
	(ai_player_add_fireteam_squad player0 sq_swamp_bmarines3)


	; solo case - fireteam configuration, has to be run after the fireteam exists
	(ai_player_set_fireteam_no_max player0)						; player0 should be able to hold all marines for the solo case
	(ai_set_fireteam_fallback_squad player0 sq_tower_marines) 	; this requires the squad's task on the tower to handle reenabling combat when entered in case we are mid-supression loop.

	; in 2p+ co-op, setup player1 and peel off 2 squads for their fireteam, leaving both players with 2 squads following
	(if (coop_players_2)
		(begin
			(ai_player_add_fireteam_squad player1 sq_swamp_bmarines1)
			(ai_player_add_fireteam_squad player1 sq_swamp_bmarines2)

			(ai_player_set_fireteam_no_max player1)
			(ai_set_fireteam_fallback_squad player1 sq_tower_marines) ; this requires the squad's task on the tower to handle reenabling combat when entered in case we are mid-supression loop.
		)
	)

	; in 3p+ co-op, setup player2 and give them one of player1's squads, leaving player0 with 2 squads following and each co-op player with 1 squad following each.
	(if (coop_players_3)
		(begin
			(ai_player_add_fireteam_squad player2 sq_swamp_bmarines2)

			(ai_player_set_fireteam_no_max player2)
			(ai_set_fireteam_fallback_squad player2 sq_tower_marines) ; this requires the squad's task on the tower to handle reenabling combat when entered in case we are mid-supression loop.
		)
	)

	; in 4p co-op, setup player3 and give them one of player0's squads, leaving everyone with 1 squad following.
	(if (coop_players_4)
		(begin
			(ai_player_add_fireteam_squad player3 sq_swamp_bmarines3)

			(ai_player_set_fireteam_no_max player3)
			(ai_set_fireteam_fallback_squad player3 sq_tower_marines) ; this requires the squad's task on the tower to handle reenabling combat when entered in case we are mid-supression loop.
		)
	)
)

; helpers
(script static boolean (f_this_marine_needs_to_catch_up_to_target (ai marine_actor) (ai marine_squad) (object catchup_target) (real r_catchup_distance))
	(cond
		((and (ai_is_in_fireteam marine_actor) (> (objects_distance_to_object marine_actor catchup_target) r_catchup_distance)) 			true)	; fireteam marines too far away from their comabt need to catchup
		((and (not (ai_is_in_fireteam marine_actor)) (not (f_this_marine_is_through_the_gauntlet marine_actor)))  						true)	; marines that lost their fireteam (player died) and haven't made it through the gauntlet need to catchup


		(true 																															false)	; all other cases, no catchup needed
	)
)

; used for anti-hysteresis so that marines don't flip between catchup modes right on the borderline and never really enter combat when the player is moving
(script static boolean (f_this_marine_has_caught_up_to_target (ai marine_actor) (ai marine_squad) (object catchup_target) (real r_catchup_distance))
	(cond
		((and (ai_is_in_fireteam marine_actor) (< (objects_distance_to_object marine_actor catchup_target) (- r_catchup_distance r_anti_hysteresis_distance)  )) 	true)	; fireteam marines who are within x units of the catchup radius are considered caught up
		((and (not (ai_is_in_fireteam marine_actor)) (f_this_marine_is_through_the_gauntlet marine_actor))  														true)	; marines that lost their fireteam (player died) and have made it through are considered caught up


		(true 																																						false)	; all other cases, marine is still catching up
	)
)

(script static boolean (f_this_marine_is_through_the_gauntlet (ai marine_actor))
	(volume_test_object tv_swamp_b_marine_main_5 marine_actor)
)

(script static void (f_dump_marine_out_of_fireteam_and_into_tower_defenders (ai marine_actor))
	; put the unit into the destination squad.  this is not a fireteam squad, so they marine will stop following and respect the task's zones again.
	(ai_migrate_persistent marine_actor sq_tower_marines)

	; the marine may have been in catchup mode (supressed combat) when it crossed the trigger volume, so ensure they can fight now that they made it
	(f_reset_catchup_mode marine_actor)

	(print_if b_debug "a swamp b marine made it to the tower and joined the defenders.")
)

(script static void (f_enable_catchup_mode (ai marine_actor))
	(ai_suppress_combat marine_actor true)
	(ai_set_blind ai_current_actor true)
	(ai_set_deaf ai_current_actor true)

	(print_if b_debug "a swamp b marine is supressing combat to catch up.")
)

(script static void (f_reset_catchup_mode (ai marine_actor))
	(ai_suppress_combat marine_actor false)
	(ai_set_blind ai_current_actor false)
	(ai_set_deaf ai_current_actor false)
)

; command scripts can't take players as a param.  fireteam leaders cannot be gotten dynmaically.  so... i guess just put everything in statics and make a copy that passes each player manually
; this is the static that is the core of the command scripts
(script static void (f_manage_combat_supression_until_gauntlet_for_this_marine (ai marine_actor) (ai marine_squad) (object catchup_target) (real catchup_distance))
	; while the marine has not made it through the gauntlet, suppress combat if it needs to catch up
	(sleep_until
		(begin
			(if (f_this_marine_needs_to_catch_up_to_target marine_actor marine_squad catchup_target catchup_distance)
				(begin ; then
					(f_enable_catchup_mode marine_actor)
				)
				(begin ; else
					(if (f_this_marine_has_caught_up_to_target marine_actor marine_squad catchup_target catchup_distance)
						(begin
							(f_reset_catchup_mode marine_actor)
						)
					)
				)
			)

			(f_this_marine_is_through_the_gauntlet marine_actor); stop supressing combat once you've made it through the gauntlet
		)
	1 ) ; check every frame

	; once through the gauntlet, join the tower defenders
	(f_dump_marine_out_of_fireteam_and_into_tower_defenders ai_current_actor)
)

; dish these out via task
(script command_script cs_marine_supress_combat_to_catch_up_player0
	; let the marine do everything it would normally do...
	(cs_enable_dialogue true)
	(cs_enable_looking true)
	(cs_enable_moving true)
	(cs_enable_targeting true)

	; ... while each marine has not made it through the gauntlet, supress combat so it triggers sprint on the marine when its too far away.  dump it into the
	(f_manage_combat_supression_until_gauntlet_for_this_marine ai_current_actor ai_current_squad player0 r_cs_catchup_distance)
)

(script command_script cs_marine_supress_combat_to_catch_up_player1
	; let the marine do everything it would normally do...
	(cs_enable_dialogue true)
	(cs_enable_looking true)
	(cs_enable_moving true)
	(cs_enable_targeting true)

	; ... while each marine has not made it through the gauntlet, supress combat so it triggers sprint on the marine when its too far away.  dump it into the
	(f_manage_combat_supression_until_gauntlet_for_this_marine ai_current_actor ai_current_squad player1 r_cs_catchup_distance)
)

(script command_script cs_marine_supress_combat_to_catch_up_player2
	; let the marine do everything it would normally do...
	(cs_enable_dialogue true)
	(cs_enable_looking true)
	(cs_enable_moving true)
	(cs_enable_targeting true)

	; ... while each marine has not made it through the gauntlet, supress combat so it triggers sprint on the marine when its too far away.  dump it into the
	(f_manage_combat_supression_until_gauntlet_for_this_marine ai_current_actor ai_current_squad player2 r_cs_catchup_distance)
)

(script command_script cs_marine_supress_combat_to_catch_up_player3
	; let the marine do everything it would normally do...
	(cs_enable_dialogue true)
	(cs_enable_looking true)
	(cs_enable_moving true)
	(cs_enable_targeting true)

	; ... while each marine has not made it through the gauntlet, supress combat so it triggers sprint on the marine when its too far away.  dump it into the
	(f_manage_combat_supression_until_gauntlet_for_this_marine ai_current_actor ai_current_squad player3 r_cs_catchup_distance)
)

; redundancy attached to the tower squad's task to guarantee combat is enabled for the tower squad.
; needed for handling ai_fallback_squad cases in 3p and 4p combat
(script command_script cs_enable_combat
	(f_reset_catchup_mode ai_current_actor)
)

;====================================================================================================================================================================================================
; swamp_b marine intro scripts
; when the player breaks the follow plane just past the pillar, marines are sucked into tasks that apply command scripts, which will halt any of the intro command scripts midway through.
;====================================================================================================================================================================================================

(script static boolean f_swamp_b_marines_in_combat
	(or
		(= (ai_combat_status sq_gr_swamp_b_marines) dangerous)		; for the flood
		(ai_allegiance_broken player human)							; and traitorous spartans
	)
)

(script static boolean f_dubbo_interrupted
	(or
		(volume_test_players tv_swamp_b_marine_dubbo_follow)	; he will join the fireteam here, so the command script can let go
		(ai_allegiance_broken player human)						; he will fight you here, so the command script can let go
	)
)

(script command_script cs_marine_dubbo_intro
	(cs_enable_dialogue false) ; no systemic audio like "go around go around" until his scripted line is finished

	(branch (f_dubbo_interrupted) (f_print_abort_message "cs_dubbo_intro aborted"))

	; start crouched in front of the gear, looking out toward the forest
	(cs_crouch true)
	(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_left)

	; respond to the player reaching the surface by standing up and looking back
	(sleep_until (volume_test_players tv_player_on_surface_swamp_b) 1)
	(cs_crouch false)
	(cs_face_player true)

	; wait for time to approach
	(f_sleep_until_dubbo_should_approach)

	; approach chief
	(cs_go_to ps_swamp_b_marine_intro/intro_dubbo_speech)
	(cs_lower_weapon true)	; don't point your gun at chief while you talk to him

	; rely on follow behavior to pick up chief and face him once you reach the point
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_enable_looking true)

	; hold forever, rely on command_script interruption to bail out
	(sleep_until false 1)
)

(script command_script cs_marine_intro_rear_right_stand
	(branch (f_swamp_b_marines_in_combat) (f_print_abort_message "...cs_marine_intro_rear_right_stand has aborted"))

	; aim at forest to start
	(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_left) ; start looking to the left

	; react to dubbo starting to move
	(f_sleep_until_dubbo_should_approach)
	(sleep (game_ticks_from_seconds 0.2)) ; dubbo will immediately stand up when this bool is set, so give it slight offset so this guy is reacting
	(cs_face_player true)
	(cs_lower_weapon true)

	(sleep (game_ticks_from_seconds 3.0)) ; watch the conversation a little longer than the other guy, then turn back to the forest

	; look back to original position and wait for turn to complete
	(cs_face true ps_swamp_b_marine_intro/intro_look_outside_middle_left)
	(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_left)
	(sleep (game_ticks_from_seconds 1.75))

	; and step forward
	(cs_walk true)
	(cs_go_to_and_face ps_swamp_b_marine_intro/intro_rear_right_walk ps_swamp_b_marine_intro/intro_look_outside_middle_left)
	(cs_walk false)

	(sleep_until false 1) ; face player with weapon lowered until the branch condition kills the command script
)

(script command_script cs_marine_intro_rear_left
	(branch (f_swamp_b_marines_in_combat) (f_print_abort_message "...cs_marine_intro_rear_left has aborted"))

	; aim at forest to start
	(cs_face true ps_swamp_b_marine_intro/intro_look_outside_middle)
	(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle)

	(begin_random	; shift nervously, looking out at the forest
		(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle)
		(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_right)
	)

	; react to dubbo starting to move
	(f_sleep_until_dubbo_should_approach)
	(sleep (game_ticks_from_seconds 0.33)) ; slower delay than other guy that turns
	(cs_face_player true)

	; regard the conversation for a moment...
	(sleep (game_ticks_from_seconds 2.25))

	; then turn back to forest...
	(cs_face true ps_swamp_b_marine_intro/intro_look_outside_middle)
	(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle)

	(sleep (game_ticks_from_seconds 2)) ; time to turn back to forest

	; and rifle fidget, before settling in
	(cs_custom_animation objects\characters\marine\marine "alert:rifle:posing_var1" true) ; check and reload assault rifle
	(sleep_until (<= (unit_get_custom_animation_time ai_current_actor) 0) 1)
	(cs_stop_custom_animation)

	; loop until branch breaks things, occasionally looking out at the forest
	(sleep_until
		(begin
			(begin ; face forward and hold
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle)
				(sleep (game_ticks_from_seconds (real_random_range 4.0 8.0))) ; spend more time looking in your original direction
			)
			(begin_random	; shift nervously between one of three random points on the door to create overlapping flashlight effects
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle)
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_right)
				;(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_right)
			)
			(sleep (game_ticks_from_seconds 2.0)) ; then hold

			false ; exit condition
		)
	1)
)


(script command_script cs_marine_intro_forward_left
	(branch (f_swamp_b_marines_in_combat) (f_print_abort_message "...cs_marine_intro_forward_left has aborted"))

	; aim at forest to start
	(cs_face true ps_swamp_b_marine_intro/intro_look_outside_middle_left)
	(cs_crouch true)

	; loop until branch breaks things, occasionally looking out at the forest
	(sleep_until
		(begin
			; face forward and hold
			(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_left)
			(sleep (game_ticks_from_seconds (real_random_range 2.0 4.0))) ; spend more time looking in your original direction

			(begin_random	; shift nervously between random points on the door to create overlapping flashlight effects
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle)
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_right)
			)
			(sleep (game_ticks_from_seconds 2.0)) ; then hold


			false ; exit condition
		)
	1)
)

(script command_script cs_marine_intro_forward_right
	(branch (f_swamp_b_marines_in_combat) (f_print_abort_message "...cs_marine_intro_forward_right has aborted"))

	(cs_go_to_and_face ps_swamp_b_marine_intro/intro_forward_right ps_swamp_b_marine_intro/intro_look_outside_right)
	(cs_crouch true)

	; loop until branch breaks things, occasionally looking out at the forest
	(sleep_until
		(begin
			; face forward and hold
			(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_right)
			(sleep (game_ticks_from_seconds (real_random_range 3.0 6.0))) ; spend more time looking in your original direction

			(begin_random	; shift nervously between random points on the door to create overlapping flashlight effects
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_left)
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_right)
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle_left)
			)
			(sleep (game_ticks_from_seconds (real_random_range 2.0 4.0))) ; then hold


			false ; exit condition
		)
	1)
)

(script command_script cs_marine_intro_forward_right_pillar
	(branch (f_swamp_b_marines_in_combat) (f_print_abort_message "...cs_marine_intro_forward_right_pillar has aborted"))

	(cs_crouch true)
	(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_right) ; start looking over the top

	; loop until branch breaks things, occasionally looking out at the forest
	(sleep_until
		(begin
			; face forward and hold
			(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_right)
			(sleep (game_ticks_from_seconds (real_random_range 4.0 8.0))) ; spend more time looking in your original direction

			(begin_random	; shift nervously between random points on the door to create overlapping flashlight effects
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_middle)
				(cs_aim true ps_swamp_b_marine_intro/intro_look_outside_right)
			)
			(sleep (game_ticks_from_seconds (real_random_range 3.0 6.0))) ; then hold


			false ; exit condition
		)
	1)
)

;====================================================================================================================================================================================================
; swamp_b command scripts
;====================================================================================================================================================================================================

(script command_script cs_monitor_intro
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)
	(ai_disregard (ai_actors ai_current_actor) true)

	; take the intro route through the swamp
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(cs_fly_by ps_monitor_intro/p0)
	(cs_fly_by ps_monitor_intro/p1)
	(cs_fly_by ps_monitor_intro/p2)
	(cs_fly_by ps_monitor_intro/p3)
	(cs_fly_by ps_monitor_intro/p4)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(cs_fly_by ps_monitor_intro/p5)
	(cs_fly_by ps_monitor_intro/p6)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(cs_fly_by ps_monitor_intro/p7)
	(cs_fly_by ps_monitor_intro/p8)
	(cs_fly_by ps_monitor_intro/p9)

	; poe energy, wait for player to get close, then laugh and continue on.
	(cs_fly_by ps_monitor_intro/p10)
	(cs_face_player true)
	(sleep_until (volume_test_players tv_guilty_continue) 1)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)

	; finish flying past the backlit-flood and into the other bsp...
	(cs_face_player false)
	(cs_fly_by ps_monitor_intro/p11)
	(cs_fly_by ps_monitor_intro/p12)
	(cs_fly_by ps_monitor_intro/p13)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(cs_fly_by ps_monitor_intro/p14)
	(cs_fly_by ps_monitor_intro/p15)
	(cs_fly_by ps_monitor_intro/p16)
	(cs_fly_by ps_monitor_intro/p17)



	; ...take the perch route finale up to the perch, without the sleeps
	(cs_face_player false)
	(cs_fly_to ps_monitor_perch/p14 1)
	(cs_fly_to ps_monitor_perch/p15 1)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(cs_fly_to ps_monitor_perch/p16 1)
	(cs_fly_to ps_monitor_perch/p17 1)
	(cs_fly_to ps_monitor_perch/p1 1)
	(cs_fly_to ps_monitor_perch/p0 1)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)

	; hold at perch until the waves call for a flyby to mark progression
	(cs_fly_to ps_monitor_perch/p0 1)
	(cs_face_player true)

	; after the waves call for a flyby, do a loop and make some noise to give a sense of progression
	(sleep_until b_wave_flyby 1)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(cs_face_player false)
	(cs_fly_to ps_monitor_perch/p_flyby_1 1)
	(cs_fly_to ps_monitor_perch/p_flyby_2 1)
	(cs_fly_to ps_monitor_perch/p_flyby_3 1)
	(cs_fly_to ps_monitor_perch/p_flyby_4 1)


	; look at chief while over the middle and laugh while you wonder why the long-awaited reclaimer brought such a low-grade combat skin
	(cs_fly_to ps_monitor_perch/p_flyby_4 1)
	(cs_face_player true)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(sleep (game_ticks_from_seconds 3.43))
	(cs_face_player false)



	; return to perch, pausing around the tree for one last remark about how the other reclaimers aren't even wearing combat skins
	(cs_fly_to ps_monitor_perch/p_flyby_4b 1)
	(cs_fly_to ps_monitor_perch/p12 1)
	(cs_fly_to ps_monitor_perch/p11 1) ; we're rewinding the return-from-skull path here, so yes it's supposed to be descending
	(cs_face_player true)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(sleep (game_ticks_from_seconds 7))
	(cs_face_player false)

	; hold at perch until end of the level, unless the player triggers the skull hint
	(cs_fly_to ps_monitor_perch/p0 1)
	(cs_face_player true)

	; ye olde speedrun strats are not forgotten in yon modern day...
	; ... merely de-cheesed and turned into collectible hints for those that remember.
	(sleep_until (= (ai_living_count sq_gr_sentinels) 0) 1)
	(cs_run_command_script ai_current_actor cs_monitor_skull_hint)
)

(script command_script cs_monitor_skull_hint
	(cs_face_player false)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1) ; play vo of the monitor singing/whistling

	(cs_fly_to ps_monitor_perch/p1 1)
	(cs_fly_to ps_monitor_perch/p2 1)
	(cs_fly_to ps_monitor_perch/p3 1)

	(cs_fly_to ps_monitor_perch/p4 1)

	(cs_fly_to ps_monitor_perch/p5 1)
	(cs_face_player true)
	(sleep (game_ticks_from_seconds 3.43))

	(cs_face_player false)
	(cs_fly_to ps_monitor_perch/p6 1)
	(cs_fly_to ps_monitor_perch/p7 1)
	(cs_fly_to ps_monitor_perch/p8 1)
	(cs_face_player true)

	; hover above the skull until it gets picked up
	(sleep_until (f_they_come_back_skull_is_picked_up) 1)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(sleep (game_ticks_from_seconds 3.43))

	(cs_face_player false)
	(cs_fly_to ps_monitor_perch/p9 1)
	(cs_fly_to ps_monitor_perch/p10 1)
	(cs_fly_to ps_monitor_perch/p11 1)
	(cs_face_player true)
	(sleep (game_ticks_from_seconds 7))
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(sleep (game_ticks_from_seconds 3.43))

	(cs_face_player false)
	(cs_fly_to ps_monitor_perch/p12 1)
	(sleep (game_ticks_from_seconds 3.43))

	(cs_fly_to ps_monitor_perch/p13 1)
	(cs_face_player true)
	(sleep (game_ticks_from_seconds 3.43))

	(cs_face_player false)
	(cs_fly_to ps_monitor_perch/p14 1)
	(cs_fly_to ps_monitor_perch/p15 1)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(cs_face_player true)
	(sleep (game_ticks_from_seconds 7))

	(cs_face_player false)
	(cs_fly_to ps_monitor_perch/p16 1)
	(cs_fly_to ps_monitor_perch/p17 1)
	(cs_fly_to ps_monitor_perch/p1 1)
	(cs_fly_to ps_monitor_perch/p0 1)
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c10_sing ai_current_actor 1)
	(cs_face_player true)
	(sleep_until false (game_ticks_from_seconds 30)) ; hold cs until end of game
)

; object_get_health returns 0 when the skull is on the ground (because it has no health) but -1 when
(script static boolean f_they_come_back_skull_is_picked_up
	(= (object_get_health skull_theycomeback) -1)
)

(script dormant swamp_b_pelican_and_guilty_flights
	(sleep_until (volume_test_players tv_pelican_circling_start) 1)

	; pelican circling the tower
	(print_if b_debug "dm_vignette_pelican_circling set to 1")
	(device_set_position_immediate dm_vignette_pelican_circling 1) 	; trigger the level sequence actor to begin circling
	(print_if b_debug "pelican circling vignette triggered")

	; guilty spark flying through the woods
	(ai_place sq_gr_monitor)	; the spawn point runs cs_monitor_intro on its own to send him flying
)

;====================================================================================================================================================================================================
; bridge monitors
; light bridges interpolate through space due to an animation issue, killing everything below them
; thus, we use two device machines, one for collision (the real one, invisible) and a vignette machine for the visual.
;
; to use, configure the device control to use a device group, but do not hook the bridge itself up to the device group.
; let the script listen to the group changes and create/destroy collision as it toggles the visuals accordingly.
;====================================================================================================================================================================================================

(script static void (f_print_abort_message (string message))
	(print_if b_debug "script aborted...")
	(print_if b_debug message)
)

(script dormant bridge_b_monitor
	(branch (volume_test_players tv_cleanup_sterilizer_midpoint) (f_print_abort_message "bridge_b montior shutdown")) ; exit condition, stop monitoring the bridge when the player hits the sterlizer point of no return

	(sleep_until
		(begin
			(f_toggle_lightbridge_on_group_change bridge_b_collision bridge_b bridge_b_position)

			false ; exit condition, rely on branch to kill the monitor
		)
	1 )
)

(script dormant bridge_e_monitor
	(branch (volume_test_players tv_cleanup_lift_d_shaft_entrance) (f_print_abort_message "bridge_b montior shutdown")) ; exit condition, stop montioring the bridge when the player the level_b point of no return

	(sleep_until
		(begin
			(f_toggle_lightbridge_on_group_change bridge_e_collision bridge_e bridge_e_position)

			false ; exit condition, rely on branch to kill the monitor
		)
	1 )
)

(script static void (f_toggle_lightbridge_on_group_change (device_name lightbridge_collision) (device_name lightbridge_visuals) (device_group lightbridge_group))
	; ; wait until the device group is on, then create the collision and toggle the visuals on
	(sleep_until (= (device_group_get lightbridge_group) 1) 1)
	(object_create lightbridge_collision)
	(device_set_position_immediate lightbridge_visuals 1)

	; wait until the device group is off, then remove the collision and toggle the visuals off
	(sleep_until (= (device_group_get lightbridge_group) 0) 1)
	(object_destroy lightbridge_collision)
	(device_set_position_immediate lightbridge_visuals 0)

	; prevent idle players from coyote-floating when the bridge goes away
	(sleep 1)
	(object_wake_physics player0)
	(object_wake_physics player1)
	(object_wake_physics player2)
	(object_wake_physics player3)
)

;====================================================================================================================================================================================================
; lift monitors
;====================================================================================================================================================================================================

(script dormant lift_a_switch_monitor
	(if b_elevator_switches_toggle
		(begin ; then
			(sleep_until
				(begin
					(f_manage_c10_lift_switches lift_a_position lift_a_cont_b_offplat lift_a_cont_b) ; this lift's position is reversed for the rally point, so these arguments are intentionally reversed
				b_flood_revealed ; break loop condition
 				)
			1 )

			; delete the switches on cleanup
			(object_destroy lift_a_cont_b)
			(object_destroy lift_a_cont_b_offplat)

		)
		(begin ; else
			(print_if b_debug "switch monitors disabled, skipping switch management")
		)
	)
)

(script dormant lift_b_switch_monitor
	(if b_elevator_switches_toggle
		(begin ; then
			(sleep_until
				(begin
					(f_manage_c10_lift_switches lift_b_position lift_b_cont_a_offplat lift_b_cont_a) ; this lift's position is reversed for the rally point, so these arguments are intentionally reversed
				(volume_test_players int_bottom_lift_b_trigger) ; break loop condition
 				)
			1 )

			; delete the switches on cleanup
			(object_destroy lift_b_cont_a)
			(object_destroy lift_b_cont_a_offplat)
		)
		(begin ; else
			(print_if b_debug "switch monitors disabled, skipping switch management")
		)
	)
)

(script dormant lift_d_switch_monitor
	(if b_elevator_switches_toggle
		(begin ; then
			(sleep_until
				(begin
					(f_manage_c10_lift_switches lift_d_position lift_d_cont_a lift_d_cont_a_offplat)
				(volume_test_players swamp_b_vo_trigger) ; break loop condition
 				)
			1 )

			; delete the switches on cleanup
			(object_destroy lift_d_cont_a)
			(object_destroy lift_d_cont_a_offplat)
		)
		(begin ; else
			(print_if b_debug "switch monitors disabled, skipping switch management")
		)
	)
)

(global short s_switch_monitor_deletion_delay 1) ; number of seconds to wait before deleting the switches after the player hits the button, to allow sound effects to play
(script static void (f_manage_c10_lift_switches
						(device_group dg_to_check)
						(object_name platform_switch)
						(object_name offplatform_switch)
					)

	(if (= (device_group_get dg_to_check) 0) ; lift is at rest
		(begin ; then activate the on-lift switch and turn off the room switch
			(sleep (game_ticks_from_seconds s_switch_monitor_deletion_delay)) ; slight delay to let the sound finish before deleting
			(object_create_anew platform_switch)
			(object_destroy offplatform_switch)
		)
		(begin ; else activate the room switch and turn off the on-lift switch
			(sleep (game_ticks_from_seconds s_switch_monitor_deletion_delay)) ; slight delay to let the sound finish before deleting
			(object_create_anew offplatform_switch)
			(object_destroy platform_switch)
		)
	)
)

; this is actually the control switch portion of the falling lift vignette
; run it even if the switch monitors are disabled, since it still needs to wait the standard amount of time before deleting the switch to let sound effects play
(script dormant lift_a_falling_switch_monitor_vignette
	; this sleep used to handle letting the audio on the switch play, but since the bp handles audio, we actually want it to squelch.  leaving in case audio gets pissed later.
	;(sleep (game_ticks_from_seconds s_switch_monitor_deletion_delay)) ; wait the standard amount so the switch behaves as expected... but do not turn on the new one
	(object_destroy lift_a_falling_control_offplat)
	(device_set_position_immediate dm_vignette_falling_lift_ctl_sparks 0.5) ; send the signal to bp to play the broken sparks
	(sleep (game_ticks_from_seconds 2.0))
	(device_set_position_immediate dm_vignette_falling_lift_ctl_sparks 1.0) ; set bp to completed state

)

;====================================================================================================================================================================================================
; navpoints
;====================================================================================================================================================================================================

(script dormant start_mission_navpoints
	(if b_pre_flood_breadcrumb (f_blip_flag navpoint_1_pelican 0))

	(sleep_until (or (volume_test_players np_trigger_1_pelican)(volume_test_players np_trigger_1_pelican_woods)) 1)
	(f_unblip_all)
	(if b_pre_flood_breadcrumb (f_blip_flag navpoint_2_swamp_a 0))

	(sleep_until (volume_test_players np_trigger_2_swamp_a) 1)
	(f_unblip_all)
	(if b_pre_flood_breadcrumb (f_blip_flag navpoint_3_entrance 0))

	(sleep_until (volume_test_players np_trigger_3_entrance) 1)
	(f_unblip_all)

	(sleep_until (volume_test_players bay_a_entrance_trigger) 1)
	;(sleep_until (volume_test_players int_a_trigger) 1) ; this was used in dec/jan ur, but you got the signal while still high on the elevator.  now it spawns in the next room.

	(sleep (game_ticks_from_seconds 3)) ; let the player react to the grunts and jackals
	(if b_pre_flood_breadcrumb (f_blip_flag navpoint_4_lab_a 0))

	; to be continued in level_a_navpoints
)

(script dormant level_a_navpoints
	(if (f_insertion_point_matches insertion_1_level_a)
		(if b_pre_flood_breadcrumb (f_blip_flag navpoint_4_lab_a 0))
	)
	(sleep_until (volume_test_players np_trigger_4_1_lab_a) 1)
	(f_unblip_all)
	(if b_pre_flood_breadcrumb (f_blip_flag navpoint_5_above_marine 0))

	(sleep_until (or
					(volume_test_players np_trigger_5_above_marine)
					(volume_test_players bay_b_trigger)
					(volume_test_players control_table_cinematic_trigger)
				)
	1)
	(f_unblip_all)
	(if b_pre_flood_breadcrumb (f_blip_flag navpoint_6_prison_room 0))

	(sleep_until (or
					(volume_test_players np_trigger_6b_prison_approach)
					(volume_test_players bay_b_trigger)
					(volume_test_players control_table_cinematic_trigger)
				)
	1)
	(f_unblip_all)

	; to be continued in flood_revealed_navpoints
)

(script dormant flood_revealed_navpoints
	(sleep_until b_flood_reveal_room_open 1)
	(f_unblip_all)
	(f_blip_flag navpoint_6_prison_room_exit 0)

	(sleep_until (or
					(volume_test_players np_trigger_6_prison_exit_r)
					(volume_test_players np_trigger_6_prison_exit_l)
				)
	1)
	(f_unblip_all)
	(f_blip_flag navpoint_7_prison_door 0)

	(sleep_until (volume_test_players np_trigger_7_prison_door) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_4b_lab_a_2f 0)

	(sleep_until (volume_test_players np_trigger_4_2_lab_a) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_8_bay_a 0)

	(sleep_until (volume_test_players np_trigger_8_bay_a) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_9_lift_a_fall 0)

	(sleep_until (or
		(volume_test_players np_trigger_10_steril_door)
		(volume_test_players np_trigger_9_lift_fall))
	1)
	(if (volume_test_players np_trigger_9_lift_fall)
		(begin
			(f_unblip_all)
			(sleep_until (or
				(= (device_group_get lift_a_falling_position) 1)
				(volume_test_players np_trigger_10_steril_door)
			) 1)
			(if (= (device_group_get lift_a_falling_position) 1)
				(begin
					(sleep (game_ticks_from_seconds 13)) ; wait for elevator to finish falling
					(f_blip_flag navpoint_10_steril_door 0)
					(sleep_until (volume_test_players np_trigger_10_steril_door) 1)
					(f_nav_to_elevator_b)
				)
				; else
				(f_nav_to_elevator_b)
			))
		; else
		(f_nav_to_elevator_b)
	)

	(sleep_until (volume_test_players np_trigger_11_elevator_b) 1)
	(f_unblip_all)

	; to be continued in level_b_navpoints
)

(script static void f_nav_to_elevator_b
	(f_unblip_all)
	(f_blip_flag navpoint_11_elevator_b 0)
)

(script dormant level_b_navpoints
	; from elevator into the door
	(sleep_until (volume_test_players int_lift_infector_trigger) 1)
	(wake level_b_post_lightbridge_navpoints)
	(f_unblip_all)
	;(f_blip_flag navpoint_12a_bay_c 0) ; there's a single exit to this room, blip is overkill

	;(sleep_until (volume_test_players int_lift_infector_trigger1) 1) ; we were using this in dec/jan ur, but need to integrate the objective here.  leaving commented in case we need to roll back
	; broken lightbridge lower left door exit
	(sleep_until (volume_test_players tv_lightbridge_obj) 1)
	(wake f_obj_nonblocking_lightbridge)
	(f_unblip_all)

	; give the player a moment to see the marine vignette play out and the objective message to pop before telling them how to complete the puzzle
	; then, pop the nav if the the player is still in the room
	(sleep (game_ticks_from_seconds 4))
	(if (volume_test_players tv_player_has_not_crossed_lightbridge)
		(begin ; then
				(f_blip_flag navpoint_12b_bay_c_1f 0)
		)
	)

	; end of hallway into lab_d (1st floor of switchback room)
	; double sleep is required because of the pause for the objective before - if the player sprints for the door they can make it past this trigger, so don't get this waterfall caught either way
	; thus, check for either this volume or the next one in the hallway
	(sleep_until (or (volume_test_players np_trigger_12_bay_c_l) (volume_test_players np_trigger_14_lab_d_off)) 1)
	(f_unblip_all)
	(if (volume_test_players np_trigger_12_bay_c_l)
		(begin ; then
				(f_blip_flag navpoint_13_lab_d_1f 0)
		)
	)

	; 2nd floor of lab_d, this is the nasty switchback to the 2nd floor
	(sleep_until (volume_test_players np_trigger_14_lab_d_off) 1)
	(f_unblip_all)
	(sleep_until (volume_test_players np_trigger_14_lab_d_on) 1) ; these are stacked so that you get into the room a bit before the switchback draws
	(f_blip_flag navpoint_14_lab_d_2f 0)

	; lab c, after the one way door
	(sleep_until (volume_test_players np_trigger_14_lab_d_2f) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_15_lab_c 0)
)

; players can skip this section if they bypass the lightbridge, so this needs to be its own section
(script dormant level_b_post_lightbridge_navpoints
	; bay_e, the red room with all the flood on the wall
	(sleep_until (volume_test_players np_trigger_15_lab_c) 1)
	(wake f_obj_nonblocking_surface)
	(sleep_forever level_b_navpoints)
	(f_unblip_all)
	(f_blip_flag navpoint_16_bay_e 0)

	(sleep_until (volume_test_players np_trigger_17_bay_d_2) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_16b_lab_e 0)

	(sleep_until (volume_test_players np_trigger_18_lab_e) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_17_elevator_c 0)

	(sleep_until (volume_test_players np_trigger_19_elevator_c) 1)
	(f_unblip_all)
	; to be continued in swamp_b_navpoints
)

(script dormant swamp_b_navpoints
	(sleep_until (volume_test_players tv_player_on_surface_swamp_b) 1)		; don't start navs until we're on the surface of the swamp and the first nav timeout can happen down low

	(sleep_until (volume_test_players tv_swamp_b_navpoint_safety) 1 (game_ticks_from_seconds 60))
	(f_blip_flag navpoint_18_swamp_b_mid 0)

	(sleep_until (volume_test_players np_trigger_20_swamp_b_mid) 1)
	(f_unblip_all)
	(f_blip_flag navpoint_19_tower 0)

	; the victory conditions are tied to a particular volume in front of the tower, so this last navpoint has special rules
	; when a player occupies the final volume, turn the navpoint off
	; when a player leaves the final volume, turn the navpoint on
	(sleep_until (volume_test_players swamp_b_trigger_final) 1)
	(wake f_obj_nonblocking_tower)
	(f_unblip_all)
	(sleep_until
		(begin
			(if (volume_test_players swamp_b_trigger_final)
				(begin 				; then, the player is in the volume
					(f_unblip_all)
				)
				(begin 				; else, turn the navpoint back on and remind the player
					(f_blip_flag navpoint_19_tower 0)
				)
			)
			(= b_mission_is_completing true) ; repeat until the mission ends
		)
	1 )

	(f_unblip_all) ; unblip at end of mission
)

; removes all navpoints used in the level
(script static void f_unblip_all
	(f_unblip_flag navpoint_1_pelican)
	(f_unblip_flag navpoint_2_swamp_a)
	(f_unblip_flag navpoint_3_entrance)
	(f_unblip_flag navpoint_3b_lift_a_control)
	(f_unblip_flag navpoint_4_lab_a)
	(f_unblip_flag navpoint_4b_lab_a_2f)
	(f_unblip_flag navpoint_5_above_marine)
	(f_unblip_flag navpoint_6_prison_room)
	(f_unblip_flag navpoint_6_prison_room_exit)
	(f_unblip_flag navpoint_7_prison_door)
	(f_unblip_flag navpoint_8_bay_a)
	(f_unblip_flag navpoint_9_lift_a_fall)
	(f_unblip_flag navpoint_10_steril_door)
	(f_unblip_flag navpoint_11_elevator_b)
	(f_unblip_flag navpoint_12a_bay_c)
	(f_unblip_flag navpoint_12b_bay_c_1f)
	(f_unblip_flag navpoint_13_lab_d_1f)
	(f_unblip_flag navpoint_14_lab_d_2f)
	(f_unblip_flag navpoint_15_lab_c)
	(f_unblip_flag navpoint_16_bay_e)
	(f_unblip_flag navpoint_16b_lab_e)
	(f_unblip_flag navpoint_17_elevator_c)
	(f_unblip_flag navpoint_18_swamp_b_mid)
	(f_unblip_flag navpoint_19_tower)
)



;=========================================
; objectives
; ui scripts block for 5 seconds because the ui layer doesn't queue; this just does the blocking global call in another thread
;==========================================
(script dormant f_obj_nonblocking_find
	(f_hud_obj_new "obj_c10_find" "obj_c10_find")
)

(script dormant f_obj_nonblocking_escape
	(sleep (game_ticks_from_seconds 3)) ; hold a beat before the escape and final navpoint so the door can finish opening
	(f_hud_obj_new_no_hud_completion "obj_c10_escape" "obj_c10_escape") ; don't show completion because the player has not actually found keyes.
)

(script dormant f_obj_nonblocking_lightbridge
	(f_hud_obj_new_no_hud_completion "obj_c10_broken_light_bridge" "obj_c10_broken_light_bridge") ; don't show completion because the player is not done escaping
)

(script dormant f_obj_nonblocking_surface
	(f_hud_obj_new "obj_c10_way_to_surface" "obj_c10_way_to_surface") ; finally, something you completed!  good job, player.
)

; complete without showing new here to acknowledge the surface so the marine objective can wait until after the vo line
(script dormant f_obj_nonblocking_complete_surface
	(f_hud_obj_complete)
)

(script dormant f_obj_nonblocking_marines_new
	(f_hud_obj_new_no_hud_completion "obj_c10_leadmarines" "obj_c10_leadmarines") ; don't show completion because we did that manually on the surface objective
)

(script dormant f_obj_nonblocking_tower
	(f_hud_obj_new_no_hud_completion "obj_c10_tower" "obj_c10_tower") ; don't show completion in case all the marines got eaten
)



;=========================================
; rally points
;==========================================

(script dormant c10_rally_point_unlocks
	(wake c10_unlock_insertion1_level_a)
	(wake c10_unlock_insertion1_level_b)
	(wake c10_unlock_next_level)
)

(script dormant c10_unlock_insertion1_level_a
	(sleep_until
		(or
			(f_insertion_point_script_is_blocked insertion_preflood)
			(volume_test_players int_a_trigger)
		) 1)

	(print_if b_debug "rally point c10: unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_c10_level_a")
	(f_unlock_insertion_point_with_incident_name "unlock_c10")
	(submit_incident_with_custom_string_id "game_activity_begin" "c10")
)

(script dormant c10_unlock_insertion1_level_b
	(sleep_until
		(or
			(f_insertion_point_script_is_blocked insertion_4_swamp_b)
			(volume_test_players int_lift_infector_trigger)
		) 1)

	(print_if b_debug "rally point c10: unlocking rally point charlie")
	(f_unlock_insertion_point_with_incident_name "ins_c10_level_b")
	(f_unlock_insertion_point_with_incident_name "unlock_c10")
	(submit_incident_with_custom_string_id "game_activity_begin" "c10")
)

(script dormant c10_unlock_next_level
	(sleep_until b_mission_is_completing 1)

	(print_if b_debug "rally point c10: unlocking next level - c20")
	(f_unlock_insertion_point_with_incident_name "unlock_c20")
)