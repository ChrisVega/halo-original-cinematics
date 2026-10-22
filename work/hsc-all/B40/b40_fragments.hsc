(script static boolean aiobjective_arenad_grunts_enter_4_2
(or (volume_test_players b3_top_reins_trigger)(>= 0.5 (ai_living_fraction gr_arena_d_s1))))

(script static boolean aiobjective_arenad_jackals_enter_4_4
(volume_test_players b3_top_reins_trigger))

(script static boolean aiobjective_arenad_elite_enter_4_6
(or (>= 0.5 (ai_living_fraction sq_arena_d_s2_elite))(>= 0.5 (ai_living_fraction sq_arena_d_s2_elite_com))))

(script static boolean aiobjective_ext_a_area_b_mar_joinplayerfireteambyscript_6_0
(or (f_player_is_driving_tank) (volume_test_players np_trigger_8b_snowfield_b_tank_decision)))

(script static boolean aiobjective_ext_a_area_b_mar_followplayerinsnowfieldbforcombat_6_1
(volume_test_players tv_snwfld_b_tank_push))

(script static boolean aiobjective_ext_a_area_b_mar_pushtoscorp_6_3
(volume_test_players tv_vo_snowfield_b_reunion))

(script static boolean aiobjective_ext_a_area_b_mar_startatscorp_6_6
(volume_test_players tv_vo_snowfield_b_reunion))

(script static boolean aiobjective_ext_b_postchasm_mar_follow_player_9_0
(volume_test_players tv_postchasm_marines_follow))

(script static boolean aiobjective_snowfielda_wraithfightsight_10_2
(and b_wraith_can_break_off (<= (object_get_health ext_a_dropship_wraith_a) 0.75)))

(script static boolean aiobjective_snowfielda_wraithfightpush_10_3
(and b_wraith_can_break_off (f_snwfld_a_wraith_should_stop_shelling)))

(script static boolean aiobjective_snowfielda_anyvehiclefight_10_7
b_snwfld_a_cov_playfight)

(script static boolean aiobjective_snowfielda_infantryfightfollow_10_9
(= (ai_living_count ext_a_area_a_cov_wp) 0))

(script static boolean aiobjective_snowfielda_infantryfight_10_10
b_snwfld_a_cov_playfight)

(script static boolean aiobjective_ext_b_area_b_cov_turreta_magicsight_13_2
(or (volume_test_players tv_player_on_upper_spiral_ledge)(volume_test_players tv_spiral_player_on_ice_lake)))

(script static boolean aiobjective_ext_b_area_b_cov_turretb_magicsight_13_5
(or (volume_test_players tv_player_on_upper_spiral_ledge) (volume_test_players tv_spiral_player_on_ice_lake)))

(script static boolean aiobjective_ext_b_area_b_cov_turret_b_long_13_6
(= (ai_living_count ext_b_area_b_cov_tgc) 0))

(script static boolean aiobjective_ext_b_area_b_cov_turretc_magicsight_13_9
(or (volume_test_players tv_player_on_upper_spiral_ledge) (volume_test_players tv_player_past_bunker_trees)))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_top_pursue_low_13_12
(volume_test_players tv_spiral_player_on_ice_lake))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_top_pursue_high_13_13
(volume_test_players tv_spiral_player_on_spiral_arch))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_arch_top_pursue_13_16
(volume_test_players tv_spiral_player_on_spiral_arch))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_arch_top_guard_approach_13_17
(volume_test_players tv_spiral_player_on_spiral_top))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_dropship_pursue_13_20
(volume_test_players tv_spiral_player_on_ice_lake))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_dropship_pressureatbottomofsprial_13_21
(volume_test_players tv_spiral_player_on_spiral_arch))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_hunters_berserk_13_24
(= (ai_living_count ext_b_area_b_cov_spiral_hunters) 1))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_hunters_goalie_13_26
(or (volume_test_players tv_spiral_player_on_ice_lake) (= (ai_living_count ext_b_marines) 0)))

(script static boolean aiobjective_ext_b_area_b_cov_spiral_hunters_realfight_13_27
(volume_test_players tv_spiral_player_can_see_marines))

(script static boolean aiobjective_bridge_a_wraithplayerskip_16_2
b_player_skipping_bridge_a)

(script static boolean aiobjective_bridge_a_wraithshell_16_3
b_pelican_pre_unload)

(script static boolean aiobjective_bridge_a_bansheepeeloff_16_8
b_bridge_a_banshee_peel_off)

(script static boolean aiobjective_bridge_a_bansheecombat_magiclong_16_9
b_bridge_a_banshee_combat)

(script static boolean aiobjective_bridge_a_shade_pelicanlongvision_16_12
b_bridge_pelican_in_range)

(script static boolean aiobjective_ext_a_area_c_cov_cliffwraith_cliffwraithmagic_18_0
b_cliffwraithdonewaiting)

(script static boolean aiobjective_ext_a_area_c_cov_cliffwraith_cliffwraithwaiting_18_1
(or b_cortanahascalledouttunnela (volume_test_players tv_snowfield_c_wraith_aggro)))

(script static boolean aiobjective_zig_cov_bottom_pursueupstructureifplayerpasses_20_1
(volume_test_players tv_zig_trigger_player_past_1st_switchback))

(script static boolean aiobjective_zig_cov_bottom_fallbacktoleftafteronedies_20_2
(< (ai_living_fraction sq_gr_zig_cov_bottom_hunters) 1))

(script static boolean aiobjective_tarmac_tower_corridor_a_approach_23_3
(volume_test_players tv_tower_entrance_a) )

(script static boolean aiobjective_tarmac_tower_corridor_b_approach_23_6
(volume_test_players tv_tower_entrance_b) )

(script static boolean aiobjective_ext_b_marines_putsquadinplayerfireteam_24_0
(and (volume_test_players ext_b_marines_trigger_fireteam) (= (ai_living_count ext_b_area_b_cov_spiral_hunters) 0)))

(script static boolean aiobjective_ext_b_marines_followplayerinicelake_24_1
(or (volume_test_players ext_b_marines_trigger) (volume_test_players ext_b_marines_trigger_fireteam)))

(script static boolean aiobjective_ext_b_marines_runto_small_area_24_2
(volume_test_players tv_spiral_player_can_see_marines))

(script static boolean aiobjective_outsidecontroltunnel_tunnel_open_25_0
(= (device_get_position large_door_ziggurat_1) 1))

(script static boolean obj_stunnel_g_lift_defence_26_1
(>= (ai_combat_status sq_stunnel_g_jackals_front) "visible"))

(script static boolean obj_stunnel_g_door_defence_26_3
(>= (ai_combat_status sq_stunnel_g_jackals_back) "visible"))

(script static boolean aiobjective_c_bridge_banshee_elites_banshee_27_0
(any_players_in_vehicle_type s_vehicle_type_banshee))

(script static boolean aiobjective_ext_a_area_c_cov_fullfieldmagic_28_2
(or b_cortanahascalledouttunnela (volume_test_players tv_snowfield_c_wraith_aggro)))

(script static boolean aiobjective_ext_a_area_c_cov_shades_long_vision_28_5
(volume_test_players tv_snowfield_c_shade_aggro))

(script static boolean aiobjective_ext_a_area_c_cov_any_vehicle_wraith_aggro_28_7
(or b_cortanahascalledouttunnela (volume_test_players tv_snowfield_c_wraith_aggro)))

(script static boolean aiobjective_ext_a_area_c_cov_infantryfallbackwhentankcombatstarts_28_10
(and (f_player_is_driving_tank) (or b_cortanahascalledouttunnela (volume_test_players tv_snowfield_c_wraith_aggro))))

(script static boolean aiobjective_ext_a_area_c_cov_infantryfallbackwhentanksighted_28_11
(f_player_is_driving_tank))

(script static boolean aiobjective_ext_a_area_b_cov_tanksquads_eliterunforghost_limit_1_29_1
(and (or (f_player_is_driving_tank) (volume_test_players np_trigger_8b_snowfield_b_tank_decision)) (> (object_get_health ext_a_area_b_ghost_c) 0)))

(script static boolean aiobjective_ext_a_area_b_cov_leftcov_fallbackontankboard_fullcombat_29_4
(f_player_is_driving_tank))

(script static boolean aiobjective_ext_a_area_b_cov_leftcov_fight_nonadevehicle_29_5
(volume_test_players tv_vo_snowfield_b_reunion))

(script static boolean aiobjective_ext_a_area_b_cov_rightcov_fight_nonadevehicle_29_7
(volume_test_players tv_vo_snowfield_b_reunion))

(script static boolean aiobjective_ext_a_area_b_cov_goalie_pushtomeetplayer_29_9
(or (f_player_is_driving_tank) (volume_test_players np_trigger_8b_snowfield_b_tank_decision)))

(script static boolean aiobjective_ext_a_area_b_cov_icetunnel_joinsnowfieldc_29_12
(or (volume_test_players tv_snowfield_c_wraith_aggro) (volume_test_players tv_snowfield_c_shade_aggro)))

(script static boolean aiobjective_ext_a_area_b_cov_icetunnel_push_29_14
(volume_test_players ext_a_area_c_trigger_b))

(script static boolean aiobjective_ext_a_area_c_cov_hunters_pushout_vehicle_32_0
(<= (+   (ai_living_count ext_a_area_c_cov_wraiths) (ai_living_count ext_a_area_c_cov_field_ghosts) (ai_living_count ext_a_area_c_cov_shades) (ai_living_count ext_a_area_c_cov_banshee)          ) 1))

(script static boolean aiobjective_ext_a_area_c_cov_hunters_pushout_32_1
(<= (+   (ai_living_count ext_a_area_c_cov_wraiths) (ai_living_count ext_a_area_c_cov_field_ghosts) (ai_living_count ext_a_area_c_cov_shades) (ai_living_count ext_a_area_c_cov_banshee)          ) 1))

(script static boolean aiobjective_ext_a_area_a_mar_addtofireteamaftervolumeandnopindown_33_0
(and (volume_test_players marines_objective_trigger_0) (f_zulu_marines_no_longer_pinned_down) (= (ai_living_count ext_a_area_a_cov_wp_bridge) 0)))

(script static boolean aiobjective_ext_a_area_a_mar_addtofireteamifplayerdriveswarthog_33_1
(f_player_is_driving_warthog))

(script static boolean aiobjective_ext_a_area_a_mar_takeshelterfromwraithafternopindown_33_2
(f_zulu_marines_no_longer_pinned_down))

(script static boolean aiobjective_ext_a_area_a_mar_moveleftafterghostdownandspartanhelping_33_3
(and (= (ai_living_count ext_a_area_a_cov_gpa) 0) (volume_test_players marines_objective_trigger_0_b)))

(script static boolean aiobjective_ext_a_area_a_mar_allowleftafterghostpressure_33_4
(and (= (ai_living_count ext_a_area_a_cov_gpa) 0) (= (ai_living_count ext_a_area_a_cov_vista) 0)))

(script static boolean aiobjective_ext_b_area_c_cave_waitbydoorforevac_38_1
b_cortanahastoldbisentitowait)

(script static boolean aiobjective_ext_b_area_c_cave_emergefromcaveaftergunclear_38_2
b_bunker_marines_can_advance)

(script static boolean aiobjective_ext_b_area_c_cave_supportchiefintherocks_38_3
(and b_marines_halted (volume_test_players tv_marine_pickett_trigger)))

(script static boolean aiobjective_ext_b_area_c_cave_holdpositionbelowridge_38_4
b_marines_halted)

(script static boolean aiobjective_ext_b_area_c_cave_pursueplayerintosnowfield_38_9
(or (volume_test_players tv_player_past_bunker_trees) (volume_test_players tv_spiral_cave_player_over_top)))

(script static boolean aiobjective_ext_b_area_c_cave_reinforceslopeaftercaveclear_38_11
(<= (ai_living_fraction gr_ext_b_area_b_cave_mouth) .5))

(script static boolean aiobjective_ext_b_area_c_cave_fleetoslopeafterelitedeath_38_14
(ai_living_count ext_b_area_b_cov_si))

(script static boolean aiobjective_ext_b_area_c_cave_supporteliteafterroarorplayerpush_38_15
(or b_cave_has_roared (volume_test_players tv_spiral_cave_spec_ops_runpast)))

(script static boolean aiobjective_ext_b_area_c_cave_entercavetosurpriseplayer_38_19
(volume_test_players tv_spiral_cave_spec_ops))

(script static boolean aiobjective_ext_b_area_a_tarmac_avengethewraith_magic_39_4
(= (ai_living_count sq_wraith_gunner_34) 0))

(script static boolean aiobjective_ext_b_area_a_tarmac_avengethewraith_long_39_5
(= (ai_living_count sq_wraith_gunner_34) 0))

(script static boolean aiobjective_ext_b_area_a_tarmac_wraithlongsightonpushorcombat_39_8
(or (volume_test_players tv_tower_entrance_a)(volume_test_players tv_tower_entrance_b) (and (<= (ai_living_count gr_ext_b_area_a_drop) 3) (<= (ai_living_count gr_ini_ext_b_second_shades) 1))))

(script static boolean aiobjective_ext_b_area_a_tarmac_dontshootmeintheback_leftturret_39_12
(and (not (objects_can_see_object (players) ext_b_a_turret_a 60)) (volume_test_players tv_tower_dont_shoot_in_back)))

(script static boolean aiobjective_ext_b_area_a_tarmac_dontshootmeintheback_rightturret_39_14
(and (not (objects_can_see_object (players) ext_b_a_turret_b 60)) (volume_test_players tv_tower_dont_shoot_in_back)))

(script static boolean aiobjective_ext_b_area_a_tarmac_shade_longvision_39_15
(or (volume_test_players tv_tower_shade_aggro) (<= (ai_living_count gr_ext_b_area_a_drop) 3)))

(script static boolean aiobjective_ext_b_area_a_tarmac_fallbacktowraith_39_18
(or (volume_test_players tv_tarmac_fallback) (= (ai_living_count sq_wraith_gunner_34) 0)))

(script static boolean aiobjective_controltunnel_fallbackaftergeneraliskilledorrunpass_41_1
(or (= (ai_living_fraction elite_commander_control) 0) (and (volume_test_players tv_control_hallway_runpast) (> (ai_living_fraction elite_commander_control) 0))))

(script static boolean aiobjective_controltunnel_supportgeneralandgruntsfrombehind_41_2
(> (device_get_position large_door_ziggurat_1) 0))

(script static boolean aiobjective_controltunnel_pursuerunpass_41_5
(volume_test_players tv_control_hallway_runpast))

(script static boolean aiobjective_controltunnel_rushplayerifontopplatformandgruntsaredying_41_6
(and (volume_test_players tv_zig_trigger_player_on_top) (<= (ai_living_fraction sq_gr_control_cov_grunts) .5)))

(script static boolean aiobjective_controltunnel_defendentrancetocontroltunnel_spotted_41_7
(= (device_get_position large_door_ziggurat_1) 1))

(script static boolean aiobjective_controltunnel_defendentrancetocontroltunnel_41_8
(= (device_get_position large_door_ziggurat_1) 1))

(script static boolean aiobjective_controltunnel_defendentrancetocontroltunnelblinddeafuntildoor_41_9
(> (device_get_position large_door_ziggurat_1) 0))

(script static boolean aiobjective_controltunnel_pursuerunpass_41_12
(volume_test_players tv_control_hallway_runpast))

(script static boolean aiobjective_controltunnel_fallbacktotunnelaftergeneraliskilled_41_13
(= (ai_living_fraction elite_commander_control) 0))

(script static boolean aiobjective_controltunnel_pushoutofcontroltunnel_41_14
(= (device_get_position large_door_ziggurat_1) 1))

(script static boolean aiobjective_controltunnel_defendentrancetocontroltunnel_41_15
(> (device_get_position large_door_ziggurat_1) 0))

(script static boolean aiobjective_controltunnel_pushforturrets_41_18
(= (device_get_position large_door_ziggurat_1) 1))

(script static boolean aiobjective_controltunnel_defendentrancetocontroltunnel_41_19
(> (device_get_position large_door_ziggurat_1) 0))

(script static boolean aiobjective_insertion_cov_grunt_fight_43_1
b_intro_elite_spotted_player)

(script static boolean aiobjective_insertion_cov_grunt_fight_43_4
b_intro_elite_spotted_player)

(script static boolean aiobjective_insertion_cov_grunt_flee_43_5
b_intro_cinematic_has_finished)

(script static boolean aiobjective_insertion_cov_elite_outdoors_magic_43_9
(volume_test_object tv_elite_exited_door insertion_cov_elites))

(script static boolean aiobjective_arenaa_ledge_engage_45_1
(volume_test_players tv_a1_middle_trigger))

(script static boolean aiobjective_arenaa_reinforce_45_11
(volume_test_players tv_a1_middle_trigger))

(script static boolean aiobjective_c_bridge_top_fight_48_7
b_top_guards_move_in)

(script static boolean aiobjective_ext_b_area_c_banshee_attacktime_49_0
(>= (ai_combat_status gr_ext_b_area_c_cov_banshee) alert))

(script static boolean aiobjective_ext_b_area_c_banshee_attacklowermagiconceincombat_49_1
(or (<= (ai_living_count gr_ext_b_area_c_cov_ghosts) 1) (volume_test_players tv_player_advanced_into_bunker)))

(script static boolean aiobjective_ext_b_area_c_banshee_stayhighpatrolunlessplayeradvancesorthesquadtakesdamage_49_3
b_marines_halted)

(script static boolean aiobjective_ext_b_area_c_banshee_attacklowerifsightedandatleastoneghostisdead_49_4
(<= (ai_living_count gr_ext_b_area_c_cov_ghosts) 2))

(script static boolean aiobjective_ext_b_area_c_banshee_patrollownearbunker_49_5
(volume_test_players tv_bunker_banshee_low_patrol))

(script static boolean aiobjective_ext_b_area_c_bunker_fightonsight_53_2
(<= (ai_living_count gr_ext_b_area_c_cov_ghosts) 1))

(script static boolean aiobjective_ext_b_area_c_bunker_findplayerifghostsdieorplayeradvances_53_3
(or (<= (ai_living_count gr_ext_b_area_c_cov_ghosts) 1) (volume_test_players ext_b_c_trigger_d)))

(script static boolean aiobjective_ext_b_area_c_bunker_fightinfrontlineifplayeradvancesorturretandghostdies_53_6
(or (volume_test_players tv_player_advanced_into_bunker) (   and (<= (ai_living_count gr_ext_b_area_b_rocks_turret) 0) (<= (ai_living_count gr_ext_b_area_c_cov_ghosts) 2)   )     ))

(script static boolean aiobjective_ext_b_area_c_bunker_fightinfrontlineifrocksguardsorghostsdieorplayeradvances_53_9
(or (<= (ai_living_count ext_b_area_c_cov_gb) 1) (<= (ai_living_count gr_ext_b_area_c_cov_ghosts) 2) (volume_test_players tv_player_pressuring_rocks)))

(script static boolean aiobjective_ext_b_area_c_bunker_sightonadvanceorvehicledeath_53_15
(or (<= (ai_living_count gr_ext_b_area_b_rocks_turret) 0) (<= (ai_living_count gr_ext_b_area_c_cov_door) 1) (<= (ai_living_count gr_ext_b_area_c_cov_ghosts) 1)(<= (ai_living_count gr_ext_b_area_c_cov_banshee) 0)(volume_test_players tv_door_guard_turret)))

(script static boolean aiobjective_ext_b_area_c_bunker_expandfightafterreinforcementsarekilled_53_21
(<= (ai_living_count gr_ext_b_area_b_cave_reinf) 1))

(script static boolean aiobjective_ext_b_area_c_bunker_stopfollowingandguardentranceinstead_53_24
(volume_test_players ext_b_c_trigger_d))

