;====================================================================================================================================================================================================
; globals =============================================================
;====================================================================================================================================================================================================

(global boolean b_glift_a_top false)
(global boolean b_glift_a_reset false)
(global boolean b_glift_b_bottom false)
(global short s_cur_beat 1)

;====================================================================================================================================================================================================
; mission startup scripts =====================================================================================================================================================================================
;====================================================================================================================================================================================================

(script startup mission_3_start
	(submit_incident_with_custom_string_id "game_activity_begin" "e30")
	(ai_allegiance player human)
	(ai_allegiance human player)
	(e30_insertion_point_fixups)
	(f_start_auto_save_loop)

	(ai_prefer_target (players) true)
	;nav
	(wake nav_backtracking_loop)

	(ai_prefer_target_team gr_transit_encounters player)

	(wake transit_soft_kill_volume_setup)

	;garden b shields
	(object_destroy sc_cov_port_shield_g2_1)
	(object_destroy sc_cov_port_shield_g2_2)

	;music
	(wake e30_music_controller)
)

;============================================================================
; flow control scripts ======================================================
;============================================================================
(script dormant control_gravlift_to_down
	(object_destroy gravitylift_a_up)
	(object_create gravitylift_a_down)
)

;============================================================================
; objectives scripts ========================================================
;============================================================================

;beat 1
(script static void mission_obj_to_bridge
	(print "objective: head for the tolerance's bridge and retrieve the nav data from its starholo")
	(f_hud_obj_new "obj_e30_bridge" "obj_e30_bridge")
)

(script dormant mission_obj_starholo
	(print "objective: download the starholo data")
	(f_hud_obj_new "obj_starholo_data" "obj_starholo_data")
)

;beat 2
(script dormant mission_obj_docking_bay
	(print "objective: head to the hangar to regroup with williams and unsc survivors")
	(f_hud_obj_new "obj_docking_bay" "obj_docking_bay")
)

(script dormant mission_obj_docking_bay_repeat_1
	(print "objective: head to the hangar to regroup with williams and unsc survivors")
	(f_hud_obj_new_no_hud_completion "obj_docking_bay" "obj_docking_bay")
)

(script dormant mission_obj_docking_bay_repeat_2
	(print "objective: head to the hangar to regroup with williams and unsc survivors")
	(f_hud_obj_new_no_hud_completion "obj_docking_bay" "obj_docking_bay")
)

;beat 3
(script static void mission_obj_power_transit
	(print "objective: power up the transit platform")
	(f_hud_obj_new_no_hud_completion "obj_powertransit" "obj_powertransit")
)

(script dormant mission_obj_eliminate
	(print "objective: eliminate hostiles around the platform and continue through the ship")
	(f_hud_obj_new "obj_eliminate" "obj_eliminate")
)

(script static void mission_obj_dome_power
	(print "objective: restore power to the transit station")
	(f_hud_obj_new_no_hud_completion "obj_restorepower" "obj_restorepower")
)

(script static void mission_obj_regroup_williams
	(print "objective: regroup with williams and unsc survivors")
	(f_hud_obj_new_no_hud_completion "obj_regroup1" "obj_regroup1")
)

;beat 4

;space 1
(script dormant mission_obj_regroup_johnson
	(print "objective: regroup with johnson 1")
	(f_hud_obj_new_no_hud_completion "obj_regroup_johnson" "obj_regroup_johnson")
)

(script dormant mission_obj_buy_time
	(print "objective: destroy enemy fighters to buy time for williams")
	(f_hud_obj_new_no_hud_completion "obj_spacestart" "obj_spacestart")
)

(script dormant relay_objective_control
	(mission_obj_destroy_turrets)
	;check or any turret squad to be destroyed
	(if
		(coop_players_3);three or more players
		;then check for all relays turrets squads
		(sleep_until
			(or
				(<= (ai_living_count sq_relay1_aa) 0)
				(<= (ai_living_count sq_relay2_aa) 0)
				(<= (ai_living_count sq_relay3_aa) 0)
				(<= (ai_living_count sq_relay4_aa) 0)
				(<= (ai_living_count sq_relay5_aa_diff_coop) 0)
				(<= (ai_living_count sq_relay6_aa_diff_coop) 0)
			)
			1
		)
		;else check for only the top relay turret squads
		(sleep_until
			(or
				(<= (ai_living_count sq_relay1_aa) 0)
				(<= (ai_living_count sq_relay2_aa) 0)
				(<= (ai_living_count sq_relay3_aa) 0)
				(<= (ai_living_count sq_relay4_aa) 0)
			)
			1
		)
	)

	(if
		;2 or more players or heroic/legendary
		(or
			(coop_players_2)
			(difficulty_heroic)
			(difficulty_legendary)
		)
		;then normal style objective for coop or heroic/legendary
		(mission_obj_relay_coop)
		;else incremental object updates for solo normal and easy
		(begin
			(mission_obj_relay_zero)

			(sleep_until (>= s_relays_destroyed 1) 1)
			(mission_obj_relay_one)

			(sleep_until (>= s_relays_destroyed 2) 1)
			(mission_obj_relay_two)

			(sleep_until (>= s_relays_destroyed 3) 1)
			(mission_obj_relay_three)

			(sleep_until (>= s_relays_destroyed 4) 1)
			(mission_obj_relay_all)
		)
	)

)

(script static void mission_obj_destroy_turrets
	(print "objective: destroy turrets to open relay node")
	(f_hud_obj_new_no_hud_completion "obj_destroy_turret" "obj_destroy_turret")
)

(script static void mission_obj_relay_zero
	(print "objective: destroy external relay nodes 0/4")
	(f_hud_obj_new_no_hud_completion "obj_relay_nodes" "obj_relay_nodes")
)

(script static void mission_obj_relay_one
	(print "objective: destroy external relay nodes 1/4")
	;(f_hud_obj_new_no_hud_completion "obj_relay_nodes2" "obj_relay_nodes2")
	(f_hud_obj_advance  "obj_relay_nodes2" true)
)

(script static void mission_obj_relay_two
	(print "objective: destroy external relay nodes 2/4")
	;(f_hud_obj_new_no_hud_completion "obj_relay_nodes3" "obj_relay_nodes3")
	(f_hud_obj_advance  "obj_relay_nodes3" true)
)

(script static void mission_obj_relay_three
	(print "objective: destroy external relay nodes 3/4")
	;(f_hud_obj_new_no_hud_completion "obj_relay_nodes4" "obj_relay_nodes4")
	(f_hud_obj_advance  "obj_relay_nodes4" true)
)

(script static void mission_obj_relay_all
	(print "objective: destroy external relay nodes 4/4")
	;(f_hud_obj_new_no_hud_completion "obj_relay_nodes5" "obj_relay_nodes5")
	(f_hud_obj_advance  "obj_relay_nodes5" false)
)

(script static void mission_obj_relay_coop
	(print "objective: destroy external relay nodes")
	(f_hud_obj_new_no_hud_completion "obj_relay_nodescoop" "obj_relay_nodescoop")
)

(script dormant mission_obj_debris_field
	(print "objective: follow johnson's seraph through debris field")
	(f_hud_obj_new "obj_regroup_johnson2" "obj_regroup_johnson2")
)

;space 2
(script dormant mission_obj_survive
	(print "objective: survive until reinforcements arrive")
	(f_hud_obj_new_no_hud_completion "obj_space_survive" "obj_space_survive")
)

(script dormant mission_obj_protect_marines
	(print "objective: protect the marines")
	(f_hud_obj_new_no_hud_completion "obj_marines_protect" "obj_marines_protect")
)

;space 3
(script static void mission_obj_burden_protect
	(print "objective: protect the burden of proof from covenant fighters")
	(f_hud_obj_new_no_hud_completion "obj_burden_protect" "obj_burden_protect")
)

(script dormant kamikaze_objective_control
	(if
		;2 or more players or heroic/legendary
		(or
			(coop_players_2)
			(difficulty_heroic)
			(difficulty_legendary)
		)
		;then normal style objective for coop
		(begin
			;first wave
			(mission_obj_kamikaze_coop)
			;second wave
			(sleep_until (= b_kamikaze_wave_2_spawned 1) 1)
			(mission_obj_kamikaze_coop)
		)
		;else
		(begin
			(mission_obj_kamikaze_zero)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 1) 1)
			(mission_obj_kamikaze_one)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 2) 1)
			(mission_obj_kamikaze_two)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 3) 1)
			(mission_obj_kamikaze_three)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 4) 1)
			(mission_obj_kamikaze_four)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 5) 1)
			(mission_obj_kamikaze_five)

			;remind player of count as second wave starts
			(sleep_until (= b_kamikaze_wave_2_spawned 1) 1)
			(mission_obj_kamikaze_five_reminder)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 6) 1)
			(mission_obj_kamikaze_six)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 7) 1)
			(mission_obj_kamikaze_seven)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 8) 1)
			(mission_obj_kamikaze_eight)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 9) 1)
			(mission_obj_kamikaze_nine)

			(sleep_until (>= (ai_body_count obj_space3_cov/kamikaze_seraphs) 10) 1)
			(mission_obj_kamikaze_all)
		)
	)
)

(script static void mission_obj_kamikaze_zero
	(print "objective: intercept vessels attacking the burden of proof 0/10")
	(f_hud_obj_new_no_hud_completion "obj_intercept1" "obj_intercept1")
)

(script static void mission_obj_kamikaze_one
	(print "objective: intercept vessels attacking the burden of proof 1/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept2" "obj_intercept2")
	(f_hud_obj_advance "obj_intercept2" true)
)

(script static void mission_obj_kamikaze_two
	(print "objective: intercept vessels attacking the burden of proof 2/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept3" "obj_intercept3")
	(f_hud_obj_advance "obj_intercept3" true)
)

(script static void mission_obj_kamikaze_three
	(print "objective: intercept vessels attacking the burden of proof 3/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept4" "obj_intercept4")
	(f_hud_obj_advance "obj_intercept4" true)
)

(script static void mission_obj_kamikaze_four
	(print "objective: intercept vessels attacking the burden of proof 4/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept5" "obj_intercept5")
	(f_hud_obj_advance "obj_intercept5" true)
)

(script static void mission_obj_kamikaze_five
	(print "objective: intercept vessels attacking the burden of proof 5/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept6" "obj_intercept6")
	(f_hud_obj_advance "obj_intercept6" true)
)

(script static void mission_obj_kamikaze_five_reminder
	(print "objective: intercept vessels attacking the burden of proof 5/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept6" "obj_intercept6")
	(f_hud_obj_repeat "obj_intercept6")
)

(script static void mission_obj_kamikaze_six
	(print "objective: intercept vessels attacking the burden of proof 6/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept7" "obj_intercept7")
	(f_hud_obj_advance "obj_intercept7" true)
)

(script static void mission_obj_kamikaze_seven
	(print "objective: intercept vessels attacking the burden of proof 7/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept8" "obj_intercept8")
	(f_hud_obj_advance "obj_intercept8" true)
)

(script static void mission_obj_kamikaze_eight
	(print "objective: intercept vessels attacking the burden of proof 8/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept9" "obj_intercept9")
	(f_hud_obj_advance "obj_intercept9" true)
)

(script static void mission_obj_kamikaze_nine
	(print "objective: intercept vessels attacking the burden of proof 9/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept10" "obj_intercept10")
	(f_hud_obj_advance "obj_intercept10" true)
)

(script static void mission_obj_kamikaze_all
	(print "objective: intercept vessels attacking the burden of proof 10/10")
	;(f_hud_obj_new_no_hud_completion "obj_intercept11" "obj_intercept11")
	(f_hud_obj_advance "obj_intercept11" true)
)

(script static void mission_obj_kamikaze_coop
	(print "objective: intercept vessels attacking the burden of proof")
	(f_hud_obj_new_no_hud_completion "obj_interceptcoop" "obj_interceptcoop")
)

;general space
(script static void mission_obj_regroup_bop
	(print "objective: regroup with burden of proof")
	(f_hud_obj_new "obj_regroup_bop" "obj_regroup_bop")
)

(script dormant mission_obj_regroup_bop_final
	(print "objective: regroup with burden of proof")
	(f_hud_obj_new_no_hud_completion "obj_regroup_bop" "obj_regroup_bop")
)


(script static void mission_obj_regroup_johnson3
	(print "objective: regroup with johnson 3")
	(f_hud_obj_new "obj_regroup_johnson3" "obj_regroup_johnson3")
)

(script static void mission_obj_regroup_johnson4
	(print "objective: regroup with johnson 4")
	(f_hud_obj_new "obj_regroup_johnson4" "obj_regroup_johnson4")
)

(script static void mission_obj_regroup_johnson5
	(print "objective: regroup with johnson 5")
	(f_hud_obj_new "obj_regroup_johnson5" "obj_regroup_johnson5")
)

(script static void (f_hud_obj_advance (user_interface_objective obj_reference) (boolean b_show_hud_finish))
	; pause menu should show how many things are destroyed
	(f_hud_pause_menu_new_objective_internal obj_reference)
	; hud should say how many things are destroyed is completed
	(objectives_hud_clear)
    (objectives_hud_set_string 0 obj_reference)
	(if b_show_hud_finish
		(begin
			(set b_needs_clear_obj_hud_pop false)
			(objectives_hud_finish_up_to 0)
		)
		(set b_needs_clear_obj_hud_pop true)
	)
)

;============================================================================
; chapter scripts ===========================================================
;============================================================================

;beat 1
(script dormant chapter_1
	(sleep_until (volume_test_players tv_chapter_1) 1)

	(print "chapter title 1 - best served cold")
	(f_hud_chapter "chapter_e30_1")

	(mission_obj_to_bridge)
)

;beat 2
(script dormant chapter_2
	(sleep_until (volume_test_players tv_chapter_2) 1)
	(set s_music_trigger_e30 110)
	(f_hud_chapter "chapter_e30_2")
)

;beat 3
(script dormant chapter_3
	(f_hud_chapter "chapter_e30_3")
)

;beat 4


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;______            _     __     _____       _   _           ______      _     _
;| ___ \          | |   /  |   |_   _|     | | | |          | ___ \    (_)   | |
;| |_/ / ___  __ _| |_  `| |     | | ___   | |_| |__   ___  | |_/ /_ __ _  __| | __ _  ___
;| ___ \/ _ \/ _` | __|  | |     | |/ _ \  | __| '_ \ / _ \ | ___ \ '__| |/ _` |/ _` |/ _ \
;| |_/ /  __/ (_| | |_  _| |_    | | (_) | | |_| | | |  __/ | |_/ / |  | | (_| | (_| |  __/
;\____/ \___|\__,_|\__| \___/    \_/\___/   \__|_| |_|\___| \____/|_|  |_|\__,_|\__, |\___|
;                                                                                __/ |
;================================================================================|___/===============================================================================================================
;====================================================================================================================================================================================================

(script dormant begin_beat1
	(print "******* begin_beat1 awoke *******")
	; beat 1 encounter scripts
	(set s_cur_beat 1)
	(wake overview)
	(wake overview_side_hall)
	(wake overview_vista)
	(wake minor_vista_approach)
	(wake minor_vista)
	(wake hydro_entry_hall_1)
	(wake hydro_entry_hall_2)
	(wake hydro_entry)
	(wake garden_1)
	(wake garden_2)
	(wake hydro_bridge)
	(wake control_approach)
	(wake control)
	; beat 1 narrative
	(wake vo_mission_intro)
	(wake music_hydro_entry_trigger)
	(wake music_hydro_exit_trigger)
	(wake vo_garden_hunters)
	(wake vo_control_intro)
	(wake vo_garden_frosty)
	(wake chapter_1)
	; nav
	(wake beat1_nav_loop)
	; flow control
	(device_group_set glift_a_lid glift_a_pg 1) ; remove in future because position group not needed
	(wake point_of_no_return_beat1)
	(wake beat1_johnson_fall_bridge_check)

	;johnson's starting objective
)

(global short obj_con_overview 0) ;used with obj_overview_unsc, obj_overview_vista_unsc, obj_minor_vista_to_entry_unsc

;==============
;encounter 1
;==============

;encounter has cues tied to objectives

(script dormant overview
	(print "******* encounter 1 *******")
	(sleep_until (volume_test_players tv_beat1_e1_act_overview) 1)
	(ai_place gr_beat1_e1_overview)
	(ai_activity_set sq_e1_overview_sleep_g asleep)
	(print "game_save_no_timeout 1")
	(game_save_no_timeout) ;checkpoint

	(print "	obj_con_overview 10")
	(set obj_con_overview 10); player is advancing to encounter 1
)

(script command_script cs_grunt_stare
	(cs_abort_on_alert true) ;end cs if player is spotted
	(cs_abort_on_damage true) ;end cs if grunts are damaged
	(cs_face true ps_beat1_e1_stare/p5)
	(cs_go_to_nearest ps_beat1_e1_stare)
	(cs_pause 40)
)

;==============
;encounter 2
;==============

;encounter has cues tied to objectives

(script dormant overview_side_hall
	(sleep_until (volume_test_players tv_act_overview_sidehall) 1)
	(ai_place gr_beat1_e2_overview_cor)
	(ai_activity_set sq_e2_overview_cor_grunts asleep)

	(sleep_until (volume_test_players tv_player_in_e2) 1)

	(print "	obj_con_overview 20")
	(set obj_con_overview 20); player is advancing to encounter 2

	(sleep_until (volume_test_players tv_act_john_overview_vista) 1)
	;(cs_run_command_script ai_johnson cs_overview_unsc)
	(game_save_no_timeout) ;checkpoint
)

;==============
;encounter 3
;==============

;encounter has cues tied to objectives

(global boolean b_vista_vignette_started 0)
(global boolean b_vista_vignette_jackal_seen 0)
(global boolean b_vista_vignette_elite_seen 0)
(global boolean b_elite_roared 0)
(global boolean b_elite_pointed 0)

(script dormant overview_vista
	(sleep_until (volume_test_players tv_act_overview_vista) 1)
	(ai_place gr_overview_hydro1)
	(ai_activity_set sq_overview_hydro_grunts1 asleep)

	(wake vista_vignette)

	(print "	obj_con_overview 30")
	(set obj_con_overview 30)

	(sleep_until (volume_test_players tv_act_john_overview_vista) 1)

	(ai_set_objective ai_johnson obj_overview_vista_unsc)

	(sleep_until
		(or
			(volume_test_players tv_e3_vista_wave2)
			(<= (ai_living_fraction gr_overview_hydro1) .75)
		)
		1
	)
	(print "spawning wave 2")
	(ai_place gr_overview_hydro2)
	(print "game_save_no_timeout 2")
	(game_save_no_timeout) ;checkpoint
	(wake vo_hydro_vista)

	(sleep_until (= (ai_living_count gr_overview_hydro2) 0) 1)
	(print "game_save_no_timeout 2.5")
	(game_save_no_timeout) ;checkpoint
)

(script command_script cs_smack_elite
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_enable_moving false)
	(cs_aim true ps_e3_elite_smack/p0)
	;(cs_push_stance patrol)
	;(sleep_forever)
	(sleep (game_ticks_from_seconds 60))
)

(script dormant vista_vignette
	(ai_place gr_beat1_vista_vign)
	(ai_activity_set sq_vista_vign_grunts asleep)

	(wake vista_vignette_jackal_check)
	(wake vista_vignette_elite_check)

	(sleep_until
		(or
			(= b_vista_vignette_jackal_seen 1)
			(= b_vista_vignette_elite_seen 1)
		)
		1
	)
	(print "vista vignette - started")
	(set b_vista_vignette_started 1)
)

(script dormant vista_vignette_jackal_check
	(sleep_until
		(or
			(and
				(volume_test_players tv_vista_vign)
				(or
					(objects_can_see_object (players) sq_vista_vign_jackals/jackal0 5)
					(objects_can_see_object (players) sq_vista_vign_jackals/jackal1 5)
					(objects_can_see_object (players) sq_vista_vign_jackals/jackal2 5)
				)
			)
			(= b_elite_roared 1)
		)
		1
	)
	(print "vista vignette - jackals have seen player in the spot")
	(set b_vista_vignette_jackal_seen 1)
)

(script dormant vista_vignette_elite_check
	(sleep_until
			(and
				(volume_test_players tv_vista_vign)
				(objects_can_see_object (players) sq_vista_vign_point_elite 15)
			)
		1
	)
	(print "vista vignette - elite has seen player in the spot")
	(set b_vista_vignette_elite_seen 1)
)

(script command_script cs_vista_vign_spotted_player_jackal
	(cs_action_at_player ai_action_surprise_front)
)

(script command_script cs_vista_vign_spotted_player_elite
	(cs_action_at_player ai_action_berserk)
	(set b_elite_roared 1)
	(print "vista vignette - point elite roared")
	(cs_pause .5)
	(cs_action_at_object dm_beat1_block_door0 ai_action_point)
	(set b_elite_pointed 1)
	(print "vista vignette - point elite pointed")
)

(script command_script cs_vista_vign_spotted_player_hall
	(cs_go_to_nearest ps_vista_vign_elites_patrol)
	(cs_aim_object true sq_vista_vign_point_elite)
	(sleep_until (= b_elite_pointed 1) 1)
	(print "vista vignette - hall elites headed out")
	(cs_aim_object false sq_vista_vign_point_elite)
	(cs_go_to ps_vista_vign_elites_run/p0)
	(ai_erase ai_current_actor)
)

;==============
;encounter 4
;==============

(script dormant minor_vista_approach
	(sleep_until (volume_test_players tv_act_minor_vista_approach) 1)
	(ai_place gr_beat1_e4_overview_grav_cor)
	(ai_set_objective ai_johnson obj_minor_vista_to_entry_unsc)

	(print "	obj_con_overview 40")
	(set obj_con_overview 40)

)

(script command_script cs_e4_ambush
	(cs_abort_on_damage true)
	(cs_aim_player true)
	(sleep_until (volume_test_players tv_e4_ambush) 1)
	(cs_go_to (ai_nearest_point ai_current_actor ps_e4_ambush))
)

;==============
;encounter 5
;==============

;encounter has cues tied to objectives

(script dormant minor_vista
	(sleep_until (volume_test_players tv_act_minor_vista) 1)
	(ai_place gr_beat1_e5_overview_grav_room)

	(sleep_until (volume_test_players tv_act_minor_vista) 1)
	;(cs_run_command_script ai_johnson cs_minor_vista_unsc)
)

(script command_script cs_e5_ambush
	(cs_abort_on_damage true)
	(cs_aim_player true)
	(sleep_until (volume_test_players tv_e4_ambush) 1)
	(sleep (game_ticks_from_seconds 3))
	(cs_go_to ps_e5_ambush/p0)
)

;temp fix to get johnson over the bsp boundary
(script command_script cs_minor_vista_unsc
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_nearest ps_minor_vista_unsc)
	(cs_move_towards_point ps_minor_vista_unsc/p5 .3)
)

;==============
;encounter 6
;==============

(script dormant hydro_entry_hall_1
	(sleep_until (volume_test_players tv_act_hydro_entry_hall_1))
	(print "gr_beat1_e1_to_e2_cleanup clean up")
	(ai_disposable gr_beat1_e1_to_e2_cleanup true)
	(print "gr_beat1_e1_to_e2_cleanup clean up done")
	(ai_place gr_beat1_e6_hydro_entry_cor)
	(print "	obj_con_overview 50")
	(set obj_con_overview 50)

	(sleep_until (volume_test_players tv_player_in_e6))
	(print "	obj_con_overview 60")
	(set obj_con_overview 60)
)

;==============
;encounter 7
;==============

;encounter has cues tied to objectives

(script dormant hydro_entry_hall_2
	(sleep_until (volume_test_players tv_act_hydro_entry_hall_2) 1)
	(ai_place gr_beat1_e7_hydro_entry_garden)

	(print "	obj_con_overview 70")
	(set obj_con_overview 70)

	(print "game_save_no_timeout 3")
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_hydro_entry_0) 1)
	(ai_disposable gr_beat1_e3_to_e4_cleanup true)

	(print "game_save_no_timeout 3.5")
	(game_save_no_timeout) ;checkpoint
)

(script command_script cs_e7_sword_ambush
	(cs_aim_player true)
	(cs_abort_on_damage true)
	(sleep_until
		(or
		(volume_test_players tv_e7_chase_player)
		(and
			(volume_test_players tv_e7_chase_player_look)
			(objects_can_see_flag (players) fl_e7_ambush_look 20)
		)
		)
		1
	)
	(cs_go_to ps_e7_sword_ambush/p1)
	(print "cs_e7_sword_ambush release")
)

;==============
;encounter 8
;==============

;encounter has cues tied to objectives

; insertion point - ins_e30_hydro_enter

(script dormant hydro_entry
	(sleep_until (volume_test_players tv_hydro_entry_0) 1)
	(ai_place gr_beat1_e8_hydro_entry_w1)
	(ai_erase gr_beat1_vista_vign)

	(ai_set_objective ai_johnson obj_hydro_entry_unsc)

	(wake e8_ambush_dawdle_check)

	(sleep_until
		(or
			(<= (ai_living_fraction gr_beat1_e8_hydro_entry_w1) .75)
			(volume_test_players tv_e8_entry_rein)
		)
		1
	)
	(ai_place gr_beat1_e8_hydro_entry_w2)

	(sleep_until (<= (ai_living_count gr_beat1_e8_hydro_entry_room) 0) 1)
	(if (< s_music_trigger_e30 39) (set s_music_trigger_e30 40))
	(print "game_save_no_timeout 4")
	(game_save_no_timeout) ;checkpoint

)

(script command_script cs_e8_entry_ambush_grunts
	(cs_aim_player true)
	(cs_abort_on_damage true)
	(cs_crouch true)

	(e8_entry_ambush_trigger)
	(sleep (game_ticks_from_seconds .5))
	(print "cs_e8_entry_ambush release")
	(cs_crouch false)
	(cs_go_to (ai_nearest_point ai_current_actor ps_e8_ambush_grunt))
)

(script command_script cs_e8_entry_ambush_elites
	(cs_aim_player true)
	(cs_abort_on_damage true)
	(cs_crouch true)

	(e8_entry_ambush_trigger)
	(sleep (game_ticks_from_seconds .25))
	(print "cs_e8_entry_ambush release")
	(cs_crouch false)
	(cs_go_to (ai_nearest_point ai_current_actor ps_e8_ambush_elite))
)

(script command_script cs_e8_entry_ambush_jackals
	(cs_aim_player true)
	(cs_abort_on_damage true)
	(cs_crouch true)

	(e8_entry_ambush_trigger)
	(print "cs_e8_entry_ambush release")
	(cs_crouch false)
	(cs_go_to (ai_nearest_point ai_current_actor ps_e8_ambush_jackal))
)

(global boolean b_e8_ambush_dawdled 0)

(script dormant e8_ambush_dawdle_check
	(sleep_until (volume_test_players tv_e8_entry_ambush_dawdle) 1)
	(sleep (game_ticks_from_seconds 10))
	(set b_e8_ambush_dawdled 1)
)

(script static void e8_entry_ambush_trigger
	(sleep_until
		(or
			(volume_test_players tv_e8_entry_ambush)
			(= b_e8_ambush_dawdled 1)
		)
		1
	)
)

;==============
;encounter 9
;==============

;encounter has cues tied to objectives

(global short obj_con_gardens 0) ;used in obj_gardens_unsc

(script dormant garden_1
	(sleep_until (volume_test_players tv_act_garden_1) 1)
	(print "gr_beat1_e5_to_e7_cleanup clean up")
	(ai_disposable gr_beat1_e5_to_e7_cleanup true)

	(ai_place gr_beat1_e9_hydro_garden)
	(wake garden_1_encounter_eliminated)

	(ai_set_objective ai_johnson obj_gardens_unsc)

	(print "game_save_no_timeout 5")
	(game_save_no_timeout) ;checkpoint
	(wake vo_garden_hunters_outro)

	;(sleep_until (volume_test_players tv_end_garden_1) 1)

	;kill the script if the player has not killed the hunters after making it to the next garden
	;(if (> (ai_living_count gr_beat1_e9_hydro_garden) 0)
	;	;then
	;	(sleep_forever vo_garden_hunters_outro)
	;)
)

(script dormant garden_1_encounter_eliminated
	(sleep_until (<= (ai_living_count gr_beat1_e9_hydro_garden) 0))
	(print "game_save_no_timeout 5.5")
	(game_save_no_timeout) ;checkpoint
)

;==============
;encounter 10
;==============

; insertion point - ins_e30_hydro_mid
; zone set - zs_hydro_control
(script dormant garden_2
	(sleep_until (volume_test_players tv_act_garden_2) 1)
	(print "gr_beat1_e8_hydro_entry_room cleanup")
	(ai_disposable gr_beat1_e8_hydro_entry_room true)
	(ai_place gr_beat1_e10_hydro_garden2)

	(print "	obj_con_gardens 20")
	(set obj_con_gardens 20)

	(print "game_save_no_timeout 6")
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_end_garden_2) 1)

	(print "gr_beat1_e9_to_e10_cleanup cleanup")
	(ai_disposable gr_beat1_e9_to_e10_cleanup true)
	(print "game_save_no_timeout 7")
	(game_save_no_timeout) ;checkpoint
)

;==============
;encounter 11
;==============

(script dormant hydro_bridge
	(sleep_until (volume_test_players tv_act_hydro_bridge) 1)
	(ai_place gr_beat1_e11_w1)

	(wake johnson_to_hydro_bridge)

	(sleep_until
		(or
			(<= (ai_living_fraction gr_beat1_e11_w1) .75)
			(volume_test_players tv_hydro_bridge_c)
		)
		1
	)
	(ai_place gr_beat1_e11_w2)

	(wake e11_checkpoint)

	(sleep_until (volume_test_players tv_end_hydro_bridge) 1)
	(print "gr_beat1_e11_hydro_bridge cleanup")
	(ai_disposable gr_beat1_e11_hydro_bridge true)
)

(script dormant e11_checkpoint
	(sleep_until (<= (ai_living_count gr_beat1_e11_hydro_bridge) 0) 1)
	(print "game_save_no_timeout 8")
	(game_save_no_timeout) ;checkpoint
)

(script dormant johnson_to_hydro_bridge
	(print "remove johnson from fireteam")
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_hydro_bridge)
)

;==============
;encounter 12
;==============

(script dormant control_approach
	(sleep_until (volume_test_players tv_act_control_approach) 1)
	(ai_place gr_beat1_e12_control_grav_up)
	(wake vo_control_approach)
	(wake johnson_control_bridge)
)

(script dormant nav_to_control
	(sleep_until
		(and
			(<= (ai_living_count gr_beat1_e12_control_grav_up) 0)
				(volume_test_players tv_nav_to_control)
		)
		1
	)
	(sleep (game_ticks_from_seconds 3))
	(f_blip_flag fl_nav_to_control 0)
	(sleep_until (volume_test_players tv_navend_to_control) 1)
	(f_unblip_flag fl_nav_to_control)
)

;==============
;encounter 13
;==============

(global boolean b_e13_ready_for_push 0)
(global boolean b_e13_started 0)
(global boolean b_bridge_cinematic_played 0)

(script dormant control
	(sleep_until (volume_test_players tv_act_control) 1)
	(ai_place gr_beat1_e13_control_w1)
	(ai_prefer_target_team gr_beat1_e13_control_bridge player)
	; (ai_prefer_target (players) true)
	(wake vo_control_outro)


	(sleep_until (volume_test_players tv_control_encounter) 1)
	(print "game_save_no_timeout before control bridge encounter")
	(game_save_no_timeout) ;checkpoint

	(sleep_until
		(or
			(<= (ai_living_fraction gr_beat1_e13_control_w1) .6) ;when 60% dies
			(= ( ai_nonswarm_count sq_control_elites_gen) 0) ;when general dies
		)
	 	1
	 	(game_ticks_from_seconds 45)
	)

	(print "place wave 2 upper left")
	(ai_place gr_beat1_e13_control_w2_up_l)

	(sleep (game_ticks_from_seconds 10))

	(sleep_until
		(or
			(<= (ai_living_fraction gr_beat1_e13_control_w1) .4) ;when 40% dies
			(= (ai_nonswarm_count sq_control_elites_gen) 0) ;when general dies
		)
	 	1
	 	(game_ticks_from_seconds 30)
	)

	(print "place wave 2 upper right")
	(ai_place gr_beat1_e13_control_w2_up_r)

	(sleep (game_ticks_from_seconds 15))

	(print "place wave 2 lower")
	(ai_place gr_beat1_e13_control_w2_lower)
	(set s_music_trigger_e30 80)

		(sleep_until
        (<= (ai_living_fraction gr_beat1_e13_control_bridge) .4) ;when 40% dies
        1
        (game_ticks_from_seconds 30)
    )

	(if (coop_players_3)
		(begin
			(print "place wave 3 upper left")
			(ai_place gr_beat1_e13_control_w3_up_l)

			(sleep_until
				(<= (ai_living_fraction gr_beat1_e13_control_w3_up_l) .6) ;when 60% dies
				1
				(game_ticks_from_seconds 45)
			)

			(print "place wave 3 upper right")
			(ai_place gr_beat1_e13_control_w3_up_r)

			(sleep (game_ticks_from_seconds 15))

			(print "place wave 3 lower")
			(ai_place gr_beat1_e13_control_w3_lower)
		)
	)



	(sleep (game_ticks_from_seconds 1))

	(sleep_until (<= (ai_nonswarm_count gr_beat1_e13_control_bridge) 5) 1)

	(print "5 reminging enemies ready for final push task")
	(set b_e13_ready_for_push 1)

	(sleep_until (<= (ai_nonswarm_count gr_beat1_e13_control_bridge) 3) 1)
	(print "3 reminging enemies readyblipped")
	(f_blip_ai gr_beat1_e13_control_bridge 1)

	(print "game_save_no_timeout 9")
	(game_save_no_timeout) ;checkpoint

	(sleep_until
		(and
			(volume_test_players tv_end_beat_1)
			(<= (ai_nonswarm_count gr_beat1_e13_control_bridge) 0)
		)
		1
	)

	(print "game_save_no_timeout 9.5")
	(game_save_no_timeout) ;checkpoint --> just in case the hunters are one/two of the remaining 3

	;allow for a pause before cinematic starts
	(print "sleep for a bit")
	(sleep (game_ticks_from_seconds 5))

	(print_if b_debug_gameplay "insertion point: ins_e30_grav_lift unlocked")
	(submit_incident "ins_e30_grav_lift")
	(submit_incident_with_custom_string_id "game_activity_begin" "e30")

	(set s_music_trigger_e30 100)
	(f_play_cinematic cinematics\e30\e30_bridge.cinematic ps_after_cine_teleport)
	(set b_bridge_cinematic_played  1)
	(print "gr_beat1_encounters cleanup")
	(ai_erase gr_beat1_encounters) ; end of beat 1
	(wake after_cine_teleport)
	(wake begin_beat2)
)

(script dormant johnson_control_bridge
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_control)
	(sleep_until (volume_test_players tv_control_encounter) 1)
	(set b_e13_started 1)
)

;leaving the teleport for johnson at the request of the level owner.
(script dormant after_cine_teleport
	(object_teleport_to_ai_point ai_johnson ps_after_cine_teleport/p_johnson)
)


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;______            _     _____            _____       _____                   _ _
;| ___ \          | |   / __  \          |_   _|     |_   _|                 (_) |
;| |_/ / ___  __ _| |_  `' / /'  ______    | | ___     | |_ __ __ _ _ __  ___ _| |_
;| ___ \/ _ \/ _` | __|   / /   |______|   | |/ _ \    | | '__/ _` | '_ \/ __| | __|
;| |_/ /  __/ (_| | |_  ./ /___            | | (_) |   | | | | (_| | | | \__ \ | |_
;\____/ \___|\__,_|\__| \_____/            \_/\___/    \_/_|  \__,_|_| |_|___/_|\__|
;
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant ins_beat2_catch_up
	(set s_music_trigger_e30 100)
	(f_play_cinematic cinematics\e30\e30_bridge.cinematic)
	(wake begin_beat2)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_control)
	(set b_bridge_cinematic_played  1)
	(wake beat1_doors_updates)
)

(script dormant begin_beat2
	(print "******* begin_beat2 awoke *******")
	; beat 2 encounter scripts
	(set s_cur_beat 2)
	(wake gravlift_redux)
	(wake hydro_bridge_redux)
	(wake garden_redux_2)
	(wake post_garden_low)
	(wake post_garden_high)
	(wake garden_exit)
	(wake hydro_entry_redux)
	(wake rr_approach)
	(wake rr)
	; flow control
	(wake control_gravlift_to_down)
	; beat 2 narrative
	(wake chapter_2)
	(wake vo_beat2_down_lift)
	(wake music_hydro_bridge_redux_trigger)
	(wake music_hydro_meetup_trigger)
	; nav
	(wake beat2_nav_loop)
	(wake vo_init_beat_2)
	; flow control
	(wake beat2_doors_updates)
	(wake point_of_no_return_beat2)
	(wake beat2_johnson_fall_bridge_check)

	(wake mission_obj_docking_bay)

	(wake vo_control_after_cine)
	(print "game_save_no_timeout 10")
	(game_save_no_timeout) ;checkpoint
)

;==============
;encounter 14
;==============

(script dormant vo_init_beat_2
	(sleep_until (volume_test_players tv_nav_beat2_gravlift) 1)
	(wake vo_control_leaving)
)

(script dormant gravlift_redux
	(sleep_until (volume_test_players tv_act_gravlift_redux) 1)
	(ai_place gr_beat2_e14_gravlift_redux)
	(wake vo_control_grav_lift_lower)
	(wake gravlift_redux_encounter_eliminated)
	(print "game_save_no_timeout 11")
	(game_save_no_timeout) ;checkpoint
	(sleep_until (volume_test_players tv_end_gravlift_redux) 1)
	(ai_disposable gr_beat2_e14_gravlift_redux true)
)

(script dormant gravlift_redux_encounter_eliminated
	(sleep_until (= (ai_living_count gr_beat2_e14_gravlift_redux) 0))
	(print "game_save_no_timeout 11.25")
	(game_save_no_timeout) ;checkpoint
)
;==============
;encounter 15
;==============

(script dormant hydro_bridge_redux
	(sleep_until (volume_test_players tv_act_hydro_bridge_redux) 1)
	(wake johnson_to_hydro_bridge_redux)

	(ai_place gr_beat2_e15_w1)

	(wake hydro_bridge_redux_hallway_cp)

	(sleep_until
		(or
			(<= (ai_living_fraction gr_beat2_e15_w1) .75)
			(volume_test_players tv_bridge_redux_wave_2)
		)
		1
	)
	(ai_place gr_beat2_e15_w2)

	(print "game_save_no_timeout 11.5")
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_end_hydro_bridge_redux) 1)
	(ai_disposable gr_beat2_e15_hydro_bridge_redux true)
)

(script dormant hydro_bridge_redux_hallway_cp
	(sleep_until (volume_test_players tv_hydro_bridge_redux_cp) 1)
	(print "hydro_bridge_redux_hallway_cp game_save_no_timeout 11.75")
	(game_save_no_timeout) ;checkpoint
)

(script dormant johnson_to_hydro_bridge_redux
	(sleep_until (volume_test_players tv_bridge_redux_johnson_to) 1)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_bridge_redux)

	(sleep_until (volume_test_players tv_lead_garden_redux) 1)

	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_gardens_redux_unsc)
)

;==============
;encounter 16
;==============

(script dormant garden_redux_2
	(sleep_until (volume_test_players tv_act_garden_redux_2) 1)
	(ai_place gr_beat2_e16_garden2_w1)

	(object_create sc_cov_port_shield_g2_1)
	(object_create sc_cov_port_shield_g2_2)

	(sleep_until
		(or
			(volume_test_players tv_mid_garden_redux_2)
			(<= (ai_living_count gr_beat2_e16_garden2_w1) 2)
		)
	1
	)

	(ai_place gr_beat2_e16_garden2_w2)

	(print "game_save_no_timeout 12")
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_end_garden_redux_2) 1)
	(ai_disposable gr_beat2_e16_garden2_redux true)
	(wake vo_hydro_garden_return)
	(print "game_save_no_timeout 12")
	(game_save_no_timeout) ;checkpoint
)

;==============
;encounter 17
;==============

(global boolean b_e17_spawned 0)

(script dormant post_garden_low
	(sleep_until (volume_test_players tv_act_post_garden_low) 1)
	(ai_place gr_beat2_e17_post_garden_low)
	(set b_e17_spawned 1)

	(print "test for player")
	(sleep_until (volume_test_players tv_post_garden_high) 1)

	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)

	(sleep_until (volume_test_players tv_end_post_garden_low) 1)
	(ai_disposable gr_beat2_e17_post_garden_low true)
)

;==============
;encounter 18
;==============

(script dormant post_garden_high
	(sleep_until (volume_test_players tv_act_post_garden_high) 1)
	(ai_place gr_beat2_e18_post_garden_high)
	(sleep_until (volume_test_players tv_end_post_garden_high) 1)
	(ai_disposable gr_beat2_e18_post_garden_high true)
	(print "game_save_no_timeout 13")
	(game_save_no_timeout) ;checkpoint
)

;==============
;encounter 19
;==============

(script dormant garden_exit
	(sleep_until (volume_test_players tv_act_garden_exit) 1)
	(ai_place gr_beat2_e19_garden_exit)
	(sleep_until (volume_test_players tv_end_garden_exit) 1)
	(ai_disposable gr_beat2_e19_garden_exit true)
)

;==============
;encounter 20
;==============

(script dormant hydro_entry_redux
	(sleep_until (volume_test_players tv_act_hydro_entry_redux) 1)
	(ai_place gr_beat2_e20_hydro_entry_redux)
	(wake hydro_entry_redux_cp)

	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_hydro_entry_redux_unsc)

	(sleep_until (volume_test_players tv_end_hydro_entry_redux) 1)
	(ai_disposable gr_beat2_e20_hydro_entry_redux true)
)

(script dormant hydro_entry_redux_cp
	(sleep_until (= (ai_living_count gr_beat2_e20_hydro_entry_redux) 0) 1)
	(print "game_save_no_timeout")
	(game_save_no_timeout) ;checkpoint
)

;==============
;encounter 21
;==============

(script dormant rr_approach
	(sleep_until (volume_test_players tv_act_rr_approach) 1)
	(ai_place gr_beat2_e21_w1)

	(wake rr_approach_encounter_eliminated)

	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)

	(sleep_until
		(or
			(volume_test_players tv_mid_rr_approach)
			(<= (ai_living_count gr_beat2_e21_w1) 4)
		)
		1
	)
	(ai_place gr_beat2_e21_w2)

	(print "game_save_no_timeout 15")
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_end_rr_approach) 1)
	(ai_disposable gr_beat2_e21_connection2 true)
)

(script dormant rr_approach_encounter_eliminated
	(sleep_until (= (ai_living_count gr_beat2_e21_connection2) 0) 1)
	(print "game_save_no_timeout 15.5")
	(game_save_no_timeout) ;checkpoint
)
;==============
;encounter 22
;==============

(global boolean b_nav_to_beat3_ready 0)

(script dormant rr
	(sleep_until (volume_test_players tv_act_rr) 1)
	(ai_place gr_beat2_e22_rest_respite)
	(wake johnson_to_rr_top)
	(wake beat3_trigger)
	(wake johnson_transit_follow_objective)

	(print "game_save_no_timeout16")
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_end_beat_2) 1)

	(print "game_save_no_timeout 17")
	(game_save_no_timeout) ;checkpoint
)

(script dormant johnson_to_rr_top
	(sleep_until (volume_test_players tv_johnson_rr_to_top) 1)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_rr)

	(sleep_until
		(or
			(volume_test_players tv_johnson_rr_from_top)
			(= (ai_living_count gr_beat2_e22_rest_respite) 0)
		)
		1
	)
	(set b_nav_to_beat3_ready 1)
)

(script dormant johnson_transit_follow_objective
	(sleep_until (volume_test_players tv_ponr_transit_grav_below) 1)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
)

(script dormant init_johnson
	(cond
		((f_insertion_point_matches ins_e30_start) (begin
			(ai_place sq_johnson_start)
			(set ai_johnson sq_johnson_start)
		))
		((f_insertion_point_matches ins_e30_hydro_enter) (begin
			(ai_place sq_johnson_hydro_enter)
			(set ai_johnson sq_johnson_hydro_enter)
			(ai_player_add_fireteam_squad player0 ai_johnson)
		))
		((f_insertion_point_matches ins_e30_hydro_mid) (begin
			(ai_place sq_johnson_hydro_mid)
			(set ai_johnson sq_johnson_hydro_mid)
			(ai_player_add_fireteam_squad player0 ai_johnson)
		))
		((f_insertion_point_matches ins_e30_grav_lift) (begin
			(ai_place sq_johnson_grav_lift)
			(set ai_johnson sq_johnson_grav_lift)
		))
		((f_insertion_point_matches ins_e30_hydro_redux) (begin
			(ai_place sq_johnson_hydro_redux)
			(set ai_johnson sq_johnson_hydro_redux)
			(ai_player_add_fireteam_squad player0 ai_johnson)
		))
		((f_insertion_point_matches ins_e30_rr_approach) (begin
			(ai_place sq_johnson_rr_approach)
			(set ai_johnson sq_johnson_rr_approach)
			(ai_player_add_fireteam_squad player0 ai_johnson)
		))
		((f_insertion_point_matches ins_e30_transit_station) (begin
			(ai_place sq_johnson_transit)
			(set ai_johnson sq_johnson_transit)
			(ai_player_add_fireteam_squad player0 ai_johnson)
		))
		((f_insertion_point_matches ins_e30_dome_station) (begin
			(ai_place sq_johnson_dome)
			(set ai_johnson sq_johnson_dome)
			(ai_player_add_fireteam_squad player0 ai_johnson)
		))
	)
	(wake ai_disregard_johnson)
	(nav_on_init_johnson)
)

;help johnson follow the player if he falls too far behind
(script dormant ai_disregard_johnson
	(print "ai disregarding script started")
	(sleep_until
		(begin
			;check how far a player is away from johnson
			(if
				(> (objects_distance_to_object (players) ai_johnson) 25) ;world units
				;then
				(begin
					;enemies don't care that johnson is on their ship and he cannot perceive them
					;(print "ai_johnson is now disregarded he is too far away from any player")
					(ai_disregard ai_johnson true)
					(ai_set_blind ai_johnson true)
					(ai_set_deaf  ai_johnson true)
				)
				;else
				(begin
					;enemies now care that johnson is on their ship and he can now perceive that them
					;(print "ai_johnson is now regarded since he is close to a player")
					(ai_disregard ai_johnson false)
					(ai_set_blind ai_johnson false)
					(ai_set_deaf  ai_johnson false)
				)
			)

		b_space_started ; exit condition
   		)
    	1 ;check this many ticks
  	)
	(print "ai disregarding script ended")
)

(script static void nav_on_init_johnson
	(sleep (game_ticks_from_seconds 1))
	;(chud_track_object_with_priority ai_johnson 2 emile_name)
	(f_hud_hero_waypoint ai_johnson hero_johnson hero_default_max_dist)
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;  ____             _     _____   _____                    _ _
; | __ )  ___  __ _| |_  |___ /  |_   _| __ __ _ _ __  ___(_) |_
; |  _ \ / _ \/ _` | __|   |_ \    | || '__/ _` | '_ \/ __| | __|
; | |_) |  __/ (_| | |_   ___) |   | || | | (_| | | | \__ \ | |_
; |____/ \___|\__,_|\__| |____/    |_||_|  \__,_|_| |_|___/_|\__|
;
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(global boolean b_tram_power false)
(global boolean b_tram_unlock false)

(script dormant beat3_trigger
	(sleep_until (volume_test_players tv_began_beat3) 1)
	(wake begin_beat3)
)

(script dormant begin_beat3
	(print "beat 3 scripts wake")

	(wake johnson_fall_transit_check)

	;wake beat 3 encounters scripts
	(wake e23)
	(wake e24_e25)
	(wake e26)
	(wake e27)
	(wake e28_e29)
	(wake e30)
	(wake e31)
	(wake e32)
	(wake e33)
	(wake e34)
	(wake beat4_trigger)
	(wake dome_station_vignette)
	(wake transit_soft_kill_volume_control)
	(wake transit_gravlift_failsafe)

	; narrative
	(wake music_docking_bay_station_safety)
)

(script dormant transit_gravlift_failsafe
	(sleep_until (volume_test_players tv_transit_lift_failsafe ) 1)
	(print "creating gravitylift_b_down is necassary")
	(object_create_if_necessary gravitylift_b_down)
)

;==============
;encounter 23
;==============

(global short obj_con_transit 0)
(global boolean b_beat3_reached 0)

(script dormant e23
	(sleep_until (volume_test_players tv_transit_e23) 1)

	(print_if b_debug_gameplay "insertion point: ins_e30_transit_station unlocked")
	(submit_incident "ins_e30_transit_station")
	(submit_incident_with_custom_string_id "game_activity_begin" "e30")

	(set b_beat3_reached 1)

	(ai_place gr_transit_e23_transit_hallway)

	(print "remove johnson from fireteam")
	(ai_player_remove_fireteam_squad player0 ai_johnson)

	(ai_set_objective ai_johnson obj_transit_unsc)

	(wake tram_attachments_setup)
	(wake chapter_3)

	(wake point_of_no_return_beat3)
)

;==============
;encounter 24 & 25
;==============

(script dormant e24_e25
	(sleep_until (volume_test_players tv_transit_e24_e25) 1)
	(print "******* encounter 24 & 25 *******")

	(ai_place gr_transit_e24_e25_h_station)
	(ai_activity_set sq_e24_grunts asleep)
	(wake music_e24_e25_encounter_end)

	(wake tram_power_activation)
	(wake tram_unlock_activation)

	(print "game_save_no_timeout 18")
	(game_save_no_timeout) ;checkpoint

	(wake post_e24_e25)

	(sleep_until (volume_test_players tv_transit_e25_marker) 1)

	(set s_music_trigger_e30 160)
	(wake vo_transit_hydro_enter)

	(f_blip_flag fl_hydro_station_1 0)
	(f_blip_flag fl_hydro_station_2 0)

	;sleep until player hits both transit switches for tram
	(sleep_until
		(and
			(= b_tram_power 1)
			(= b_tram_unlock 1)
		)
		1
	)
	(print "tram powered and unlocked")
	(set s_music_trigger_e30 180)
	(wake vo_transit_hydro_activated)
	(wake beat_3_start_transit_control) ;need to replace with real controls
	(wake mission_obj_docking_bay_repeat_1)

)

(script dormant post_e25_johnson_switch_help
	(branch
			;abort if player hits both switches before johnson can help
		(and
			(= b_tram_power 1)
			(= b_tram_unlock 1)

		)
		(kill_branch)
	)

	;wait for encounter to be over before johnson can try to help player
	(sleep_until (= (ai_living_count gr_transit_e24_e25_h_station) 0) 1)

	(sleep_until
		;johnson has a task to move to the opposite switch where the player is at
		(or
			(volume_test_object tv_transit_e25_left_switch ai_johnson)
			(volume_test_object tv_transit_e25_right_switch ai_johnson)
		)
		1
	)

	(cs_run_command_script ai_johnson cs_e25_johnson_switch_help)

)

(script command_script cs_e25_johnson_switch_help
	(object_cannot_take_damage ai_johnson)

	(cond
		;johnson at switch 1 platform
		(
			(volume_test_object tv_transit_e25_left_switch ai_johnson)
			(begin
				(cs_go_to ps_transit_e25_switch_help/p0)
				(cs_go_to ps_transit_e25_switch_help/p1)
				(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true)
				(sleep (unit_get_custom_animation_time ai_johnson))
				(device_set_position dc_hydro_station_1 1)
				(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true)
			)
		)
		;johnson at switch 2 platform
		(
			(volume_test_object tv_transit_e25_right_switch ai_johnson)
			(begin
				(cs_go_to ps_transit_e25_switch_help/p2)
				(cs_go_to ps_transit_e25_switch_help/p3)
				(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true)
				(sleep (unit_get_custom_animation_time ai_johnson))
				(device_set_position dc_hydro_station_2 1)
				(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true)
			)
		)
	)

	(object_can_take_damage ai_johnson)
)

(script dormant post_e24_e25
	(sleep_until (= (ai_living_count gr_transit_e24_e25_h_station) 0) 1)
	(print "game_save_no_timeout 19")
	(game_save_no_timeout) ;checkpoint

	(print "	set obj_con_transit 10")
	(set obj_con_transit (+ obj_con_transit 10))
	(if (= (game_coop_player_count) 1) (wake post_e25_johnson_switch_help)) ;johnson won't help if master chief's clones show up
)

(script dormant tram_power_activation
	(sleep_until (= (device_get_position dc_hydro_station_1) 1) 1)
	(set b_tram_power true)
	(print "tram powered")
	(device_set_power dc_hydro_station_1 0)
	(f_unblip_flag fl_hydro_station_1)

	(print "	+ obj_con_transit 5")
	(set obj_con_transit (+ obj_con_transit 5))
)

(script dormant tram_unlock_activation
	(sleep_until (= (device_get_position dc_hydro_station_2) 1) 1)
	(set b_tram_unlock true)
	(print "tram unlock")
	(device_set_power dc_hydro_station_2 0)
	(f_unblip_flag fl_hydro_station_2)
	;opens first door
	(device_set_position dm_transit_large_door1 1)

	(print "	+ obj_con_transit 5")
	(set obj_con_transit (+ obj_con_transit 5))
)

;==============
;encounter 26
;==============

(global boolean b_section_1_complete false)

(script dormant e26
	(sleep_until (volume_test_players tv_transit_e26) 1)

	(print "game_save_no_timeout 20")
	(game_save_no_timeout) ;checkpoint

	(print "obj_con_transit 30")
	(set obj_con_transit 30)

	(print "******* encounter 26 *******")

	;wave 1
	(ai_place gr_transit_e26_w1)
	(print "e26 wave 1")

	(sleep_until (= b_e26_pos_change 1) 1)
	(ai_place gr_transit_e26_w2)

	(sleep_until (<= (ai_living_count gr_transit_e26_w1) 0) 1)
	(wake vo_transit_section1_cleared)
)

;==============
;encounter 27
;==============
(script dormant e27
	(sleep_until (volume_test_players tv_transit_e27) 1)

	(print "obj_con_transit 40")
	(set obj_con_transit 40)

	(print "game_save_no_timeout 21")
	(game_save_no_timeout) ;checkpoint

	(print "******* encounter 27 *******")
	(ai_place gr_transit_e27_bridge1)
	(wake vo_transit_section2_start)
	(wake vo_transit_section2_cleared)

	(sleep_until (= b_e27_kamikaze_spawn 1) 1)
	(ai_place gr_transit_e27_bridge2)

	(sleep_until (= b_e27_kamikaze_prep 1) 1)
	(ai_grunt_kamikaze  sq_e27_c_suicide)
)

(script command_script cs_e27_temp_jump_down
	(print "	cs_e27_temp_jump_down started")
	(cs_face_object true player0)
	(ai_grunt_kamikaze  sq_e27_c_suicide)
	(cs_go_to ps_e27_temp_grunt_jump/p2)
	(sleep_until (= b_e27_kamikaze_ready 1) 1)
	(cs_move_towards_point ps_e27_temp_grunt_jump/p3 2)
	(cs_jump_to_point 1 1.5)
)

(script dormant ins_dome_station_catch_up
	(print "ins_dome_station_catch_up")

	;wake remainging beat 3 encounters
	(wake e28_e29)
	(wake e30)
	(wake e31)
	(wake e32)
	(wake e33)
	(wake e34)
	(wake beat4_trigger)
	(wake dome_station_transit_control_catch_up)
	(wake dome_station_vignette)
	(object_create_folder of_dome_station)
)

;==============
;encounter 28 - 30
;==============
(script dormant e28_e29
	(sleep_until (volume_test_players tv_transit_e28) 1)

	(print "obj_con_transit 50")
	(set obj_con_transit 50)

	(sleep_until
		(or
			(volume_test_players tv_transit_e28_e29_left)
			(volume_test_players tv_transit_e28_e29_right)
		)
		1
	)

	;once the dome station has started or player dawdles
	(sleep_until (= b_dome_powering_started 1) 1 (game_ticks_from_seconds 20))

	(print "game_save_no_timeout 22")
	(game_save_no_timeout) ;checkpoint

	(print "******* encounter 28 *******")
	(ai_place gr_transit_e28_dome_station)

	(sleep_until (= b_dome_powering_started 1) 1 (game_ticks_from_seconds 20))

	(print "game_save_no_timeout 23")
	(game_save_no_timeout) ;checkpoint

	(print "******* encounter 29 *******")
	(ai_place gr_transit_e29_dome_corridors)
)

;==============
;encounter 30
;==============

(global boolean b_dome_powering_started false)
(global boolean b_dome_defend_complete false)
(global short s_dome_wave_defeated 0)

(script dormant e30
	(wake vo_transit_dome_switched)
	(wake vo_transit_dome_powered)
	(sleep_until (volume_test_players tv_transit_e30) 1)
	(f_blip_flag fl_dome_station_1 0)
	(f_blip_flag fl_dome_station_2 0)

	;player can press either switch
	(sleep_until
		(or
			(= (device_get_position dc_dome_station_1) 1)
			(= (device_get_position dc_dome_station_2) 1)
		)
	1)
	(set b_dome_powering_started 1)

	(wake mission_obj_eliminate)

	(print "obj_con_transit 60")
	(set obj_con_transit 60)

	(print "******* encounter 30 *******")

	(device_set_power dc_dome_station_1 0)
	(device_set_power dc_dome_station_2 0)
	(f_unblip_flag fl_dome_station_1)
	(f_unblip_flag fl_dome_station_2)

	(object_create_folder of_dome_tram_refresh) ;ensure some weapons are on tram before it takes off again

	(print "game_save_no_timeout before defend sequence")
	(game_save_no_timeout) ;checkpoint

	(sleep (game_ticks_from_seconds 5)) ;sleep for a bit before the waves come

	(if
		(> (ai_nonswarm_count gr_transit_e28_e29_dome_station) 0)
		;then
		(begin
			(print "holding e30 until e28 & e29 are dead")
			(sleep_until (<= (ai_nonswarm_count gr_transit_e28_e29_dome_station) 2) 1)
			(sleep (game_ticks_from_seconds 5))
		)
		;else
	)

	;wave 1
	(ai_place gr_e30_wave1)
	(print "e30 wave 1")
	(sleep_until (<= (ai_nonswarm_count sq_e30_wave1) 2) 1)

	;wave 2
	(sleep (game_ticks_from_seconds 5))
	(ai_place gr_e30_wave2)
	(print "e30 wave 2")
	(set s_music_trigger_e30 220)
	(sleep_until (<= (ai_nonswarm_count sq_e30_wave2) 0) 1)

	(set s_dome_wave_defeated 2)

	(print "check-point post wave2")
	(game_save_no_timeout) ;checkpoint

	;wave 3
	(sleep (game_ticks_from_seconds 5))
	(ai_place gr_e30_wave3_plus)
	(print "e30 wave 3")

	(set s_dome_wave_defeated 3)


	(sleep_until (<= (ai_nonswarm_count gr_transit_e30_dome_defend) 3) 1)
	(f_blip_ai gr_cleanup_e28_to_e30 1) ;ensure e28, e29 &, e30 units are blipped
	(print "blipping last 3 enemies")

	;wait for all enemies to be dead
	(sleep_until (= (ai_nonswarm_count gr_transit_e30_dome_defend) 0) 1)
	(set b_dome_defend_complete 1)

	(ai_player_remove_fireteam_squad player0 ai_johnson)

	(print "game_save_no_timeout 25")
	(game_save_no_timeout) ;checkpoint

	(print "obj_con_transit 65")
	(set obj_con_transit 65)

	(wake mission_obj_docking_bay_repeat_2)

)

(script dormant dome_station_vignette
	(sleep_until (>= (device_get_position dm_transit) r_dome_station_vign_pos) 1)

	;turn off all lights
	(print "dome station vignette - dm_dome_vignette_off 0")
	(device_set_position_immediate dm_dome_vignette_off 0.5)

	(sleep_until (= b_dome_powering_started 1) 1)
	(print "dome station vignette - wave counter started - powering on sfx starts")
	;turn on first set of lights
	(device_set_position_immediate dm_dome_vignette_1st 0.5)
	(print "dome station vignette - device_set_position_immediate dm_dome_vignette_1st 0.5")

	;turn on second set of lights
	(sleep_until (>= s_dome_wave_defeated 2) 1 (game_ticks_from_seconds 30))
	(device_set_position_immediate dm_dome_vignette_2nd 0.5)
	(print "dome station vignette - device_set_position_immediate dm_dome_vignette_2nd 0.5")

	;turn on third set of lights
	(sleep_until (>= s_dome_wave_defeated 3) 1 (game_ticks_from_seconds 30))
	(device_set_position_immediate dm_dome_vignette_3rd 0.5)
	(print "dome station vignette - device_set_position_immediate dm_dome_vignette_3rd 0.5")

	;turn on last set of lights
	(sleep_until (= b_dome_defend_complete 1) 1)
	(device_set_position_immediate dm_dome_vignette_last 0.5)
	(print "dome station vignette - device_set_position_immediate dm_dome_vignette_last 0.5")
	(print "dome station vignette - end - powering on sfx finsihes")
)

;==============
;encounter 31
;==============

(script dormant e31
	;wave 1
	(sleep_until (volume_test_players tv_transit_e31) 1)

	(print "game_save_no_timeout 26")
	(game_save_no_timeout) ;checkpoint

	(print "******* encounter 31 *******")

	(ai_place gr_e31_wave1)
	(print "e31 wave 1")

	(ai_place gr_e31_wave2)
	(print "e31 wave 2")

	(sleep_until (volume_test_players tv_transit_e31_wave3) 1)
	(ai_place gr_e31_wave3)
	(print "e31 wave 3")

)

;==============
;encounter 32
;==============

(global boolean b_section_4_complete false)

(script dormant e32
	(sleep_until (volume_test_players tv_transit_e32) 1)

	(print "obj_con_transit 70")
	(set obj_con_transit 70)

	(print "game_save_no_timeout 27")
	(game_save_no_timeout) ;checkpoint

	(wake vo_transit_station4_clear)

	(print "******* encounter 32 *******")

	;wave 1
	(ai_place gr_e32_wave1)
	(ai_place gr_e32_wave2)

	(sleep_until (and
				(= (ai_living_count gr_e32_wave1) 0)
				(= (ai_living_count gr_e32_wave2) 0)
				)
				1
	)
	(set b_section_4_complete true)
)

;==============
;encounter 33
;==============
(script dormant e33
	(sleep_until (volume_test_players tv_transit_e33) 1)
	(wake vo_transit_hangar_station)
	(wake vo_hangar_gravlift)

	(print "******* encounter 33 *******")
	(ai_place gr_transit_e33_docking_station)

	(print "obj_con_transit 80")
	(set obj_con_transit 80)

	(print "game_save_no_timeout 28")
	(game_save_no_timeout) ;checkpoint

	(sleep_until
		(and
			;wait til tram is stopped
			(= (device_get_position dm_transit) 1)
			;wait til enemies are dead or player runs past encounter
			(or
				(= (ai_living_count gr_transit_e33_docking_station) 0)
				(volume_test_players tv_post_e33_lead_to_grav)
			)
		)
		1
	)
	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_transit_hangar_johnson)
)

;==============
;encounter 34
;==============

(script dormant e34
	(wake vo_hangar_enter)
	(sleep_until (volume_test_players tv_transit_e34) 1)
	(print "******* encounter 34 *******")
	(ai_place gr_transit_e34_hangar)
	(wake e34_johnson_objective)
	(wake hangar_vign)
	(wake beat3_exit_nav_blip)

	(sleep_until (volume_test_players tv_transit_e34_a) 1)
	(print "game_save_no_timeout at start of hangar")
	(game_save_no_timeout) ;checkpoint


	(sleep_until (<= (ai_living_fraction gr_transit_e34_hangar) .5) 1)
	(print "half the covenant in the hanger are dead")
	(game_save_no_timeout) ;checkpoint
)

(script dormant beat3_exit_nav_blip
	(sleep_until (volume_test_players tv_transit_player_in_hangar) 1)
	(f_blip_flag fl_beat3_exit 0)

	(sleep_until (volume_test_players tv_space_trans_to_1) 1)
	(f_unblip_flag fl_beat3_exit)
)


(script dormant e34_johnson_objective
	(sleep_until (volume_test_players tv_transit_hangar_follow) 1)

	(ai_set_objective ai_johnson obj_transit_hangar_johnson)
)

;==============
;hangar vignette
;==============

(global boolean b_hangar_wraith_start 0)
(global boolean b_hangar_johnson_start 0)
(global boolean b_hangar_johnson_in_pos 0)
(global boolean b_johnson_shot_barrels 0)
(global short s_ensure_explosion_time (game_ticks_from_seconds 1))
(global boolean b_wraith_in_position 0)
(global boolean b_hangar_vignette_over 0)

;johnson runs up to his shooting position and waits for the tank to be next to the barrels and then he shoots it
(script command_script cs_hangar_vign_johnson
	(cs_enable_targeting true)
	(cs_enable_moving true)
	(sleep_until (= b_hangar_johnson_start 1) 1)
	(cs_go_to ps_hangar_vign_johnson/p3_fuel_rod)
	(unit_add_equipment ai_current_actor psp_johnson_flak true true)

	(sleep_until (= b_wraith_in_position 1) 1)
	(print "hangar vign - accurate cue placed")
	(ai_place_cue fc_johnson_accurate)

	;start shooting at things
	(sleep_until
		(begin
			(cond
				((barrel_visible_and_alive cr_hangar_vign_barrel00) 				(cs_shoot true cr_hangar_vign_barrel00))
				((barrel_visible_and_alive cr_hangar_vign_barrel01) 				(cs_shoot true cr_hangar_vign_barrel01))
				((barrel_visible_and_alive cr_hangar_vign_barrel02) 				(cs_shoot true cr_hangar_vign_barrel02))
				((barrel_visible_and_alive cr_hangar_vign_barrel03) 				(cs_shoot true cr_hangar_vign_barrel03))
				((>= (object_get_health (unit_get_vehicle sq_e34_hangar_vign)) 0) 	(cs_shoot true sq_e34_hangar_vign))
			)
			(= (ai_living_count sq_e34_hangar_vign) 0);exit condition
		)
		10;run every ticks
	)
	(ai_remove_cue fc_johnson_accurate)
	(set b_hangar_vignette_over 1)
	(print "hangar vign - cue placed removed")
)

(script static boolean (barrel_visible_and_alive (object barrel))
	(and
		(>= (object_get_health barrel) 0)
		(objects_can_see_object ai_johnson barrel 15)
		(volume_test_object tv_hangar_vign_j_shoot ai_johnson)
		(!= (volume_test_objects tv_hangar_vign_j_dont_shoot (players)) 1)
	)
)

(script dormant hangar_vign_barrel_explosion
	(object_create_if_necessary cr_hangar_vign_barrel00)
	(object_create_if_necessary cr_hangar_vign_barrel01)
	(object_create_if_necessary cr_hangar_vign_barrel02)
	(object_create_if_necessary cr_hangar_vign_barrel03)

	(sleep_until
		(or
			(<= (object_get_health cr_hangar_vign_barrel00) 0)
			(<= (object_get_health cr_hangar_vign_barrel01) 0)
			(<= (object_get_health cr_hangar_vign_barrel02) 0)
			(<= (object_get_health cr_hangar_vign_barrel03) 0)
		)
		1
	)
	(print "barrels - check wraith")
	(if
		(< (objects_distance_to_flag (ai_vehicle_get sq_e34_hangar_vign) fl_hangar_vign_barrels_fx) 16) ;within 50 meters or 16 world units
		;then
		(begin
			(print "barrels - damage wraith")
			(object_damage_damage_section (ai_vehicle_get sq_e34_hangar_vign/elite_d) "weakspot" 10000)
		)
		;else
		(print "barrels - wraith too far away")
	)

	(print "barrels destroyed")
	;applies visual effect
	(effect_new "fx/fx_library/explosions/covenant_explosion_medium/cov_crate_explosion_medium" fl_hangar_vign_barrels_fx)
	;applies damage effect
	(effect_new "fx/vignettes/e30/johnson_seraph_shootdown_force" fl_hangar_vign_barrels_fx)

)

;wraith drive about halfway towards the heros fires then drives closer ending next to the barrels
(script command_script cs_hangar_vign_wraith_driver_start
	(cs_enable_targeting false)
	(cs_enable_moving false)
	(sleep_until (volume_test_players tv_transit_player_in_hangar) 1)
	;start moving if player shoots wraith through big window
	(cs_abort_on_damage true)
	(sleep_until (= b_hangar_wraith_start 1) 1)
)

;wraith gunner shoots suppressing fire around the heros
(script command_script cs_hangar_vign_wraith_gunner_start
	(cs_enable_targeting false)
	(cs_enable_moving false)
	(sleep_until (volume_test_players tv_transit_player_in_hangar) 1)
	;start moving if player shoots wraith through big window
	(cs_abort_on_damage true)
	(sleep_until (= b_hangar_wraith_start 1) 1)
)

;moves wraith next to the barrels
(script command_script cs_hangar_vign_wraith_driver_move
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(cs_go_to ps_hangar_vign_johnson/p1_wraith_move)
	(set b_wraith_in_position 1)
	(print "b_wraith_in_position is ready")
	(sleep_forever)
)

;hero moment for johnson - wraith approaches and fires at heros and johnson snipes barrels that will blow up the tank
(script dormant hangar_vign
	(sleep_until (volume_test_players tv_transit_player_in_hangar) 1)
	(wake hangar_vign_barrel_explosion)
	(wake hangar_vign_trigger_johnson_cs)

	(sleep_until
		(or
			(volume_test_players tv_transit_hangar_fallback)
			(= (ai_living_count sq_e34_a) 0)
		)
		1
	)
	(set b_hangar_johnson_start 1)

	(sleep_until (volume_test_players tv_hangar_vign) 1)
	(set b_hangar_wraith_start 1)

	(cs_run_command_script sq_e34_hangar_vign/elite_d cs_hangar_vign_wraith_driver_move)

	(sleep_until (= b_hangar_vignette_over 1) 1)
	(object_can_take_damage ai_johnson)

	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_johnson_follow)
)

(script dormant hangar_vign_trigger_johnson_cs
	(sleep_until (volume_test_object tv_transit_player_in_hangar ai_johnson) 1)
	(object_cannot_take_damage ai_johnson)
	(cs_run_command_script ai_johnson cs_hangar_vign_johnson)
)

;====================================================================================================================================================================================================
; transit scripts =====================================================================================================================================================================================
;====================================================================================================================================================================================================

;transit speeds
(global real r_transit_powered_vert 	1)
(global real r_transit_powered_normal 	.22)
(global real r_transit_powered_slow 	.10)
(global real r_transit_powered_slower 	.08)
(global real r_transit_last_speed 		0)

;transit debug
(global real r_test_debug_tram_position 0)
(global real r_test_debug_tram_power 0)
(global real r_test_debug_tram_control_pos 0)

;transit positions
(global real r_ini_station_undock_pos 	0.028)
(global real r_tram_door2_open_pos 		0.110)
(global real r_tram_door1_close_pos 	0.120)
(global real r_tram_e26_slow_pos		0.128)
(global real r_tram_door2_close_pos 	0.148)
(global real r_e26_jump_prep_pos 		0.150)
(global real r_e26_jump_ready_pos 		0.155)
(global real r_e26_pos_change_pos 		0.163)
(global real r_tram_door3_open_pos 		0.167)
(global real r_tram_door4_open_pos 		0.184)
(global real r_tram_door3_close_pos 	0.192)
(global real r_tram_door4_close_pos 	0.214)
(global real r_e27_kamikaze_spawn_pos 	0.215)
(global real r_e27_grunts_behind_pos	0.231)
(global real r_e27_kamikaze_prep_pos 	0.238)
(global real r_e27_grunts_stay_pos		0.241)
(global real r_e27_kamikaze_ready_pos 	0.248)
(global real r_tram_door5_open_pos 		0.253)
(global real r_tram_door6_open_pos 		0.270)
(global real r_tram_door5_close_pos 	0.281)
(global real r_speed_up_to_dome_pos		0.284)
(global real r_tram_door6_close_pos 	0.311)
(global real r_dome_station_vign_pos	0.361)
(global real r_dome_station_vo_pos		0.365)
(global real r_dome_station_dock_pos 	0.374)
(global real r_dome_station_stop 		0.530)
(global real r_dome_station_undock 		0.614)
(global real r_tram_door7_open_pos 		0.663)
(global real r_tram_door8_open_pos 		0.685)
(global real r_tram_door7_close_pos 	0.699)
(global real r_tram_e31_slow_pos		0.702)
(global real r_tram_door8_close_pos 	0.721)
(global real r_e31_jump_ready_pos 		0.751)
(global real r_tram_door9_open_pos 		0.758)
(global real r_tram_door10_open_pos 	0.768)
(global real r_tram_door9_close_pos 	0.777)
(global real r_tram_door10_close_pos 	0.797)
(global real r_e32_jump_ready_pos		0.802)
(global real r_tram_door11_open_pos 	0.814)
(global real r_tram_door12_open_pos 	0.830)
(global real r_tram_door11_close_pos 	0.840)
(global real r_speed_up_to_hangar_pos	0.838)
(global real r_tram_door12_close_pos 	0.879)
(global real r_hangar_station_dock_pos 	0.894)

;trigger booleans
(global boolean b_e26_jump_prep 0)
(global boolean b_e26_jump_ready 0)
(global boolean b_e26_pos_change 0)
(global boolean b_e27_grunts_behind 0)
(global boolean b_e27_grunts_stay 0)
(global boolean b_e27_kamikaze_spawn 0)
(global boolean b_e27_kamikaze_prep 0)
(global boolean b_e27_kamikaze_ready 0)
(global boolean b_e31_jump_ready 0)
(global boolean b_e32_jump_ready 0)

;(script dormant test_debug_tram_position
;	(debug_scripting_globals 1)
;	(debug_scripting_variable 'r_test_debug_tram_position' true)
;	(debug_scripting_variable 'r_test_debug_tram_power' true)
;	(debug_scripting_variable 'r_test_debug_tram_control_pos' true)
;	;loop while
;	(sleep_until
;		(begin
;			(set r_test_debug_tram_position (device_get_position dm_transit))
;			(set r_test_debug_tram_power (device_get_power dm_transit))
;			(set r_test_debug_tram_control_pos (device_get_position dc_tram_button))
;			(= (device_get_position dm_transit) 1) ;exit condition
;		)
;		1;run every 1 tick
;	)
;	(print "test_debug_tram_position ended")
;)

(script dormant tram_attachments_setup
	(print "tram tram_attachments_setup")
	(objects_attach dm_transit button dc_tram_button "")
)

(script static void tram_button_control
	(f_blip_object dm_transit 0)
	(device_set_power dc_tram_button 1)
	(sleep_until (= (device_get_position dc_tram_button) 1) 1)
	;(device_group_set dc_brute_emerg_cell_control dg_brute_emerg_cell_pos 1)
	;(device_group_set dc_brute_emerg_cell_control dg_brute_emerg_cell_pow 0)
	(device_set_position_immediate dc_tram_button 0)
	(device_set_power dc_tram_button 0)
	(f_unblip_object dm_transit)
)

(script dormant beat_3_start_transit_control
	(wake migrate_tram_jump_squads_loop)
	(wake beat3_transit_progress_part_1)
	(wake beat3_transit_progress_part_2)
	(transit_control_part_1)
	(transit_control_part_2)
)

(script static void transit_control_part_1
	;(wake test_debug_tram_position)
	(player_set_profile start_profile_coop_respawn_tram)
	(print "tram ready")
	(tram_button_control)

	(print "game_save_no_timeout 30")
	(game_save_no_timeout) ;checkpoint

	(wake vo_transit_hydro_leaving)

	(wake leaving_transit_station_johnson_tele)

	; set device position to 1, to keep it continuing towards the end
	(device_set_position dm_transit 1)

	;undock from station 1 and go to normal speed after vertical movement is completed
	(undock_init_station)
	(tram_normal_speed)

	; slow down tram for encounter 26 - section 1
	(sleep_until (>= (device_get_position dm_transit) r_tram_e26_slow_pos) 1)
	(tram_slow_speed)
)

(script dormant leaving_transit_station_johnson_tele
	;temp to move johnson on tram
	(bring_johnson_on_tram)
	(cs_run_command_script ai_johnson cs_kill_command_script)
)

(script static void transit_control_part_2
	;(wake test_debug_tram_position)
	(wake vo_transit_dome_stop_trigger)

	;speed up to dome station
	(sleep_until (>= (device_get_position dm_transit) r_speed_up_to_dome_pos) 1)
	(tram_normal_speed)

	(dock_dome_station)
	(tram_stop_speed)

	(wake vo_transit_dome_dawdle)

	;wait til dome station encounter is complete
	(sleep_until (= b_dome_defend_complete 1) 1)
	(print "tram ready")
	(tram_button_control)

	(wake leaving_dome_station_johnson_tele)

	(undock_dome_station)
	(tram_normal_speed)

	(print "game_save_no_timeout 32")
	(game_save_no_timeout) ;checkpoint

	; slow down tram for encounter 31 - section 3
	(sleep_until (>= (device_get_position dm_transit) r_tram_e31_slow_pos) 1)
	(tram_slower_speed)

	;speed up to hangar station
	(sleep_until (>= (device_get_position dm_transit) r_speed_up_to_hangar_pos) 1)
	(tram_normal_speed)

	(dock_hangar_station)

	(set b_tram_ride_over 1)

	(print "game_save_no_timeout 33")
	(game_save_no_timeout) ;checkpoint
)

(script dormant leaving_dome_station_johnson_tele
	;temp to move johnson on tram
	(bring_johnson_on_tram)
	(cs_run_command_script ai_johnson cs_kill_command_script)
)

(script dormant vo_transit_dome_stop_trigger
	(sleep_until (>= (device_get_position dm_transit) r_dome_station_vo_pos) 1)
	(wake vo_transit_dome_stop)
)

(script static void undock_init_station
	(tram_docking_speed)
	(sleep_until (>= (device_get_position dm_transit) r_ini_station_undock_pos) 1)
)

(script static void dock_dome_station
	(print "waiting for dome station does pos")
	(sleep_until (>= (device_get_position dm_transit) r_dome_station_dock_pos) 1)
	(tram_docking_speed)
	(print "waiting for dome station stop pos")
	(sleep_until (>= (device_get_position dm_transit) r_dome_station_stop) 1)
)

(script static void dock_hangar_station
	(sleep_until (>= (device_get_position dm_transit) r_hangar_station_dock_pos) 1)
	(tram_docking_speed)
)

(script static void undock_dome_station
	(tram_docking_speed)
	(sleep_until (>= (device_get_position dm_transit) r_dome_station_undock) 1)
)

(script static void tram_normal_speed
	(tram_acceleration r_transit_powered_normal)
	(device_set_power dm_transit r_transit_powered_normal)
	(print "tram normal speed")
)

(script static void tram_slow_speed
	(tram_acceleration r_transit_powered_slow)
	(device_set_power dm_transit r_transit_powered_slow)
	(print "tram slow speed")
)

(script static void tram_slower_speed
	(tram_acceleration r_transit_powered_slower)
	(device_set_power dm_transit r_transit_powered_slower)
	(print "tram slower speed")
)

(script static void tram_stop_speed
	(device_set_power dm_transit 0)
	(print "tram stopped")
)

(script static void tram_docking_speed
	(tram_docking_acceleration r_transit_powered_vert)
	(device_set_power dm_transit r_transit_powered_vert)
	(print "tram slower docking speed")
)

;using haloscript for the acceleration of the power to slow tram dowm. was not getting the results intended using device_animate_position or device_set_position_transition_time
(script static void (tram_acceleration (real r_new_tram_speed))
	(set r_transit_last_speed (device_get_power dm_transit))
	(if ;the current power of the tram is greater than new tram speed
		(> (device_get_power dm_transit) r_new_tram_speed)
		;then slow down gradually to normal power
		(begin
			(print "tram begin slow down")
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .90))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .80))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .70))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .60))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .50))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .40))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .30))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .20))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .10))
			(sleep (game_ticks_from_seconds .5))
		)
		;else the current power of the tram is less than new tram speed
		(begin
			(print "tram begin speed up")
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .10))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .20))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .30))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .40))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .50))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .60))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .70))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .80))
			(sleep (game_ticks_from_seconds .5))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .90))
			(sleep (game_ticks_from_seconds .5))
		)
	)
)

(script static void (tram_docking_acceleration (real r_new_tram_speed))
	(set r_transit_last_speed (device_get_power dm_transit))
	(if ;the current power of the tram is greater than new tram speed
		(> (device_get_power dm_transit) r_new_tram_speed)
		;then slow down gradually to normal power
		(begin
			(print "tram begin slow down")
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .90))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .80))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .70))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .60))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .50))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .40))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .30))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .20))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_slow_down_percent r_new_tram_speed .10))
			(sleep (game_ticks_from_seconds .2))
		)
		;else the current power of the tram is less than new tram speed
		(begin
			(print "tram begin speed up")
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .10))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .20))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .30))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .40))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .50))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .60))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .70))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .80))
			(sleep (game_ticks_from_seconds .2))
			(device_set_power dm_transit (r_speed_up_percent r_new_tram_speed .90))
			(sleep (game_ticks_from_seconds .2))
		)
	)
)

(script static real (r_slow_down_percent (real r_new_tram_speed) (real r_percent))
	; r_new_tram_speed + ((r_transit_last_speed - r_new_tram_speed) * r_percent)
	(+
		r_new_tram_speed
		(*
			(- r_transit_last_speed r_new_tram_speed)
			r_percent
		)
	)
)

(script static real (r_speed_up_percent (real r_new_tram_speed) (real r_percent))
	; r_transit_last_speed + ((r_new_tram_speed - r_transit_last_speed) * r_percent)
	(+
		r_transit_last_speed
		(*
			(- r_new_tram_speed r_transit_last_speed)
			r_percent
		)
	)
)

(script dormant dome_station_transit_control_catch_up
	(print "dome station insertion point catch up")
	(device_set_position_immediate dm_transit 0.280)
	(device_set_power dm_transit 0)
	(print "tram stopped")
	(wake tram_attachments_setup)
	(sleep_until (volume_test_players tv_tram) 1)
	(device_set_position_immediate  dm_transit_large_door6 1)
	(sleep (game_ticks_from_seconds 20))
	(device_set_position dm_transit 1)
	(device_set_power dm_transit 1)
	(tram_slow_speed)

	(wake migrate_tram_jump_squads_loop)
	(wake beat3_transit_progress_part_2)
	(transit_control_part_2)
)

;updating booleans when the tram reaches certain points
(script dormant beat3_transit_progress_part_1

	;open second door to section a
	(sleep_until (>= (device_get_position dm_transit) r_tram_door2_open_pos) 1)
	(object_create_folder of_transit_section_b)
	(device_set_position dm_transit_large_door2 1)

	;close door 1
	(sleep_until (>= (device_get_position dm_transit) r_tram_door1_close_pos) 1)
	(device_set_position dm_transit_large_door1 0)

	(wake transit_station_cleanup)

	;close door 2
	(sleep_until (>= (device_get_position dm_transit) r_tram_door2_close_pos) 1)
	(device_set_position dm_transit_large_door2 0)

	;encounter 26
	(sleep_until (>= (device_get_position dm_transit) r_e26_jump_prep_pos) 1)
	(set b_e26_jump_prep 1)

	(sleep_until (>= (device_get_position dm_transit) r_e26_jump_ready_pos) 1)
	(set b_e26_jump_ready 1)

	(sleep_until (>= (device_get_position dm_transit) r_e26_pos_change_pos) 1)
	(set b_e26_pos_change 1)

	;open doors to section b
	(sleep_until (>= (device_get_position dm_transit) r_tram_door3_open_pos) 1)
	(device_set_position dm_transit_large_door3 1)

	(sleep_until (>= (device_get_position dm_transit) r_tram_door4_open_pos) 1)
	(object_create_folder of_dome_station)
	(device_set_position dm_transit_large_door4 1)

	;close door 3
	(sleep_until (>= (device_get_position dm_transit) r_tram_door3_close_pos) 1)
	(device_set_position dm_transit_large_door3 0)

	(wake transit_section_a_cleanup)

	;close door 4
	(sleep_until (>= (device_get_position dm_transit) r_tram_door4_close_pos) 1)
	(device_set_position dm_transit_large_door4 0)

	(sleep_until (>= (device_get_position dm_transit) r_e27_kamikaze_spawn_pos) 1)
	(set b_e27_kamikaze_spawn 1)

	;encounter 27
	(sleep_until (>= (device_get_position dm_transit) r_e27_grunts_behind_pos) 1)
	(set b_e27_grunts_behind 1)

	(sleep_until (>= (device_get_position dm_transit) r_e27_kamikaze_prep_pos) 1)
	(set b_e27_kamikaze_prep 1)

	(sleep_until (>= (device_get_position dm_transit) r_e27_grunts_stay_pos) 1)
	(set b_e27_grunts_stay 1)

	(sleep_until (>= (device_get_position dm_transit) r_e27_kamikaze_ready_pos) 1)
	(set b_e27_kamikaze_ready 1)

	;open door 1 to dome station
	(sleep_until (>= (device_get_position dm_transit) r_tram_door5_open_pos) 1)
	(device_set_position dm_transit_large_door5 1)
)

(script dormant beat3_transit_progress_part_2
	;open door 2 to dome station
	(sleep_until (>= (device_get_position dm_transit) r_tram_door6_open_pos) 1)
	(object_create_folder of_transit_section_c)
	(device_set_position dm_transit_large_door6 1)

	;close door 5
	(sleep_until (>= (device_get_position dm_transit) r_tram_door5_close_pos) 1)
	(device_set_position dm_transit_large_door5 0)

	(wake transit_section_b_cleanup)

	;close door 6
	(sleep_until (>= (device_get_position dm_transit) r_tram_door6_close_pos) 1)
	(device_set_position dm_transit_large_door6 0)

	;open doors to section c
	(sleep_until (>= (device_get_position dm_transit) r_tram_door7_open_pos) 1)
	(set s_music_trigger_e30 240)
	(device_set_position dm_transit_large_door7 1)

	(sleep_until (>= (device_get_position dm_transit) r_tram_door8_open_pos) 1)
	(object_create_folder of_transit_section_d)
	(device_set_position dm_transit_large_door8 1)

	;close door 7
	(sleep_until (>= (device_get_position dm_transit) r_tram_door7_close_pos) 1)
	(device_set_position dm_transit_large_door7 0)

	(wake dome_station_cleanup)

	;close door 8
	(sleep_until (>= (device_get_position dm_transit) r_tram_door8_close_pos) 1)
	(device_set_position dm_transit_large_door8 0)

	;encounter 31
	(sleep_until (>= (device_get_position dm_transit) r_e31_jump_ready_pos) 1)
	(set b_e31_jump_ready 1)

	;open doors to section d
	(sleep_until (>= (device_get_position dm_transit) r_tram_door9_open_pos) 1)
	(device_set_position dm_transit_large_door9 1)

	(sleep_until (>= (device_get_position dm_transit) r_tram_door10_open_pos) 1)
	(device_set_position dm_transit_large_door10 1)

	;close door 9
	(sleep_until (>= (device_get_position dm_transit) r_tram_door9_close_pos) 1)
	(device_set_position dm_transit_large_door9 0)

	(wake transit_section_c_cleanup)

	;close door 10
	(sleep_until (>= (device_get_position dm_transit) r_tram_door10_close_pos) 1)
	(device_set_position dm_transit_large_door10 0)

	;encounter 32
	(sleep_until (>= (device_get_position dm_transit) r_e32_jump_ready_pos) 1)
	(set b_e32_jump_ready 1)

	;open doors to last stop
	(sleep_until (>= (device_get_position dm_transit) r_tram_door11_open_pos) 1)
	(object_create_folder of_hangar_station)
	(object_create_folder of_hangar_bottom)
	(device_set_position dm_transit_large_door11 1)

	(sleep_until (>= (device_get_position dm_transit) r_tram_door12_open_pos) 1)
	(device_set_position dm_transit_large_door12 1)

	;close door 11
	(sleep_until (>= (device_get_position dm_transit) r_tram_door11_close_pos) 1)
	(device_set_position dm_transit_large_door11 0)

	(wake transit_section_d_cleanup)

	;close door 12
	(sleep_until (>= (device_get_position dm_transit) r_tram_door12_close_pos) 1)
	(device_set_position dm_transit_large_door12 0)
)

;transit clean up scripts
(script dormant transit_station_cleanup
	(sleep_until (<= (device_get_position dm_transit_large_door1) 0) 1)

	(print "gr_cleanup_e23_to_e25 clean up")
	(ai_erase gr_cleanup_e23_to_e25)

	(print "blam object cleanup  - transit station")
	(object_destroy_folder of_transit_station)

	(print "garbage_collect_now at transit_station_cleanup")
	(garbage_collect_now)
)

(script dormant transit_section_a_cleanup
	(sleep_until (<= (device_get_position dm_transit_large_door3) 0) 1)

	(print "gr_transit_e26_section1 clean up")
	(ai_erase gr_transit_e26_section1)

	(print "blam object cleanup  - transit section a")
	(object_destroy_folder of_transit_section_a)

	(print "garbage_collect_now at transit_section_a_cleanup")
	(garbage_collect_now)
)

(script dormant transit_section_b_cleanup
	(sleep_until (<= (device_get_position dm_transit_large_door5) 0) 1)

	(print "gr_transit_e27_section2 clean up")
	(ai_erase gr_transit_e27_section2)

	(print "blam object cleanup  - transit section b")
	(object_destroy_folder of_transit_section_b)

	(print "garbage_collect_now at transit_section_b_cleanup")
	(garbage_collect_now)
)

(script dormant dome_station_cleanup
	(sleep_until (<= (device_get_position dm_transit_large_door7) 0) 1)

	(print "gr_cleanup_e28_to_e30 clean up")
	(ai_erase gr_cleanup_e28_to_e30)

	(print "blam object cleanup  - dome_station")
	(object_destroy_folder of_dome_station)

	(print "garbage_collect_now at dome_station_cleanup")
	(garbage_collect_now)
)

(script dormant transit_section_c_cleanup
	(sleep_until (<= (device_get_position dm_transit_large_door9) 0) 1)

	(print "gr_transit_e31_section_3 clean up")
	(ai_erase gr_transit_e31_section_3)

	(print "blam object cleanup  - transit section c")
	(object_destroy_folder of_transit_section_c)

	(print "garbage_collect_now at transit_section_c_cleanup")
	(garbage_collect_now)
)

(script dormant transit_section_d_cleanup
	(sleep_until (<= (device_get_position dm_transit_large_door11) 0) 1)

	(print "gr_transit_e32_section_4 clean up")
	(ai_erase gr_transit_e32_section_4)

	(print "blam object cleanup  - transit section d")
	(object_destroy_folder of_transit_section_d)

	(print "garbage_collect_now at transit_section_d_cleanup")
	(garbage_collect_now)
)

(script command_script cs_tram_test_script
	(begin_random
		(cs_go_to ps_tram_test/p0)
		(cs_go_to ps_tram_test/p1)
		(cs_go_to ps_tram_test/p2)
		(cs_go_to ps_tram_test/p3)
		(cs_go_to ps_tram_test/p4)
	)
	(cs_go_to ps_tram_test/p6)
	(cs_go_to ps_tram_test/p5)
)


;====================================================================================================================================================================================================
;point of no return scripts
;====================================================================================================================================================================================================

(script dormant init_beat1_object_placement
	(print "placing beat 1 object folders")
	(object_create_folder of_before_hydro_entry)
	(object_create_folder of_garden)
	(object_create_folder of_overlook)
	(if (coop_players_2) (object_create_folder of_before_hydro_entry_coop_equip))
)

(script dormant init_beat1_mid_object_placement
	(object_create_folder of_garden)
	(object_create_folder of_overlook)
)

(script dormant init_beat2_object_placement
	(object_create_folder of_before_grav_b_down)
	(sleep_until (volume_test_players tv_ponr_gravlift_b_below) 1)
	(object_create_folder of_garden)
	(object_create_folder of_overlook)
	(object_create_folder of_garden_b_bridge)
	(if (coop_players_2) (object_create_folder of_garden_b_bridge_coop_equip))
)

(script dormant init_beat2_mid_object_placement
	(object_create_folder of_garden)
	(object_create_folder of_overlook)
)

(script dormant init_beat3_object_placement
	(object_create_folder of_transit_station)
	(object_create_folder of_transit_section_a)
)

(script dormant point_of_no_return_beat1
	(wake ensure_johnson_in_hydro_entry)
	;sleep until first player is in garden a room
	(sleep_until (volume_test_players tv_ponr_garden) 1)
	;close door
	(wake beat1_doors_updates)
	;teleport players not on the right side of the door
	(ponr_player_in_2_tv_tele tv_ponr_before_hydro_entry1 tv_ponr_before_hydro_entry2 fl_ponr_tele_b_garden_p0 fl_ponr_tele_b_garden_p1 fl_ponr_tele_b_garden_p2 fl_ponr_tele_b_garden_p3)
	(wake ponr_johnson_garden_a)
	;blam object cleanup that is behind the door and can no longer be seen by the player
	(print "cleaning up before hydro entry encounters and objects")
	(object_destroy_folder of_before_hydro_entry)
	(ai_erase gr_beat1_e1_to_e2_cleanup)
	(ai_erase gr_beat1_e3_to_e4_cleanup)
	(ai_erase gr_beat1_e5_to_e7_cleanup)
	(object_create_folder of_garden_b_bridge)
	(if (coop_players_2) (object_create_folder of_garden_b_bridge_coop_equip))

	(wake ensure_johnson_in_bridge1)

	;garbage collecting
	;(sleep (game_ticks_from_seconds 1))
	;(print "garbage_collect_now at wind a")
	;(garbage_collect_now)

	;sleep until first player is at the top of grav lift b room
	(sleep_until (volume_test_players tv_ponr_gravlift_b_above) 1)
	;teleport players not in or above gravlift
	(ponr_player_not_in_2_tv_tele tv_ponr_gravlift_b_above tv_ponr_gravlift_b_shaft fl_ponr_tele_gravlift_b_p0 fl_ponr_tele_gravlift_b_p1 fl_ponr_tele_gravlift_b_p2 fl_ponr_tele_gravlift_b_p3)
	(wake ponr_johnson_gravlift_b_up)
	(object_create_folder of_before_grav_b_down)
	(ai_erase gr_beat1_e8_hydro_entry_room)
	(ai_erase gr_beat1_e9_to_e10_cleanup)
	(ai_erase gr_beat1_e11_hydro_bridge)
	(set b_beat1_johnson_bridge_check 1);no longer need to check if johnson falls off the bridge

	;if more aggressive object count is needed this lines can be commented out, but objects will not keep their previous locations when created again when player backtracks
	;(object_destroy_folder of_garden)
	;(object_destroy_folder of_overlook)

	;garbage collecting
	(print "garbage_collect_now at gravlift b up")
	(garbage_collect_unsafe) ;player will not be able to see any potential garbage in the big grav lift

	(wake ensure_johnson_in_control)
)

(script dormant ponr_johnson_garden_a
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)
	(ponr_johnson_in_2_tv_tele tv_ponr_before_hydro_entry1 tv_ponr_before_hydro_entry2 fl_ponr_tele_b_garden_j)
)

(script dormant ponr_johnson_gravlift_b_up
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)
	(ponr_johnson_not_in_2_tv_tele tv_ponr_gravlift_b_above tv_ponr_gravlift_b_shaft fl_ponr_tele_gravlift_b_j_up)
)

(script dormant point_of_no_return_beat2
	;sleep until first player is at the bottom of grav lift b room
	(sleep_until (volume_test_players tv_ponr_gravlift_b_below) 1)
	;teleport players not in or above gravlift
	(ponr_player_not_in_2_tv_tele tv_ponr_gravlift_b_below tv_ponr_gravlift_b_shaft fl_ponr_tele_gravlift_b_p0 fl_ponr_tele_gravlift_b_p1 fl_ponr_tele_gravlift_b_p2 fl_ponr_tele_gravlift_b_p3)
	(wake ponr_johnson_gravlift_b_down)
	(object_destroy_folder of_before_grav_b_down)

	;if more aggressive object count is needed this lines can be commented out, but objects will not keep their previous locations when created again when player backtracks
	;(object_create_folder of_garden)
	;(object_create_folder of_overlook)

	;garbage collecting
	(print "garbage_collect_now at gravlift b down")
	(garbage_collect_unsafe) ;player will not be able to see any potential garbage in the big grav lift

	(wake ensure_johnson_in_bridge2)
	(wake ensure_johnson_in_garden_hallway)

	(sleep_until (volume_test_players tv_ponr_tele_a_garden) 1)
	(ponr_player_not_in_2_tv_tele tv_ponr_tele_a_garden tv_ponr_garden_hallway fl_ponr_tele_a_garden_p0 fl_ponr_tele_a_garden_p1 fl_ponr_tele_a_garden_p2 fl_ponr_tele_a_garden_p3)
	(wake ponr_johnson_garden_a_backtrack)
	(wake beat2_after_garden_door_update)
	(set b_beat2_johnson_bridge_check 1);no longer need to check if johnson falls off the bridge

	(object_create_folder of_wing_c)
	;garden b shields
	(object_create sc_cov_port_shield_g2_1)
	(object_create sc_cov_port_shield_g2_2)
	(object_destroy_folder of_garden_b_bridge)
	(ai_erase gr_beat2_e14_gravlift_redux)
	(ai_erase gr_beat2_e15_hydro_bridge_redux)
	(ai_erase gr_beat2_e16_garden2_redux)

	(wake ensure_johnson_in_hydro_entry_redux)

	(sleep_until (volume_test_players tv_create_rr_objects) 1)
	(object_create_folder of_restrespite)

	(wake ensure_johnson_in_rr)

	;sleep until first player is at the bottom of transit grav lift
	(sleep_until (volume_test_players tv_ponr_transit_grav_below) 1)
	(ponr_player_not_in_2_tv_tele  tv_ponr_transit_grav_below tv_ponr_transit_grav_shaft fl_ponr_tele_transit_b_p0 fl_ponr_tele_transit_b_p1 fl_ponr_tele_transit_b_p2 fl_ponr_tele_transit_b_p3)
	(wake ponr_johnson_transit_grav)
	(object_destroy_folder of_restrespite)
	(object_destroy_folder of_overlook)
	(object_destroy_folder of_garden)
	(object_destroy_folder of_wing_c)
	(object_create_folder of_transit_station)
	(object_create_folder of_transit_section_a)
	(ai_erase gr_beat2_encounters)



	;garbage collecting
	(print "garbage_collect_now at transit gravlift down")
	(garbage_collect_unsafe) ;player will not be able to see any potential garbage in the big grav lift

)

(script dormant ponr_johnson_gravlift_b_down
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)
	(ponr_johnson_not_in_2_tv_tele tv_ponr_gravlift_b_below tv_ponr_gravlift_b_shaft fl_ponr_tele_gravlift_b_j_down)
)

(script dormant ponr_johnson_garden_a_backtrack
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)
	(ponr_johnson_not_in_2_tv_tele tv_ponr_tele_a_garden tv_ponr_garden_hallway fl_ponr_tele_a_garden_j)
)

(script dormant ponr_johnson_transit_grav
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)
	(ponr_johnson_not_in_2_tv_tele tv_ponr_transit_grav_below tv_ponr_transit_grav_shaft fl_ponr_tele_transit_b_j)
)

(script dormant ensure_johnson_in_hydro_entry
	(print "ensure_johnson_in_hydro_entry has started")
	(ensure_johnson_in_encounter tv_hydro_entry_ensure tv_ponr_garden fl_hydro_entry_ensure)
	(print "ensure_johnson_in_hydro_entry has ended")
)

(script dormant ensure_johnson_in_bridge1
	(print "ensure_johnson_in_bridge1 has started")
	(ensure_johnson_in_encounter tv_bridge1_ensure tv_ponr_gravlift_b_shaft fl_bridge1_ensure)
	(print "ensure_johnson_in_bridge1 has ended")
)

(script dormant ensure_johnson_in_control
	(print "ensure_johnson_in_control has started")
	(ensure_johnson_in_encounter tv_control_encounter tv_ponr_gravlift_b_below fl_control_ensure)
	(print "ensure_johnson_in_control has ended")
)

(script dormant ensure_johnson_in_bridge2
	(print "ensure_johnson_in_bridge2 has started")
	(ensure_johnson_in_encounter tv_bridge2_ensure tv_ponr_garden_hallway fl_bridge2_ensure)
	(print "ensure_johnson_in_bridge2 has ended")
)

;try to teleport johnson without the player being able to see before the point of no return
(script dormant ensure_johnson_in_garden_hallway
	(print "ensure_johnson_in_garden_hallway has started")
	(ensure_johnson_in_encounter tv_ponr_garden_hallway tv_ponr_tele_a_garden fl_garden_ensure)
	(print "ensure_johnson_in_garden_hallway has ended")
)

(script dormant ensure_johnson_in_hydro_entry_redux
	(print "ensure_johnson_in_hydro_entry_redux has started")
	(ensure_johnson_in_encounter tv_hydro_entry_redux_ensure tv_rr_ensure_j_is_close fl_hydro_entry_redux_ensure)
	(print "ensure_johnson_in_hydro_entry_redux has ended")
)

(script dormant ensure_johnson_in_rr
	(print "ensure_johnson_in_rr has started")
	(ensure_johnson_in_encounter tv_rr_ensure_j_is_close tv_ponr_transit_grav_shaft fl_ensure_j_tele_rr)
	(print "ensure_johnson_in_rr has ended")
)

(script dormant ensure_johnson_in_dome_station
	(print "ensure_johnson_in_dome_station has started")
	(sleep_until
		(and
			;player is at the top of the dome station
			(volume_test_players tv_transit_e30_ensure)
			;johnson is on the left or right side
			(or
				(volume_test_object tv_transit_e30_ensure_left ai_johnson)
				(volume_test_object tv_transit_e30_ensure_right ai_johnson)
			)
		)
		1
	)
	;teleport to the left or right side
	(cond
		((volume_test_object tv_transit_e30_ensure_left ai_johnson) 	(ensure_johnson_in_encounter tv_transit_e30_ensure tv_transit_e30_ensure_end fl_transit_e30_ensure_left))
		((volume_test_object tv_transit_e30_ensure_right ai_johnson) 	(ensure_johnson_in_encounter tv_transit_e30_ensure tv_transit_e30_ensure_end fl_transit_e30_ensure_right))
	)
	(print "ensure_johnson_in_dome_station has ended")
)

(script dormant ensure_johnson_in_docking_bay
	(print "ensure_johnson_in_docking_bay has started")
	(ensure_johnson_in_encounter tv_transit_e34_ensure tv_space_trans_to_1 fl_transit_e34_ensure)
	(print "ensure_johnson_in_docking_bay has ended")
)

(script static void (ensure_johnson_in_encounter (trigger_volume tv_teleport) (trigger_volume tv_next_area) (cutscene_flag f))
	(sleep_until (volume_test_players tv_teleport) 1)
	(tele_johnson_to_flag tv_teleport tv_next_area f)
)

(script static void (tele_johnson_to_flag (trigger_volume tv_teleport) (trigger_volume tv_next_area) (cutscene_flag f))
	(if
		(!= (volume_test_object tv_teleport ai_johnson) 1)
		;then
		(begin
			(print "waiting johnson teleport to flag")
			(sleep_until
				(or
					;make sure johnson and teleport spot are not visible and player is not too close to teleport spot (limit how obvious the teleport looks on motion tracker)
					(and
						(= (objects_can_see_flag (players) f 90) false)
						(> (objects_distance_to_flag (players) f) 7.5)
						(= (objects_can_see_object (players) ai_johnson 90) false)
						(> (object_get_health (object_get_ai ai_johnson)) 0) ;make sure johnson is alive
					)
					(= (volume_test_object tv_teleport ai_johnson) 1) ;johnson is already in the right area
					(= (volume_test_players tv_next_area) true) ;player past the encounter
				)
				1
			)
			;incase johnson has made his way into the tv after the sleep
			(if
				(and
					(= (volume_test_object tv_teleport ai_johnson) false) ;if johnson has not made it to the intened area
					(= (volume_test_players tv_next_area) false) ;if player has not past the encounter area or is in next spot where johnson can be teleported to
				)
				;then
				(begin
					(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)
					(object_teleport ai_johnson f)
					(print "johnson teleported to flag")
				)
				;else
				(print "johnson did not need to be teleported")
			)
		)
	)
)

(script dormant point_of_no_return_beat3
	(print "tram point of no return started")
	(wake ensure_johnson_in_dome_station)
	(wake ensure_johnson_in_docking_bay)

	;hydro station
	(sleep_until (>= (device_get_position dm_transit) r_tram_door2_open_pos) 1)
	(ponr_player_on_tram_tv_attach)

	;section a
	(sleep_until (>= (device_get_position dm_transit) r_tram_door4_open_pos) 1)
	(ponr_player_on_tram_tv_attach)

	;section b
	(sleep_until (>= (device_get_position dm_transit) r_tram_door6_open_pos) 1)
	(ponr_player_on_tram_tv_attach)

	;dome station
	(sleep_until (>= (device_get_position dm_transit) r_tram_door8_open_pos) 1)
	(ponr_player_on_tram_tv_attach)

	;section c
	(sleep_until (>= (device_get_position dm_transit) r_tram_door10_open_pos) 1)
	(ponr_player_on_tram_tv_attach)

	;section d
	(sleep_until (>= (device_get_position dm_transit) r_tram_door12_open_pos) 1)
	(ponr_player_on_tram_tv_attach)

	;gravlift up to hangar
	(sleep_until (volume_test_players tv_ponr_hangar_above) 1)
	(ponr_player_not_in_2_tv_tele  tv_ponr_hangar_above tv_ponr_hangar_grav_shaft fl_ponr_tele_hangar_p0 fl_ponr_tele_hangar_p1 fl_ponr_tele_hangar_p2 fl_ponr_tele_hangar_p3)
	(ponr_johnson_not_in_2_tv_tele tv_ponr_hangar_above tv_ponr_hangar_grav_shaft fl_ponr_tele_hangar_j)
	(object_destroy_folder of_hangar_station)
	(object_create_folder of_hangar_top)
	(if (coop_players_2) (object_create_folder of_hangar_top_coop_weapons))

	;garbage collecting
	(print "garbage_collect_now at gravlift b down")
	(garbage_collect_unsafe) ;player will not be able to see any potential garbage in the big grav lift
)

(script dormant transit_soft_kill_volume_setup
	;disable soft_kill volumes that the player needs to be able to tranverse at first
	(kill_volume_disable kill_soft_hydro_station)
	(kill_volume_disable kill_soft_section_a)
	(kill_volume_disable kill_soft_dome_left)
	(kill_volume_disable kill_soft_dome_mid)
	(kill_volume_disable kill_soft_dome_right)
	(kill_volume_disable kill_soft_section_d_left)
	(kill_volume_disable kill_soft_section_d_right)
)

(global real r_tram_s_kill_1_pos 0.050) ;leaving hydro station
(global real r_tram_s_kill_2_pos 0.160) ;leaving section a
(global real r_tram_s_kill_3_pos 0.620) ;leaving dome station
(global real r_tram_s_kill_4_pos 0.806) ;leaving section d

(script dormant transit_soft_kill_volume_control
	;hydro station
	(transit_kill_volume_enable kill_soft_hydro_station r_tram_s_kill_1_pos r_tram_door2_open_pos)

	;section a
	(transit_kill_volume_enable kill_soft_section_a 	r_tram_s_kill_2_pos r_tram_door4_open_pos)

	;dome station
	(transit_3_kill_volume_enable kill_soft_dome_left kill_soft_dome_mid kill_soft_dome_right r_tram_s_kill_3_pos r_tram_door8_open_pos)

	;section d
	(transit_2_kill_volume_enable kill_soft_section_d_left kill_soft_section_d_right r_tram_s_kill_4_pos r_tram_door12_open_pos)
)

(script static void (transit_kill_volume_enable (trigger_volume soft_kill_tv) (real real_tram_pos_first) (real real_tram_pos_last))
	(sleep_until (>= (device_get_position dm_transit) real_tram_pos_first))
	(if (not (volume_test_players tv_tram))
		;then
		(begin
			(print "transit soft kill manager - soft_kill volume enable since no player is on tram")
			(kill_volume_enable soft_kill_tv)
		)
		;else
		(print "transit soft kill manager - delay enabling soft_kill volume since there is a player on tram")
	)
	(sleep_until
		;if no player is on the tram after the intial check or last tram position is reached
		(or
			(>= (device_get_position dm_transit) real_tram_pos_last)
			(not (volume_test_players tv_tram))
		)
		1
	)
	(print "transit soft kill manager - soft_kill volume enable since last tram position is reached")
	(kill_volume_enable soft_kill_tv)

)

(script static void (transit_2_kill_volume_enable (trigger_volume soft_kill_tv1) (trigger_volume soft_kill_tv2) (real real_tram_pos_first) (real real_tram_pos_last))
	(sleep_until (>= (device_get_position dm_transit) real_tram_pos_first))
	(if (not (volume_test_players tv_tram))
		;then
		(begin
			(print "transit soft kill manager - soft_kill volumes enable since no player is on tram")
			(kill_volume_enable soft_kill_tv1)
			(kill_volume_enable soft_kill_tv2)
		)
		;else
		(print "transit soft kill manager - delay enabling soft_kill volumes since there is a player on tram")
	)
	(sleep_until
		;if no player is on the tram after the intial check or last tram position is reached
		(or
			(>= (device_get_position dm_transit) real_tram_pos_last)
			(not (volume_test_players tv_tram))
		)
		1
	)
	(print "transit soft kill manager - soft_kill volumes enable since last tram position is reached")
	(kill_volume_enable soft_kill_tv1)
	(kill_volume_enable soft_kill_tv2)

)

(script static void (transit_3_kill_volume_enable (trigger_volume soft_kill_tv1) (trigger_volume soft_kill_tv2) (trigger_volume soft_kill_tv3) (real real_tram_pos_first) (real real_tram_pos_last))
	(sleep_until (>= (device_get_position dm_transit) real_tram_pos_first))
	(if (not (volume_test_players tv_tram))
		;then
		(begin
			(print "transit soft kill manager - soft_kill volumes enable since no player is on tram")
			(kill_volume_enable soft_kill_tv1)
			(kill_volume_enable soft_kill_tv2)
			(kill_volume_enable soft_kill_tv3)
		)
		;else
		(print "transit soft kill manager - delay enabling soft_kill volumes since there is a player on tram")
	)
	(sleep_until
		;if no player is on the tram after the intial check or last tram position is reached
		(or
			(>= (device_get_position dm_transit) real_tram_pos_last)
			(not (volume_test_players tv_tram))
		)
		1
	)
	(print "transit soft kill manager - soft_kill volumes enable since last tram position is reached")
	(kill_volume_enable soft_kill_tv1)
	(kill_volume_enable soft_kill_tv2)
	(kill_volume_enable soft_kill_tv3)

)

(script static void (ponr_johnson_in_2_tv_tele (trigger_volume tv1) (trigger_volume tv2) (cutscene_flag f_player0))
	(if
		(or
			(volume_test_object tv1 ai_johnson)
			(volume_test_object tv2 ai_johnson)
		)
		;then
		(begin
			(print "teleporting ai_johnson")
			(object_teleport ai_johnson f_player0)
		)
	)
)

(script static void (ponr_player_in_2_tv_tele (trigger_volume tv1) (trigger_volume tv2) (cutscene_flag f_player0) (cutscene_flag f_player1) (cutscene_flag f_player2) (cutscene_flag f_player3))
		;check if player 0 needs to teleported
	(if
		(or
			(volume_test_object tv1 player0)
			(volume_test_object tv2 player0)
		)
		;then
		(begin
			(print "teleporting player 0")
			(object_teleport player0 f_player0)
		)
	)

	;check if player 1 needs to teleported
	(if
		(or
			(volume_test_object tv1 player1)
			(volume_test_object tv2 player1)
		)
		;then
		(begin
			(print "teleporting player 1")
			(object_teleport player1 f_player1)
		)
	)
	;check if player 2 needs to teleported
	(if
		(or
			(volume_test_object tv1 player2)
			(volume_test_object tv2 player2)
		)
		;then
		(begin
			(print "teleporting player 2")
			(object_teleport player2 f_player2)
		)
	)
	;check if player 3 needs to teleported
	(if
		(or
			(volume_test_object tv1 player3)
			(volume_test_object tv2 player3)
		)
		;then
		(begin
			(print "teleporting player 3")
			(object_teleport player3 f_player3)
		)
	)

)

(script static void (ponr_player_not_in_tv_tele (trigger_volume tv) (cutscene_flag f_player0) (cutscene_flag f_player1) (cutscene_flag f_player2) (cutscene_flag f_player3))
		;check if player 0 needs to teleported
	(if
		(not
			(volume_test_object tv player0)
		)
		;then
		(begin
			(print "teleporting player 0")
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
			(print "teleporting player 1")
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
			(print "teleporting player 2")
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
			(print "teleporting player 3")
			(object_teleport player3 f_player3)
		)
	)

)

(script static void (ponr_player_not_in_2_tv_tele (trigger_volume tv1) (trigger_volume tv2) (cutscene_flag f_player0) (cutscene_flag f_player1) (cutscene_flag f_player2) (cutscene_flag f_player3))
		;check if player 0 needs to teleported
	(if
		(not
			(or
				(volume_test_object tv1 player0)
				(volume_test_object tv2 player0)
			)
		)
		;then
		(begin
			(print "teleporting player 0")
			(object_teleport player0 f_player0)
		)
	)

	;check if player 1 needs to teleported
	(if
		(not
			(or
				(volume_test_object tv1 player1)
				(volume_test_object tv2 player1)
			)
		)
		;then
		(begin
			(print "teleporting player 1")
			(object_teleport player1 f_player1)
		)
	)
	;check if player 2 needs to teleported
	(if
		(not
			(or
				(volume_test_object tv1 player2)
				(volume_test_object tv2 player2)
			)
		)
		;then
		(begin
			(print "teleporting player 2")
			(object_teleport player2 f_player2)
		)
	)
	;check if player 3 needs to teleported
	(if
		(not
			(or
				(volume_test_object tv1 player3)
				(volume_test_object tv2 player3)
			)
		)
		;then
		(begin
			(print "teleporting player 3")
			(object_teleport player3 f_player3)
		)
	)

)

(script static void (ponr_johnson_not_in_tv_tele (trigger_volume tv) (cutscene_flag f_player0))
	(if
		(not
			(volume_test_object tv ai_johnson)
		)
		;then
		(begin
			(print "teleporting ai_johnson")
			(object_teleport ai_johnson f_player0)
		)
	)
)

(script static void (ponr_johnson_not_in_2_tv_tele (trigger_volume tv1) (trigger_volume tv2) (cutscene_flag f_player0))
	(if
		(not
			(or
				(volume_test_object tv1 ai_johnson)
				(volume_test_object tv2 ai_johnson)
			)
		)
		;then
		(begin
			(print "teleporting ai_johnson")
			(object_teleport ai_johnson f_player0)
		)
	)
)

(script static void ponr_player_on_tram_tv_attach
		;check if player 0 needs to teleported
	(if
		(not
			(or
				(volume_test_object tv_tram player0)
				(volume_test_object tv_tram_general_area player0)
			)
		)
		;then
		(begin
			(print "attaching player 0 to tram")
			(objects_attach dm_transit tele_player0 player0 "")
			(objects_detach dm_transit player0)
		)
	)

	;check if player 1 needs to teleported
	(if
		(not
			(or
				(volume_test_object tv_tram player1)
				(volume_test_object tv_tram_general_area player1)
			)
		)
		;then
		(begin
			(print "attaching player 1 to tram")
			(objects_attach dm_transit tele_player1 player1 "")
			(objects_detach dm_transit player1)
		)
	)
	;check if player 2 needs to teleported
	(if
		(not
			(or
				(volume_test_object tv_tram player2)
				(volume_test_object tv_tram_general_area player2)
			)
		)
		;then
		(begin
			(print "attaching player 2 to tram")
			(objects_attach dm_transit tele_player2 player2 "")
			(objects_detach dm_transit player2)
		)
	)
	;check if player 3 needs to teleported
	(if
		(not
			(or
				(volume_test_object tv_tram player3)
				(volume_test_object tv_tram_general_area player3)
			)
		)
		;then
		(begin
			(print "attaching player 3 to tram")
			(objects_attach dm_transit tele_player3 player3 "")
			(objects_detach dm_transit player3)
		)
	)

)


(script dormant beat1_doors_updates
	(print "beat1_doors_updates - don't let the player backtrack to zn_start_hydro")
	(device_set_power dm_beat1_block_door0 0)
)

;update doors that need state changes so players can progress
(script dormant beat2_doors_updates
	;hydro entry doors
	;dm_beat2_path_door1 is initially one sided in beat 1 to be a monster closet
	(device_one_sided_set dm_beat2_path_door1 false)
	;dm_beat2_path_door2 is initially off in beat 1 to close back of monster closet
	(device_set_power dm_beat2_path_door2 1)
	;dm_beat2_path_door3 is initially off in beat 1 to block the top path
	(device_set_power dm_beat2_path_door3 1)

	;control room doors
	;dm_beat2_armory_door0 is initially off in beat 1
	(device_set_power dm_beat2_armory_door0 1)
	;dm_beat2_armory_door1 is initially off in beat 1
	(device_set_power dm_beat2_armory_door1 1)

	;hydro garden 1 doors
	;dm_beat2_path_door0 is initially off in beat 1
	(device_set_power dm_beat2_path_door0 1)
	;dm_beat2_block_door1 is initially on in beat 1 but needs to be off until the player passes the grav lift
	(device_set_position_immediate dm_beat2_block_door1 0)
	(device_set_power dm_beat2_block_door1 0)
	;check if player is past the gravlift
	(sleep_until (volume_test_players tv_act_garden_exit) 1)
	;dm_beat2_block_door1 is initially two sided in beat 1 and will be used as a monster closet door in beat 2
	(device_set_power dm_beat2_block_door1 1)
	(device_one_sided_set dm_beat2_block_door1 true)
	;dm_beat2_block_door2 is initially two sided in beat 1 and part of beat 2 but will close off back of monster closet
	(device_one_sided_set dm_beat2_block_door2 true)
)

(script dormant beat2_after_garden_door_update
	;close garden b door so player cannot backtrack
	(device_set_position_immediate dm_beat2_block_door3 0)
	(device_set_power dm_beat2_block_door3 0)
)

;====================================================================================================================================================================================================
;utility scripts
;====================================================================================================================================================================================================
(script command_script cs_kill_command_script
	(print "killing current command script")
	(object_can_take_damage ai_johnson)
	(sleep 1)
)

(script static void kill_branch
	(print "killing script since branch condition met")
)

;(global boolean b_any_player_on_tram 0)

;(script continuous attached_tv_tram_check
;	(if (= (volume_test_players tv_tram) 1)
;		;then
;		(set b_any_player_on_tram 1)
;	)
;	(set b_any_player_on_tram 0)
;)

(global boolean b_tram_ride_over 0)

(script dormant migrate_tram_jump_squads_loop
	(sleep_until
		(begin
			;check if enemies jump on tram and then migrate them to a tram squad
			;e26
			(if (volume_test_objects tv_tram (ai_get_object sq_e26_jump_elite1_w1)) 	(ai_migrate sq_e26_jump_elite1_w1 sq_tram_e26))
			(if (volume_test_objects tv_tram (ai_get_object sq_e26_jump_elite2_w1)) 	(ai_migrate sq_e26_jump_elite2_w1 sq_tram_e26))
			;e27
			(if (volume_test_objects tv_tram (ai_get_object sq_e27_b_grunts/grunt1)) 	(ai_migrate sq_e27_b_grunts/grunt1 sq_tram_e27))
			(if (volume_test_objects tv_tram (ai_get_object sq_e27_b_grunts/grunt2)) 	(ai_migrate sq_e27_b_grunts/grunt2 sq_tram_e27))
			(if (volume_test_objects tv_tram (ai_get_object sq_e27_b_grunts/grunt3)) 	(ai_migrate sq_e27_b_grunts/grunt3 sq_tram_e27))
			(if (volume_test_objects tv_tram (ai_get_object sq_e27_b_grunts/grunt4)) 	(ai_migrate sq_e27_b_grunts/grunt4 sq_tram_e27))
			(if (volume_test_objects tv_tram (ai_get_object sq_e27_b_grunts/grunt5)) 	(ai_migrate sq_e27_b_grunts/grunt5 sq_tram_e27))
			(if (volume_test_objects tv_tram (ai_get_object sq_e27_b_grunts/grunt6)) 	(ai_migrate sq_e27_b_grunts/grunt6 sq_tram_e27))
			(if (volume_test_objects tv_tram (ai_get_object sq_e27_c_suicide)) 			(ai_migrate sq_e27_c_suicide sq_tram_e27))
			;e31
			(if (volume_test_objects tv_tram (ai_get_object sq_e31_w3_brutes/brute1)) 	(ai_migrate sq_e31_w3_brutes/brute1 sq_tram_e31))
			(if (volume_test_objects tv_tram (ai_get_object sq_e31_w3_brutes/brute2)) 	(ai_migrate sq_e31_w3_brutes/brute2 sq_tram_e31))
			;e32
			(if (volume_test_objects tv_tram (ai_get_object sq_e32_w1_elites/elite1)) 	(ai_migrate sq_e32_w1_elites/elite1 sq_tram_e32))
			(if (volume_test_objects tv_tram (ai_get_object sq_e32_w2_elites/elite1)) 	(ai_migrate sq_e32_w2_elites/elite1 sq_tram_e32))
			(if (volume_test_objects tv_tram (ai_get_object sq_e32_w2_elites/elite2)) 	(ai_migrate sq_e32_w2_elites/elite2 sq_tram_e32))

		b_tram_ride_over ; exit condition
   		)
    	10
  	)
)

(global boolean b_johnson_transit_check false)
(global cutscene_flag fl_transit_buddy_teleport fl_transit_buddy_0)

(script dormant johnson_fall_transit_check
  ; loop until b_johnson_transit_check is true
  (sleep_until
    (begin
    	(print "beat 3 johnson fall check - prints every 5 seconds")
    	;check if johnson falls off the tram and attach him to the tram
    	(if
			(volume_test_object kill_under_transit ai_johnson)
			;then
			(bring_johnson_on_tram)
		)
		(if
			(or
				(volume_test_object kill_under_hangar ai_johnson)
				(volume_test_object kill_under_hangar2 ai_johnson)
				(volume_test_object kill_under_hangar3 ai_johnson)
			)
			;then
			(object_teleport ai_johnson fl_hangar_buddy_tele)
		)
      b_johnson_transit_check ; exit condition
    )
    (game_ticks_from_seconds 5)
  )
)

(global boolean b_beat1_johnson_bridge_check false)
(global boolean b_beat2_johnson_bridge_check false)

(script dormant beat1_johnson_fall_bridge_check
	(print "beat1_johnson_fall_bridge_check started")
  ; loop until b_beat1_johnson_bridge_check is true
	(sleep_until
		(begin
			(print "beat 1 johnson fall check - prints every 5 seconds")
			;check if johnson falls off the bridge and attach him to the tram
			(if
				(volume_test_object kill_under_bridge_tv ai_johnson)
				;then
				(object_teleport ai_johnson fl_bridge1_buddy_tele)
			)
		b_beat1_johnson_bridge_check ; exit condition
		)
    	(game_ticks_from_seconds 5)
  	)
	(print "beat1_johnson_fall_bridge_check ended")
)

(script dormant beat2_johnson_fall_bridge_check
  (print "beat2_johnson_fall_bridge_check started")
  ; loop until b_beat2_johnson_bridge_check is true
	(sleep_until
		(begin
			(print "beat 2 johnson fall check - prints every 5 seconds")
			;check if johnson falls off the bridge and attach him to the tram
			(if
				(volume_test_object kill_under_bridge_tv ai_johnson)
				;then
				(object_teleport ai_johnson fl_bridge2_buddy_tele)
			)
		b_beat2_johnson_bridge_check ; exit condition
		)
		(game_ticks_from_seconds 5)
	)
	(print "beat2_johnson_fall_bridge_check ended")
)

(script static void bring_johnson_on_tram
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)
	(objects_attach dm_transit tele_johnson ai_johnson "")
	(objects_detach dm_transit ai_johnson)
)

;nav points
(global cutscene_flag last_blip_flag fl_ini_nav)
(global cutscene_flag second_last_blip_flag fl_ini_nav)
(global cutscene_flag third_last_blip_flag fl_ini_nav)
(global boolean b_nav_active 0)
(global trigger_volume last_tv_nav tv_chapter_1)
(global trigger_volume last_backtrack_tv_nav tv_chapter_1)

(global short s_nav_point_delay (game_ticks_from_seconds 1))

(global boolean b_nav_backtrack_timer_needed 0)
(global boolean b_nav_backtrack_timer_running 0)
(global boolean b_nav_backtrack_timer_complete 0)
(global boolean b_nav_backtrack_timer_used 0)
(global short s_nav_backtrack_timer_delay (game_ticks_from_seconds 30))

;beat 1 nav points
(script static void beat1_nav_control
	(cond
		;(check)																						(results)
		; ---------------- encounter 2 ----------------
		;cond - nav to sidehall
		((f_nav_ai_tv_check fl_nav_to_sidehall gr_beat1_e1_overview tv_nav_overview_sidehall) 			(f_blip_one_with_tv fl_nav_to_sidehall tv_nav_overview_sidehall))

		;cond - navend to sidehall
		((f_navend_fl_tv_check fl_nav_to_sidehall tv_navend_overview_sidehall) 							(f_unblip_with_tv fl_nav_to_sidehall tv_navend_overview_sidehall))

		; ---------------- encounter 3 ----------------
		;cond - nav to minor vista
		((f_nav_ai_tv_check fl_to_minor_vista gr_beat1_e3_overview_vista tv_nav_to_minor_vista) 		(f_blip_one_with_tv fl_to_minor_vista tv_nav_to_minor_vista))

		;cond - navend to minor vista
		((f_navend_fl_tv_check fl_to_minor_vista tv_navend_to_minor_vista) 								(f_unblip_with_tv fl_to_minor_vista tv_navend_to_minor_vista))

		;  ---------------- encounter 8 ----------------
		;cond - nav to door out of hydro entry
		((f_nav_ai_tv_check fl_to_wing gr_beat1_e8_hydro_entry_room tv_act_fl_to_wing) 					(f_blip_one_with_tv fl_to_wing tv_act_fl_to_wing))

		;cond - nav to door to gardens
		((f_nav_tv_check fl_to_gardens tv_nav_to_gardens)												(f_blip_one_with_tv fl_to_gardens tv_nav_to_gardens))

		;cond - navend to door to gardens
		((f_navend_fl_tv_check fl_to_gardens tv_end_fl_to_gardens)										(f_unblip_with_tv fl_to_gardens tv_end_fl_to_gardens))

		; ---------------- encounter 9 ----------------
		;cond - nav_to_garden2
		((f_nav_ai_tv_check fl_to_gardens2 gr_beat1_e9_hydro_garden tv_nav_to_garden2)					(f_blip_one_with_tv fl_to_gardens2 tv_nav_to_garden2))

		;cond - navend to door to gardens
		((f_navend_fl_tv_check fl_to_gardens2 tv_navend_to_garden2)										(f_unblip_with_tv fl_to_gardens2 tv_navend_to_garden2))

		; ---------------- encounter 10 ----------------
		;cond - nav door to bridge
		((f_nav_ai_tv_check fl_to_bridge1 gr_beat1_e10_hydro_garden2 tv_nav_to_bridge1)					(f_blip_one_with_tv fl_to_bridge1 tv_nav_to_bridge1))

		;cond - navend door to bridge
		((f_navend_fl_tv_check fl_to_bridge1 tv_navend_to_bridge1)										(f_unblip_with_tv fl_to_bridge1 tv_navend_to_bridge1))

		; ---------------- encounter 11 ----------------
		;cond - nav end of bridge
		((f_nav_tv_check fl_to_bridge1_end tv_nav_to_bridge1_end)										(f_blip_one_with_tv fl_to_bridge1_end tv_nav_to_bridge1_end))

		;cond - navend end of bridge
		((f_navend_fl_tv_check fl_to_bridge1_end tv_navend_to_bridge1_end)								(f_unblip_with_tv fl_to_bridge1_end tv_navend_to_bridge1_end))

		;cond - nav to control gravlift
		((f_nav_ai_tv_check fl_to_control_gravlift gr_beat1_e11_hydro_bridge tv_nav_to_control_gravlift)(f_blip_one_with_tv fl_to_control_gravlift tv_nav_to_control_gravlift))

		;cond - navend to control gravlift
		((f_navend_fl_tv_check fl_to_control_gravlift tv_navend_to_control_gravlift)					(f_unblip_with_tv fl_to_control_gravlift tv_navend_to_control_gravlift))

		; ---------------- encounter 12 ----------------
		;cond - nav to control
		((f_nav_ai_tv_check fl_nav_to_control gr_beat1_e12_control_grav_up tv_nav_to_control)			(f_blip_one_with_tv fl_nav_to_control tv_nav_to_control))

		;cond - navend to control
		((f_navend_fl_tv_check fl_nav_to_control tv_navend_to_control)									(f_unblip_with_tv fl_nav_to_control tv_navend_to_control))
	)
)

;beat 2 nav points
(script static void beat2_nav_control
	(cond
		;(check)																							(results)
		; ---------------- encounter 14 ----------------
		;cond - nav out of bridge
		((f_nav_tv_check fl_init_beat_2 tv_nav_beat2_init) 													(f_blip_one_with_tv fl_init_beat_2 tv_nav_beat2_init))

		;cond - nav to gravlift
		((f_nav_tv_check fl_to_beat2_gravlift tv_nav_beat2_gravlift) 										(f_blip_one_with_tv fl_to_beat2_gravlift tv_nav_beat2_gravlift))

		;cond - navend to gravlift
		((f_navend_fl_tv_check fl_to_beat2_gravlift tv_navend_beat2_gravlift) 								(f_unblip_with_tv fl_to_beat2_gravlift tv_navend_beat2_gravlift))

		; ---------------- encounter 15 ----------------
		;cond - nav to start of bridge redux
		((f_nav_ai_tv_check fl_to_bridge_redux gr_beat2_e14_gravlift_redux tv_act_hydro_bridge_redux)		(f_blip_one_with_tv fl_to_bridge_redux tv_act_hydro_bridge_redux))

		;cond - nav to end of bridge redux
		((f_nav_tv_check fl_to_bridge_redux_end tv_navend_to_bridge_redux) 									(f_blip_one_with_tv fl_to_bridge_redux_end tv_navend_to_bridge_redux))

		;cond - navend to end of bridge redux
		((f_navend_fl_tv_check fl_to_bridge_redux_end tv_navend_to_bridge_redux_end) 						(f_unblip_with_tv fl_to_bridge_redux_end tv_navend_to_bridge_redux_end))

		; ---------------- encounter 16 ----------------
		;cond - nav to start to garden b exit
		((f_nav_ai_tv_check fl_nav_garden_b_exit gr_beat2_e16_garden2_w1 tv_nav_garden_b_exit)				(f_blip_one_with_tv fl_nav_garden_b_exit tv_nav_garden_b_exit))

		;cond - navend to end of garden b exitfl_nav_garden_b_exit
		((f_navend_fl_tv_check fl_nav_garden_b_exit tv_navend_to_bridge_redux_end) 						(f_unblip_with_tv fl_nav_garden_b_exit tv_navend_garden_b_exit))

		;cond - nav to side route
		((f_nav_tv_check fl_to_side_route tv_act_to_side_route) 											(f_blip_one_with_tv fl_to_side_route tv_act_to_side_route))

		;cond - navend to side route
		((f_navend_fl_tv_check fl_to_side_route tv_end_to_side_route) 										(f_unblip_with_tv fl_to_side_route tv_end_to_side_route))

		; ---------------- encounter 20 ----------------
		;cond - nav to rr
		((f_nav_ai_tv_check fl_to_rr gr_beat2_e20_hydro_entry_redux tv_act_to_rr) 							(f_blip_one_with_tv fl_to_rr tv_act_to_rr))

		;cond - navend to rr
		((f_navend_fl_tv_check fl_to_rr tv_end_to_rr) 														(f_unblip_with_tv fl_to_rr tv_end_to_rr))

		; ---------------- encounter 22 ----------------
		;cond - nav to beat 3 gravlift
		((and
			(= b_nav_to_beat3_ready 1)
			(f_nav_ai_tv_check fl_nav_to_beat3_grav gr_beat2_e22_rest_respite tv_nav_beat3)
		)																									(f_blip_one_with_tv fl_nav_to_beat3_grav tv_nav_beat3))

		;cond - nav to beat 3 gravlift
		((f_nav_tv_check fl_nav_beat3 tv_navend_to_beat3_grav) 												(f_blip_one_with_tv fl_nav_beat3 tv_navend_to_beat3_grav))

		;cond - navend to beat 3 gravlift
		((f_navend_fl_tv_check fl_nav_beat3 tv_end_beat_2) 													(f_unblip_with_tv fl_nav_beat3 tv_end_beat_2))
	)
)

;nav control conditions checks
(script static boolean (f_nav_ai_tv_check (cutscene_flag f) (ai encounter_squad )(trigger_volume tv_nav))
	(f_nav_backtrack_need_check f tv_nav)

	;this boolean will be returned
	(and
		(f_nav_should_be_blipped_check f)
		(<= (ai_living_count encounter_squad) 0)
		(volume_test_players tv_nav)
	)
)

(script static boolean (f_nav_tv_check (cutscene_flag f) (trigger_volume tv_nav))
	(f_nav_backtrack_need_check f tv_nav)

	;this boolean will be returned
	(and
		(f_nav_should_be_blipped_check f)
		(volume_test_players tv_nav)
	)
)

(script static boolean (f_navend_tv_check (trigger_volume tv_navend))
	(volume_test_players tv_navend)
)

(script static boolean (f_navend_fl_tv_check (cutscene_flag f) (trigger_volume tv_navend))
	(and
		(= last_blip_flag f)
		(= b_nav_active 1)
		(volume_test_players tv_navend)
	)
)

;nav condition static scripts
(script static void (f_nav_backtrack_need_check (cutscene_flag f) (trigger_volume tv_nav))
	(if
		(and
			(= b_nav_backtrack_timer_running 0)
			(or
				(and
					(= b_nav_active 1)
					(= second_last_blip_flag f)
				)
				(and
					(= b_nav_active 0)
					(= last_blip_flag f)
				)
			)
			(volume_test_players tv_nav)
		)
		(set b_nav_backtrack_timer_needed 1)
	)
)

(script static boolean (f_nav_should_be_blipped_check (cutscene_flag f))
	(or
		;is f different than the last flag blipped and is there no active flag?
		(and
			(= b_nav_active 0)
			(!= last_blip_flag f)
		)
		;is f different than the last and second to last flag blipped?
		(and
			(!= last_blip_flag f)
			(!= second_last_blip_flag f)
		)
		(and
			(= b_nav_active 1)
			(!= second_last_blip_flag f)
			(= third_last_blip_flag f)
		)
		;has the backtrack timer completed?
		(= b_nav_backtrack_timer_complete 1)
	)
)

;nav control results
(script static void (f_blip_one_with_tv (cutscene_flag f) (trigger_volume tv_nav))
	(if (= b_nav_backtrack_timer_complete 1) (set b_nav_backtrack_timer_used 1))
	(f_unblip_flag last_blip_flag)
	(sleep s_nav_point_delay)
	(f_blip_flag f 0)
	(set b_nav_active 1)
	;want third to last & second to last flags to be unique
	(if
		(!= third_last_blip_flag second_last_blip_flag)
		;then
		(set third_last_blip_flag second_last_blip_flag)
		;else
		(print "third and second flags matched. did not update third flag")
	)
	;want second to last & last flags to be unique
	(if
		(!= second_last_blip_flag last_blip_flag)
		;then
		(set second_last_blip_flag last_blip_flag)
		;else
		(print "second and last flags matched. did not update second flag")
	)
	(set last_blip_flag f)
	(set last_tv_nav tv_nav)
)

(script static void (f_unblip_with_tv (cutscene_flag f) (trigger_volume tv_navend))
	(set last_tv_nav tv_navend)
	(f_unblip_flag f)
	(set b_nav_active 0)
)

;nav loops
(script dormant nav_backtracking_loop
	;loop while b_space_started is false
	(sleep_until
		(begin
			(print "backtracking timer waiting til needed")
			(sleep_until (= b_nav_backtrack_timer_needed 1) 1)

			(set last_backtrack_tv_nav last_tv_nav)
			(if (volume_test_players last_tv_nav) (print "backtracking timer player in last_tv_nav"))
			(sleep_until (= (volume_test_players last_tv_nav) 0) 1)

			(sleep (game_ticks_from_seconds 2)) ;wait a bit for the nav loop to go through again

			(if (!= last_backtrack_tv_nav last_tv_nav)
				;then
				(begin
					(print "backtracking timer player moved on")
					(set b_nav_backtrack_timer_needed 0)
				)
				;else
				(begin
					(print "backtracking timer started")
					(set b_nav_backtrack_timer_running 1)

					(sleep s_nav_backtrack_timer_delay)

					(if (= b_nav_backtrack_timer_used 0)
						;then
						(begin
							(print "backtracking timer completed")
							(set b_nav_backtrack_timer_complete 1)

							;sleep until nav point is blipped
							(sleep_until b_nav_backtrack_timer_used 1)

							;reset variables
							(print "backtracking timer used - variables reset")
							(set b_nav_backtrack_timer_needed 0)
							(set b_nav_backtrack_timer_running 0)
							(set b_nav_backtrack_timer_complete 0)
							(set b_nav_backtrack_timer_used 0)
						)
						;else
						(begin
							(print "backtracking timer - nav recently blipped")
							(set b_nav_backtrack_timer_needed 0)
							(set b_nav_backtrack_timer_running 0)
						)
					)
				)
			)
			b_space_started ;exit condition
		)
		(game_ticks_from_seconds 1) ;run every 1 seconds
	)
	(print "breadcrumbs: beat1_nav_loop over")
)

(script dormant beat1_nav_loop
	;loop while b_bridge_cinematic_played is false
	(sleep_until
		(begin
			(beat1_nav_control)
			b_bridge_cinematic_played ;exit condition
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat1_nav_loop over")
)

(script dormant beat2_nav_loop
	;loop while b_bridge_cinematic_played is false
	(sleep_until
		(begin
			(beat2_nav_control)
			b_beat3_reached;exit condition
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat2_nav_loop over")
)


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;  ____             _     _  _     ____
; | __ )  ___  __ _| |_  | || |   / ___| _ __   __ _  ___ ___
; |  _ \ / _ \/ _` | __| | || |_  \___ \| '_ \ / _` |/ __/ _ \
; | |_) |  __/ (_| | |_  |__   _|  ___) | |_) | (_| | (_|  __/
; |____/ \___|\__,_|\__|    |_|   |____/| .__/ \__,_|\___\___|
;                                       |_|
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;clumps (borrowed from m45 to start)
(global short clump_tolerance_aa	19)
(global short clump_seraphs			18)
;(global short clump_sabres			17)
(global short clump_bop_aa			16)
(global short clump_banshees		15)
;(global short clump_ground_flavor  14)
;(global short clump_ground_aa		19)

(global boolean b_space_started 0)
(global short zs_space_index 1)

(global short s_current_space_encounter 0)
(global boolean b_space_1_complete 0)
(global boolean b_space_2_complete 0)
(global boolean b_space_3_complete 0)
(global ai ai_current_ser_johnson sq_seraph_johnson)

(script dormant beat4_trigger
	(sleep_until (volume_test_players tv_space_trans_to_1) 1)

	(wake begin_beat4)
)

(script dormant beat3_cleanup
	(print "gr_transit_encounters clean up")
	(ai_erase gr_transit_encounters) ;clean up
	(ai_erase ai_johnson) ;killing interior johnson
	(object_destroy_folder of_hangar_top)
	(object_destroy_folder of_hangar_bottom)
	(garbage_collect_unsafe)
	(print "******* switching to space *******")
	(cinematic_teleport ps_space1_start)
	(f_switch_zone_set_blocking zs_space)
)

(global boolean b_e30_change_cinematic_started 0)
(global boolean b_e30_change_cinematic_ended 0)

(script dormant begin_beat4
	(set b_johnson_transit_check true) ;stop checking for johnson falling

	(print "******* beat 4: space section 1 *******")

	(print_if b_debug_gameplay "insertion point: ins_e30_space_1 unlocked")
	(submit_incident "ins_e30_space_1")
	(submit_incident_with_custom_string_id "game_activity_begin" "e30")

	(set s_music_trigger_e30 280)
	(set b_e30_change_cinematic_started 1)
	; fade to black, clean up beat3, switch to space, start the cinematic
	(f_manual_cinematic_prepare cinematics\e30\e30_change.cinematic true)
	(if
		(!= (current_zone_set_fully_active) zs_space_index)
		(begin
			(wake beat3_cleanup)
			; wait until beat3 finishes cleanup & switching zone sets to zs_space.
			(sleep_until (= (current_zone_set_fully_active) zs_space_index) 1)
		)
	)
	(f_manual_cinematic_play cinematics\e30\e30_change.cinematic)

	(set b_e30_change_cinematic_ended 1)
	(set s_music_trigger_e30 290)

	(enable_space_debris)

	(print "fade out")
	(fade_out 0 0 0 0)
	(set b_space_started 1)
	(wake e30_space_respawn)
	;don't check if player is airborne during space section
	(set player_respawn_check_airborne 0)

	(init_space_johnson)
	(space_vehicle_spawn_setup v_space1_ser_johnson v_space1_ser_p0 v_space1_ser_p1 v_space1_ser_p2 v_space1_ser_p3)
	(space_vehicle_setup v_space1_ser_johnson v_space1_ser_p0 v_space1_ser_p1 v_space1_ser_p2 v_space1_ser_p3)

	(wake space2_trigger)
	(wake space3_trigger)
	(wake init_relay)
	(wake init_relay_turrets)
	(wake space1_e1_dogfight)

	(fade_in 0 0 0 (game_ticks_from_seconds 1))
	(f_hud_chapter "chapter_e30_4") ; chapter title 4
	(print "game_save_no_timeout 36")
	(game_save_no_timeout)

)

(script static void space_1_soft_ceilings
	;turn off transition soft ceiling at the start of space 1
	(soft_ceiling_enable soft_ceiling_to_space_2 0)
	(soft_ceiling_enable soft_ceiling_space_3 0)
)

;(script command_script cs_turret_shoot_test
;	(cs_enable_looking true)
;	(cs_enable_targeting true)
;	;(cs_shoot_point true ps_turret_shoot_test/p0)
;	(cs_shoot true player0)
;	(sleep_forever)
;)

(script static void (space_vehicle_spawn_setup (object_name v_ser_johnson) (object_name v_ser_p0) (object_name v_ser_p1) (object_name v_ser_p2) (object_name v_ser_p3))
	; wait for all co-op players to be ready before trying to spawn seraphs
	(f_game_wait_for_player_start)
	;creating seraphs
	(object_create v_ser_p0)
	(if (coop_players_2) (object_create v_ser_p1))
	(if (coop_players_3) (object_create v_ser_p2))
	(if (coop_players_4) (object_create v_ser_p3))
	(object_create v_ser_johnson)
	(object_cannot_die v_ser_johnson true)
)

(script static void (space_vehicle_setup (vehicle v_ser_johnson) (vehicle v_ser_p0) (vehicle v_ser_p1) (vehicle v_ser_p2) (vehicle v_ser_p3))
	;load chief and johnson into seraphs
    (vehicle_load_magic (vehicle v_ser_p0) "banshee_d" player0)
	(if (coop_players_2) (vehicle_load_magic v_ser_p1 "banshee_d" player1))
	(if (coop_players_3) (vehicle_load_magic v_ser_p2 "banshee_d" player2))
	(if (coop_players_4) (vehicle_load_magic v_ser_p3 "banshee_d" player3))


	(vehicle_set_player_interaction v_ser_p0 "banshee_d" false false)
	(if (coop_players_2) (vehicle_set_player_interaction v_ser_p1 "banshee_d" false false))
	(if (coop_players_3) (vehicle_set_player_interaction v_ser_p2 "banshee_d" false false))
	(if (coop_players_4) (vehicle_set_player_interaction v_ser_p3 "banshee_d" false false))

	(vehicle_load_magic v_ser_johnson "banshee_d" (ai_actors ai_current_ser_johnson))

	;hover for a bit
	(vehicle_hover v_ser_p0 1)
	(if (coop_players_2) (vehicle_hover v_ser_p1 1))
	(if (coop_players_3) (vehicle_hover v_ser_p2 1))
	(if (coop_players_4) (vehicle_hover v_ser_p3 1))
	(vehicle_hover v_ser_johnson 1)

	;let johnson go first
	;commandscripts called from johnson squad
	(vehicle_hover v_ser_johnson 0)
	(nav_on_space_johnson v_ser_johnson)

	;let players go
	(sleep (game_ticks_from_seconds 1)) ;give time for camera to catch up to seraph position
	(vehicle_hover v_ser_p0 0)
	(if (coop_players_2) (vehicle_hover v_ser_p1 0))
	(if (coop_players_3) (vehicle_hover v_ser_p2 0))
	(if (coop_players_4) (vehicle_hover v_ser_p3 0))
)

;==============
;space encounter 1 - dogfight
;==============

(global boolean b_johnson_e1_guide_over 0)

(script command_script cs_space1_e1_johnson_guide
	(print "******* johnson guide to space encounter 1 *******")

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	;(cs_attach_to_spline "sh_space_1_spline") ;commented out for now

	(cs_fly_by ps_space1_e1_johnson_guide/p0 2)

	(wake vo_space_hangar_exit)
	(wake mission_obj_regroup_johnson)

	(cs_fly_by ps_space1_e1_johnson_guide/p1 2)
	(cs_fly_by ps_space1_e1_johnson_guide/p2 2)
	(cs_fly_by ps_space1_e1_johnson_guide/p3 2)
	(cs_fly_by ps_space1_e1_johnson_guide/p4 2)

	;to start encounter if player has not yet it the trigger volume
	(set b_johnson_e1_guide_over 1)
)

(script dormant space1_e1_dogfight
	(sleep_until
		(or
			(= b_johnson_e1_guide_over 1)
			(volume_test_players tv_space_1_e1)
		)
	)

	(print "game_save_no_timeout 37")
	(game_save_no_timeout) ;checkpoint

	(print "******* space encounter 1 - dogfight with banshees *******")
	(set s_current_space_encounter 1)

	;spawn ai
	(ai_place gr_space1_e1_dogfight)

	;blip ai
	(blip_enemy_squads_titled sq_space1_e1_banshee5 enemy_banshee)

	(wake mission_obj_buy_time)

	(sleep_until (<= (ai_living_count sq_space1_e1_banshee5) 0) 1)
	(wake space1_e2_relays)
	(wake vo_space_relay_start)
	(wake relay_objective_control)

	(print "game_save_no_timeout 38")
	(game_save_no_timeout) ;checkpoint
)

;==============
;space encounter 2 - relays
;==============

(global real r_relay_damage_pos .5)
(global short s_relays_destroyed 0)
(global boolean b_relay_1_destroyed 0)
(global boolean b_relay_2_destroyed 0)
(global boolean b_relay_3_destroyed 0)
(global boolean b_relay_4_destroyed 0)
(global boolean b_relay_5_destroyed 0)
(global boolean b_relay_6_destroyed 0)

(script dormant space1_e2_relays
	(print "******* space encounter 2 - relay 1 *******")
	(set s_current_space_encounter 2)

	(wake music_space_relay_destroyed_30)

	;(blip_enemy_squads_titled gr_space1_relay_aa enemy_aa)

	(wake beat4_relay1_nav_loop)
	(wake beat4_relay2_nav_loop)
	(wake beat4_relay3_nav_loop)
	(wake beat4_relay4_nav_loop)
	(if
		(coop_players_3) ;three or more players
		;then spawn on control the coop relays
		(begin
			(wake beat4_relay5_nav_loop)
			(wake beat4_relay6_nav_loop)
		)
	)

	;place and control relays
	(wake relay_1_health_check)
	(wake relay_1_control)
	(wake relay_2_health_check)
	(wake relay_2_control)
	(wake relay_3_health_check)
	(wake relay_3_control)
	(wake relay_4_health_check)
	(wake relay_4_control)
	(if
		(coop_players_3) ;three or more players
		;then spawn on control the coop relays
		(begin
			(wake relay_5_health_check)
			(wake relay_5_control)
			(wake relay_6_health_check)
			(wake relay_6_control)
		)
	)

	(wake e2_banshee_spawn)

	;check when all relays are destroyed
	(if
		(coop_players_3);three or more players
		;then check for all relays
		(sleep_until
			(and
				(= b_relay_1_destroyed 1)
				(= b_relay_2_destroyed 1)
				(= b_relay_3_destroyed 1)
				(= b_relay_4_destroyed 1)
				(= b_relay_5_destroyed 1)
				(= b_relay_6_destroyed 1)
			)
		1
		)
		;else check for only the top relays
		(sleep_until
			(and
				(= b_relay_1_destroyed 1)
				(= b_relay_2_destroyed 1)
				(= b_relay_3_destroyed 1)
				(= b_relay_4_destroyed 1)
			)
		1
		)
	)

	(print "******* section 1 complete *******")
	(set b_space_1_complete 1)
	(set s_current_space_encounter 5)
	(wake vo_space_relay_destroyed)

	(to_space_2_soft_ceiling_transition)

	(print "game_save_no_timeout 40")
	(game_save_no_timeout) ;checkpoint
)

(script static void to_space_2_soft_ceiling_transition
	;space1 soft ceiling diable
	;need to flip on another that extends past the space2 trigger volume, but keeps the boudary on the opposite side of the tolerance
	(soft_ceiling_enable soft_ceiling_space_1 0)
	(soft_ceiling_enable soft_ceiling_to_space_2 1)
)

(script dormant e2_banshee_spawn
	(sleep_until (>= s_relays_destroyed 1) 1)
	(ai_place sq_space1_e2_left)

	(sleep_until (>= s_relays_destroyed 2) 1)
	(ai_place sq_space1_e2_right)

	(sleep_until (>= s_relays_destroyed 3) 1)
	(ai_place sq_space1_e2_back)

	(if
		(coop_players_3);three or more players
		;then
		(begin
			(sleep_until (>= s_relays_destroyed 4) 1)
			(ai_place sq_space1_e2_ser_coop1)

			(sleep_until (>= s_relays_destroyed 5) 1)
			(ai_place sq_space1_e2_ser_coop2)
		)
	)
)

(script dormant init_relay
	(object_create dm_relay1)
	(object_create dm_relay2)
	(object_create dm_relay3)
	(object_create dm_relay4)

	(if
		(coop_players_3) ;three or more players
		;then
		(begin
			(object_create dm_relay5_coop_diff)
			(object_create dm_relay6_coop_diff)
		)
	)

	(print "relays cannot take damage")
	(object_cannot_take_damage dm_relay1)
	(object_cannot_take_damage dm_relay2)
	(object_cannot_take_damage dm_relay3)
	(object_cannot_take_damage dm_relay4)
	(if
		(coop_players_3) ;three or more players
		;then
		(begin
			(object_cannot_take_damage dm_relay5_coop_diff)
			(object_cannot_take_damage dm_relay6_coop_diff)
		)
	)

	(sleep_until (>= s_current_space_encounter 2) 1)

	(ai_object_set_team dm_relay1 covenant)
	(ai_object_set_team dm_relay2 covenant)
	(ai_object_set_team dm_relay3 covenant)
	(ai_object_set_team dm_relay4 covenant)
	(if
		(coop_players_3) ;three or more players
		;then
		(begin
			(ai_object_set_team dm_relay5_coop_diff covenant)
			(ai_object_set_team dm_relay6_coop_diff covenant)
		)
	)
)

(script dormant init_relay_turrets
	(if
		(coop_players_3) ;three or more players
		;then
		(ai_place gr_relay_aa_3p_4p) ;spawn all groups of relay aa
		;else
		(ai_place gr_relay_aa_1p_2p) ;spawn only top groups of realy aa
	)
	(ai_set_clump gr_space1_relay_aa clump_tolerance_aa)
	(ai_designer_clump_perception_range 5000)

	(print "turrets cannot take damage and are braindead")
	;relay 1 turrets
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay1_aa/turret1))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay1_aa/turret2))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay1_aa/turret3))

	;relay 2 turrets
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay2_aa/turret1))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay2_aa/turret2))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay2_aa/turret3))

	;relay 3 turrets
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay3_aa/turret1))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay3_aa/turret2))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay3_aa/turret3))

	;relay 4 turrets
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay4_aa/turret1))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay4_aa/turret2))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay4_aa/turret3))

	;relay 5 turrets
	(if
		(coop_players_3) ;three or more players
		;then
		(begin
			(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay5_aa_diff_coop/turret1))
			(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay5_aa_diff_coop/turret2))
			(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay5_aa_diff_coop/turret3))
		)
	)
	;relay 6 turrets
	(if
		(coop_players_3) ;three or more players
		;then
		(begin
			(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay6_aa_diff_coop/turret1))
			(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay6_aa_diff_coop/turret2))
			(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_relay6_aa_diff_coop/turret3))
		)
	)
	(ai_cannot_die gr_space1_relay_aa true)
	(ai_braindead gr_space1_relay_aa true)

	(sleep_until (>= s_current_space_encounter 2) 1)

	(print "turrets can now take damage and are active")
	;relay 1 turrets
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay1_aa/turret1))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay1_aa/turret2))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay1_aa/turret3))

	;relay 2 turrets
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay2_aa/turret1))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay2_aa/turret2))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay2_aa/turret3))

	;relay 3 turrets
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay3_aa/turret1))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay3_aa/turret2))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay3_aa/turret3))

	;relay 4 turrets
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay4_aa/turret1))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay4_aa/turret2))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay4_aa/turret3))

	;relay 5 turrets
	(if
		(coop_players_3) ;three or more players
		;then
		(begin
			(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay5_aa_diff_coop/turret1))
			(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay5_aa_diff_coop/turret2))
			(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay5_aa_diff_coop/turret3))
		)
	)

	;relay 6 turrets
	(if
		(coop_players_3) ;three or more players
		;then
		(begin
			(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay6_aa_diff_coop/turret1))
			(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay6_aa_diff_coop/turret2))
			(object_can_take_damage (ai_vehicle_get_from_starting_location sq_relay6_aa_diff_coop/turret3))
		)
	)

	(ai_cannot_die gr_space1_relay_aa false)
	(ai_braindead gr_space1_relay_aa false)

	(ai_force_full_lod gr_space1_relay_aa)
)

(script dormant relay_1_control
	(print "		relay 1 control started ")
	(space1_relay_control dm_relay1 sq_relay1_aa)
	(print "		relay 1 control ended")
)

(script dormant relay_1_health_check
	(sleep_until (<= (object_get_health dm_relay1) 0)1)
	(print "******* relay 1 destroyed *******")
	;(f_unblip_flag fl_space1_e2_relay_1)
	(effect_new "fx\explosions\common\explo_cov_vert_lrg" fl_space1_explo_relay_1)
	(set b_relay_1_destroyed true)
	(set s_relays_destroyed (+ s_relays_destroyed 1))
	(print "******* relay 1 destroyed *******")
)

(script dormant relay_2_control
	(print "		relay 2 control started ")
	(space1_relay_control dm_relay2 sq_relay2_aa)
	(print "		relay 2 control ended")
)

(script dormant relay_2_health_check
	(sleep_until (<= (object_get_health dm_relay2) 0)1)
	(print "******* relay 2 destroyed *******")
	;(f_unblip_flag fl_space1_e2_relay_2)
	;(effect_new "fx\explosions\common\explo_cov_vert_lrg" fl_space1_explo_relay_2)
	(set b_relay_2_destroyed true)
	(set s_relays_destroyed (+ s_relays_destroyed 1))
	(print "******* relay 2 destroyed *******")
)

(script dormant relay_3_control
	(print "		relay 3 control started ")
	(space1_relay_control dm_relay3 sq_relay3_aa)
	(print "		relay 3 control ended")
)

(script dormant relay_3_health_check
	(sleep_until (<= (object_get_health dm_relay3) 0)1)
	(print "******* relay 3 destroyed *******")
	;(f_unblip_flag fl_space1_e2_relay_3)
	;(effect_new "fx\explosions\common\explo_cov_vert_lrg" fl_space1_explo_relay_3)
	(set b_relay_3_destroyed true)
	(set s_relays_destroyed (+ s_relays_destroyed 1))
	(print "******* relay 3 destroyed *******")
)

(script dormant relay_4_control
	(print "		relay 4 control started ")
	(space1_relay_control dm_relay4 sq_relay4_aa)
	(print "		relay 4 control ended")
)

(script dormant relay_4_health_check
	(sleep_until (<= (object_get_health dm_relay4) 0)1)
	(print "******* relay 4 destroyed *******")

	;(effect_new "fx\explosions\common\explo_cov_vert_lrg" fl_space1_explo_relay_4)
	(set b_relay_4_destroyed true)
	(set s_relays_destroyed (+ s_relays_destroyed 1))
	(print "******* relay 4 destroyed *******")
)

(script dormant relay_5_control
	(print "		relay 5 control started ")
	(space1_relay_control dm_relay5_coop_diff sq_relay5_aa_diff_coop)
	(print "		relay 5 control ended")
)

(script dormant relay_5_health_check
	(sleep_until (<= (object_get_health dm_relay5_coop_diff) 0)1)
	(print "******* relay 5 destroyed *******")

	;(effect_new "fx\explosions\common\explo_cov_vert_lrg" fl_space1_explo_relay_5)
	(set b_relay_5_destroyed true)
	(set s_relays_destroyed (+ s_relays_destroyed 1))
	(print "******* relay 5 destroyed *******")
)

(script dormant relay_6_control
	(print "		relay 6 control started ")
	(space1_relay_control dm_relay6_coop_diff sq_relay6_aa_diff_coop)
	(print "		relay 6 control ended")
)

(script dormant relay_6_health_check
	(sleep_until (<= (object_get_health dm_relay6_coop_diff) 0)1)
	(print "******* relay 6 destroyed *******")

	;(effect_new "fx\explosions\common\explo_cov_vert_lrg" fl_space1_explo_relay_6)
	(set b_relay_6_destroyed true)
	(set s_relays_destroyed (+ s_relays_destroyed 1))
	(print "******* relay 6 destroyed *******")
)

(script static void (space1_relay_control (device relay) (ai turrets))
	;use delay unless defending turret squad is dead
	(sleep_until (= (ai_living_count turrets) 0) 1)

	(device_set_position relay .5)
	(sleep_until (>= (device_get_position relay) r_relay_damage_pos) 1)
	(object_can_take_damage relay)
	(f_blip_object relay 1)
)

;==============
;space encounter 5 - leave area to debris field
;==============

(script command_script cs_space1_e5_johnson_guide
	(print "******* johnson guide to space to section 2 *******")
	(cs_ignore_obstacles true)

	(wake mission_obj_debris_field)

	(cs_fly_to ps_space1_e5_johnson_guide/p0)
	(cs_fly_to ps_space1_e5_johnson_guide/p1)
	(cs_fly_to ps_space1_e5_johnson_guide/p2)
)

;====================================================================================================================================================================================================
; space section 2 =====================================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant space2_trigger
	;sleep until space 1 is compplete
	(sleep_until (= b_space_1_complete 1) 1)

	;johnson leads player to section 2 trigger
	(wake vo_space_to_debris)
	(f_blip_flag fl_space1_e5_to_debris_field 0)
	(cs_run_command_script sq_seraph_johnson cs_space1_e5_johnson_guide)
	(sleep_until (script_finished "vo_space_to_debris") 1)

	(print "space 2 - ready for transition")
	(sleep_until (volume_test_players tv_space_2_trigger) 1 (game_ticks_from_seconds 15))

	(f_unblip_flag fl_space1_e5_to_debris_field)

	(print "******* switching to spacee 2 *******")
	(fade_out 0 0 0 (game_ticks_from_seconds 1))

	(sleep (game_ticks_from_seconds 1))

	(print "gr_space1_encounters clean up")
	(ai_erase gr_space1_encounters) ;clean up
	(garbage_collect_unsafe) ;it's okay the screen will be black

	(object_destroy_folder of_space1_vehicles)

	(ai_set_objective ai_current_ser_johnson obj_space2_unsc)

	(wake begin_beat4_section2)
)

(script dormant ins_space_2_catch_up
	(print "******* insertion space 2 catch up *******")
	(enable_space_debris)
	(fade_out 0 0 0 0)

	(init_space_johnson)

	(wake begin_beat4_section2)
	(wake space3_trigger)
	(set b_space_started 1)
	;don't check if player is airborne during space section
	(set player_respawn_check_airborne 0)
)

(script dormant begin_beat4_section2
	(print "******* beat 4: space section 2 *******")

	(print "current space encounter 6")
	(set s_current_space_encounter 6)

	(space_vehicle_spawn_setup v_space2_ser_johnson v_space2_ser_p0 v_space2_ser_p1 v_space2_ser_p2 v_space2_ser_p3)
	(space_vehicle_setup v_space2_ser_johnson v_space2_ser_p0 v_space2_ser_p1 v_space2_ser_p2 v_space2_ser_p3)

	(space_2_and_3_soft_ceilings)

	(object_create_folder of_space)
	(wake space_debris_velocity_nudge)

	(fade_in 0 0 0 (game_ticks_from_seconds 1))
	(print "game_save_no_timeout 41")
	(game_save_no_timeout) ;checkpoint

	(wake space2_e8_marine_rescue)

)

(global real r_rand_upper 5)
(global real r_rand_lower -5)

(script dormant space_debris_velocity_nudge
	;panels crates
	(f_set_crate_velocity panel_a)
	(f_set_crate_velocity panel_a2)
	(f_set_crate_velocity panel_a3)
	(f_set_crate_velocity panel_a4)
	(f_set_crate_velocity panel_a5)
	(f_set_crate_velocity panel_a6)
	(f_set_crate_velocity panel_a7)
	(f_set_crate_velocity panel_a8)
	(f_set_crate_velocity panel_a9)
	(f_set_crate_velocity panel_a10)
	(sleep 5)
	(f_set_crate_velocity panel_a11)
	(f_set_crate_velocity panel_a12)
	(f_set_crate_velocity panel_a13)
	(f_set_crate_velocity panel_a14)
	(f_set_crate_velocity panel_a15)
	(f_set_crate_velocity panel_a16)
	(f_set_crate_velocity panel_a17)
	(f_set_crate_velocity panel_a18)
	(f_set_crate_velocity panel_a19)
	(f_set_crate_velocity panel_a20)
	(sleep 5)
	(f_set_crate_velocity panel_a21)
	(f_set_crate_velocity panel_a23)
	(f_set_crate_velocity panel_a24)
	(f_set_crate_velocity panel_a25)
	(f_set_crate_velocity panel_a26)
	(f_set_crate_velocity panel_a27)

	;support crates
	(f_set_crate_velocity support_a)
	(f_set_crate_velocity support_a2)
	(f_set_crate_velocity support_a3)
	(f_set_crate_velocity support_a4)
	(f_set_crate_velocity support_a5)
	(f_set_crate_velocity support_a6)
	(f_set_crate_velocity support_a7)
	(f_set_crate_velocity support_a8)

	;thruster crates
	(f_set_crate_velocity thruster_a)
	(f_set_crate_velocity thruster_a2)
	(sleep 5)
	(f_set_crate_velocity thruster_a3)
	(f_set_crate_velocity thruster_a4)
	(f_set_crate_velocity thruster_a5)
	(f_set_crate_velocity thruster_a6)
	(f_set_crate_velocity thruster_a7)
	(f_set_crate_velocity thruster_a8)
	(f_set_crate_velocity thruster_a9)
	(f_set_crate_velocity thruster_a10)
	(f_set_crate_velocity thruster_a11)
	(f_set_crate_velocity thruster_a12)
	(sleep 5)
	(f_set_crate_velocity thruster_a13)
	(f_set_crate_velocity thruster_a14)
	(f_set_crate_velocity thruster_a15)
	(f_set_crate_velocity thruster_a16)
	(f_set_crate_velocity thruster_a17)
	(f_set_crate_velocity thruster_a18)
	(f_set_crate_velocity thruster_a19)
	(f_set_crate_velocity thruster_a20)
	(f_set_crate_velocity thruster_a21)
	(f_set_crate_velocity thruster_a22)
	(sleep 5)
	(f_set_crate_velocity thruster_a23)
	(f_set_crate_velocity thruster_a24)
	(f_set_crate_velocity thruster_a25)
	(f_set_crate_velocity thruster_a26)
)

(script static void (f_set_crate_velocity (object crate))
	(object_set_velocity crate (real_random_range r_rand_lower r_rand_upper) (real_random_range r_rand_lower r_rand_upper) (real_random_range r_rand_lower r_rand_upper))
)

(script static void space_2_and_3_soft_ceilings
	;turn off transition soft ceiling since we no longer need it
	(soft_ceiling_enable soft_ceiling_to_space_2 0)
	;turn on space 2/3 soft ceiling
	(soft_ceiling_enable soft_ceiling_space_3 1)
)

;==============
;space 2 encounter 6 - johnson guide
;==============

(global boolean b_johnson_e6_guide_over 0)

(script command_script cs_space2_e6_johnson_guide
	(print "******* johnson guide to space 2 encounter 6 *******")

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	(cs_fly_by ps_space2_e6_johnson_guide/p0 .5)
	(wake vo_space_debris_follow)
	(cs_fly_by ps_space2_e6_johnson_guide/p1)
	;(cs_vehicle_boost true)
	(cs_fly_by ps_space2_e6_johnson_guide/p2)
	(cs_fly_by ps_space2_e6_johnson_guide/p3)
	;(cs_vehicle_boost false)
	(cs_fly_by ps_space2_e6_johnson_guide/p4)

	(set b_johnson_e6_guide_over 1)
)

;==============
;space 2 encounter 8 - rescue marines
;==============

(global short s_space_2_e8_rescue_part 0)
(global boolean b_space_2_e8_marines_placed 0)
(global boolean b_e8_wave_a_ready 0)
(global boolean b_e8_wave_b_ready 0)
(global boolean b_e8_wave_b_all_spawned 0)
(global boolean b_e8_wave_c_ready 0)
(global boolean b_e8_wave_c_all_spawned 0)
(global short s_e8_wave_spawn_clamp 5)

(script dormant space2_e8_marine_rescue
	(ai_place gr_space2_side_aa)

	;allow squads to spawn in with higher current enemy count when 3+ coop
	(if (coop_players_3) (set s_e8_wave_spawn_clamp 7))

	(sleep_until
		(or
			(= b_johnson_e6_guide_over 1)
			(volume_test_players tv_space_2_e8)
		)
	)

	(print "game_save_no_timeout 42")
	(game_save_no_timeout) ;checkpoint

	(print "current space encounter 8")
	(set s_current_space_encounter 8)

	(print "******* space 2 encounter 8 - rescue marines *******")
	(wake vo_space_marines_escape)
	(wake mission_obj_protect_marines)
	(wake space2_e8_wave_a_control)
	(wake space2_e8_wave_b_control)
	(wake space2_e8_wave_c_control)

	(print "marines spawned")
	(ai_place sq_space2_marines)
	(ai_cannot_die sq_space2_marines/gunner true)
	(ai_cannot_die sq_space2_marines/pilot true)
	(nav_on_marines)
	(set b_space_2_e8_marines_placed 1)

	;wave a
	(sleep (game_ticks_from_seconds 3)) ;temp timing
	(set b_e8_wave_a_ready 1)

	;wave b
	(sleep_until (>= s_space_2_e8_rescue_part 1) 1 (game_ticks_from_seconds 90))
	(set b_e8_wave_b_ready 1)

	(garbage_collect_now) ;reduce the object count

	;wave c
	(sleep_until (>= s_space_2_e8_rescue_part 2) 1 (game_ticks_from_seconds 120))
	(set b_e8_wave_c_ready 1)

	;don't start the final sleep check until the last wave has spawned
	(sleep_until (= b_e8_wave_c_all_spawned 1) 1)

	(sleep_until (= (ai_living_count gr_space2_e8_cov) 0) 1 (game_ticks_from_seconds 180))

	;kill stagglers incase they get stuck
	(if (> (ai_living_count gr_space2_e8_cov) 0)
		;then
		(ai_kill gr_space2_e8_cov)
	)

	(wake vo_space_marines_saved)
	(cs_run_command_script sq_space2_marines cs_space2_marines_end)

	(print "game_save_no_timeout 44")
	(game_save_no_timeout) ;checkpoint

	(unblip_marines)

	;let the player breath a bit until the next encounter starts
	(sleep_until (= b_marines_saved_vo_played 1) 1)
	(sleep (game_ticks_from_seconds 5))

	(garbage_collect_now) ;reduce the object count

	(print "encounter 8 over")
	(space_2_complete)
)

(script dormant space2_e8_wave_a_control
	(sleep_until (= b_e8_wave_a_ready 1) 1)
	(print "space 2 encounter 8 wave a - all squads spawned")

	;spawn all enemies in wave then blip them
	(ai_place gr_space2_e8_a)
	(blip_enemy_squads sq_space2_e8_a_ban3)
	;these squads are setup not to spawn with lower player count or difficulty
	(if (coop_players_3) (blip_enemy_squads_titled sq_space2_e8_a_ser_coop enemy_seraph))
	(if (or (difficulty_heroic) (difficulty_legendary)) (blip_enemy_squads_titled sq_space2_e8_a_ser_diff enemy_seraph))
)

(script dormant space2_e8_wave_b_control
	(sleep_until (= b_e8_wave_b_ready 1) 1)
	(print "space 2 encounter 8 wave b - ready")

	;spawn default enemies then blip them
	(space2_e8_wave_spawn_sleep)
	(print "space 2 encounter 8 wave b - default squads spawned")
	(ai_place sq_space2_e8_b_ban3)
	(ai_place sq_space2_e8_b_seraph2)
	(blip_enemy_squads sq_space2_e8_b_ban3)
	(blip_enemy_squads_titled sq_space2_e8_b_seraph2 enemy_seraph)

	;coop or higher difficulty squads
	(space2_e8_wave_spawn_sleep)
	(print "space 2 encounter 8 wave b - coop/difficulty squads spawned")
	(if (coop_players_3)
		;then
		(begin
			(ai_place sq_space2_e8_b_ser_coop)
			(blip_enemy_squads_titled sq_space2_e8_b_ser_coop enemy_seraph)
		)
	)
	(if
		(or (difficulty_heroic) (difficulty_legendary))
		;then
		(begin
			(ai_place sq_space2_e8_b_ban_diff)
			(blip_enemy_squads sq_space2_e8_b_ban_diff)
		)
	)
	;wave b all has spawned
	(set b_e8_wave_b_all_spawned 1)
)

(script dormant space2_e8_wave_c_control
	(sleep_until
		(and
			(= b_e8_wave_c_ready 1)
			(= b_e8_wave_b_all_spawned 1)
		)
		1
	)

	(space2_e8_wave_spawn_sleep)
	(print "space 2 encounter 8 wave c - default squads spawned")
	(ai_place sq_space2_e8_c_ban3)
	(ai_place sq_space2_e8_c_seraph2)
	(blip_enemy_squads sq_space2_e8_c_ban3)
	(blip_enemy_squads_titled sq_space2_e8_c_seraph2 enemy_seraph)

	;coop or higher difficulty squads
	(space2_e8_wave_spawn_sleep)
	(print "space 2 encounter 8 wave c - coop/difficulty squads spawned")
	(if (coop_players_3)
		;then
		(begin
			(ai_place sq_space2_e8_c_ser_coop)
			(blip_enemy_squads_titled sq_space2_e8_c_ser_coop enemy_seraph)
		)
	)
	(if
		(or (difficulty_heroic) (difficulty_legendary))
		;then
		(begin
			(ai_place sq_space2_e8_c_ban_diff)
			(blip_enemy_squads sq_space2_e8_c_ban_diff)
		)
	)
	;wave c all has spawned
	(set b_e8_wave_c_all_spawned 1)
)

(script static void space2_e8_wave_spawn_sleep
	;give a moment for in between spawning squads
	(sleep (game_ticks_from_seconds 5))
	;ensure not too many enemies are spawned at the same time
	(sleep_until (<= (ai_living_count gr_space2_e8_cov) s_e8_wave_spawn_clamp) 1)
)

(script command_script cs_space2_marines_enter
	(cs_vehicle_speed 1)
	(cs_fly_by ps_space2_e8_marines_start/p0 30)
	(cs_fly_by ps_space2_e8_marines_start/p1 30)
	(set s_space_2_e8_rescue_part 1)
	(cs_fly_by ps_space2_e8_marines_start/p2 30)
	(set s_space_2_e8_rescue_part 2)
	(cs_fly_by ps_space2_e8_marines_start/p3 30)
	(set s_space_2_e8_rescue_part 3)
	(cs_fly_by ps_space2_e8_marines_start/p4 30)
	(set s_space_2_e8_rescue_part 4)
	(cs_fly_by ps_space2_e8_marines_start/p5 30)
)

(script command_script cs_space2_marines_gunner
	(cs_shoot true gr_space2_e8_cov)
	(sleep_forever)
)

(script command_script cs_space2_marines_end
	(cs_vehicle_speed 1)
	(cs_fly_by ps_space2_e8_marines_end/p0 .5)
	(cs_fly_by ps_space2_e8_marines_end/p1 .5)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script command_script cs_banshee_chase
	(ai_set_clump ai_current_actor clump_banshees)
	(ai_designer_clump_perception_range 5000)
)

(script static void space_2_complete
	(print "******* section 2 complete *******")
	(set b_space_2_complete 1)
	(wake space2_bop_entrance)
	(set s_current_space_encounter 10)
)

(global boolean b_bop_entrance_ready 0)

(script dormant space2_bop_entrance
	(wake vo_space_burden_on_the_way)
	(f_blip_flag fl_space3_burden_check 0)
	(print "budren look flag check started")
	;give time for the player to be look in the right spot
	(sleep_until (objects_can_see_flag (players) fl_space3_burden_check 15) 1 (game_ticks_from_seconds 10))
	(print "budren look flag check completed")
	;don't trigger the vfx/spawn in burden if player is too close
	(sleep_until (> (objects_distance_to_flag (players) fl_space3_burden_check) 200) 1) ;within 609.6 meters or 200 world units
	(print "budren distance flag check completed")
	(wake vo_space_burden_detected)
	(sleep_until (= b_vo_burden_detected_played 1) 1)
	(f_unblip_flag fl_space3_burden_check)
	(sleep (game_ticks_from_seconds 1))

	(print "vfx - slipspace effect")
	(effect_new "fx/vignettes/e30/bop_slipspace_arrival" fl_space3_burden_check)

	(sleep (game_ticks_from_seconds 0.30)) ;allow a bit of time before bop spawns

	(set b_bop_entrance_ready 1) ;this will spawn the bop
)

(script command_script cs_space_2_side_aa_1
	(cs_aim true  ps_space2_e8_marines_start/p0)
	;(cs_shoot_point true ps_space2_e8_marines_start/p0)

	(sleep_until (>= s_current_space_encounter 8) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p0)

	(sleep_until (>= s_space_2_e8_rescue_part 1) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p2)

	(sleep_until (>= s_space_2_e8_rescue_part 2) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p4)

	(sleep_until (>= s_space_2_e8_rescue_part 3) 1)
	(print "turrets no longer shoot")
	(cs_shoot false)
	(ai_braindead ai_current_actor true)

	;sleep until space 3 section
	(sleep_until
		(and
			(= b_prophet_escapes_vo_played 1)
			(>= (device_get_position dm_bop) r_burden_pos_6)
		)
		1
	)
	(ai_braindead ai_current_actor false)

	;(cs_shoot_point true (ai_nearest_point sq_bop_aa/turret_6 ps_space3_bop_pos_path))

	(cs_shoot_point true ps_space3_bop_pos_path/p15)

	(sleep_until (script_started "vo_space_outro") 1)
	(cs_shoot false)
	(ai_braindead ai_current_actor true)
)

(script command_script cs_space_2_side_aa_2
	(cs_aim true  ps_space2_e8_marines_start/p0)
	;(cs_shoot_point true ps_space2_e8_marines_start/p0)

	(sleep_until (>= s_current_space_encounter 8) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p1)

	(sleep_until (>= s_space_2_e8_rescue_part 1) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p3)

	(sleep_until (>= s_space_2_e8_rescue_part 2) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p4)

	(sleep_until (>= s_space_2_e8_rescue_part 3) 1)
	(print "turrets no longer shoot")
	(cs_shoot false)

	;sleep until space 3 section
	(sleep_until
		(and
			(= b_prophet_escapes_vo_played 1)
			(>= (device_get_position dm_bop) r_burden_pos_6)
		)
		1
	)
	(ai_braindead ai_current_actor false)

	(cs_shoot_point true ps_space3_bop_pos_path/p15)

	(sleep_until (script_started "vo_space_outro") 1)
	(cs_shoot false)
	(ai_braindead ai_current_actor true)
)

(script command_script cs_space_2_big_left_aa
	(cs_aim true  ps_space2_e8_marines_start/p0)
	;(cs_shoot_point true ps_space2_e8_marines_start/p0)

	(sleep_until (>= s_current_space_encounter 8) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p1)

	(sleep_until (>= s_space_2_e8_rescue_part 1) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p3)

	(sleep_until (>= s_space_2_e8_rescue_part 2) 1)
	(cs_shoot_point true ps_space2_e8_aa_targets/p4)

	(sleep_until (>= s_space_2_e8_rescue_part 3) 1)
	(print "turrets no longer shoot")
	(cs_shoot false)

	;sleep until space 3 section
	(sleep_until
		(and
			(= b_prophet_escapes_vo_played 1)
			(>= (device_get_position dm_bop) r_burden_pos_6)
		)
		1
	)
	(ai_braindead ai_current_actor false)

	(cs_shoot_point true ps_space3_bop_pos_path/p15)

	(sleep_until (script_started "vo_space_outro") 1)
	(cs_shoot false)
	(ai_braindead ai_current_actor true)
)

;==============
;space encounter 10 - leave area to proof of burden
;==============

(script command_script cs_space2_end_johnson_guide
	(print "******* johnson guide to space 3 *******")
	(cs_fly_to ps_space2_end_johnson_guide/p2)
	(cs_fly_to ps_space2_end_johnson_guide/p3)
	(cs_fly_to ps_space2_end_johnson_guide/p4)
)

;====================================================================================================================================================================================================
; space section 3 ===================================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant space3_trigger
	;sleep until space 2 is compplete
	(sleep_until (= b_space_2_complete 1) 1)
	(print "space 2 end")

	(sleep_until (= b_bop_entrance_ready 1) 1)

	(object_create dm_bop)
	(nav_on_bop dm_bop)
	(wake space3_burden_control)

	(sleep (game_ticks_from_seconds 5))

	(wake vo_space_burden_arrival)

	(sleep_until
		(or
			(volume_test_players tv_space_3_trigger)
			(>= (device_get_position dm_bop) .1)
		)
		1
	)

	(print "******* starting spacee 3 *******")

	(ai_set_objective ai_current_ser_johnson obj_space3_unsc)

	(wake begin_beat4_section3)
)

(script dormant ins_space_3_catch_up
	(print "******* insertion space 3 catch up *******")
	(enable_space_debris)
	(fade_out 0 0 0 0)

	(init_space_johnson)

	(wake begin_beat4_section3)

	(space_vehicle_spawn_setup v_space3_ser_johnson v_space3_ser_p0 v_space3_ser_p1 v_space3_ser_p2 v_space3_ser_p3)
	(space_vehicle_setup v_space3_ser_johnson v_space3_ser_p0 v_space3_ser_p1 v_space3_ser_p2 v_space3_ser_p3)

	(object_create dm_bop)
	(device_set_position_immediate dm_bop .1)
	(wake space3_burden_control)
	(wake space3_e11_johnson_start)

	(space_2_and_3_soft_ceilings)

	(ai_place gr_space2_side_aa)
	(set s_space_2_e8_rescue_part 4);for tolerance turret ai to get to the space 3 section of the command script

	(set b_space_started 1)
	;don't check if player is airborne during space section
	(set player_respawn_check_airborne 0)

	(fade_in 0 0 0 (game_ticks_from_seconds 1))

)

(script command_script cs_space3_e11_johnson_start
	(print "******* johnson guide to space 2 encounter 6 *******")

	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	(cs_fly_by ps_space3_start/p_johnson_goto .5)
)

(script dormant begin_beat4_section3
	(print "******* beat 4: space section 3 *******")

	(print "current space encounter 11")
	(set s_current_space_encounter 11)

	(print "game_save_no_timeout 48")
	(game_save_no_timeout) ;checkpoint

	(wake space3_e11_protect)
	(wake e30_game_won)
)

(script dormant space3_e11_johnson_start
	(cs_run_command_script ai_current_ser_johnson cs_space3_e11_johnson_start)
)

;==============
;space 3 encounter 11 - protect the burden
;==============
(global boolean b_kamikaze_wave_spawned 0)
(global boolean b_kamikaze_wave_2_spawned 0)

(script dormant space3_e11_protect

	(object_immune_to_friendly_damage ai_current_ser_johnson true)

	(wake vo_space_burden_encounter_start)

	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_1) 1)

	(sleep (game_ticks_from_seconds 5))

	;kamikaze section 1
	(print "space3 e11 kamikaze section 1")
	(print "	kamikazi a")
	;1 on normal and additonal per heroic/legendary, 2p coop, and +3p coop
	(ai_place sq_space3_e11_a_kamikaze)
	(wake vo_space_kamikaze_incoming)

	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_2) 1)
	;1 on normal and additonal per heroic/legendary, 2p coop, and +3p coop
	(print "	kamikazi b")
	(ai_place sq_space3_e11_b_kamikaze)

	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_3) 1)
	;1 on normal and additonal per heroic/legendary, 2p coop, and +3p coop
	(print "	kamikazi c")
	(ai_place sq_space3_e11_c_kamikaze)

	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_4) 1)
	;2 on normal and additonal per heroic/legendary, 2p coop, and +3p coop
	(print "	kamikazi d")
	(ai_place sq_space3_e11_d_kamikaze)

	(set b_kamikaze_wave_spawned 1)
	(wake music_kamikaze_progression_36)

	;dogfight wave
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_5) 1)

	(garbage_collect_now) ;reduce the object count
	(sleep (game_ticks_from_seconds .5))

	(print "space3 e11 dogfight")

	(print "game_save_no_timeout 51")
	(game_save_no_timeout) ;checkpoint

	(wake vo_space_williams_update)

	(sleep (game_ticks_from_seconds 2))

	(ai_place sq_space3_e11_e_ban5)
	;additonal 2 on heroic/legendary, 2 on 2p coop, & 2 on +3p coop
	(ai_place sq_space3_e11_e_ser)

	(sleep (game_ticks_from_seconds 3))

	(wake vo_space_e11_dogfight)
	(blip_enemy_squads gr_space3_dogfight)

	(sleep_until (= (ai_living_count gr_space3_dogfight) 0) 1)

	;vignette
	(wake vo_space_prophet_escapes)
	(ai_place sq_space3_harmony) ;runs commands script when placed

	;wait to finish remaining vo_space_prophet_escapes lines until player looks at flag or ten seconds pass
	(sleep_until (objects_can_see_object (players) sq_space3_harmony 15) 1 (game_ticks_from_seconds 10))
	(set b_harmony_look_check 1)
	(print "space3 e11 harmony look check completed")

	(garbage_collect_now) ;reduce the object count

	;kamikaze section 2
	(sleep_until
		(and
			(= b_prophet_escapes_vo_played 1)
			(>= (device_get_position dm_bop) r_burden_pos_6)
		)
		1
	)

	(print "space3 e11 kamikaze section 2")

	;1 on normal and additonal per heroic/legendary, 2p coop, and +3p coop
	(print "	kamikazi f")
	(ai_place sq_space3_e11_f_kamikaze)
	;5 on normal and additonal 3 on 3p coop
	(ai_place sq_space3_e11_f_ban5)

	(set b_kamikaze_wave_2_spawned 1)

	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_7) 1)
	;1 on normal and additonal per heroic/legendary, 2p coop, and +3p coop
	(print "	kamikazi g")
	(ai_place sq_space3_e11_g_kamikaze)

	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_8) 1)
	;1 on normal and additonal per heroic/legendary, 2p coop, and +3p coop
	(print "	kamikazi h")
	(ai_place sq_space3_e11_h_kamikaze)
	;5 on normal and additonal 3 on 3p coop
	(ai_place sq_space3_e11_h_ban5)

	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_9) 1)
	;1 on normal and additonal per heroic/legendary, 2p coop, and +3p coop
	(print "	kamikazi i")
	(ai_place sq_space3_e11_i_kamikaze)

	(wake vo_space_kamikaze_destroyed_trigger)

	;tolerance shield vignette
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_final) 1)

	(damage_object (ai_vehicle_get gr_space3_banshees) "hull" 5000)
	(ai_kill gr_space3_banshees)

	(damage_object (ai_vehicle_get gr_space2_side_aa) "body" 5000)
	(ai_kill gr_space2_side_aa)

	(f_blip_flag fl_e11_shield_vign_look_check 0)

	(garbage_collect_now) ;reduce the object count

	(sleep_until (objects_can_see_flag (players) fl_e11_shield_vign_look_check 15) 1 (game_ticks_from_seconds 10))
	(print "tolerance shield check over")
	(set b_tol_shield_look_check 1)
	(f_unblip_flag fl_e11_shield_vign_look_check)

	(wake vo_space_outro)
	(print "vfx stub - tolerance shield dissipates")
	(effect_new "fx\vignettes\e30\tolerance_shield_dissolve" fl_space3_e11_shield_vignetee)

	;sleep until vo finishes
	(sleep_until (script_finished "vo_space_outro") 1)

	(wake mission_obj_regroup_bop_final)

	;pause for better flow into outro cinematic
	;(sleep  (game_ticks_from_seconds 4))

	(set b_space_3_complete 1)
)

(global real r_burden_pos_1 	.10)
(global real r_burden_pos_2 	.20)
(global real r_burden_pos_3 	.27)
(global real r_burden_pos_4 	.34)
(global real r_burden_pos_5 	.42)
(global real r_burden_pos_5_5	.55)
(global real r_burden_pos_6 	.60)
(global real r_burden_pos_7 	.68)
(global real r_burden_pos_8 	.75)
(global real r_burden_pos_9 	.83)
(global real r_burden_pos_final .9)

(script dormant space3_burden_control
	(bop_load_gunners dm_bop)
	;(wake test_debug_bop_position)

	(print "device power 1 and position 1")
	(device_set_position dm_bop 1)
	(device_set_power dm_bop 1)

	;starting position
	(print "	burden position start")
	(nav_on_bop dm_bop)

	;second position
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_1) 1)
	(print "	burden position 1")

	;third position
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_2) 1)
	(print "	burden position 2")

	;forth position
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_3) 1)
	(print "	burden position 3")

	;fith position
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_4) 1)
	(print "	burden position 4")

	;sixth position
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_5) 1)
	(print "	burden position 5")

	;if prophet moment has not started slow down
	(if (= b_prophet_escapes_vo_played 0)
		;then
		(device_set_power dm_bop .75)
	)

	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_5_5) 1)
	(print "	burden position 5.5")

	;let player see prophet moment before starting up
	(if (= b_harmony_vign_over 0)
		;then
		(device_set_power dm_bop 0)
	)

	(sleep_until (= b_harmony_vign_over 1) 1)

	;return to full speed
	(device_set_power dm_bop 1)

	;seventh position
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_6) 1)
	(print "	burden position 6")

	;eighth position
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_7) 1)
	(print "	burden position 7")

	;eighth position
	;(sleep_until (>= (device_get_position dm_bop) r_burden_pos_7) 1)
	;(print "	burden position 7")

	;final position
	(sleep_until (>= (device_get_position dm_bop) r_burden_pos_final) 1)
	(print "	burden position final")
)

(script static void (kamikaze_spawn_setup (ai squad))
	;make kamikaze seraphs weaker
	(units_set_current_vitality (ai_vehicle_get squad) .5 .5)
	(object_set_shield (ai_vehicle_get squad) 0)
	(object_set_shield_stun_infinite (ai_vehicle_get squad))
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp")
	(blip_kamikaze_squads squad)
)

(script static void (kamikaze_ensure_kill (ai squad))
	(object_set_velocity (ai_vehicle_get squad) 200)
	(print "kamikaze velocity set to 200")
	(sleep_until (volume_test_object tv_bop_kamikaze_kill squad) 1 (game_ticks_from_seconds 1)) ;time out just incase kamikaze cannot get to tv
	(print "kamikaze in trigger volume or timeout has passed")
	(sleep 10) ;sleep for a bit so kamikaze seraph can get closer to bop
	(print "kill kamikaze")
	(damage_object (ai_vehicle_get squad) "hull" 5000)
	(ai_kill squad)
)

(script command_script cs_kamikaze_seraph_t_left
	(kamikaze_spawn_setup ai_current_actor)
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true) ;needed for the kamikaze seraphs to not be affected by the pathfinding spheres on the bop

	(print "kamikaze flying to kamikaze_fly_to_left_far")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_left_far")

	(print "kamikaze flying to kamikaze_fly_to_left_mid")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_left_mid")

	(print "kamikaze flying to kamikaze_fly_to_left")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_left")

	(kamikaze_ensure_kill ai_current_actor)
)

(script command_script cs_kamikaze_seraph_t_right
	(kamikaze_spawn_setup ai_current_actor)
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true) ;needed for the kamikaze seraphs to not be affected by the pathfinding spheres on the bop

	(print "kamikaze flying to kamikaze_fly_to_right_far")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_right_far")

	(print "kamikaze flying to kamikaze_fly_to_right_mid")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_right_mid")

	(print "kamikaze flying to kamikaze_fly_to_top")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_top")

	(kamikaze_ensure_kill ai_current_actor)
)

(script command_script cs_kamikaze_seraph_b_left
	(kamikaze_spawn_setup ai_current_actor)
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true) ;needed for the kamikaze seraphs to not be affected by the pathfinding spheres on the bop

	(print "kamikaze flying to kamikaze_fly_to_b_left_far")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_b_left_far")

	(print "kamikaze flying to kamikaze_fly_to_left_mid")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_left_mid")

	(print "kamikaze flying tokamikaze_fly_to_left")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_left")

	(kamikaze_ensure_kill ai_current_actor)
)

(script command_script cs_kamikaze_seraph_b_right
	(kamikaze_spawn_setup ai_current_actor)
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true)

	(print "kamikaze flying to kamikaze_fly_to_b_right_far")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_b_right_far")

	(print "kamikaze flying to kamikaze_fly_to_right_mid")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_right_mid")

	(print "kamikaze flying to kamikaze_fly_to_right")
	(cs_fly_to_object_marker dm_bop "kamikaze_fly_to_right")

	(kamikaze_ensure_kill ai_current_actor)
)

(global boolean b_harmony_vign_over 0)

(script command_script cs_harmony
	(f_blip_ai_vehicles_labelled ai_current_actor 1 enemy_harmony)
	(cs_fly_by ps_space3_harmony/p0)
	(cs_fly_by ps_space3_harmony/p1)
	(unblip_enemy_squads ai_current_actor)
	(cs_fly_by ps_space3_harmony/p2)
	(cs_fly_to ps_space3_harmony/p3)
	;(cs_fly_to ps_space3_harmony/p4)

	(ai_enable_stuck_flying_kill ai_current_actor true)
	(ai_set_stuck_velocity_threshold ai_current_actor 1)
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp")
	(object_set_velocity (ai_vehicle_get ai_current_actor) 1000)
	(cs_pause 5)
	(object_set_scale (unit_get_vehicle ai_current_actor) 0.01 (game_ticks_from_seconds 2))
	(set b_harmony_vign_over 1)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script static void (space3_banshee_spawn_clamp (ai squad) (ai group))
	(ai_place
		squad
		(min ; don't spawn more than 5 banshees
			5
			(max ;always spawn at least 1 banshee
				1
				(- 6 (ai_living_count group)) ;try to keep of max of 6 banshees in combat
			)
		)
	)

	(blip_enemy_squads squad)
)

(script static void (space3_seraph_spawn_clamp (ai squad) (ai group))
	(ai_place
		squad
		(min ; don't spawn more than 3 banshees
			3
			(max ;always spawn at least 1 banshee
				1
				(- 3 (ai_living_count group)) ;try to keep of max of 3 seraphs in combat
			)
		)
	)

	(blip_enemy_squads squad)
)

(script dormant e30_game_won
	(sleep_until (= b_space_3_complete 1) 1)

	(print "******* you win!!!!! *******")
	(fade_out 0 0 0 30)
	(disable_space_debris)
	(set s_music_trigger_e30 400)
	(submit_incident_with_custom_string_id "game_activity_end_completed" "e30")
	(f_play_cinematic cinematics\e30\e30_mac.cinematic)
	(game_won)
)

;====================================================================================================================================================================================================
; utility space scripts ==============================================================================================================================================================================
;====================================================================================================================================================================================================

;space debris control
(script static void enable_space_debris
	(print "space debris device at 0.5")
	(device_set_position_immediate dm_space_debris 0.5)
)

(script static void disable_space_debris
	(print "space debris device at 0")
	(device_set_position_immediate dm_space_debris 0)
)

; friendly
(script static void init_space_johnson
	(cond
		((f_insertion_point_matches ins_e30_space_1) (begin
			(ai_place sq_seraph_johnson)
			(set ai_current_ser_johnson sq_seraph_johnson)
			(print "sq_seraph_johnson spawned")
		))
		((f_insertion_point_matches ins_e30_space_2) (begin
			(ai_place sq_seraph_johnson2)
			(set ai_current_ser_johnson sq_seraph_johnson2)
			(print "sq_seraph_johnson spawned")
		))
		((f_insertion_point_matches ins_e30_space_3) (begin
			(ai_place sq_seraph_johnson3)
			(set ai_current_ser_johnson sq_seraph_johnson3)
			(print "sq_seraph_johnson spawned")
		))
		;when coming from a previous insertion point than the space ones
		((= b_space_started 1) (begin
			(ai_place sq_seraph_johnson)
			(set ai_current_ser_johnson sq_seraph_johnson)
			(print "sq_seraph_johnson spawned")
		))
	)
	(ai_cannot_die ai_current_ser_johnson true)
	;(nav_on_space_johnson)
)

; marking
; -------------------------------------------------------------------------------------------------
(script static void (blip_enemy_squads (ai squad))
	;(f_blip_ai squad 5)
	;(f_blip_object (unit_get_vehicle squad) 5)
	(f_blip_ai_vehicles squad 5)
)

(script static void (blip_enemy_squads_titled (ai squad) (string_id name))
	;(f_blip_ai_labelled squad 5 name)
	(f_blip_ai_vehicles_labelled squad 5 name)
)

(script static void (blip_kamikaze_squads (ai squad))
	;(f_blip_ai_labelled squad 5 enemy_kamikaze_seraph)
	(f_blip_ai_vehicles_labelled squad 5 enemy_kamikaze_seraph)
)

(script static void (unblip_enemy_squads (ai squad))
	;(f_unblip_ai squad)
	(f_unblip_ai_vehicles squad)
)

(script static void (nav_on_space_johnson (vehicle johnson_ser))
	(print "nav on space johnson")
	;(f_blip_ai ai_current_ser_johnson 2) ;green dot
	(chud_track_object_with_priority johnson_ser 2 hero_johnson)
	(chud_track_object_set_vertical_offset johnson_ser 1)
)

(script static void nav_on_marines
	(chud_track_object_with_priority (ai_vehicle_get_from_starting_location sq_space2_marines/pilot) 2 obj_protect)
)

(script static void unblip_marines
	(f_unblip_object (ai_vehicle_get_from_starting_location sq_space2_marines/pilot))
)

(script static void (nav_on_bop (object object))
	(chud_track_object_with_priority object 2 hero_bop)
)

;nav globals
(global real r_too_far_away 200)
(global real r_too_far_away_large 400)
(global cutscene_flag last_space_flag_blip fl_space1_e1_signatures)
(global boolean b_nav_space_active 0)

;relay 1 - area flag and turrets
(script static void beat4_relay1_nav_control
	(cond
		; ---------------- space encounter 2 ----------------
		;cond - nav
		((f_nav_space_enc_flag_check 2 fl_space1_e2_relay_1 r_too_far_away_large)					(f_blip_relay_flag fl_space1_e2_relay_1 sq_relay1_aa))
		;cond - navend
		((f_navend_space_enc_flag_check 2 fl_space1_e2_relay_1 r_too_far_away_large)				(f_blip_relay_turrets fl_space1_e2_relay_1 sq_relay1_aa))
	)
)

;relay 2 - area flag and turrets
(script static void beat4_relay2_nav_control
	(cond
		; ---------------- space encounter 2 ----------------
		;cond - nav
		((f_nav_space_enc_flag_check 2 fl_space1_e2_relay_2 r_too_far_away_large)					(f_blip_relay_flag fl_space1_e2_relay_2 sq_relay2_aa))
		;cond - navend
		((f_navend_space_enc_flag_check 2 fl_space1_e2_relay_2 r_too_far_away_large)				(f_blip_relay_turrets fl_space1_e2_relay_2 sq_relay2_aa))
	)
)

;relay 3 - area flag and turrets
(script static void beat4_relay3_nav_control
	(cond
		; ---------------- space encounter 2 ----------------
		;cond - nav
		((f_nav_space_enc_flag_check 2 fl_space1_e2_relay_3 r_too_far_away_large)					(f_blip_relay_flag fl_space1_e2_relay_3 sq_relay3_aa))
		;cond - navend
		((f_navend_space_enc_flag_check 2 fl_space1_e2_relay_3 r_too_far_away_large)				(f_blip_relay_turrets fl_space1_e2_relay_3 sq_relay3_aa))
	)
)

;relay 4 - area flag and turrets
(script static void beat4_relay4_nav_control
	(cond
		; ---------------- space encounter 2 ----------------
		;cond - nav
		((f_nav_space_enc_flag_check 2 fl_space1_e2_relay_4 r_too_far_away_large)					(f_blip_relay_flag fl_space1_e2_relay_4 sq_relay4_aa))
		;cond - navend
		((f_navend_space_enc_flag_check 2 fl_space1_e2_relay_4 r_too_far_away_large)				(f_blip_relay_turrets fl_space1_e2_relay_4 sq_relay4_aa))
	)
)

;relay 5 - area flag and turrets
(script static void beat4_relay5_nav_control
	(cond
		; ---------------- space encounter 2 ----------------
		;cond - nav
		((f_nav_space_enc_flag_check 2 fl_space1_e2_relay_5 r_too_far_away_large)					(f_blip_relay_flag fl_space1_e2_relay_5 sq_relay5_aa_diff_coop))
		;cond - navend
		((f_navend_space_enc_flag_check 2 fl_space1_e2_relay_5 r_too_far_away_large)				(f_blip_relay_turrets fl_space1_e2_relay_5 sq_relay5_aa_diff_coop))
	)
)

;relay 6 - area flag and turrets
(script static void beat4_relay6_nav_control
	(cond
		; ---------------- space encounter 2 ----------------
		;cond - nav
		((f_nav_space_enc_flag_check 2 fl_space1_e2_relay_6 r_too_far_away_large)					(f_blip_relay_flag fl_space1_e2_relay_6 sq_relay6_aa_diff_coop))
		;cond - navend
		((f_navend_space_enc_flag_check 2 fl_space1_e2_relay_6 r_too_far_away_large)				(f_blip_relay_turrets fl_space1_e2_relay_6 sq_relay6_aa_diff_coop))
	)
)

;cond
(script static boolean (f_nav_space_enc_flag_check (short space_enc) (cutscene_flag f) (real distance))
	(and
		(= s_current_space_encounter space_enc)
		(> (objects_distance_to_flag (players) f) distance)
	)
)

(script static boolean (f_navend_space_enc_flag_check (short space_enc) (cutscene_flag f) (real distance))
		;(> s_current_space_encounter space_enc)
		(and
			(= s_current_space_encounter space_enc)
			(< (objects_distance_to_flag (players) f) distance)
		)
)

;results
(script static void (f_blip_one_space (cutscene_flag f))
	(f_unblip_flag last_space_flag_blip)
	(f_blip_flag f 0)
	(set last_space_flag_blip f)
	(set b_nav_space_active 1)
)

(script static void (f_unblip_space (cutscene_flag f))
	(f_unblip_flag f)
	(set b_nav_space_active 0)
)

(script static void (f_blip_relay_turrets (cutscene_flag f) (ai turret_squad))
	(f_unblip_flag f)
	(blip_enemy_squads_titled turret_squad enemy_aa)
)

(script static void (f_blip_relay_flag (cutscene_flag f) (ai turret_squad))
	(f_blip_flag f 0)
	(f_unblip_ai turret_squad)
)

(script dormant beat4_relay1_nav_loop
	;loop while b_relay_1_destroyed is false
	(sleep_until
		(begin
			(beat4_relay1_nav_control)
			(= (ai_living_count sq_relay1_aa) 0) ;exit condition
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat4_relay1_nav_loop over")
	(f_unblip_space fl_space1_e2_relay_1)
)

(script dormant beat4_relay2_nav_loop
	;loop while b_relay_2_destroyed is false
	(sleep_until
		(begin
			(beat4_relay2_nav_control)
			(= (ai_living_count sq_relay2_aa) 0) ;exit condition
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat4_relay2_nav_loop over")
	(f_unblip_space fl_space1_e2_relay_2)
)

(script dormant beat4_relay3_nav_loop
	;loop while b_relay_3_destroyed is false
	(sleep_until
		(begin
			(beat4_relay3_nav_control)
			(= (ai_living_count sq_relay3_aa) 0) ;exit condition
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat4_relay3_nav_loop over")
	(f_unblip_space fl_space1_e2_relay_3)
)

(script dormant beat4_relay4_nav_loop
	;loop while b_relay_4_destroyed is false
	(sleep_until
		(begin
			(beat4_relay4_nav_control)
			(= (ai_living_count sq_relay4_aa) 0) ;exit condition
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat4_relay4_nav_loop over")
	(f_unblip_space fl_space1_e2_relay_4)
)

(script dormant beat4_relay5_nav_loop
	;loop while b_relay_5_destroyed is false
	(sleep_until
		(begin
			(beat4_relay5_nav_control)
			(= (ai_living_count sq_relay5_aa_diff_coop) 0) ;exit condition
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat4_relay5_nav_loop over")
	(f_unblip_space fl_space1_e2_relay_5)
)

(script dormant beat4_relay6_nav_loop
	;loop while b_relay_6_destroyed is false
	(sleep_until
		(begin
			(beat4_relay6_nav_control)
			(= (ai_living_count sq_relay6_aa_diff_coop) 0) ;exit condition
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat4_relay6_nav_loop over")
	(f_unblip_space fl_space1_e2_relay_6)
)


; warping
; -------------------------------------------------------------------------------------------------
(script command_script cs_banshee_warp
	(ai_set_clump ai_current_actor clump_banshees)
	(ai_designer_clump_perception_range 1000)
	;(ai_enable_stuck_flying_kill ai_current_actor true)
	;(ai_set_stuck_velocity_threshold ai_current_actor 1)
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp") ;space banshee currently not setup with fx_warp marker
	;(if b_play_warp_sound
		;(sound_impulse_start sfx_warp (ai_vehicle_get ai_current_actor) 1.0))
	;(object_set_velocity (ai_vehicle_get ai_current_actor) 50)
)

(script command_script cs_seraph_warp
	(ai_set_clump ai_current_actor clump_seraphs)
	(ai_designer_clump_perception_range 2000)
	;(ai_enable_stuck_flying_kill ai_current_actor true)
	;(ai_set_stuck_velocity_threshold ai_current_actor 1)
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp")
	;(if b_play_warp_sound
		;(sound_impulse_start sfx_warp (ai_vehicle_get ai_current_actor) 1.0))
	;(object_set_velocity (ai_vehicle_get ai_current_actor) 100)
)

(script command_script cs_banshee_normal_spawn
	(ai_set_clump ai_current_actor clump_banshees)
	(ai_designer_clump_perception_range 1000)
)

(script command_script cs_seraph_normal_spawn
	(ai_set_clump ai_current_actor clump_seraphs)
	(ai_designer_clump_perception_range 2000)
)

; boosting
; -------------------------------------------------------------------------------------------------
(script command_script boost_5seconds
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_vehicle_boost true)
	(sleep 150)
)

(script command_script boost_10seconds
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_vehicle_boost true)
	(sleep 300)
)
(script command_script boost_20seconds
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_vehicle_boost true)
	(sleep 600)
)
(script command_script boost_infinite
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_vehicle_boost true)
	(sleep_forever)
)

; vfx
; -------------------------------------------------------------------------------------------------
(global effect fx_warp_flash "fx/vignettes/e30/fighter_slipspace_arrival")

; =================================================================================================
; bop - burden of proof
; =================================================================================================
(script static void (bop_load_gunners (device_name d))

	; right
	; -------------------------------------------------------------------------------------------------
	(print "space section 3 - burden of proof: loading bop gunners...")

	;turret 0
	(ai_place sq_bop_aa/turret_0)
	(vehicle_load_magic
		(object_at_marker d "turret_0")
		""
		(ai_get_object sq_bop_aa/turret_0))

	;turret 1
	(ai_place sq_bop_aa/turret_1)
	(vehicle_load_magic
		(object_at_marker d "turret_1")
		""
		(ai_get_object sq_bop_aa/turret_1))

	;turret 2
	(ai_place sq_bop_aa/turret_2)
	(vehicle_load_magic
		(object_at_marker d "turret_2")
		""
		(ai_get_object sq_bop_aa/turret_2))

	;turret 3
	(ai_place sq_bop_aa/turret_3)
	(vehicle_load_magic
		(object_at_marker d "turret_3")
		""
		(ai_get_object sq_bop_aa/turret_3))

	;turret 4
	(ai_place sq_bop_aa/turret_4)
	(vehicle_load_magic
		(object_at_marker d "turret_4")
		""
		(ai_get_object sq_bop_aa/turret_4))

	;turret 5
	(ai_place sq_bop_aa/turret_5)
	(vehicle_load_magic
		(object_at_marker d "turret_5")
		""
		(ai_get_object sq_bop_aa/turret_5))

	;turret 6
	(ai_place sq_bop_aa/turret_6)
	(vehicle_load_magic
		(object_at_marker d "turret_6")
		""
		(ai_get_object sq_bop_aa/turret_6))

	;turret 7
	(ai_place sq_bop_aa/turret_7)
	(vehicle_load_magic
		(object_at_marker d "turret_7")
		""
		(ai_get_object sq_bop_aa/turret_7))

	;turret 8
	(ai_place sq_bop_aa/turret_8)
	(vehicle_load_magic
		(object_at_marker d "turret_8")
		""
		(ai_get_object sq_bop_aa/turret_8))

	;turret 9
	(ai_place sq_bop_aa/turret_9)
	(vehicle_load_magic
		(object_at_marker d "turret_9")
		""
		(ai_get_object sq_bop_aa/turret_9))

	;turret 10
	(ai_place sq_bop_aa/turret_10)
	(vehicle_load_magic
		(object_at_marker d "turret_10")
		""
		(ai_get_object sq_bop_aa/turret_10))

	(ai_set_clump sq_bop_aa clump_bop_aa)
	(ai_disregard (ai_actors sq_bop_aa) true)
)

(global real r_test_debug_bop_position 0)

(script dormant test_debug_bop_position
	(debug_scripting_globals 1)
	(debug_scripting_variable 'r_test_debug_bop_position' true)
	;loop while
	(sleep_until
		(begin
			(set r_test_debug_bop_position (device_get_position dm_bop))
			(= (device_get_position dm_bop) 1) ;exit condition
		)
		1;run every 1 tick
	)
	(print "test_debug_tram_position ended")
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; _______   _______ .______    __    __    _______         _______.  ______ .______       __  .______   .___________.    _______.
;|       \ |   ____||   _  \  |  |  |  |  /  _____|       /       | /      ||   _  \     |  | |   _  \  |           |   /       |
;|  .--.  ||  |__   |  |_)  | |  |  |  | |  |  __        |   (----`|  ,----'|  |_)  |    |  | |  |_)  | `---|  |----`  |   (----`
;|  |  |  ||   __|  |   _  <  |  |  |  | |  | |_ |        \   \    |  |     |      /     |  | |   ___/      |  |        \   \
;|  '--'  ||  |____ |  |_)  | |  `--'  | |  |__| |    .----)   |   |  `----.|  |\  \----.|  | |  |          |  |    .----)   |
;|_______/ |_______||______/   \______/   \______|    |_______/     \______|| _| `._____||__| | _|          |__|    |_______/
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script continuous debug_transit
	(sleep_forever)
	(debug_transit_teleport)
)

(script static void debug_transit_teleport
	(print "debug_transit_teleport: starting")

	(f_switch_zone_set_blocking zs_start_hydro)
	;teleport to transit flag
	(print "debug_transit_teleport: teleporting players to transit flag")
	(volume_teleport_players_not_inside tv_debug_transit_teleport fl_debug_transit_teleport)
)