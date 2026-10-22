(script static boolean obj_hydro_entry_redux_unsc_e20_defeated_0_0
(= (ai_living_count gr_beat2_e20_hydro_entry_redux) 0))

(script static boolean obj_transit_e32_cov_tram_jump_1_3
(= b_e32_jump_ready 1))

(script static boolean obj_johnson_bridge_redux_encounter_over_2_0
(= (ai_living_count gr_beat2_e15_hydro_bridge_redux) 0))

(script static boolean obj_johnson_bridge_redux_johnson_a_2_2
(volume_test_players tv_hydro_bridge_a))

(script static boolean obj_johnson_bridge_redux_johnson_b_2_3
(volume_test_players tv_hydro_bridge_b))

(script static boolean obj_johnson_bridge_redux_johnson_c_2_4
(volume_test_players tv_hydro_bridge_c))

(script static boolean obj_johnson_bridge_redux_johnson_d_2_5
(or (volume_test_players tv_hydro_bridge_d) (= (ai_living_count gr_beat2_e14_gravlift_redux) 0)))

(script static boolean obj_johnson_rr_down_lift_3_0
(volume_test_players tv_ponr_transit_grav_shaft))

(script static boolean obj_johnson_rr_by_lift_3_1
(volume_test_players tv_rr_to_grav))

(script static boolean obj_johnson_rr_by_exit_3_2
(= (ai_living_count gr_beat2_e22_rest_respite) 0))

(script static boolean obj_johnson_rr_head_down_3_3
(volume_test_players tv_johnson_rr_from_top))

(script static boolean obj_overview_unsc_e2_4_1
(>= obj_con_overview 20))

(script static boolean obj_overview_unsc_e2_defeated_4_2
(and (>= obj_con_overview 20) (<= (ai_task_count obj_overview_cov/overview_cor) 0)))

(script static boolean obj_overview_unsc_e1_4_4
(>= obj_con_overview 10))

(script static boolean obj_overview_unsc_e1_defeated_4_5
(and (>= obj_con_overview 10) (<= (ai_task_count obj_overview_cov/overview_entry) 0)))

(script static boolean obj_overview_unsc_gate_stealthy_4_6
(<= (ai_combat_status gr_beat1_e1_overview) idle))

(script static boolean obj_overview_unsc_wait_at_door_4_10
(= obj_con_overview 0))

(script static boolean obj_transit_e33_e34_e35_cov_e34_b_fallback_6_3
(volume_test_players tv_transit_hangar_fallback))

(script static boolean obj_control_player_front_7_4
(and (= b_e13_ready_for_push 1) (<= (ai_living_count gr_beat1_e13_control_bridge) 3)))

(script static boolean obj_control_remaing_troops_7_5
(= b_e13_ready_for_push 1))

(script static boolean obj_vista_vign_spotted_player_8_1
(= b_vista_vignette_jackal_seen 1))

(script static boolean obj_vista_vign_player_at_window_8_4
(= b_vista_vignette_elite_seen 1))

(script static boolean obj_vista_vign_alert_8_10
(= b_vista_vignette_started 1))

(script static boolean obj_hydro_entry_unsc_go_to_next_area_9_0
(volume_test_players tv_hydro_entry_john_follow))

(script static boolean obj_hydro_entry_unsc_e8_defeated_9_1
(<= (ai_task_count obj_hydro_entry_cov/encounter_8) 0))

(script static boolean obj_space1_cov_gate_e2_10_1
(>= s_current_space_encounter 2))

(script static boolean obj_space1_cov_e2_follow_10_2
(= (game_coop_player_count) 1))

(script static boolean obj_space1_cov_e2_relay1_10_3
(= b_relay_1_destroyed 0))

(script static boolean obj_space1_cov_e2_relay2_10_4
(= b_relay_2_destroyed 0))

(script static boolean obj_space1_cov_e2_relay3_10_5
(= b_relay_3_destroyed 0))

(script static boolean obj_space1_cov_e2_relay4_10_6
(= b_relay_4_destroyed 0))

(script static boolean obj_space1_cov_e2_relay5_relay6_10_7
(and (= b_relay_5_destroyed 0) (= b_relay_6_destroyed 0)))

(script static boolean obj_space1_cov_gate_e1_10_8
(<= s_current_space_encounter 1))

(script static boolean obj_space1_cov_e1_remaining_follow_10_9
(= (game_coop_player_count) 1))

(script static boolean obj_space1_cov_e1_init_follow_10_10
(= (game_coop_player_count) 1))

(script static boolean obj_space1_cov_gate_e2_10_13
(>= s_current_space_encounter 2))

(script static boolean obj_space1_cov_e2_relay1_10_14
(= b_relay_1_destroyed 0))

(script static boolean obj_space1_cov_e2_relay2_10_15
(= b_relay_2_destroyed 0))

(script static boolean obj_space1_cov_e2_relay3_10_16
(= b_relay_3_destroyed 0))

(script static boolean obj_space1_cov_e2_relay4_10_17
(= b_relay_4_destroyed 0))

(script static boolean obj_space1_cov_e2_relay5_relay6_10_18
(and (= b_relay_5_destroyed 0) (= b_relay_6_destroyed 0)))

(script static boolean obj_overview_vista_unsc_e3_11_1
(>= obj_con_overview 30))

(script static boolean obj_overview_vista_unsc_wait_for_player_11_2
(>= obj_con_overview 35))

(script static boolean obj_overview_vista_unsc_e3_defeated_11_3
(and (>= obj_con_overview 30) (<= (ai_task_count obj_overview_vista_cov/kung_fu) 0)))

(script static boolean obj_overview_vista_unsc_gate_stealthy_11_4
(<=  (ai_combat_status gr_beat1_e3_overview_vista) idle))

(script static boolean obj_transit_e31_cov_tram_jump_12_3
(= b_e31_jump_ready 1))

(script static boolean obj_space3_unsc_dog_fight_15_0
(>= (device_get_position dm_bop) r_burden_pos_5))

(script static boolean obj_space3_unsc_kamikaze_wave_1_15_1
(>= (device_get_position dm_bop) 0))

(script static boolean obj_johnson_control_after_cine_17_0
(= b_bridge_cinematic_played 1))

(script static boolean obj_johnson_control_down_lift_17_1
(= (volume_test_players tv_ponr_gravlift_b_shaft) 1))

(script static boolean obj_johnson_control_lead_to_lift_17_2
(= (volume_test_players tv_act_control) 1))

(script static boolean obj_johnson_control_control_battle_17_4
(= b_e13_started 1))

(script static boolean obj_johnson_control_player_front_17_5
(= b_e13_ready_for_push 1))

(script static boolean obj_johnson_control_lead_to_control_17_7
(<= (ai_living_count gr_beat1_e12_control_grav_up) 0))

(script static boolean obj_transit_unsc_dome_station_18_0
(>= obj_con_transit 50))

(script static boolean obj_transit_unsc_tram_18_1
(= b_dome_defend_complete 1))

(script static boolean obj_transit_unsc_follow_player_18_2
(= b_dome_powering_started 1))

(script static boolean obj_transit_unsc_head_to_top_18_3
(>= (device_get_position dm_transit) r_dome_station_stop))

(script static boolean obj_transit_unsc_tram_ride_18_4
(>= obj_con_transit 20))

(script static boolean obj_transit_unsc_post_e25_18_6
(>= obj_con_transit 10))

(script static boolean obj_transit_unsc_coop_j_on_tram_18_7
(> (game_coop_player_count) 1))

(script static boolean obj_transit_unsc_solo_play_check_18_8
(= (game_coop_player_count) 1))

(script static boolean obj_transit_unsc_right_switch_18_9
(volume_test_players tv_transit_e25_left_switch))

(script static boolean obj_transit_unsc_left_switch_18_10
(volume_test_players tv_transit_e25_right_switch))

(script static boolean obj_transit_unsc_e23_e24_e25_active_18_12
(= obj_con_transit 0))

(script static boolean obj_transit_unsc_follow_player_18_13
(> (ai_combat_status gr_transit_e23_e24_e25) idle))

(script static boolean obj_space2_cov_e8_rescue_19_1
(= s_current_space_encounter 8))

(script static boolean obj_space2_cov_e8_rescue_a_19_2
(<= s_space_2_e8_rescue_part 1))

(script static boolean obj_space2_cov_e8_rescue_b_19_3
(= s_space_2_e8_rescue_part 2))

(script static boolean obj_space2_cov_e8_rescue_c_19_4
(>= s_space_2_e8_rescue_part 3))

(script static boolean obj_space2_cov_e8_rescue_19_6
(= s_current_space_encounter 8))

(script static boolean obj_space2_cov_e8_rescue_a_19_7
(<= s_space_2_e8_rescue_part 1))

(script static boolean obj_space2_cov_e8_rescue_b_19_8
(= s_space_2_e8_rescue_part 2))

(script static boolean obj_space2_cov_e8_rescue_c_19_9
(>= s_space_2_e8_rescue_part 3))

(script static boolean obj_minor_vista_to_entry_unsc_e7_20_1
(>= obj_con_overview 70))

(script static boolean obj_minor_vista_to_entry_unsc_e7_defeated_20_2
(and (>= obj_con_overview 70) (<= (ai_task_count obj_minor_vista_to_entry_cov/gr_beat1_e7_hydro_entry_garden) 0)))

(script static boolean obj_minor_vista_to_entry_unsc_e6_20_3
(>= obj_con_overview 60))

(script static boolean obj_minor_vista_to_entry_unsc_e6_defeated_20_4
(and (>= obj_con_overview 60) (<= (ai_task_count obj_minor_vista_to_entry_cov/gr_beat1_e6_hydro_entry_cor) 0)))

(script static boolean obj_minor_vista_to_entry_unsc_e4_e5_20_6
(>= obj_con_overview 40))

(script static boolean obj_minor_vista_to_entry_unsc_e5_bottom_defeated_20_7
(<= (ai_task_count obj_minor_vista_to_entry_cov/e5_bottom_guarding_door) 0))

(script static boolean obj_minor_vista_to_entry_unsc_follow_player_20_8
(>= obj_con_overview 50))

(script static boolean obj_minor_vista_to_entry_unsc_e4_e5_defeated_20_9
(<= (ai_task_count obj_minor_vista_to_entry_cov/grav_top) 0))

(script static boolean obj_johnson_hydro_bridge_after_encounter_23_0
(= (ai_living_count gr_beat1_e11_hydro_bridge) 0))

(script static boolean obj_johnson_hydro_bridge_to_lift_23_1
(= (volume_test_players tv_ponr_gravlift_b_shaft) 1))

(script static boolean obj_johnson_hydro_bridge_follow_23_3
(volume_test_players tv_hydro_bridge_johnson_return))

(script static boolean obj_johnson_hydro_bridge_johnson_c_23_4
(volume_test_players tv_hydro_bridge_c))

(script static boolean obj_johnson_hydro_bridge_johnson_b_23_5
(volume_test_players tv_hydro_bridge_b))

(script static boolean obj_transit_e28_e29_e30_cov_all_defend_sequence_24_0
(= b_dome_powering_started 1))

(script static boolean obj_space2_unsc_space2_guide_to_space3_27_0
(= b_space_2_complete 1))

(script static boolean obj_space2_unsc_e8_rescue_27_1
(= s_current_space_encounter 8))

(script static boolean obj_space2_unsc_marines_c_27_2
(>= s_space_2_e8_rescue_part 3))

(script static boolean obj_space2_unsc_marines_b_27_3
(= s_space_2_e8_rescue_part 2))

(script static boolean obj_space2_unsc_marines_a_27_4
(<= s_space_2_e8_rescue_part 1))

(script static boolean obj_space2_unsc_e6_johnson_guide_27_5
(<= s_current_space_encounter 6))

(script static boolean obj_gardens_redux_unsc_e17_28_0
(volume_test_players tv_lead_post_garden_redux))

(script static boolean obj_gardens_redux_unsc_follow_player_28_1
(volume_test_players tv_post_garden_high))

(script static boolean obj_gardens_redux_unsc_follow_player_28_2
(volume_test_players tv_post_garden_grav_up))

(script static boolean obj_gardens_redux_unsc_wait_lift_28_3
(and (= b_e17_spawned 1) (= (ai_living_count gr_beat2_e17_post_garden_low) 0)))

(script static boolean obj_gardens_redux_unsc_encounter_28_4
(volume_test_players tv_mid_garden_a_redux))

(script static boolean obj_gardens_redux_unsc_wait_at_next_door_28_7
(= (ai_living_count gr_beat2_e16_garden2_redux) 0))

(script static boolean obj_gardens_redux_unsc_encounter_28_8
(volume_test_players tv_start_garden_redux))

(script static boolean obj_space3_cov_dogfight_wave_29_2
(>= (device_get_position dm_bop) r_burden_pos_5))

(script static boolean obj_space3_cov_kamikaze_wave_1_29_3
(>= (device_get_position dm_bop) 0))

(script static boolean obj_space3_cov_dogfight_wave_29_5
(>= (device_get_position dm_bop) r_burden_pos_5))

(script static boolean obj_space3_cov_kamikaze_wave_1_29_6
(>= (device_get_position dm_bop) 0))

(script static boolean obj_transit_e23_e24_e25_cov_hunter_aggressive_30_1
(= (ai_living_count gr_e25_hunters) 1))

(script static boolean obj_transit_e23_e24_e25_cov_grunt_to_hunters_30_6
(= (volume_test_players tv_transit_e25_marker) 1))

(script static boolean obj_transit_e23_e24_e25_cov_can_retreat_30_7
(= (ai_living_count gr_e25_hunters) 0))

(script static boolean obj_rest_respite_fallback_31_2
(<= (ai_living_count gr_beat2_e22_rest_respite) 5))

(script static boolean obj_rest_respite_top_31_5
(volume_test_players tv_rr_top_check))

(script static boolean obj_rest_respite_mid_edge_31_6
(<= (ai_living_count gr_beat2_e22_rest_respite) 10))

(script static boolean obj_rest_respite_fallback_round_31_9
(<= (ai_living_count gr_beat2_e22_rest_respite) 5))

(script static boolean obj_rest_respite_fallback_31_13
(<= (ai_living_count gr_beat2_e22_rest_respite) 5))

(script static boolean obj_space1_unsc_to_debris_field_32_0
(= b_space_1_complete 1))

(script static boolean obj_space1_unsc_e2_relays_32_1
(= s_current_space_encounter 2))

(script static boolean obj_space1_unsc_e2_relay_1_32_2
(= b_relay_1_destroyed 0))

(script static boolean obj_space1_unsc_e2_relay_2_32_3
(= b_relay_2_destroyed 0))

(script static boolean obj_space1_unsc_e2_relay_3_32_4
(= b_relay_3_destroyed 0))

(script static boolean obj_space1_unsc_e2_relay_4_32_5
(= b_relay_4_destroyed 0))

(script static boolean obj_space1_unsc_e1_dogfight_32_6
(<= s_current_space_encounter 1))

(script static boolean obj_transit_hangar_johnson_hangar_vign_33_0
(= b_hangar_johnson_start 1))

(script static boolean obj_transit_hangar_johnson_shoot_pos_33_1
(volume_test_object tv_hangar_vign_wraith sq_e34_hangar_vign))

(script static boolean obj_transit_hangar_johnson_enter_hangar_33_3
(volume_test_players tv_transit_player_in_hangar))

(script static boolean obj_transit_hangar_johnson_towards_hangar_33_4
(volume_test_players tv_post_e33_up_grav))

(script static boolean obj_transit_hangar_johnson_up_grav_33_5
(volume_test_players tv_post_e33_below_grav))

(script static boolean obj_transit_hangar_johnson_by_grav_33_6
(volume_test_players tv_post_e33_lead_to_grav))

(script static boolean obj_hydro_bridge_follow_player_35_2
(volume_test_players tv_hydro_bridge_c))

(script static boolean obj_hydro_bridge_flank_bridge_b_35_3
(volume_test_players tv_hydro_bridge_b))

(script static boolean obj_hydro_bridge_flank_bridge_a_35_4
(volume_test_players tv_hydro_bridge_a))

(script static boolean obj_transit_e27_cov_jump_from_behind_36_4
(= b_e27_grunts_behind  1))

(script static boolean obj_transit_e27_cov_suicide_grunt_36_7
(= b_e27_kamikaze_ready  1))

(script static boolean obj_transit_e26_cov_tram_jump_37_3
(= b_e26_jump_ready 1))

(script static boolean obj_transit_e26_cov_top_right_37_6
(= b_e26_pos_change 1))

(script static boolean obj_transit_e26_cov_lower_platform_right_37_8
(= b_e26_pos_change 1))

(script static boolean obj_gardens_unsc_e10_38_0
(>= obj_con_gardens 20))

(script static boolean obj_gardens_unsc_follow_player_38_1
(volume_test_players tv_garden2_john_follow))

(script static boolean obj_gardens_unsc_wait_at_next_door_38_2
(<= (ai_task_count obj_gardens_cov/gr_beat1_e10_hydro_garden2) 0))

(script static boolean obj_gardens_unsc_advance_38_3
(volume_test_players tv_garden_2_enc))

(script static boolean obj_gardens_unsc_follow_player_38_5
(volume_test_players tv_garden1_john_follow))

(script static boolean obj_gardens_unsc_wait_at_next_door_38_6
(<= (ai_task_count obj_gardens_cov/gr_beat1_e9_hydro_garden) 0))

(script static boolean obj_gardens_unsc_task_0_38_7
(volume_test_players tv_end_fl_to_gardens))

