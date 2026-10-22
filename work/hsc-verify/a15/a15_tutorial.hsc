;\\tutorial globals
(global boolean b_bypass_tutorials false)
(global boolean b_tutorial_setup_done false)
(global boolean b_fast_setup_decline false)
(global boolean b_fast_setup_done false)
(global boolean b_is_player_out_of_cryo false)
(global boolean b_is_player_in_red_square false)
(global boolean b_is_player_looking_at_tech false)
(global boolean b_cryo_tech_free true)
(global boolean b_cryo_tech_free_b true)
(global boolean b_cryo_tech_calib_point false)
(global boolean b_is_player_cueing_calib_lights false)
(global boolean b_is_player_done_calib_lights false)
(global boolean b_is_tech_red_square_done false)
(global short s_idle_check 0)

;\\target calibration globals
(global short s_test_target_cycle 0)
(global short s_test_looking_count 0)
(global boolean b_test_center_panel false)
(global boolean b_test_left_panel false)
(global boolean b_test_right_panel false)
(global boolean b_test_up_panel false)
(global boolean b_test_down_panel false)
(global boolean b_is_player_chose_yinversion0 false)
(global boolean b_is_player_chose_yinversion1 false)
(global boolean b_is_player_done_yinversion false)
(global boolean b_is_player_in_yellow_square false)
(global boolean b_is_tech_yellow_square_done false)

;\\training globals
(global boolean b_tutorial_cryo_done false)
(global boolean b_tutorial_crouch_done false)
(global boolean b_tutorial_jump_done false)
(global boolean b_tutorial_weapon_done false)
(global boolean b_tutorial_second_weapon_done false)
(global boolean b_tutorial_terminal_done false)
(global boolean b_tutorial_navmarker_done false)
(global boolean b_tutorial_radar_done false)
(global boolean b_tutorial_flanking_done false)
(global boolean b_tutorial_melee_done false)
(global boolean b_tutorial_get_weapon false)
(global boolean b_tutorial_grenades_done true) ; block until cinematic is over
(global boolean b_tutorial_flashlight_done false)
(global boolean b_tutorial_sprint_done false)
(global boolean b_tutorial_equipment_done false)
(global short s_tutorial_flashlight_count 0)
(global short s_weapons_number 0)
(global short s_equipment_number 0)

;\\vignette globals
(global boolean b_is_player_watching_drama false)
(global boolean b_is_assistant_dead false)
(global boolean b_wakey_ready false)

;====================================================================================================================================================================================================
; setup ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant tutorial_setup
	; place tech and assistant
	(cryo_load)
	;(pre_bridge_load)
	(ai_place sq_cryo_tech)
	(object_cannot_take_damage (ai_actors sq_cryo_tech))
	(units_set_current_vitality (ai_actors sq_cryo_tech) 1 0)
	(unit_doesnt_drop_items (ai_actors sq_cryo_tech))
	(ai_cannot_die sq_cryo_tech 1)

	;create speaker for cryoassistant
	(object_create ss_cryobay)

	;put datapad in tech's hand
	(object_create sc_cryo_tech_datapad)
	(objects_attach (ai_get_object sq_cryo_tech/tech_0) "right_hand" sc_cryo_tech_datapad "")

	;(object_create v_cryotube_1) ; stub object doesn't exist yet
	(print_if b_debug_gameplay "stub: cryotube asset missing")
	;(unit_enter_vehicle (player0) v_cryotube_1 "ct-driver")

	;setting vignette 1 as started

	(if b_debug_gameplay
		(begin; resetting movement values necessary for pie
			(player_enable_input true)
			(player_disable_movement false)
			;enable floor is lava skull
			(skull_affects_players skull_floor_is_lava true)
		)
		(begin ; else
			(player_enable_input false)
			(player_disable_movement true)
			;disable floor is lava skull
			(skull_affects_players skull_floor_is_lava false)
		)
	)

	; setup doors for pie
	(device_set_position dm_cryo_explosion_door_3 0)
	(device_set_power dm_cryo_explosion_door_3 0)
	(device_set_position dm_cryo_door_1 0)
	(device_set_power dm_cryo_door_1 0)
	(device_set_position dm_cryo_door_2 0)
	(device_set_power dm_cryo_door_2 0)

	;turning on steam for vignette
	(device_set_position_immediate dm_vignette_1_1_steam 1)
	(print_if (= (device_get_position dm_vignette_1_1_steam) 1) "dm_vignette_1_1_steam fired")

	; turn off red square lights
	(calibration_lights_off)

	;fade out hud, turn on elements in tutorials as player progresses (per glough needs to be changed to chud_show for specific elements; note chud_show not working as expected?)

	(wake a10_a_tutorial_start)
	(hud_enable_training false)
	(chapter_a15_1)

	(hud_enable_training true)
	(wake training_move)

	(if (not b_bypass_tutorials)
		(begin
			(print_if b_debug_gameplay "hiding hud")
			(chud_fade_shield_for_player player0 0 1)
			(chud_fade_grenades_for_player player0 0 1)
			(chud_fade_motion_sensor_for_player player0 0 1)
			(chud_fade_weapon_stats_for_player player0 0 1)

			(wake tutorial_crouch)
			(wake tutorial_jump)
			(wake tutorial_weapon)
			(wake tutorial_equipment)
;			(wake tutorial_terminal)	;need to verify if this is supported
;			(wake tutorial_navmarker) 	;need to verify if this is supported (happens just before flashlight tutorial in mcc)
;			(wake tutorial_radar) 		;need to verify if this is supported (happens just after flashlight tutorial in mcc)
;			(wake tutorial_flanking)	;need to verify if this is supported
			(wake tutorial_flashlight)
			(wake tutorial_melee)
			(wake tutorial_grenades)
			(wake tutorial_sprint)
			(sleep_until (gp_calibration_complete) 1)
		)
	)

	(sleep_until b_tutorial_cryo_done 1)
	(set b_tutorial_setup_done true)
)

(script static void setup_chambers
	(if (>= (game_coop_player_count) 2)
		(object_create so_cryo_open_pod2)
		(object_create so_cryo_closed_pod2)
	)
	(if (>= (game_coop_player_count) 3)
		(object_create so_cryo_open_pod3)
		(object_create so_cryo_closed_pod3)
	)
	(if (= (game_coop_player_count) 4)
		(object_create so_cryo_open_pod4)
		(object_create so_cryo_closed_pod4)
	)
)

;*(script dormant non_tutorial_setup
	(ai_place sq_cryo_tech)
	(units_set_current_vitality (ai_actors sq_cryo_tech) 1 0)
	(unit_doesnt_drop_items (ai_actors sq_cryo_tech))

	(player_enable_input true)
	(player_disable_movement false)

; 	setup doors for pie
	(device_set_position dm_cryo_explosion_door_3 0)
	(device_set_power dm_cryo_explosion_door_3 0)
	(device_set_position dm_cryo_door_1 0)
	(device_set_power dm_cryo_door_1 0)
	(device_set_position dm_cryo_door_2 0)
	(device_set_power dm_cryo_door_2 0)

	(set b_tutorial_setup_done true)

	(wake skip_tutorial)
)*;

;====================================================================================================================================================================================================
; a10 missionlevel scripts ==============================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; a10_a_tutorial_start
;====================================================================================================================================================================================================

(script dormant a10_a_tutorial_start
	(print_if b_debug_gameplay "a10_a_tutorial_start started.")

	(cs_run_command_script sq_cryo_tech/asst cs_introduction_1) ; assistant in observation room
	(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:wakeup_idle" true)

	; music
	(set s_music_trigger 20)
	(set s_ambient_shake_intensity 0)

	; vo
	(wake dialog_cryo_intro)
	(sleep_until b_cryo_intro_done 1)

	; stub cryotube opening fx
	(print_if b_debug_gameplay "stub: cryotube opening fx missing")

	(if b_fast_setup_decline
		(wake finish_tutorial)
	)

	(if b_fast_setup_done
		(wake skip_tutorial)
	)

	; todo hide/show health bar on hud (legacy parity)
)


(script dormant training_move
	(print_if b_debug_gameplay "prompt: move")

	(hud_set_training_text "training_move")
	(hud_show_training_text true)

	(player_action_test_reset)
	(sleep_until (player_action_test_move_relative_all_directions) 1)

	(hud_show_training_text false)
	(hud_set_training_text "")
)

(script command_script cs_introduction_1
	(print_if b_debug_gameplay "cs_introduction_1")
	(cs_abort_on_damage true)
	(cs_stow true)
	(cs_walk true)

	(unit_set_stance sq_cryo_tech/asst "patrol") ; leomartinez add

	(sleep 30)
	(cs_move_towards_point ps_tutorial_calibration/p9 0.5)
	(cs_go_to_and_face ps_tutorial_calibration/p1 ps_drama_sam/p1)
	(sleep delay_witness)

	(cs_force_combat_status 0)

	; stub animation
	(print_if b_debug_gameplay "*assistant interacting with consoles*")

	(sleep_until b_tutorial_cryo_done 1)
)

;\\skip training?
(script dormant skip_tutorial_option
	(f_show_hud_text "tutorial_skip") ; ui: begin calibration? press {} to proceed with calibration. press {} to skip calibration
	(sleep (* 30 1))
	(player_action_test_reset)

	(sleep_until
		(cond
			((player_action_test_context_primary)
				(begin ; press accept to start tutorial
					(print_if b_debug_gameplay "starting tutorial")
					;(hud_set_training_text "dia_training") ;begin training
					;(hud_show_training_text true)
					;(wake finish_tutorial)
					(set b_fast_setup_decline true)
				)
			)
			((player_action_test_rotate_weapons)
				(begin; press cancel to skip tutorial
					(print_if b_debug_gameplay "tutorial skipped")
					(chud_fade_shield_for_player player0 1 1)
					;(wake skip_tutorial)
					(set b_fast_setup_done true)
				)
			)
		)
		1
	)

)

;\\skip
(script dormant skip_tutorial
	(print_if b_debug_gameplay "tutorial skipped!")
	(set b_is_player_done_yinversion true)
	(set b_is_tech_red_square_done true)
	(set b_is_tech_yellow_square_done true)
	(gp_notify_calibration_complete)
	(set b_tutorial_cryo_done true)

	(wake a10_a_interactive_cutscene_sam)
)

;\\dont skip
(script dormant finish_tutorial
	(print_if b_debug_gameplay "tutorial accepted")
	(sleep_until b_fast_setup_decline 1)
	(f_hud_obj_new_no_hud_completion "dia_a10_training" "dia_a10_training")

	(set b_is_player_out_of_cryo true)
	(wake a10_a_tutorial_redsquare)
	(wake a10_a_tutorial_yellowsquare)
	(sleep_until b_tutorial_cryo_done 1)
	(wake a10_a_interactive_cutscene_sam)
)

;=================================================================================================
; red square
;=================================================================================================
(script dormant a10_a_tutorial_redsquare
	(print_if b_debug_gameplay "a10_a_tutorial_redsquare")

	(wake red_square_tech)

	; wait for player to stand on the red square
	(sleep_until
		(and
			(volume_test_object tv_cryo_tech_red_sq sq_cryo_tech/tech)
		 	(volume_test_players tv_red_square)
		)
	1)

	(sleep (* 30 1))
	(wake dialog_red_square_tech)
	(sleep_until b_cryo_tech_calib_point)

	(wake red_square_targeting)
	(sleep_until (= 5 s_test_looking_count) 1)
	(set g_red_square_progress 1)
	(sleep 60)

	(player_action_test_reset)
	(f_show_hud_text "tutorial_looking_choose_2") ; ui: invert vertical looking? press {} to invert looking. press {} to leave as normal

	;\\choose inverted look or normal look
	(sleep_until
		(cond
			((player_action_test_context_primary)
				(begin ; press accept to invert
					(print_if b_debug_gameplay "look inverted")
					(f_show_hud_text "tutorial_looking_choose_1") ;ui : "vertical looking is now inverted|nlook up and down"
					(player_invert_look_y player0)
					(set b_is_player_chose_yinversion1 true)
					true
				)
			)
			((player_action_test_rotate_weapons)
				(begin; press cancel to keep look normal
					(print_if b_debug_gameplay "look is normal")
					(f_show_hud_text "tutorial_looking_choose_3") ;ui : "vertical looking is now normal|nlook up and down"
					(set b_is_player_chose_yinversion0 true)
					true
				)
			)
		)
		1
	)
		(if b_is_player_chose_yinversion1
			(begin
				(set b_is_player_chose_yinversion1 false)
				(wake dialog_red_square_invert)
				(wake inverted_red_square_targeting)
			)
		    (set b_is_player_done_calib_lights true) ;else
		)

	(sleep_until b_is_player_done_calib_lights 1)
	(sound_impulse_start sound\levels\a15\obj_lights_tone_look_alignment_complete reticlecalibration_greencenter 2)

	(dialog_red_square_complete)
	(set b_is_player_done_yinversion true)
	(set b_is_tech_red_square_done true)
	(calibration_lights_off)
	(game_save_no_timeout)
)

(script static void calibration_lights_set
	(object_destroy reticlecalibration_greencenter)
	(object_create_anew reticlecalibration_redcenter)
	(set b_test_center_panel false)
	(object_destroy reticlecalibration_greenup)
	(object_create_anew reticlecalibration_redup)
	(set b_test_up_panel false)
	(object_destroy reticlecalibration_greendown)
	(object_create_anew reticlecalibration_reddown)
	(set b_test_down_panel false)
	(object_destroy reticlecalibration_greenleft)
	(object_create_anew reticlecalibration_redleft)
	(set b_test_left_panel false)
	(object_destroy reticlecalibration_greenright)
	(object_create_anew reticlecalibration_redright)
	(set b_test_right_panel false)
)

(script static void calibration_lights_off
	(object_destroy	reticlecalibration_greencenter)
	(object_destroy	reticlecalibration_redcenter)
	(object_destroy	reticlecalibration_greenup)
	(object_destroy	reticlecalibration_redup)
	(object_destroy	reticlecalibration_greendown)
	(object_destroy	reticlecalibration_reddown)
	(object_destroy	reticlecalibration_greenleft)
	(object_destroy	reticlecalibration_redleft)
	(object_destroy	reticlecalibration_greenright)
	(object_destroy	reticlecalibration_redright)
)

;\\look at the targets
(script dormant red_square_targeting
	(print_if b_debug_gameplay "targeting calibration started")
	(f_hud_obj_new "tutorial_looking_targeted_2" "tutorial_looking_targeted_2") ; "target each of the flashing lights"
	(set s_test_target_cycle 0)
	(set s_test_looking_count 0)
	(calibration_lights_set)

	(wake test_center_panel)
	(wake test_left_panel)
	(wake test_right_panel)
	(wake test_up_panel)
	(wake test_down_panel)

	(sleep_until 
		(and
			b_test_down_panel
			b_test_up_panel
			b_test_left_panel
			b_test_right_panel
			b_test_center_panel
		)
		1
	)
)

(script static boolean (test_panel (cutscene_flag fl_looking_panel) (object_name reticlecalibration_red) (object_name reticlecalibration_green))
	(if	
		(and
			b_is_player_in_red_square
			(<= 0 s_test_target_cycle)
			(<= 0 s_test_looking_count)
			(objects_can_see_flag (player0) fl_looking_panel 5)
		)
		(begin
			(set s_test_looking_count (+ s_test_looking_count 1))
			(set s_test_target_cycle (+ s_test_target_cycle 1))
			(object_destroy reticlecalibration_red)
			(object_create_anew reticlecalibration_green)
			(sleep 5)
			(sound_impulse_start sound\levels\a15\obj_lights_tone_look_alignment_green reticlecalibration_green 2)
			true
		)
		false
	)
)

(script dormant test_center_panel
	(sleep_until (test_panel fl_looking_panel_center reticlecalibration_redcenter reticlecalibration_greencenter)1)
	(set b_test_center_panel true)
)

(script dormant test_left_panel
	(sleep_until (test_panel fl_looking_panel_left reticlecalibration_redleft reticlecalibration_greenleft)1)
	(set b_test_left_panel true)
)

(script dormant test_right_panel
	(sleep_until (test_panel fl_looking_panel_right reticlecalibration_redright reticlecalibration_greenright)1)
	(set b_test_right_panel true)
)

(script dormant test_up_panel
	(sleep_until (test_panel fl_looking_panel_up reticlecalibration_redup reticlecalibration_greenup)1)
	(set b_test_up_panel true)
)

(script dormant test_down_panel
	(sleep_until (test_panel fl_looking_panel_down reticlecalibration_reddown reticlecalibration_greendown)1)
	(set b_test_down_panel true)
)

(script dormant inv_test_center_panel
	(sleep_until (test_panel fl_looking_panel_center reticlecalibration_redcenter reticlecalibration_greencenter)1)
	(set b_test_center_panel true)
)

(script dormant inv_test_left_panel
	(sleep_until (test_panel fl_looking_panel_left reticlecalibration_redleft reticlecalibration_greenleft)1)
	(set b_test_left_panel true)
)

(script dormant inv_test_right_panel
	(sleep_until (test_panel fl_looking_panel_right reticlecalibration_redright reticlecalibration_greenright)1)
	(set b_test_right_panel true)
)

(script dormant inv_test_up_panel
	(sleep_until (test_panel fl_looking_panel_up reticlecalibration_redup reticlecalibration_greenup)1)
	(set b_test_up_panel true)
)

(script dormant inv_test_down_panel
	(sleep_until (test_panel fl_looking_panel_down reticlecalibration_reddown reticlecalibration_greendown)1)
	(set b_test_down_panel true)
)

;\\look at targets again while inverted
(script dormant inverted_red_square_targeting
	(print_if b_debug_gameplay "targeting calibration restarted")
	(f_hud_obj_new "tutorial_looking_targeted_2" "tutorial_looking_targeted_2") ; ui: "target each of the flashing lights"
	(set s_test_target_cycle 0)
	(set s_test_looking_count 0)
	(calibration_lights_set)
	(sound_impulse_start sound\levels\a15\obj_lights_tone_look_alignment_yellow reticlecalibration_redcenter 2)

	(wake inv_test_center_panel)
	(wake inv_test_left_panel)
	(wake inv_test_right_panel)
	(wake inv_test_up_panel)
	(wake inv_test_down_panel)

	(sleep_until 
		(and
			b_test_down_panel
			b_test_up_panel
			b_test_left_panel
			b_test_right_panel
			b_test_center_panel
		)
		1
	)


	(set g_red_square_progress 2)
	(sleep 60)

	;\\confirm look inversion
	(player_action_test_reset)
	(f_show_hud_text "tutorial_looking_choose_4") ;players choice ui: "keep vertical looking inverted? press accept to keep look inverted, press cancel to go back"
	(sleep_until
		(cond
			((player_action_test_context_primary)
				(begin ; press accept to keep invert look
					(print_if b_debug_gameplay "keep look inverted")
					(f_show_hud_text "tutorial_looking_choose_1") ;ui : "vertical looking is now inverted|nlook up and down"
					(set b_is_player_chose_yinversion1 true)
				)
			)
			((player_action_test_rotate_weapons)
				(begin; press cancel to keep look as normal
					(print "look is normal")
					(f_show_hud_text "tutorial_looking_choose_3") ;ui : "vertical looking is now normal|nlook up and down"
					(player_invert_look_y player0)
					(set b_is_player_chose_yinversion0 true)
				)
			)
		)
		1
	)
	(set b_is_player_done_calib_lights true)
)

(script dormant red_square_tech
	(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:targetsensor_walk" true) ; leomartinez edit
	(wake nav_red_square)
	(dialog_cryo_tech_wakeup)
	(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )

	(wake red_square_request)

	(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:targetsensor_idle" true) ; leomartinez edit

	(sleep_until b_cryo_tech_calib_point 1)

	(sleep_until (and b_cryo_tech_free_b b_is_player_in_red_square) 1)
	(set b_cryo_tech_free false)
	(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:targetsensor_lightpanels" true)
	(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
	(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:targetsensor_idle" true)
	;(sleep (game_ticks_from_seconds 1)) ;if we interupt the anim too soon it lets the player move
	(set b_cryo_tech_free true)


	(sleep_until b_is_player_done_yinversion 1)
)

(script dormant red_square_request
	;if player leaves red square
	(sleep_until
		(begin
			(if
				(volume_test_players tv_red_square)
					(begin
						(print "inside red square")
						(set b_is_player_in_red_square true)
						(sleep_until (not (volume_test_players tv_red_square)) 1)

					)
					(begin
						(print "outside red square")
						(set b_is_player_in_red_square false)
						(if (not (or (volume_test_players tv_red_square) b_is_player_done_calib_lights))
							(begin
								(sleep_until b_cryo_tech_free 1)
								(set b_cryo_tech_free_b false)
								(if (game_all_quiet) (f_md_3d_play 0 sq_cryo_tech/tech m01_00560 "cryotech: stand on the red square, please."))
								(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:targetsensor_standonsquare" true)
								(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
								(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:targetsensor_idle" true)
								(f_hud_obj_repeat "tutorial_looking_targeted_1")
								;(sleep (game_ticks_from_seconds 1)) ;if we interupt the anim too soon it lets the player move
								(set b_cryo_tech_free_b true)
							)
						)

						(sleep_until (or (volume_test_players tv_red_square) b_cryo_tech_free) 1 (game_ticks_from_seconds 9)) ;reminder delay
					)
				)
				b_is_player_done_calib_lights
			)
			(game_ticks_from_seconds 1) ;makes sure the hint doesn't take too long to play initially, but also doesn't play as soon as the player leaves the square
		)
)

(script dormant nav_red_square
	(f_blip_flag fl_navpoint_look_calibrate 0)
	(sleep_until (volume_test_players tv_red_square))
	(f_unblip_flag fl_navpoint_look_calibrate)
)

;=================================================================================================
; a10_a_tutorial_yellowsquare
;=================================================================================================
(script dormant a10_a_tutorial_yellowsquare
	(sleep_until b_is_tech_red_square_done 1)
	(print_if b_debug_gameplay "a10_a_tutorial_yellowsquare")
	(wake dialog_yellow_square_test)

	(wake yellow_square_tech)
;	(cs_run_command_script sq_cryo_tech/asst cs_yellow_square_asst)

	;ui training objective
	(f_hud_obj_new "tutorial_shields" "tutorial_shields") ; ui: "stand on the yellow square for shield calibration"
	(wake nav_yellow_square)

	(sleep_until (volume_test_players tv_yellow_square) 1)
	(if (volume_test_players tv_yellow_square)
		(begin
			(sleep -1 yellow_square_request)
			(player_disable_movement true)
			;disable floor is lava skull
			(skull_affects_players skull_floor_is_lava false)
			(set b_is_player_in_yellow_square true)

			(if (not (objects_can_see_object (players) sq_cryo_tech/tech 10))
				(begin
					(f_md_3d_play 0 sq_cryo_tech/tech m01_00720 "cryotech: sir, i need you to look at me so we can begin.")

					(sleep_until (and b_is_player_in_yellow_square (objects_can_see_object (players) sq_cryo_tech/tech 15) 1))

					(f_md_3d_play 20 sq_cryo_tech/tech m01_00730 "cryotech: thank you, sir.")
				)
			)
		)
	)

	(set g_cryo_shield_progress 1)
	(sleep (* 30 1))
	; stub animation
	(print_if b_debug_gameplay "*tech interacts with calibration machine*")
	(object_set_shield player0 0)
	(object_set_shield_stun player0 3)
	(chud_fade_shield_for_player player0 1 1)
	(sleep (* 30 3))

	; bringing shields online
	; stub effect & animation of the device
	(print_if b_debug_gameplay "effect: shield calibration device animating")
	; zapper fx/animation gets activated at 0.5
	(device_set_position_immediate dm_vignette_0_1_shield 0.5)
	; stub fade in shields hud
	(print_if b_debug_gameplay "hud: shields ui fade in")
	(sleep (* 30 3))

	(set g_cryo_shield_progress 2)
	(object_set_shield_stun player0 (* 30 3))


	; todo show training if available [sheilds]
	;(hud_set_training_text add_id)
	;(hud_show_training_text true)

	(sleep (* 30 6)) ; pause for vo lines to finish

	; empty player shield to test recharge
	;(object_set_shield player0 0)
	;(object_set_shield_stun player0 2)
	(damage_new "levels/halo1/solo/a15/a15_shield" fl_navpoint_shield_calibrate)
	(sleep (* 30 3))

	(set g_cryo_shield_progress 3)
	(sleep (* 30 4))

	; make sure zapper can't restart on reload
	(device_set_position_immediate dm_vignette_0_1_shield 1)


	; stub fx/flavor far-off explosion
;	(print_if b_debug_gameplay "stub: far-off explosion fx missing")

	; todo enable red warning lights

	(set b_is_tech_yellow_square_done true)
	(player_disable_movement false)
	;enable floor is lava skull
	(skull_affects_players skull_floor_is_lava true)

	(gp_notify_calibration_complete)
	(set b_tutorial_cryo_done true)
)

(script dormant yellow_square_tech

	(sleep (game_ticks_from_seconds 2))

	(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:shieldtest_walk" true)  ; leomartinez edit
	(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )

	;(sleep (* 30 1))

	(if (not (volume_test_players tv_yellow_square)) (wake yellow_square_request))

	(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:shieldtest_idle_01" true)  ; leomartinez edit

	(sleep_until b_is_player_in_yellow_square 1)

	(sleep (game_ticks_from_seconds 5))

	(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:shieldtest_idle_01_to_02" true)  ; leomartinez edit
	(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
	(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:shieldtest_idle_02" true)  ; leomartinez edit
)

(script dormant yellow_square_request
	; while waiting for player to enter yellow square
	(sleep_until
		(begin
			(if (not b_is_player_in_yellow_square )
				(begin
					(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:shieldtest_idle_01_standonsquare" true)
					(f_md_3d_play 0 sq_cryo_tech/tech m01_00710 "cryotech: stand on the yellow square. this'll just take a second.")
					(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
					(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:shieldtest_idle_01" true)


					;(f_hud_obj_repeat "tutorial_shields")
					(sleep (game_ticks_from_seconds 10)) ;time till repeat
					b_is_player_in_yellow_square
				)
			)
		)
		1
	)
)

(script dormant nav_yellow_square
	(f_blip_flag fl_navpoint_shield_calibrate 0)
	(sleep_until (volume_test_players tv_yellow_square))
	(f_unblip_flag fl_navpoint_shield_calibrate)
)

;=================================================================================================
; a10_a_interactive_cutscene_sam (if skipping tutorial, this scene plays after skipping)
;=================================================================================================
(script dormant a10_a_interactive_cutscene_sam
	(print_if b_debug_gameplay "a10_a_interactive_cutscene_sam started.")
	(wake watch_drama) ;tech faces asst
	(cs_run_command_script sq_cryo_tech/asst cs_drama_asst) ;asst faces elite

	(wake dialog_cryo_captain_orders)

	(sleep_until (= g_cryo_captain_order_progress 1) 1)
	;objective ui
	(f_hud_obj_new_no_hud_completion "dia_a10_bridge" "obj_a10_bridge")

	(sleep_until (> g_cryo_captain_order_progress 2) 1)


	(ai_place sq_cryo_bane)
	(cs_run_command_script sq_cryo_bane/elite cs_drama_elite)

	; player looks at asst or enters volume to trigger elite sequence, otherwise it starts after 5 sec
	(sleep_until (or (objects_can_see_object (players) sq_cryo_tech/asst 40) (volume_test_players tv_cryo_explosion_trigger_1))1 (* 30 5))
	(set b_is_player_watching_drama true)
	;(custom_animation sq_cryo_tech/asst "objects\characters\marine\marine" "panic:idle:var1" true) ; leomartinez edit

	(sleep (game_ticks_from_seconds 4) )

	; open door to sam
	(device_set_position_immediate dm_cryo_door_1 1)
	(device_set_power dm_cryo_door_1 0)
	(device_set_power dm_cryo_door_2 1)

	;explosion coincides with door open

	(pe_camera_shake_m)
	; vfx vignette machine activation happens at 0.5
	(device_set_position_immediate dm_vignette_1_2_explosion 0.5)
	(print_if (= (device_get_position dm_vignette_1_2_explosion) 0.5) "dm_vignette_1_2_explosion fired")
	(device_set_position_immediate dm_vignette_1_3_lights 1)
	(print_if (= (device_get_position dm_vignette_1_3_lights) 1) "dm_vignette_1_3_lights fired")
	(sleep 3)
	; vfx vignette machine 1 forces vignettes into final position without retriggering one shot particles systems
	(device_set_position_immediate dm_vignette_1_2_explosion 1)

	(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:intruders_react" true)
	(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
	

)

(script dormant watch_drama

	(if (not b_fast_setup_done)
		(begin
			(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:shieldtest_captainkeys" true)  ; leomartinez edit
			(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
		)
		(begin
			(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:wakeup_captainkeys" true)  ; leomartinez edit
			(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
		)
	)

	(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:intruders_idle" true) ; leomartinez edit
)

(script command_script cs_drama_asst
	(cs_abort_on_alert false)
	(cs_abort_on_damage false)
	(cs_walk true)
	(cs_go_to ps_drama_sam/p0 5)
	;(cs_face_object true sq_cryo_tech/tech) ; leomartinez edit - using cs_look_object instead
	(cs_look_object true sq_cryo_tech/tech) ; leomartinez add
	(cs_stow false)
	(cs_enable_moving false)

	(sleep_until (> g_cryo_captain_order_progress 2) 1)
	(unit_set_stance sq_cryo_tech/asst "panic") ; leomartinez add
	

	(sleep_until b_is_player_watching_drama 1)
	(wake dialog_drama_asst)
	;(cs_face_object true dm_cryo_door_1)
	(cs_custom_animation objects\characters\marine\marine "panic:surprise_left" true) ; leomartinez add
	(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/asst) false) 1 )
	(cs_custom_animation objects\characters\marine\marine "panic:turn_left" true) ; leomartinez add

	;(pe_camera_shake_m)
	;(cs_custom_animation objects\characters\marine\marine "panic:idle" true)
	(sleep_until (= (device_get_position dm_cryo_door_1) 1) 1)
	(cs_custom_animation objects\characters\marine\marine "panic:stagger_explosions" true)

	(object_can_take_damage (ai_actors sq_cryo_tech/asst))
	(object_cannot_die sq_cryo_tech/asst false)
	(ai_cannot_die sq_cryo_tech/asst false)

	;(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/asst) false) 1 )
	;(cs_custom_animation objects\characters\marine\marine "panic:idle" true)

	;(sleep_until (= g_cryo_captain_order_progress 4) 1)

	(sleep_until (< (unit_get_health sq_cryo_tech/asst) 1) 1 (game_ticks_from_seconds 20))
	(cs_custom_animation objects\characters\marine\marine "any:h_kill:front:head" true)
	(sleep 30) ;want to kill the assistant as the animation is about to end
	(cs_die 0) 
	(set s_ambient_shake_intensity 2)
)

(script command_script cs_drama_elite
	(object_cannot_die sq_cryo_bane/elite true)
	(sleep (game_ticks_from_seconds 6) )
	(cs_move_towards_point ps_drama_sam/p2 .5)

	(sleep_until b_is_player_watching_drama 1)

	;(sleep 30)
	(cs_shoot false)
	(cs_move_towards_point ps_drama_sam/p2 .25)

	(cs_aim_object true sq_cryo_tech/asst)
	(sleep_until (= g_cryo_captain_order_progress 4) 1)

	(cs_aim_object true sq_cryo_tech/asst)
	(set g_cryo_captain_order_progress 5)
	(cs_shoot true sq_cryo_tech/asst)

	(sleep 60)

	(device_set_power dm_cryo_explosion_door_3 1)

	(sleep_until (< (unit_get_health sq_cryo_tech/asst) 1) 1 (game_ticks_from_seconds 20))

	(cs_go_to ps_drama_sam/p0)

	(cs_action_at_player ai_action_point)
	(cs_action_at_player ai_action_taunt)

	(sleep (game_ticks_from_seconds .5) )
	(cs_go_to ps_drama_sam/p3)
	(ai_erase sq_cryo_bane)

)

;====================================================================================================================================================================================================
; a10_b_to_the_bridge
;====================================================================================================================================================================================================
(script dormant a10_b_to_the_bridge
	(print_if b_debug_gameplay "a10_b_to_the_bridge waiting..")
	(print_if b_debug_gameplay "a10_b_to_the_bridge started.")
;	(f_game_save) - start heroic/legendary diff from here
	(sleep_until (= g_cryo_captain_order_progress 5) 1)

	;open cryo doors, start moving tech

	;*(sleep_until (or
		(objects_can_see_object (players) sq_cryo_tech/tech 40)
		(volume_test_players tv_tutorial_skip_1))
	1)

	(sleep 60)*;

	(object_can_take_damage (ai_actors sq_cryo_tech/tech))
	(ai_cannot_die sq_cryo_tech/tech false)

	(print "running through the door- wakey true")

	(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:escape_run" true) ; leomartinez edit

	(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
	(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "ma15:cryo_marine:escape:idle_thisway" true)

	(wake dialog_cryo_get_out)
	(sleep_until (objects_can_see_object (players) sq_cryo_tech/tech 40) 1)


	(custom_animation sq_cryo_tech/tech "objects\characters\marine\marine" "ma15_cryo_marine:escape_run_hallway" true) ; leomartinez edit
	(sleep_until ( = (unit_is_playing_custom_animation sq_cryo_tech/tech) false) 1 )
	(print "cryo tech idling")
	(custom_animation_loop sq_cryo_tech/tech "objects\characters\marine\marine" "panic:idle" true)
)


;====================================================================================================================================================================================================
; tutorials\trainings ==============================================================================================================================================
;====================================================================================================================================================================================================

;*
	(script dormant title_training
	>>todo move tranings out<<
	^						 ^
	^   					 ^
)
*;
;\\ trainings in order as the player triggers them (only on easy/normal)

(script dormant tutorial_jump
	(sleep_until (volume_test_players tv_moving_jump) 1)
	(hud_enable_training false)

	(print_if b_debug_gameplay "tutorial_jump: how to jump")

	(player_action_test_reset)
    (sleep 1)

	(player_training_activate_jump)

	(hud_enable_training true)

	(print_if b_debug_gameplay "jump training complete")

	(set b_tutorial_jump_done true)
)


(script dormant tutorial_crouch
	(sleep_until (volume_test_players tv_moving_crouch) 1)
	(hud_enable_training false)

	(print_if b_debug_gameplay "tutorial_crouch: how to crouch")

	(player_action_test_reset)
    (sleep 1)

	(player_training_activate_crouch)

	(hud_enable_training true)

	(print_if b_debug_gameplay "crouch tutorial complete")

	(set b_tutorial_crouch_done true)
)

(script dormant tutorial_weapon
	(sleep_until (unit_has_weapon_readied player0 objects\weapons\pistol\magnum\magnum.weapon) 1)

	(wake tutorial_get_weapon)

	(print_if b_debug_gameplay "tutorial_weapon: how to use a weapon")

	(sleep_until
		(and
			 (unit_has_weapon_readied player0 objects\weapons\pistol\magnum\magnum.weapon)
			 (volume_test_players tv_shoot_trigger_1)
		)
	1)

	;fire weapon
	(hud_set_training_text "training_leftfire")
	(hud_show_training_text true)

	(player_action_test_reset)
    (sleep_until (player_action_test_primary_trigger) 1 90)

	(hud_show_training_text false)
	(hud_set_training_text "")

	(sleep 30)

	;use weapon scope
	(hud_set_training_text "training_zoom")
	(hud_show_training_text true)

	(player_action_test_reset)
    (sleep_until (player_action_test_secondary_trigger) 1 90)

	(hud_show_training_text false)
	(hud_set_training_text "")

	(sleep 30)

	;reload weapon
	(hud_set_training_text "training_reload")
	(hud_show_training_text true)

	(player_action_test_reset)
    (sleep_until (player_action_test_context_primary) 1 90) ; needs a player_action_test for reload to cover kb&m + controller inputs (only checks correctly for conroller)

	(hud_show_training_text false)
	(hud_set_training_text "")

	(sleep 30)

	(print_if b_debug_gameplay "weapon training complete")

	(set b_tutorial_weapon_done true)
)

(script dormant tutorial_get_weapon
	(sleep_until b_tutorial_weapon_done 1)

;	(wake tutorial_second_weapon) roll into training text for this tutorial
	(print_if b_debug_gameplay "tutorial_get_weapon: how to pick up a weapon")

	(sleep_until
		(or (volume_test_players tv_cafeteria_trigger_2)
			(= 0 (ai_living_count sq_shoot_anti))
		)
	1)

	(hud_set_training_text "training_swaphold")
	(hud_show_training_text true)

	(player_action_test_reset)
	(sleep_until (player_action_test_context_primary) 1)
	(sleep 60)

	(if (weapons_number_is_two)
		(print_if b_debug_gameplay "weapon picked up, training complete")
	)

	(hud_show_training_text false)
	(hud_set_training_text "")

	(set b_tutorial_get_weapon true)
)

;*(script dormant tutorial_second_weapon
	(sleep_until
		(and (weapons_number_is_two) b_tutorial_get_weapon)
	1)

	; todo wait for second weapon
	(print_if b_debug_gameplay "tutorial: second weapon picked")
	(print_if b_debug_gameplay "tutorial popup: use wheel to switch weapons")

	 ;placeholder ui
	(f_show_tutorial_text "tut_cyc_weap")

	; todo print as tooltip/popup
	;(hud_set_training_text add_id)
	;(hud_show_training_text true)

	(player_action_test_reset)
	(sleep_until (player_action_test_rotate_weapons) 1)
	(print_if b_debug_gameplay "tutorial: weapon cycling complete")
	;(hud_show_training_text false)
	(set b_tutorial_second_weapon_done true)
)*;

;(script dormant tutorial_terminal
;	(sleep_until (and (not b_tutorial_terminal_done) (volume_test_players elevator_trigger)) 1)
;	 todo print as tooltip/popup
;	(print_if b_debug_gameplay "tutorial_terminal: how to access terminals")
;	(print_if b_debug_gameplay "tutorial popup: press e to interact")
;	(hud_set_training_text add_id)
;	(hud_show_training_text true)
;	(sleep (* 30 5))
;	(hud_show_training_text false)
;	(set b_tutorial_terminal_done true)
;)

;(script dormant tutorial_navmarker
;	(sleep_until (and (not b_tutorial_navmarker_done) b_a10_b_done
;		(or (volume_test_players navpoint_trigger_1) (volume_test_players navpoint_trigger_2)))
;	1)
;	(print_if b_debug_gameplay "tutorial_navmarker: how to use navmarkers")
;	(wake navpoint_1)
;	(wake navpoint_2)
;	(sleep_until (volume_test_players flank_trigger_3) 1)
;	(set b_tutorial_navmarker_done true)
;	(sleep_forever navpoint_1)
;	(sleep_forever navpoint_2)
;	(f_unblip_flag tutorial_navpoint_flag_1)
;	(f_unblip_flag tutorial_navpoint_flag_2)
;)

;(script dormant navpoint_1
;	(sleep_until
;		(begin
;			(sleep_until (volume_test_players navpoint_trigger_1) 1)
			; stub tutorial
;			(f_blip_flag tutorial_navpoint_flag_1 0)
;			(f_unblip_flag tutorial_navpoint_flag_2)
;			b_tutorial_navmarker_done)1)
;)

;(script dormant navpoint_2
;	(sleep_until
;		(begin
;			(sleep_until (volume_test_players navpoint_trigger_2) 1)
;			; stub tutorial
;			(f_blip_flag tutorial_navpoint_flag_2 0)
;			(f_unblip_flag tutorial_navpoint_flag_1)
;			b_tutorial_navmarker_done)1)
;)

;(script dormant tutorial_radar
;	(sleep_until (and
;		(or (volume_test_players radar_trigger_1) (volume_test_players radar_trigger_2))
;		b_a10_b_done
;		(not b_tutorial_radar_done))
;	1)

;	; stub tutorial
;	(chud_fade_motion_sensor_for_player player0 1 1)
;	(print_if b_debug_gameplay "tutorial_radar: how to use radar")
	; not in the original, delete if not desired
	;(hud_set_training_text add_id)
	;(hud_show_training_text true)
	;(sleep (* 30 5))
	;(hud_show_training_text false)
;	(set b_tutorial_radar_done true)
;)

;*
(script dormant tutorial_flanking
	(sleep_until (and (not b_tutorial_flanking_done) b_a10_b_done (volume_test_players tv_flank_trigger_2) 1))

	; stub tutorial
	(print_if b_debug_gameplay "tutorial_flanking: how to use flanking")
	; not in the original, delete if not desired
	;(hud_set_training_text training_crouch)
	;(hud_show_training_text true)
	;(sleep 5)
	;(hud_show_training_text false)
	(set b_tutorial_flanking_done true)
)
*;

(script dormant tutorial_flashlight
	(sleep_until (volume_test_players tv_light_1) 1)

	(print_if b_debug_gameplay "tutorial_flashlight: how to use a flashlight")

	;using the following due to (player_training_activate_flashlight) taking priority when used. blocks other trainings if the player never activates flashlight
	(hud_set_training_text "training_flashlight")
	(hud_show_training_text true)

	(player_action_test_reset)
	(sleep_until
		(begin
			(if (not (player_night_vision_on)) (set s_tutorial_flashlight_count 0)
				(if (player_night_vision_on)
					(set s_tutorial_flashlight_count (+ s_tutorial_flashlight_count 1))
				)
			)
			(= s_tutorial_flashlight_count 1)
		)
		1
	)

	(sleep_until (<= s_tutorial_flashlight_count 1) 1)

	(hud_show_training_text false)
	(hud_set_training_text "")

	(print_if b_debug_gameplay "flashlight training complete")
	(set b_tutorial_flashlight_done true)
)

(script dormant tutorial_melee
	(sleep_until (volume_test_players tv_melee_trigger_1) 1)

	(print_if b_debug_gameplay "tutorial_melee : how to melee")

	(hud_set_training_text "training_rearmelee")
	(hud_show_training_text true)

	(player_action_test_reset)
	(sleep_until (player_action_test_melee) 1)

	(hud_show_training_text false)
	(hud_set_training_text "")

	(print_if b_debug_gameplay "melee training complete")
	(set b_tutorial_melee_done true)
)


(script dormant tutorial_sprint
	; right after cryo search beat and heading towards boom room (might need to make a seperate volume after the door)
	(sleep_until (volume_test_players tv_boom_trigger_1) 1)

	(print_if b_debug_gameplay "tutorial_sprint: how to sprint")

	(player_action_test_reset)
	(sleep 1)

	(player_training_activate_sprint)

	(set b_tutorial_sprint_done true)
)

(script dormant tutorial_grenades
	(sleep_until (volume_test_players tv_grenade_trigger) 1)

	(print_if b_debug_gameplay "tutorial_grenades: how to use grenades")

	(chud_fade_grenades_for_player player0 1 1)  ; reactivate grenade ui

	(hud_set_training_text "training_throwgrenade")
	(hud_show_training_text true)

	(player_action_test_reset)
	(sleep_until (player_action_test_grenade_trigger) 1)

	(hud_show_training_text false)
	(hud_set_training_text "")

	(print_if b_debug_gameplay "grenade training complete")
	(set b_tutorial_grenades_done true)
)

(script dormant tutorial_equipment
	(sleep_until
		(and (or (volume_test_players tv_equipment_1) (volume_test_players tv_equipment_2)) (equipment_overshield))
	1)

	(print_if b_debug_gameplay "tutorial_grenade: how to use special equipment")

;	(player_action_test_reset) for player_training_activate
;	(sleep 1)

;	(player_training_activate_equipment) - not displaying/functional yet

	(hud_set_training_text "training_equipment")
	(hud_show_training_text true)

	(player_action_test_reset)
	(sleep_until (player_action_test_equipment) 1)

	(hud_show_training_text false)
	(hud_set_training_text "")

	(print_if b_debug_gameplay "equipment training complete")
	(set b_tutorial_equipment_done true)
)
