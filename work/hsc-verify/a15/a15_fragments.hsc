(script static boolean obj_bridge_cower_crewmen_init_0_0
(not (volume_test_objects tv_bridge_kill_check (ai_actors sq_bridge_kill))))

(script static boolean obj_airlock_1_marine_boarded_3_0
(> (ai_living_count gr_airlock_1_anti_boarding) 0))

(script static boolean obj_airlock_1_marine_airlock_3_1
(volume_test_objects tv_airlock_1_push_a (ai_actors gr_airlock_1_anti)))

(script static boolean obj_airlock_1_marine_a_playfight_3_2
(not (volume_test_players tv_airlock_1_push_a)))

(script static boolean obj_airlock_1_marine_push_3_4
(volume_test_objects tv_airlock_1_push_b (ai_actors gr_airlock_1_anti)))

(script static boolean obj_airlock_1_marine_push_playfight_3_5
(not (volume_test_players tv_airlock_1_trigger_4)))

(script static boolean obj_airlock_1_marine_final_playfight_3_7
(not (volume_test_players tv_airlock_1_trigger_5)))

(script static boolean obj_airlock_1_marine_investigate_3_9
b_explosion_reacted)

(script static boolean obj_lifepod_1_anti_fall_back_7_0
(< (ai_living_count sq_lifepod_1_anti_rg) 3))

(script static boolean obj_flank_fall_back_8_1
(<= (ai_living_count gr_flank_anti) 4))

(script static boolean obj_stairs_elevator_12_0
(= (ai_living_count gr_stairs_anti) 0))

(script static boolean obj_stairs_last_marine_12_1
(and (<= (ai_living_count gr_stairs_anti) 2) (= (ai_living_count sq_stairs_anti_lg) 0)))

(script static boolean obj_stairs_upper_marine_12_2
(or (volume_test_players tv_stairs_trigger_2) (<= (ai_living_count gr_stairs_anti_init) 3)))

(script static boolean obj_lifepod_2_push_forward_14_1
(< (ai_living_count sq_lifepod_2_anti)3))

(script static boolean obj_lifepod_2_fall_back_14_4
(< (ai_living_count sq_lifepod_2_anti)3))

(script static boolean obj_airlock_2_reinforcements_19_0
(> (ai_living_count gr_airlock_2_anti)6))

(script static boolean obj_airlock_2_forward_19_1
(> (ai_living_count gr_airlock_2_anti)6))

(script static boolean obj_stairs_anti_attack_lower_20_4
(> (device_get_position dm_stairs_door_1) 0.8))

(script static boolean obj_stairs_anti_attack_upper_20_7
(> (device_get_position dm_stairs_door_2) 0.8))

(script static boolean obj_airlock_1_cov_boarded_22_0
(> (ai_living_count gr_airlock_1_anti_boarding) 0))

(script static boolean obj_airlock_1_cov_last_stand_22_1
(< (ai_strength gr_airlock_1_anti_boarding) 0.25))

(script static boolean obj_airlock_1_cov_ls_playfight_22_2
(not (volume_test_players tv_airlock_1_trigger_5)))

(script static boolean obj_airlock_1_cov_fall_back_22_4
(< (ai_strength gr_airlock_1_anti_boarding) 0.5))

(script static boolean obj_airlock_1_cov_fb_playfight_22_5
(not (volume_test_players tv_airlock_1_trigger_4)))

(script static boolean obj_airlock_1_cov_airlock_playfight_22_8
(not (volume_test_players tv_airlock_1_push_a)))

(script static boolean obj_crawl_found_23_0
(>= (ai_combat_status sq_crawl_anti) alert))

(script static boolean obj_containment_3_last_push_24_1
(< (ai_living_count gr_containment_3_anti)10))

(script static boolean obj_containment_3_second_push_24_2
(< (ai_living_count gr_containment_3_anti)12))

(script static boolean obj_containment_3_first_push_24_3
(< (ai_living_count gr_containment_3_anti)16))

(script static boolean obj_containment_3_start_24_4
(or (volume_test_players tv_final_trigger_1) (volume_test_players tv_final_trigger_2)))

(script static boolean obj_containment_3_area_2_open_24_7
(> (ai_living_count gr_containment_3_anti)14))

(script static boolean obj_containment_3_area_4_open_24_8
(> (ai_living_count gr_containment_3_anti)12))

(script static boolean obj_containment_3_area_6_open_24_9
(> (ai_living_count gr_containment_3_anti)5))

(script static boolean obj_cafeteria_advance_25_0
(volume_test_players tv_cafeteria_trigger_6))

(script static boolean obj_cafeteria_hold_25_1
(= (ai_living_count gr_cafeteria_anti_init)0))

