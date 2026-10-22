;============================================================================
; beat 1 - to control room narrative ========================================
;============================================================================
(script dormant vo_mission_intro
	(sleep_until (volume_test_players vo_mission_intro) 1)

	(sleep (game_ticks_from_seconds 0.8))
	(f_md_3d_play 45 ai_johnson m14_00521 "johnson: i don't know about you, chief, but i'm just about done with this damned place. this starholo data better be worth it.")
	(f_md_2d_play 15 m14_00522 "master chief: we get to the bridge, then we get what we came for.")
	(f_md_3d_play 0 ai_johnson m14_00523 "johnson: you forgot 'and then we get the hell off this crazy boat.'")
	(set s_music_trigger_e30 10)
)

(script dormant vo_hydro_vista
	(sleep_until
		(and
			(<= (ai_living_count gr_overview_hydro1) 0)
			(<= (ai_living_count gr_overview_hydro2) 0)
			(volume_test_players vo_hydro_vista)
		)
		1
	)

	(set s_music_trigger_e30 20)
	(sleep (game_ticks_from_seconds 1.7))
	(f_md_3d_play 30 ai_johnson m14_00650 "johnson: nice place. pity i didn't bring thermite charges.")
	(f_md_2d_play 0 m14_00660 "master chief: record everything. oni will want to analyze this.")
	(set obj_con_overview 35) ;to move johnson to different task in obj_overview_vista_unsc

)

(script dormant vo_garden_hunters
	(sleep_until (volume_test_players vo_garden_hunters) 1)

	(sleep (game_ticks_from_seconds 1))
	(if (> (ai_living_count gr_beat1_e9_hydro_garden) 0) ;hunters are still alive play the vo and music
		;then
		(begin
			(f_md_3d_play 0 ai_johnson m14_00710 "johnson: time for some dee-vine intervention!")
			(set s_music_trigger_e30 50)
		)
		;else
		(print "player killed hunters too fast. not playing vo line and updating music variable")
	)
)

(script dormant vo_garden_hunters_outro
	(branch
		;if player makes it to the next garden room and hunters are still alive branch and end the script
		(and
			(volume_test_players tv_end_garden_1)
			(> (ai_living_count gr_beat1_e9_hydro_garden) 0)
		)
		(f_md_skip_next)
	)

	(sleep_until (<= (ai_living_count gr_beat1_e9_hydro_garden) 0) 1)

	(set s_music_trigger_e30 60)

	(sleep (game_ticks_from_seconds 1.5)) ; delay for feel
	(f_md_3d_play 0 ai_johnson m14_00730 "johnson: damn. let's not do that again.")
)

(script dormant vo_garden_frosty
	(sleep_until (volume_test_players vo_garden_frosty) 1)

	(f_md_2d_play 15 m14_01710 "williams: johnson, status.")
	(f_md_2d_play 30 m14_01720 "johnson: we're close, el tee.")
	(f_md_2d_play 35 m14_01730 "williams: copy. we've cleared a route to the hangar.")
	(f_md_2d_play 30 m14_01740 "master chief: good luck, lieutenant. see you at the rally point.")
	(f_md_2d_play 0 m14_01750 "williams: ...yeah. stay frosty, spartan.")
)

(script dormant vo_control_approach
	(sleep_until
		(or
			(volume_test_players vo_control_approach)
			(<= (ai_living_count gr_beat1_e12_control_grav_up) 0)
		)
	1)

	(if (<= (ai_living_count gr_beat1_e12_control_grav_up) 0) (sleep (game_ticks_from_seconds 2))) ; delay for feel

	(wake mission_obj_starholo)

	(f_md_2d_play 15 m14_00750 "master chief: this should be the bridge.")
	(f_md_3d_play 30 ai_johnson m14_00760 "johnson: ready for our dramatic entrance?")
	(f_md_2d_play 20 m14_00770 "master chief: it's the only kind i know.")
	(f_md_3d_play 0 ai_johnson m14_00780 "johnson: well then, let's go get what we came for.")
)

(script dormant vo_control_intro
	(sleep_until (volume_test_players vo_control_intro) 1)
	(sleep_until (script_finished "vo_control_approach") 1)

	(set s_music_trigger_e30 70)
	(sleep (game_ticks_from_seconds 1.8))
	(f_md_3d_play 0 ai_johnson m14_00800 "johnson: sneaky bastards are trying to lock down their battle net! we need to stop them before they encrypt the starholo data!")
)

(script dormant vo_control_outro
	(sleep_until (<= (ai_living_count gr_beat1_e13_control_bridge) 0) 1)
	(set s_music_trigger_e30 90)

	(sleep (game_ticks_from_seconds 1.5)) ; delay for feel
	(f_md_3d_play 0 ai_johnson m14_00820 "johnson: that should be the last of 'em chief.")
)

;============================================================================
; beat 2 - away from control room narrative =================================
;============================================================================

(script dormant vo_control_after_cine
	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play 0 m14_00830 "master chief: we've got the data. integrity looks good.")
)

(script dormant vo_control_leaving
	(f_md_2d_play 15 m14_00930 "master chief: lieutenant williams, we have secured the data and are en-route to your position")
	(f_md_2d_play 20 m14_00940 "johnson: save some covenant for us. i'd hate to do all this walking for nothing!")
	(f_md_2d_play 0 m14_00960 "williams: no promises. williams out.")
)

(script dormant vo_control_grav_lift_lower
	(sleep_until (volume_test_players vo_control_grav_lower) 1)

	(object_create ss_control_grav_lift_lower)
	(print "harmony: all this for a simple map? you are truly blind to the miracles of my creation… and to the inevitability of your species' fate.")
	(sound_impulse_start sound\scripted\vo_scr_m14dlc3\m14_01760_harmony ss_control_grav_lift_lower 1)
	(sleep (sound_impulse_time sound\scripted\vo_scr_m14dlc3\m14_01760_harmony))
	(object_destroy ss_control_grav_lift_lower)
)

(script dormant vo_hydro_garden_return
	(sleep_until (volume_test_players vo_hydro_garden_return) 1)

	(set s_music_trigger_e30 140)
	(f_md_2d_play 15 m14_00520 "master chief: intel suggested this was a garden or recreation bay. looks like a hydroponics facility.")
	(f_md_3d_play 45 ai_johnson m14_02400 "johnson: chief, when we get out of here, i'll personally pin a medal on your chest and treat you to a night on the town.")
	(f_md_2d_play 35 m14_02410 "master chief: is that a threat, sergeant major?")
	(f_md_3d_play 0 ai_johnson m14_02420 "johnson: just going to hurt my feelings? i see how it is.")
)

(script dormant vo_beat2_down_lift
	(sleep_until (volume_test_players tv_glift_b_enter) 1)
	(f_md_2d_play 20 m14_01000 "williams: no leftovers for the late arrivals.")
	(f_md_2d_play 20 m14_01010 "johnson:  i figured you'd have this whole mess sorted out by the time i got there.")
	(f_md_2d_play 30 m14_01030 "master chief: let's not keep them waiting.")
	(f_md_3d_play 0 ai_johnson m14_01040 "johnson: after you. bravery before beauty.")
	(set s_music_trigger_e30 150)
)

;============================================================================
; beat 3 - transit narrative ================================================
;============================================================================

(script dormant vo_transit_hydro_enter
	(ai_actor_dialogue_enable ai_johnson 0)
	(sleep (game_ticks_from_seconds 0.8))
	(f_md_3d_play 30 ai_johnson m14_01771 "johnson: looks like we've found a ride.")
	(f_md_2d_play 25 m14_01770 "master chief: let's get moving.")
	(f_md_3d_play 0 ai_johnson m14_01780 "johnson: think they'll give us that tour?")
	(mission_obj_power_transit)
	(sleep (game_ticks_from_seconds 2))
	(ai_actor_dialogue_enable ai_johnson 1)
)

(script dormant vo_transit_hydro_activated
	(if (skull_enabled skull_daddy) ;iwhbyd skull enabled
		;then
		(begin
			(if (< (random_range 1 100) 75)
				;75% chance to play
				(wake vo_transit_skull_regular)
				;25% chance to play the ultimate rare choo choo line
				(wake vo_transit_choo_choo)
			)
		)
		;else
		(f_md_3d_play 0 ai_johnson m14_02370 "johnson: all aboard!") ;regular vo line
	)
)

(script dormant vo_transit_skull_regular
	(f_md_3d_play 75 ai_johnson m14_01790 "johnson: chugga-chugga!")
	(f_md_3d_play 0 ai_johnson m14_01620 "johnson: damn.")
)

(script dormant vo_transit_choo_choo
	(f_md_3d_play 75 ai_johnson m14_01790 "johnson: chugga-chugga!")
	(f_md_2d_play 0 m14_01800 "master chief: choo-choo.")
)


(script dormant vo_transit_hydro_leaving
	(f_md_2d_play 45 m14_02390 "williams: hangars secure. no covenant left breathing. we're holding position.")
	(f_md_2d_play 0 m14_01810 "master chief: understood. we are moving to regroup.")
	(set s_music_trigger_e30 190)
)

(script dormant vo_transit_section1_cleared
	(f_md_3d_play 0 ai_johnson m14_01820 "johnson: nothing stops this train!")
)

(script dormant vo_transit_section2_start
	(sleep_until (volume_test_players tv_transit_e27_a) 1)
	(f_md_2d_play 0 m14_01830 "master chief: target covenant on the bridge.")
)

(script dormant vo_transit_section2_cleared
	(sleep_until (= (ai_living_count gr_transit_e27_section2) 0) 1)
	(f_md_3d_play 0 ai_johnson m14_01840 "johnson: next!")
)

(script dormant vo_transit_dome_stop
	(sleep (game_ticks_from_seconds 2.8))
	(f_md_3d_play 90 ai_johnson m14_01850 "johnson: well, ain't this a fine mess. power's out, chief.")
	(f_md_2d_play 0 m14_01860 "master chief: there's a power relay above us.")
	(mission_obj_dome_power)
)

(script dormant vo_transit_dome_dawdle

	;sleep until first enemies in encounter are dead
	(sleep_until (= (ai_living_count gr_transit_e28_dome_station) 0) 1)

	;abort if player starts the powering up process for the dome station
	(branch
		(= b_dome_powering_started 1) (f_md_abort)
	)

	(sleep delay_dawdle)

	(f_md_3d_play 30 ai_johnson m14_01870 "johnson: train's offline, chief!")
	(f_md_2d_play 0 m14_01880 "master chief: i'll get it running. cover me.")
)

(script dormant vo_transit_dome_switched
	(sleep_until (= b_dome_powering_started 1) 1)

	(f_md_2d_play 30 m14_01890 "master chief: power has been rerouted.")
	(f_md_3d_play 90 ai_johnson m14_01900 "johnson: systems look to be waking up…")
	(f_md_3d_play 0 ai_johnson m14_01910 "johnson: a local alert got through … we have more bad guys incoming!")
	(set s_music_trigger_e30 210)
)

(script dormant vo_transit_dome_powered
	(sleep_until (= b_dome_defend_complete 1) 1)

	(set s_music_trigger_e30 230)
	(f_md_3d_play 35 ai_johnson m14_02380 "johnson: ready to move out.")
	(f_md_2d_play 0 m14_01920 "master chief: let's move.")
)

(script dormant vo_transit_station4_clear
	(sleep_until (= b_section_4_complete 1) 1)

	(f_md_3d_play 45 ai_johnson m14_02430 "johnson: their security is terrible.")
	(f_md_2d_play 30 m14_02440 "master chief: we won't always be so lucky.")
	(f_md_3d_play 0 ai_johnson m14_02450 "johnson: ok, mr. sunshine.")
)

(script dormant vo_transit_hangar_station
	(f_md_3d_play 0 ai_johnson m14_01930 "johnson: this is our stop!")
	(set s_music_trigger_e30 250)
)

(script dormant vo_hangar_gravlift
	(sleep_until (volume_test_players tv_transit_e33_a) 1)

	(f_md_2d_play 15 m14_01990 "williams: we've got a covenant counterattack inbound! falling back to defensive positions!")
	(f_md_3d_play 45 ai_johnson m14_02000 "johnson: copy that el tee! dig in and make 'em pay for every inch!")
	(f_md_3d_play 20 ai_johnson m14_02010 "johnson:  chief, i'm not sure those marines can hold out.")
	(f_md_2d_play 0 m14_02011 "master chief:they'll hold.")
	(set s_music_trigger_e30 260)
	(mission_obj_regroup_williams)
)

(script dormant vo_hangar_enter
	(sleep_until (volume_test_players tv_transit_e34_a) 1)
	(sleep_until (script_finished "vo_hangar_gravlift") 1)

	(f_md_3d_play 95 ai_johnson m14_02020 "johnson: marines, we're almost there. you copy?")
	(f_md_3d_play 45 ai_johnson m14_02040 "johnson: williams, you read?")
	(f_md_2d_play 15 m14_02050 "master chief: i don't like it.")
	(f_md_3d_play 0 ai_johnson m14_02060 "johnson: me either, let's hustle.")
)

;============================================================================
; beat 4 - space narrative ==================================================
;============================================================================

(script dormant vo_space_hangar_exit
	(f_md_2d_play 45 m14_01380 "johnson: you do know how to fly these things, right?")
	(f_md_2d_play 0 m14_01390 "master chief: i'm a quick learner.")
)

(script dormant vo_space_relay_start
	(f_md_2d_play 30 m14_01391 "williams: heads up, chief! we're seeing power surges - the covenant are up to something.")
	(f_md_2d_play 45 m14_01392 "johnson: any guesses?")
	(f_md_2d_play 30 m14_02490 "williams: not sure, could be prepping an emergency slipspace jump, could be firing a wideband comms pulse to call for reinforcements. whatever it is, we need to stop it.")
	(f_md_2d_play 30 m14_01393 "johnson: let's target their external relay nodes. that should keep them stranded and distracted.")
	(f_md_2d_play 0 m14_02500 "williams: good luck.")
)

(script dormant vo_space_relay_destroyed
	(f_md_2d_play 45 m14_01397 "williams: whatever you did out there seems to be working.")
	(f_md_2d_play 0 m14_01398 "johnson: that will show these bastards what happens when they mess with humanity's finest!")
)

(script dormant vo_space_to_debris
	(sleep_until (script_finished "vo_space_relay_destroyed") 1)

	(sleep (game_ticks_from_seconds 2))
	(set s_music_trigger_e30 310)
	(f_md_2d_play 40 m14_01480 "williams: williams to sierra-117, first generator is down, but they aren't too happy about it. hopefully more attention on us means less on you.  ")
	(f_md_2d_play 0 m14_01481 "master chief: acknowledged. redeploying to the debris field. we need the extra cover.")
)

(script dormant vo_space_debris_follow
	(wake mission_obj_survive)
	(f_md_2d_play 25 m14_02460 "johnson: never gets easier seeing this.")
	(f_md_2d_play 20 m14_02470 "master chief: it's a reminder of what's at stake.")
	(f_md_2d_play 0 m14_02480 "johnson: sure. i just wish we weren't sent in to sweep up ashes after the whole damn house was burned down.")
)

(script dormant vo_space_marines_escape
	(f_md_2d_play 0 m14_02130 "williams: spartan. we're sending out dropships with our wounded. keep 'em safe.")
	(set s_music_trigger_e30 320)
	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play 0 m14_02140 "master chief: acknowledged, lieutenant. sending rendezvous coordinates.")
)

(global boolean b_marines_saved_vo_played 0)

(script dormant vo_space_marines_saved
	(f_md_2d_play 0 m14_02150 "williams: our tigers are en-route to the rally point… thanks.")
	(set s_music_trigger_e30 330)
	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play 0 m14_02160 "master chief: copy. good work, lieutenant.")
	(set b_marines_saved_vo_played 1)
)

(script dormant vo_space_burden_on_the_way
	(f_md_2d_play 0 m14_01440 "johnson: burden should arrive shortly, let's clear the way.")
	(mission_obj_regroup_bop)
)

(global boolean b_vo_burden_detected_played 0)

(script dormant vo_space_burden_detected
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play 0 m14_01521 "johnson: slipspace rupture detected!")
	(set b_vo_burden_detected_played 1)
)

(script dormant vo_space_burden_arrival
	(set s_music_trigger_e30 340)
	(f_md_2d_play 30 m14_01540 "johnson: there's our ride home, chief.")
	(f_md_2d_play 35 m14_01550 "johnson: libra two to libra actual. confirming our iff in commandeered covenant fighters. we're preparing for your fire mission. sending target coordinates.")
	(f_md_2d_play 0 m14_01560 "burden: coordinates confirmed.")
	(mission_obj_burden_protect)
)

(script dormant vo_space_burden_encounter_start
	(f_md_2d_play 0 m14_01570 "johnson: okay chief, let's give the burden some cover and buy our new friends time to do their thing.")
)

(script dormant vo_space_kamikaze_incoming
	(wake kamikaze_objective_control)
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play 10 m14_02170 "master chief: new contacts.")
	(f_md_2d_play 30 m14_02180 "johnson: what the?!")
	(f_md_2d_play 15 m14_02190 "johnson: i see 'em… and they're not slowing down.")
	(f_md_2d_play 5 m14_02200 "master chief: they're going to hit the burden. full burn.")
	(f_md_2d_play 20 m14_02210 "johnson: crazy bastards!")
	(f_md_2d_play 0 m14_02220 "master chief: priority target those ships!")
	(set s_music_trigger_e30 350)
)

(script dormant vo_space_williams_update
	(f_md_2d_play 50 m14_01500 "johnson: williams, how are we looking on those power generators?")
	(f_md_2d_play 25 m14_01510 "williams: closing in on the last one. we lost robins and kimura... we'll make it happen.")
	(f_md_2d_play 0 m14_01520 "johnson: understood, lieutenant. do what you can.")
)

(script dormant vo_space_e11_dogfight
	(sleep_until (script_finished "vo_space_williams_update") 1)

	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play 30 m14_01410 "master chief: we have interceptors inbound.")
	(f_md_2d_play 0 m14_01420 "johnson: time to dance.")
	(mission_obj_burden_protect)
)

(global boolean b_harmony_look_check 0)
(global boolean b_prophet_escapes_vo_played 0)

(script dormant vo_space_prophet_escapes
	(set s_music_trigger_e30 370)
	(object_create ss_harmony_warp) ; create sound scenery object for harmony warp sfx

	(f_md_2d_play 0 m14_02250 "johnson: new target.")
	(sleep_until (= b_harmony_look_check 1) 1)
	(sleep (game_ticks_from_seconds 0.8))
	(f_md_2d_play 25 m14_02260 "master chief: that's a command shuttle.")
	(f_md_2d_play 30 m14_02270 "harmony: where i go, you cannot follow - your victory is but an illusion!")
	(f_md_2d_play 45 m14_02280 "harmony: i move not in fear, but in purpose.")
	(f_md_2d_play 15 m14_02290 "johnson: i can't get a lock.")
	(f_md_2d_play -5 m14_02300 "harmony: farewell, demon. may your despair echo in the void.")
	(sound_impulse_start sound\vehicles\tuning_fork\harmony_warp_out ss_harmony_warp 1)
	(sleep (game_ticks_from_seconds 1.25))
	(f_md_2d_play 0 m14_02310 "master chief: impulse drive signature.")

	(sleep_until (= b_harmony_vign_over 1) 1)

	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play 35 m14_02320 "johnson: damn it! we lost him!")
	(set s_music_trigger_e30 380)
	(f_md_2d_play 0 m14_02330 "master chief: for now. stay on mission.")
	(set b_prophet_escapes_vo_played 1)
	(object_destroy ss_harmony_warp) ; destroy sound scenery object for harmony warp sfx
)

(script dormant vo_space_kamikaze_destroyed_trigger
	(sleep_until (= 0 (ai_living_count sq_space3_e11_i_kamikaze)) 1)
	(wake vo_space_kamikaze_destroyed)
)

(script dormant vo_space_kamikaze_destroyed
	(f_md_2d_play 25 m14_02230 "master chief: targets neutralized.")
	(begin_random_count 1
		(f_md_2d_play 0 m14_01460 "johnson: phew! i take back every bad thing i've said about you, chief.")
		(f_md_2d_play 0 m14_02240 "johnson: tenacious bastards.")
	)
)

(global boolean b_tol_shield_look_check 0)

(script dormant vo_space_outro
	(sleep (game_ticks_from_seconds 2))
	(set s_music_trigger_e30 390)
	(f_md_2d_play 60 m14_01590 "williams: this is williams. the last generator is down.")
	(f_md_2d_play 15 m14_01660 "burden: we're locked. clear the target!")
	(f_md_2d_play 30 m14_01600 "johnson: just in time, el tee. big damn heroes, all of you.")
	(f_md_2d_play 60 m14_01610 "williams: appreciate it, sergeant major. name a building after us or something. i was thinking something like--")
)


;============================================================================
; music controller ========================================
;============================================================================

(global short s_music_trigger_e30 0)

(script dormant e30_music_controller
	(sleep_until (> s_music_trigger_e30 0) 1)
	(if (= s_music_trigger_e30 10) (begin (music_event sound/music/e30/mus_01_vista_room_encounter_start) (print "mus_01_vista_room_encounter_start")))

	(sleep_until (> s_music_trigger_e30 10) 1)
	(if (= s_music_trigger_e30 20) (begin (music_event sound/music/e30/mus_02_vista_room_encounter_end) (print "mus_02_vista_room_encounter_end")))

	(sleep_until (> s_music_trigger_e30 20) 1)
	(if (= s_music_trigger_e30 30) (begin (music_event sound/music/e30/mus_03_hydroponics_room_encounter_start) (print "mus_03_hydroponics_room_encounter_start")))

	(sleep_until (> s_music_trigger_e30 30) 1)
	(if (= s_music_trigger_e30 40) (begin (music_event sound/music/e30/mus_04_hydroponics_room_encounter_end) (print "mus_04_hydroponics_room_encounter_end")))

	(sleep_until (> s_music_trigger_e30 40) 1)
	(if (= s_music_trigger_e30 50) (begin (music_event sound/music/e30/mus_05_hunter_encounter_start) (print "mus_05_hunter_encounter_start")))

	(sleep_until (> s_music_trigger_e30 50) 1)
	(if (= s_music_trigger_e30 60) (begin (music_event sound/music/e30/mus_06_hunter_encounter_end) (print "mus_06_hunter_encounter_end")))

	(sleep_until (> s_music_trigger_e30 60) 1)
	(if (= s_music_trigger_e30 70) (begin (music_event sound/music/e30/mus_07_control_bridge_encounter_start) (print "mus_07_control_bridge_encounter_start")))

	(sleep_until (> s_music_trigger_e30 70) 1)
	(if (= s_music_trigger_e30 80) (begin (music_event sound/music/e30/mus_08_control_bridge_encounter_hunters_start) (print "mus_08_control_bridge_encounter_hunters_start")))

	(sleep_until (> s_music_trigger_e30 80) 1)
	(if (= s_music_trigger_e30 90) (begin (music_event sound/music/e30/mus_09_control_bridge_encounter_end) (print "mus_09_control_bridge_encounter_end")))

	(sleep_until (> s_music_trigger_e30 90) 1)
	(if (= s_music_trigger_e30 100) (begin (music_event sound/music/e30/mus_10_control_bridge_cinematic_start) (print "mus_10_control_bridge_cinematic_start")))

	(sleep_until (> s_music_trigger_e30 100) 1)
	(if (= s_music_trigger_e30 110) (begin (music_event sound/music/e30/mus_11_chapter_title_cyborg_justice_start) (print "mus_11_chapter_title_cyborg_justice_start")))

	(sleep_until (> s_music_trigger_e30 110) 1)
	(if (= s_music_trigger_e30 120) (begin (music_event sound/music/e30/mus_12_return_hydroponics_bridge_start) (print "mus_12_return_hydroponics_bridge_start")))

	(sleep_until (> s_music_trigger_e30 120) 1)
	(if (= s_music_trigger_e30 130) (begin (music_event sound/music/e30/mus_13_return_hydroponics_bridge_meetup) (print "mus_13_return_hydroponics_bridge_meetup")))

	(sleep_until (> s_music_trigger_e30 130) 1)
	(if (= s_music_trigger_e30 140) (begin (music_event sound/music/e30/mus_14_return_hydroponics_bridge_end) (print "mus_14_return_hydroponics_bridge_end")))

	(sleep_until (> s_music_trigger_e30 140) 1)
	(if (= s_music_trigger_e30 150) (begin (music_event sound/music/e30/mus_15_sneak_encounter_start) (print "mus_15_sneak_encounter_start")))

	(sleep_until (> s_music_trigger_e30 150) 1)
	(if (= s_music_trigger_e30 160) (begin (music_event sound/music/e30/mus_16_sneak_hunter_encounter_start) (print "mus_16_sneak_hunter_encounter_start")))

	(sleep_until (> s_music_trigger_e30 160) 1)
	(if (= s_music_trigger_e30 170) (begin (music_event sound/music/e30/mus_17_return_hunter_encounter_end) (print "mus_17_return_hunter_encounter_end")))

	(sleep_until (> s_music_trigger_e30 170) 1)
	(if (= s_music_trigger_e30 180) (begin (music_event sound/music/e30/mus_18_return_hunter_encounter_end_safety) (print "mus_18_return_hunter_encounter_end_safety")))

	(sleep_until (> s_music_trigger_e30 180) 1)
	(if (= s_music_trigger_e30 190) (begin (music_event sound/music/e30/mus_19_tram_encounter_start) (print "mus_19_tram_encounter_start")))

	; mus_20 removed from design

	(sleep_until (> s_music_trigger_e30 200) 1)
	(if (= s_music_trigger_e30 210) (begin (music_event sound/music/e30/mus_21_tram_stealth_elite_encounter_start) (print "mus_21_tram_stealth_elite_encounter_start")))

	(sleep_until (> s_music_trigger_e30 210) 1)
	(if (= s_music_trigger_e30 220) (begin (music_event sound/music/e30/mus_22_tram_brutes_wave_encounter_start) (print "mus_22_tram_brutes_wave_encounter_start")))

	(sleep_until (> s_music_trigger_e30 220) 1)
	(if (= s_music_trigger_e30 230) (begin (music_event sound/music/e30/mus_23_tram_brutes_wave_encounter_end) (print "mus_23_tram_brutes_wave_encounter_end")))

	(sleep_until (> s_music_trigger_e30 230) 1)
	(if (= s_music_trigger_e30 240) (begin (music_event sound/music/e30/mus_24_tram_ride_2_encounter_start) (print "mus_24_tram_ride_2_encounter_start")))

	(sleep_until (> s_music_trigger_e30 240) 1)
	(if (= s_music_trigger_e30 250) (begin (music_event sound/music/e30/mus_25_tram_ride_2_encounter_end) (print "mus_25_tram_ride_2_encounter_end")))

	(sleep_until (> s_music_trigger_e30 250) 1)
	(if (= s_music_trigger_e30 260) (begin (music_event sound/music/e30/mus_26_docking_bay_station_start) (print "mus_26_docking_bay_station_start")))

	(sleep_until (> s_music_trigger_e30 260) 1)
	(if (= s_music_trigger_e30 270) (begin (music_event sound/music/e30/mus_27_docking_bay_station_safety) (print "mus_27_docking_bay_station_safety")))

	(sleep_until (> s_music_trigger_e30 270) 1)
	(if (= s_music_trigger_e30 280) (begin (music_event sound/music/e30/mus_28_marine_cine_start) (print "mus_28_marine_cine_start")))

	(sleep_until (> s_music_trigger_e30 280) 1)
	(if (= s_music_trigger_e30 290) (begin (music_event sound/music/e30/mus_29_space_patrol_tutorial_encounter_start) (print "mus_29_space_patrol_tutorial_encounter_start")))

	(sleep_until (> s_music_trigger_e30 290) 1)
	(if (= s_music_trigger_e30 300) (begin (music_event sound/music/e30/mus_30_space_relay_node_encounter_start) (print "mus_30_space_relay_node_encounter_start")))

	(sleep_until (> s_music_trigger_e30 300) 1)
	(if (= s_music_trigger_e30 310) (begin (music_event sound/music/e30/mus_31_space_relay_nodes_encounter_end) (print "mus_31_space_relay_nodes_encounter_end")))

	(sleep_until (> s_music_trigger_e30 310) 1)
	(if (= s_music_trigger_e30 320) (begin (music_event sound/music/e30/mus_32_space_debris_field_encounter_start) (print "mus_32_space_debris_field_encounter_start")))

	(sleep_until (> s_music_trigger_e30 320) 1)
	(if (= s_music_trigger_e30 330) (begin (music_event sound/music/e30/mus_33_space_debris_field_encounter_end) (print "mus_33_space_debris_field_encounter_end")))

	(sleep_until (> s_music_trigger_e30 330) 1)
	(if (= s_music_trigger_e30 340) (begin (music_event sound/music/e30/mus_34_space_burden_arrival_encounter_start) (print "mus_34_space_burden_arrival_encounter_start")))

	(sleep_until (> s_music_trigger_e30 340) 1)
	(if (= s_music_trigger_e30 350) (begin (music_event sound/music/e30/mus_35_space_protect_burden_encounter_start) (print "mus_35_space_protect_burden_encounter_start")))

	(sleep_until (> s_music_trigger_e30 350) 1)
	(if (= s_music_trigger_e30 360) (begin (music_event sound/music/e30/mus_36_space_protect_burden_progression_continue) (print "mus_36_space_protect_burden_progression_continue")))

	(sleep_until (> s_music_trigger_e30 360) 1)
	(if (= s_music_trigger_e30 370) (begin (music_event sound/music/e30/mus_37_space_harmony_escapes_encounter) (print "mus_37_space_harmony_escapes_encounter")))

	(sleep_until (> s_music_trigger_e30 370) 1)
	(if (= s_music_trigger_e30 380) (begin (music_event sound/music/e30/mus_38_space_stay_on_mission_start) (print "mus_38_space_stay_on_mission_start")))

	(sleep_until (> s_music_trigger_e30 380) 1)
	(if (= s_music_trigger_e30 390) (begin (music_event sound/music/e30/mus_39_williams_death_encounter_start) (print "mus_39_williams_death_encounter_start")))

	(sleep_until (> s_music_trigger_e30 390) 1)
	(if (= s_music_trigger_e30 400) (begin (music_event sound/music/e30/mus_40_ending_cinematic_start) (print "mus_40_ending_cinematic_start")))
)

;============================================================================
; music beat 1 - to control room  ========================================
;============================================================================

; mus_01 set in vo_mission_intro
; mus_02 set in vo_hydro_vista

(script dormant music_hydro_entry_trigger
	(sleep_until (volume_test_players mus_hydro_entry_03) 1)
	(set s_music_trigger_e30 30)
)

(script dormant music_hydro_exit_trigger
	; mus_04 also set in e30.hsc/hydro_entry script if player clears encounter
	(sleep_until (volume_test_players mus_hydro_exit_04) 1)
	(if (< s_music_trigger_e30 39) (set s_music_trigger_e30 40))
)

; mus_05 set in vo_garden_hunters
; mus_06 set in vo_garden_hunters_outro
; mus_07 set in vo_control_intro
; mus_08 set in e30/hsc/control script
; mus_09 set in vo_control_outro

;============================================================================
; music beat 2 - away from control room  ======================
;============================================================================

; mus_10 set in e30.hsc/control and e30.hsc/ins_beat2_catch_up

(script dormant music_hydro_bridge_redux_trigger
	(sleep_until (volume_test_players mus_hydro_bridge_redux_12) 1)
	(set s_music_trigger_e30 120)
)

(script dormant music_hydro_meetup_trigger
	(sleep_until (volume_test_players mus_hydro_bridge_meetup_13) 1)
	(set s_music_trigger_e30 130)
)

; mus_14 set in vo_hydro_garden_return
; mus_15 set in vo_beat2_down_lift

;============================================================================
; music beat 3 - transit ==================================
;============================================================================

; mus_16 set in e30.hsc/e24_e25

(script dormant music_e24_e25_encounter_end
	(sleep_until (<= (ai_living_count gr_transit_e24_e25_h_station) 0) 1)
	(set s_music_trigger_e30 170)
)

; mus_18 set in e30.hsc/e24_e25
; mus_19 set in vo_transit_hydro_leaving
; mus_20 set in vo_transit_dome_stop
; mus_21 set in vo_transit_dome_switched
; mus_22 set in e30.hsc/e30
; mus_23 set in vo_transit_dome_powered
; mus_24 set in beat3_transit_progress_part_2
; mus_26 set in vo_hangar_gravlift

(script dormant music_docking_bay_station_safety
	(sleep_until (volume_test_players mus_bay_safety_27) 1)
	(set s_music_trigger_e30 270)
)

; mus_28 set in e30.hsc/begin_beat4

;============================================================================
; music beat 4 - space  ==================================================
;============================================================================

; mus_29 set in e30.hsc/begin_beat4
; mus_30 set in vo_space_relay_destroyed
; mus_31 set in vo_space_to_debris


(script dormant music_space_relay_destroyed_30
	(sleep_until (>= s_relays_destroyed 1) 1)
	(set s_music_trigger_e30 300)
)

; mus_32 set in vo_space_marines_escape
; mus_33 set in vo_space_marines_saved
; mus_34 set in vo_space_burden_arrival
; mus_35 set in vo_space_kamikaze_incoming

(script dormant music_kamikaze_progression_36
	(sleep_until (= 0 (ai_living_count sq_space3_e11_d_kamikaze)) 1)
	(set s_music_trigger_e30 360)
)

; mus_36 set in vo_space_kamikaze_destroyed
; mus_37 set in vo_space_prophet_escapes
; mus_38 set in vo_space_prophet_escapes
; mus_39 set in vo_space_generators_down
; mus_40 set in e30_game_won
