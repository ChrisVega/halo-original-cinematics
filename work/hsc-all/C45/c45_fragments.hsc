(script static boolean obj_e6_a_guard_runpasttoconduitroom_2_1
(volume_test_players tv_plat1_runpast_guard))

(script static boolean obj_e6_a_guard_platform_bansheeshootback_2_2
(and (volume_test_players tv_plat1_banshee_shootback) (not (volume_test_players tv_act_chapter_2))))

(script static boolean obj_e6_a_guard_runpasttoconduitroom_2_5
(volume_test_players tv_plat1_runpast_guard))

(script static boolean obj_e6_a_reinforce_platform_2_6
(and (< (ai_living_fraction sq_e6_a_empa_vignette) 1) (volume_test_players tv_act_chapter_2)))

(script static boolean obj_e8_a_eli_maj_pla_b_3_1
(and (<  (ai_living_fraction sq_e8_a_gmpb) 0.25) (< (ai_living_fraction sq_e8_a_jmpc) 0.25)))

(script static boolean obj_e8_a_flee_to_interior_grunt_3_4
(< (ai_living_fraction sq_e8_a_gmpb) 1))

(script static boolean obj_e8_a_flee_to_interior_jack_3_7
(< (ai_living_fraction sq_e8_a_jmpc) 1))

(script static boolean obj_e_extra_room_extra_arena_fight_magic_4_1
(< (ai_living_fraction sq_e_extra_a_flood) .5))

(script static boolean obj_e_extra_room_extra_arena_fight_magic_4_3
(< (ai_living_fraction sq_e_extra_a_covenant) .5))

(script static boolean obj_e_extra_room_extra_hal_step_out_and_attack_4_7
(volume_test_players tv_extra_room_hallway_elbow))

(script static boolean obj_e_extra_room_push_to_close_side_hallway_4_10
(volume_test_players tv_extra_room_hallway_ambush))

(script static boolean obj_e_extra_room_extra_hal_attack_4_13
(volume_test_players tv_extra_room_hallway_ambush))

(script static boolean obj_e_extra_room_extra_hal_run_down_middle_and_fight_when_player_seen_4_16
(volume_test_players tv_extra_room_hallway_elbow))

(script static boolean obj_e_extra_room_extra_gen_magic_at_half_count_4_19
(<= (ai_living_fraction sq_e_extra_c_flood) .5))

(script static boolean obj_e48_a_flood_up_5_2
(and (= (ai_living_count sq_e48_a_jmpb) 0) (not (volume_test_players tv_shine_tower_player_in_pit))))

(script static boolean obj_e48_a_flood_eat_player_in_pit_5_3
(and (= (ai_living_count sq_e48_a_jmpb) 0) (volume_test_players tv_shine_tower_player_in_pit)))

(script static boolean obj_e62_a_stealth_fight_20_3
(< (ai_living_count gr_e62_a) 6))

(script static boolean obj_e62_a_wave2_fight_20_6
(< (ai_living_count gr_e62_a) 6))

(script static boolean obj_e62_a_wave3_fight_20_9
(< (ai_living_count gr_e62_d) 6))

(script static boolean obj_e48_a_snipers_spiral_top_cover_from_ridge_28_2
(volume_test_players tv_shine_tower_player_after_tree))

(script static boolean obj_e48_a_snipers_spiral_top_cover_from_tower_28_3
(volume_test_players tv_shine_tower_player_before_tree))

(script static boolean obj_e48_a_snipers_spiral_shade_magic_28_9
(or (volume_test_players tv_shine_tower_player_after_tree) (volume_test_players tv_shine_tower_player_in_pit)))

(script static boolean obj_e48_a_snipers_spiral_rock_3_cover_from_ridge_28_13
(volume_test_players tv_shine_tower_player_after_tree))

(script static boolean obj_e48_a_snipers_spiral_rock_3_cover_from_tower_28_14
(volume_test_players tv_shine_tower_player_before_tree))

(script static boolean obj_e48_a_snipers_spiral_rock_2_cover_from_ridge_28_20
(volume_test_players tv_shine_tower_player_after_tree))

(script static boolean obj_e48_a_snipers_spiral_rock_2_cover_from_tower_28_21
(volume_test_players tv_shine_tower_player_before_tree))

(script static boolean obj_e48_a_snipers_shine_tower_move_to_gate_28_30
(volume_test_players tv_shine_tower_player_approaching_gate))

