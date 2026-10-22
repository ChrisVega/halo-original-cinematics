(script static boolean obj_johnson_rr_schenanigans_sniper_post_2_0_0
(volume_test_players tv_johnson_rr_2nd_sniper_post))

(script static boolean obj_johnson_rr_schenanigans_sniper_post_1_0_1
(volume_test_players tv_sophie_says_hi))

(script static boolean obj_geneforge_ll_elite_wave_3_b_pursuit_4_3
(< (ai_living_count gr_geneforge_ll_wv3_master) 4))

(script static boolean obj_geneforge_ll_upper_gate_wave2_4_6
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv2_otr true)))

(script static boolean obj_geneforge_ll_elite_wave_2_otr_lower_4_8
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv2_otr true)))

(script static boolean obj_geneforge_ll_upper_gate_wave1_4_10
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv1_otr true)))

(script static boolean obj_geneforge_ll_elite_wave_1_otr_lower_4_12
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv1_otr true)))

(script static boolean obj_geneforge_ll_brute_wave_3_pursuit_4_16
(< (ai_living_count gr_geneforge_ll_wv3_master) 4))

(script static boolean obj_geneforge_ll_upper_gate_3a_4_17
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv3a_otr true)))

(script static boolean obj_geneforge_ll_brute_wave_3a_otr_lower_4_19
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv3a_otr true)))

(script static boolean obj_geneforge_ll_upper_gate_wave_2_4_22
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv2_otr true)))

(script static boolean obj_geneforge_ll_brute_wave_2_otr_lower_4_24
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv2_otr true)))

(script static boolean obj_geneforge_ll_grunt_wave_3_pursuit_4_28
(< (ai_living_count gr_geneforge_ll_wv3_master) 4))

(script static boolean obj_geneforge_ll_upper_gate_wave2_4_30
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv2_otr true)))

(script static boolean obj_geneforge_ll_grunt_wave_2_otr_lower_4_32
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv2_otr true)))

(script static boolean obj_geneforge_ll_upper_gate_wave1_4_34
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv1_otr true)))

(script static boolean obj_geneforge_ll_grunt_wave_1_otr_lower_4_36
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv1_otr true)))

(script static boolean obj_geneforge_ll_jackal_wave_3_pursuit_4_39
(< (ai_living_count gr_geneforge_ll_wv3_master) 4))

(script static boolean obj_geneforge_ll_upper_gate_wave1_4_42
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv1_otr true)))

(script static boolean obj_geneforge_ll_jackal_wave_1_otr_lower_4_44
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv1_otr true)))

(script static boolean obj_rest_respite_wave_3_pursuit_6_0
(< (ai_living_count gr_rest_respite_wave3) 4))

(script static boolean obj_last_battle_waves_pursuit_7_0
(<= (ai_living_count gr_final_encounter_master) 3))

(script static boolean obj_last_battle_waves_grunts_front_of_lab_7_18
(volume_test_players tv_ai_trigger_front_lab))

(script static boolean obj_last_battle_waves_grunts_middle_of_lab_7_19
(volume_test_players tv_ai_trigger_mid_lab))

(script static boolean obj_last_battle_waves_grunts_back_of_lab_7_20
(volume_test_players tv_ai_trigger_back_lab))

(script static boolean obj_last_battle_waves_grunts_upper_back_left_7_21
(volume_test_players tv_ai_trigger_top_bl))

(script static boolean obj_last_battle_waves_grunts_upper_back_right_7_22
(volume_test_players tv_ai_trigger_top_br))

(script static boolean obj_last_battle_waves_grunts_upper_front_left_7_23
(volume_test_players tv_ai_trigger_top_fl))

(script static boolean obj_last_battle_waves_grunts_upper_front_right_7_24
(volume_test_players tv_ai_trigger_top_fr))

(script static boolean obj_last_battle_waves_jackals_front_of_lab_7_28
(volume_test_players tv_ai_trigger_front_lab))

(script static boolean obj_last_battle_waves_jackals_middle_of_lab_7_29
(volume_test_players tv_ai_trigger_mid_lab))

(script static boolean obj_last_battle_waves_jackals_back_of_lab_7_30
(volume_test_players tv_ai_trigger_back_lab))

(script static boolean obj_last_battle_waves_jackals_upper_back_left_7_31
(volume_test_players tv_ai_trigger_top_bl))

(script static boolean obj_last_battle_waves_jackals_upper_back_right_7_32
(volume_test_players tv_ai_trigger_top_br))

(script static boolean obj_last_battle_waves_jackals_upper_front_left_7_33
(volume_test_players tv_ai_trigger_top_fl))

(script static boolean obj_last_battle_waves_jackals_upper_front_right_7_34
(volume_test_players tv_ai_trigger_top_fr))

(script static boolean obj_grav_lift_room_enc_20_combat_wav1_8_0
(= (ai_living_count gr_grav_lift_room_wv1) 1))

(script static boolean obj_grav_lift_room_enc_20_fallback_8_2
(< (ai_living_count gr_grav_lift_room_wv1) 2))

(script static boolean obj_grav_lift_room_enc_20_combat_wav2_8_7
(= (ai_living_count gr_grav_lift_room_wv2) 1))

(script static boolean obj_grav_lift_room_enc_20_fallback_8_9
(< (ai_living_count gr_grav_lift_room_wv2) 2))

(script static boolean obj_grav_lift_room_enc_20_fallback_8_12
(< (ai_living_count gr_grav_lift_room_wv2) 2))

(script static boolean obj_grav_lift_room_enc_20_combat_wav3_8_17
(= (ai_living_count gr_grav_lift_room_wv3) 1))

(script static boolean obj_grav_lift_room_enc_20_fallback_8_21
(< (ai_living_count gr_grav_lift_room_wv3) 2))

(script static boolean obj_coor_to_glr_combat_12_0
(> (ai_combat_status gr_coor_to_glr) alert))

(script static boolean obj_9_clock_fall_back_13_0
(< (ai_living_count gr_dock_9_clock) 4))

(script static boolean obj_last_battle_initial_pursuit_14_0
(= (ai_living_count gr_final_encounter_start) 3))

(script static boolean obj_last_battle_initial_central_elites_14_5
(= s_johnson_final_encounter 1))

(script static boolean obj_last_battle_initial_rifle_elites_combat_14_7
(= s_johnson_final_encounter 1))

(script static boolean obj_last_battle_initial_floor_grunts_14_12
(= s_johnson_final_encounter 1))

(script static boolean obj_last_battle_initial_gunner_grunta_14_13
(= s_johnson_final_encounter 1))

(script static boolean obj_last_battle_initial_gunner_gruntb_14_14
(= s_johnson_final_encounter 1))

(script static boolean obj_last_battle_initial_grunts_pre_combat_14_15
(= s_johnson_final_encounter 0))

(script static boolean obj_airborne_hanger_spirit_troops_fallback_19_1
(< (ai_living_count gr_airborne) 4))

(script static boolean obj_johnson_geneforge_ll_wave_4_20_0
(= s_johnson_zone_genforge_ll 4))

(script static boolean obj_johnson_geneforge_ll_wave_3b_20_1
(= s_johnson_zone_genforge_ll 3))

(script static boolean obj_johnson_geneforge_ll_upper_gate_wave_3_20_2
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv3a_otr true)))

(script static boolean obj_johnson_geneforge_ll_wave_3_otr_lower_20_4
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv3a_otr true)))

(script static boolean obj_johnson_geneforge_ll_wave_3_20_5
(= s_johnson_zone_genforge_ll 2))

(script static boolean obj_johnson_geneforge_ll_upper_gate_wave2_20_6
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv2_otr true)))

(script static boolean obj_johnson_geneforge_ll_wave_2_otr_lower_20_8
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv2_otr true)))

(script static boolean obj_johnson_geneforge_ll_wave_2_20_9
(= s_johnson_zone_genforge_ll 1))

(script static boolean obj_johnson_geneforge_ll_upper_gate_wave1_20_10
(and (volume_test_players_all tv_chiefcheck_geneforge_upper) (= b_geneforge_ll_wv1_otr true)))

(script static boolean obj_johnson_geneforge_ll_wave_1_otr_lower_20_12
(and (volume_test_players_all tv_chiefcheck_geneforge_lower) (= b_geneforge_ll_wv1_otr true)))

(script static boolean obj_johnson_geneforge_ll_wave_1_20_13
(= s_johnson_zone_genforge_ll 0))

(script static boolean obj_johnson_final_encounter_johnson_wave_3_21_0
(= s_johnson_final_encounter 4))

(script static boolean obj_johnson_final_encounter_johnson_wave_2_21_1
(= s_johnson_final_encounter 3))

(script static boolean obj_johnson_final_encounter_johnson_wave_1_21_2
(= s_johnson_final_encounter 2))

(script static boolean obj_johnson_final_encounter_johnson_pre_wave_21_3
(= s_johnson_final_encounter 1))

(script static boolean obj_testing_facility_revisit_wv2_retreat_22_0
(< (ai_living_count gr_testing_facility_wv2_cov) 4))

(script static boolean obj_dojo_elites_spec_ops_combat_23_4
(= b_dojo_specops_can_kill 1))

(script static boolean obj_dojo_coop_2_3_specops_combat_23_6
(= b_dojo_specops_can_kill 1))

(script static boolean obj_dojo_coop_4_zealots_combat_23_8
(= b_dojo_specops_can_kill 1))

(script static boolean obj_johnson_testing_facility_top_left_24_0
(volume_test_players tv_johnson_sf_top_left))

(script static boolean obj_johnson_testing_facility_top_right_24_1
(volume_test_players tv_johnson_sf_top_right))

(script static boolean obj_johnson_testing_facility_bottom_left_24_2
(volume_test_players tv_johnson_sf_bottom_left))

(script static boolean obj_johnson_testing_facility_bottom_right_24_3
(volume_test_players tv_johnson_sf_bottom_right))

(script static boolean obj_storage_enc12_retreat_25_5
(< (ai_living_count sq_geneforge_start_grunt) 3))

(script static boolean obj_rest_respite_attack_main_floor_28_1
(= (ai_combat_status gr_rest_respite_initial) dangerous))

(script static boolean obj_rest_respite_combat_28_10
(= (ai_combat_status gr_rest_respite_initial) dangerous))

(script static boolean obj_johnson_dojo_sniper_post_johnson_at_gravbridge_33_0
(= b_johnson_can_trigger_gb 1))

(script static boolean obj_johnson_dojo_sniper_post_johnson_in_kill_mode_33_1
(= b_combat_in_dojo_is_go 1))

(script static boolean obj_johnson_hanger_schenanigans_hunter_fight_mid_35_0
(= (ai_living_count sq_dockingbay_lift_hunter) 1))

(script static boolean obj_johnson_hanger_schenanigans_hunter_fight_35_1
(volume_test_object tv_johnson_hunter_town ai_johnson))

(script static boolean obj_johnson_hanger_schenanigans_sniper_post_3_35_2
(= s_johnson_hanger_point_checker 5))

(script static boolean obj_johnson_hanger_schenanigans_sniper_post_4_35_3
(= s_johnson_hanger_point_checker 4))

(script static boolean obj_johnson_hanger_schenanigans_sniper_post_3_35_4
(= s_johnson_hanger_point_checker 3))

(script static boolean obj_johnson_hanger_schenanigans_sniper_post_2_35_5
(= s_johnson_hanger_point_checker 2))

(script static boolean obj_johnson_hanger_schenanigans_sniper_post_1_35_6
(= s_johnson_hanger_point_checker 1))

(script static boolean obj_dockingbay_initial_fall_back_39_3
(< (ai_living_count gr_dock_intro_b) 3))

(script static boolean obj_testing_facility_revisit_wv1_jackal_fallback_42_4
(= (ai_living_count sq_testing_facility_wv1_jackals) 1))

(script static boolean obj_testing_facility_revisit_wv1_grunt_fallback_42_7
(< (ai_living_count sq_testing_facility_wv1_grunts) 3))

