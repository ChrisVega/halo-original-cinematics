;====================================================================================================================================================================================================
; global vars ==============================================================================================================================================
;====================================================================================================================================================================================================

;\\delays
(global long delay_blink (* 30 3))
(global long delay_dawdle (* 30 10))
(global long delay_tutorial (* 30 15))
(global long delay_prompt (* 30 10))
(global long delay_witness (* 30 5))
(global long delay_wait (* 30 10))
(global long delay_late (* 30 45))
(global long delay_lost (* 30 60))

;\\debug
(global boolean b_debug_gameplay true)
(global boolean b_debug_audio false)

;\\cutscene globals
(global boolean mark_bridge_cutscene false)

;\\mission globals
(global boolean b_a10_b_done false)
(global boolean b_a10_c_done false)

;\\vo globals
(global boolean b_cryo_intro_done false)
(global boolean b_look_at_tech_done false)
(global short g_red_square_progress 0)
(global short g_cryo_shield_progress 0)
(global short g_cryo_captain_order_progress 0)
(global boolean b_doom_crewman_ready false)
(global boolean b_explosion_reacted false)
(global boolean b_first_contact_dawdle false)
(global boolean b_dialog_final false)

;\\combat globals
(global boolean b_is_player_through_cryo false)
(global boolean b_airlock_1_boarded false)
(global boolean b_reached_stairwell1 false)
(global boolean b_reached_stairwell2 false)
(global boolean b_reached_cargohold false)
(global short s_bridge_living_count 0)
(global boolean b_kill_marines_enter_bridge false)
(global boolean b_past_possible_mutiney false)

;\\vignette globals
(global boolean b_mark_launch_1 false)
(global boolean b_mark_launch_3 false)
(global real r_blast_door_starting_position 0.7)
(global boolean b_show_radar false)

;====================================================================================================================================================================================================
; a10 startup ==============================================================================================================================================
;====================================================================================================================================================================================================

(script startup mission_a10
	(ai_allegiance player human)
	(a15_insertion_point_fixups)
	(f_start_auto_save_loop)

	;bypass the tutorial if any skulls are enabled or not solo easy/normal
	(set b_bypass_tutorials
		(or
			(not (solo_normal))
			(skull_any_enabled)
		)
	)

	(handle_early_grenades)

	(wake music_a15)
	(wake ambient_shake)
	(set s_ambient_shake_intensity 0)
	(wake navpoints_a10)


	(if (f_insertion_point_area_pending ins_start)
		(begin
			(cond
				((= (game_difficulty_get_real) legendary) (print "Original Cinematics: intro movie off")                 )
				((= (game_difficulty_get_real) heroic) (print "Original Cinematics: intro movie off")              )
				(true (print "Original Cinematics: intro movie off")              )
			)
			;load necessary doors, etc.
			(submit_incident_with_custom_string_id "game_activity_begin" "a10")
			(pre_bridge_load)
			(wake vignettes_fire)
			(wake tutorial_setup)

			(wake a10_b_to_the_bridge)
			(wake tutorial_first_contact)
			(wake mission_crossfire)
			(wake mission_bridge)

			(wake mission_cryo_explosion)
			(wake mission_blam_burn)
			(wake mission_blam_scare)
			(wake mission_containment_1)
			(wake dialog_flavor_cortana)
		)
	)

	(if (f_insertion_point_area_pending ins_cafeteria)
		(begin
			(submit_incident_with_custom_string_id "game_activity_begin" "a10")
			(sleep_until mark_bridge_cutscene 1)
			(wake mission_shoot)
			(wake mission_cafeteria)
			(wake mission_airlock_1)
			(wake dialog_flavor_captain_bravo)
		)
	)

	(if (f_insertion_point_area_pending ins_flank)
		(begin
			(submit_incident_with_custom_string_id "game_activity_begin" "a10")
			(wake mission_flank)
			(wake mission_loop)
			(wake loop_no_return)
		)
	)

	(if (f_insertion_point_area_pending ins_airlock2)
		(begin
			(submit_incident_with_custom_string_id "game_activity_begin" "a10")
			(wake mission_airlock_2)
			(wake mission_knot)
		)
	)


	(if (f_insertion_point_area_pending ins_stairs)
		(begin
			(submit_incident_with_custom_string_id "game_activity_begin" "a10")
			(wake mission_stairs)
			(wake mission_containment_2)
			(wake mission_lifepod_1)
			(wake mission_tunnel)
			(wake tunnel_blast_door_close)
			(wake dialog_flavor_captain_charlie)
			(wake reveal_radar)
		)
	)

	(if (f_insertion_point_area_pending ins_cryo)
		(begin
			(submit_incident_with_custom_string_id "game_activity_begin" "a10")
			(wake cryo_search)
			(wake mission_boom)
			(wake mission_crawl)
			(wake mission_final)
		)
	)
)

(script static boolean solo_normal
	(and
		(not (game_is_cooperative))
		(or
			(= (game_difficulty_get_real) easy)
			(= (game_difficulty_get_real) normal)
		)
	)
)

(script static void handle_early_grenades
	; early grenades only if tutorials were bypassed
	(if
		(f_insertion_point_area_pending ins_cafeteria)
		; then disable to start, cafeteria will handle later on
		(ai_grenades false)
		; else we'll handle now
		(ai_grenades b_bypass_tutorials)
	)
)

(script dormant vignettes_fire
; 	;vignettes
	(device_set_position_immediate dm_vignette_1_1_steam 1)
	(print_if (= (device_get_position dm_vignette_1_1_steam) 1) "dm_vignette_1_1_steam fired")
	;(device_set_position_immediate dm_vignette_1_2_explosion 1)
	;(print_if (= (device_get_position dm_vignette_1_2_explosion) 1) "dm_vignette_1_2_explosion fired")

	;(device_set_position_immediate dm_vignette_1_3_lights 1)
	;(print_if (= (device_get_position dm_vignette_1_3_lights) 1) "dm_vignette_1_3_lights fired")

; 	(device_set_position_immediate dm_vignette_2_4_decals 1)
; 	(print_if (= (device_get_position dm_vignette_2_4_decals) 1) "dm_vignette_2_4_decals fired")
; 	(device_set_position_immediate dm_vignette_2_5_lights 1)
; 	(print_if (= (device_get_position dm_vignette_2_5_lights) 1) "dm_vignette_2_5_lights fired")

; 	(device_set_position_immediate dm_vignette_3_2_decals 1)
; 	(print_if (= (device_get_position dm_vignette_3_2_decals) 1) "dm_vignette_3_2_decals fired")
; 	(device_set_position_immediate dm_vignette_3_3_lights 1)
; 	(print_if (= (device_get_position dm_vignette_3_3_lights) 1) "dm_vignette_3_3_lights fired")

; 	(device_set_position_immediate dm_vignette_4_2_decals 1)
; 	(print_if (= (device_get_position dm_vignette_4_2_decals) 1) "dm_vignette_4_2_decals fired")
; 	(device_set_position_immediate dm_vignette_4_3_lights 1)
; 	(print_if (= (device_get_position dm_vignette_4_3_lights) 1) "dm_vignette_4_3_lights fired")

; 	(device_set_position_immediate dm_vignette_7_2_lights_decals 1)
; 	(print_if (= (device_get_position dm_vignette_7_2_lights_decals) 1) "dm_vignette_7_2_lights_decals fired")

; 	(device_set_position_immediate dm_vignette_8_1_ticklanding 1)
; 	(print_if (= (device_get_position dm_vignette_8_1_ticklanding) 1) "dm_vignette_8_1_ticklanding fired")
; 	(device_set_position_immediate dm_vignette_8_3_decals_lights 1)
; 	(print_if (= (device_get_position dm_vignette_8_3_decals_lights) 1) "dm_vignette_8_3_decals_lights fired")
)

(script static void hide_radar_grenades
	;hides radar and grenade after insertion points and ui resets
	(if (solo_normal)
		(begin
			(chud_fade_grenades_for_player player0 0 1)
			(chud_fade_motion_sensor_for_player player0 0 1)
		)
	)
)

(script dormant reveal_radar
	(sleep_until b_show_radar)
	(chud_fade_motion_sensor_for_player player0 1 1)
)

(script dormant mission_cryo_explosion
	(print "mission_cryo_explosion")
	;beginning vignette 2

 	(game_save_no_timeout)

	(sleep_until (< .8 (device_get_position dm_cryo_explosion_door_3)) 1)
	;sleep until the cryo tech gets to the explosion trigger
	(sleep_until (volume_test_objects tv_cryo_explosion_trigger_2 (ai_actors sq_cryo_tech/tech)) 1)

	(sleep_until
		;sleep until the player gets to the trigger, moves forward past jump trigger,
		; or the players can see the door or tech
		(or
			(volume_test_players tv_cryo_explosion_trigger_2)
			(volume_test_players tv_moving_jump_success)
			(objects_can_see_object (players) dm_cryo_explosion_door_1 60)
			(objects_can_see_object (players) sq_cryo_tech/tech 60)
		)
		1
		;trigger the explosion after 5 seconds no matter what
		(game_ticks_from_seconds 5)
	)

	(set s_music_trigger 30)
	(set s_navpoint_index 1)

	;placeholder large camera shake
	;(pe_camera_shake_l)
	;(print_if b_debug_gameplay "large camera shake")

	;trigger vignette 2 elements
	(device_set_position_immediate dm_vignette_2_1_explosion 0.5)
	(print_if (= (device_get_position dm_vignette_2_1_explosion) 0.5) "dm_vignette_2_1_explosion fired")
	(device_set_position_immediate dm_vignette_2_2_explosion 0.5)
	(print_if (= (device_get_position dm_vignette_2_2_explosion) 0.5) "dm_vignette_2_2_explosion fired")
	(device_set_position_immediate dm_vignette_2_3_doorexplosion 0.5)
	(print_if (= (device_get_position dm_vignette_2_3_doorexplosion) 0.5) "dm_vignette_2_3_doorexplosion fired")
	(device_set_position_immediate dm_vignette_2_4_decals 1)
	(print_if (= (device_get_position dm_vignette_2_4_decals) 1) "dm_vignette_2_4_decals fired")
	(device_set_position_immediate dm_vignette_2_5_lights 1)
	(print_if (= (device_get_position dm_vignette_2_5_lights) 1) "dm_vignette_2_5_lights fired")

	(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:escape_explode" true) ; leomartinez edit

	(pe_camera_shake_l)

	;ensure the tech has almost no health
	(unit_set_current_vitality sq_cryo_tech/tech 0.1 0)
	(sound_impulse_start sound\dialog\combat\cryotech\default\11_involuntary\dth sq_cryo_tech/tech 1) ; manually scripting death sound as custom_animation disables systemic dth sounds
	;call a damage effect to hurt the player and the cryo tech if nearby
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_cryo_explosion_flag_3)
	(object_destroy sc_cryo_tech_datapad)

	;open the door with the explosion just a tiny bit, then turn off the power to show the red light
	(device_set_position dm_cryo_explosion_door_1 0.1)
	(sleep_until (= (device_get_position dm_cryo_explosion_door_1) 0.1) 1)

	(device_set_power dm_cryo_explosion_door_1 0)

	(device_set_position_immediate dm_vignette_2_1_explosion 1)
	(device_set_position_immediate dm_vignette_2_2_explosion 1)
	(device_set_position_immediate dm_vignette_2_3_doorexplosion 1)

	(sleep (game_ticks_from_seconds 1)) ;let the explosion clear before starting more
	(set s_ambient_shake_intensity 3)
)

;====================================================================================================================================================================================================
;
; blam_burn
;
; description: the vignette of the first blast door closing with an explosion
;====================================================================================================================================================================================================

(script dormant mission_blam_burn
	(print "mission_blam_burn")
	;set the blast door to a good starting position
	(device_set_position_immediate dm_blam_burn_door_1 r_blast_door_starting_position)
	(sleep_until (volume_test_objects tv_containment_1_trigger_1 (players)) 1)
	(set s_navpoint_index 2)


	(device_set_position dm_blam_burn_door_1 0)

	(sleep_until (objects_can_see_flag (players) fl_blam_burn_flag_3 30) 1 delay_witness)

	(pe_camera_shake_l)
	(device_set_position_immediate dm_vignette_4_unsc_explo1a 1)

;triggering vignette 4 elements
	(device_set_position_immediate dm_vignette_4_1_explosion 0.5)
	(print_if (= (device_get_position dm_vignette_4_1_explosion) 0.5) "dm_vignette_4_1_explosion fired")
	(device_set_position_immediate dm_vignette_4_2_decals 1)
	(print_if (= (device_get_position dm_vignette_4_2_decals) 1) "dm_vignette_4_2_decals fired")
	(device_set_position_immediate dm_vignette_4_3_lights 1)
	(print_if (= (device_get_position dm_vignette_4_3_lights) 1) "dm_vignette_4_3_lights fired")
 	(sleep 5)
	(device_set_position_immediate dm_vignette_4_unsc_explo1b 0.5)

 	(sleep 15)
	(pe_camera_shake_m)
	(device_set_position_immediate dm_vignette_4_unsc_explo1c 0.5)
 	(sleep 5)
	(device_set_position_immediate dm_vignette_4_unsc_explo1d 0.5)

	;close the door after the explosions
	(device_set_position dm_blam_burn_door_2 0)

	(sleep 2)
	(device_set_position_immediate dm_vignette_4_1_explosion 1)
	(device_set_position_immediate dm_vignette_4_unsc_explo1b 1)
	(device_set_position_immediate dm_vignette_4_unsc_explo1c 1)
	(device_set_position_immediate dm_vignette_4_unsc_explo1d 1)

)

(script dormant mission_blam_scare

	(sleep_until (volume_test_objects tv_blam_scare_trigger_2 (players)) 1)

	;placeholder small camera shake
	(pe_camera_shake_s)
	(print_if b_debug_gameplay "small camera shake")

	;trigger vignette 3 elements
	(device_set_position_immediate dm_vignette_3_1_explosion 0.5)
	(print_if (= (device_get_position dm_vignette_3_1_explosion) 0.5) "dm_vignette_3_1_explosion fired")
	(device_set_position_immediate dm_vignette_3_2_decals 1)
	(print_if (= (device_get_position dm_vignette_3_2_decals) 1) "dm_vignette_3_2_decals fired")
	(device_set_position_immediate dm_vignette_3_3_lights 1)
	(print_if (= (device_get_position dm_vignette_3_3_lights) 1) "dm_vignette_3_3_lights fired")
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_blam_scare_flag_3)


;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\wall_explode_01\wall_explode_01" fl_blam_scare_flag_3) ;----------------- wall explo main
	(sleep 5)
;	(object_create blam_steam_flame_1)
	(device_set_position_immediate dm_vignette_3_1_explosion 1)
)



;====================================================================================================================================================================================================
;
; containment
;
; description: the vignettes of the blast doors and crewman battling covenant
;====================================================================================================================================================================================================

(script dormant mission_containment_1
	(print "mission_containment_1")

	;set the blast door to a good starting position so players don't expect to be able to go through it
	(device_set_position_immediate dm_containment_1_door_3 r_blast_door_starting_position)

	(wake mission_containment_1_post)

	;sleep until the player gets to the door just before the first blast
	(sleep_until (volume_test_objects tv_containment_1_trigger_1 (players)) 1)

	;beginning vignette 3
	(game_save_no_timeout)

	;place rear security
	(ai_place sq_containment_1/rear_security)
	(object_cannot_take_damage (ai_actors sq_containment_1/rear_security))
	(unit_doesnt_drop_items (ai_actors sq_containment_1/rear_security))

	;place rear crewman
	(ai_place sq_containment_1/rear_crewman)
	(object_cannot_take_damage (ai_actors sq_containment_1/rear_crewman))
	(unit_doesnt_drop_items (ai_actors sq_containment_1/rear_crewman))

	(sleep_until (volume_test_objects tv_containment_1_trigger_2 (players)) 1)

	;place forward security unsc
	(ai_place sq_containment_1/forward_security)
	(object_cannot_take_damage (ai_actors sq_containment_1/forward_security))
	(units_set_current_vitality (ai_actors sq_containment_1/forward_security) 1 0)
	(unit_doesnt_drop_items (ai_actors sq_containment_1/forward_security))

	;place covenant
	(ai_place sq_containment_1_anti_re)
	(ai_berserk sq_containment_1_anti_re 0)
	(object_cannot_take_damage (ai_actors sq_containment_1_anti_re))
	(unit_doesnt_drop_items (ai_actors sq_containment_1_anti_re))

	;sleep until the player gets to the crouch area
	(sleep_until (volume_test_objects tv_moving_crouch_success (players)) 1)

	(object_can_take_damage (ai_actors sq_containment_1/rear_crewman))

	;show the first explosions and kill the rear crewman
	(device_set_position_immediate dm_vignette_4_plasma_explo1 0.5)
	(sleep 5)
	(pe_camera_shake_m)
	(device_set_position_immediate dm_vignette_4_unsc_explo2 0.5)

	(ai_kill sq_containment_1/rear_crewman)

	; make sure explos dont re-fire on reload
	(sleep 2)
	(device_set_position_immediate dm_vignette_4_plasma_explo1 1)
	(device_set_position_immediate dm_vignette_4_unsc_explo2 1)

	;close the containment door when players get to crouch trigger or the look at it
	(sleep_until
		(or
			(volume_test_players tv_moving_crouch)
			(objects_can_see_object (players) dm_containment_1_door_3 35)
		) 1 delay_witness)
	(device_set_position dm_containment_1_door_3 0)

	(cs_run_command_script sq_containment_1/rear_security cs_containment_1_security_retreat)

	;place elites at far end of hallway
	(ai_place sq_containment_1_anti_fe)
	(ai_berserk sq_containment_1_anti_fe 0)
	(object_cannot_take_damage (ai_actors sq_containment_1_anti_fe))
	(unit_doesnt_drop_items (ai_actors sq_containment_1_anti_fe))

	;sleep until the player gets out of the crouch area and into the hallway
	(sleep_until (or (volume_test_objects tv_containment_1_trigger_3 (players))
		(objects_can_see_object (players) dm_containment_1_door_2 30)) 1 delay_witness)

	;place the crewman that flees and cowers
	(ai_place sq_containment_1/flee_crewman)
	(unit_doesnt_drop_items (ai_actors sq_containment_1/flee_crewman))
	(object_cannot_take_damage (ai_actors sq_containment_1/flee_crewman))

	(wake dialog_containment)

	;kill forward security with blasts
	(object_can_take_damage (ai_actors sq_containment_1/forward_security))
	(device_set_position_immediate dm_vignette_4_4_explosion2 0.5)
	(print_if (= (device_get_position dm_vignette_4_4_explosion2) 0.5) "dm_vignette_4_4_explosion2 fired")
	(ai_kill sq_containment_1/forward_security)

	(device_set_position_immediate dm_vignette_4_5_plasma_explo3 0.5)

	;place the doom_crewman and have him flee to the blast doors, then close them when he gets there
	(ai_place sq_containment_1/doom_crewman)
	(object_cannot_take_damage (ai_actors sq_containment_1/doom_crewman))
	(units_set_current_vitality (ai_actors sq_containment_1/doom_crewman) 1 0)
	(unit_doesnt_drop_items (ai_actors sq_containment_1/doom_crewman))

	(set b_doom_crewman_ready 1)

	(ai_magically_see gr_containment_1_anti sq_containment_1)

	;close containment_1_door_1 a little when flee_crewman leaves volume
	(sleep_until (not (volume_test_objects tv_containment_1_slam (ai_actors sq_containment_1/flee_crewman))) 1)
	(device_set_position_immediate dm_containment_1_door_1 r_blast_door_starting_position)

	;make sure explo doesnt refire on reolad
	(device_set_position_immediate dm_vignette_4_4_explosion2 1)
	(device_set_position_immediate dm_vignette_4_5_plasma_explo3 1)


	;close containment_1_door_1 when player or doom_crewman gets to slam trigger
	(sleep_until (or
		(volume_test_players tv_containment_1_slam)
		(volume_test_objects tv_containment_1_slam (ai_actors sq_containment_1/doom_crewman))
		)
	1 delay_witness)

	(device_set_position dm_containment_1_door_1 0)
	(object_can_take_damage (ai_actors sq_containment_1/doom_crewman))

	(sleep (game_ticks_from_seconds 0.5))
	;close containment_1_door_2 and blow stuff up
	(device_set_position dm_containment_1_door_2 0)
	(sleep (game_ticks_from_seconds 1.0))
	(sleep 10)
	(pe_camera_shake_m)
	(device_set_position_immediate dm_vignette_4_5_explosion3 0.5)
	(print_if (= (device_get_position dm_vignette_4_5_explosion3) 0.5) "dm_vignette_4_5_explosion3 fired")
	(sleep 5)
	(device_set_position_immediate dm_vignette_4_unsc_explosion4 0.5)

	(ai_kill sq_containment_1/doom_crewman)

	(cs_run_command_script sq_containment_1_anti_fe cs_containment_1_anti_forward_elite)

	;after the door is fully closed, tell the player to get to the bridge
	(sleep_until (= 0 (device_get_position dm_containment_1_door_1)) 1)

	;make sure explos dont refire on reload
	(device_set_position_immediate dm_vignette_4_5_explosion3 1)
	(device_set_position_immediate dm_vignette_4_unsc_explosion4 1)

	(cs_run_command_script sq_containment_1/rear_security_0 cs_containment_1_dawdle) ; vo line if delay
)

(script dormant mission_containment_1_post
	;once the doors close, erase the ai behind them
	(sleep_until (= (device_get_position dm_containment_1_door_3) 0) 1)
	(ai_erase sq_containment_1_anti_re)

	(sleep_until (= (device_get_position dm_containment_1_door_1) 0) 1)
	(ai_erase sq_containment_1_anti_fe)
	(ai_erase sq_containment_1/forward_security)
	(ai_erase sq_containment_1/doom_crewman)
)

;containment command scripts

(script command_script cs_containment_1_security_retreat
	(cs_move_towards_point ps_containment_1/p_rear_sec 0.5)
)

(script command_script cs_containment_1_flee_crewman
	(cs_go_to ps_containment_1/p_flee_pause 0.5)
	(cs_face_player true)
	(cs_custom_animation_loop "objects\characters\marine\marine" "panic:duck_and_cover_idle" true)
	(sleep_until false)
)

(script command_script cs_containment_1_doom_crewman
	(cs_go_to ps_containment_1/p_doom_to)
	;turn around fast and duck
	(cs_custom_animation "objects\characters\marine\marine" "panic:turn_right_fast" true)
	(cs_custom_animation_loop "objects\characters\marine\marine" "panic:duck_and_cover_idle" true)
	(sleep_forever)
)

(script command_script cs_containment_1_anti_forward_elite
	(cs_move_towards_point ps_containment_1/p_forward_elite_to 0.5)
	(cs_enable_targeting true)
	(sleep_until false)
)

(script command_script cs_containment_1_dawdle
	(print_if b_debug_gameplay "cs_containment_1_dawdle")
	(sleep_until (volume_test_players tv_containment_1_trigger_3) 1)
	(cs_face_player true)
	(wake dialog_containment_dawdle)
	(sleep 90)
	(cs_enable_looking true)
	(sleep_until false)
)

;====================================================================================================================================================================================================
;
; first contact
;
; description: the jump scare with the roaring elite
; note: player controls are not locked in co-op
;====================================================================================================================================================================================================

(script dormant tutorial_first_contact
	(device_set_position_immediate dm_first_contact_door_1 0)
	(device_set_position_immediate dm_first_contact_door_4 1)

	(sleep_until (volume_test_objects tv_first_contact_trigger_2 (players)) 1)

	;spawn the marines, set them to be invincible and not drop any loot
	(ai_place gr_first_contact)
	(object_cannot_take_damage (ai_actors gr_first_contact))
	(units_set_current_vitality (ai_actors gr_first_contact) 1 0)
	(unit_doesnt_drop_items (ai_actors gr_first_contact))
	(ai_berserk gr_first_contact 0)

	;spawn the elite, set it to be invincible and not drop any loot
	(ai_place gr_first_contact_anti)
	(object_cannot_take_damage (ai_actors gr_first_contact_anti))
	(units_set_current_vitality (ai_actors gr_first_contact_anti) 1 0)
	(unit_doesnt_drop_items (ai_actors gr_first_contact_anti))
	(ai_magically_see gr_first_contact gr_first_contact_anti)

	;power on the door, but it's set to ignore players so it won't open until we want it to
	(device_set_power dm_first_contact_door_1 1)

	;if not co-op, lock the players controls and show letterbox
	(if (not (game_is_cooperative))
		(wake lock_player_controls_and_letterbox)
		;else
		(begin
			(device_ignore_player_set dm_first_contact_door_1 false)
			(set s_music_trigger 40)
		)
	)

	;after the door starts opening, marines start talking
	(sleep_until (< .3 (device_get_position dm_first_contact_door_1)) 1)


	(sleep_until (volume_test_objects tv_first_contact_trigger_3 (players)) 1)
	(close_first_contact_door)
	(wake dialog_first_contact)
)

(script dormant lock_player_controls_and_letterbox
	(player_disable_movement true)
	;disable floor is lava skull
	(skull_affects_players skull_floor_is_lava false)
	(chud_show_screen_chapter_title empty)
	(sleep 15)
	(device_ignore_player_set dm_first_contact_door_1 false)
	;(player_control_lock_gaze player0 ps_first_contact_1/elite 0.5)
	(set s_music_trigger 40)
	(sleep (game_ticks_from_seconds 4.25))
	(player_disable_movement false)
	;(player_control_unlock_gaze player0)
	;enable floor is lava skull
	(skull_affects_players skull_floor_is_lava true)
	(chud_clear_screen_chapter_title)
	(hide_radar_grenades)
)

(script static void close_first_contact_door
	(print "close first_contact_door and set the elite's command script")

	(sleep_until (volume_test_objects tv_first_contact_trigger_4 (ai_actors gr_first_contact_anti)) 1)

	;close the doors
	(device_set_position dm_first_contact_door_3 0)
	(sleep 30)

	; tell the elite to go back into the room.
	(cs_run_command_script sq_first_contact_rm1/rescue_marine_1 cs_first_contact_dawdle) ; vo line if delay

	;once the elite is in the room, turn off the power to the door so it won't open again
	(sleep_until (= (device_get_position dm_first_contact_door_3) 0) 1)
	(device_set_power dm_first_contact_door_3 0)
)

(script command_script cs_first_contact_elite
	;wait for a second for the door to open a little before starting roar and berserk
	(cs_enable_dialogue ai_current_actor false)

	(sleep 30)
	(ai_prefer_target_ai ai_current_squad gr_first_contact true)
	(ai_berserk ai_current_actor true)
	;(sleep 15) - it looks better with this sleep, but sometimes the elite makes other sounds and i don't know how to prevent that

	(cs_play_sound sound\dialog\combat\newelite1\default\13_script\a15_roar)

	;sleep a little longer than the sound duration to make sure the roar finishes before the elite starts shooting
	(sleep 15)

	;if any of this changes the elite doesn't run back like he's supposed to...
	(cs_shoot_point true ps_first_contact_1/p0)
	(cs_aim true ps_first_contact_1/p0)
	(sleep 60)
	(cs_move_towards_point ps_first_contact_1/p1 1)
	(sleep_until (= (device_get_position dm_first_contact_door_3) 0) 1)
	(sleep 30)
	(ai_erase ai_current_squad)
)

(script command_script cs_first_contact_dawdle
	(print_if b_debug_gameplay "cs_first_contact_dawdle")
	(sleep_until (volume_test_players tv_first_contact_trigger_3) 1)
	(cs_face_player true)
	(set b_first_contact_dawdle 1)
	(sleep 90)
)

;====================================================================================================================================================================================================
;
; fetch marine and crossfire
;
; description: the vignettes of the crossfire marines and fetch marine, dubbo
; dubbo leads the player to the bridge. he'll throw a grenade if player isn't too close
;====================================================================================================================================================================================================

(global short g_fetch_marine_progress 0)

(script dormant mission_crossfire
	;create the doors and equipment
	(pre_stairs_load)

	;set the blast doors to a good starting position
	(device_set_position_immediate dm_crossfire_door_1 r_blast_door_starting_position)
	(device_set_position_immediate dm_crossfire_door_2 r_blast_door_starting_position)

	;create the bipeds in the armory
	(object_create bi_unnamed_30)
	(object_create bi_unnamed_31)
	(object_create bi_unnamed_32)
	(object_create bi_unnamed_33)
	(object_create bi_unnamed_34)

	;destroy the rifles in the marines hands
	(object_destroy (object_at_marker bi_unnamed_30 "primary_weapon"))
	(object_destroy (object_at_marker bi_unnamed_31 "primary_weapon"))

	;play the injured animations on the marines
	(custom_animation_loop bi_unnamed_30 "objects\characters\marine\marine" "global_injured:unarmed:gut_ground" true)
	(custom_animation_loop bi_unnamed_31 "objects\characters\marine\marine" "global_injured:unarmed:leg_ground:var1" true)
	(custom_animation_loop bi_unnamed_32 "objects\characters\marine\marine" "alert:rifle:idle" true)

	;setting physics to false because the physics pill interpenetrates static mesh
	(object_set_physics bi_unnamed_31 false)

	(sleep_until (volume_test_objects tv_crossfire_trigger_1 (players)) 1)

	(game_save_no_timeout)
	;begin vignette 7

	;spawn the fetch marine, "dubbo", set him to be invincible and not drop any loot
	(ai_place sq_fetch_f)
	(object_cannot_take_damage (ai_actors sq_fetch_f))
	(units_set_current_vitality (ai_actors sq_fetch_f) 1 0)
	(unit_doesnt_drop_items (ai_actors sq_fetch_f))

	;spawn the crossfire marines, set them to be invincible and not drop any loot
	;both at the first blast door and the second blast door
	(ai_place gr_crossfire)
	(object_cannot_take_damage (ai_actors gr_crossfire))
	(units_set_current_vitality (ai_actors gr_crossfire) 1 0)
	(unit_doesnt_drop_items (ai_actors gr_crossfire))

	;spawn the crossfire covenant, set them to be invincible and not drop any loot
	(ai_place gr_crossfire_anti)
	(ai_berserk gr_crossfire_anti 0)
	(object_cannot_take_damage (ai_actors gr_crossfire_anti))
	(units_set_current_vitality (ai_actors gr_crossfire_anti) 1 0)
	(unit_doesnt_drop_items (ai_actors gr_crossfire_anti))

	;erase covenant once the doors close so they don't chatter behind them
	;also for performance
	(wake erase_ai_after_crossfire_doors_close)

	;sleep until the player gets close to the crossfire area or can see the covenant
	;this matches legacy behavior
	(sleep_until (or (volume_test_players tv_crossfire_trigger_2)
		(objects_can_see_flag (players) fl_crossfire_flag_2 30)) 1 delay_dawdle)

	;sleep until the players get into the armory or players can see the fetch marine
	;with a timeout of delay_dawdle
	(sleep_until
		(or
			(volume_test_objects tv_fetch_trigger_3 (players))
			(and
				(objects_can_see_object (players) (list_get (ai_actors sq_fetch_f) 0) 20)
				(volume_test_objects tv_fetch_trigger_2 (players))
			)
		)
		1
		delay_dawdle
	)

	;start closing the blast door
	(device_set_position dm_crossfire_door_1 0)

	(sleep_until
		(or
			(volume_test_objects tv_fetch_trigger_3 (players))
			(and
				(objects_can_see_object (players) (list_get (ai_actors sq_fetch_f) 0) 20)
				(volume_test_objects tv_fetch_trigger_2 (players))
			)
		)
		1
	)
	(print "fetch marine dialogue")
	(wake dialog_fetch)

	;sets a waypoint on the fetch marine as their dialogue begins.
	(f_blip_ai_offset sq_fetch_f 0 0)

	(sleep_until
		(or
			(volume_test_objects tv_fetch_trigger_3 (players))
			(and
				(objects_can_see_object (players) (list_get (ai_actors sq_fetch_f) 0) 20)
				(volume_test_objects tv_fetch_trigger_2 (players))
			)
		)
		1
	)
	(sleep 5)
	; (ai_command_list fetch/fetch fetch_1)
	(set g_fetch_marine_progress 1)

	(sleep_until (volume_test_objects tv_crossfire_trigger_4 (players)) 1)

	(set g_fetch_marine_progress 2)

	;sleep until the player gets close to the grenade throw (crossfire) area
	(sleep_until (volume_test_players tv_crossfire_trigger_4) 1)

	(object_can_take_damage (ai_actors sq_crossfire_2/rash_crewman))

	;trigger vignette 7 elements (plasma grenade explosion)
	(device_set_position_immediate dm_vignette_7_1_explosion 0.5)
	(print_if (= (device_get_position dm_vignette_7_1_explosion) 0.5) "dm_vignette_7_1_explosion fired")

	;this doesn't look hooked up
	(device_set_position_immediate dm_vignette_7_2_lights_decals 1)
	(print_if (= (device_get_position dm_vignette_7_2_lights_decals) 1) "dm_vignette_7_2_lights_decals fired")

	;this damage effect should kill the rash_crewman
	(damage_new "objects/weapons/grenade/plasma_grenade/damage_effects/plasma_grenade_explosion" fl_crossfire_flag_1)

	(set g_fetch_marine_progress 3)

	;(sleep_until (volume_test_players tv_crossfire_trigger_5) 1)
	;close the crossfire door if the fetch marine is not ready to throw grenade
	; (if
	; 	(not (volume_test_objects tv_crossfire_trigger_5 (ai_actors sq_fetch_f)))
	; 	(device_set_position dm_crossfire_door_2 0)
	; )
	;
	(device_set_position dm_crossfire_door_2 0)

	(sleep_until
		(or
			(volume_test_objects tv_bridge_trigger_1 (players))
			(objects_can_see_object (players) (list_get (ai_actors sq_fetch_f) 0) 30)
		)
		1
	)

	;make sure explo doesnt refire on reload
	(device_set_position_immediate dm_vignette_7_1_explosion 1)


	(set g_fetch_marine_progress 4)

	(sleep_until
		(or
			(objects_can_see_object (players) (list_get (ai_actors sq_fetch_f) 0) 15)
			mark_bridge_cutscene
		)
		1
	)

	(sleep_until mark_bridge_cutscene 1)
	(ai_erase gr_crossfire)
	(ai_erase sq_fetch_f)

	;destroy bipeds that aren't used anymore
	(object_destroy bi_unnamed_30)
	(object_destroy bi_unnamed_31)
	(object_destroy bi_unnamed_32)
	(object_destroy bi_unnamed_33)
	(object_destroy bi_unnamed_34)
)

(script dormant erase_ai_after_crossfire_doors_close
	;once the crossfire doors are closed, erase the ai behind them so they don't make noise
	;need to split the anti squad so they can be erased separately
	(sleep_until (= (device_get_position dm_crossfire_door_1) 0) 1)
	(ai_erase sq_crossfire_anti_1)

	(sleep_until (= (device_get_position dm_crossfire_door_2) 0) 1)
	(ai_erase sq_crossfire_anti_2)
)

(script command_script cs_rash_crewman
	;ensure the rash_crewman doesn't do anything except look around until he's killed by the grenade blast
	(cs_custom_animation_loop "objects\characters\marine\marine" "panic:duck_and_cover_idle" true)
	(sleep_forever)
)

(script command_script cs_fetch_marine
	(cs_enable_pathfinding_failsafe true) ; this helps with getting stuck
	(cs_ignore_obstacles true) ; this helps with getting stuck

	;tell the marine to target covenant
	(cs_enable_targeting true)

	(sleep_until (> g_fetch_marine_progress 0) 1)
	;once the player is in place, have the fetch marine look at the player for a bit
	(cs_enable_targeting false)
	(sleep 1)
	(cs_face_player true)

	;these timings are to make the marine not have bad animations while turning to and from the player
	(sleep (game_ticks_from_seconds 0.5))
	(cs_face_player false)
	(sleep (game_ticks_from_seconds 0.5))

	;run to the crossfire door
	(cs_go_to_and_face ps_fetch_1/p0 ps_fetch_1/p1)

	;sleep until the player gets close to the door
	(sleep_until (> g_fetch_marine_progress 1) 1)
	(if (>= (device_get_position dm_crossfire_door_2) 0.70) ;(= g_fetch_marine_progress 2)
		(begin
			;(cs_go_to_and_face ps_fetch_1/p0 ps_fetch_1/p1)
			(cs_grenade ps_fetch_1/p2 0)
		)
	)

	(sleep_until (> g_fetch_marine_progress 2) 1)
	;(cs_move_towards_point ps_fetch_1/p0 0.5)
	;(cs_move_towards_point ps_fetch_1/p0 0.5)

	(sleep_until (> g_fetch_marine_progress 3) 1)

	(cs_go_to ps_fetch_3/p0)
	(cs_face_player true)
	(cs_lower_weapon true) ; zfannon - isn't working?

	(sleep_until false)
)

(script dormant bridge_kill_kill_kill

	(set s_bridge_living_count (ai_living_count gr_bridge))
	(units_set_current_vitality (ai_actors sq_bridge_keyes/keyes) 1 0)
 	(sleep_until (< (ai_living_count gr_bridge) s_bridge_living_count))

	(if (not b_past_possible_mutiney) ; end if the bridge crew goes away because the player has past a point of no return and the crew was despawned
		(begin
			;canceling saves and autosave
			(f_pause_auto_save_loop)

			(print "bridge_kill_kill_kill")
			(device_set_position dm_bridge_kill_door_2 0)
			(device_set_power dm_bridge_kill_door_2 0)
			(volume_teleport_players_not_inside tv_bridge_all fl_x20_post_flag_2)

			(wake dialog_kill_kill_kill)
			(ai_allegiance_remove player human)
			(ai_set_objective gr_bridge obj_bridge_cower)
			(sleep 60)
			(ai_place sq_bridge_kill)
			(ai_cannot_die sq_bridge_kill true)
			(device_set_power dm_bridge_kill_door_1 1)
			(device_set_position dm_bridge_kill_door_1 1)
			(wake achievement_kill_and_corral)
		)
	)
)

(script command_script cs_bridge_kill_marines
	(cs_abort_on_damage true)
	(sleep (random_range 10 30)) ;adding a small jitter so the squad spreads out a bit
	(cs_go_by ps_bridge_kill/p0 ps_bridge_kill/p1)
	(cs_go_by ps_bridge_kill/p1 ps_bridge_kill/p3)
)

(script dormant achievement_kill_and_corral
	;sleep until we've killed keyes.
	(sleep_until (< (ai_living_count sq_bridge_keyes) 1))
	(print_if b_debug_gameplay "achievement | keyes is dead waiting on corraling of marines")

	;sleep until all reinforcement marines are trapped.
	(sleep_until (volume_test_objects_all tv_bridge_this_is_my_ship (ai_actors sq_bridge_kill)) 1)
	(submit_incident "trapped_keyes_reinforcements")
)

;(script command_script cs_bridge_kill_crew_reaction
;	(cs_action_at_player ai_action_hold)
;)

;====================================================================================================================================================================================================

; bridge

;====================================================================================================================================================================================================

(script dormant mission_bridge
	(print "mission_bridge")

	(sleep_until
		(or
			(volume_test_objects tv_bridge_trigger_1 (players))
			(f_insertion_point_script_is_blocked ins_cafeteria)
		)
		1
	)
; 	(game_save_no_timeout)
;	(set test_bridge_active true)
; 	(object_create keyesa10)
; 	(ai_attach_free keyesa10 characters\captain\captain)
; 	(unit_set_seat keyesa10 alert)
; 	(ai_command_list_by_unit keyesa10 keyes_2)
; 	(bridge_flavor)
	(set s_ambient_shake_intensity 0)

	(ai_place gr_bridge)

	(sleep_until
		(or
			(volume_test_objects tv_bridge_cinematic (players))
			(f_insertion_point_script_is_blocked ins_cafeteria)
		)
		1
	)

	(print "Original Cinematics: bridge movie off")                           
	(wake chapter_a15_2)
	(pre_bridge_cleanup)

	(wake space_battle_flyby_bridge)
	(wake bridge_kill_kill_kill)
	(object_destroy (object_at_marker sq_bridge_keyes/keyes "primary_weapon"))

	(print "wake keyes nameplate script")
	(wake nav_nameplate_keyes)

	(print_if b_debug_gameplay "insertion point: cafeteria unlocked")
	(submit_incident "ins_a10_cafeteria")
	(wake dialog_post_bridge_cinematic)

	(set s_ambient_shake_intensity 1)
	(player_set_profile profile_respawn_weapons)
; 	(vehicle_load_magic pilot_1 "" (ai_actors bridge/pilot_crewman_1))
	(device_set_position dm_bridge_door_1 0)
	(device_set_position_immediate dm_bridge_door_2 0)
	;turn off the power so that it's a red light when coming back through
	(device_set_power dm_bridge_door_2 0)
	(device_set_position_immediate dm_bridge_door_3 0)
	(device_set_power dm_bridge_door_3 0)
	(device_set_position_immediate dm_bridge_door_4 1)

	(set mark_bridge_cutscene true)
	(device_set_position_immediate dm_crossfire_door_1 0)
	(device_set_position_immediate dm_crossfire_door_2 0)
; 	(wake bridge_leave_prompt)

	;objective ui
	(f_hud_obj_new "dia_a10_escape" "obj_a10_escape")
	(set s_navpoint_index 3)
)



(script dormant	nav_nameplate_keyes
	(print "giving keyes his nameplate")
	(f_hud_hero_waypoint sq_bridge_keyes hero_keyes hero_default_max_dist)
)

(script dormant cortana_shield_down
	(sleep_until (= (object_get_shield player0) 0) 1)
	(if (not (ai_allegiance_broken player human))
			(wake dialog_shield_down)
	)
)

(script dormant cortana_airlock
	(sleep_until
		(or
			(volume_test_objects tv_boarding_trigger_1 (players))
			(volume_test_objects tv_boarding_trigger_2 (players))
		)
		1
	)
	(wake dialog_airlock)
	(wake dialog_overshield)
)

(script command_script cs_sitting_crew_0
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc1/pod_crewman_1))
	(sleep_forever)
)

(script command_script cs_sitting_crew_1
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc2/pod_crewman_2))
	(sleep_forever)
)
(script command_script cs_sitting_crew_2
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc3/pod_crewman_3))
	(sleep_forever)
)

(script command_script cs_sitting_crew_3
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc4/pod_crewman_4))
	(sleep_forever)
)

(script command_script cs_sitting_crew_4
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc5/pod_crewman_5))
	(sleep_forever)
)

(script command_script cs_sitting_crew_5
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc6/pod_crewman_6))
	(sleep_forever)
)

(script command_script cs_sitting_crew_6
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc7/pod_crewman_7))
	(sleep_forever)
)

(script command_script cs_sitting_crew_7
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc8/pod_crewman_8))
	(sleep_forever)
)

(script command_script cs_sitting_crew_8
	(vehicle_load_magic blamvehicle_bridgeseats "" (ai_actors sq_bridge_pc9/pod_crewman_9))
	(sleep_forever)
)

(script command_script cs_standing_keyes
	(cs_custom_animation_loop "objects\characters\marine\marine" "combat:unarmed:idle" true)
	(sleep_forever)
)

(global boolean b_player_picked_up_magnum false)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encoutner 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_shoot
	(print "mission_shoot")
	(object_create bi_bridge_marine)
	(object_create w_bridge_magnum)
	(custom_animation_loop bi_bridge_marine "objects\characters\marine\marine" "global_injured:unarmed:gut_ground" true)

	;destroy the rifle in the marine's hands
	(object_destroy (object_at_marker bi_bridge_marine "primary_weapon"))

	(sleep_until
		(or
			(volume_test_players tv_shoot_trigger_1 )
			(unit_has_weapon player0 objects\weapons\pistol\magnum\magnum.weapon)
			(unit_has_weapon player1 objects\weapons\pistol\magnum\magnum.weapon)
			(unit_has_weapon player2 objects\weapons\pistol\magnum\magnum.weapon)
			(unit_has_weapon player3 objects\weapons\pistol\magnum\magnum.weapon)
		)
		1
	)
	(f_player_handle_magnum player0)
	(f_player_handle_magnum player1)
	(f_player_handle_magnum player2)
	(f_player_handle_magnum player3)

	(if (not b_player_picked_up_magnum)
		; still on the ground, clean up
		(object_destroy w_bridge_magnum)
	)

	(ai_place sq_shoot_anti)
	(unit_doesnt_drop_items (ai_actors sq_shoot_anti))
	(f_ai_magically_see_players sq_shoot_anti)

	(sleep_until (volume_test_players tv_shoot_trigger_1)1)
	(sleep (game_ticks_from_seconds 15)) ;give players time to figure out how to shoot enemies
	(f_blip_ai sq_shoot_anti 1) ;blip any enemies here alive if the players hasn't figured out they need to kill them
)

(script static boolean (f_player_handle_magnum (unit player_name))
	(if
		(unit_has_weapon player_name objects\weapons\pistol\magnum\magnum.weapon)
		(set b_player_picked_up_magnum true)
		(begin
			; then give them one now
			(unit_add_equipment player_name profile_bridge false false)
			false
		)
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encoutner 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_cafeteria
	(print "mission_cafeteria")
	;lock the door so player can't backtrack
	(device_set_position_immediate  dm_bridge_door_1 0)
	(device_set_power dm_bridge_door_1 0)

	(sleep_until (volume_test_objects tv_cafeteria_trigger_1 (players)) 1)
	(wake cortana_shield_down)

	;;;;;;;;;play fighting until the player arrives
	(ai_place sq_cafeteria_anti_ie)
	(ai_place sq_cafeteria_anti_ig)

	;;;;;;;;;;opens up cafeteria after tutorial grunts are dead
	(sleep_until (= 0 (ai_nonswarm_count sq_shoot_anti)) 5 delay_lost)
	; early grenades only if tutorials were bypassed
	(ai_grenades b_bypass_tutorials)
	(set s_music_trigger 60)
	(ai_place sq_cafeteria_im)
	(object_create w_cafeteria_ar)
	(game_save_no_timeout)
	(device_set_power dm_cafeteria_door_4 1)
	(device_set_position dm_cafeteria_door_4 1)

	;;;;;;;;;;;when player enters, enemies can take damage
	(sleep_until (volume_test_objects tv_cafeteria_trigger_2 (players)) 1)
	(object_can_take_damage (ai_actors sq_cafeteria_anti_ie))
	(wake dialog_cafeteria)

	(set s_navpoint_index 4)

	(sleep_until
		(or
			(< (ai_living_count gr_cafeteria_anti_init) 3)
			(volume_test_objects tv_cafeteria_trigger_3 (players))
		)
		1
	)

	(ai_place sq_cafeteria_rm)
	;open hallway doors
	(device_set_power dm_cafeteria_door_1 1)
	(device_set_position dm_cafeteria_door_1 1)
	(device_set_power dm_cafeteria_door_2 1)
	(device_set_position dm_cafeteria_door_2 1)
	(device_set_power dm_cafeteria_door_3 1)
	(device_set_position dm_cafeteria_door_3 1)

	(sleep_until
		(or
			(= 0 (ai_living_count gr_cafeteria_anti_init))
			(volume_test_objects tv_cafeteria_trigger_3 (players))
		)
		1
	)

	;;;;;;;;;;;;;enemies spawn and enter platform
	(ai_place gr_cafeteria_anti_left)
	(ai_place gr_cafeteria_anti_right)
	;open airlock door
	(device_set_power dm_bsp1_door 1)
	(device_set_position dm_bsp1_door 1)

	(sleep_until
		(or
			(< (ai_living_count gr_cafeteria_anti_right) 3)
			(volume_test_objects tv_cafeteria_trigger_6 (players))
		)
		1
	)

	;(f_ai_magically_see_players sq_cafeteria_anti_rg2)
	; music
	(sleep_until
		(or
			(volume_test_players tv_cafeteria_trigger_5)
			(and
				(= 0 (ai_nonswarm_count gr_cafeteria_anti_right))
				(= 0 (ai_nonswarm_count gr_cafeteria_anti_left))
			)
		)
		1
	)
	(set s_music_trigger 70)

	(sleep (game_ticks_from_seconds 10))  ;starts waiting 10 seconds after the player has already left the area to remove any enemies still hanging out
	(ai_disposable gr_cafeteria_anti true)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encoutner 3,encoutner 4,encounter 5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_airlock_1
	(sleep_until (volume_test_objects tv_bsp1_2 (players)) 1)
	(wake cortana_airlock)
	; hold shake for dialogue
	(set s_ambient_shake_intensity 0)

	;we've moved past the keyes encounter stop achievement check
	(sleep_forever achievement_kill_and_corral)

	;adding coop overshields for 3-4 player coop
	(if (> (game_coop_player_count) 2)
		(begin
			(object_create eq_1_os_3_coop)
			(object_create eq_1_os_4_coop)
		)
	)

	;begin vignette 8
	(wake space_battle_flyby_airlock)
	(device_set_position_immediate dm_airlock_1_door_1 0) ;door had to be left open for navmesh generation, set to close as intended before player arrives

	(game_save_no_timeout)
	(ai_place gr_airlock_1)
	(units_set_current_vitality (ai_actors sq_airlock_1_am) 1 0)
	(ai_place sq_airlock_1_anti_be)
	(ai_magically_see sq_airlock_1_anti_be sq_airlock_1_im)
	(wake mission_tick_2)

	(sleep_until
		(or
			(volume_test_players tv_airlock_1_trigger_1)
			(= (ai_living_count sq_airlock_1_anti_be) 0)
		)
	1)
	(wake tick_impacts_ship)

	(sleep_until (volume_test_players tv_airlock_1_trigger_2) 1)

	;trigger vignette 8 elements
	(device_set_position_immediate dm_vignette_8_1_ticklanding 1)
	(print_if (= (device_get_position dm_vignette_8_1_ticklanding) 1) "dm_vignette_8_1_ticklanding fired")
	(device_set_position_immediate dm_vignette_8_4_lasercutter 0.5)

	(sleep_until
		(or
			(volume_test_players tv_airlock_1_trigger_3)
			(and
				(< (objects_distance_to_object (players) dm_airlock_1_door_1) 9)
				(objects_can_see_object (players) dm_airlock_1_door_1 25)
			)
		)
		1
	)

	(sleep (game_ticks_from_seconds 0.5))

	(pe_camera_shake_m)

	;trigger vignette 8 elements
	(device_set_position_immediate dm_vignette_8_2_explosion 0.5)
	(print_if (= (device_get_position dm_vignette_8_2_explosion) 0.5) "dm_vignette_8_2_explosion fired")
	(device_set_position_immediate dm_vignette_8_3_decals_lights 1)
	(print_if (= (device_get_position dm_vignette_8_3_decals_lights) 1) "dm_vignette_8_3_decals_lights fired")

	;call a damage effect to hurt the player if nearby and marines
	(damage_new "objects/weapons/grenade/plasma_grenade/damage_effects/plasma_grenade_explosion" fl_airlock_1_flag_1)

	(object_destroy dm_airlock_1_door_1)
	(sleep 2)
	; make sure explo doesnt refire on reload
	(ai_place gr_airlock_1_anti_boarding)
	(device_set_position_immediate dm_vignette_8_2_explosion 1)
	(device_set_position_immediate dm_vignette_8_4_lasercutter 0)

	; (ai_place gr_airlock_1_anti_boarding)
	(set b_airlock_1_boarded true)
	(set s_music_trigger 90)
	;(ai_magically_see gr_airlock_1_anti_boarding sq_airlock_1_im)

	(sleep_until (volume_test_objects tv_airlock_1_trigger_6 (players)) 1)
	(ai_place sq_airlock_1_anti_e)
	(unit_set_stance sq_airlock_1_anti_e "panic")

	(fireteam_setup)
	(ai_set_fireteam_absorber sq_airlock_1_im true)

	(sleep (game_ticks_from_seconds 10)) ;starts waiting 10 seconds after the player has already left the area to remove any enemies still hanging out
	(ai_disposable gr_airlock_1_anti true)
)

(script static void fireteam_setup
	(ai_player_add_fireteam_squad player0 sq_fireteam_player0)
	; 4 minus players
	(ai_player_set_fireteam_max player0 (- 4 (game_coop_player_count)))
	; wide radius, to replenish the fallen if reasonably close by
	(ai_player_set_fireteam_max_squad_absorb_distance player0 25.0)
)

(script command_script cs_airlock_1_look
	(cs_look true ps_airlock_1/p0)
	(sleep_until false)
)

(script dormant tick_impacts_ship
	(set s_navpoint_index 5)
	(sleep (game_ticks_from_seconds 2))

 	(pe_camera_shake_l)
	(set s_ambient_shake_intensity 2)
	(sleep (game_ticks_from_seconds 1))
	(wake dialog_airlock_explosion)
	(set s_music_trigger 80)

)

(script dormant mission_tick_2
	;attach tick 2 to the guide rails and then set the track to its starting position.
	(objects_attach dm_airlock_2_tick_2 "" dm_airlock_2_tick_2_track "attach")
	(device_set_position dm_airlock_2_tick_2_track .2)

	(sleep_until (volume_test_objects tv_airlock_1_tick_2 (players)) 1)

	;tick moves in
	(device_set_position dm_airlock_2_tick_2_track 0)

	;rail hits its limit
	(sleep_until (> (device_get_position dm_airlock_2_tick_2_track) .01) 1)

	;tick extends to final position.
	(device_set_position dm_airlock_2_tick_2 .999)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 6;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_flank
	(sleep_until (volume_test_objects tv_flank_trigger_1 (players)) 1)
	(set s_navpoint_index 8)
	(game_save_no_timeout)

	(set s_music_trigger 100)

	(sleep 5)
	(ai_place sq_flank)
	(ai_place gr_flank_anti)

	(sleep_until (<= (ai_nonswarm_count gr_flank_anti) 0) 1)
	(ai_set_fireteam_absorber sq_flank true)
	(set s_music_trigger 110)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 7;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_loop
	(sleep_until
		(volume_test_objects tv_loop_trigger_1 (players))
		1
	)
	(set s_music_trigger 120)
	(game_save_no_timeout)
	(ai_place sq_loop)

	(ai_place sq_loop_anti_ie)
	(ai_place sq_loop_anti_ig)
	(ai_magically_see sq_loop gr_loop_anti)
	(ai_magically_see gr_loop_anti sq_loop)

	(ai_braindead sq_loop/doom_crewman 1)
	(device_set_position dm_loop_broken_door .3)


	(sleep 5)
	;_oldvignette(effect_new "fx\explosions\common\explo_cov_vert_med" fl_loop_flag_1);------------------- plasma explos loop 1
	(sleep 30)
	;_oldvignette(effect_new "fx\explosions\common\explo_unsc_hor_lrg" fl_loop_flag_2);------------------- plasma explos loop 2

	(ai_kill sq_loop/doom_crewman)

	(sleep_until
		(or
			(volume_test_objects tv_loop_trigger_2 (players))
			(volume_test_objects tv_loop_trigger_3 (players))
		)
		1
	)
	; (object_pvs_clear)
	(ai_place sq_loop_anti_rg)

	(sleep_until (= 0 (ai_nonswarm_count gr_loop_anti)) 1)
	(ai_set_fireteam_absorber sq_loop true)
	;(sleep 15)
	; (ai_migrate loop airlock_2/airlock)
)

(script dormant loop_no_return
	(sleep_until (volume_test_objects tv_loop_trigger_4 (players)) 1)

	(volume_teleport_players_not_inside tv_loop_trigger_5 fl_loop_flag_1)

	(device_set_position_immediate dm_bsp2_door 0)
	(device_set_power dm_bsp2_door 0) ; turn off door.

	(pre_tick2_cleanup)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 8;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_airlock_2
	(sleep_until (volume_test_objects tv_airlock_2_trigger_1 (players)) 1)
	(game_save_no_timeout)

	;adding coop overshields for 3-4 player coop
	(if (> (game_coop_player_count) 2)
		(begin
			(object_create eq_3_os_3_coop)
			(object_create eq_3_os_4_coop)
		)
	)

	(ai_place gr_airlock_2_anti)
	; (ai_magically_see_encounter airlock_2 airlock_2_anti)
	; (ai_magically_see_encounter airlock_2_anti airlock_2)
	;(sleep 30)
	(pre_tunnel_load)

)

(script command_script cs_crouch_door
	(cs_enable_targeting true)
	(cs_enable_moving true)
	(cs_enable_looking true)

	(sleep_until
		(begin
			; hack until ai bsp transitions are fixed
			(if
				(volume_test_object zone_set:zs_02 ai_current_actor)
				(begin
					(cs_move_towards_point ps_airlock_1_bsp_hack/p0 0.5)
					(cs_move_towards_point ps_airlock_1_bsp_hack/p1 0.5)
					(cs_move_towards_point ps_airlock_1_bsp_hack/p2 0.5)
				)
			)
			(if
				(volume_test_players tv_knot_trigger_1)
				(begin
					(sleep_until (volume_test_object tv_knot_crouch ai_current_actor) 1)
					(cs_crouch true)
					(sleep_until (not (volume_test_object tv_knot_crouch ai_current_actor)))
					(cs_crouch false)
				)
			)

			false ; forever
		)
	)
)

(script command_script cs_abort
	(sleep 1)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 9;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_knot
	(sleep_until (volume_test_objects tv_knot_trigger_1 (players)) 1)
	(game_save_no_timeout)

	(sleep_until (volume_test_objects tv_knot_trigger_2 (players)) 1)
	(ai_place gr_knot)

	(sleep (game_ticks_from_seconds 1)) ;allows the scienists a moment to run before their persuers spawn
	(ai_place gr_knot_anti)

	(sleep_until (volume_test_players tv_bsp3_4) 1) ; wait until the player moves far enough into the encounter
	(device_set_position dm_bsp3_door_a 0) ; beginning locking players in and stopping backtracking.
	(wake dialog_blast_door_warning)

	(sleep_until (= (device_get_position dm_bsp3_door_a) 0) 1)
	(device_set_power dm_bsp3_door_a 0) ; turn off door.

	(pre_stairs_cleanup)

	(if (game_is_cooperative) (volume_teleport_players_not_inside begin_zone_set:zs_03 fl_stairs_teleport)) ;explicitly warping players that manage to sneak out of huge trigger and get stuck behind the door
)

(script command_script cs_knot_last_stand_1
	(cs_go_to ps_knot/p0)
	(cs_custom_animation_loop "objects\characters\marine\marine" "panic:duck_and_cover_idle" true)
	(sleep_until false)
)

(script command_script cs_knot_last_stand_2
	(cs_go_to ps_knot/p2)
	(cs_custom_animation_loop "objects\characters\marine\marine" "panic:duck_and_cover_idle" true)
	(sleep_until false)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 10;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_stairs
	(sleep_until (= (current_zone_set_fully_active) 2) 1)

	(print_if b_debug_gameplay "insertion point: stairs unlocked")
	(submit_incident "ins_a10_stairs")

	(game_save_no_timeout)

	(device_set_position_immediate dm_stairs_door_1 0) ;door had to be left open for navmesh generation, set to close as intended before player arrives
	(device_set_position_immediate dm_stairs_door_2 0) ;door had to be left open for navmesh generation, set to close as intended before player arrives

	(wake space_battle_flyby_observation)


	;pulling players forward so we can unload the view from the tick windows and move to the observation deck.
	; (volume_teleport_players_not_inside tv_bsp3_4 fl_stairs_flag_1)

	;closing door behind players to prevent backtracking.
	; inserstion point does this to dm_bsp3_door_b which reduces player confusion
	; but that door is too close to the zone set teleportation to use here


	(ai_place sq_stairs_im)
	(ai_place sq_stairs_anti_ie)
	(ai_place sq_stairs_anti_ig)

	; (ai_magically_see gr_stairs gr_stairs_anti)
	;(ai_magically_see gr_stairs_anti gr_stairs)

	(cs_run_command_script sq_fireteam_player0 cs_abort)
	(ai_migrate sq_fireteam_player0 sq_stairs_im)

	(sleep_until
		 (or
		 	(< (ai_living_count gr_stairs_anti_init) 4)
			(volume_test_players tv_stairs_trigger_5)
		 )
		1
	)

	(set s_navpoint_index 13)

	(wake dialog_stairs)
	(set s_music_trigger 130)

	(sleep_until
		 (or
		 	(<= (ai_living_count gr_stairs_anti_init) 3)
			(volume_test_players tv_stairs_trigger_2)
		 )
		1
	)
 	(ai_place sq_stairs_anti_lg)
	(device_set_power dm_stairs_door_1 1)
	(device_set_position dm_stairs_door_1 1)

	(sleep_until
		 (or
			(<= (ai_living_count sq_stairs_anti_lg) 1)
			(volume_test_players tv_stairs_trigger_2)
		 )
		1
	)
	(sleep 90)
	(ai_place sq_stairs_anti_ue)
	(ai_place sq_stairs_anti_ug)
	(device_set_power dm_stairs_door_2 1)
	(device_set_position dm_stairs_door_2 1)

	(sleep_until (= 0 (ai_living_count gr_stairs_anti)) 1)
	(set s_music_trigger 140)

	(sleep_until
		(and
			(volume_test_objects_all tv_stairs_elevator2 (ai_actors gr_stairs))
			(not (volume_test_players tv_stairs_elevator))
		)
		1
	)

	(device_set_position dm_stairs_door_2 0)
	(device_set_power dm_stairs_door_2 0)

	(sleep (game_ticks_from_seconds 10)) ;starts waiting 10 seconds after the player has already left the area to remove any enemies still hanging out
	(ai_disposable gr_stairs true)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 11;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_containment_2
	(sleep_until (volume_test_objects tv_containment_2_trigger_1 (players)) 1)
	(set s_ambient_shake_intensity 3)
	(game_save_no_timeout)
	(ai_place gr_containment_2_anti)
	(ai_migrate gr_stairs gr_containment_2)
	;(wake navpoint_obslounge)
	(post_tunnel_load)
)

(script command_script cs_containment_2_shield
	(cs_abort_on_damage true)
	(cs_enable_moving false)

	(sleep_until
		(or
			(< (objects_distance_to_object (players) (ai_get_object ai_current_squad)) 7)
			(< (ai_living_fraction sq_containment_2_anti_rg) 1)
		)
		1
	)
	(cs_enable_moving true)
)

;(script dormant navpoint_obslounge
;	(sleep_until (volume_test_players tv_intercom_trigger_83) 1)
;	(set s_navpoint_index 14)
;)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 12;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_lifepod_1
	(wake lifepod_1_flavor)
	(sleep_until (volume_test_objects tv_lifepod_1_trigger_1 (players)) 1)
	(set s_music_trigger 150)
	(game_save_no_timeout)
	(ai_place gr_lifepod_1_anti)
)

(script dormant lifepod_1_launch_1
	;(sleep_until (objects_can_see_object (players) dm_lifepod_1_bdoor_1 40) 1 )

	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_explo_zero_g" fl_lifepod_1_bflag_1) ;------------------ lifepod explo 1
	; -------------------------------------------------------- this effect is the first lifepod door opening, this lifepod escapes? no laser/explo combo hits this pod - then the next spacebeams (a,b,c,d,e) fire
	; -------------------------------------------------------- i think its supposed to be destroyed but thats not set up, you can watch the pod turn off in game - sawicki

	(sleep 3)
	(object_destroy dm_lifepod_1_bdoor_1)
	(device_set_power dm_lifepod_1_1 1)
	(device_set_position dm_lifepod_1_1 1)
	(pe_camera_shake_s)
	(sleep 15)

	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_01" fl_spacebeam_1_flag_1a) ;------------------ space beam a
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a)
	(sleep 10)
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_02" fl_spacebeam_1_flag_1a2) ;------------------ space beam b
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a2)
	(sleep 5)
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_03" fl_spacebeam_1_flag_1a3) ;------------------ space beam c
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a3)
	(sleep 15)
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_01" fl_spacebeam_1_flag_1a4) ;------------------ space beam d
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a4)
	(sleep 10)
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_02" fl_spacebeam_1_flag_1a5) ;------------------- space beam e
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a5)
	(sleep 10)
	(set b_mark_launch_1 true)

	(sleep_until (> (device_get_position dm_lifepod_1_1) .75) 1)
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\lifepod_destruction" fl_lifepod_1_flavor_flag_1) ;--- lifepod explo x1 --- remove?
	(sleep (game_ticks_from_seconds .7))
	(object_destroy dm_lifepod_1_1)
)

(script dormant lifepod_1_launch_3
	;(sleep_until (objects_can_see_object (players) dm_lifepod_1_bdoor_3 40) 1 )
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_explo_zero_g" fl_lifepod_1_bflag_3) ;----------------- lifepod explo 2 -- door open effect
	; -------------------------------------------------------- this effect is the second lifepod door opening, then the next spacebeams (1a and 1b) fire, then lifepod explo a fire (door open)
	; -------------------------------------------------------- then spacebeam 1c and t1 fire
	(sleep 3)

	(object_destroy dm_lifepod_1_bdoor_3)
	(device_set_power dm_lifepod_1_3 1)
	(device_set_position dm_lifepod_1_3 1)

	;(pe_camera_shake_s)
	;(sleep 15)
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_01" fl_spacebeam_1_flag_1a) ;-------------- space beam 1a
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a)
	;(sleep 10)
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_02" fl_spacebeam_1_flag_1a2) ;---------------- space beam 1b
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a2)
	;(sleep 5)
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_03" fl_spacebeam_1_flag_1a3) ;---------------- space beam 1c --------------------------------------------------------------------------------------
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a3)
	;(sleep 15)
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_02" fl_spacebeam_1_flag_1a4) ;---------------- space beam 1d
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_impact" fl_spacebeam_1_flag_1a4)
	;(sleep 10)
	;(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_laser_01" fl_spacebeam_1_flag_1a5) ;------------------ space beam 1e
	;(sleep 10)

	(set b_mark_launch_3 true)

	(sleep_until (> (device_get_position dm_lifepod_1_3) .85) 1)
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\lifepod_destruction" fl_lifepod_1_flavor_flag_3) ;------------------ lifepod explo x3 - this kills lifepod 3
	(sleep (game_ticks_from_seconds .7))
	(object_destroy dm_lifepod_1_3)

)


 (script dormant lifepod_1_flavor
 	(sleep_until (volume_test_objects tv_lifepod_1_trigger_1 (players)) 1)
	;begin vignette 10

	(wake dialog_lifepod_launch)
 	(object_create dm_lifepod_1_1)
 	(object_create dm_lifepod_1_2)
 	(object_create dm_lifepod_1_3)
 	(object_create dm_lifepod_1_bdoor_1)
 	(object_create dm_lifepod_1_bdoor_2)
 	(object_create dm_lifepod_1_bdoor_3)

	;(sleep_until (volume_test_players tv_lifepod_1_trigger_1 )1)
 				  ;*(volume_test_objects tv_lifepod_1_trigger_2 (players))) 1)
 	(set b_test_lifepod_blasts false)
 	(sleep_until (or (volume_test_objects tv_lifepod_trigger_3 (players))
 				  (not b_mark_lifepod_blasts)) 1)*;

	(wake lifepod_1_launch_1)
 	;(sleep_until (or (volume_test_objects tv_lifepod_trigger_3 (players))
 	;			  b_mark_launch_1) 1)
 	;(sleep_until (volume_test_objects tv_lifepod_trigger_3 (players)) 1 30)
 	(sleep_until (volume_test_players tv_lifepod_1_trigger_2 )1)

	(wake lifepod_1_launch_3)

 	;*(sleep_until (or (volume_test_objects tv_lifepod_trigger_3 (players))
 				  b_mark_launch_1) 1)

 	(sleep_until (or (volume_test_objects tv_lifepod_trigger_3 (players))
 				  (volume_test_objects tv_lifepod_trigger_3 (players))) 1 30)*;
 	;(sleep_until (objects_can_see_object (players) dm_lifepod_1_bdoor_2 40) 1)
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\spacebeam_explo_zero_g" fl_lifepod_1_bflag_2) ;----------------- lifepod explo a
 	(sleep 3)
 	(object_destroy dm_lifepod_1_bdoor_2)


	;trigger vignette 10 elements
	(device_set_position_immediate dm_vignette_10_1_rumble 1)
	(print_if (= (device_get_position dm_vignette_10_1_rumble) 1) "dm_vignette_10_1_rumble fired")
	(device_set_position_immediate dm_vignette_10_2_plasmacannon 1)
	(print_if (= (device_get_position dm_vignette_10_2_plasmacannon) 1) "dm_vignette_10_2_plasmacannon fired")
	(device_set_position_immediate dm_vignette_10_3_debris 1)
	(print_if (= (device_get_position dm_vignette_10_3_debris) 1) "dm_vignette_10_3_debris fired")
	(device_set_position_immediate dm_vignette_10_4_tick 1)
	(print_if (= (device_get_position dm_vignette_10_4_tick) 1) "dm_vignette_10_4_tick fired")

	(sleep (game_ticks_from_seconds 0.5))
	(device_set_power dm_lifepod_1_2 1)
	(device_set_position dm_lifepod_1_2 1)
	(pe_camera_shake_s)

 	(sleep_until (< 0.6 (device_get_position dm_lifepod_1_2)) 1)
	(pe_camera_shake_s)
	(effect_new "objects\levels\halo1\solo\a15\fx\spacebeam_lasers\lifepod_destruction" fl_lifepod_1_flavor_flag_2) ;--- lifepod explo x2 --- remove?
	(sleep (game_ticks_from_seconds .7))
 	(object_destroy dm_lifepod_1_2)
	(if (< s_conversation_id_a15 4) (wake dialog_lifepod_destroyed)) ; ensures if player has rushed ahead towards jeffries tubes, this line will not play

	(pe_camera_shake_m)
 	(sleep 15)
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 14;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_tunnel
	(sleep_until (volume_test_players tv_tunnel_trigger_enc) 1)
	(f_blip_ai sq_lifepod_1_anti_rg 1)

	; the device machine position for first explo was being reset to 0
	; somehow at the space laser/lifepod section, this forces the
	; first explo into its destroyed state
	(device_set_position_immediate dm_vignette_1_2_explosion 1)

	(sleep_until (= (ai_nonswarm_count sq_lifepod_1_anti_rg) 0)1)
	(wake dialog_accessway)

	(sleep_until (= s_navpoint_index 16))
	(device_set_power dm_tunnel_door_2 1)

	(sleep_until (volume_test_objects tv_tunnel_trigger_2 (players)) 1)
	(set s_music_trigger 160)

	(if (not b_bypass_tutorials)
		(begin
			(wake tutorial_motiontracker)
			(print "difficulty normal or easy - motion tracker tutorial activated")
		)
		(print "difficulty heroic or legenedary - motion tracker tutorial deactivated") ;else
	)
	(print "difficulty check done")

	(sleep_until (volume_test_objects tv_tunnel_exit_trigger_1 (players)) 1)
	(ai_place sq_tunnel_anti)
	(ai_place sq_tunnel_anti_sucker)
	(cryo_load)

	(if b_bypass_tutorials
		(begin
			;to prevent sucker grunt from reacting to the player approaching them and prevent the rest of the squad from hearing the player when reaching the access doors
			(ai_set_task sq_tunnel_anti_sucker obj_tunnel_anti combat)
		)
		(print "difficulty heroic or legenedary - sq_tunnel_anti not defean or blinded") ;else
	)

	(sleep_until (volume_test_objects tv_motiontracker_1 (players)) 1)
	(wake dialog_tracker)
	(wake dialog_cortana_melee_tutorial)
	(game_save_no_timeout)

	(sleep_until
		(or
			(volume_test_objects tv_motiontracker_2 (players))
			(volume_test_objects tv_motiontracker_3 (players))
			(volume_test_objects tv_motiontracker_4 (players))
		)
		1
	)
	(set s_music_trigger 170)
	(wake navpoint_tunnel_exit)

	(sleep_until (volume_test_objects tv_melee_trigger_1 (players)) 1)
	(set b_show_radar true) ;safety call if the player is able to dash through the tubes in the window where the audio can be cut

	(sleep_until (volume_test_objects tv_melee_trigger_2 (players)) 1)
	(set s_navpoint_index 18)

	(sleep_until (volume_test_objects tv_tunnel_exit_trigger_2 (players)) 1)
	(object_create bi_unnamed_41)

)

(script dormant tunnel_blast_door_close
	(sleep_until (volume_test_players tv_tunnel_trigger_close) 1)

	(game_save_no_timeout)

	(device_set_position dm_tunnel_door_3 0)

	(sleep_until (= (device_get_position dm_tunnel_door_3) 0) 1)
	(device_set_power dm_tunnel_door_3 0)
	(if (game_is_cooperative) (volume_teleport_players_not_inside tv_lifepod_1_trigger_5 fl_cheat_lifepod_1_flag))
	(pre_tunnel_cleanup)

	(ai_erase gr_stairs_anti)
	(ai_erase gr_containment_2_anti)
)

(script command_script sucker_grunt_stand
	(cs_abort_on_damage true)
	(cs_abort_on_alert true)
	(cs_action ps_sucker_grunt/p0 ai_activity_watch)
	(cs_pause 20)
)

(script dormant tutorial_motiontracker
	(device_set_power dm_motiontracker_door_2 0)
	(device_set_power dm_motiontracker_door_3 0)
	(wake dialog_too_close)
)

(script dormant navpoint_tunnel_exit
	(sleep_until
		(or
			(= 0 (ai_living_count sq_tunnel_anti))
			(volume_test_players tv_tunnel_exit_trigger_2)
		)
	1)
	(set s_navpoint_index 19)
)

(script dormant cryo_search
	(device_set_position_immediate dm_cryo_door_1 1)
	(device_set_power dm_cryo_door_1 0)
	(device_set_position_immediate dm_cryo_door_2 1)
	(device_set_power dm_cryo_door_2 0)

	(wake cryo_find)

	(sleep_until (volume_test_objects tv_cryo_search_trigger_1 (players)) 1)
	(game_save_no_timeout)
	(ai_place sq_cryo_search)

	(sleep_until (volume_test_objects tv_cryo_search_trigger_2 (players)) 1)
	(set s_navpoint_index 20)
	(wake dialog_cryo_search)

	(sleep_until (not (volume_test_players tv_cryo_search_trigger_2))1)
	(ai_erase sq_cryo_search) ;removing elites when they stop shooting

	;(sleep 90)
	; (ai_command_list_advance cryo_search)
	; (sleep_until (= 2 (ai_command_list_status (ai_actors cryo_search/elite_major))) 1)
	; (ai_command_list cryo_search cryo_search_2)
)

(script dormant cryo_find
	(sleep_until (or (>= (ai_combat_status sq_cryo_search) alert) (volume_test_players tv_cryo_search_trigger_3))1)
	(print_if b_debug_gameplay "found him")
	(cs_run_command_script sq_cryo_search cryo_attack)
)

(script command_script cryo_attack
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(sleep_until
		(begin
			(cs_aim_player true)
			(cs_shoot true)
			(not (volume_test_players tv_cryo_search_trigger_2))
		)
		(random_range 30 60)
	)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 15;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_boom
	(sleep_until (volume_test_objects tv_boom_trigger_1 (players)) 1)

	;begin vignette 12

	(ai_place gr_boom_anti)
	(device_set_power dm_x10_14 1)
	(game_save_no_timeout)

	(sleep_until
		(or
			(volume_test_objects tv_boom_trigger_2 (players))
			(= 0 (ai_living_count sq_boom_anti_eb))
		)
		1
	)

	;trigger vignette 12 elements
	(device_set_position_immediate dm_vignette_12_1_eliteexplosion 0.5)
	(print_if (= (device_get_position dm_vignette_12_1_eliteexplosion) 0.5) "dm_vignette_12_1_eliteexplosion fired")
	(device_set_position_immediate dm_vignette_12_2_decals_lights 1)
	(print_if (= (device_get_position dm_vignette_12_2_decals_lights) 1) "dm_vignette_12_2_decals_lights fired")

	; (effect_new "effects\explosions\medium explosion" boom_flag_1)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_1a" fl_boom_flag_1) ;------------------ explo r1
	(pe_camera_shake_l)
	(device_set_position_immediate dm_vignette_12_elite_explo1 0.5)
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_boom_flag_1)

	 (sleep 10)
	 (ai_kill sq_boom_anti_eb)
	; (effect_new "effects\explosions\medium explosion" boom_flag_2)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_1b" fl_boom_flag_2) ;------------------- explo r2
	(device_set_position_immediate dm_vignette_12_elite_explo2 0.5)
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_boom_flag_2)

	 (sleep 5)
	; (effect_new "effects\explosions\medium explosion" boom_flag_3)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_1c" fl_boom_flag_3) ;------------------- explo r3
	(device_set_position_immediate dm_vignette_12_elite_explo3 0.5)
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_boom_flag_3)


	(sleep_until
		(or
			(volume_test_objects tv_boom_trigger_3 (players))
			(= 0 (ai_living_count sq_boom_anti_gb))
		)
		1
		delay_wait
	)

	;trigger vignette 12 elements
	(device_set_position_immediate dm_vignette_12_3_explosion2 0.5)
	(print_if (= (device_get_position dm_vignette_12_3_explosion2) 0.5) "dm_vignette_12_3_explosion2 fired")
	(device_set_position_immediate dm_vignette_12_4_decal_lights 1)
	(print_if (= (device_get_position dm_vignette_12_4_decal_lights) 1) "dm_vignette_12_4_decal_lights fired")

	; (effect_new "effects\explosions\medium explosion" boom_flag_8)
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_boom_flag_8)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_2a" fl_boom_flag_8) ;------------------- med explo 1
	(pe_camera_shake_l)
	(device_set_position_immediate dm_vignette_12_grunt_explo1 0.5)
	 (sleep 5)
	; (effect_new "effects\explosions\medium explosion" boom_flag_9)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_2b" fl_boom_flag_9) ;------------------- med explo 2
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_boom_flag_9)
	(device_set_position_immediate dm_vignette_12_grunt_explo2 0.5)
	 (sleep 10)
	; (effect_new "effects\explosions\medium explosion" boom_flag_10)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_2c" fl_boom_flag_10) ;------------------ med explo 3
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_boom_flag_10)
	(device_set_position_immediate dm_vignette_12_grunt_explo3 0.5)

	(sleep_until (volume_test_objects tv_boom_trigger_4 (players)) 1 delay_wait)
	; (if (game_is_cooperative) (sleep 90))

	; (effect_new "effects\explosions\medium explosion" boom_flag_4)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_3a" fl_boom_flag_4) ;------------------- med explo 4
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_boom_flag_4)

	(pe_camera_shake_l)
	(device_set_position_immediate dm_vignette_12_container_explo1 0.5)
	(sleep 10)
	; (effect_new "effects\explosions\medium explosion" boom_flag_5)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_3b" fl_boom_flag_5) ;------------------- med explo 5
	(damage_new "fx/fx_library/ambient/fire/fire_large/fire_large" fl_boom_flag_5)
	(device_set_position_immediate dm_vignette_12_container_explo2 0.5)
	(sleep 5)
	; (effect_new "effects\explosions\medium explosion" boom_flag_6)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_3c" fl_boom_flag_6) ;------------------- med explo 6
	(damage_new "levels/halo1/solo/a15/a15_explosion" fl_boom_flag_6)
	(device_set_position_immediate dm_vignette_12_container_explo3 0.5)
	(sleep 5)
	; (effect_new "effects\explosions\medium explosion" boom_flag_7)
;_oldvignette	(effect_new "objects\levels\halo1\solo\a15\fx\explos_kills_elite\explo_kills_elite_3d" fl_boom_flag_7) ;------------------- med explo 7
	;(damage_new "fx/fx_library/ambient/fire/fire_large/fire_large" fl_boom_flag_7)
	(device_set_position_immediate dm_vignette_12_container_explo4 0.5)

	; force all explos into their destroyed states for reloads
	(sleep 2)
	(device_set_position_immediate dm_vignette_12_1_eliteexplosion 1)
	(device_set_position_immediate dm_vignette_12_elite_explo1 1)
	(device_set_position_immediate dm_vignette_12_elite_explo2 1)
	(device_set_position_immediate dm_vignette_12_elite_explo3 1)
	(device_set_position_immediate dm_vignette_12_3_explosion2 1)
	(device_set_position_immediate dm_vignette_12_grunt_explo1 1)
	(device_set_position_immediate dm_vignette_12_grunt_explo2 1)
	(device_set_position_immediate dm_vignette_12_grunt_explo3 1)
	(device_set_position_immediate dm_vignette_12_container_explo1 1)
	(device_set_position_immediate dm_vignette_12_container_explo2 1)
	(device_set_position_immediate dm_vignette_12_container_explo3 1)
	(device_set_position_immediate dm_vignette_12_container_explo4 1)


	(sleep_until (< (ai_living_count gr_boom_anti) 2) delay_late)
	(sleep_until (game_all_quiet))
)

(script command_script cs_boom_elite_wait
	(ai_activity_set ai_current_squad gaze)
	(cs_abort_on_combat_status 5)

	(sleep_until
		(and
			(> (objects_distance_to_object (players) (ai_get_object ai_current_squad)) 0)
			(< (objects_distance_to_object (players) (ai_get_object ai_current_squad)) 12)
		)
		1
	)

	(ai_activity_abort ai_current_squad)
	(cs_face_player true)
	(sleep 30)
	(cs_force_combat_status 5)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 16;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_crawl
	(sleep_until (volume_test_players tv_boom_trigger_4) 1)
	(ai_place sq_crawl_anti)
)

(script command_script cs_crawl_grunt_1
	(cs_abort_on_damage true)
	(sleep_until (volume_test_players tv_bsp6_5) 1)
	(cs_move_towards_point ps_crawl_pois/p4 0.5)
)

(script command_script cs_crawl_grunt_2
	(cs_abort_on_damage true)
	(sleep_until (volume_test_players tv_bsp6_5) 1)
	(cs_move_towards_point ps_crawl_pois/p1 0.5)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encounter 17;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(script dormant mission_final
	(print "mission_final")
	(sleep_until (volume_test_objects tv_bsp5_6 (players)) 1)
	(game_save_no_timeout)

	(ai_place sq_containment_3_anti_init)
	(ai_place sq_containment_3)
	(f_ai_set_integrated_flashlight sq_containment_3/init_marine_0 true)

	(sleep_until
		(or
			(volume_test_objects tv_final_trigger_1 (players))
			(volume_test_objects tv_final_trigger_2 (players))
			;(volume_test_objects tv_final_trigger_3 (players)) ;trigger volumes removed due to new geo changes mtr-21299
			;(volume_test_objects tv_final_trigger_4 (players)) ;trigger volumes removed due to new geo changes mtr-21299
		)
		1
	)
	(set s_ambient_shake_intensity 4)
	(set s_music_trigger 180)
	(set s_navpoint_index 21)
; 	(ai_follow_target_players containment_3)

	;(sleep_until (volume_test_objects tv_final_trigger_5 (players)) 1)
	(ai_place sq_containment_3_anti_flank)
	(ai_place sq_containment_3_anti_wave_2)
	(ai_place sq_containment_3_anti_wave_3)

	(sleep_until
		(or
			(volume_test_objects tv_final_trigger_6 (players))
			(volume_test_objects tv_final_trigger_11 (players))
		)
		1
	)
	(game_save)
	(set s_music_trigger 190)
; 	(ai_follow_target_disable containment_3)
	(ai_place sq_lifepod_2)
	(ai_place sq_lifepod_2_anti)
	(ai_magically_see sq_lifepod_2 sq_lifepod_2_anti)
	(ai_magically_see sq_lifepod_2_anti sq_lifepod_2)

	(wake dialog_final)
	(f_hud_obj_new "obj_a10_fight" "obj_a10_fight")

	(wake cue_final_dialog)

; 	(ai_follow_target_players lifepod_2)
	(sleep_until (<= (ai_nonswarm_count sq_lifepod_2_anti) 3) 1)
	(f_blip_ai sq_lifepod_2_anti 1)

	(sleep_until (= 0 (ai_nonswarm_count sq_lifepod_2_anti)) 1) ;comment to remove blood gate
;	(ai_kill sq_lifepod_2_anti)

	(device_set_power dm_final_door_1 1)
	(device_set_position dm_final_door_1 1)

	(cinematic_preroll cinematics\a10\a10_outro.cinematic)

	(sleep 45)

	(sleep_until (volume_test_objects tv_end_trigger (players)) 1)

; 	(object_destroy lifepod_x30)
; 	(object_destroy field_x30)
; 	(set global_rumble false)
	(submit_incident "unlock_a30")
	(submit_incident_with_custom_string_id "game_activity_end_completed" "a10")
	(f_play_cinematic cinematics\a10\a10_outro.cinematic)
	(game_won)
)

(script dormant cue_final_dialog
	(sleep_until (or
					(volume_test_objects tv_final_trigger_13 (players))
					(volume_test_objects tv_final_trigger_12 (players))
				)
				1
	)
	(set b_dialog_final true)
)

;====================================================================================================================================================================================================
; navpoints  ==============================================================================================================================================
;====================================================================================================================================================================================================

(global short s_navpoint_index 0)

(script static void f_unblip_all
	(print "f_unblip_all called")

	(f_unblip_flag fl_navpoint_jump)
	(f_unblip_object dm_first_contact_door_2)
	(f_unblip_object dm_cafeteria_door_4)
	(f_unblip_flag fl_airlock_1_flag_1)
	(f_unblip_flag fl_navpoint_shiphallwayblocked)
	(f_unblip_flag fl_navpoint_boardingpodb)
	(f_unblip_flag fl_navpoint_stairs)
	(f_unblip_flag fl_navpoint_obslounge)
	(f_unblip_flag fl_tunnel_flag_1)
	(f_unblip_flag fl_tunnel_flag_2)
	(f_unblip_flag fl_boom_exit)
	(f_unblip_object dm_final_door_1)
	(f_unblip_flag fl_cafeteria_exit)
	(f_unblip_flag fl_stairs_exit)
	(f_unblip_flag fl_tunnel_exit)
)

(script dormant navpoints_a10
	(print "navpoints_a10 started")
	; navpoint on jump tutorial - 1
	(sleep_until (> s_navpoint_index 0)	1)
	(if (= s_navpoint_index 1)
		(begin
			(print "s_navpoint_index = 1")
			(f_blip_flag fl_navpoint_jump 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_navpoint_jump) 1)
					(volume_test_players tv_moving_jump_success)
					(> s_navpoint_index 1)
				)
				1
			)

			(f_unblip_flag fl_navpoint_jump)
		)
	)

	; navpoint on jump scare hall door - 2
	(sleep_until (> s_navpoint_index 1)	1)
	(if (= s_navpoint_index 2)
		(begin
			(f_unblip_all)
			(print "s_navpoint_index = 2")
			(f_blip_object dm_first_contact_door_2 0)

			(sleep_until
				(or
					(< (objects_distance_to_object (players) dm_first_contact_door_2) 0.5)
					(> s_navpoint_index 2)
				)
				1
			)

			(f_unblip_object dm_first_contact_door_2)
		)
	)

	; navpoint on messhall entrance after bridge cinematic
	(sleep_until (> s_navpoint_index 2)	1)
	(if (= s_navpoint_index 3)
		(begin
			(f_unblip_all)
			(print "s_navpoint_index = 3")
			(f_blip_object dm_cafeteria_door_4 0)

			(sleep_until
				(or
					(> (ai_living_count sq_shoot_anti) 0)
					(= (ai_nonswarm_count sq_shoot_anti) 0)
					(< (objects_distance_to_object (players) dm_cafeteria_door_4) 0.5)
					(> s_navpoint_index 3)
				)
				1
			)

			(f_unblip_object dm_cafeteria_door_4)
		)
	)


	;guides the player out of the cafeteria
	(sleep_until (> s_navpoint_index 3)	1)
	(if (= s_navpoint_index 4)
		(begin
			(f_unblip_all)
			(print "s_navpoint_index = 4")

			(sleep_until
				(or
					(= 0 (ai_living_count gr_cafeteria_anti_init))
					(volume_test_players tv_cafeteria_trigger_5)
					(> s_navpoint_index 4)
				)
				1
			)

			(f_blip_flag fl_cafeteria_exit 0)
			;displays the waypoint until the player catches up to the waypoint.
			(sleep_until
				(or
					(volume_test_players tv_cafeteria_trigger_5)
					(> s_navpoint_index 4)
				)
				1
			)

			(print "s_navpoint_index = 4x")
			(f_unblip_flag fl_cafeteria_exit) ;turns off waypoint once a player arrives
		)
	)

	; navpoint on first airlock
	(sleep_until (> s_navpoint_index 4) 1)
	(if (= s_navpoint_index 5)
		(begin
			(print "s_navpoint_index = 5")
			(f_blip_flag fl_airlock_1_flag_2 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_airlock_1_flag_2) 3)
					(> s_navpoint_index 5)
				)
				1
			)
			(f_unblip_flag fl_airlock_1_flag_2)
			(set s_navpoint_index 6)
		)
	)

	; navpoint on first airlock
	(sleep_until (> s_navpoint_index 5) 1)
	(if (= s_navpoint_index 6)
		(begin
			(print "s_navpoint_index = 6")
			(f_blip_flag fl_airlock_1_flag_3 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_airlock_1_flag_3) 3)
					(> s_navpoint_index 6)
				)
				1
			)

			(f_unblip_flag fl_airlock_1_flag_3)
			(set s_navpoint_index 7)
		)
	)

	; navpoint on first airlock
	(sleep_until (> s_navpoint_index 6) 1)
	(if (= s_navpoint_index 7)
		(begin
			(print "s_navpoint_index = 7")
			(f_blip_object dm_airlock_1_door_3 0)

			(sleep_until
				(or
					(< (objects_distance_to_object (players) dm_airlock_1_door_3) 0.5)
					(> s_navpoint_index 7)
				)
				1
			)

			(f_unblip_object dm_airlock_1_door_3)
		)
	)

	; navpoint on access main b
	(sleep_until (> s_navpoint_index 7) 1)
	(if (= s_navpoint_index 8)
		(begin
			(print "s_navpoint_index = 8")
			(f_blip_flag fl_navpoint_shiphallwayblocked 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_navpoint_shiphallwayblocked) 3)
					(> s_navpoint_index 8)
				)
				1
			)

			(f_unblip_flag fl_navpoint_shiphallwayblocked)
			(set s_navpoint_index 9)
		)
	)

	(sleep_until (> s_navpoint_index 8) 1)
	(if (= s_navpoint_index 9)
		(begin
			(print "s_navpoint_index = 9")
			(f_blip_object dm_bsp2_door 0)

			(sleep_until
				(or
					(< (objects_distance_to_object (players) dm_bsp2_door) 0.5)
					(> s_navpoint_index 9)
				)
				1
			)

			(f_unblip_object dm_bsp2_door)
			(set s_navpoint_index 10)
		)
	)

	; navpoint on second airlock
	(sleep_until (> s_navpoint_index 9) 1)
	(if (= s_navpoint_index 10)
		(begin
			(print "s_navpoint_index = 10")
			(f_blip_flag fl_navpoint_boardingpodb 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_navpoint_boardingpodb) 3)
					(> s_navpoint_index 10)
				)
				1
			)

			(f_unblip_flag fl_navpoint_boardingpodb)
			(set s_navpoint_index 11)
		)
	)

	(sleep_until (> s_navpoint_index 10) 1)
	(if (= s_navpoint_index 11)
		(begin
			(print "s_navpoint_index = 11")
			(f_blip_object dm_bsp3_door_b 0)
			(sleep_until
				(or
					(< (objects_distance_to_object (players) dm_bsp3_door_b) 0.5)
					(> s_navpoint_index 11)
				)
				1
			)
			(f_unblip_object dm_bsp3_door_b)
			(set s_navpoint_index 12)
		)
	)

	; navpoint on stairs room
	(sleep_until (> s_navpoint_index 11) 1)
	(if (= s_navpoint_index 12)
		(begin
			(print "s_navpoint_index = 12")
			(f_blip_flag fl_navpoint_stairs 0)
			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_navpoint_stairs) 6)
					(> s_navpoint_index 12)
				)
				1
			)
			(f_unblip_flag fl_navpoint_stairs)
		)
	)

	;checks to see if all enemy squads in the stairs encounter are dead before giving the player the next waypoint.
	(sleep_until (> s_navpoint_index 12) 1)
	(if (= s_navpoint_index 13)
		(begin
			(print "s_navpoint_index = 13")
			(sleep_until
				(or
					(= 0 (ai_living_count gr_stairs_anti))
					(< (objects_distance_to_flag (players) fl_stairs_exit) 3)
					(> s_navpoint_index 13)
				)
				1
			)

			(f_blip_flag fl_stairs_exit 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_stairs_exit) 3)
					(volume_test_players tv_stairs_exit)
					(> s_navpoint_index 13)
				)
				1
			)

			(f_unblip_flag fl_stairs_exit)
			(set s_navpoint_index 14)
		)
	)

	; navpoint on obs lounge - index 10
	(sleep_until (> s_navpoint_index 13) 1)
	(if (= s_navpoint_index 14)
		(begin
			(print "s_navpoint_index = 14")
			(f_blip_flag fl_stairs_exit2 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_stairs_exit2) 3)
					(> s_navpoint_index 14)
				)
				1
			)

			(f_unblip_flag fl_stairs_exit2)
			(set s_navpoint_index 15)
		)
	)

	(sleep_until (> s_navpoint_index 14) 1)
	(if (= s_navpoint_index 15)
		(begin
			(print "s_navpoint_index = 15")
			(f_blip_flag fl_navpoint_obslounge 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_navpoint_obslounge) 3)
					(> s_navpoint_index 15)
				)
				1
			)

			(f_unblip_flag fl_navpoint_obslounge)
		)
	)

	; navpoint on entrance to tunnels - set after cortana finishes her dialog in dialog_accessway
	(sleep_until (> s_navpoint_index 15) 1)
	(if (= s_navpoint_index 16)
		(begin
			(print "s_navpoint_index = 16")
			(f_blip_flag fl_tunnel_flag_1 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_tunnel_flag_1) 1)
					(> s_navpoint_index 16)
				)
				1
			)

			(f_unblip_flag fl_tunnel_flag_1)
		)
	)

	; navpoint on tunnel exit - possible to skip if player rushes through jeffries tube
	(sleep_until
		(or
			(> s_navpoint_index 16)
			(volume_test_players tv_melee_trigger_1)
		)
	1)
	(if (= s_navpoint_index 17)
		(begin
			(print "s_navpoint_index = 17")
			(f_blip_flag fl_tunnel_flag_2 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_tunnel_flag_2) 1)
					(> s_navpoint_index 17)
				)
				1
			)

			(f_unblip_flag fl_tunnel_flag_2)
		)
	)

	; navpoint in ship hallway cryob a - leading player to cryo bay
	(sleep_until
		(or
			(> s_navpoint_index 17)
			(volume_test_players tv_tunnel_exit_trigger_2) ;skippable on higher difficulties
		)
	1)
	(if (= s_navpoint_index 18)
		(begin
			(print "s_navpoint_index = 18")
			(f_blip_flag fl_tunnel 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_tunnel) 1)
					(> s_navpoint_index 18)
				)
				1
			)

			(f_unblip_flag fl_tunnel)
		)
	)

	(sleep_until (> s_navpoint_index 18) 1)
	(if (= s_navpoint_index 19)
		(begin
			(print "s_navpoint_index = 19")
			(f_blip_flag fl_tunnel_exit 0)

			(sleep_until
				(or
					(< (objects_distance_to_flag (players) fl_tunnel_exit) 1)
					(> s_navpoint_index 19)
				)
				1
			)

			(f_unblip_flag fl_tunnel_exit)
		)
	)


	; navpoint on cryo control a
	(sleep_until (> s_navpoint_index 19) 1)
	(if (= s_navpoint_index 20)
		(begin
			(print "s_navpoint_index = 20")
			(f_blip_flag fl_boom_exit 0)

			(sleep_until
				(or
					(< (objects_distance_to_object (players) dm_bsp5_door) 0.5)
					(> s_navpoint_index 20)
				)
				1
			)

			(f_unblip_flag fl_boom_exit)
		)
	)


	; navpoint on final escape pod bay entrance
	(sleep_until (volume_test_players tv_intercom_trigger_130) 1)

	(print "s_navpoint_index = 21")
	(f_blip_flag fl_lifepod2 0)
	(sleep_until (< (objects_distance_to_flag (players) fl_lifepod2) 6) 1)
	(f_unblip_flag fl_lifepod2)

	; safety navpoint - blips when final squad killed and player is not in trigger volume to finish level
	(sleep_until (= 0 (ai_nonswarm_count sq_lifepod_2_anti)) 1)
	(if (not (volume_test_players tv_end_trigger))
		(f_blip_object dm_final_door_1 0)
	)
)

;====================================================================================================================================================================================================
; flavor scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
(script static boolean weapons_number_is_two
	(set s_weapons_number 0)
	(if (unit_has_weapon player0 objects\weapons\pistol\magnum\magnum.weapon)
		(set s_weapons_number (+ s_weapons_number 1))
	)
	(if (unit_has_weapon player0 objects\weapons\pistol\plasma_pistol\plasma_pistol.weapon)
		(set s_weapons_number (+ s_weapons_number 1))
	)
	(if (unit_has_weapon player0 objects\weapons\rifle\assault_rifle\assault_rifle.weapon)
		(set s_weapons_number (+ s_weapons_number 1))
	)
	(if (unit_has_weapon player0 objects\weapons\rifle\plasma_rifle\plasma_rifle.weapon)
		(set s_weapons_number (+ s_weapons_number 1))
	)

	(>= s_weapons_number 2)
)

(script static boolean equipment_overshield
	(set s_equipment_number 0)
	(if (unit_has_equipment player0 objects\equipment\overshield\overshield.equipment)
		(set s_equipment_number (+ s_equipment_number 1))
	)
	(>= s_equipment_number 1)
)

;====================================================================================================================================================================================================
; player_effects
;====================================================================================================================================================================================================

(script static void pe_camera_shake_s
	(player_effect_set_max_translation .03 .01 .06)
	(player_effect_set_max_rotation 1 3 3)
	(player_effect_set_max_rumble 0.08 0.3)
	(player_effect_start 1 0)
	(sound_impulse_start sound\levels\a15\amb_env_a15_shiphits_camerashake_all none 2)
	(sleep 3)
	(player_effect_stop 1)
 )

 (script static void pe_camera_shake_m
	(player_effect_set_max_translation .06 .02 .12)
	(player_effect_set_max_rotation 2 5 5)
	(player_effect_set_max_rumble 0.2 0.3)
	(player_effect_start 1 0)
	(sound_impulse_start sound\levels\a15\amb_env_a15_shiphits_camerashake_all none 2)
	(sleep 3)
	(player_effect_stop 1)
 )

 (script static void pe_camera_shake_l
	(player_effect_set_max_translation .12 .04 .24)
	(player_effect_set_max_rotation 4 8 8)
	(player_effect_set_max_rumble 0.45 0.25)
	(player_effect_start 1 0)
	(sound_impulse_start sound\levels\a15\amb_env_a15_shiphits_camerashake_all none 2)
	(sleep 3)
	(player_effect_stop 1)
 )

 (global short s_ambient_shake_intensity 0)

 (script dormant ambient_shake
	(sleep_until
		(cond
			((= s_ambient_shake_intensity 0) ; intensity 0 - no shakes at all
				(begin
					(print "ambient shake intensity 0 - rest")
					(sleep_until  (> s_ambient_shake_intensity 0))
					(sleep (random_range 30 90))
					false
				)
			)
			((= s_ambient_shake_intensity 1) ; intensity 1 - occasional minor shakes
				(begin
					(print "ambient shake intensity 1 - shake")
					(pe_camera_shake_s)
					(sleep (random_range 150 900))
					false
				)
			)
			((= s_ambient_shake_intensity 2) ; intensity 2 - frequent minor shakes with occasional more significant shake
				(begin
					(print "ambient shake intensity 2 - shake")
					(begin_random
						(pe_camera_shake_s)
						(pe_camera_shake_s)
						(pe_camera_shake_s)
						(pe_camera_shake_m)
					)
					(sleep (random_range 120 840))
					false
				)
			)
			((= s_ambient_shake_intensity 3) ; intensity 3 - some minor shakes with frequent more significant shake
				(begin
					(print "ambient shake intensity 3 - shake")
					(begin_random
						(pe_camera_shake_s)
						(pe_camera_shake_s)
						(pe_camera_shake_m)
						(pe_camera_shake_m)
					)
					(sleep (random_range 90 750))
					false
				)
			)
			((= s_ambient_shake_intensity 4) ; intensity 4 - few minor shakes with frequent more significant shake and occasional major shakes
				(begin
					(print "ambient shake intensity 4 - shake")
					(begin_random
						(pe_camera_shake_s)
						(pe_camera_shake_m)
						(pe_camera_shake_m)
						(pe_camera_shake_m)
						(pe_camera_shake_l)
					)
					(sleep (random_range 60 600))
					false
				)
			)
		)
	)
 )

 ;===================================================================================================================================================================================================
 ; space battle flybys
 ;===================================================================================================================================================================================================
 (global real delay_space_battle_flyby 30 )
 (script dormant space_battle_flyby_airlock
	;place vehicles
	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_flyby_airlock1))
			(ai_place sq_flyby_air1r)
			(sleep (random_range 450 750))
			(ai_disposable sq_flyby_air1r true)
		(volume_test_players tv_bsp3_4))
	1)
)
(script dormant space_battle_flyby_observation
	;place vehicles
	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_flyby_observation))
			(ai_place sq_flyby_ob_banshee)
			(sleep (random_range 300 600))
			(ai_disposable sq_flyby_ob_banshee true)
		(volume_test_players tv_tunnel_trigger_2))
	1)
)
(script dormant space_battle_flyby_bridge
	;place vehicles
	(sleep_until (volume_test_players tv_flyby_bridge) 1)
	(print "bridge flyby")
	(ai_place sq_flyby_bridge_seraph)
	;(cs_run_command_script sq_flyby_bridge_seraph cs_flyby_bridge_seraph)
	(sleep 120)
	(ai_disposable sq_flyby_bridge_seraph true)
)

(script command_script cs_flyby_bridge_seraph
	(cs_teleport ps_flyby_bridge/p0  ps_flyby_bridge/p1)
	(cs_fly_by ps_flyby_bridge/p0)
	(cs_fly_by ps_flyby_bridge/p1)
	(cs_fly_by ps_flyby_bridge/p2)
	(cs_fly_by ps_flyby_bridge/p3)
)

(script command_script cs_flyby_air1r_1
	(cs_teleport ps_flyby_air1r_1/p0  ps_flyby_air1r_1/p1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 10)

	(cs_fly_by ps_flyby_air1r_1/p0)
	(cs_fly_by ps_flyby_air1r_1/p1)
	(cs_fly_by ps_flyby_air1r_1/p2)
)

(script command_script cs_flyby_air1r_2
	(cs_teleport ps_flyby_air1r_2/p0  ps_flyby_air1r_2/p1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 30)

	(cs_fly_by ps_flyby_air1r_2/p0)
	(cs_fly_by ps_flyby_air1r_2/p1)
	(cs_fly_by ps_flyby_air1r_2/p2)
)

(script command_script cs_flyby_air1r_3
	(cs_teleport ps_flyby_air1r_3/p0  ps_flyby_air1r_3/p1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 30)

	(cs_fly_by ps_flyby_air1r_3/p0)
	(cs_fly_by ps_flyby_air1r_3/p1)
	(cs_fly_by ps_flyby_air1r_3/p2)
)

(script command_script cs_flyby_air1r_4
	(cs_teleport ps_flyby_air1r_4/p0  ps_flyby_air1r_4/p1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 30)

	(cs_fly_by ps_flyby_air1r_4/p0)
	(cs_fly_by ps_flyby_air1r_4/p1)
	(cs_fly_by ps_flyby_air1r_4/p2)
)

(script command_script cs_flyby_air1r_5
	(cs_teleport ps_flyby_air1r_5/p0  ps_flyby_air1r_5/p1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 30)

	(cs_fly_by ps_flyby_air1r_5/p0)
	(cs_fly_by ps_flyby_air1r_5/p1)
	(cs_fly_by ps_flyby_air1r_5/p2)
)

(script command_script cs_flyby_air1r_c1
	(cs_teleport ps_flyby_air1r_c1/p0  ps_flyby_air1r_c1/p1)

	(cs_fly_by ps_flyby_air1r_c1/p0)
	(cs_fly_by ps_flyby_air1r_c1/p1)
	(cs_fly_by ps_flyby_air1r_c1/p2)
)

(script command_script cs_flyby_air1r_c2
	(cs_teleport ps_flyby_air1r_c2/p0  ps_flyby_air1r_c2/p1)

	(cs_fly_by ps_flyby_air1r_c2/p0)
	(cs_fly_by ps_flyby_air1r_c2/p1)
	(cs_fly_by ps_flyby_air1r_c2/p2)
)

(script command_script cs_flyby_air1r_c3
	(cs_teleport ps_flyby_air1r_c3/p0  ps_flyby_air1r_c3/p1)

	(cs_fly_by ps_flyby_air1r_c3/p0)
	(cs_fly_by ps_flyby_air1r_c3/p1)
	(cs_fly_by ps_flyby_air1r_c3/p2)
)

(script command_script cs_flyby_observation_banshee1
	(cs_fly_by ps_flyby_observation/p0)
	(cs_fly_by ps_flyby_observation/p1)
	(cs_fly_by ps_flyby_observation/p2)
	(cs_fly_by ps_flyby_observation/p3)
	(cs_fly_by ps_flyby_observation/p4)
	(cs_fly_by ps_flyby_observation/p5)
)

;=============================================
;=========== chapter titles ==================
;=============================================

(script static void chapter_a15_1
	(print_if b_debug_gameplay "chapter title 1 - reveille")
	(f_hud_chapter "training")
)

(script dormant chapter_a15_2
	(print_if b_debug_gameplay "chapter title 2 - ai constructs and cyborgs first!")
	(f_hud_chapter "escape")

	(hide_radar_grenades)
)



;=============================================
;==========loading / clean up=================
;=============================================

(script static void cryo_load
	;elements that will be used both in the begining of the level,and when the player returns above
	(object_create_folder fo_objects_cryo)

	(setup_chambers)
)

(script static void pre_bridge_load
	(object_create_folder fo_objects_pre_bridge)
	(object_create_folder fo_objects_pre_bridge_doors)
)

(script static void pre_bridge_cleanup
	(ai_erase gr_pre_bridge_cov)
	(ai_erase gr_pre_bridge_hum)

	(object_destroy_folder bi_pre_bridge)

	(object_destroy_folder fo_objects_cryo)
	(object_destroy_folder fo_objects_cryo_conditional)
	(object_destroy_folder fo_objects_pre_bridge)
	(object_destroy_folder fo_objects_pre_bridge_doors)
	(garbage_collect_now)

)

(script static void pre_stairs_load
	(object_create_folder w_pre_stairs)
	(object_create_folder eq_pre_stairs)

	(object_create_folder w_post_stairs)
	(object_create_folder eq_post_stairs)

	(object_create_folder fo_objects_pre_stairs)
	(object_create_folder fo_objects_pre_stairs_doors)
)

(script static void pre_tick2_cleanup
	(set b_past_possible_mutiney true)

	(sleep (game_ticks_from_seconds 0.25));makes sure that the variable is set before the bridge crew is erased to ensure the muteny script doesn't go off

	(ai_erase gr_bridge)
	(ai_erase gr_airlock_1_anti)
	(ai_erase gr_airlock_1)

	(garbage_collect_now)
)

(script static void pre_stairs_cleanup

	(ai_erase gr_pre_stairs_cov)
	(ai_erase gr_pre_stairs_hum)

	(object_destroy_folder bi_pre_stairs)
	(object_destroy_folder w_pre_stairs)
	(object_destroy_folder eq_pre_stairs)

	(object_destroy_folder fo_objects_pre_stairs)
	(object_destroy_folder fo_objects_pre_stairs_doors)
	(object_destroy dm_airlock_2_tick_2)
	(garbage_collect_now)
)

(script static void pre_tunnel_load
	(object_create_folder fo_objects_pre_tunnel)
	(object_create_folder fo_objects_pre_tunnel_doors)
)

(script static void pre_tunnel_cleanup
	(object_destroy_folder fo_objects_pre_tunnel)
	(object_destroy_folder fo_objects_pre_tunnel_doors)
	(garbage_collect_now)
)

(script static void post_tunnel_load
	(object_create_folder fo_objects_post_tunnel)
	(object_create_folder fo_objects_post_tunnel_doors)
)