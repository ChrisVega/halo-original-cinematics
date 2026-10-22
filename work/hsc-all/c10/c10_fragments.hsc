(script static boolean aiobjective_swamp_b_flood_swarm_lz_magic_9_1
b_wave_flyby)

(script static boolean aiobjective_bay_b_covenant_gotocentertodie_16_0
(volume_test_players bay_b_trigger))

(script static boolean aiobjective_bay_a1_jackalreinforce_17_0
(or (volume_test_players bay_a_bottom_trigger) (<= (ai_living_fraction sq_gr_bay_a_bottom) 0.75)) )

(script static boolean aiobjective_bay_a1_gruntfireatplayerbycrates_17_1
(volume_test_players bay_a_entrance_trigger))

(script static boolean aiobjective_swamp_b_marines_coop_4p_follow_player3_after_exit_21_3
(and (coop_players_4) (volume_test_object tv_swamp_b_marine_initial player3)))

(script static boolean aiobjective_swamp_b_marines_coop_3p_follow_player2_after_exit_21_5
(and (coop_players_3) (volume_test_object tv_swamp_b_marine_initial player2)))

(script static boolean aiobjective_swamp_b_marines_coop_2p_follow_player1_after_exit_21_7
(and (coop_players_2) (volume_test_object tv_swamp_b_marine_initial player1)))

(script static boolean aiobjective_swamp_b_marines_coop_2p_follow_player1_after_exit_21_9
(and (coop_players_2) (volume_test_object tv_swamp_b_marine_initial player1)))

(script static boolean aiobjective_swamp_b_marines_follow_player0_after_exit_21_11
(volume_test_object tv_swamp_b_marine_initial player0))

(script static boolean aiobjective_bay_a_revisited_eatspartansfollowafterfalseelevator_23_5
(and (= (ai_living_count sq_gr_bay_a_covenant) 0) (volume_test_players tv_bay_a_spartan_eater_follow) ( = (device_group_get lift_a_falling_position) 1)))

(script static boolean aiobjective_bay_a_revisited_theneatspartans_23_6
(= (ai_living_count sq_gr_bay_a_covenant) 0))

(script static boolean aiobjective_bay_a_revisited_eatcoviesfirst_23_7
(and (volume_test_players tv_bay_a_revisted) (= b_flood_revealed true)))

(script static boolean aiobjective_bay_a_revisited_eatspartansfollowafterfalseelevator_23_10
(and (volume_test_players tv_bay_a_spartan_eater_follow) ( = (device_group_get lift_a_falling_position) 1)))

(script static boolean aiobjective_bay_a_revisited_eatspartans_23_11
(and (volume_test_players tv_bay_a_revisted) (= b_flood_revealed true)))

(script static boolean aiobjective_bay_b_flood_realfight_24_0
(volume_test_players bay_b_trigger))

(script static boolean aiobjective_swamp_a_enc2_defend_25_1
(volume_test_players enc_swamp_a_trigger_02))

(script static boolean aiobjective_swamp_a_enc2_fightafterflee_25_4
(volume_test_players enc_swamp_a_trigger_02))

