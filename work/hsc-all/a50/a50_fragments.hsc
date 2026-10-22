(script static boolean ai_objective_maneuver_area5_lift_muster_pelican_1_1
(= b_lift_pelican false))

(script static boolean ai_objective_maneuver_area5_lift_muster_johnson_1_2
(= b_lift_johnson false))

(script static boolean ai_objective_maneuver_area5_lift_muster_marines_1_3
(= b_lift_marines false))

(script static boolean ai_objective_maneuver_area5_lift_muster_fill_1_4
(= b_lift_fill false))

(script static boolean ai_objective_enc23_prison_mar_combat_started_2_1
(volume_test_players prison_after_reyes_saved_trigger))

(script static boolean ai_objective_enc23_prison_mar_boss_fight_2_2
(> (ai_living_count prison_out_boss) 0))

(script static boolean ai_objective_enc23_prison_mar_begin_follow_player_2_3
(< (ai_living_count prison_out_boss) 1))

(script static boolean ai_objective_enc23_prison_mar_prison_lobby_2_5
(volume_test_players tv_lobby_exit))

(script static boolean ai_objective_enc23_prison_mar_move_to_corner_2_7
(and (<= (ai_living_count prison_grunt_kamikaze) 0)  (<= (ai_living_count prison_culling_stealth) 0)) )

(script static boolean ai_objective_enc23_prison_mar_combat_started_2_10
(volume_test_players prison_after_reyes_saved_trigger))

(script static boolean ai_objective_enc23_prison_mar_begin_follow_player_2_11
(volume_test_players prison_to_prison_control_trigger))

(script static boolean ai_objective_enc23_prison_mar_follow_player_1_front_2_12
(not (game_is_cooperative)))

(script static boolean ai_objective_enc23_prison_mar_combat_started_2_16
(volume_test_players prison_after_reyes_saved_trigger))

(script static boolean ai_objective_enc23_prison_mar_begin_follow_player_2_17
(volume_test_players prison_to_prison_control_trigger))

(script static boolean ai_objective_enc23_prison_mar_follow_player_3_4_front_2_18
(> (game_coop_player_count) 2))

(script static boolean ai_objective_enc23_prison_mar_combat_started_2_22
(volume_test_players prison_after_reyes_saved_trigger))

(script static boolean ai_objective_enc23_prison_mar_boss_fight_2_23
(volume_test_players tv_lobby_exit))

(script static boolean ai_objective_enc23_prison_mar_begin_follow_player_2_24
(< (ai_living_count prison_out_boss) 1))

(script static boolean ai_objective_enc23_prison_mar_lobby_2_26
(volume_test_players prison_cell_d_hall_trigger))

(script static boolean ai_objective_enc23_prison_mar_support_player_2_27
(volume_test_players prison_to_prison_control_trigger))

(script static boolean ai_objective_enc23_prison_mar_to_corner_2_29
(<= (ai_living_count prison_culling_stealth) 0))

(script static boolean ai_objective_enc23_prison_mar_lobby_2_31
(volume_test_players prison_to_prison_control_trigger))

(script static boolean ai_objective_enc23_prison_mar_full_lobby_2_32
(volume_test_players tv_lobby_exit))

(script static boolean ai_objective_enc23_prison_mar_cell_block_2_33
(volume_test_players prison_cell_d_hall_trigger))

(script static boolean ai_objective_enc17_hangar_level2_cov_defend_path_to_l3_6_0
(volume_test_players hangar_exit_trigger))

(script static boolean ai_objective_enc25_control_revisited_mar_exit_7_1
(= (ai_living_count enc_control_revisited) 0))

(script static boolean ai_objective_enc25_control_revisited_mar_player_not_in_room_7_4
(not (volume_test_players control_music_trigger)))

(script static boolean ai_objective_enc_area3_cov_combat_started_8_1
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc_area3_cov_wraping_up_8_4
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc_area3_cov_getting_to_the_end_8_5
(or (volume_test_players area3_trigger_c) (player_in_vehicle area3_turret_a) (player_in_vehicle area3_turret_b)))

(script static boolean ai_objective_enc_area3_cov_follow_player_8_6
(< (ai_living_count area3_encounter) 5))

(script static boolean ai_objective_enc_area3_cov_combat_started_8_8
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc_area3_cov_stop_hiding_8_15
(and (= (f_area3_combat_started) true) (volume_test_players area3_trigger_a)))

(script static boolean ai_objective_enc_area3_cov_combat_started_8_22
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc_area3_cov_combat_started_8_26
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc_area3_cov_combat_started_8_31
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc_area3_cov_defensive_8_36
(< (+ (ai_living_count area3_grunts_c) (ai_living_count area3_grunts_ledge) (ai_living_count area3_grunts_ledge_b)) 3))

(script static boolean ai_objective_enc_area3_cov_entrance_grunts_8_37
(volume_test_players area3_trigger_a))

(script static boolean ai_objective_enc_area3_cov_push_forward_8_38
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc_area3_cov_sleeping_8_40
(= (f_area3_combat_started) false))

(script static boolean ai_objective_enc_area3_cov_cover_ledge_8_42
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc_area3_cov_combat_started_8_47
(= (f_area3_combat_started) true))

(script static boolean ai_objective_enc16_hangar_left_hall_fall_back_to_p1_9_6
(< (ai_living_count grunts_a_lefthall) 1))

(script static boolean ai_objective_enc16_hangar_left_hall_move_to_corner_9_8
(< (ai_living_count grunts_w) 1))

(script static boolean ai_objective_enc16_hangar_left_hall_take_corner_9_12
(< (ai_living_count grunts_w) 1))

(script static boolean ai_objective_enc16_hangar_left_hall_fall_back_to_p2_9_14
(< (ai_living_count grunts_e_lefthall) 1))

(script static boolean ai_objective_enc16_hangar_left_hall_go_to_p1_9_16
(< (ai_living_count elites_a_lefthall) 1))

(script static boolean ai_objective_enc16_hangar_left_hall_fall_back_to_hangar_9_21
(< (ai_living_count stealth_g_lefthall) 1))

(script static boolean ai_objective_enc16_hangar_left_hall_support_p2_9_23
(< (ai_living_count grunts_e_lefthall) 1))

(script static boolean ai_objective_enc16_hangar_left_hall_go_to_p2_9_27
(< (ai_living_count stealth_e_lefthall) 1))

(script static boolean ai_objective_enc21_22_prison_cov_chase_player_11_2
(volume_test_players tv_spring_prison_trap))

(script static boolean ai_objective_enc21_22_prison_cov_attack_11_9
(or (>= (ai_combat_status elites_left) "clear_los") (>= (ai_combat_status elites_right) "clear_los") (volume_test_players tv_spring_prison_trap)))

(script static boolean ai_objective_enc21_22_prison_cov_combat_11_10
(or (< (ai_strength elites_left) 1) (< (ai_strength elites_right) 1) (volume_test_players tv_spring_prison_trap)))

(script static boolean ai_objective_enc21_22_prison_cov_bait_the_room_11_13
(volume_test_players prison_cell_d_hall_trigger))

(script static boolean ai_objective_enc21_22_prison_cov_hold_mid_11_14
(volume_test_players new_cap_rescued))

(script static boolean ai_objective_enc21_22_prison_cov_stop_intruder_11_18
(volume_test_players new_cap_rescued))

(script static boolean ai_objective_enc21_22_prison_cov_defend_block_c_11_20
(< (ai_living_count prison_in_lobby_cov) 3))

(script static boolean ai_objective_enc21_22_prison_cov_cell_b_11_22
(volume_test_players tv_cellblock_b))

(script static boolean ai_objective_enc21_22_prison_cov_cell_a_11_24
(volume_test_players tv_cellblock_a))

(script static boolean ai_objective_enc21_22_prison_cov_lobby_11_26
(volume_test_players prison_control_to_prison_hallway_trigger))

(script static boolean ai_objective_enc21_22_prison_cov_security_checkpoint_11_30
(volume_test_players prison_entrance_follow_player_trigger))

(script static boolean ai_objective_enc21_22_prison_cov_choke_hall_11_31
(volume_test_players prison_hallway_to_prison_entrance_trigger))

(script static boolean ai_objective_enc21_22_prison_cov_retreat_to_lobby_11_32
(< (ai_living_count prison_in_checkpoint_cov) 3))

(script static boolean ai_objective_enc21_22_prison_cov_fall_back_11_34
(or (< (ai_living_count jackals_c_prison) 1) (< (ai_living_count new_elite_guard) 1)))

(script static boolean ai_objective_enc21_22_prison_cov_pull_back_checkpoint_11_41
(< (ai_living_count grunts_a_prison) 2))

(script static boolean ai_objective_enc3_area3_mar_push_up_hill_12_0
(volume_test_players area3_trigger_c))

(script static boolean ai_objective_enc3_area3_mar_take_hill_12_1
(< (ai_living_count area3_squads_2) 1))

(script static boolean ai_objective_enc3_area3_mar_take_back_12_4
(volume_test_players area3_trigger_b))

(script static boolean ai_objective_enc3_area3_mar_flank_right_12_6
(volume_test_players tv_flank_right))

(script static boolean ai_objective_enc3_area3_mar_flank_left_12_10
(volume_test_players tv_flank_left))

(script static boolean objective_covenant_area2_side_normal_14_1
(or (<= (ai_living_fraction  area2_wave_1) 0.5) (volume_test_players area2_trigger_a)))

(script static boolean objective_covenant_area2_side_follow_player_land_02_14_5
(volume_test_players area2_follow_player_side))

(script static boolean ai_objective_enc25_control_revisited_cov_chase_17_2
(not (volume_test_players control_music_trigger)))

(script static boolean ai_objective_enc25_control_revisited_cov_pursue_relentless_coop_17_6
(> (game_coop_player_count) 2))

(script static boolean ai_objective_enc25_control_revisited_cov_patrol_17_12
(not (volume_test_players control_no_return_trigger)))

(script static boolean ai_objective_enc9_grav_mus_hall_retreat_18_2
(< (ai_living_count grav_mus_hall_encounter) 2))

(script static boolean ai_objective_enc9_grav_mus_hall_fall_back_18_3
(< (ai_living_count grav_mus_hall_encounter) 4))

(script static boolean ai_objective_enc9_grav_mus_hall_ambush_18_6
(or (< (ai_living_fraction grav_mus_hall_encounter) 1) (volume_test_players tv_grav_mus_hall_flank)))

(script static boolean ai_objective_enc9_grav_mus_hall_get_aggro_18_11
(volume_test_players tv_grav_mus_hall_flank))

(script static boolean ai_objective_enc10_12_muster_bay_cov_follow_player_21_1
(volume_test_players muster_floor_trigger))

(script static boolean ai_objective_enc10_12_muster_bay_cov_run_away_21_11
(< (ai_living_count ledge_elites_side) 1))

(script static boolean ai_objective_enc10_12_muster_bay_cov_pursue_21_24
(volume_test_players muster_floor_trigger))

(script static boolean ai_objective_enc10_12_muster_bay_cov_defensive_21_29
(not (volume_test_players muster_floor_trigger)))

(script static boolean ai_objective_enc10_12_muster_bay_cov_follow_player_21_35
(volume_test_players muster_floor_trigger))

(script static boolean ai_objective_enc14_15_hangar_cov_encounter_begins_23_0
(volume_test_players hangar_entrance))

(script static boolean ai_objective_enc14_15_hangar_cov_encounter_15_23_1
(> (ai_living_count sg_hangar_f_1_hunters) 0))

(script static boolean ai_objective_enc14_15_hangar_cov_l1_bonded_pair_23_3
(> (ai_living_count sg_hangar_f_1_hunters) 1))

(script static boolean ai_objective_enc14_15_hangar_cov_encounter_14_23_8
(f_hangar_combat_started))

(script static boolean ai_objective_enc14_15_hangar_cov_l1_wave_5_23_14
( = 5 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_cov_l1_wave_5_23_16
(> (ai_living_count enc_hangar_floor_1) 5))

(script static boolean ai_objective_enc14_15_hangar_cov_l1_wave_4_23_18
( = 4 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_cov_l1_wave_3_23_22
( = 3 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_cov_l1_wave_2_23_26
( = 2 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_cov_l1_wave_1_23_30
( = 1 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc20_control_cov_defend_24_27
(volume_test_players control_no_return_check))

(script static boolean ai_objective_enc8_grav_pad_mar_heading_to_muster_door_27_0
(script_finished "vo_gravroom_end"))

(script static boolean ai_objective_enc8_grav_pad_mar_hold_the_room_27_2
(or (< (ai_strength ai_fireteam_fill) 1) (< (ai_strength ai_fireteam_marines) 1)))

(script static boolean ai_objective_enc8_grav_pad_mar_wrap_up_27_3
(= b_gravity_pad_waves_done true))

(script static boolean ai_objective_enc8_grav_pad_mar_kill_hunters_or_jackals_27_4
(> (ai_living_count sg_grav_tank_door) 0))

(script static boolean ai_objective_enc8_grav_pad_mar_both_alive_27_5
(> (ai_living_count sg_grav_tank_door) 1))

(script static boolean ai_objective_enc8_grav_pad_mar_just_one_left_27_7
(= (ai_living_count sg_grav_tank_door) 1))

(script static boolean ai_objective_enc8_grav_pad_mar_hold_off_waves_27_10
(= b_gravity_wave true))

(script static boolean ai_objective_enc8_grav_pad_mar_front_27_11
(and (<= (ai_living_count sg_grav_left_front) 1) (<= (ai_living_count sg_grav_right_front) 1)))

(script static boolean ai_objective_enc8_grav_pad_mar_rear_27_12
(and (<= (ai_living_count sg_grav_left_rear) 1) (<= (ai_living_count sg_grav_right_rear) 1)))

(script static boolean ai_objective_enc8_grav_pad_mar_left_27_13
(and (<= (ai_living_count sg_grav_left_front) 1) (<= (ai_living_count sg_grav_left_rear) 1)))

(script static boolean ai_objective_enc8_grav_pad_mar_right_27_14
(and (<= (ai_living_count sg_grav_right_front) 1) (<= (ai_living_count sg_grav_right_rear) 1)))

(script static boolean ai_objective_enc8_grav_pad_mar_left_front_27_15
(<= (ai_living_count sg_grav_left_front) 1))

(script static boolean ai_objective_enc8_grav_pad_mar_left_rear_27_16
(<= (ai_living_count sg_grav_left_rear) 1))

(script static boolean ai_objective_enc8_grav_pad_mar_right_front_27_17
(<= (ai_living_count sg_grav_right_front) 1))

(script static boolean ai_objective_enc8_grav_pad_mar_right_rear_27_18
(<= (ai_living_count sg_grav_right_rear) 1))

(script static boolean ai_objective_enc20_22_control_mar_after_combat_30_0
(= (f_control_combat_started) true))

(script static boolean ai_objective_enc20_22_control_mar_room_secured_30_1
(< (ai_living_count control_encounter) 1))

(script static boolean ai_objective_enc20_22_control_mar_proceed_to_prison_30_2
(> (device_get_position control_door_d) 0.5))

(script static boolean ai_objective_enc20_22_control_mar_move_to_high_ground_30_5
(= (f_control_combat_started) true))

(script static boolean ai_objective_enc20_22_control_mar_take_platform_30_6
(or (not (volume_test_object control_music_trigger pad_elites_major)) (< (ai_living_count pad_elites_major) 1)))

(script static boolean ai_objective_enc20_22_control_mar_marines_move_to_observation_30_7
(= b_to_control_observation true))

(script static boolean ai_objective_enc20_22_control_mar_assault_the_room_30_8
(= (f_control_combat_started) true))

(script static boolean ai_objective_enc20_22_control_mar_push_up_30_9
(< (ai_living_count grunts_m) 1))

(script static boolean ai_objective_enc20_22_control_mar_take_right_ramp_30_10
(< (ai_strength control_elites_right) 0.75))

(script static boolean ai_objective_enc20_22_control_mar_take_right_30_11
(< (ai_strength control_elites_right) 0.75))

(script static boolean ai_objective_enc20_22_control_mar_marines_stay_at_main_door_30_13
(= b_to_control_main true))

(script static boolean ai_objective_enc20_22_control_mar_assault_the_room_30_14
(= (f_control_combat_started) true))

(script static boolean ai_objective_enc20_22_control_mar_push_up_30_15
(< (ai_living_count grunts_k) 1))

(script static boolean ai_objective_enc20_22_control_mar_take_left_ramp_30_16
(< (ai_strength control_elites_left) 0.75))

(script static boolean ai_objective_enc20_22_control_mar_take_left_30_17
(< (ai_strength control_elites_left) 0.75))

(script static boolean ai_objective_enc14_15_hangar_mar_encounter_starts_32_0
(volume_test_players hangar_entrance))

(script static boolean ai_objective_enc14_15_hangar_mar_encounter_18_32_1
(volume_test_players hangar_second_right_hall))

(script static boolean ai_objective_enc14_15_hangar_mar_encounter_17_32_3
(volume_test_players hangar_left_hall_pillars))

(script static boolean ai_objective_enc14_15_hangar_mar_now_on_second_floor_32_4
(volume_test_players hangar_second_reins_trigger))

(script static boolean ai_objective_enc14_15_hangar_mar_encounter_16_32_6
(and (> (ai_living_count sg_hangar_f_1_hunters) 0) (= b_hangar_floor_1_waves_complete true)))

(script static boolean ai_objective_enc14_15_hangar_mar_wait_for_player_to_enter_32_7
(and (< (ai_living_count sg_hangar_f_1_hunters) 1) (volume_test_players hangar_first_trigger_a)))

(script static boolean ai_objective_enc14_15_hangar_mar_push_to_first_corner_32_9
(> (ai_strength grunts_w) 0.5))

(script static boolean ai_objective_enc14_15_hangar_mar_take_corner_32_10
(< (ai_living_count grunts_w) 1))

(script static boolean ai_objective_enc14_15_hangar_mar_approach_p1_32_11
(or (< (ai_living_count elites_a_lefthall) 1) (< (ai_living_count grunts_a_lefthall) 1)))

(script static boolean ai_objective_enc14_15_hangar_mar_take_pillar_1_32_12
(< (ai_living_count hangar_f_2_hall_corner) 1))

(script static boolean ai_objective_enc14_15_hangar_mar_take_pillar_2_32_13
(< (ai_living_count grunts_e_lefthall) 1))

(script static boolean ai_objective_enc14_15_hangar_mar_take_pillar_3_32_14
(and (< (ai_living_count stealth_g_lefthall) 1) (< (ai_living_count stealth_e_lefthall) 1)))

(script static boolean ai_objective_enc14_15_hangar_mar_move_to_floor_2_32_15
(volume_test_players hangar_second_trigger_a))

(script static boolean ai_objective_enc14_15_hangar_mar_encounter_15_32_16
(> (ai_living_count sg_hangar_f_1_hunters) 0))

(script static boolean ai_objective_enc14_15_hangar_mar_final_encounter_32_17
(> (ai_living_count sg_hangar_f_1_hunters) 0))

(script static boolean ai_objective_enc14_15_hangar_mar_follow_front_32_18
(volume_test_players hangar_area))

(script static boolean ai_objective_enc14_15_hangar_mar_encounter_14_32_23
(f_hangar_combat_started))

(script static boolean ai_objective_enc14_15_hangar_mar_wave_f_32_26
(= 5 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_mar_w_f_aggro_32_28
(< (ai_living_count enc_hangar_floor_1) 6))

(script static boolean ai_objective_enc14_15_hangar_mar_wave_e_32_30
(= 4 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_mar_w_e_aggro_32_32
(< (ai_living_count enc_hangar_floor_1) 6))

(script static boolean ai_objective_enc14_15_hangar_mar_wave_d_32_34
(= 3 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_mar_w_d_aggro_32_36
(< (ai_living_count enc_hangar_floor_1) 6))

(script static boolean ai_objective_enc14_15_hangar_mar_wave_b_32_38
(= 2 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_mar_w_b_aggro_32_40
(< (ai_living_count enc_hangar_floor_1) 6))

(script static boolean ai_objective_enc14_15_hangar_mar_wave_a_32_42
(= 1 s_hangar_floor_1_current_wave))

(script static boolean ai_objective_enc14_15_hangar_mar_w_a_aggro_32_44
(< (ai_living_count enc_hangar_floor_1) 6))

(script static boolean ai_objective_enc5_7_area5_mar_combat_33_0
(>= (ai_combat_status area5_encounter) certain))

(script static boolean ai_objective_enc5_7_area5_mar_fight_hunters_33_1
(> (ai_living_count area5_hunters) 0))

(script static boolean ai_objective_enc5_7_area5_mar_warp_up_33_2
(< (ai_living_count area5_hunters) 1))

(script static boolean ai_objective_enc5_7_area5_mar_support_player_33_6
(= (f_turrets_are_empty) true))

(script static boolean ai_objective_enc19_hangar_level3_cov_player_at_d_34_1
(volume_test_players hangar_third_trigger_d))

(script static boolean ai_objective_enc19_hangar_level3_cov_player_at_c_34_2
(volume_test_players hangar_third_trigger_c))

(script static boolean ai_objective_enc19_hangar_level3_cov_player_at_b_34_3
(volume_test_players hangar_third_trigger_b))

(script static boolean ai_objective_enc_area5_cov_boss_fight_37_1
(> (ai_living_count area5_hunters) 0))

(script static boolean ai_objective_enc_area5_cov_combat_37_5
(or (>= (ai_combat_status area5_encounter) certain) (volume_test_players area5_dropship_trigger)))

(script static boolean ai_objective_enc_area5_cov_grav_waves_37_10
(> (ai_living_count area5_wave) 0))

(script static boolean ai_objective_enc_area5_cov_follow_player_37_11
(>= (ai_combat_status area5_encounter) certain))

(script static boolean ai_objective_enc_area5_cov_combat_37_25
(>= (ai_combat_status area5_encounter) certain))

(script static boolean ai_objective_enc1_2_area2_mar_wrapping_up_40_0
(> (ai_living_count area2_back_squads) 0))

(script static boolean ai_objective_enc1_2_area2_mar_end_combat_40_1
(< (ai_living_count area2_encounter) 1))

(script static boolean ai_objective_enc1_2_area2_mar_encounter_1_40_2
(= (f_area2_combat_started) true))

(script static boolean ai_objective_enc1_2_area2_mar_clear_the_area_40_3
(volume_test_players area2_trigger_b))

(script static boolean ai_objective_enc1_2_area2_mar_defend_area_40_4
(< (+ (ai_living_count area2_wave_1) (ai_living_count area2_wave_2)) 5))

(script static boolean ai_objective_enc1_2_area2_mar_charge_40_6
(volume_test_players area2_trigger_a))

(script static boolean ai_objective_enc1_2_area2_mar_flank_player_40_15
(volume_test_players canyon_nav_reached1))

(script static boolean ai_objective_enc1_2_area2_mar_move_to_hold_40_18
(volume_test_players area2_trigger))

(script static boolean ai_objective_enc_area4_cov_wrap_up_encounter_42_0
(volume_test_players area4_reins_trigger))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_1
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_7
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_alert_42_12
(>= (ai_combat_status area4_encounter) active))

(script static boolean ai_objective_enc_area4_cov_hold_the_choke_point_42_14
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_move_to_pit_42_15
(< (ai_living_count area4_encounter) 6))

(script static boolean ai_objective_enc_area4_cov_move_to_hold_42_16
(< (ai_living_count area4_encounter) 3))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_19
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_22
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_25
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_28
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_31
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_35
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_alert_42_39
(> (ai_combat_status area4_encounter) active))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_43
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_sniper_42_48
(> (ai_combat_status area4_encounter) active))

(script static boolean ai_objective_enc_area4_cov_alert_42_49
(> (ai_combat_status area4_encounter) active))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_52
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_retreat_to_turret_e_42_53
(<= (ai_living_fraction area4_jackals_d) 0.5))

(script static boolean ai_objective_enc_area4_cov_alert_42_59
(> (ai_combat_status area4_encounter) active))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_62
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_alert_42_66
(> (ai_combat_status area4_encounter) active))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_70
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_alert_42_74
(> (ai_combat_status area4_encounter) active))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_77
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_alert_42_81
(> (ai_combat_status area4_encounter) active))

(script static boolean ai_objective_enc_area4_cov_combat_started_42_84
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc_area4_cov_player_right_42_90
(= (f_area4_get_player_side) 1))

(script static boolean ai_objective_enc_area4_cov_player_left_42_91
(= (f_area4_get_player_side) 2))

(script static boolean ai_objective_enc13_muster_hangar_hall_player_has_arrived_43_13
(not (volume_test_players muster_hangar_hall_trigger)))

(script static boolean ai_objective_enc_area2_back_gaurd_44_1
(volume_test_players area2_trigger_c))

(script static boolean ai_objective_enc_area2_clean_up_44_2
(< (ai_living_count area2_encounter) 5))

(script static boolean ai_objective_enc_area2_combat_begins_44_5
(= (f_area2_combat_started) true))

(script static boolean ai_objective_enc_area2_combat_ends_44_6
(> (ai_living_count area2_wave_2) 0))

(script static boolean ai_objective_enc_area2_follow_player_44_7
(< (+ (ai_living_count area2_wave_2) (ai_living_count area2_wave_1)) 5))

(script static boolean ai_objective_enc_area2_roam_44_14
(< (ai_combat_status area2_wave_1) uninspected))

(script static boolean ai_objective_enc_area2_gunning_44_21
(= (f_area2_combat_started) true))

(script static boolean ai_objective_enc4_area4_mar_wrap_up_47_0
(> (ai_living_count area4_reinforcements) 0))

(script static boolean ai_objective_enc4_area4_mar_clean_up_remainders_47_1
(< (ai_living_count area4_encounter) 5))

(script static boolean ai_objective_enc4_area4_mar_combat_over_47_2
(< (ai_living_count area4_encounter) 1))

(script static boolean ai_objective_enc4_area4_mar_combat_started_47_3
(= (f_area4_combat_started) true))

(script static boolean ai_objective_enc4_area4_mar_go_right_47_5
(= area4_player_went_right true))

(script static boolean ai_objective_enc4_area4_mar_b_take_the_bridge_47_7
(and (< (ai_living_count area4_grunts_b) 2) (< (ai_living_count area4_jackals_g) 1)))

(script static boolean ai_objective_enc4_area4_mar_c_clear_turret_d_47_8
(and (< (ai_living_count area4_grunts_s) 1) (< (ai_living_count area4_jackals_u) 2)))

(script static boolean ai_objective_enc4_area4_mar_d_take_trees_47_9
(and (< (ai_living_count area4_elites_q) 2) (< (ai_living_count area4_grunts_q) 2)))

(script static boolean ai_objective_enc4_area4_mar_go_to_pit_47_10
(and (< (ai_living_count area4_elites_q) 1) (< (ai_living_count area4_grunts_q) 1)))

(script static boolean ai_objective_enc4_area4_mar_go_left_47_11
(= area4_player_went_left true))

(script static boolean ai_objective_enc4_area4_mar_b_clear_ledge_corner_47_13
(and (< (ai_living_count area4_jackals_c) 2) (< (ai_living_count area4_jackals_d) 2)))

(script static boolean ai_objective_enc4_area4_mar_c_clear_turret_e_47_14
(and (< (ai_living_count area4_jackals_c) 1) (< (ai_living_count area4_jackals_d) 1)))

(script static boolean ai_objective_enc4_area4_mar_d_clear_turret_b_47_15
(and (< (ai_strength area4_elites_q) 0.7) (< (ai_living_count area4_grunts_q) 2)))

(script static boolean ai_objective_enc4_area4_mar_e_take_pit_entrance_47_16
(and (< (ai_living_count area4_elites_q) 1) (< (ai_living_count area4_grunts_q) 1)))

(script static boolean ai_objective_enc4_area4_mar_go_to_pit_47_17
(> (ai_living_count area4_squad_dropship) 0))

(script static boolean ai_objective_enc4_area4_mar_split_from_player_47_18
(or (volume_test_players area4_marines_ledge_trigger) (volume_test_players area4_marines_middle_trigger)))

(script static boolean ai_objective_enc4_area4_mar_go_right_47_19
(= area4_player_went_left true))

(script static boolean ai_objective_enc4_area4_mar_b_take_the_bridge_47_21
(and (< (ai_living_count area4_grunts_b) 2) (< (ai_living_count area4_jackals_g) 1)))

(script static boolean ai_objective_enc4_area4_mar_c_clear_turret_d_47_22
(and (< (ai_living_count area4_grunts_s) 1) (< (ai_living_count area4_jackals_u) 2)))

(script static boolean ai_objective_enc4_area4_mar_d_take_trees_47_23
(and (< (ai_living_count area4_elites_q) 2) (< (ai_living_count area4_grunts_q) 2)))

(script static boolean ai_objective_enc4_area4_mar_go_to_pit_47_24
(and (< (ai_living_count area4_elites_q) 1) (< (ai_living_count area4_grunts_q) 1)))

(script static boolean ai_objective_enc4_area4_mar_go_left_47_25
(= area4_player_went_right true))

(script static boolean ai_objective_enc4_area4_mar_b_clear_ledge_corner_47_27
(and (< (ai_living_count area4_jackals_c) 2) (< (ai_living_count area4_jackals_d) 2)))

(script static boolean ai_objective_enc4_area4_mar_c_clear_turret_e_47_28
(and (< (ai_living_count area4_jackals_c) 1) (< (ai_living_count area4_jackals_d) 1)))

(script static boolean ai_objective_enc4_area4_mar_d_clear_turret_b_47_29
(< (ai_strength area4_elites_q) 0.7))

(script static boolean ai_objective_enc4_area4_mar_e_take_pit_entrance_47_30
(or (< (ai_living_count area4_elites_q) 1) (< (ai_living_count area4_grunts_q) 1)))

(script static boolean ai_objective_enc4_area4_mar_go_to_pit_47_31
(> (ai_living_count area4_squad_dropship) 0))

(script static boolean ai_objective_enc4_area4_mar_wait_for_player_fork_47_33
(volume_test_players area4_trigger_a))

(script static boolean ai_objective_enc4_area4_mar_d_hold_the_fork_47_34
(< (ai_living_count ai_player_fireteam) 3))

(script static boolean aiobjective_hangar_first_l_follow_player_hallway_48_2
(= (device_get_position hangar_exit) 1))

(script static boolean ai_objective_enc23_prison_cov_follow_52_1
(volume_test_players prison_hallway_to_prison_entrance_trigger))

(script static boolean ai_objective_enc23_prison_cov_fight_52_10
(= b_prison_break_started true))

(script static boolean ai_objective_enc23_prison_cov_prison_break_in_progress_52_12
(= b_prison_break_started true))

(script static boolean ai_objective_enc23_prison_cov_pull_to_door_52_13
(volume_test_players tv_lobby_exit))

(script static boolean ai_objective_enc23_prison_cov_follow_to_b_52_15
(volume_test_players tv_cellblock_b))

(script static boolean ai_objective_enc23_prison_cov_hold_barricade_52_17
(or (volume_test_object tv_crate_barricade crate_prison2)(volume_test_object tv_crate_barricade crate_prison5)(volume_test_object tv_crate_barricade crate_prison7)))

(script static boolean ai_objective_enc23_prison_cov_pull_back_52_20
(volume_test_players prison_to_prison_control_trigger))

(script static boolean ai_objective_enc23_prison_cov_stop_exit_52_22
(volume_test_players tv_lobby_exit))

(script static boolean ai_objective_enc23_prison_cov_follow_to_b_52_24
(volume_test_players tv_cellblock_b))

(script static boolean ai_objective_enc23_prison_cov_pull_back_52_25
(volume_test_players prison_to_prison_control_trigger))

(script static boolean ai_objective_enc23_prison_cov_grunt_works_52_27
(not (volume_test_players prison_after_reyes_saved_trigger)))

(script static boolean ai_objective_enc23_prison_cov_kill_52_32
(= b_prison_break_started true))

(script static boolean ai_objective_enc_grav_pad_cov_moving_out_of_grav_54_1
b_gravity_pad_waves_done)

(script static boolean ai_objective_enc_grav_pad_cov_hunt_player_54_7
(< (ai_living_count ai_fireteam_fill) 1))

(script static boolean ai_objective_enc_grav_pad_cov_rage_54_20
(< (ai_living_count sg_grav_tank_door) 2))

(script static boolean ai_objective_enc_grav_pad_cov_follow_marines_54_29
(> (ai_living_count fireteam_gravity_room_marines) 0))

(script static boolean ai_objective_enc_grav_pad_cov_follow_fill_54_30
(> (ai_living_count fireteam_gravity_room_fill) 0))

(script static boolean ai_objective_enc_grav_pad_cov_player_not_in_volume_54_32
(not (volume_test_players gravity_trigger)))

(script static boolean ai_objective_enc_grav_pad_cov_rage_54_33
(< (ai_living_count sg_grav_tank_door) 2))

