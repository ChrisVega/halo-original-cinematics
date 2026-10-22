;====================================================================================================================================================================================================
; vo ==============================================================================================================================================
;====================================================================================================================================================================================================

(global short s_vo_progress_c20 0)
(global boolean b_told_of_transit_lift 0)

; floor 1 vo ====================================================================================================================================================================================================

(script dormant vo_floor1_intro_trigger
	(sleep_until (= s_vo_progress_c20 1) 1) ; wait until monitor starts flying (player triggered or idle triggered)
	(wake vo_floor1_intro)
)

(script dormant vo_floor1_intro
	(ai_actor_dialogue_enable ai_monitor false)
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_3d_play_guilty_spark 15 ai_monitor m07_00040 "guilty spark: the index is naturally our first priority. we cannot activate the installation's fail safes without the index.")
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00370 "guilty spark: we must make our way to the transit lift on the other side of the level.")
	(ai_actor_dialogue_enable ai_monitor true)
)

(script dormant vo_floor1_centercorridor1_trigger
	(sleep_until
		(and
			(script_finished "vo_floor1_intro")
			(volume_test_players tv_vo_centercorridor1_ledge)
		)
	1)
	(wake vo_floor1_centercorridor1)
)

(script dormant vo_floor1_centercorridor1
	(branch (>= (device_get_position floor_1_door_right) 0.1) (f_md_abort))

	(ai_actor_dialogue_enable ai_monitor false)
	(sleep (game_ticks_from_seconds 1))
	(f_md_3d_play_guilty_spark 0 sq_monitor m07_009670 "guilty spark: your combat skin is not fitted with a contragravity web? curious.")
	(ai_actor_dialogue_enable ai_monitor true)
	(set b_told_of_transit_lift true) ; sets navpoint on door panel in floor_1_library_a_nav_control
)

(script dormant vo_floor1_intro_dawdle_trigger
	(sleep_until
		(and
			(script_finished "vo_floor1_intro")
			(= s_vo_progress_c20 10) ; wait until monitor reaches in front of door in cs_343_shaft_present
		)
	1)
	(if (not b_told_of_transit_lift) (set b_told_of_transit_lift true)) ; sets navpoint ond oor panel in floor_1_library_a_nav_control
	(wake vo_floor1_intro_dawdle)
)

(script dormant vo_floor1_intro_dawdle
	(branch (>= (device_get_position floor_1_door_right) 0.1) (f_md_abort))

	(sleep_until
		(begin
			(f_md_3d_play_guilty_spark 0 ai_monitor m07_009720 "guilty spark: why do you continue to ignore your task?")
			false
		)
	(game_ticks_from_seconds 30))
)

(script dormant vo_floor1_librarya_first_encounter
	(sleep_until
		(or
			(volume_test_players tv_vo_flood_library)
			(= (ai_living_count sq_f1_flood_marine3_0) 1)
		)
	1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00120 "guilty spark: puzzling… you brought such ineffective weapons to combat the flood, despite the containment protocols.")
)

(script dormant vo_floor1_librarya_breaking_door_vignette
	(sleep_until
		(and
			(= (device_get_position f1_lib_a_breakin_door_device) 1)
			(= s_vo_progress_c20 15) ; wait until monitor has gone through door in cs_343_library_a
		)
	1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_09140 "guilty spark: containment failure... system integrity at... oh, the audacity!")
)

(script dormant vo_floor1_carrier_trigger
	(sleep_until (volume_test_object tv_navend_library_a_hall_3 (ai_get_object ai_monitor)) 1)
	(wake vo_floor1_carrier)
)

(script dormant vo_floor1_carrier
	(f_md_3d_play_guilty_spark 15 ai_monitor m07_00260 "guilty spark: you can see how the body has been transformed by the genetic restructuring of the flood infection.")
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00270 "guilty spark: the small creatures carry spores that cause a host to mutate. the mutated host then produces spores that can pass the flood to others. it is insidious and elegant. as long as any hosts remain, the flood is…virulent.")
)

(script dormant vo_floor1_librarya_door
	(sleep_until (volume_test_object tv_end_library_a_door (ai_get_object ai_monitor)) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00100 "guilty spark: please follow closely. we are apporaching the first access portal.")
)

(script dormant vo_floor1_middle_door
	(sleep_until (= s_vo_progress_c20 20) 1) ; wait until monitor tries to open middle door in cs_343_middle_sec_door
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c20_sing (ai_get_object ai_monitor) 1)
	(sleep (game_ticks_from_seconds 3))
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00340 "guilty spark: curious. a failsafe has been tripped on this portal. i must attend to it.")
	(set s_vo_progress_c20 21) ; allow monitor to move aside in cs_343_middle_sec_door
	(sleep_until (= s_vo_progress_c20 22) 1) ; wait until encounter begins in middle_sec_door
	(sleep (game_ticks_from_seconds 1))
	(f_md_3d_play_guilty_spark 75 ai_monitor m07_00330 "guilty spark: oh, my apoologies.")
	(f_md_3d_play_guilty_spark 60 ai_monitor m07_009610 "guilty spark: per protocol, this area must be sterilized before we can proceed.")
)

(script dormant vo_floor1_smallroomb_trigger
	(sleep_until (= (device_get_position floor_1_middle_entrance_door) 1) 1)
	(wake vo_floor1_smallroomb)
)

(script dormant vo_floor1_smallroomb
	(sleep_until (= s_vo_progress_c20 30) 1) ; wait until monitor arrives in front of broken door in cs_343_broken_door
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00420 "guilty spark hmm. this portal is blocked. apologies. we will need to reroute. follow me.")
	(set s_vo_progress_c20 31) ; allow monitor to proceed in cs_343_broken_door
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_3d_play_guilty_spark 75 ai_monitor m07_009390 "guilty spark: where did i put that subroutine?")
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009370 "guilty spark: do not fret, reclaimer, i shall return!")
)

(script dormant vo_floor1_sentinel_intro_trigger
	(sleep_until (volume_test_players tv_act_sentinel_intro) 1)
	(wake vo_floor1_sentinel_intro)
)

(script dormant vo_floor1_sentinel_intro
	(sleep (game_ticks_from_seconds 2))
	(f_md_3d_play_guilty_spark 45 ai_monitor m07_009420 "guilty spark: oh you did survive--how delightful.")
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00130 "guilty spark: these sentinels will supplement your combat systems, but i suggest you upgrade to at least a class twelve combat skin. your current model only scans as a class two, which is ill suited for this kind of work.")
)

(script dormant vo_floor1_lift_trigger
	(sleep_until (volume_test_players tv_lift_1_start) 1)
	(wake vo_floor1_lift)
)

(script dormant vo_floor1_lift
	(f_md_3d_play_guilty_spark 60 ai_monitor m07_00380 "guilty spark: the flood's numbers continue to grow, reclaimer. full containment failure expected in fifteen cycles.")
	(sleep_until (>= (device_get_position elevator_1) 0.15) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00150 "pardon me. a plasma conduit breach in section five-five-two-four has disrupted power flow to a gravitic maintenance assembly. repairs require my attention. i will return soon.")
)

; floor 2 vo =====================================================================================================================================================================================================

(script dormant vo_floor2_intro
	(sleep_until (volume_test_players tv_act_hallway_b) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009730 "guilty spark: we can't stop here, reclaimer.")
)

(script dormant vo_floor2_hallwayb_door_trigger
	(sleep_until (= s_vo_progress_c20 39) 1) ; wait until monitor reaches in front of door in cs_343_hallway_b_door
	(wake vo_floor2_hallwayb_door)
)

(script dormant vo_floor2_hallwayb_door
	(f_md_3d_play_guilty_spark 30 ai_monitor m07_09270 "guilty spark: system integration is proceeding as expected")
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009350 "guilty spark: please be patient! my task is more delicate than you can imagine.")
	(sleep_until (= s_vo_progress_c20 40) 1) ; wait until sentinels arrive in f2_lhallwayb_sec_door_init
	(sleep (game_ticks_from_seconds 6.5))
	(f_md_3d_play_guilty_spark 240 ai_monitor m07_00140 "guilty spark: the sentinels can use their weapons to manage the flood for only a short time. speed is of the essence.")
	(sleep_until (>= (device_get_position floor_2_stacks_entrance_door) 0.5) 1) ; wait until door is open
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_09280 "guilty spark: concluding operations.")
)

(script dormant vo_floor2_reclaimer_intro
	(sleep_until (volume_test_players tv_act_343_library_c1) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009330 "guilty spark: i cannot tell you how delightful it is to have someone to talk to!")
)

(script dormant vo_floor2_reclaimer_trigger
	(sleep_until
		(and
			(volume_test_players tv_act_343_library_c2)
			(= s_vo_progress_c20 45) ; wait until monitor reaches the reclaimer
		)
	1)
	(wake vo_floor2_reclaimer)
)

(script dormant vo_floor2_reclaimer
	(f_md_3d_play_guilty_spark 15 ai_monitor m07_00310 "guilty spark: ah, the other reclaimer.")
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00320 "guilty spark: unfortunately, his combat skin proved even less suitable than yours.")
	(set s_vo_progress_c20 46)
)

(script dormant vo_floor2_libraryd
	(sleep_until (= (device_get_position floor_2_door_right) 1) 1)
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00070 "guilty spark: this installation's research facilities are, of course, most impressive. perhaps you will have time to reacquaint yourself to them soon.")
)

(script dormant vo_floor2_pureform_trigger
	(sleep_until
		(and
			(volume_test_object tv_vo_tank_intro (ai_get_object sq_f2_lib_d_r4_tank))
			(objects_can_see_object (players) (ai_get_object sq_f2_lib_d_r4_tank) 30)
		)
	1)
	(set s_music_trigger_c20 110)
	(wake vo_floor2_pureform)
)

(script dormant vo_floor2_pureform
	(f_md_3d_play_guilty_spark 15 ai_monitor m07_09180 "guilty spark: oh my... that evaluation subject should not be ambulatory! sterilization field integrity will require extensive recalibration!")
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_09190 "guilty spark: a prime example of why containment discipline is paramount!")
)

(script dormant vo_floor2_libraryd_exit
	(sleep_until (volume_test_object tv_vo_libd_exit (ai_get_object ai_monitor)) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009500 "guilty spark: you may have encountered logs and communication records from this ring's history, reclaimer. i hope their contents are edifying!")
)

(script dormant vo_floor2_centercorridorb_door
	(sleep_until (= s_vo_progress_c20 50) 1) ; wait until monitor is in front of door in cs_343_lib_d
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00210 "guilty spark: i will deactivate the security lock. wait here.")
	(sleep_until (= s_vo_progress_c20 51) 1) ; wait until monitor returns after clearing waves in cs_343_small_room_c
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c20_sing (ai_get_object ai_monitor) 1)
)

(script dormant vo_floor2_smallroomc_trigger
	(sleep_until (volume_test_players tv_vo_smallroomc) 1)
	(wake vo_floor2_smallroomc)
	(wake vo_floor2_smallroomc_idle)
	(wake vo_floor2_smallroomc_warning)
)

(script dormant vo_floor2_smallroomc
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00400 "guilty spark: as per protocol, the illuminated markers will direct your progress. follow diligently.")
	(set s_music_trigger_c20 150)
	(sleep_until (= (device_get_position light_bridge_a) 1) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009700 "guilty spark: excellent.")
	(sleep_until (volume_test_players tv_f2_largeroom_a_island2) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009440 "guilty spark: how remarkable it is to look upon such a collection of catalogued life!")
	(sleep_until (volume_test_players tv_act_343_lift2) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00390 "guilty spark: i look forward to presenting my full status report once we deal with this outbreak.")
	(sleep_forever vo_floor2_smallroomc_warning)
)

(script dormant vo_floor2_smallroomc_idle
	(branch (volume_test_players tv_act_343_lift2) (f_md_abort))
	(sleep_until
		(begin
			(f_md_3d_play_guilty_spark 0 ai_monitor m07_009690 "guilty spark: reclaimer! manually activate the bridge segments to avoid contact with the flood.")
			false
		)
	(game_ticks_from_seconds 50))

)

(script dormant vo_floor2_smallroomc_warning
	(sleep_until (volume_test_players tv_vo_smallroomc_warning) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009710 "guilty spark: oh, dear.")
)

(script dormant vo_floor2_lift
	(sleep_until (volume_test_players tv_343_lift2_leave) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00180 "guilty spark: flood activity has caused a failure in a drone control subsystem. i must reset the backup unit. please continue on. i will rejoin you when i've completed my task.")
)

; floor 3 vo =====================================================================================================================================================================================================

(script dormant vo_floor3_intro
	(sleep_until (volume_test_players tv_act_343_floor_3_intro) 1)
	(f_md_3d_play_guilty_spark 180 ai_monitor m07_009410 "guilty spark: did you miss me?")
)

(script dormant vo_floor3_hallway
	(sleep_until (volume_test_players tv_vo_f3_intro_hallway) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00300 "guilty spark: your environment suit should serve you well when the flood begins to alter the atmosphere. you are a good planner.")
)

(script dormant vo_floor3_jump_scare
	(sleep_until (>= (device_get_position floor_3_jump_scare_door) 0.15) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_09160 "guilty spark: security breach detected. multiple vectors. reclaimer, please optimize for close quarters tactical engagements.")
)

(script dormant vo_floor3_centercorridorc
	(sleep_until (= s_vo_progress_c20 68) 1) ; wait until monitor arrives in centercorridorc in cs_343_jump_door
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009470 "guilty spark: this room once held the complete record of seventy-four inhabited worlds.")
	(set s_vo_progress_c20 69) ; allow monitor to move in 343_library_e
)

(script dormant vo_floor3_door_trigger
	(sleep_until (= s_vo_progress_c20 70) 1) ; wait until monitor tries to open door in cs_343_large_room_b
	(wake vo_floor3_door)
)

(script dormant vo_floor3_door
	(f_md_3d_play_guilty_spark 30 ai_monitor m07_009680 "guilty spark: the parasite works quickly to degrade my containment options")
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009380 "guilty spark: don't worry, i won't be far.")
)

(script dormant vo_floor3_door_returns
	(sleep_until (= s_vo_progress_c20 71) 1) ; wait until monitor returns in cs_343_large_room_b
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009400 "guilty spark: see? i have returned just as i promised!")
)

(script dormant vo_floor3_largeroomb_start
	(sleep_until (volume_test_players tv_end_library_f) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009650 "guilty spark: apologies, but hardlight generators are degraded in this area.")
)

(script dormant vo_floor3_largeroomb_end_trigger
	(sleep_until (volume_test_players tv_act_343_to_lift3) 1)
	(wake vo_floor3_largeroomb_end)
)

(script dormant vo_floor3_largeroomb_end
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009600 "guilty spark: the charm of this facility is lost on the less enlightened, would you not agree?")
	(sleep_until (= s_vo_progress_c20 80) 1) ; wait until monitor is opening door in cs_343_to_lift3
	(sound_impulse_start sound\dialog\combat\guiltyspark\default\13_script\c20_sing (ai_get_object ai_monitor) 1)
)


(script dormant vo_floor3_largehallwayd
	(sleep_until (volume_test_players tv_vo_largehallwayd) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009320 "guilty spark: if this is the end, at least it will be an interesting one.")
)

(script dormant vo_floor3_outro
	(sleep_until (volume_test_players tv_act_lift3) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009580 "guilty spark: please continue your sterilization protocols. i will move ahead to ensure security safeguards are intact.")
)

; floor 4 vo =========================================================================================================================================================================================================

(script dormant vo_floor4_intro
	(sleep_until (or (< s_split_dir 0) (> s_split_dir 0)) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00170 "guilty spark: we must continue. this way, please.")
)

(script dormant vo_floor4_hallway3_door
	(sleep_until (= s_vo_progress_c20 90) 1) ; wait until monitor reaches in front of door in cs_343_hallway_e_door
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_009590 "guilty spark: local sentinels are out of compliance and require my attention. i will rejoin you soon.")
)

(script dormant vo_floor4_index
	(sleep_until b_opening_final_door 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00220 "guilty spark: the energy barrier surrounding the index will deactivate when you approach.")
	(sleep_until (>= (device_get_position floor_4_door_last_room) 0.5) 1)
	(f_md_3d_play_guilty_spark 0 ai_monitor m07_00230 "guilty spark: you may now retrieve the index.")
)


;====================================================================================================================================================================================================
; music ==============================================================================================================================================
;====================================================================================================================================================================================================

(global short s_music_trigger_c20 0)

(script dormant c20_music_controller
	(print "c20_music_controller started")

	; mus_01 set in startup script with cinematic
	(sleep_until (> s_music_trigger_c20 0) 1)
	(if (= s_music_trigger_c20 10) (begin (music_event sound/music/c20/mus_01_opening_cinematic_start) (print "mus_01_opening_cinematic_start")))

	; mus_02 set in 343_start_to_shaft with chapter title
	(sleep_until (> s_music_trigger_c20 10) 1)
	(if (= s_music_trigger_c20 20) (begin (music_event sound/music/c20/mus_02_small_room_a_start) (print "mus_02_small_room_a_start")))

	; mus_03 set in library_a_door with door vignette
	(sleep_until (> s_music_trigger_c20 20) 1)
	(if (= s_music_trigger_c20 30) (begin (music_event sound/music/c20/mus_03_library_a_encounter_start) (print "mus_03_library_a_encounter_start")))

	; mus_04 set in middle_sec_door with encounter spawning
	(sleep_until (> s_music_trigger_c20 30) 1)
	(if (= s_music_trigger_c20 40) (begin (music_event sound/music/c20/mus_04_access_portal_1_encounter_start) (print "mus_04_access_portal_1_encounter_start")))

	; mus_05 set in middle_sec_door with encounter ending
	(sleep_until (> s_music_trigger_c20 40) 1)
	(if (= s_music_trigger_c20 50) (begin (music_event sound/music/c20/mus_05_access_portal_1_encounter_end) (print "mus_05_access_portal_1_encounter_end")))

	; mus_06 set in beat_1_outro_encounter with encounter starting
	(sleep_until (> s_music_trigger_c20 50) 1)
	(if (= s_music_trigger_c20 60) (begin (music_event sound/music/c20/mus_06_floor_1_elevator_flood_combat_encounter_start) (print "mus_06_floor_1_elevator_flood_combat_encounter_start")))

	; mus_07 set in 343_hallway_b with chapter title
	(sleep_until (> s_music_trigger_c20 60) 1)
	(if (= s_music_trigger_c20 70) (begin (music_event sound/music/c20/mus_07_floor_1_elevator_flood_combat_encounter_end) (print "mus_07_floor_1_elevator_flood_combat_encounter_end")))

	(sleep_until (> s_music_trigger_c20 70) 1)
	(if (= s_music_trigger_c20 80) (begin (music_event sound/music/c20/mus_08_access_portal_2_encounter_start) (print "mus_08_access_portal_2_encounter_start")))

	(sleep_until (> s_music_trigger_c20 80) 1)
	(if (= s_music_trigger_c20 90) (begin (music_event sound/music/c20/mus_09_access_portal_2_encounter_end) (print "mus_09_access_portal_2_encounter_end")))

	(sleep_until (> s_music_trigger_c20 90) 1)
	(if (= s_music_trigger_c20 100) (begin (music_event sound/music/c20/mus_10_library_d_encounter_start) (print "mus_10_library_d_encounter_start")))

	(sleep_until (> s_music_trigger_c20 100) 1)
	(if (= s_music_trigger_c20 110) (begin (music_event sound/music/c20/mus_11_floor2_tank_encounter_start) (print "mus_11_floor2_tank_encounter_start")))

	(sleep_until (> s_music_trigger_c20 110) 1)
	(if (= s_music_trigger_c20 120) (begin (music_event sound/music/c20/mus_12_floor2_tank_encounter_end) (print "mus_12_floor2_tank_encounter_end")))

	(sleep_until (> s_music_trigger_c20 120) 1)
	(if (= s_music_trigger_c20 130) (begin (music_event sound/music/c20/mus_13_access_portal_3_encounter_start) (print "mus_13_access_portal_3_encounter_start")))

	(sleep_until (> s_music_trigger_c20 130) 1)
	(if (= s_music_trigger_c20 140) (begin (music_event sound/music/c20/mus_14_access_portal_3_encounter_end) (print "mus_14_access_portal_3_encounter_end")))

	(sleep_until (> s_music_trigger_c20 140) 1)
	(if (= s_music_trigger_c20 150) (begin (music_event sound/music/c20/mus_15_puzzle_room_encounter_start) (print "mus_15_puzzle_room_encounter_start")))

	(sleep_until (> s_music_trigger_c20 150) 1)
	(if (= s_music_trigger_c20 160) (begin (music_event sound/music/c20/mus_16_puzzle_room_encounter_end) (print "mus_16_puzzle_room_encounter_end")))

	(sleep_until (> s_music_trigger_c20 160) 1)
	(if (= s_music_trigger_c20 170) (begin (music_event sound/music/c20/mus_17_large_hallway_c_encounter_start) (print "mus_17_large_hallway_c_encounter_start")))

	; mus_18 removed from design

	(sleep_until (> s_music_trigger_c20 180) 1)
	(if (= s_music_trigger_c20 190) (begin (music_event sound/music/c20/mus_19_center_corridor_c_encounter_start) (print "mus_19_center_corridor_c_encounter_start")))

	(sleep_until (> s_music_trigger_c20 190) 1)
	(if (= s_music_trigger_c20 200) (begin (music_event sound/music/c20/mus_20_large_hallway_c_encounter_end) (print "mus_20_large_hallway_c_encounter_end")))

	(sleep_until (> s_music_trigger_c20 200) 1)
	(if (= s_music_trigger_c20 210) (begin (music_event sound/music/c20/mus_21_puzzle_room_2_encounter_start) (print "mus_21_puzzle_room_2_encounter_start")))

	(sleep_until (> s_music_trigger_c20 210) 1)
	(if (= s_music_trigger_c20 220) (begin (music_event sound/music/c20/mus_22_encounter_end) (print "mus_22_encounter_end")))

	; mus_23 set in beat_4_final with encounter starting
	(sleep_until (> s_music_trigger_c20 220) 1)
	(if (= s_music_trigger_c20 230) (begin (music_event sound/music/c20/mus_23_large_hallway_e_final_access_portal_encounter_start) (print "mus_23_large_hallway_e_final_access_portal_encounter_start")))

	; mus_24 set in beat_4_final with encounter ending
	(sleep_until (> s_music_trigger_c20 230) 1)
	(if (= s_music_trigger_c20 240) (begin (music_event sound/music/c20/mus_24_large_hallway_e_final_access_portal_encounter_end) (print "mus_24_large_hallway_e_final_access_portal_encounter_end")))

	; mus_25 set in c20_won with cinematic
	(sleep_until (> s_music_trigger_c20 240) 1)
	(if (= s_music_trigger_c20 250) (begin (music_event sound/music/c20/mus_25_ending_cinematic_start) (print "mus_17_ending_cinematic_start")))

	(print "c20_music_controller finished")
)

; no c20_music_triggers_beat1 as all triggers were found in c20.hsc

(script dormant c20_music_triggers_beat2
	(print "c20_music_triggers_beat2 started")
	; mus_08 set in f2_lhallwayb_sec_door_init with encounter starting
	; mus_09 set in f2_lhallwayb_sec_door_init with encounter ending

	(sleep_until (volume_test_players tv_music_library_d_100) 1)
	(set s_music_trigger_c20 100)

	; mus_11 set in vo_floor2_pureform_trigger with tank timing
	(sleep_until (= s_music_trigger_c20 110) 1) ; wait until tank is spawned

	(sleep_until (= 0 (ai_living_count sq_f2_lib_d_r4_tank)) 1)
	(set s_music_trigger_c20 120)

	; mus_13 set in f2_center_east_sec_door with encounter starting
	; mus_14 set in f2_center_east_sec_door with encounter ending
	; mus_15 set in vo_floor2_smallroomc with dialogue

	(sleep_until (> (device_get_position elevator_2) 0) 1)
	(set s_music_trigger_c20 160)
	(print "c20_music_triggers_beat2 finished")
)


(script dormant c20_music_triggers_beat3
	(print "c20_music_triggers_beat3 started")
	(sleep_until (>= (device_get_position floor_3_jump_scare_door) r_door_jump_pause_pos) 1)
	(set s_music_trigger_c20 170)

	; mus_19 set in security_door_3 with encounter starting
	; mus_20 set in security_door_3 with encounter ending

	(sleep_until (volume_test_players tv_music_library_f_210) 1)
	(set s_music_trigger_c20 210)

	(sleep_until (> (device_get_position elevator_3) 0) 1)
	(set s_music_trigger_c20 220)
	(print "c20_music_triggers_beat3 finished")
)

; no c20_music_triggers_beat4 as all triggers were found in c20.hsc