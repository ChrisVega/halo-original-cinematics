(global boolean debug true)

(script static void a50_insertion_point_fixups
	; uncommon one-off insertion point fixups, standard shared mission flow should handle everything else
	(cond
		((f_insertion_point_matches insertion_area1) (fixup_ins_area1))
		((f_insertion_point_matches insertion_area3) (fixup_ins_area3))
		((f_insertion_point_matches insertion_area4) (fixup_ins_area4))
		((f_insertion_point_matches insertion_area5) (fixup_ins_area5))
		((f_insertion_point_matches insertion_gravity_room) (fixup_ins_gravity_room))
		((f_insertion_point_matches insertion_grav_mus_hall) (fixup_ins_grav_mus_hall))
		((f_insertion_point_matches insertion_hangar) (fixup_ins_hangar))
		((f_insertion_point_matches insertion_control) (fixup_ins_control))
		((f_insertion_point_matches insertion_prison) (fixup_ins_prison))
		((f_insertion_point_matches insertion_control_revisited) (fixup_ins_control_revisited))
		((f_insertion_point_matches insertion_hangar_revisited) (fixup_ins_hangar_revisited))
	)
)

; area 1 - rally point alpha
(script static void fixup_ins_area1
	(f_switch_zone_set_blocking set_landing)
	(a50_initial_profiles blam_profile_start_level blam_profile_respawn_sniper)
	(f_cinematic_handle_intro_snap cinematics\a50\a50_intro.cinematic)

	(prep_fireteam fireteam_area1_johnson fireteam_area1_marines fireteam_area1_fill false)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")
)

; area 2
; (script static void fixup_ins_area2
; 	(print_if debug "ins_area2")
; 	(f_switch_zone_set_blocking set_landing)
; )

; area 3
(script static void fixup_ins_area3
	(f_switch_zone_set_blocking set_landing)
	(a50_initial_profiles blam_profile_start_level blam_profile_respawn_sniper)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_area3_johnson fireteam_area3_marines fireteam_area3_fill true)

	(print_if debug "insertion objective | fight your way to the covenant battlecruiser")
	(f_hud_obj_new "obj_a50_board" "obj_a50_board")

	(print_if debug "fireteam | flashlights enabled at insertion")
	(f_ai_set_integrated_flashlight ai_player_fireteam true)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")
)

; area 4
(script static void fixup_ins_area4
	(f_switch_zone_set_blocking set_lift_approach)
	(a50_initial_profiles blam_profile_start_level blam_profile_respawn_sniper)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_area4_johnson fireteam_area4_marines fireteam_area4_fill true)

	(print_if debug "insertion objective | fight your way to the covenant battlecruiser")
	(f_hud_obj_new "obj_a50_board" "obj_a50_board")

	(print_if debug "fireteam | flashlights enabled at insertion")
	(f_ai_set_integrated_flashlight ai_player_fireteam true)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")
)

; area 5
(script static void fixup_ins_area5
	(f_switch_zone_set_blocking set_lift_bottom)
	(a50_initial_profiles blam_profile_start_level blam_profile_respawn_sniper)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_area5_johnson fireteam_area5_marines fireteam_area5_fill true)

	(print_if debug "insertion objective | fight your way to the covenant battlecruiser")
	(f_hud_obj_new "obj_a50_board" "obj_a50_board")

	(print_if debug "fireteam | flashlights enabled at insertion")
	(f_ai_set_integrated_flashlight ai_player_fireteam true)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")
)

; gravity room - rally point bravo
(script static void fixup_ins_gravity_room
	(f_switch_zone_set_blocking set_lift_top)
	(a50_initial_profiles blam_profile_grav_room blam_profile_respawn_interior)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_gravity_room_johnson fireteam_gravity_room_marines fireteam_gravity_room_fill true)

	(object_destroy gravity_lift_a_to_ground)

	(print_if debug "insertion objective | locate the ship's brig")
	(f_hud_obj_new "obj_a50_rescue" "obj_a50_rescue")

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")

	(print_if debug "rally point | a50 - unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_a50_gravity_room")
)

; gravity muster hall
(script static void fixup_ins_grav_mus_hall
	(f_switch_zone_set_blocking set_lift_top)
	(a50_initial_profiles blam_profile_grav_room blam_profile_respawn_interior)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_grav_mus_hall_johnson fireteam_grav_mus_hall_marines fireteam_grav_mus_hall_fill true)

	(print_if debug "insertion objective | locate the ship's brig")
	(f_hud_obj_new "obj_a50_rescue" "obj_a50_rescue")

	; unlock doors and open them so the player can back track to marines
	(device_set_power gravity_bay_door 1)
	(device_set_position gravity_bay_door 1)

	(device_one_sided_set gravity_door_lf false)
	(device_one_sided_set gravity_door_lr false)

	(device_set_power grav_mus_hall_door 1)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")

	(print_if debug "rally point | a50 - unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_a50_gravity_room")
)

; muster bay
; (script static void fixup_ins_muster_bay
; 	(print_if debug "ins_muster_bay")
; 	(f_switch_zone_set_blocking set_muster)
; )

; hangar
(script static void fixup_ins_hangar
	(f_switch_zone_set_blocking set_hangar)
	(a50_initial_profiles blam_profile_grav_room blam_profile_respawn_interior)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_hangar_johnson fireteam_hangar_marines fireteam_hangar_fill true)

	(print_if debug "insertion objective | locate the ship's brig")
	(f_hud_obj_new "obj_a50_rescue" "obj_a50_rescue")

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")

	(print_if debug "rally point | a50 - unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_a50_gravity_room")

	(f_hangar_point_of_no_return_clean_up)
)

; control - rally point charlie
(script static void fixup_ins_control
	(f_switch_zone_set_blocking set_hangar_detention)
	(a50_initial_profiles blam_profile_control blam_profile_respawn_interior)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_control_johnson fireteam_control_marines fireteam_control_fill true)

	(print_if debug "insertion objective | locate the ship's brig")
	(f_hud_obj_new "obj_a50_rescue" "obj_a50_rescue")

	; open the hangar door for players that fall
	(f_open_hangar_exit)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")

	(print_if debug "rally point | a50 - unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_a50_gravity_room")

	(print_if debug "rally point | a50 - unlocking rally point charlie")
	(f_unlock_insertion_point_with_incident_name "ins_a50_control")

	(f_hangar_point_of_no_return_clean_up)
)

; prison
(script static void fixup_ins_prison
	(f_switch_zone_set_blocking set_hangar_detention)
	(a50_initial_profiles blam_profile_control blam_profile_respawn_interior)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_prison_johnson fireteam_prison_marines fireteam_prison_fill true)

	(print_if debug "insertion objective | rescue captain keyes from the ship's brig")
	(f_hud_obj_new "obj_a50_rescuekeyes" "obj_a50_rescuekeyes")

	; open the hangar door for players that fall
	(f_open_hangar_exit)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")

	(print_if debug "rally point | a50 - unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_a50_gravity_room")

	(print_if debug "rally point | a50 - unlocking rally point charlie")
	(f_unlock_insertion_point_with_incident_name "ins_a50_control")

	(f_hangar_point_of_no_return_clean_up)
)

; control revisited
(script static void fixup_ins_control_revisited
	(f_switch_zone_set_blocking set_hangar_detention)
	(a50_initial_profiles blam_profile_control blam_profile_respawn_interior)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_control_2_johnson fireteam_control_2_marines fireteam_control_2_fill true)

	(print_if debug "insertion objective | return to the ship's hangar")
	(f_hud_obj_new "obj_a50_escape" "obj_a50_escape")

	; open the hangar door for players that fall
	(f_open_hangar_exit)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")

	(print_if debug "rally point | a50 - unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_a50_gravity_room")

	(print_if debug "rally point | a50 - unlocking rally point charlie")
	(f_unlock_insertion_point_with_incident_name "ins_a50_control")

	(f_hangar_point_of_no_return_clean_up)
)

; hangar revisited
(script static void fixup_ins_hangar_revisited
	(f_switch_zone_set_blocking set_hangar_detention)
	(a50_initial_profiles blam_profile_control blam_profile_respawn_interior)
	(f_insertion_fade_to_gameplay)

	(prep_fireteam fireteam_hangar_2_johnson fireteam_hangar_2_marines fireteam_hangar_2_fill true)

	(print_if debug "insertion objective | return to the ship's hangar")
	(f_hud_obj_new "obj_a50_escape" "obj_a50_escape")

	; open the hangar door for players that fall
	(f_open_hangar_exit)

	;_____rally points_____
	(print_if debug "rally point | a50 - unlocking level a50: truth and reconciliation")
	(f_unlock_insertion_point_with_incident_name "unlock_a50")

	(print_if debug "rally point | a50 - unlocking rally point alpha")
	(f_unlock_insertion_point_with_incident_name "ins_a50_area1")

	(print_if debug "rally point | a50 - unlocking rally point bravo")
	(f_unlock_insertion_point_with_incident_name "ins_a50_gravity_room")

	(print_if debug "rally point | a50 - unlocking rally point charlie")
	(f_unlock_insertion_point_with_incident_name "ins_a50_control")

	(f_hangar_point_of_no_return_clean_up)
)

(script static void (prep_fireteam (ai johnson)(ai marines)(ai fill) (boolean b_spawn_ai))

	(if b_spawn_ai
		(begin
			(ai_place johnson)
			(ai_place marines)
			(ai_place fill)
		)
	)

	(ai_player_set_fireteam_no_max player0)

	(set ai_fireteam_johnson johnson)
	(set ai_fireteam_marines marines)
	(set ai_fireteam_fill fill)
	(set ai_player_fireteam fireteams_all)
)

(script static void (a50_initial_profiles
						(starting_profile start)
						(starting_profile respawn)
					)
	(player_set_profile start)
	; respawn profile in new thread
	(set sp_a50_respawn_async respawn)
	(wake a50_initial_profiles_async)
)

(global starting_profile sp_a50_respawn_async blam_profile_start_level)
(script dormant a50_initial_profiles_async
	; wait
	(f_editor_wait_for_player)
	(f_game_wait_for_player_start)
	; set
	(player_set_profile sp_a50_respawn_async)
)

; close and power off the backtrack door then destroy some crates we can't see anymore
(script static void f_hangar_point_of_no_return_clean_up
	(device_set_position_immediate hangar_first_floor_backtrack_door 0)
	(device_set_power hangar_first_floor_backtrack_door 0)

	(object_destroy_folder muster_hangar_hall_crates)
)