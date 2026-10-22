;====================================================================================================================================================================================================
; vo ==============================================================================================================================================
;====================================================================================================================================================================================================

(global boolean b_cortana_told_you_to_jump false)

(script dormant vo_enc1_1
	(if (< conversation_id 1) (set conversation_id 1))
	(branch
		(> conversation_id 1) (f_md_abort)
	)

	(f_md_2d_play_cortana 30 m09_00060 "cortana: i can read the captain's cni transponder. he's in the control room... but i'm not detecting any human life signs.")
	(sleep_until (volume_test_players enc1_1_triggerkeyesvo_volume) 1 (game_ticks_from_seconds 2))
	(set s_music_trigger 30)
	(f_md_2d_play 0 m09_00070 "keyes: chief! don't be a fool! leave me!")
	(f_md_2d_play_cortana 0 m09_00080 "cortana: captain? captain?! i've lost him.")
)

(script dormant vo_enc1_1_exploration
	(sleep_until (script_finished "vo_enc1_1") 1)

	(if (< conversation_id 2) (set conversation_id 2))
	(branch
		(> conversation_id 2) (f_md_abort)
	)
	(f_md_2d_play_cortana 0 m09_00090 "cortana: the damage caused by the crash and the flood have sealed off all nearby accessways to the control room. we should find another way in.")
)

(script dormant vo_enc1_5_intro_trigger
	(if (volume_test_players tv_vo_mus_jumped) (print "player jumped, not triggering vo_enc1_5_intro") ; player jumped immediately, don't trigger vo
		; else
		(wake vo_enc1_5_intro) ; player did not jump immediately
	)
)

(script dormant vo_enc1_5_intro
	(if (< conversation_id 3) (set conversation_id 3))
	(branch
		(or 
			(> conversation_id 3) ; player lands in coolant
			(volume_test_players tv_vo_mus_jumped_later)
		) 
		(f_md_abort)
	)

	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play_cortana 0 m09_00100 "cortana: analyzing damage. this hole was caused by some kind of explosive... very powerful, if it tore through the ship's hull. all i detect down there are pools of coolant. we should continue our search somewhere else.")
)

(script dormant vo_enc1_5
	(sleep_until (script_finished "vo_enc1_5_intro") 1)

	(if (< conversation_id 4) (set conversation_id 4))
	(branch
	 	(or (> conversation_id 4) (volume_test_players tv_vo_mus_jumped)) (f_md_abort)
	)

	(sleep_until (> enc1_5_limiter 10) 1 (game_ticks_from_seconds 5))

	(f_md_2d_play_cortana 0 m09_00120 "cortana: warning! threat level increasing. that jump into the coolant is looking better all the time, chief. trust me... it's deep enough to cushion our fall.")
	(wake objective_jump)
	(set b_cortana_told_you_to_jump true)

	(wake nav_canyon_jump_control)

	(sleep_until (> enc1_5_limiter 18) 1 (game_ticks_from_seconds 5))
	(f_md_2d_play_cortana 0 m09_00110 "cortana: there's so many i can't track them all!")

	(sleep_until (> enc1_5_limiter 25) 1 (game_ticks_from_seconds 2))
	(f_md_2d_play_cortana 0 m09_00130 "cortana: chief, we need to jump. now! ")
)

(script dormant vo_enc3_0
	(if (< conversation_id 5) (set conversation_id 5))
	(branch
		(> conversation_id 5) (f_md_abort)
	)

	(sleep (game_ticks_from_seconds 2))
	(if b_cortana_told_you_to_jump (f_md_2d_play_cortana 45 m09_00140 "cortana: i told you it was deep enough.")) ;only play this line if cortana already told masterchief that it was deep enough
	(f_md_2d_play_cortana 30 m09_00160 "cortana: the crash did more damage than i suspected. analyzing: coolant leakage rate is significant. the ship's reactors should already have gone critical.")
	(f_md_2d_play_cortana 0 m09_00170 "cortana: we should head this way, towards the ship's gravity lift.")

	(wake nav_canyon_entrance_control)
	(wake objective_exterior)
	(wake vo_enc3_dawdle)
)

(script dormant vo_enc3_dawdle
	(branch (> conversation_id 5) (f_md_abort)) ; abort when player proceeds out of enc3_0 area

	(f_md_dawdle_play 0 m09_00150 "cortana: let's get out of here and find another way back aboard the ship." 2)
)

(script dormant vo_enc3_1
	(sleep_until (script_finished "vo_enc3_0") 1)

	(if (< conversation_id 6) (set conversation_id 6))

	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play 15 m09_00180 "keyes: i gave you an order, soldier! now pull out!")
	(f_md_2d_play_cortana 0 m09_00190 "cortana: he's delirious... in pain... we have to find him!")
)


(script dormant vo_enc3_4
	(sleep_until (volume_test_players enc3_4a) 1)

	(f_md_2d_play_cortana 0 m09_00200 "cortana: wait. the covenant and flood are attacking each other. i recommend we wait until they've worn each other down. then we'll only have to deal with the stragglers. ")
)

(script dormant vo_enc3_8
	(sleep_until (volume_test_players enc3_8a) 1)

	(wake nav_gravlift_control)
	(set s_music_trigger 100)
	(f_md_2d_play_cortana 0 m09_00210 "cortana: power source detected... there's the gravity lift... it's still operational...that's our way back in.")
	(f_md_2d_play 0 m09_00220 "keyes: (roar of pain) ")
	(f_md_2d_play_cortana 0 m09_00230 "cortana: the captain! his vitals are fading. please, chief. hurry!")
	(wake objective_lift)
)

(script dormant vo_enc4_1
	(f_md_2d_play_cortana 0 m09_00240 "cortana: we should be able to get into the ship's control room from here. ")
)

(script dormant vo_enc4_2
	(f_md_2d_play_cortana 0 m09_00250 "cortana: the covenant battle net is a mess...i can't access the ship's schematics. my records indicate that a shuttle bay should be...here. ")
	(wake navpoint_shuttle_bay_control)
)

(script dormant vo_enc4_3
	(sleep_until (volume_test_players tv_vo_enc4_3) 1)

	(f_md_2d_play_cortana 0 m09_00260 "cortana: look, in the corners...the flood are gathering bodies here.")
)

(script dormant vo_enc5_1
	(f_md_2d_play_cortana 0 m09_00270 "cortana: looks like another shuttle bay. we should be able to reach the control room from the third level.")
	(wake nav_hangar_loop_up)
)

(script dormant vo_enc5_7
	(sleep_until (volume_test_players tv_vo_enc5_7) 1)

	(f_md_2d_play_cortana 0 m09_00280 "cortana: the control room should be... this way. ")
	(wake navpoint_control_room_control)
)

(script dormant vo_enc6_3
	(sleep_until (= (cinematic_in_progress) false) 1)

	(sleep (game_ticks_from_seconds 3.5))
	(f_md_2d_play_cortana 0 m09_09130 "cortana: alert! i'm detecting multiple covenant and flood groups approaching the bridge!")

	(sleep_until
		(or
			(volume_test_players enc6_5_stopper)
			(volume_test_players enc6_3_safe)
		)
	1)
	(f_md_2d_play_cortana 0 m09_00340 "cortana: we need to get back to the pillar of autumn.  let's go back to the shuttle bay and find a ride.")
)

(script dormant vo_enc7_2
	(branch (or (player_in_vehicle (ai_vehicle_get_from_starting_location sq_outro_banshee1/spawnpoint)) (player_in_vehicle (ai_vehicle_get_from_starting_location sq_outro_banshee2/spawnpoint)))
		(f_md_abort)
	)

	(sleep (game_ticks_from_seconds 3))
	(f_md_2d_play_cortana 0 m09_00350 "cortana: perfect. grab one of the banshees and we'll use it to return to the pillar of autumn.")
	(wake nav_banshee_control)
)

;====================================================================================================================================================================================================
; keyes transmissions =================================================================================================================================
;====================================================================================================================================================================================================

(script dormant vo_keyes_pained_enc4_4
	(f_md_2d_play 0 m09_00380 "keyes: the memories... they're not mine... i must hold on...")
)

(script dormant vo_keyes_pained_enc4_7
	(f_md_2d_play 0 m09_00370 "keyes: 199... 12... jk")
)

(script dormant vo_keyes_pained_enc5
	(sleep_until (volume_test_players tv_vo_keyes_sec5) 1)
	(f_md_2d_play 0 m09_00400 "keyes: i can hear their whispers...")
)

(script dormant vo_keyes_pained_enc5_5
	(f_md_2d_play 0 m09_00410 "keyes: they're relentless... but so am i...")
)

(script dormant vo_keyes_pained_enc5_6
	(f_md_2d_play 0 m09_00430 "keyes: catherine? is that really you?")
)

(script dormant vo_keyes_pained_enc6_1
	(branch (volume_test_players enc6_3_cin) (f_md_abort))

	(f_md_2d_play 45 m09_00390 "keyes: i can feel them... crawling inside my mind... but i won't give in...")
	(f_md_2d_play 0 m09_00420 "keyes: miranda…")
)


;====================================================================================================================================================================================================
; vignette ========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant vo_vig1_migrate_grunt
	(sleep_until (objects_can_see_object (players) sq_enc1_2_covenant_grunt 20) 1)
	(sound_impulse_start sound\dialog\combat\grunt\default\13_script\d20_flee sq_enc1_2_covenant_grunt 1)
)

;====================================================================================================================================================================================================
; music ==============================================================================================================================================
;====================================================================================================================================================================================================

(global short s_music_trigger 0)

(script dormant music_d20
	(print "music_d20 started")

	(sleep_until (> s_music_trigger 10) 1)
	(if (= s_music_trigger 20) (begin (print "mus_02_command_room_encounter_start") (music_event sound/music/d20/mus_02_command_room_encounter_start)))

	(sleep_until (> s_music_trigger 20) 1)
	(if (= s_music_trigger 30) (begin (print "mus_03_keyes_diologue_encounter_start") (music_event sound/music/d20/mus_03_keyes_diologue_encounter_start)))

	(sleep_until (> s_music_trigger 30) 1)
	(if (= s_music_trigger 40) (begin (print "mus_04_drop_encounter_start") (music_event sound/music/d20/mus_04_drop_encounter_start)))

	(sleep_until (> s_music_trigger 40) 1)
	(if (= s_music_trigger 50) (begin (print "mus_05_drop_encounter_end_safety") (music_event sound/music/d20/mus_05_drop_encounter_end_saftey))) ; spelling error in sound tag

	; mus_06 was removed 

	; mus_07 was removed

	(sleep_until (> s_music_trigger 70) 1)
	(if (= s_music_trigger 80) (begin (print "mus_08_narrowing2_encounter_start") (music_event sound/music/d20/mus_08_narrowing2_encounter_start)))

	(sleep_until (> s_music_trigger 80) 1)
	(if (= s_music_trigger 90) (begin (print "mus_09_narrowing2_encounter_end") (music_event sound/music/d20/mus_09_narrowing2_encounter_end)))

	(sleep_until (> s_music_trigger 90) 1)
	(if (= s_music_trigger 100) (begin (print "mus_10_gravity_lift_encounter_start") (music_event sound/music/d20/mus_10_gravity_lift_encounter_start)))

	(sleep_until (> s_music_trigger 100) 1)
	(if (= s_music_trigger 110) (begin (print "mus_11_gravity_lift_encounter_end") (music_event sound/music/d20/mus_11_gravity_lift_encounter_end)))

	(sleep_until (> s_music_trigger 110) 1)
	(if (= s_music_trigger 120) (begin (print "mus_12_vehicle_bay_encounter_start") (music_event sound/music/d20/mus_12_vehicle_bay_encounter_start)))

	(sleep_until (> s_music_trigger 120) 1)
	(if (= s_music_trigger 130) (begin (print "mus_13_vehicle_bay_encounter_end") (music_event sound/music/d20/mus_13_vehicle_bay_encounter_end)))

	; mus_14, mus_15 not in design

	(sleep_until (> s_music_trigger 150) 1)
	(if (= s_music_trigger 160) (begin (print "mus_16_head_to_keyes_encounter_start") (music_event sound/music/d20/mus_16_head_to_keyes_encounter_start)))

	(sleep_until (> s_music_trigger 160) 1)
	(if (= s_music_trigger 170) (begin (print "mus_17_head_to_keyes_encounter_end") (music_event sound/music/d20/mus_17_head_to_keyes_encounter_end)))

	; mus_18 removed from design

	(sleep_until (> s_music_trigger 180) 1)
	(if (= s_music_trigger 190) (begin (print "mus_19_enemy_arrival_keyes_room_encounter_start") (music_event sound/music/d20/mus_19_enemy_arrival_keyes_room_encounter_start)))

	(sleep_until (> s_music_trigger 190) 1)
	(if (= s_music_trigger 200) (begin (print "mus_20_hangar_battle_encounter_start") (music_event sound/music/d20/mus_20_hangar_battle_encounter_start)))
)

(script dormant music_trigger_20
	(sleep_until (volume_test_players tv_mus_trigger_20) 1)
	(set s_music_trigger 200)
)