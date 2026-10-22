(script static boolean aiobjective_enc4_3_5_muster_encounter4_5_0_0
(volume_test_players enc4_5))

(script static boolean aiobjective_enc4_3_5_muster_everyone_collapse_0_1
(volume_test_players enc4_5b))

(script static boolean aiobjective_enc4_3_5_muster_gaurd_exit_0_2
(volume_test_players tv_navend_vehiclebay_exit))

(script static boolean aiobjective_enc4_3_5_muster_player_drops_0_4
(volume_test_players enc4_3c))

(script static boolean aiobjective_enc4_3_5_muster_hall_ways_0_6
(volume_test_players enc4_4))

(script static boolean aiobjective_enc4_3_5_muster_encounter4_4_0_10
(volume_test_players enc4_4))

(script static boolean aiobjective_enc4_3_5_muster_combat_attack_b_0_16
(volume_test_players enc4_3b))

(script static boolean aiobjective_enc3_8_flood_chase_player_1_0
(<= (ai_living_count enc3_8_cov) 0))

(script static boolean aiobjective_enc3_8_flood_final_push_1_4
(volume_test_players enc3_8b))

(script static boolean aiobjective_enc3_8_flood_kill_sword_squad_1_6
(> (ai_living_count enc3_8_cov_sword) 0))

(script static boolean aiobjective_enc3_8_flood_playfight_1_7
(not (volume_test_players grav_lift)))

(script static boolean aiobjective_enc3_8_flood_go_to_cross_roads_1_8
(volume_test_players tv_fall_back_to_cross_roads))

(script static boolean aiobjective_enc3_8_flood_go_to_tree_1_9
(volume_test_players grav_lift))

(script static boolean aiobjective_enc3_8_flood_playfight_1_11
(not (volume_test_players grav_lift)))

(script static boolean aiobjective_enc3_8_flood_move_up_hill_1_12
(< (ai_living_count enc3_8_cov_gaurd) 4))

(script static boolean aiobjective_enc3_8_flood_attack_lift_1_13
(<= (ai_living_count enc3_8_cov_gaurd) 0))

(script static boolean aiobjective_enc3_8_flood_kill_sword_squad_1_15
(> (ai_living_count enc3_8_cov_sword) 0))

(script static boolean aiobjective_enc3_8_flood_playfight_1_16
(not (volume_test_players grav_lift)))

(script static boolean aiobjective_enc3_8_flood_go_to_cross_roads_1_17
(volume_test_players tv_fall_back_to_cross_roads))

(script static boolean aiobjective_enc3_8_flood_go_to_tree_1_18
(volume_test_players grav_lift))

(script static boolean aiobjective_enc3_8_flood_playfight_1_20
(not (volume_test_players grav_lift)))

(script static boolean aiobjective_enc3_8_flood_move_up_hill_1_21
(< (ai_living_count enc3_8_cov_gaurd) 4))

(script static boolean aiobjective_enc3_8_flood_attack_lift_1_22
(<= (ai_living_count enc3_8_cov_gaurd) 0))

(script static boolean aiobjective_enc3_8_flood_task_45_1_25
(not (volume_test_players grav_lift)))

(script static boolean aiobjective_enc3_5_cov_fall_back_2_2
(< (unit_get_health enc3_5_turret) .75))

(script static boolean aiobjective_enc3_5_flood_ambush_5_0
(volume_test_players enc3_5c))

(script static boolean aiobjective_enc3_5_flood_back_5_8
(volume_test_players enc3_6))

(script static boolean aiobjective_enc3_5_flood_mid_5_9
(volume_test_players enc3_5a))

(script static boolean aiobjective_enc3_5_flood_forward_5_12
(volume_test_players enc3_6))

(script static boolean aiobjective_enc4_7_cov_run_for_hangar_9_2
(volume_test_players enc4_8))

(script static boolean aiobjective_enc4_7_cov_last_line_9_3
(<= (ai_living_count enc4_7_cov) 2))

(script static boolean aiobjective_enc4_7_cov_fight_off_flood_9_4
(or (> (ai_living_count enc4_7_flood) 0) (> (ai_living_count enc4_8_flood) 0)))

(script static boolean aiobjective_enc4_7_cov_no_player_playfight_9_5
(not (volume_test_players tv_enc4_7_player_check)))

(script static boolean aiobjective_enc4_7_cov_fall_back_hard_9_9
(< (ai_living_count enc4_7_cov) 4))

(script static boolean aiobjective_enc5_6_flood_chase_12_1
(volume_test_players enc5_7))

(script static boolean aiobjective_enc4_0_flood_co_op_15_0
(> (game_coop_player_count) 2))

(script static boolean aiobjective_enc6_5_flood_chase_player_19_5
(volume_test_players enc6_5_stopper))

(script static boolean aiobjective_enc6_5_flood_roll_out_on_wave_19_6
(>= enc6_5_limiter (- (* 6 spawn_scale) 1)))

(script static boolean aiobjective_enc6_5_flood_player_attempts_to_escape_19_7
(or (volume_test_players enc6_4) (volume_test_players enc6_5_stopper) (script_finished "enc6_5_manager")))

(script static boolean aiobjective_enc6_5_flood_push_player_to_door_19_10
(not (volume_test_players enc6_5_platform)))

(script static boolean aiobjective_enc5_1_flood_shift_to_defense_20_1
(volume_test_players enc5_6))

(script static boolean aiobjective_enc5_1_flood_playfight_20_5
(not (volume_test_players enc5_1)))

(script static boolean aiobjective_enc5_1_flood_playfight_20_7
(not (volume_test_players enc5_1)))

(script static boolean aiobjective_enc5_1_flood_playfight_20_9
(not (volume_test_players enc5_1)))

(script static boolean aiobjective_enc5_1_flood_move_to_level_2_20_10
(volume_test_players enc5_1_spawner_safety))

(script static boolean aiobjective_enc5_1_flood_move_to_level_2_20_11
(<= (ai_living_count sq_enc5_1_floor_covenant_grunts) 0))

(script static boolean aiobjective_enc5_7_flood_move_to_hangar_21_3
(volume_test_players tv_nav_shuttle_3rd_floor))

(script static boolean aiobjective_enc5_7_flood_follow_player_21_4
(not (volume_test_players tv_nav_shuttle_3rd_floor)))

(script static boolean aiobjective_enc6_1_cov_defending_22_1
(> (device_get_position small_door78) .5))

(script static boolean aiobjective_enc6_1_cov_a_fight_for_bridge_22_4
(> (device_get_position small_door78) .5))

(script static boolean aiobjective_enc5_4_cov_move_to_stairs_23_1
(<= (ai_nonswarm_count enc5_4_flood) 0))

(script static boolean aiobjective_enc5_4_cov_move_to_elbow_23_2
(<= (ai_nonswarm_count enc5_5_flood) 0))

(script static boolean aiobjective_enc5_4_cov_move_to_control_23_3
(<= (ai_nonswarm_count enc5_6_flood) 0))

(script static boolean aiobjective_enc5_7_cov_move_to_hall_24_1
(<= (ai_nonswarm_count enc5_2_flood) 0))

(script static boolean aiobjective_enc5_7_cov_move_to_stairs_24_2
(<= (ai_nonswarm_count enc5_4_flood) 0))

(script static boolean aiobjective_enc5_7_cov_move_to_hall_exit_24_3
(<= (ai_nonswarm_count enc5_5_flood) 0))

(script static boolean aiobjective_enc5_7_cov_move_to_control_hall_24_4
(<= (ai_nonswarm_count enc5_6_flood) 0))

(script static boolean aiobjective_enc5_7_cov_chase_player_24_5
(<= (ai_nonswarm_count enc5_7_flood) 0))

(script static boolean aiobjective_enc5_7_cov_move_to_top_24_6
(<= (ai_nonswarm_count enc5_7_flood) 0))

(script static boolean aiobjective_enc3_8_cov_final_stand_25_0
(volume_test_players enc3_8c))

(script static boolean aiobjective_enc3_8_cov_move_to_guard_25_3
(or (<= (ai_living_count enc3_8_cov_sword) 1) (volume_test_players enc3_8b )))

(script static boolean aiobjective_enc3_8_cov_fall_back_to_cross_roads_25_5
(volume_test_players tv_fall_back_to_cross_roads))

(script static boolean aiobjective_enc3_8_cov_fall_back_player_25_6
(volume_test_players grav_lift))

(script static boolean aiobjective_enc5_5_flood_move_to_elbow_26_0
(volume_test_players enc5_6))

(script static boolean aiobjective_enc5_5_flood_top_of_stairs_26_2
(<= (ai_nonswarm_count sq_enc5_5_flood_hall) 0))

(script static boolean aiobjective_enc5_5_flood_chase_26_5
(volume_test_players enc5_5c))

(script static boolean aiobjective_enc3_0_cov_chase_27_1
(<= (ai_living_count enc3_0_flood) 0))

(script static boolean aiobjective_enc3_0_cov_chase_27_4
(<= (ai_living_count enc3_0_flood) 0))

(script static boolean aiobjective_enc6_4_cov_breach_control_28_1
(or (volume_test_players enc6_4) (>= enc6_5_limiter (- (* 6 spawn_scale) 1))))

(script static boolean aiobjective_enc6_4_cov_chase_player_28_2
(<= (ai_nonswarm_count enc6_5_flood) 0))

(script static boolean aiobjective_enc3_4_flood_fight_for_real_30_1
(or (volume_test_players enc3_4b) (volume_test_players enc3_4a)))

(script static boolean aiobjective_enc3_4_flood_wrap_encounter_30_2
(< (ai_living_count enc3_4_cov) 3))

(script static boolean aiobjective_enc3_4_flood_focus_player_30_3
(< (ai_living_count enc3_4_cov) 1))

(script static boolean aiobjective_enc3_4_flood_hunters_died_30_9
(< (ai_living_count sq_enc3_4_covenant_hunters) 1))

(script static boolean aiobjective_enc5_3_cov_take_command_33_1
(volume_test_players enc5_1_spawner_safety))

(script static boolean aiobjective_enc5_5_cov_advance_to_elbow_35_1
(<= (ai_nonswarm_count sq_enc5_5_flood_hall) 0))

(script static boolean aiobjective_enc5_5_cov_advance_to_top_35_2
(<= (ai_nonswarm_count enc5_5_flood) 0))

(script static boolean aiobjective_enc5_5_cov_advance_to_control_35_3
(<= (ai_nonswarm_count enc5_6_flood) 0))

(script static boolean aiobjective_enc6_1_flood_fight_for_the_bridge_37_1
(> (device_get_position small_door78) .5))

(script static boolean aiobjective_enc5_2_cov_follow_player_38_0
(<= (ai_nonswarm_count enc5_2_flood) 0))

(script static boolean aiobjective_enc4_7_flood_move_to_exit_46_2
(>= (ai_living_count enc4_7_cov) 1))

(script static boolean aiobjective_enc4_7_flood_no_player_playfight_46_3
(not (volume_test_players tv_enc4_7_player_check)))

(script static boolean aiobjective_enc4_7_flood_fight_covenant_46_7
(> (ai_living_count enc4_7_cov) 0))

(script static boolean aiobjective_enc4_7_flood_no_player_playfight_46_8
(not (volume_test_players tv_enc4_7_player_check)))

(script static boolean aiobjective_enc4_7_flood_move_to_mid_46_9
(< (ai_living_count enc4_7_cov) 4))

(script static boolean aiobjective_enc4_7_flood_take_exit_46_10
(<= (ai_living_count enc4_7_cov) 2))

(script static boolean aiobjective_enc3_0_flood_chase_47_1
(<= (ai_living_count enc3_0_cov) 0))

(script static boolean aiobjective_enc3_0_flood_chase_47_3
(<= (ai_living_count enc3_0_cov) 0))

(script static boolean aiobjective_enc3_2_flood_check_for_player_leaving_48_1
(or (volume_test_players enc3_3b) ( <= (ai_living_count enc3_2_cov) 0)))

(script static boolean aiobjective_enc3_2_flood_check_for_no_covies_48_3
(<= (ai_living_count enc3_2_cov) 0))

(script static boolean aiobjective_enc1_5_flood_attack_player_coop_49_1
(> (game_coop_player_count) 2))

(script static boolean aiobjective_enc3_4_cov_fight_for_real_50_1
(or (volume_test_players enc3_4b) (volume_test_players enc3_4a)))

(script static boolean aiobjective_enc3_4_cov_hunters_dead_50_4
(< (ai_living_count sq_enc3_4_covenant_hunters) 1))

(script static boolean aiobjective_enc3_4_cov_retreat_50_5
(<= (ai_living_count enc3_4_cov) 3))

(script static boolean aiobjective_enc3_4_cov_defend_50_11
(< (ai_living_count sq_enc3_4_covenant_hunters) 2))

(script static boolean aiobjective_enc3_4_cov_forward_50_12
(> (ai_living_count sq_enc3_4_covenant_hunters) 1))

(script static boolean aiobjective_enc5_1_cov_playfight_51_2
(not (volume_test_players enc5_1)))

(script static boolean aiobjective_enc5_1_cov_move_on_player_51_3
(volume_test_players enc5_1_spawner_safety))

(script static boolean aiobjective_enc5_1_cov_playfight_51_6
(not (volume_test_players enc5_1)))

(script static boolean aiobjective_enc5_1_cov_push_player_51_7
(volume_test_players enc5_1_spawner_safety))

(script static boolean aiobjective_enc5_1_cov_playfight_51_10
(not (volume_test_players enc5_1)))

(script static boolean aiobjective_enc5_1_cov_move_up_51_11
(volume_test_players enc5_1_spawner_safety))

(script static boolean aiobjective_enc5_1_cov_move_up_51_12
(and (<= (ai_nonswarm_count sq_enc5_1_flood_infectors) 0) (<= (ai_nonswarm_count sq_enc5_1_floor_1_def_flood) 0)))

(script static boolean aiobjective_enc5_2_flood_push_pillar_53_1
(<= (ai_living_count sq_enc5_2_covenant_hunters) 0))

(script static boolean aiobjective_enc5_2_flood_push_top_53_2
(<= (ai_living_count sq_enc5_2_covenant_grunts) 1))

(script static boolean aiobjective_enc5_2_flood_go_to_hangar_53_3
(<= (ai_living_count enc5_2_cov) 0))

(script static boolean aiobjective_enc5_2_flood_follow_player_53_4
(<= (ai_living_count enc5_1_cov) 0))

(script static boolean aiobjective_enc3_7_flood_attack_turret_55_9
(< (ai_living_count sq_enc3_7_covenant_grunts) 2))

