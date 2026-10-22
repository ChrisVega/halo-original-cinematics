(script static boolean aiobjective_shaft_a_exit_interior_free_1_1
(volume_test_players shafta_platform))

(script static boolean aiobjective_shaft_a_exit_exterior_free_1_4
(< (ai_living_count interior_stealth_elite) 2))

(script static boolean aiobjective_valley_canyon_reinforce_fight_2_2
(or (< (ai_living_count canyon_elite) 1) (< (ai_living_count canyon_grunt) 3)) )

(script static boolean aiobjective_beach_lz_push_to_drop3_12_4
(<= (ai_living_count sq_gr_beach_arch) 0))

(script static boolean aiobjective_beach_lz_push_to_drop2_12_5
(<= (ai_living_count sq_gr_beach_arch) 0))

(script static boolean aiobjective_beach_lz_push_to_drop_12_6
(<= (ai_living_count sq_gr_beach_arch) 0))

(script static boolean aiobjective_lid_backup_default_17_0
(= b_backup_lid false))

(script static boolean aiobjective_beach_assault_marines_marines_clear_arch_20_0
(or (volume_test_players tv_enc1_1_arch_back) (and (< (ai_living_count sq_gr_beach_arch) 3)(< (ai_living_count sq_gr_base) 1))))

(script static boolean aiobjective_beach_assault_marines_marines_take_arch_20_1
(or (volume_test_players tv_enc1_1_arch) (and (>= (ai_living_count sq_gr_beach_arch) 3)(< (ai_living_count sq_gr_base) 1))))

(script static boolean aiobjective_beach_assault_marines_marines_attack_arch_20_2
(or (volume_test_players tv_enc1_1_arch_ambush) (volume_test_object tv_enc1_1_arch_ambush sq_gr_beach_lz)))

(script static boolean aiobjective_beach_assault_marines_marines_take_base_20_3
(or (volume_test_players tv_enc1_1_base) (= (ai_living_count sq_gr_base) 1)))

(script static boolean aiobjective_beach_assault_marines_left_marines_attack_base_20_5
(or (volume_test_players tv_enc1_1_base) (and (> (ai_living_count sq_gr_base) 1) (< (ai_living_count sq_gr_camp) 1))))

(script static boolean aiobjective_beach_assault_marines_shared_left_marines_take_camp_20_6
(or (volume_test_players tv_enc1_1_camp) (= (ai_living_count sq_gr_camp) 1)))

(script static boolean aiobjective_beach_assault_marines_right_marines_attack_base_20_9
(or (volume_test_players tv_enc1_1_base) (and (> (ai_living_count sq_gr_base) 1) (< (ai_living_count sq_gr_camp) 1))))

(script static boolean aiobjective_beach_assault_marines_shared_right_marines_take_camp_20_10
(or (volume_test_players tv_enc1_1_camp) (= (ai_living_count sq_gr_camp) 1)))

(script static boolean aiobjective_beach_assault_cov_ambush_at_arch_23_1
(or (volume_test_players tv_enc1_1_arch_back) (and (<= (ai_living_count sq_gr_beach_arch) 1)(<= (ai_living_count sq_gr_base) 1))))

(script static boolean aiobjective_beach_assault_cov_retreat_at_arch_23_5
(or (volume_test_players tv_enc1_1_arch_ambush)(volume_test_object tv_enc1_1_arch_ambush sq_gr_left_marine_beach_lz) (volume_test_object tv_enc1_1_arch_ambush sq_gr_right_marine_beach_lz)))

(script static boolean aiobjective_beach_assault_cov_retreat_to_arch_23_9
(or (volume_test_players tv_enc1_1_arch_ambush)(volume_test_object tv_enc1_1_arch_ambush sq_gr_left_marine_beach_lz) (volume_test_object tv_enc1_1_arch_ambush sq_gr_right_marine_beach_lz)))

(script static boolean aiobjective_beach_assault_cov_retreat_to_base_23_10
(or (volume_test_players tv_enc1_1_camp) (<= (ai_living_count sq_gr_camp) 1)))

(script static boolean aiobjective_beach_assault_cov_retreat_to_arch_23_14
(or (volume_test_players tv_enc1_1_arch_ambush)(volume_test_object tv_enc1_1_arch_ambush sq_gr_left_marine_beach_lz) (volume_test_object tv_enc1_1_arch_ambush sq_gr_right_marine_beach_lz)))

(script static boolean aiobjective_beach_assault_cov_retreat_to_base_23_15
(or (volume_test_players tv_enc1_1_camp) (<= (ai_living_count sq_gr_camp) 1)))

(script static boolean aiobjective_beach_arch_ambush_30_1
(= b_arch_ambush true))

(script static boolean aiobjective_locker_elite_fight_pursue_38_0
(volume_test_players shafta_enable_locker_elite))

