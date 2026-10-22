;====================================================================================================================================================================================================
; play vo under condition
;====================================================================================================================================================================================================

; ================== beat 1 vo ==================
(script dormant dialogue_mission_start
	(f_md_2d_play_cortana 0 m10_00070 "cortana: we need to get to the bridge…from there, we can use the captain's neural implants to initiate an overload of the ship's fusion engines. the explosion should damage enough systems below it to destroy the ring.")
)

; ================== beat 2 vo ==================
(script dormant dialogue_enter_bridge
	(f_md_2d_play_cortana 0 m10_00080 "cortana: the bridge.  we made it. let's get to work.")
	(sleep_until dialogue_bridge_ready 1)
	(f_md_2d_play_cortana 0 m10_00090 "cortana: i need you to upload me into the control systems. the terminal is located next to the main view screen.")
	(sleep (game_ticks_from_seconds 1))
	(f_exclusive_blip_flag fl_cortana_port 0)
)

; ================== beat 3 vo ==================
(script dormant dialogue_get_to_engine
	(f_md_2d_play_cortana 30 m10_00300 "cortana: chief: we need to get to the engine room. that's the only other place where the monitor can override the self-destruct sequence!")
	(f_md_2d_play_cortana 0 m10_00310 "cortana: the ship was heavily damaged when it crashed. head to the cryo chamber. we should be able to get to the engine room through there.")
)

; ================== beat 4 vo ==================

; ================== beat 5 vo ==================
(script dormant dialogue_engine_enter
	(f_md_2d_play_cortana 30 m10_00320 "cortana: engine room located. we're here.")
	(f_md_2d_play_cortana 30 m10_00330 "cortana: don't worry. i have access to all of the reactor schematics and procedures. i'll walk you through it.")
	(wake mus_14)
	(f_controls_blip)
	(wake engine_room_objective)
	(f_md_2d_play_cortana 0 m10_00340 "cortana: first we need to pull back the exhaust couplings. that will expose a shaft that leads to the primary fusion drive core.")
)

(script dormant dialogue_engine_first_console
	(f_md_2d_play_cortana 30 m10_00360 "cortana: good. step one complete.  now, we should have a straight shot into one of the ship's four fusion reactors")
	(f_md_2d_play_cortana 30 m10_00370 "cortana: we need a catalyst explosion to destabilize the magnetic containment field surrounding the fusion cells.")
	(if
		(not (armory_needed))
		(f_md_2d_play_cortana 0 m10_00380 "cortana: use an explosive. i recommend a grenade or rocket. if you run out of explosives, there is an armory station located near the engine room's entrance.")
	)
	(wake armory_reminder)
)

(script dormant dialogue_engine_armory
	(sleep_until
		(begin
			(if
				b_armory_reminding
				(begin
					(f_md_2d_play_cortana 0 m10_00380 "cortana: use an explosive. i recommend a grenade or rocket. if you run out of explosives, there is an armory station located near the engine room's entrance.")
					(sleep (game_ticks_from_seconds 45))
				)
			)
			(= (f_exhaust_killed) 4)
		)
		(game_ticks_from_seconds 1)
	)
)

(script dormant dialogue_engine_first_destroyed
	(sleep (game_ticks_from_seconds 2.5))
	(f_md_2d_play_cortana 0 m10_00390 "cortana: analyzing... fusion reactor number one destabilizing. use explosives on the other three reactors. that should be enough to trigger a wildcat explosion of the engines.")
)

(script dormant dialogue_engine_third_destroyed
	(sleep (game_ticks_from_seconds 2.5))
	(f_md_2d_play_cortana 0 m10_00400 "cortana: keep it up! only one more fusion reactor to go!")

)

(script dormant dialogue_engine_fourth_destroyed
	(wake mus_16)
	(f_md_2d_play_cortana 30 m10_00410 "cortana: that did it!  the engine's gone critical. based on the current rate of decay we should have 15 minutes to get off the ship.")
	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play_cortana 0 m10_00430 "cortana: cortana to echo-419...come in echo-419.")
	(f_md_2d_play 15 m10_00440 "echo 419: roger cortana, i read you five by five. ")
	(f_md_2d_play_cortana 15 m10_00450 "cortana: the pillar of autumn's engines are going critical, foehammer. request immediate extraction. approach the crash site and be ready to pick us up at external access junction 4-c as soon as you get my signal.")
	(f_md_2d_play 0 m10_00460 "echo 419: affirmative. echo-419 going on station now.")
)

(script dormant dialogue_enter_lift
	(f_md_2d_play 15 m10_00470 "echo 419: echo-419 to cortana. things are getting noisy down there. everything ok?")
	(f_md_2d_play_cortana 0 m10_00480 "cortana: negative, negative. we have a wildcat destabilization of the ship's fusion core. the engines must have sustained more damage than we thought.")
)


(script dormant dialogue_monitor_player
	(sleep_until
		(begin
			(if b_dialogue_monitor_player
				(begin
					(print_if b_debug_gameplay "monitor speaks to player")
					(begin_random_count 1
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00830 "guilty spark: not acceptable reclaimer, you must surrender the construct.")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00840 "guilty spark: you must surrender the construct so that we may return to our appointed task.")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00870 "guilty spark: are you perhaps ill?")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00880 "guilty spark: your behavior is not in keeping with established protocols.")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00890 "guilty spark: you would destroy this installation as well as this facinating record?")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00910 "guilty spark: the flood continue to multiply, reclaimer.")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00920 "guilty spark: why do you continue to ignore your task?")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00930 "guilty spark: surrender the construct to me or i will be forced to take you offline permanently")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00950 "guilty spark: your behavior necessitates repair and revision.")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00960 "guilty spark: please … surrender the construct and i will endevour to make the necessary repairs as quickly as possible.")
					)
					(set b_dialogue_monitor_player false)
				)
			)
			b_dialogue_monitor_complete
		)
	1)
)

(script dormant dialogue_monitor_self
	(sleep_until
		(begin
			(if b_dialogue_monitor_self
				(begin
					(print_if b_debug_gameplay "monitor speaks to self")
					(begin_random_count 1
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_00970 "guilty spark: revision and repair protocalls continuing. please wait for update.")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_01030 "guilty spark: hardware and software configurations are below required specifications.")
						(f_md_3d_play_guilty_spark 0 sq_enc5_1_monitor m10_01040 "guilty spark: re-categorising data for processing and storage now.")
					)
					(set b_dialogue_monitor_self false)
				)
			)
			b_dialogue_monitor_complete
		)
	1)
)



; ================== beat 6 vo ==================
(script dormant dialogue_player_in_warthog
	(if
		(= (game_difficulty_get) legendary)
		(f_md_2d_play 30 m10_00770 "analyzing...[pause] we have five minutes before the fusion drives detonate. we need to evac now.")
	)
	(f_md_2d_play_cortana (* 30 8) m10_00490 "cortana: activating final countdown timer. when it reaches zero, the engines will detonate...the explosion will generate a temperature of almost one hundred million degrees...don't be here when it blows.")
)

(script dormant dialogue_enter_vehicle_bay
	(f_md_2d_play_cortana 0 m10_00510 "cortana: alert: our rv point with foehammer is further towards the ship's bow than our current position. use a warthog to reach the extraction point...or we'll never make it in time.")
)

(script static boolean dialogue_player_leaves_vehicle
	(if
		(not
			(or
				b_player_longsword
				(volume_test_players tv_enc6_5_1_grunt_ee)
			)
		)

	(begin
		(f_md_2d_play_cortana 0 m10_00780 "cortana: alert! we need to keep moving! get back in the warthog!")
		true
	)
	false
	)
)

(script static boolean dialogue_player_wrong_direction
	(begin_random_count 1
		(f_md_2d_play_cortana 0 m10_00790 "cortana: stop!  chief you're going the wrong way!")
	)
	true
)

(script dormant dialogue_leave_warthog_room
	(sleep (game_ticks_from_seconds 10))

	(sleep_until
		(volume_test_players tv_enc6_0_1)
		1
		(game_ticks_from_seconds 20)
	)

	(if (not (unit_in_vehicle_type player0 s_vehicle_type_warthog))
		(f_md_2d_play_cortana 0 m10_00500 "cortana: we can't make it on foot! we need a vehicle!")
	)

	(f_blip_object bay_warthog_1 blip_objective)
	(f_blip_object bay_warthog_2 blip_objective)
	(f_blip_object bay_warthog_3 blip_objective)
	(f_blip_object bay_warthog_4 blip_objective)

	(sleep_until
		(or
			(unit_in_vehicle_type player0 s_vehicle_type_warthog)
			(unit_in_vehicle_type player1 s_vehicle_type_warthog)
			(unit_in_vehicle_type player2 s_vehicle_type_warthog)
			(unit_in_vehicle_type player3 s_vehicle_type_warthog)
		)
		1
	)

	(f_unblip_object bay_warthog_1)
	(f_unblip_object bay_warthog_2)
	(f_unblip_object bay_warthog_3)
	(f_unblip_object bay_warthog_4)
	(wake check_player_in_warthog)
	(wake nav_wart_run)
)

(script dormant dialogue_foehammer_evade
	(wake dialogue_foehammer_mess)
	(f_md_2d_play_cortana 0 m10_00550 "cortana: cortana to echo-419: two covenant banshees are approaching on your six. evade! say again: evade!")
	(f_md_2d_play 0 m10_00560 "echo 419: roger, roger...i see 'em...wait one...come on...come on...breaking right! damn! too late!")

)
(script dormant dialogue_foehammer_mess
	(sleep_until (volume_test_players tv_enc6_2_1)1)
	(f_md_2d_play_cortana 0 m10_09100 "cortana: we need to get through that mess and rendezvous with foehammer. don't stop for anything!")
)

(script dormant dialogue_foehammer_pick_up
	(sleep_until (volume_test_players tv_enc6_4) 1)
	(f_md_2d_play_cortana 15 m10_00520 "cortana: wait! stop! this is where foehammer is coming to pick us up. hold position here.")
	(wake mus_20)
	(f_md_2d_play_cortana 30 m10_00530 "cortana: [radio] cortana to echo-419: request extraction now! on the double!")

	; skip parts if experienced players sped through
	(if
		(volume_test_players tv_enc6_4)
		(f_md_2d_play 0 m10_00540 "pilot: [radio] affirmative, cortana. foehammer inbound...")
	)

	(set b_foehammer_crash_start true)
	(if
		(volume_test_players tv_enc6_4)
		(sleep_until (>= (device_get_position dm_foehammer_crash) 0.17) 1)
	)
	(f_md_2d_play 30 m10_00570 "echo 419: i'm hit! mayday! mayday! rear port thrusters are shot to hell! i can't hold her...i can't hold her---")
	(if
		(volume_test_players tv_enc6_4)
		(sleep_until (>= (device_get_position dm_foehammer_crash) 0.925) 1)
	)
	(f_md_2d_play 30 m10_00580 "echo 419: [death scream]")
	(sleep_until (script_finished "foehammer_death_emitters") 1)
	(sleep (game_ticks_from_seconds 3))
	(f_md_2d_play_cortana 0 m10_00590 "cortana: echo-419! ... she's gone ... calculating alternate escape route. ... ship's inventory shows one longsword fighter is still docked in launch bay 7. if we move now we can make it.")
	(set b_foehammer_crash_complete true)
)

(script dormant dialogue_big_jump
	(sleep_until (volume_test_players tv_dialogue_big_jump_1) 1)
	(f_md_2d_play_cortana 0 m10_00600 "cortana: chief, up ahead, there's a gap in the trench. at top speed we should be able to clear it.")
	(sleep_until (volume_test_players tv_dialogue_big_jump_2) 1)
	(f_md_2d_play_cortana 0 m10_00610 "cortana: jump!")
	(wake mus_22)
)

(script dormant dialogue_thirsty_grunt
	(f_md_3d_play 0 sq_grunt_ee m10_01050 "thirsty grunt: good thing that food nipple's waiting for me at the starship, cause, man, have i worked up a big grunty thirst!")
)

(script dormant dialogue_thirty_seconds
	(if
		(not
			(or
				b_player_longsword
				(volume_test_players tv_enc6_5_1_grunt_ee)
			)
		)
		(f_md_2d_play_cortana 0 m10_00820 "cortana: 30 seconds...")
	)
)

; ================== beat 7 vo ==================
(script dormant dialogue_get_aboard
	(f_md_2d_play_cortana 0 m10_00620 "cortana: that's the ship. move! we need to get aboard now!")
)
;====================================================================================================================================================================================================
; foehammer vignette audio
;====================================================================================================================================================================================================

(script dormant foehammer_flyby_emitters
	(sleep_until (>= (device_get_position dm_foehammer_flyby) 0.44) 1)
	(sound_impulse_start sound/levels/d40/vig_d40_12_pelican_02 audio_vig_12_pelican_02 1)
	(sound_impulse_start sound/levels/d40/vig_d40_12_pelican_03 audio_vig_12_pelican_03 1)
)

(script dormant foehammer_death_emitters
	(sleep_until (>= (device_get_position dm_foehammer_crash) 0.5) 1)
	(sound_impulse_start sound/levels/d40/vig_d40_13_platform_centerrearpoint audio_vig_13_platform_center 1)
	(sleep_until (>= (device_get_position dm_foehammer_crash) 0.56) 1)
	(sound_impulse_start sound/levels/d40/vig_d40_13_platform_tunnelfrontpoint audio_vig_13_platform_front 1)
	(sleep_until (>= (device_get_position dm_foehammer_crash) 0.58) 1)
	(sound_impulse_start sound/levels/d40/vig_d40_13_platform_tunnelrearpoint audio_vig_13_platform_rear 1)
	(sleep_until (and (>= (device_get_position dm_foehammer_crash) 0.945) (not (f_is_dialogue_playing))) 1)
	(sound_impulse_start sound/levels/d40/vig_d40_13_platform_explode audio_vig_13_foehammer_death 1)
)




;====================================================================================================================================================================================================
; play music under condition
;====================================================================================================================================================================================================

(global short s_music_trigger_d40 0)

(script dormant d40_music_controller
	(print "d40_music_controller started")
	; there is no mus_01 at time of refactor.

	(sleep_until (> s_music_trigger_d40 10) 1)
	(if (= s_music_trigger_d40 20)
		(begin
			(print_if b_debug_gameplay "mus 02")
			(music_event sound/music/d40/mus_02_opening_cinematic_end)
		)
	)
	(sleep_until (> s_music_trigger_d40 20) 1)
	(if (= s_music_trigger_d40 30)
		(begin
			(print_if b_debug_gameplay "mus 03")
			(music_event sound/music/d40/mus_03_medical_encounter_start)
		)
	)
	(sleep_until (> s_music_trigger_d40 30) 1)
	(if (= s_music_trigger_d40 40)
		(begin
			(print_if b_debug_gameplay "mus 04")
			(music_event sound/music/d40/mus_04_medical_encounter_end)
		)
	)
	(sleep_until (> s_music_trigger_d40 40) 1)
	(if (= s_music_trigger_d40 50)
		(begin
			(print_if b_debug_gameplay "mus 5a")
			(music_event sound/music/d40/mus_05a_bridge_encounter_start)
		)
	)
	(sleep_until (> s_music_trigger_d40 50) 1)
	(if (= s_music_trigger_d40 60)
		(begin
			(print_if b_debug_gameplay "mus 06")
			(music_event sound/music/d40/mus_06_bridge_encounter_end)
		)
	)
	(sleep_until (> s_music_trigger_d40 60) 1)
	(if (= s_music_trigger_d40 70)
		(begin
			(print_if b_debug_gameplay "mus 07")
			(music_event sound/music/d40/mus_07_armory_a_encounter_start)
		)
	)
	(sleep_until (> s_music_trigger_d40 70) 1)
	(if (= s_music_trigger_d40 80)
		(begin
			(print_if b_debug_gameplay "mus 08")
			(music_event sound/music/d40/mus_08_armory_a_encounter_end)
		)
	)
	(sleep_until (> s_music_trigger_d40 80) 1)
	(if (= s_music_trigger_d40 90)
		(begin
			(print_if b_debug_gameplay "mus 09")
			(music_event sound/music/d40/mus_09_cryo_bay_encounter_start)
		)
	)
	(sleep_until (> s_music_trigger_d40 90) 1)
	(if (= s_music_trigger_d40 100)
		(begin
			(print_if b_debug_gameplay "mus 10")
			(music_event sound/music/d40/mus_10_cryo_bay_encounter_end)
		)
	)
	(sleep_until (> s_music_trigger_d40 100) 1)
	(if (= s_music_trigger_d40 110)
		(begin
			(print_if b_debug_gameplay "mus 11")
			(music_event sound/music/d40/mus_11_armory_b_encounter_start)
		)
	)
	(sleep_until (> s_music_trigger_d40 110) 1)
	(if (= s_music_trigger_d40 120)
		(begin
			(print_if b_debug_gameplay "mus 12")
			(music_event sound/music/d40/mus_12_armory_b_encounter_end)
		)
	)
	(sleep_until (> s_music_trigger_d40 120) 1)
	(if (= s_music_trigger_d40 130)
		(begin
			(print_if b_debug_gameplay "mus 13")
			(music_event sound/music/d40/mus_13_light_fuse_run_away)
		)
	)
	(sleep_until (> s_music_trigger_d40 130) 1)
	(if (= s_music_trigger_d40 140)
		(begin
			(print_if b_debug_gameplay "mus 14")
			(music_event sound/music/d40/mus_14_engine_room_part_1)
		)
	)
	(sleep_until (> s_music_trigger_d40 140) 1)
	(if (= s_music_trigger_d40 150)
		(begin
			(print_if b_debug_gameplay "mus 15")
			(music_event sound/music/d40/mus_15_engine_room_part_2)
		)
	)
	(sleep_until (> s_music_trigger_d40 150) 1)
	(if (= s_music_trigger_d40 160)
		(begin
			(print_if b_debug_gameplay "mus 16")
			(music_event sound/music/d40/mus_16_engine_room_part_3)
		)
	)
	(sleep_until (> s_music_trigger_d40 160) 1)
	(if (= s_music_trigger_d40 170)
		(begin
			(print_if b_debug_gameplay "mus 17")
			(music_event sound/music/d40/mus_17_engine_room_end)
		)
	)
	(sleep_until (> s_music_trigger_d40 170) 1)
	(if (= s_music_trigger_d40 180)
		(begin
			(print_if b_debug_gameplay "mus 18")
			(music_event sound/music/d40/mus_18_trench_run_part_1)
		)
	)

	; mus_19 was cut from design

	(sleep_until (> s_music_trigger_d40 180) 1)
	(if (= s_music_trigger_d40 200)
		(begin
			(print_if b_debug_gameplay "mus 20")
			(music_event sound/music/d40/mus_20_echo_419)
		)
	)
	(sleep_until (> s_music_trigger_d40 200) 1)
	(if (= s_music_trigger_d40 210)
		(begin
			(print_if b_debug_gameplay "mus 21")
			(music_event sound/music/d40/mus_21_trench_run_part_2)
		)
	)
	(sleep_until (> s_music_trigger_d40 210) 1)
	(if (= s_music_trigger_d40 220)
		(begin
			(print_if b_debug_gameplay "mus 22")
			(music_event sound/music/d40/mus_22_trench_run_gap)
		)
	)
	; mus_23 will be triggered on its own outside of the controller thread.
)

(script dormant music_intro
	(set s_music_trigger_d40 20)
)

(script dormant mus_03
	(sleep_until (volume_test_players tv_mus_03) 1)
	(set s_music_trigger_d40 30)
)

(script dormant mus_04
	(sleep_until
		(or
			(= 0 (+ (ai_living_count gr_enc2_2_flood) (ai_living_count gr_enc2_2_cov)))
			(volume_test_players tv_mus_04)
		)
		1
	)
	(set s_music_trigger_d40 40)

)

(script dormant mus_bridge_cine_end
	(set s_music_trigger_d40 50)
)

(script dormant mus_06
	(sleep_until
		(or
			(= 0 (ai_living_count gr_enc2_5_sents))
			(volume_test_players tv_enc2_6b)
		)
		1
	)
	(set s_music_trigger_d40 60)
)

(script dormant mus_07
	(sleep_until (volume_test_players tv_trigger_mus_7) 1)
	(set s_music_trigger_d40 70)
)

(script dormant mus_08
	(sleep_until
		(or
			(= 0 (+ (ai_living_count gr_enc3_1_sents) (ai_living_count gr_enc3_1_flood) (ai_living_count gr_enc3_2_sents)))
			(volume_test_players tv_enc3_3)
		)
		1
	)
	(set s_music_trigger_d40 80)
)

(script dormant mus_09
	(sleep_until (volume_test_players tv_trigger_mus_9) 1)
	(set s_music_trigger_d40 90)
)

(script dormant mus_10
	(sleep_until
		(or
			(and
				(= 0 (+ (ai_living_count gr_enc4_2_cov) (ai_living_count gr_enc4_2_flood) (ai_living_count gr_enc4_2_sents)))
				b_enc4_2_manager_complete
			)
			(volume_test_players tv_enc4_3)
		)
		1
	)
	(set s_music_trigger_d40 100)

)

(script dormant mus_11
	(sleep_until (objects_can_see_object (players) (list_get (ai_actors sq_enc4_3_flood_sc) 0) 10) 1) ; test player looking at stealth flood
	(set s_music_trigger_d40 110)
)

(script dormant mus_12
	(sleep_until
		(or
			(= 0 (ai_living_count gr_enc4_3_flood))
			(volume_test_players tv_mus_12)
		)
		1
	)
	(set s_music_trigger_d40 120)
)

(script dormant mus_13
	(set s_music_trigger_d40 130)
)

(script dormant mus_14
	(set s_music_trigger_d40 140)
)
(script dormant mus_15
	(set s_music_trigger_d40 150)
)

(script dormant mus_16
	(set s_music_trigger_d40 160)
)

(script dormant mus_17
	(sleep_until (= 0 (+ (ai_living_count sq_enc5_2_cov_ese) (ai_living_count sq_enc5_2_cov_esg))) 1)
	(set s_music_trigger_d40 170)
)

(script dormant mus_18
	(set s_music_trigger_d40 180)
)

(script dormant mus_20
	(set s_music_trigger_d40 200)
)

(script dormant mus_21
	(set s_music_trigger_d40 210)

)

(script dormant mus_22
	(set s_music_trigger_d40 220)

)

(script dormant mus_23
	(print_if b_debug_gameplay "mus 23")
	(music_event sound/music/d40/mus_23_trench_run_failure)
)