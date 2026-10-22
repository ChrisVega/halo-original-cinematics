; ================== mission dialogue vo ==================

(global boolean b_player_awake false)

(script dormant dialogue_intro
	(sleep_until (= (cinematic_in_progress) false) 1)
	(if (< conversation_id 1) (set conversation_id 1))
	(branch (> conversation_id 1) (f_md_abort))

	(sleep (game_ticks_from_seconds 3))
	(f_md_2d_play_cortana 25 m02_00040 "cortana: chief? chief! can you hear me?")
	(set b_player_awake true)

	(f_md_2d_play_cortana 0 m02_00050 "cortana: at last! are you alright? can you move? ")

	(sleep_until (not (volume_test_players lz_lifeboat)) 1)

	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 0 m02_00060 "cortana: the others…the impact...there's nothing we can do.")
)

(script dormant dialogue_lz_warning
	(if (< conversation_id 2) (set conversation_id 2))
	(branch	(> conversation_id 2) (f_md_abort))

	(sleep (game_ticks_from_seconds 1.5))
	(set s_music_trigger 20)
	(f_md_2d_play_cortana 0 m02_00110 "cortana: alert: covenant dropship inbound! they must be looking for survivors. i recommend immediate evasion.")
	(if (and
			(< s_navpoint_index 1)
			(not (volume_test_players lz_ledge_safe))
			(not (volume_test_players lz_bridge))
		)
		(set s_navpoint_index 1)
	)
)

(script dormant dialogue_banshee_spawn1
	(sleep_until
		(or
			(volume_test_object lz_ledge_sky lz_banshee_pilot_1)
			(volume_test_object lz_ledge_sky lz_banshee_pilot_2)
		)
	1)

	(f_md_2d_play_cortana 0 m02_00100 "cortana: warning: i've detected incoming banshee fighters!")
)

(script dormant dialogue_lz_dawdle
	(branch (>= conversation_id 3) (f_md_abort)) ; abort when arriving at first beam tower

	(f_md_dawdle_play 0 m02_00090 "cortana: we should evacuate the area and find other survivors before covenant search teams arrive." 2)
)

(script dormant dialogue_approach_waterfall
	(sleep_until (and (volume_test_players lz_waterfall_vo_trigger) (game_safe_to_save) (not b_is_dialogue_playing)) 1)

	(f_md_2d_play_cortana 60 m02_00670 "cortana: interesting. the ring supports wildlife. the builders must possess incredible terraforming technology.")
	(f_md_2d_play_cortana 0 m02_00680 "cortana: i'm reading thousands of types of flora. the ring's ecosystem is incredibly sophisticated")
)

; ================== tower ==================

(script dormant dialogue_first_arrival
	(sleep_until (volume_test_players first_arrival_vo_trigger) 1)

	(if (< conversation_id 3) (set conversation_id 3))
	(if (< s_music_trigger 30) (set s_music_trigger 30))

	(f_md_2d_play_cortana 15 m02_00120 "cortana: i'm reading a lifeboat beacon over the next hill. we should check to see if there are any survivors.")
	(set global_first_marines_nav true)

	(f_md_2d_play 0 m02_00130 "johnson: cortana? great to hear your voice again! we're pinned down by a large covenant force. we would appreciate any assistance!")
	(set mark_protect true)

)

(script dormant dialogue_first_wave_1_defeated_johnson
	(ai_dialogue_enable false)
	(f_md_3d_play -15 first_marine_fitzgerald m02_00180 "fitzgerald: good to see you, sir! i thought we were the only ones who made it off the pillar of autumn.")
	(f_md_3d_play 5 first_marine_bisenti m02_00170 "bisenti: good to see you, sir! welcome to the party.")
	(f_md_3d_play 0 first_marine_johnson m02_00190 "johnson: it's a mess, sir. we're scattered all over this valley. we called for evac, but until you showed up i thought we were cooked.")
	(f_md_2d_play_cortana 0 m02_00200 "cortana: don't worry, sergeant, we'll stay here until evac arrives.")
	(ai_dialogue_enable true)
)

(script dormant dialogue_first_wave_2
	(set s_music_trigger 40)
	(sleep (game_ticks_from_seconds 2.5))
	(f_md_2d_play_cortana 0 m02_00140 "cortana: warning: i have detected multiple covenant dropships on approach.")
	(if (> (ai_living_count first_marine_bisenti) 0)
		(begin
			(ai_dialogue_enable false)
			(sleep (game_ticks_from_seconds 2.5))
			(f_md_2d_play 15 m02_00220 "bisenti: heads up! i've got a covenant dropship headin' in! over here!")
			(set b_first_wave_2_calledout true)
			(sleep_until global_first_wave_2 1)
			(f_md_2d_play 0 m02_00230 "bisenti: oh, man…they're everywhere! ")
			(ai_dialogue_enable true)
		)
	)
)

(script dormant dialogue_first_wave_4
	(set b_first_wave_4_calledout true)
	(f_md_2d_play 15 m02_00240 "bisenti: uh oh! another bandit droppin' in behind us! they're tryin' to flank us!")
	(sleep_until global_first_wave_4 1)
	(f_md_2d_play 0 m02_00250 "mendoza: uh, we may have a problem here…these bastards are everywhere.")
)

(script dormant dialogue_first_wave_6
	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play 0 m02_00260 "echo 419: this is pelican echo-419. anybody reading me? repeat: any unsc personnel respond!")
	(f_md_2d_play_cortana 15 m02_00270 "cortana: roger echo-419:  this is fireteam charlie. we read you. is that you foehammer?")
	(f_md_2d_play 0 m02_00280 "echo 419: roger, fireteam charlie. good to hear from you. ")
	(f_md_2d_play 0 m02_00290 "echo 419: i'm on my way.")
)

(script dormant dialogue_escape_pods
	(branch (vehicle_test_seat_unit_list jeep_global "" (players)) (f_md_skip_next))

	(if (< conversation_id 4) (set conversation_id 4))

	(sound_impulse_start sound\dialog\combat\mendoza\default\13_script\a30_look first_marine_mendoza 1) ; mendoza: mira mira!
	(print "mendoza: mira mira")
	(sleep (game_ticks_from_seconds 0.5))
	(sound_impulse_start sound\dialog\combat\bisenti\default\13_script\a30_look first_marine_bisenti 1) ; bisenti: heads up!
	(print "bisenti: heads up")
	(sleep (game_ticks_from_seconds 0.5))

	(f_md_2d_play_cortana 15 m02_00300 "cortana: look! more lifeboats! they're coming in fast.")
	(f_md_2d_play_cortana 30 m02_00310 "cortana: if those lifeboats make it down, the covenant are going to be right on top of them!")
	(f_md_2d_play_cortana 10 m02_00320 "cortana: foehammer, we need you to disengage your warthog. the master chief and i are going to see if we can save some soldiers.")
	(f_md_2d_play 15 m02_00330 "echo 419: roger, cortana.")
	(f_md_2d_play_cortana 10 m02_00340 "cortana: the master chief and i need some back up. can you spare a few men?")
	(f_md_3d_play 0 first_marine_johnson m02_00350 "johnson: sure, cortana. all right, ladies: volunteers step up, on the double!  the rest of you get to the dropship!")
)

(script dormant dialogue_first_evac_1
	(branch (vehicle_test_seat_unit_list jeep_global "" (players)) (f_md_skip_next))

	(sleep_until (script_finished "dialogue_escape_pods") 1)

	(f_md_2d_play 20 m02_00380 "echo 419: okay, charlie team: warthog deployed. saddle up…and give 'em hell. ")
	(f_md_2d_play_cortana 25 m02_00390 "cortana: roger, foehammer. stand by to evac survivors and transport them to safety.")
	(f_md_2d_play 0 m02_00400 "echo 419: that's affirmative. echo-419 staying on station. foehammer out.")

	(wake dialogue_cave_no_jeep) ; triggers dawdle line if player doesn't get into jeep
)

(script dormant dialogue_cave_no_jeep
	(branch (vehicle_test_seat_unit_list jeep_global "" (players)) (f_md_abort))
	(f_md_dawdle_play 0 m02_00420 "cortana: we need that warthog if we want to get to the other lifeboats in time…" 3)
)

(script dormant dialogue_holdout1_failing
	(branch global_first_end (f_md_abort))
	(sleep_until
		(or
			(< (ai_living_count sq_gr_first_marine) 1)
			(volume_test_players come_back_h1_1)
			(volume_test_players come_back_h1_2)
		)
	1)

	(f_md_2d_play_cortana 0 m02_00700 "cortana: i recommend that we stay near the tower and wait for extraction.")
)

(script dormant dialogue_entered_warthog
	(sleep_until (vehicle_test_seat_unit_list jeep_global "" (players)) 1)

	(if (< conversation_id 5)(set conversation_id 5))
	(branch (> conversation_id 5) (f_md_skip_next))

	(set s_music_trigger 110)
	(f_md_2d_play_cortana 45 m02_00410 "cortana: survivors will probably stick close to their emergency beacons.  we need to find where the lifeboats landed.")
	(f_md_2d_play_cortana 0 m02_09030 "cortana: my topographical scans indicate a subterranean passage nearby. it looks like our best route out of this valley.")
)

(script dormant dialogue_cave_entrance
	(sleep_until (volume_test_players cave_entrance_vo_trigger) 1)

	(if (< conversation_id 6)(set conversation_id 6))
	(branch (> conversation_id 6) (f_md_skip_next))

	(f_md_2d_play_cortana 60 m02_00450 "cortana: this cave is not a natural formation. someone built it…so it must lead somewhere.")
	(f_md_2d_play_cortana 60 m02_00430 "cortana: i've hacked into the covenant battle network. they're actually broadcasting tactical data on unencrypted channels. we should show them who they're dealing with. master chief: i'm going to use your suit's transcom-system to monitor their chatter. ")
	(f_md_2d_play_cortana 0 m02_00440 "cortana: this lapse in their security is promising. i should be able to analyze their defensive systems. i'll alert you when i find something of interest.")
)

(script dormant dialogue_cave_bridge_prompt
	(branch (= (device_get_position bridge_control) 1) (f_md_abort))

	(sleep_until
		(and
			(volume_test_players bridge_chasm_vo_trigger)
			(< (device_get_position bridge_control) 1) ; bridge is not on
		)
	1)
	
	(if (< conversation_id 7) (set conversation_id 7))

	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 0 m02_00460 "cortana: there must be some mechanism to cross this chasm. look for a control panel or switch.")
	(set mark_controls true)
)

(script dormant dialogue_light_bridge_controls
	(branch (= (device_get_position bridge_control) 1) (f_md_abort))

	(sleep_until (>= 0.3 (ai_living_fraction sq_gr_cave_floor_fat)) 1)
	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play_cortana 0 m02_09040 "cortana: i've located the bridge controls. they're on that ledge.")
	(set global_cave_control_hint true)
)

(script dormant dialogue_second_driving
	(f_md_2d_play_cortana 0 m02_00470 "cortana: there's new traffic on the covenant battle network…a lot more crew made it off the autumn than i had predicted. the captain really gave them hell. if we can find captain keyes and the other survivors, we have a chance to coordinate an effective resistance.")
)

; ================== holdouts ==================

(script dormant dialogue_holdouts_spotted
	(if b_warthog_delivery
		(begin ; if warthog is delivered
			(sleep (game_ticks_from_seconds 2))
			(f_md_2d_play_cortana 15 m02_09230 "cortana: cortana to echo-419. we need another warthog at our position.")
			(f_md_2d_play 500 m02_00790 "echo 419: roger that. i'm on my way.")
			(f_md_2d_play 0 m02_00490 "echo 419: i've spotted additional lifeboats in your area.")
			(f_md_2d_play 0 m02_00500 "echo 419: one near a rock slide.")
			(set s_callout 1)
			(f_md_2d_play 0 m02_00510 "echo 419: one near the cliff edge.")
			(set s_callout 2)
			(f_md_2d_play 0 m02_00520 "echo 419: ...and another near the head of the river.")
			(set s_callout 3)
			(f_md_2d_play 0 m02_00530 "echo 419: hard to see from my altitude, but it looks like there are more survivors.")
			(f_md_2d_play_cortana 0 m02_00540 "cortana: acknowledged. we're on our way.")
		)
		(begin ; if no warthog delivered
			(f_md_2d_play 0 m02_00480 "echo 419: echo-419 to cortana. come in. ")
			(f_md_2d_play 0 m02_00490 "echo 419: i've spotted additional lifeboats in your area.")
			(f_md_2d_play 0 m02_00500 "echo 419: one near a rock slide.")
			(set s_callout 1)
			(f_md_2d_play 0 m02_00510 "echo 419: one near the cliff edge.")
			(set s_callout 2)
			(f_md_2d_play 0 m02_00520 "echo 419: ...and another near the head of the river.")
			(set s_callout 3)
			(f_md_2d_play 0 m02_00530 "echo 419: hard to see from my altitude, but it looks like there are more survivors.")
			(f_md_2d_play_cortana 0 m02_00540 "cortana: acknowledged. we're on our way.")
		)
	)
)

(script dormant dialogue_marine_signal
	(sleep_until
		(or
			(volume_test_players midrubble_1_trigger)
			(volume_test_players cliff_2)
			(volume_test_players followers_connector_to_holdouts_obj_switch1)
			(volume_test_players midriver_1_trigger)
		)
	1)

	(f_md_2d_play_cortana 0 m02_09080 "cortana: i'm detecting marine iff signals beyond that marker.")
)

; ================== rubble ==================

(script dormant dialogue_rubble_arrival
	(sleep_until (volume_test_players rubble_arrival) 1)
	(f_md_2d_play_cortana 0 m02_00550 "cortana: survivors detected. marines are concealed in those rocks. ")
	(cond
		(b_holdout3_start (set s_music_trigger 220))
		(b_holdout2_start (set s_music_trigger 200))
		(b_holdout1_start (set s_music_trigger 180))
	)
	(sleep_until (volume_test_players rubble_jackal) 1)
	(f_md_2d_play_cortana 0 m02_09090 "cortana: alert! there are jackal snipers on the high ground. i recommend you stay out of their line of fire.")
)

(script dormant dialogue_rubble_sniper
	(sleep_until (>= 2 (objects_distance_to_object (players) sq_holdout_rubble_marine_sniper)) 1)
	(f_md_3d_play 0 sq_holdout_rubble_marine_sniper m02_00560 "fitzgerald: i think i got a few of those covenant bastards…but i'm hit. take my sniper rifle, sir. ")
)

; ================== cliff ==================

(script dormant dialogue_cliff_prompt
	(sleep_until
		(or
			(and (< (ai_living_fraction enc_holdout_cliffside_cov) .85) (volume_test_players cliff_topside))
			(volume_test_players cliff_marine_entrance_1)
			(volume_test_players cliff_marine_entrance_2)
		)
	1)

	(wake cliff_undertower_entrance_navpoints)
	(f_md_2d_play_cortana 0 m02_09110 "cortana: survivors detected beneath that tower! let's find a way down.")
	(cond
		(b_holdout3_start (set s_music_trigger 220))
		(b_holdout2_start (set s_music_trigger 200))
		(b_holdout1_start (set s_music_trigger 180))
	)
)

(script dormant dialogue_cliff_dawdle_prompt
	(branch
		(or
			(= 0 (ai_living_count enc_holdout_cliffside_marine))
			(volume_test_players cliff_dawdle_prompt_1)
			(volume_test_players cliff_dawdle_prompt_2)
		)
		(f_md_abort)
	)
	(f_md_dawdle_play 0 m02_00620 "cortana: we should search the interior of those structures before we leave." 3)
)

; ================== river ==================

(script dormant dialogue_river_arrival
	(sleep_until (volume_test_players river_arrival) 1)
	(f_md_2d_play_cortana 0 m02_00590 "cortana: there are some marines hiding in the hills above the structure.")
	(cond
		(b_holdout3_start (set s_music_trigger 220))
		(b_holdout2_start (set s_music_trigger 200))
		(b_holdout1_start (set s_music_trigger 180))
	)
)

; ================== holdout endings ==================

(script static void dialogue_abandon
	(if (> (list_count (players)) 0) ; ensures player has not died - putting logic check in here as doing it in the _abandon scripts still triggered it due to checkpointing
		(begin_random_count 1
			(f_md_2d_play_cortana 0 m02_00820 "cortana: we can't leave yet. we need to wait for the dropship.")
			(f_md_2d_play_cortana 0 m02_00830 "cortana: we should secure the area before the dropship arrives.")
			(f_md_2d_play_cortana 0 m02_00840 "cortana: where are you going? we can't abandon those marines! we need to stay near the rv point until foehammer arrives.")
			(f_md_2d_play_cortana 0 m02_00850 "cortana: we shouldn't just leave them there…")
			(f_md_2d_play_cortana 0 m02_00860 "cortana: stop.  we need to stay here with the marines until evac arrives.")
		)
	)
)


(script static void dialogue_all_dead
	(begin_random_count 1
		(f_md_2d_play_cortana 100 m02_00770 "cortana:  we couldn't save them.")
		(f_md_2d_play_cortana 100 m02_00890 "cortana: they're all…dead. we didn't save them.")
		(f_md_2d_play_cortana 100 m02_00910 "cortana: no survivors, master chief. ")
	)
)

(script dormant dialogue_reunion_tour_finished_1
	(if
		(or ; ensures there are surviving marines in the holdout
			(and global_river_end (not global_river_all_killed))
			(and global_cliff_end (not global_cliff_all_killed))
			(and global_rubble_end (not global_rubble_all_killed))
		)
		(begin
			(f_md_2d_play_cortana 15 m02_00570 "cortana: stand by, marines. i've called echo-419 for evac. we should dust-off shortly.")
			(f_md_2d_play 0 m02_00580 "stacker: roger that. marines, assemble for evac, pronto!")
		)
	)
)

(script dormant dialogue_reunion_tour_finished_1_exit
	(f_md_2d_play_cortana 100 m02_00720 "cortana: interesting. the word on the covenant battle net is find and expunge the putrid apes. sounds like we made quite an impression.")
	(f_md_2d_play_cortana 0 m02_00730 "cortana: we need to find the other two lifeboats.")
	(set s_navpoint_index 8)
)

(script dormant dialogue_reunion_tour_finished_2
	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play_cortana 0 m02_00740 "cortana: i've located the final lifeboat, i'll give you a navpoint to the beacon.")
	(set s_navpoint_index 9)
	(sleep (game_ticks_from_seconds 5))
	(f_md_2d_play_cortana 0 m02_00760 "cortana: warning: i've picked up reports that the covenant has located and secured the pillar of autumn's crash site. [pause] the good news is the captain is still alive. the bad news is that the covenant have captured the entire surviving command crew.")
)

(script dormant dialogue_third_reunion_tour_complete
	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play_cortana 30 m02_00780 "cortana: that's the last of them.")
	(f_md_2d_play 0 m02_00790 "echo 419: roger that. i'm on my way.")
)

;====================================================================================================================================================================================================
; music ==============================================================================================================================================
;====================================================================================================================================================================================================

(global short s_music_trigger 0)
(global boolean b_holdout1_start false)
(global boolean b_holdout2_start false)
(global boolean b_holdout3_start false)

(script dormant music_a30
	(sleep_until (> s_music_trigger 19) 1)
	(if (= s_music_trigger 20) (begin (music_event sound/music/a30/mus_02_crash_site_encounter_start) (print "mus_02_crash_site_encounter_start")))

	(sleep_until (> s_music_trigger 20) 1)
	(if (= s_music_trigger 30) (begin (music_event sound/music/a30/mus_03_crash_site_encounter_clear) (print "mus_03_crash_site_encounter_clear")))

	(sleep_until (> s_music_trigger 30) 1)
	(if (= s_music_trigger 40) (begin (music_event sound/music/a30/mus_04_beam_tower_encounter_start) (print "mus_04_beam_tower_encounter_start")))

	(sleep_until (> s_music_trigger 50) 1)
	(if (= s_music_trigger 60) (begin (music_event sound/music/a30/mus_06_beam_tower_encounter_wave_2) (print "mus_06_beam_tower_encounter_wave_2")))

	(sleep_until (> s_music_trigger 60) 1)
	(if (= s_music_trigger 70) (begin (music_event sound/music/a30/mus_07_beam_tower_encounter_wave_3) (print "mus_07_beam_tower_encounter_wave_3")))

	(sleep_until (> s_music_trigger 70) 1)
	(if (= s_music_trigger 80) (begin (music_event sound/music/a30/mus_08_beam_tower_encounter_wave_4) (print "mus_08_beam_tower_encounter_wave_4")))

	(sleep_until (> s_music_trigger 80) 1)
	(if (= s_music_trigger 90) (begin (music_event sound/music/a30/mus_09_beam_tower_encounter_wave_5) (print "mus_09_beam_tower_encounter_wave_5")))

	(sleep_until (> s_music_trigger 90) 1)
	(if (= s_music_trigger 100) (begin (music_event sound/music/a30/mus_10_beam_tower_encounter_clear) (print "mus_10_beam_tower_encounter_clear")))

	(sleep_until (> s_music_trigger 100) 1)
	(if (= s_music_trigger 110) (begin (music_event sound/music/a30/mus_11_warthog_training_start) (print "mus_11_warthog_training_start")))

	(sleep_until (> s_music_trigger 110) 1)
	(if (= s_music_trigger 120) (begin (music_event sound/music/a30/mus_12_lightbridge_room_enter) (print "mus_12_lightbridge_room_enter")))

	(sleep_until (> s_music_trigger 120) 1)
	(if (= s_music_trigger 130) (begin (music_event sound/music/a30/mus_13_lightbridge_room_elite_ambush) (print "mus_13_lightbridge_room_elite_ambush")))

	(sleep_until (> s_music_trigger 130) 1)
	(if (= s_music_trigger 140) (begin (music_event sound/music/a30/mus_14_lightbridge_activate) (print "mus_14_lightbridge_activate")))

	(sleep_until (> s_music_trigger 140) 1)
	(if (= s_music_trigger 150) (begin (music_event sound/music/a30/mus_15_lightbridge_room_exit) (print "mus_15_lightbridge_room_exit")))

	; mus_16 cut

	(sleep_until (> s_music_trigger 160) 1)
	(if (= s_music_trigger 170) (begin (music_event sound/music/a30/mus_17_reunion_tour_chapter) (print "mus_17_reunion_tour_chapter")))

	(sleep_until (> s_music_trigger 170) 1)
	(if (= s_music_trigger 180) (begin (music_event sound/music/a30/mus_18_holdout_1_start) (print "mus_18_holdout_1_start")))

	(sleep_until (> s_music_trigger 180) 1)
	(if (= s_music_trigger 190) (begin (music_event sound/music/a30/mus_19_holdout_1_end) (print "mus_19_holdout_1_end")))

	(sleep_until (> s_music_trigger 190) 1)
	(if (= s_music_trigger 200) (begin (music_event sound/music/a30/mus_20_holdout_2_start) (print "mus_20_holdout_2_start")))

	(sleep_until (> s_music_trigger 200) 1)
	(if (= s_music_trigger 210) (begin (music_event sound/music/a30/mus_21_holdout_2_end) (print "mus_21_holdout_2_end")))

	(sleep_until (> s_music_trigger 210) 1)
	(if (= s_music_trigger 220) (begin (music_event sound/music/a30/mus_22_holdout_3_start) (print "mus_22_holdout_3_start")))

	(sleep_until (> s_music_trigger 220) 1)
	(if (= s_music_trigger 230) (begin (music_event sound/music/a30/mus_23_holdout_3_end) (print "mus_23_holdout_3_end")))
)

(script dormant music_a30_triggers_holdouts
	(sleep_until
		(or global_cliff_start global_rubble_start global_river_start)
	1)
	(set b_holdout1_start true)
	; mus_18 triggered in each holdout begin dialogue scripts

	(sleep_until
		(or global_cliff_end global_rubble_end global_river_end)
	1)
	(set s_music_trigger 190)

	(sleep_until
		(or
			(and global_cliff_end (or global_river_start global_rubble_start))
			(and global_river_end (or global_cliff_start global_rubble_start))
			(and global_rubble_end (or global_cliff_start global_river_start))
		)
	1)
	(set b_holdout2_start true)
	; mus_20 triggered in each holdout end dialogue scripts

	(sleep_until
		(or
			(and global_cliff_end global_river_end)
			(and global_cliff_end global_rubble_end)
			(and global_rubble_end global_river_end)
		)
	1)
	(set s_music_trigger 210)

	(sleep_until
		(or
			(and global_cliff_end global_river_end global_rubble_start)
			(and global_cliff_end global_rubble_end global_river_start)
			(and global_rubble_end global_river_end global_cliff_start)
		)
	1)
	(set b_holdout3_start true)
	; mus_22 triggered in each holdout end dialogue scripts

	(sleep_until (and global_cliff_end global_river_end global_rubble_end) 1)
	(set s_music_trigger 230)
)
