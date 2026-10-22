(script static boolean obj_arena_wave_1_hill_2_3
(= b_trigger_arena_ambush true))

(script static boolean obj_arena_wave_1_mid_path_2_4
(= b_trigger_arena_ambush true))

(script static boolean obj_arena_wave_1_mid_path_grunts_2_5
(= b_trigger_arena_ambush true))

(script static boolean obj_arena_wave_1_wall_2_6
(= b_trigger_arena_ambush true))

(script static boolean obj_observation_bottom_wave1_unlock_brutes_4_2
(= b_emerg_cell_opened 0))

(script static boolean obj_final_encounter_williams_revenge_7_12
(= (ai_living_count gr_final_encounter_wv2) 0) )

(script static boolean obj_bridge_encounter_covenant_11_1
(volume_test_players tv_bridge_encounter))

(script static boolean obj_bridge_encounter_banshee_retreat_11_2
(= b_banshee_assualt_finished true))

(script static boolean obj_bridge_encounter_top_11_5
(= (ai_living_count gr_bridge_banshees) 0))

(script static boolean obj_bridge_encounter_target_banshees_11_12
(and (= (ai_living_count gr_bridge_onfoot) 0)  (= b_banshee_assualt_finished false)))

(script static boolean obj_settlement_encounter_active_13_3
(> (ai_living_count gr_settlement) 0))

(script static boolean obj_brute_cells_brute_cells_b_elite_17_1
(= (ai_living_count sq_brute_cells_wv1_brute) 0))

(script static boolean obj_brute_cells_junction_a_elite_17_5
(= (ai_living_count sq_brute_cells_wv2_brute) 0))

(script static boolean obj_brute_ambush_oh_no_you_dont_24_1
(volume_test_players tv_jackal_jungle))

(script static boolean obj_brute_ambush_jackal_player_spotted_24_3
(or (volume_test_players tv_brute_ambush_trap) (volume_test_players tv_brute_ambush_trap2) (>= (ai_combat_status gr_brute_ambush) dangerous)))

(script static boolean obj_brute_ambush_wait_trap_24_4
(not (>= (ai_combat_status gr_brute_ambush) dangerous)))

(script static boolean obj_brute_ambush_brute_wait_trap_24_5
(or (not (volume_test_players tv_brute_ambush_trap)) (not (volume_test_players tv_brute_ambush_trap2))))

(script static boolean obj_brute_ambush_jackal_wait_trap_24_6
(or (not (volume_test_players tv_brute_ambush_trap)) (not (volume_test_players tv_brute_ambush_trap2))))

(script static boolean obj_brute_ambush_trap_jump_24_8
 (not (volume_test_object tv_brute_ambush_jump sq_brute_ambush_brutes2)))

(script static boolean obj_brute_ambush_grunts_24_11
(volume_test_players tv_brute_ambush_trap))

(script static boolean obj_brute_ambush_sleeping_grunts_24_13
(or (volume_test_players tv_brute_ambush_trap) (volume_test_players tv_brute_ambush_trap2) (>= (ai_combat_status gr_brute_ambush) dangerous)))

(script static boolean obj_brute_ambush_encounter_finished_24_15
(= (ai_living_count gr_e11_brute_ambush) 0))

(script static boolean obj_brute_ambush_encounter_active_24_17
(> (ai_living_count gr_e11_brute_ambush) 0))

(script static boolean obj_brute_ambush_williams_wave2_24_18
(= (ai_living_count gr_brute_ambush) 0))

(script static boolean obj_brute_ambush_johnson_wave2_24_19
(= (ai_living_count gr_brute_ambush) 0))

(script static boolean obj_brute_ambush_williams_wave1_24_20
(> (ai_living_count gr_brute_ambush) 0))

(script static boolean obj_brute_ambush_johnson_wave1_24_21
(> (ai_living_count gr_brute_ambush) 0))

(script static boolean obj_jackal_jungle_spec_ops_blipped_26_6
(<= (ai_living_count gr_jackal_jungle) 3))

(script static boolean obj_jackal_jungle_encounter_over_26_10
 (= (ai_living_count gr_jackal_jungle) 0))

(script static boolean obj_jackal_jungle_encounter_active_26_11
(> (ai_living_count gr_jackal_jungle) 0))

(script static boolean obj_jackal_jungle_heros_end_26_12
(= (volume_test_players tv_jackal_jungle_push2) 1))

(script static boolean obj_jackal_jungle_heros_push_26_13
(= (volume_test_players tv_jackal_jungle_push) 1))

(script static boolean obj_jackal_jungle_pinned_marines_26_15
(> (ai_living_count sq_jackal_jungle_wv1_grunts) 0))

(script static boolean obj_prison_bridge_ext_wraith_prioritize_personal_space_27_2
(volume_test_players tv_wraith_personal_space))

(script static boolean obj_prison_bridge_ext_wraith_pressure_normal_27_3
(volume_test_players tv_pb_sniper_zone2))

(script static boolean obj_prison_bridge_ext_wraith_pressure_heroic_legendary_27_4
(volume_test_players tv_pb_sniper_zone2))

(script static boolean obj_prison_bridge_ext_hacking_started_27_9
(= b_prison_hacking_started 1))

(script static boolean obj_prison_bridge_ext_gate_front_27_14
(= (ai_living_count gr_prison_bridge) 0))

(script static boolean obj_prison_bridge_ext_dam_defense_push_27_17
(or (volume_test_players tv_pcheck_in_yard) (volume_test_players tv_pcheck_entrance)))

(script static boolean obj_prison_bridge_ext_dam_bridge_27_18
(and (volume_test_players tv_pcheck_on_bridge) (not (volume_test_players tv_pcheck_on_dam))))

(script static boolean obj_prison_bridge_ext_dam_snipe_easy_normal_27_20
(or (not (volume_test_players tv_pcheck_on_dam2)) (not (volume_test_players tv_pcheck_entrance))))

(script static boolean obj_prison_bridge_ext_dam_snipe_heroic_legendary_27_21
(or (not (volume_test_players tv_pcheck_on_dam2)) (not (volume_test_players tv_pcheck_entrance))))

(script static boolean obj_prison_bridge_ext_prison_flank_27_33
(not (volume_test_players tv_prison_entrance)))

(script static boolean obj_prison_bridge_ext_prison_flank_abandon_27_34
(volume_test_players tv_prison_entrance))

(script static boolean obj_prison_bridge_ext_hacking_started_humans_27_36
(= b_prison_hacking_started 1))

(script static boolean obj_prison_bridge_ext_johnson_snipe_27_37
(volume_test_object tv_pb_sniper_zone ai_johnson))

(script static boolean obj_prison_bridge_ext_ai_follow_27_38
(or (volume_test_players tv_pcheck_in_yard) (volume_test_players tv_pcheck_entrance)))

(script static boolean obj_observation_top_legendary_jump_scare_33_2
(= (game_difficulty_get) legendary))

(script static boolean obj_post_arena_encounter_guard_bridge_back_attack_35_3
(volume_test_players tv_to_bridge1_near_camo))

(script static boolean obj_brute_bowl_where_do_you_think_youre_going_37_1
(volume_test_players tv_settlement_chase))

(script static boolean obj_brute_bowl_player_front_37_2
(volume_test_players tv_e1_front))

(script static boolean obj_brute_bowl_player_mid_37_6
(volume_test_players tv_e1_mid))

(script static boolean obj_brute_bowl_player_back_37_10
(volume_test_players tv_e1_back))

(script static boolean obj_brute_bowl_jon_sniping_37_19
(> (ai_living_count gr_brute_bowl) 0))

