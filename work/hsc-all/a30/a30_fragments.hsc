(script static boolean aiobjective_lz_search_follow_player_1_0
(= true global_search_follow_player))

(script static boolean aiobjective_holdout_first_cov_run_to_your_death_2_2
(and global_first_wave_6 (< (ai_living_count sq_gr_holdout0_waves) 5)))

(script static boolean aiobjective_holdout_first_cov_take_beam_tower_2_3
(< (ai_living_count sq_gr_first_marine) 3))

(script static boolean aiobjective_holdout_first_cov_wave_6_squads_2_6
global_first_wave_6)

(script static boolean aiobjective_holdout_first_cov_wave_5_squads_2_11
global_first_wave_5)

(script static boolean aiobjective_holdout_first_cov_wave_4_2_15
global_first_wave_4)

(script static boolean aiobjective_holdout_first_cov_wave_3_2_18
global_first_wave_3)

(script static boolean aiobjective_holdout_first_cov_wave_2_2_21
global_first_wave_2)

(script static boolean aiobjective_holdout_first_cov_wave_1_2_33
global_first_wave_1)

(script static boolean aiobjective_holdout_first_cov_w1_assault_tower_2_34
(volume_test_players first_trigger_1))

(script static boolean aiobjective_holdout_rubble_marine_encounter_started_3_3
global_rubble_start)

(script static boolean aiobjective_holdout_rubble_marine_exfil_3_4
global_rubble_end)

(script static boolean aiobjective_holdout_rubble_marine_retreat_3_7
(< (ai_living_fraction enc_holdout_rubble_marine) .25))

(script static boolean aiobjective_holdout_rubble_marine_player_has_arrived_3_9
(volume_test_players rubble_arrival))

(script static boolean aiobjective_holdout_rubble_marine_wave_5_3_11
(> (ai_living_count rubble_wave_5_cship) 0))

(script static boolean aiobjective_holdout_rubble_marine_hunt_down_covenant_3_12
(<= (ai_living_count enc_holdout_rubble_cov) 5))

(script static boolean aiobjective_holdout_rubble_marine_w5_attack_3_14
(not (volume_test_object rubble_attack enc_holdout_rubble_cov)))

(script static boolean aiobjective_holdout_rubble_marine_w5_defend_3_16
(not (volume_test_object rubble_defend enc_holdout_rubble_cov)))

(script static boolean aiobjective_holdout_rubble_marine_wave_4_3_20
(> (ai_living_count rubble_wave_4_cship) 0))

(script static boolean aiobjective_holdout_rubble_marine_w4_attack_3_21
(not (volume_test_object rubble_attack enc_holdout_rubble_cov)))

(script static boolean aiobjective_holdout_rubble_marine_w4_defend_3_23
(not (volume_test_object rubble_defend enc_holdout_rubble_cov)))

(script static boolean aiobjective_holdout_rubble_marine_wave_3_3_27
(> (ai_living_count rubble_wave_3_cship) 0))

(script static boolean aiobjective_holdout_rubble_marine_w3_attack_3_28
(not (volume_test_object rubble_attack enc_holdout_rubble_cov)))

(script static boolean aiobjective_holdout_rubble_marine_w3_defend_3_30
(not (volume_test_object rubble_defend enc_holdout_rubble_cov)))

(script static boolean aiobjective_holdout_rubble_marine_wave_2_3_34
(> (ai_living_count rubble_wave_2_cship) 0))

(script static boolean aiobjective_holdout_rubble_marine_w2_attack_3_36
(not (volume_test_object rubble_attack enc_holdout_rubble_cov)))

(script static boolean aiobjective_holdout_rubble_marine_w2_defend_3_38
(not (volume_test_object rubble_defend enc_holdout_rubble_cov)))

(script static boolean aiobjective_holdout_cliffside_cov_right_2_retreat_5_1
(< (ai_living_count enc_holdout_cliffside_cov) 7))

(script static boolean aiobjective_holdout_cliffside_cov_right_2_cheat_left_5_4
(volume_test_players cliff_left_side))

(script static boolean aiobjective_lz_banshee_hills_6_0
(volume_test_players tv_banshee_hills))

(script static boolean aiobjective_lz_banshee_bridge_6_1
(volume_test_players tv_banshee_bridge))

(script static boolean aiobjective_holdout_first_marine_exfil_8_0
global_first_end)

(script static boolean aiobjective_holdout_first_marine_join_fireteam_8_1
volunteer_migrate_ready)

(script static boolean aiobjective_holdout_first_marine_get_a_lift_out_8_4
(script_finished "dialogue_escape_pods"))

(script static boolean aiobjective_holdout_first_marine_incoming_spirits_8_6
b_first_wave_2_calledout)

(script static boolean aiobjective_holdout_first_marine_wave_6_8_7
b_first_wave_6_calledout)

(script static boolean aiobjective_holdout_first_marine_all_tower_top_8_8
(< (ai_living_count sq_gr_first_starters) 5))

(script static boolean aiobjective_holdout_first_marine_wave_5_8_10
(or b_first_wave_5_calledout global_first_marine_defend))

(script static boolean aiobjective_holdout_first_marine_wave_4_8_17
b_first_wave_4_calledout)

(script static boolean aiobjective_holdout_first_marine_w4_attacking_8_19
global_first_marine_attack)

(script static boolean aiobjective_holdout_first_marine_wave_3_8_24
b_first_wave_3_calledout)

(script static boolean aiobjective_holdout_first_marine_w3_attacking_8_26
global_first_marine_attack)

(script static boolean aiobjective_holdout_first_marine_wave_2_8_31
b_first_wave_2_calledout)

(script static boolean aiobjective_holdout_first_marine_w2_attacking_8_33
global_first_marine_attack)

(script static boolean aiobjective_holdout_first_marine_welcome_player_8_39
global_ai_greetplayer)

(script static boolean aiobjective_holdout_first_marine_fight_off_wave_0_8_45
(not (volume_test_players first_arrival)))

(script static boolean aiobjective_holdout_first_marine_playfight_wait_for_player_8_49
global_first_wave_1)

(script static boolean aiobjective_holdout_rubble_cov_2_encounter_start_9_0
global_rubble_start)

(script static boolean aiobjective_holdout_rubble_cov_2_hunt_the_player_9_1
(volume_test_players rubble_arrival))

(script static boolean aiobjective_holdout_rubble_cov_2_marines_exterminated_9_2
(< (ai_living_count enc_holdout_rubble_marine) 1))

(script static boolean aiobjective_holdout_rubble_cov_2_covenant_last_stand_9_3
(and global_rubble_wave_5 (<= (ai_living_count enc_holdout_rubble_cov) 5) ))

(script static boolean aiobjective_holdout_rubble_cov_2_player_has_arrived_snipers_9_5
(volume_test_players rubble_arrival))

(script static boolean aiobjective_holdout_rubble_cov_2_wave_5_9_7
global_rubble_wave_5)

(script static boolean aiobjective_holdout_rubble_cov_2_wave_4_9_16
global_rubble_wave_4)

(script static boolean aiobjective_holdout_rubble_cov_2_wave_3_9_25
global_rubble_wave_3)

(script static boolean aiobjective_holdout_rubble_cov_2_wave_2_9_34
global_rubble_wave_2)

(script static boolean aiobjective_holdout_rubble_cov_2_player_has_arrived_9_44
(volume_test_players rubble_arrival))

(script static boolean aiobjective_holdout_cliffside_cov_main_2_retreat_11_1
(< (ai_living_count enc_holdout_cliffside_cov) 7))

(script static boolean aiobjective_holdout_cliffside_cov_main_2_cheat_right_11_4
(volume_test_players cliff_right_side))

(script static boolean aiobjective_holdout_cliffside_cov_main_2_cheat_left_11_8
(volume_test_players cliff_left_side))

(script static boolean aiobjective_holdout_hilltop_cov_encounter_start_13_0
global_river_start)

(script static boolean aiobjective_holdout_hilltop_cov_final_covenant_13_2
(and global_river_wave_2 (<= (ai_living_count sq_gr_river_wave) 5)))

(script static boolean aiobjective_holdout_hilltop_cov_marines_exterminated_13_4
(< (ai_living_count sq_gr_river_marine) 1))

(script static boolean aiobjective_holdout_hilltop_cov_wait_for_player_to_enter_13_6
(volume_test_players river_all))

(script static boolean aiobjective_holdout_hilltop_cov_wait_until_marines_are_revealed_13_7
(not (or (volume_test_object river_retreat wave_1_jackal) (any_players_in_vehicle) (< (ai_living_count sq_gr_river_wave1) 12))))

(script static boolean aiobjective_holdout_hilltop_cov_wave_2_13_16
global_river_wave_2)

(script static boolean aiobjective_holdout_cliffside_marine_evace_14_0
global_cliff_end)

(script static boolean aiobjective_holdout_cliffside_marine_victory_14_2
(< (ai_living_count sq_cliffside_inside_jackal) 1))

(script static boolean aiobjective_holdout_cliffside_cov_under_2_retreat_15_1
(< (ai_living_count enc_holdout_cliffside_cov) 6))

(script static boolean aiobjective_holdout_cliffside_cov_under_2_battle_15_3
(or (volume_test_players cliff_left_fort_first_floor) (volume_test_players cliff_right_fort_first_floor)))

(script static boolean aiobjective_holdout_cliffside_cov_under_2_combat_15_5
(or (volume_test_players cliff_right_fort_second_floor2) (volume_test_players cliff_left_fort_second_floor2)))

(script static boolean aiobjective_holdout_hilltop_marine_exfil_17_3
global_river_end)

(script static boolean aiobjective_holdout_hilltop_marine_encounter_start_17_5
global_river_start)

(script static boolean aiobjective_holdout_hilltop_marine_wait_for_rescue_17_6
(not (or (volume_test_object river_retreat wave_1_jackal)(player_in_vehicle jeep)(< (ai_living_count sq_gr_river_wave1) 14))))

(script static boolean aiobjective_holdout_hilltop_marine_enemies_approaching_17_7
(volume_test_object river_attack wave_1_jackal))

(script static boolean aiobjective_holdout_hilltop_marine_retreat_17_12
(< (ai_living_count sq_gr_river_marine) 3))

(script static boolean aiobjective_holdout_hilltop_marine_if_player_in_hilltop_17_14
(volume_test_players river_all))

(script static boolean aiobjective_holdout_hilltop_marine_mop_them_up_17_15
(and global_river_wave_2 (<= (ai_living_count sq_gr_river_wave) 5)))

(script static boolean aiobjective_holdout_hilltop_marine_help_the_chief_17_17
(or (player_in_vehicle jeep)(< (ai_living_count sq_gr_river_wave1) 14)))

(script static boolean aiobjective_bridge_plank_plank_top_19_1
(volume_test_players tv_plank_top))

(script static boolean aiobjective_bridge_plank_corner_19_2
(volume_test_players tv_plank_ramp))

(script static boolean aiobjective_bridge_plank_intial_corner_19_4
(volume_test_players tv_plank_ramp))

(script static boolean aiobjective_holdout_cliffside_cov_left_2_retreat_21_1
(< (ai_living_count enc_holdout_cliffside_cov) 7))

(script static boolean aiobjective_holdout_cliffside_cov_left_2_cheat_right_21_4
(volume_test_players cliff_right_side))

(script static boolean aiobjective_mid_banshee_rubble_entrance_22_0
(volume_test_players tv_air_rubble))

(script static boolean aiobjective_mid_banshee_cliff_entrance_22_1
(volume_test_players tv_air_cliff))

(script static boolean aiobjective_mid_banshee_cliff_river_entrance_22_2
(volume_test_players tv_air_cliff_river))

(script static boolean aiobjective_mid_banshee_mid_elysian_22_3
(volume_test_players tv_air_mid_elysian))

