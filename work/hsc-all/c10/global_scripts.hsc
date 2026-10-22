; ===============================================================================================================================================
; global scripts ================================================================================================================================
; ===============================================================================================================================================
(global boolean b_debug_globals false)

(global short player_00 0)
(global short player_01 1)
(global short player_02 2)
(global short player_03 3)

(global short s_md_play_time 0)

(global ai_line s_last_played_ai_line "")
(global boolean b_is_dialogue_playing false)
(global boolean b_print_vo_lines true)

; vehicle types - can be used in the unit_in_vehicle_type function
; these values have been taken from campaign_metagame_bucket_types.inl
; -> their order may be subject to change, use with care and test
(global short s_vehicle_type_turret 16)
(global short s_vehicle_type_mongoose 17)
(global short s_vehicle_type_warthog 18)
(global short s_vehicle_type_scorpion 19)
(global short s_vehicle_type_hornet 20)
(global short s_vehicle_type_pelican 21)
(global short s_vehicle_type_revenant 22)
(global short s_vehicle_type_seraph 23)
(global short s_vehicle_type_shade 24)
(global short s_vehicle_type_watchtower 25)
(global short s_vehicle_type_ghost 26)
(global short s_vehicle_type_chopper 27)
(global short s_vehicle_type_mauler 28)
(global short s_vehicle_type_wraith 29)
(global short s_vehicle_type_banshee 30)
(global short s_vehicle_type_phantom 31)
(global short s_vehicle_type_scarab 32)
(global short s_vehicle_type_guntower 33)
(global short s_vehicle_type_tuning_fork 34)
(global short s_vehicle_type_pel_chin_gun 35)
(global short s_vehicle_type_sabre 36)
(global short s_vehicle_type_space_banshee 37)

; object type masks, used by volume_return_objects_by_type and object_destroy_type_mask etc
; object_mask_biped 1
; object_mask_vehicle 2
; object_mask_weapon 4
; object_mask_equipment 8
; object_mask_terminal 16
; object_mask_projectile 32
; object_mask_scenery 64
; object_mask_machine 128
; object_mask_control 256
; object_mask_sound_scenery 512
; object_mask_crate 1024
; object_mask_creature 2048
; object_mask_giant 4096
; object_mask_effect_scenery 8192

(script static unit player0
	(player_get 0)
)

(script static unit player1
	(player_get 1)
)

(script static unit player2
	(player_get 2)
)

(script static unit player3
	(player_get 3)
)

(script static short player_count
  (list_count (players)))

(script static void print_difficulty
	(cond
		((= (game_difficulty_get_real) easy)		(print "easy"))
		((= (game_difficulty_get_real) normal)		(print "normal"))
		((= (game_difficulty_get_real) heroic)		(print "heroic"))
		((= (game_difficulty_get_real) legendary)	(print "legendary"))
	)
)

; globals
(global string data_mine_mission_segment "")


; difficulty level scripts
(script static boolean difficulty_legendary
	(= (game_difficulty_get_real) legendary)
)

(script static boolean difficulty_heroic
	(= (game_difficulty_get_real) heroic)
)

(script static boolean difficulty_normal
	(<= (game_difficulty_get_real) normal)
)

(script static void replenish_players
	(if b_debug_globals (print "replenish player health..."))
	(unit_set_current_vitality player0 80 80)
	(unit_set_current_vitality player1 80 80)
	(unit_set_current_vitality player2 80 80)
	(unit_set_current_vitality player3 80 80)
)

; coop player booleans
(script static boolean coop_players_2
	(>= (game_coop_player_count) 2)
)
(script static boolean coop_players_3
	(>= (game_coop_player_count) 3)
)
(script static boolean coop_players_4
	(>= (game_coop_player_count) 4)
)

;returns true if any player is in a vehicle
(script static boolean any_players_in_vehicle
    (or
	     (unit_in_vehicle (unit player0))
	     (unit_in_vehicle (unit player1))
	     (unit_in_vehicle (unit player2))
	     (unit_in_vehicle (unit player3))
    )
)

;returns true if any player is in a vehicle of the specified type
;uses the s_vehicle_type_xxx globals defined above
(script static boolean (any_players_in_vehicle_type (long s_vehicle_type))
	(or
		(unit_in_vehicle_type player0 s_vehicle_type)
		(unit_in_vehicle_type player1 s_vehicle_type)
		(unit_in_vehicle_type player2 s_vehicle_type)
		(unit_in_vehicle_type player3 s_vehicle_type)
	)
)

;fades dropships out and then destroys it
(script static void (f_dropship_actor_scale_destroy (ai dropship_actor))
	(object_set_scale (ai_vehicle_get dropship_actor) .01 (game_ticks_from_seconds 6))
	(sleep (game_ticks_from_seconds 6))
	(object_destroy (ai_vehicle_get dropship_actor))
)

;fades the vehicle out and then destroys it
(script static void (f_vehicle_scale_destroy (vehicle vehicle_variable))
	(object_set_scale vehicle_variable .01 (game_ticks_from_seconds 6))
	(sleep (game_ticks_from_seconds 6))
	(object_destroy vehicle_variable)
)

;spawn explosion at custcene location
(script static void (f_explosion_effect (cutscene_flag cutscene_variable))
	(effect_new "objects/weapons/grenade/frag_grenade/fx/airborne_detonation_met.effect" cutscene_variable)
)

;for placing pelicans and falcons etc that are critial and cannot die
(script static void (f_ai_place_vehicle_deathless (ai squad))
	(ai_place squad)
	(ai_cannot_die (object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0))) true)
	(object_cannot_die (ai_vehicle_get_from_squad squad 0) true)
)

(script static void (f_ai_place_vehicle_deathless_no_emp (ai squad))
	(ai_place squad)
	(ai_cannot_die (object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0))) true)
	(object_cannot_die (ai_vehicle_get_from_squad squad 0) true)
	(object_ignores_emp (ai_vehicle_get_from_squad squad 0) true)
)

;to get the number of ai passengers in a vehicle
(script static short (f_vehicle_rider_number (vehicle v))
	(list_count (vehicle_riders v))
)

;to determine if first squad is riding in vehicle of second squad
(script static boolean (f_all_squad_in_vehicle (ai inf_squad) (ai vehicle_squad))
	(and
		(= (ai_living_count inf_squad) 0)
		(= (ai_living_count vehicle_squad) (f_vehicle_rider_number (ai_vehicle_get_from_squad vehicle_squad 0)))
	)
)

;return the driver of a vehicle assuming only one vehicle in squad
(script static ai (f_ai_get_vehicle_driver (ai squad))
	(object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0)))
)


; call magic sight on all players
(script static void (f_ai_magically_see_players (ai squad))
	(ai_magically_see_object squad player0)
	(ai_magically_see_object squad player1)
	(ai_magically_see_object squad player2)
	(ai_magically_see_object squad player3)
)

(global short s_ai_random_spawned_num 0)
; randomly spawn ai from list until s_num_requested is reached. if bigger than num of spawnable ai, will spawn all available ai
; use "none" for unused ai slots
(script static void (f_ai_place_random (short s_num_requested) (ai ai1) (ai ai2) (ai ai3) (ai ai4) (ai ai5) (ai ai6) (real random_sleep_limit))
	(set s_ai_random_spawned_num 1)
	(begin_random
		(if (and
				(not (= ai1 none))
				(<= s_ai_random_spawned_num s_num_requested))
			(begin
				(ai_place ai1)
				(set s_ai_random_spawned_num (+ s_ai_random_spawned_num 1))
				(sleep (* 30 (real_random_range 0 random_sleep_limit)))
			)
		)
		(if (and
				(not (= ai2 none))
				(<= s_ai_random_spawned_num s_num_requested))
			(begin
				(ai_place ai2)
				(set s_ai_random_spawned_num (+ s_ai_random_spawned_num 1))
				(sleep (* 30 (real_random_range 0 random_sleep_limit)))
			)
		)
		(if (and
				(not (= ai3 none))
				(<= s_ai_random_spawned_num s_num_requested))
			(begin
				(ai_place ai3)
				(set s_ai_random_spawned_num (+ s_ai_random_spawned_num 1))
				(sleep (* 30 (real_random_range 0 random_sleep_limit)))
			)
		)
		(if (and
				(not (= ai4 none))
				(<= s_ai_random_spawned_num s_num_requested))
			(begin
				(ai_place ai4)
				(set s_ai_random_spawned_num (+ s_ai_random_spawned_num 1))
				(sleep (* 30 (real_random_range 0 random_sleep_limit)))
			)
		)
		(if (and
				(not (= ai5 none))
				(<= s_ai_random_spawned_num s_num_requested))
			(begin
				(ai_place ai5)
				(set s_ai_random_spawned_num (+ s_ai_random_spawned_num 1))
				(sleep (* 30 (real_random_range 0 random_sleep_limit)))
			)
		)
		(if (and
				(not (= ai6 none))
				(<= s_ai_random_spawned_num s_num_requested))
			(begin
				(ai_place ai6)
				(set s_ai_random_spawned_num (+ s_ai_random_spawned_num 1))
				(sleep (* 30 (real_random_range 0 random_sleep_limit)))
			)
		)
	)
)

(script static void (f_ai_place_over_ticks (ai ai1) (ai ai2) (ai ai3) (ai ai4) (ai ai5) (ai ai6))
	(if
		(not (= ai1 none))
		(begin
			(ai_place ai1)
			(sleep 1)
		)
	)
	(if
		(not (= ai2 none))
		(begin
			(ai_place ai2)
			(sleep 1)
		)
	)
	(if
		(not (= ai3 none))
		(begin
			(ai_place ai3)
			(sleep 1)
		)
	)
	(if
		(not (= ai4 none))
		(begin
			(ai_place ai4)
			(sleep 1)
		)
	)
	(if
		(not (= ai5 none))
		(begin
			(ai_place ai5)
			(sleep 1)
		)
	)
	(if
		(not (= ai6 none))
		(begin
			(ai_place ai6)
			(sleep 1)
		)
	)
)

; ===============================================================================================================================================
; player teleporting =================================================================================================================================
;
; not teleporting vehicles?  use the c++ binding instead!  -> volume_teleport_players_not_inside
; ===============================================================================================================================================

(script static void (f_volume_teleport_player_not_inside_with_vehicle (player player_to_teleport) (trigger_volume tv_safety_volume) (cutscene_flag teleport_to))
	(if (not (volume_test_object tv_safety_volume player_to_teleport))
		(player_teleport player_to_teleport teleport_to true) ; then player is not in volume and needs teleport
	)
)

; ===============================================================================================================================================
; global health script =================================================================================================================================
; ===============================================================================================================================================
(script dormant f_global_health_saves
	(sleep_until (> (player_count) 0))
	(sleep_until
		(begin
			(sleep_until (< (object_get_health player0) 1))
			(sleep (* 30 7))
			(if (< (object_get_health player0) 1)
				(begin
					(sleep_until (= (object_get_health player0) 1))
					(print "global health: health pack aquired")
					(game_save)
				)
				(print "global health: re-gen")
			)
			false
		)
	)

)

; ===============================================================================================================================================
; global game save =================================================================================================================================
; ===============================================================================================================================================
(script static void (f_game_save)
	(game_save_no_timeout)
	(print "game save requested..")
)

(script static void (f_save_at_trigger (trigger_volume volume))
	(sleep_until (volume_test_players volume) 1)
	(f_game_save)
)

(script static void (f_save_at_2_triggers (trigger_volume volume1) (trigger_volume volume2))
	(sleep_until (or (volume_test_players volume1) (volume_test_players volume2)) 1)
	(f_game_save)
)

(script static void (f_save_at_3_triggers (trigger_volume volume1) (trigger_volume volume2) (trigger_volume volume3))
	(sleep_until (or (volume_test_players volume1) (volume_test_players volume2) (volume_test_players volume3)) 1)
	(f_game_save)
)

; ===============================================================================================================================================
; auto save loop =================================================================================================================================
; ===============================================================================================================================================
(global real r_auto_save_loop_check_time 60) ; default time between auto save checks in seconds, can be changed with f_unpause_auto_save_loop with new loop time function
(global boolean b_try_auto_save_loop true) ; whether the auto save loop should be running or not, can be turned on and off with f_pause_auto_save_loop and f_unpause_auto_save_loop functions

; default save loop - requests savegame every r_auto_save_loop_check_time seconds
;   turn on by default if easy or normal difficulty
;   sleep until b_try_auto_save_loop is true and there is no cinematic playing
;   if game is currently able to save, request a save

(script static void f_start_auto_save_loop
	(if (= (game_difficulty_get) normal)
		(wake auto_save_loop)
	)
)

(script dormant auto_save_loop
	;the loop will sleep game_ticks_from_seconds r_auto_save_loop_check_time before starting the first check

	(sleep_until
		(begin
			;sleep until try auto save loop is true and cinematic is not playing then request a save
			(sleep_until (and
				(= (cinematic_in_progress) false)
				b_try_auto_save_loop)
			1)

			(if (not (game_saving))
				(begin
					(print "auto save loop: requesting save")
					(f_game_save)
				)
			)

			false
		)
		(game_ticks_from_seconds r_auto_save_loop_check_time)
	)
)

;turn off the save loop and cancel save in progress
(script static void (f_pause_auto_save_loop)
	(set b_try_auto_save_loop false)
	(game_save_cancel)
	(print "auto save loop paused")
)

(script static void (f_unpause_auto_save_loop)
	(set b_try_auto_save_loop true)
	(print "auto save loop un paused")
)

(script static void (f_unpause_auto_save_loop (real save_loop_time))
	(set b_try_auto_save_loop true)
	(set r_auto_save_loop_check_time save_loop_time)
	(print "auto save loop un paused with new loop time")
	(inspect r_auto_save_loop_check_time)
)

; ===============================================================================================================================================
; setup helpers =================================================================================================================================
; ===============================================================================================================================================
(script dormant f_debug_global_save_loop
	; default save loop - requests savegame every 30 seconds, will save if possible (system under the hood takes care of that)
	(sleep_until
		(begin
			(game_save_no_timeout)
			(print "debug checkpoint requested")
			(sleep (* 30 30))
			false
		)
	)
)

; macro
(script static void (f_global_setup_ai_grenades)
	(cond ((game_is_cooperative) (ai_grenades 1))
		 ((not (= normal (game_difficulty_get))) (ai_grenades 1))
		 (true (ai_grenades 0))
		 )
)

; ===============================================================================================================================================
; coop resume messaging =========================================================================================================================
; ===============================================================================================================================================
(script static void (f_coop_resume_unlocked
									(cutscene_title	resume_title)
									(insertion_point insertion_point)
				)
	(if (game_is_cooperative)
		(begin
			(sound_impulse_start sfx_hud_in none 1)
			(cinematic_set_chud_objective resume_title)
			(game_insertion_point_unlock insertion_point)
			;(sleep (* 30 7)) commented this out because it was breaking stuff! dmiller march 28/09
			;(sound_impulse_start sfx_hud_out none 1) commented this out temp because it was gonna sound weird!
		)
	)
)

; ===============================================================================================================================================
; performances ==================================================================================================================================
; ===============================================================================================================================================

; this script is called from a thread spawned by a performance.
; therefore all of the "performance_..." functions known which performance the function calls are intended for
; and thus we don't have to pass in a performance index.
; the default script function simply plays through all of the lines in the script, one after the other.

(script static void performance_default_script
	(sleep_until
		(begin
			(performance_play_line_by_id (+ (performance_get_last_played_line_index) 1))
		(>= (+ (performance_get_last_played_line_index) 1) (performance_get_line_count))) 0)
)


; ===== do not delete this ever ===================
(script startup beginning_mission_segment
	(data_mine_set_mission_segment mission_start)
)


; =================================================================================================
; training
; =================================================================================================
(script static void (f_hud_training (player player_num) (string_id string_hud))
	(chud_show_screen_training player_num string_hud)
	(sleep 120)
	(chud_show_screen_training player_num "")
)

(script static void f_hud_training_new_weapon
	(chud_set_static_hs_variable player0 0 1)
	(chud_set_static_hs_variable player1 0 1)
	(chud_set_static_hs_variable player2 0 1)
	(chud_set_static_hs_variable player3 0 1)
	(sleep 200)
	(chud_clear_hs_variable player0 0)
	(chud_clear_hs_variable player1 0)
	(chud_clear_hs_variable player2 0)
	(chud_clear_hs_variable player3 0)
)

(script static void (f_hud_training_confirm (player player_num) (string_id string_hud) (string button_press))
	;kill script if there is no player
	(if (= (player_is_in_game player_num) false)
		(sleep_forever)
	)

	(chud_show_screen_training player_num string_hud)
	(sleep 10)

	(player_action_test_reset)
	(sleep_until
		(cond
			((= button_press "primary_trigger") (sleep_until (unit_action_test_primary_trigger player_num)))
			((= button_press "grenade_trigger") (sleep_until (unit_action_test_grenade_trigger  player_num)))
			((= button_press "equipment") (sleep_until (unit_action_test_equipment player_num)))
			((= button_press "melee") (sleep_until (unit_action_test_melee player_num)))
			((= button_press "jump") (sleep_until (unit_action_test_jump player_num)))
			((= button_press "rotate_grenades") (sleep_until (unit_action_test_rotate_grenades player_num)))
			((= button_press "rotate_weapons") (sleep_until (unit_action_test_rotate_weapons player_num)))
			((= button_press "context_primary") (sleep_until (unit_action_test_context_primary player_num)))
			((= button_press "vision_trigger") (sleep_until (or (unit_action_test_vision_trigger player_num) (player_night_vision_on))))
			((= button_press "back") (sleep_until (unit_action_test_back player_num)))
			((= button_press "vehicle_trick") (sleep_until (unit_action_test_vehicle_trick_primary player_num)))
		)
	1 (* 30 10))

	(chud_show_screen_training player_num "")
)

;example:
;(f_hud_training_confirm player0 ct_training_melee "melee")

; =================================================================================================
; flashlights
; =================================================================================================

(global short s_flashlight_ai_index 0)
;takes a given squad and moves them all to a given point
(script static void (f_ai_set_integrated_flashlight (ai squad) (boolean turn_on))
    (set s_flashlight_ai_index 0)
    (sleep_until
        (begin
            (unit_set_integrated_flashlight (unit (list_get (ai_actors squad) s_flashlight_ai_index)) turn_on)
            (set s_flashlight_ai_index (+ s_flashlight_ai_index 1))

            (>= s_flashlight_ai_index (list_count (ai_actors squad)))
        )
    1)
)


; =================================================================================================
; objectives
; =================================================================================================

; displays a new objective in both the pause and hud menu, and pops both an objective completed and new objective popup, with the standard pause between each popup
; this is the standard way to show objectives
(script static void (f_hud_obj_new (user_interface_objective obj_menu_reference) (user_interface_objective obj_hud_reference))
	; pause menu
	(f_hud_pause_menu_new_objective_internal obj_menu_reference)

	; hud
    (f_hud_obj_complete_current_objective_internal)
	(f_hud_obj_show_new_objective_internal obj_hud_reference)
)

(script static void (f_hud_obj_complete)
	; pause menu
	(f_hud_pause_menu_complete_objective_internal)
	; hud
    (f_hud_obj_complete_current_objective_internal)
)

; displays a new objective in both the pause and hud menu, and marks the objective complete in the pause menu.  however, it does not pop a "completed" message in the hud.
; special case for where a "completed" message in the hud would be confusing or inappropriate, but you want to mark the old objective completed in the pause menu so players know they no longer need to complete it
(script static void (f_hud_obj_new_no_hud_completion (user_interface_objective obj_menu_reference) (user_interface_objective obj_hud_reference))
	; pause menu
	(f_hud_pause_menu_new_objective_internal obj_menu_reference)

	; hud
	(f_hud_obj_show_new_objective_internal obj_hud_reference)
)

; shows the objective in the hud without changing its state.  useful when you want to remind the player of the current objective but do not have a new one to give.
(script static void (f_hud_obj_repeat (user_interface_objective obj_reference))
	(objectives_hud_tag_none)
	(objectives_hud_show_string obj_reference)
)

(script static void (f_show_hud_text (user_interface_objective obj_hud_reference))
	(f_hud_obj_show_new_objective_internal obj_hud_reference)
)


; =================================================================================================
; objectives internal
; these helpers should never be called by themselves as they will not update the pause menu or show completion of previous objective
; use f_hud_obj_new to show with completion (standard case) or f_hud_obj_replace to show with no completion and keep the pause menu updated
; if you need a new operation not covered by those two, make a new script in the section above that calls these internals in the correct order
; =================================================================================================

; pause menu objectives

; pause menu will only show the current active objective or the last completed objective
(script static void (f_hud_pause_menu_new_objective_internal (user_interface_objective obj_reference))
	(objectives_menu_clear)
	(objectives_menu_set_string 0 obj_reference)
	(objectives_menu_show_up_to 0)
)

(script static void (f_hud_pause_menu_complete_objective_internal)
	(objectives_menu_finish_up_to 0)
)


; hud objective
;

; used to supress complete popup when new objectives are added and the current objective is complete
(global boolean b_needs_clear_obj_hud_pop false)

; complete the previous objective
(script static void f_hud_obj_complete_current_objective_internal
	; show everything up to the new index as completed, shows as "completed" popup
    (if b_needs_clear_obj_hud_pop
        (begin
			(set b_needs_clear_obj_hud_pop false)
			(objectives_hud_finish_up_to 0)
			(sleep (game_ticks_from_seconds 5)) ; pause execution before showing completed objective if this is not the first objective so the messages don't stack
		)
    )
)

; call the new objective popup menu with the new objective
(script static void (f_hud_obj_show_new_objective_internal (user_interface_objective obj_hud_reference))
	(set b_needs_clear_obj_hud_pop true)
    (objectives_hud_set_string 0 obj_hud_reference)
    (objectives_hud_show_string obj_hud_reference)
)



; =================================================================================================
; chapter titles
; =================================================================================================
(script static void (f_hud_chapter (cutscene_title title))
	(chud_cinematic_fade 0 30)
	(sleep 10)
	(chud_show_screen_chapter_title title)

	(sleep 120)
	(chud_clear_screen_chapter_title)

	(sleep 10)
	(chud_cinematic_fade 1 30)
)

(script static void (f_hud_chapter_slow (cutscene_title title))
	(chud_cinematic_fade 0 30)
	(sleep 10)
	(chud_show_screen_chapter_title title)

	; adding 2s vs the normal version due to the 2 x 1s delays in adding text
	(sleep 180)
	(chud_clear_screen_chapter_title)

	(sleep 10)
	(chud_cinematic_fade 1 30)
)


; =================================================================================================
; flash object
; =================================================================================================
(script static void (f_hud_flash_object_fov (object_name hud_object_highlight))
	(sleep_until
		(or
			(objects_can_see_object player0 hud_object_highlight 25)
			(objects_can_see_object player1 hud_object_highlight 25)
			(objects_can_see_object player2 hud_object_highlight 25)
			(objects_can_see_object player3 hud_object_highlight 25)
		)
	1)
	(object_create hud_object_highlight)
	(set chud_debug_highlight_object_color_red 1)
	(set chud_debug_highlight_object_color_green 1)
	(set chud_debug_highlight_object_color_blue 0)
	(f_hud_flash_single hud_object_highlight)
	(f_hud_flash_single hud_object_highlight)
	(f_hud_flash_single hud_object_highlight)
	(object_destroy hud_object_highlight)
)

(script static void (f_hud_flash_object (object_name hud_object_highlight))
	(object_create hud_object_highlight)
	(set chud_debug_highlight_object_color_red 1)
	(set chud_debug_highlight_object_color_green 1)
	(set chud_debug_highlight_object_color_blue 0)
	(f_hud_flash_single hud_object_highlight)
	(f_hud_flash_single hud_object_highlight)
	(f_hud_flash_single hud_object_highlight)
	(object_destroy hud_object_highlight)
)

(script static void (f_hud_flash_single (object_name hud_object_highlight))
	(object_hide hud_object_highlight false)
	(set chud_debug_highlight_object hud_object_highlight)
	;(sound_impulse_start sound\game_sfx\ui\transition_beeps none 1)
	(sleep 4)
	(object_hide hud_object_highlight true)
	(sleep 5)
)

(script static void (f_hud_flash_single_nodestroy (object_name hud_object_highlight))
	(set chud_debug_highlight_object hud_object_highlight)
	;(sound_impulse_start sound\game_sfx\ui\transition_beeps none 1)
	(sleep 4)
	(set chud_debug_highlight_object none)
	(sleep 5)
)



; =================================================================================================
; temp
; =================================================================================================
(global sound sfx_blip "sound\game_sfx\ui\transition_beeps")
(global object_list l_blip_list (players))
(global boolean b_blip_list_locked false)
(global short s_blip_list_index 0)

; =================================================================================================
; low-level blip functions -- do not call directly!
(script static void (f_blip_internal (object obj) (short icon_disappear_time) (short final_delay))
	(chud_track_object obj true)
	(sound_impulse_start sfx_blip none 1)
	(sleep icon_disappear_time)
	(chud_track_object obj false)
	(sleep final_delay)
)

(script static void (f_blip_flag_internal (cutscene_flag f) (short icon_disappear_time) (short final_delay))
	(chud_track_flag f true)
	(sound_impulse_start sfx_blip none 1)
	(sleep icon_disappear_time)
	(chud_track_flag f false)
	(sleep final_delay)
)

; -------------------------------------------------------------------------------------------------
; blips
; -------------------------------------------------------------------------------------------------
;*
0. objective
1. enemies
2. recon
3. neutralize
4. interface
5. hostile
6. recover
*;

(global short blip_objective 			0)
(global short blip_enemies	 			1)
(global short blip_recon 				2)
(global short blip_neutralize 			3)
(global short blip_interface 			4)
(global short blip_hostile 				5)
(global short blip_recover 				6)

;these globals are legacy, keeping them for backwards compatibility
(global short blip_default 				0)
(global short blip_ordnance 			0)


; blip a cinematic flag temporarily
(script static void (f_blip_flag (cutscene_flag f) (short type))
	(chud_track_flag_with_priority f type))

; breadcrumbs version to blip a cinematic flag temporarily
(script static void (f_bcs_blip_flag (cutscene_flag f) (short type))
	(chud_breadcrumbs_track_flag_with_priority f type))

; blip a cinenamtic flag forever
(script static void (f_blip_flag_forever (cutscene_flag f))
	(print "f_blip_flag_forever is going away. please use f_blip_flag")
	(f_blip_flag f blip_neutralize))

; unblip a cinematic flag
(script static void (f_unblip_flag (cutscene_flag f))
	(chud_track_flag f false))

; breadcrumbs version to unblip a cinematic flag
(script static void (f_bcs_unblip_flag (cutscene_flag f))
	(chud_breadcrumbs_track_flag f false))

; blip an object temporarily
(script static void (f_blip_object (object obj) (short type))
	(chud_track_object_with_priority obj type))

; blip ai vehicles (single or multiple)
(script static void (f_blip_ai_vehicles (ai group) (short blip_type))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_blip_object (ai_vehicle_get (object_get_ai (list_get l_blip_list s_blip_list_index))) blip_type))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

(script static void (f_blip_ai_vehicles_labelled (ai group) (short blip_type) (string_id name))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(chud_track_object_with_priority (ai_vehicle_get (object_get_ai (list_get l_blip_list s_blip_list_index))) blip_type name))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

; breadcrumbs version to blip an object temporarily
(script static void (f_bcs_blip_object (object obj) (short type))
	(chud_breadcrumbs_track_object_with_priority obj type))

; breadcrumbs version to blip a position temporarily
(script static void (f_bcs_blip_position (real x) (real y) (real z) (string name) (short type))
	(chud_breadcrumbs_track_position_with_priority x y z name type true))

	; blip an object temporarily
(script static void (f_blip_object_offset (object obj) (short type) (short offset))
	(chud_track_object_with_priority obj type)
	(chud_track_object_set_vertical_offset obj offset))

(script static void (f_bcs_blip_object_offset (object obj) (short type) (short offset))
	(chud_breadcrumbs_track_object_with_priority obj type)
	(chud_breadcrumbs_track_object_set_vertical_offset obj offset))

; blip an object until you say so
(script static void (f_blip_object_forever (object obj))
	(print "f_blip_object_forever is going away. please use f_blip_object")
	(chud_track_object obj true))

; turn off a blip on an object that was blipped forever
(script static void (f_unblip_object (object obj))
	(chud_track_object obj false))

(script static void (f_unblip_ai_vehicles (ai group))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_unblip_object (ai_vehicle_get (object_get_ai (list_get l_blip_list s_blip_list_index)))))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

; breadcrumbs version to turn off a blip on an object that was blipped forever
(script static void (f_bcs_unblip_object (object obj))
	(chud_breadcrumbs_track_object obj false))

; breadcrumbs version to turn off a blip on a position
(script static void (f_bcs_unblip_position (string name))
	(chud_breadcrumbs_track_position_with_priority 0 0 0 name blip_default false))

; put a blip over an object's head until dead
(script static void (f_blip_object_until_dead (object obj))
	(chud_track_object obj true)
	(sleep_until (<= (object_get_health obj) 0))
	(chud_track_object obj false))

; blip ai actors (single or multiple)
; todo: use local list variables when they come online
(script static void (f_blip_ai (ai group) (short blip_type))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_blip_object (list_get l_blip_list s_blip_list_index) blip_type))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

(script static void (f_blip_ai_labelled (ai group) (short blip_type) (string_id name))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(chud_track_object_with_priority (list_get l_blip_list s_blip_list_index) blip_type name))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

; bcs version to blip ai actors (single or multiple)
(script static void (f_bcs_blip_ai (ai group) (short blip_type))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_bcs_blip_object (list_get l_blip_list s_blip_list_index) blip_type))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

; blip ai offset (single or multiple)
; todo: use local list variables when they come online
(script static void (f_blip_ai_offset (ai group) (short blip_type) (short offset))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_blip_object_offset (list_get l_blip_list s_blip_list_index) blip_type offset))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

; blip ai actors forever (single or multiple)
; todo: use local list variables when they come online
(script static void (f_blip_ai_forever (ai group))
	(print "f_blip_ai_forever is going away. please use f_blip_ai")
	(f_blip_ai group 0)
)

; put a blip over someone's head until dead
(script static void (f_blip_ai_until_dead (ai char))
	(print "f_blip_ai_until_dead will be rolled into the new f_blip_ai command. consider using that instead.")
	(f_blip_ai_forever char)
	(sleep_until (<= (object_get_health (ai_get_object char)) 0))
	(f_unblip_ai char))

(script static void (f_unblip_ai (ai group))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_unblip_object (list_get l_blip_list s_blip_list_index)))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

(script static void (f_bcs_unblip_ai (ai group))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)
	(set s_blip_list_index 0)

	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_bcs_unblip_object (list_get l_blip_list s_blip_list_index)))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked false)
)

(script static void (f_blip_title (object obj) (string_id title))
	(chud_track_object_with_priority obj 6 title)
	(sleep 120)
	(chud_track_object obj false)
)

(script static void (f_bcs_blip_title (object obj) (string_id title))
	(chud_breadcrumbs_track_object_with_priority obj 6 title)
	(sleep 120)
	(chud_breadcrumbs_track_object obj false)
)

;(f_blip_weapon w_plasma_launcher_01 2 5)
(script static void (f_blip_weapon (object gun) (short dist) (short dist2))
	(sleep_until
		(or
			(and (<= (objects_distance_to_object player0 gun) dist) (>= (objects_distance_to_object player0 gun) .1))
			(and (<= (objects_distance_to_object player1 gun) dist) (>= (objects_distance_to_object player1 gun) .1))
			(and (<= (objects_distance_to_object player2 gun) dist) (>= (objects_distance_to_object player2 gun) .1))
			(and (<= (objects_distance_to_object player3 gun) dist) (>= (objects_distance_to_object player3 gun) .1))
		)
	1)
	(print "blip on")
	(f_blip_object gun blip_ordnance)
	(sleep_until
		(or
			(not (object_get_at_rest gun))
			 (and
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 )
		)
	1)
	(print "blip off")
	(f_unblip_object gun)
)

(script static void (f_bcs_blip_weapon (object gun) (short dist) (short dist2))
	(sleep_until
		(or
			(and (<= (objects_distance_to_object player0 gun) dist) (>= (objects_distance_to_object player0 gun) .1))
			(and (<= (objects_distance_to_object player1 gun) dist) (>= (objects_distance_to_object player1 gun) .1))
			(and (<= (objects_distance_to_object player2 gun) dist) (>= (objects_distance_to_object player2 gun) .1))
			(and (<= (objects_distance_to_object player3 gun) dist) (>= (objects_distance_to_object player3 gun) .1))
		)
	1)
	(print "blip on")
	(f_bcs_blip_object gun blip_ordnance)
	(sleep_until
		(or
			(not (object_get_at_rest gun))
			 (and
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 )
		)
	1)
	(print "blip off")
	(f_bcs_unblip_object gun)
)

; =================================================================================================
; spartan waypoint scripts
; =================================================================================================
(script static void (f_hud_spartan_waypoint (ai spartan) (string_id spartan_hud) (short max_dist))
	(sleep_until
		(begin
			(cond
				((< (objects_distance_to_object (ai_get_object spartan) player0) .95)
					(begin
						(chud_track_object spartan false)
						(sleep 60)
					)
				)

				((> (objects_distance_to_object (ai_get_object spartan) player0) max_dist)
					(begin
						(chud_track_object spartan false)
						(sleep 60)
					)
				)

				((< (objects_distance_to_object (ai_get_object spartan) player0) 3)
					(begin
						(chud_track_object_with_priority spartan 22 spartan_hud)
						(sleep 60)
					)
				)

				((objects_can_see_object player0 (ai_get_object spartan) 10)
					(begin
						(chud_track_object_with_priority spartan 22 spartan_hud)
						(sleep 60)
					)
				)

				(true
					(begin
						(chud_track_object_with_priority spartan 5 "")
						;(sleep 30)
					)
				)
			)
		0)
	30)

)

; =================================================================================================
; hero waypoint scripts
; =================================================================================================

(global short hero_default_max_dist 20)

(script static void (f_hud_hero_waypoint (ai hero) (string_id hero_string) (short max_dist))
	(sleep_until
		(begin
			(cond
				((< (objects_distance_to_object (ai_get_object hero) player0) .95)
					(begin
						(chud_track_object hero false)
						(sleep (game_ticks_from_seconds 2))
					)
				)

				((> (objects_distance_to_object (ai_get_object hero) player0) max_dist)
					(begin
						(chud_track_object hero false)
						(sleep (game_ticks_from_seconds 2))
					)
				)

				((< (objects_distance_to_object (ai_get_object hero) player0) 3)
					(begin
						(chud_track_object_with_priority hero 2 hero_string)
						(sleep (game_ticks_from_seconds 2))
					)
				)

				((objects_can_see_object player0 (ai_get_object hero) 10)
					(begin
						(chud_track_object_with_priority hero 2 hero_string)
						(sleep (game_ticks_from_seconds 2))
					)
				)

				(true
					(begin
						(chud_track_object_with_priority hero 2 "")
						;(sleep (game_ticks_from_seconds 1))
					)
				)
			)
		0)
	30)

)

; =================================================================================================
; callout scripts
; =================================================================================================
(script static void (f_callout_atom (object obj) (short type) (short time) (short postdelay))
	(chud_track_object_with_priority obj type)
	(sound_impulse_start sfx_blip none 1)
	(sleep time)
	(chud_track_object obj false)
	(sleep postdelay)
)

(script static void (f_callout_flag_atom (cutscene_flag f) (short type) (short time) (short postdelay))
	(chud_track_flag_with_priority f type)
	(sound_impulse_start sfx_blip none 1)
	(sleep time)
	(chud_track_flag f false)
	(sleep postdelay)
)

(script static void (f_callout_object (object obj) (short type))
	;(f_callout_atom obj type 10 2)
	;(f_callout_atom obj type 10 2)
	;(f_callout_atom obj type 10 2)
	(f_callout_atom obj type 120 2)
)

(script static void (f_callout_object_fast (object obj) (short type))
	;(f_callout_atom obj type 2 2)
	;(f_callout_atom obj type 2 2)
	(f_callout_atom obj type 20 5)
)

(script static void (f_callout_ai (ai actors) (short type))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)

	(set l_blip_list (ai_actors actors))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_callout_object (list_get l_blip_list s_blip_list_index) type))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set s_blip_list_index 0)
	(set b_blip_list_locked false)
)

(script static void (f_callout_ai_fast (ai actors) (short type))
	(sleep_until (= b_blip_list_locked false) 1)
	(set b_blip_list_locked true)

	(set l_blip_list (ai_actors actors))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_callout_object_fast (list_get l_blip_list s_blip_list_index) type))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set s_blip_list_index 0)
	(set b_blip_list_locked false)
)


(script static void (f_callout_and_hold_flag (cutscene_flag f) (short type))
	;(f_callout_flag_atom f type 2 2)
	;(f_callout_flag_atom f type 2 2)
	(chud_track_flag_with_priority f type)
	(sound_impulse_start sfx_blip none 1)
	(sleep 10)
)

; longswords
; =================================================================================================
; make a longsword device activate.
; device tag: sound\device_machines\040vc_longsword\start
; flyby sound tag: sound\device_machines\040vc_longsword\start
; =================================================================================================
; example: 	(f_ls_flyby my_longsword_device_machine)
;			(sound_impulse_start sound\device_machines\040vc_longsword\start none 1)
; =================================================================================================
;*
(script static void (f_ls_flyby (device d))
	(device_animate_position d 0 0.0 0.0 0.0 true)
	(device_set_position_immediate d 0)
	(device_set_power d 0)
	(sleep 1)
	(device_set_position_track d device:position 0)
	(device_animate_position d 0.5 7.0 0.1 0.1 true))
*;
; carpetbombs
; =================================================================================================
; spawn a trail of bombs across a point set.
; effect tag: fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large
; count: how many points are in the set?
; delay: time (in ticks) between the detonation of each bomb effect
; =================================================================================================
; example: 	(f_ls_carpetbomb pts_030 fx\my_explosion_fx 6 10)
; =================================================================================================
;*
(global short global_s_current_bomb 0)
(script static void (f_ls_carpetbomb (point_reference p) (effect e) (short count) (short delay))
	(set global_s_current_bomb 0)
	(sleep_until
		(begin
			(if b_debug_globals (print "boom..."))
			(effect_new_at_point_set_point e p global_s_current_bomb)
			(set global_s_current_bomb (+ global_s_current_bomb 1))
			(sleep delay)
		(>= global_s_current_bomb count)) 1)
)
*;

; =================================================================================================
; helpers
; =================================================================================================
; macro to see if a squad or group has ever spawned
(script static boolean (f_ai_has_spawned (ai actors))
	(> (ai_spawn_count actors) 0))

; macro to see if a squad or group has ever spawned and has no living members left
(script static boolean (f_ai_is_defeated (ai actors))
	(and
		(> (ai_spawn_count actors) 0)
		(<= (ai_living_count actors) 0)))

; macro to see if a squad or group has ever spawned and has a specified number of living members
(script static boolean (f_ai_is_partially_defeated (ai actors) (short count))
	(and
		(>= (ai_spawn_count actors) count)
		(<= (ai_living_count actors) count)))

; macro to see if a task is empty or not
(script static boolean (f_task_is_empty (ai task))
	(<= (ai_task_count task) 0))

; macro to see if a task has anyone in it
(script static boolean (f_task_has_actors (ai task))
	(> (ai_task_count task) 0))

; macro so we can get ahold of our ai
(script static ai (f_object_get_squad (object ai_obj))
	(ai_get_squad (object_get_ai ai_obj)))

(script static real (f_get_absolute_value (real n))
	(if (< n 0)
		(* n -1)
		n
	)
)

; returns a random point in the given point set
(script static point_reference (f_get_random_point_in_point_set (point_reference point_set))
	(ai_point_set_get_point point_set (random_range 0 (ai_get_point_count point_set)))
)

; =================================================================================================
; debug rendering of pathfinding stuff
; =================================================================================================

(script static void debug_toggle_cookie_cutters
	(if (= debug_instanced_geometry 0)
		(begin
			(set debug_objects_collision_models 0)
			(set debug_objects_physics_models 0)
			(set debug_objects_bounding_spheres 0)
			(set debug_objects_cookie_cutters 1)
			(set debug_objects 1)

			(set debug_instanced_geometry_collision_geometry 0)
			(set debug_instanced_geometry_cookie_cutters 1)
			(set debug_instanced_geometry 1)
		)
		(begin
			(set debug_objects_cookie_cutters 0)
			(set debug_objects 0)

			(set debug_instanced_geometry_cookie_cutters 0)
			(set debug_instanced_geometry 0)
		)
	)
)

(script static void debug_toggle_pathfinding_collisions
	(if (= collision_debug 0)
		(begin
			(set collision_debug 1)
			(set collision_debug_flag_ignore_invisible_surfaces 0)
		)
		(begin
			(set collision_debug 0)
			(set collision_debug_flag_ignore_invisible_surfaces 1)
		)
	)
)

; =================================================================================================
; thespian scripts
; =================================================================================================

(script static void f_branch_empty01
	(print "branch exit")
)

(script static void f_branch_empty02
	(print "branch exit")
)

(script static void f_branch_empty03
	(print "branch exit")
)

; =================================================================================================
; insertion scripts
; =================================================================================================

(script static boolean (f_insertion_point_script_is_blocked (insertion_point target_point))
	(>= (game_insertion_point_get) target_point)
)

(script static boolean (f_insertion_point_matches (insertion_point target_point))
	(= (game_insertion_point_get) target_point)
)

(script static boolean (f_insertion_point_area_pending (insertion_point target_point))
	(<= (game_insertion_point_get) target_point)
)

(script static void f_editor_wait_for_player
	; make editor + insertion points a little more pleasant
	(if
		(and
			(editor_mode)
			(= (player_count) 0)
		)
		(begin
			(print "editor waiting for player...")
			(sleep_until (> (player_count) 0) 1)
			(print "editor player found!")
			; set skew once
			(set l_game_tick_editor_skew (game_tick_get))
		)
	)
)

; let editor masquerade as having gameplay started at a normal tick, to still get good representative downstream measurements
(global long l_game_tick_editor_skew 0)

(script static long game_tick_get_editor_adjusted
	(- (game_tick_get) l_game_tick_editor_skew)
)

(script static void f_game_wait_for_player_start
	(if
		(not (game_all_players_active))
		(sleep_until (game_all_players_active) 1)
	)
)

(script static void (f_switch_zone_set_blocking (zone_set zone_set))
	; switch to correct zone set
	(print "switching zone sets...")
	(switch_zone_set zone_set)
	(if
		(= (current_zone_set_fully_active) -1)
		(sleep_until (!= (current_zone_set_fully_active) -1) 1)
	)
)

(script static void (f_place_ai_and_teleport (ai spawn_ai) (cutscene_flag teleport_to))
	(if (= (list_count (ai_actors spawn_ai)) 0) ; does ai already exist?
		(ai_place spawn_ai)
	)
	(if (>= (list_count_not_dead (ai_actors spawn_ai)) 1) ; is ai alive?
		(object_teleport spawn_ai teleport_to)
	)
)

(script static void (f_place_ai_loop_no_timeout (ai ai_to_spawn) (short seconds_between_spawn))
    (sleep_until
        (begin
            (ai_place ai_to_spawn)
            (sleep (* 30 seconds_between_spawn))
            false
        )
    1)
)

; =================================================================================================
; rally point unlocks
; =================================================================================================

; the old game_insertion_point_unlock is not used in stiched engine land.
; instead, "incidents" are submitted through blam via 'submit_incident'.
; the incident is mapped to a (unreal) gameplay tag, which unlocks the associated insertion point.
;
; define an incident names for each player-facing insertion point point in:
; /game/tags/globals/incident/mission_progression-incident_globals_definition.mission_progression-incident_globals_definition
;
; then, define a gameplay tag for each insertion point in:
; /game/datatables/dt_missionprogressiongameplaytags.dt_missionprogressiongameplaytags
;
; then, map the incident name to the gameplay tag in:
; /game/blueprints/da_blamprogress.da_blamprogress
;
; and finally, associate the gameplay tag to the insertion point in the data asset that defines insertion points.
; example: /game/levels/halo1/solo/b40/da_b40_insertionpoints.da_b40_insertionpoints
;
; after that, mission scripts may unlock the insertion point by submitting the incident with the correct name.
; this helper mostly exists to link back to this documentation and provide a single place for future updates
(script static void (f_unlock_insertion_point_with_incident_name (string_id incident_name))
	(submit_incident incident_name)
)

; =================================================================================================
; devices
; =================================================================================================

; logic to move a device between pos 0 and 1 based on a player trigger, useful for lifts
; prevents moving back to pos 0 after device pos reaches point of no return
(script static void (f_device_pendulum_logic (device device) (trigger_volume advance_trigger) (trigger_volume return_trigger) (real point_of_no_return))
	(sleep_until
		(begin
			(cond
				; if one player is in the advance_trigger we will advance
				((f_exclusive_player_triggers return_trigger advance_trigger) (device_set_position device 0)) ; return
				((volume_test_players advance_trigger) (device_set_position device 1)) ; advance
			)
			(>= (device_get_position device) point_of_no_return) ; finish movement
		)
		1
	)
)

(script static boolean (f_exclusive_player_triggers (trigger_volume include_volume) (trigger_volume exclude_volume))
	(and
		(volume_test_players include_volume)
		(not (volume_test_players exclude_volume))
	)
)
