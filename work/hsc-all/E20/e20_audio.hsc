;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;================================================== e20 - vo ========================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
;================================================== beat 1 =========================================================================================================================================
;====================================================================================================================================================================================================

(global short s_conversation_id 0)

(script dormant vo_eye_intro

	(sleep_until (= (cinematic_in_progress) false) 1) ; double check to ensure cinematic is over

	(object_create ss_eye_emitter_intro)
	(print "eye: ekumpekee dapempup.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_01620_harmony ss_eye_emitter_intro 1)
	(sleep (+ (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_01620_harmony) (game_ticks_from_seconds 0.8)))
	(f_md_3d_play 0 ai_johnson m13_01610 "johnson: well, that doesn't look friendly.")

	(ai_actor_dialogue_enable ai_johnson 1) ; re-enables johnson chatter that was disabled at spawn_buddy_johnson ins_e20_start

	(wake vo_level_start_dawdle)
	(object_destroy ss_eye_emitter_intro)
)

(script dormant vo_level_start_dawdle
	; slept forever in e20.hsc/trigger_vo_settlement_start
	(sleep_until
		(begin
			(if (game_safe_to_save)
				(begin
					(begin_random_count 1
						(f_md_2d_play 15 m13_02530 "mc: another signal burst. i have a lock with my transcom system.")
						(f_md_2d_play 15 m13_00620 "mc: i've got a lock on the signal.")
					)
    				(f_md_3d_play 0 ai_johnson m13_00630 "johnson: then let's hop to it!")
				)
			)
			false
		)
	(game_ticks_from_seconds 90)) ; checks every 90 seconds

)

(script dormant vo_brute_bowl_end
	(if (< conversation_id 2) (set s_conversation_id 2))
	(branch
		(> s_conversation_id 2) (f_md_abort)
	)

	(f_md_3d_play 0 ai_johnson m13_01640 "johnson: we couldn't save 'em. let's move to the next signal.")
)

(script dormant vo_settlement_start
    (if (< conversation_id 3) (set s_conversation_id 3))
	(branch
		(> s_conversation_id 3) (f_md_abort)
	)

	(f_md_3d_play 30 ai_johnson m13_00650 "johnson: chief! up ahead!")
    (f_md_3d_play 0 ai_johnson m13_0651 "johnson: i'll be damned, chief! we got survivors!")
)

(global boolean b_head_into_settlement false)

(script dormant vo_settlement_williams1
	;play song "mus_06_walk_and_talk"
	(set s_music_trigger_e20 60)

	(if (< conversation_id 4) (set s_conversation_id 4))
	(branch
		(> s_conversation_id 4) (f_md_abort)
	)

	(sleep 5)
	(set b_head_into_settlement 1)
	(f_md_3d_play 0 ai_williams m13_01690 "williams: if we're gonna get outta this damn dome we're gonna have to go through its main facility. unfortunately, that also includes the brute kennels. they keep 'em caged and angry… expect a fight.")
	(sleep 30)
	(f_md_3d_play 5 ai_johnson m13_00960 "johnson: you have any idea what the covvies have going on here, lieutenant?")
	(f_md_3d_play 15 ai_williams m13_00970 "williams: they're hunting us.")
	(f_md_3d_play 60 ai_williams m13_00980 "williams: they captured our company before glassing promise, rounded us up and brought us here. they started releasing us into the dome, usually a few at a time. three-minute head start.")
	(f_md_3d_play 25 ai_williams m13_01650 "williams: so… what the hell are you doing on this ship? since that “stop you needed to make” obviously wasn't to rescue me and mine.")
	(f_md_3d_play 30 ai_johnson m13_01660 "johnson: afraid not. this ship is holding high-value data the brass hopes will let us strike back at the covenant.")
    (f_md_3d_play 5 ai_williams m13_01670 "williams: maybe burn some of their worlds for a change.")

)

(script dormant vo_williams_dawdle
	(sleep_until
		(begin
			(sleep_until (game_safe_to_save) 1)
			(begin_random_count 1 ; chooses one of these dawdle lines randomly
				(f_md_3d_play 0 ai_williams m13_00870 "williams: we don't have time for this, spartan. move your armored ass.")
				(f_md_3d_play 0 ai_williams m13_00880 "williams: any damn day, sergeant major. don't make me pull rank.")
				(f_md_3d_play 0 ai_williams m13_00890 "williams: the clock is ticking. we need to regroup, unlock the doors, and get the hell out of here.")
			)
			false
		)
	(game_ticks_from_seconds (* 60 3.5))) ; triggers reminder every 3.5 minutes
)

(script dormant vo_prison_exterior_battle_mid

	(sleep_forever vo_williams_dawdle) ; kills dawdle lines when player arrives at prison exterior
	(print "killing vo_williams_dawdle")

)

(script dormant vo_brute_ambush_start

	(if (< conversation_id 6) (set s_conversation_id 6))
	(branch
		(> s_conversation_id 6) (f_md_abort)
	)

	(f_md_3d_play 0 ai_williams m13_01700 "williams: careful, sergeant major! this looks like a trap!")

)

(script dormant vo_brute_ambush_fail

	(branch (> s_conversation_id 8) (f_md_abort))

	(f_md_3d_play 10 ai_williams m13_01710 "williams: i warned you, spartan!")

	(object_create ss_eye_emitter_brute_ambush)
	(print "eye: sirupu. kushpmiee.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_01750_harmony ss_eye_emitter_brute_ambush 1)
	(sleep (game_ticks_from_seconds 1.5))

    (f_md_3d_play 0 ai_williams m13_01760 "williams: that damn eye. more covenant are on the way!")

)


(script dormant vo_brute_ambush_puck

	(if (< conversation_id 8) (set s_conversation_id 8))
	(branch
		(> s_conversation_id 8) (f_md_abort)
	)

	(f_md_3d_play 0 ai_johnson m13_01720 "johnson: el tee, taking out those chest pucks will make them berserk!")
	(f_md_3d_play 30 ai_williams m13_01730 "williams: is that a good thing?!")
   	(f_md_2d_play 0 m13_01740 "mc: it is when they attack their own.")

)


(script dormant vo_brute_ambush_cleared

	(if (< conversation_id 9) (set s_conversation_id 9))
	(branch
		(> s_conversation_id 9) (f_md_abort)
	)

	(sleep (game_ticks_from_seconds 1))
	(f_md_3d_play 25 ai_williams m13_01770 "williams: even pr machines have some use after all. thanks for the assist.")

	(print "harmony: alas, i have my great work to complete. know that i am the axis upon which your destiny turns. until next time, heretics.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_01780_harmony ss_eye_emitter_brute_ambush 1)
	(sleep (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_01780_harmony))

	(print "eye: usump. kureku. pmeimepee.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_01790_harmony ss_eye_emitter_brute_ambush 1)
	(sleep (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_01790_harmony))
	(object_destroy ss_eye_emitter_brute_ambush)

  	(f_md_3d_play 0 ai_williams m13_01800 "williams: looks like something else caught their eye. let's hustle.")

)

(script dormant vo_jackal_jungle_intro

	(sound_impulse_start sound\dialog\combat\trooperfem1\default\07_respond\hail sq_jackal_jungle_marines 1)
	(sound_impulse_start sound\dialog\combat\trooperfem2\default\07_respond\hail sq_jackal_jungle_marines 1)

)

(script dormant vo_jackal_jungle_success

	(sleep (game_ticks_from_seconds 1))
	(begin_random_count 1
		(f_md_3d_play 0 ai_williams m13_02310 "williams: look at that - you spartans might come in handy after all!")
		(f_md_3d_play 0 ai_williams m13_02320 "williams: keep it up and you'll be wearing a cape in no time.")
		(f_md_3d_play 0 ai_williams m13_02330 "williams: i admit it. you made that look easy.")
		(f_md_3d_play 0 ai_williams m13_02340 "williams: solid work, spartan.")
	)
)

(script dormant vo_jackal_jungle_fail

	(sleep (game_ticks_from_seconds 1))
	(begin_random_count 1
		(f_md_3d_play 0 ai_williams m13_02350 "williams: tiger company deserved a better effort than this.")
		(f_md_3d_play 0 ai_williams m13_02360 "williams: gotta do better than that if we're gonna survive this.")
		(f_md_3d_play 0 ai_williams m13_02370 "wiliams: you can't do it all on your own, spartan.")
	)
)

(script dormant vo_prison_bridge_view

	(f_md_3d_play 0 ai_williams m13_01810 "williams: that's the place. they're on lockdown after we broke out.")
	;plays song "mus_09_bridge_start"
	(set s_music_trigger_e20 90)

)

(script dormant vo_prison_bridge_start

	(object_create ss_eye_emitter_prison)
	(print "harmony: ah. there you are. observe, demon: your struggle is ornamental. succeed or fall, it matters not.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_01630_harmony ss_eye_emitter_prison 1)
	(sleep (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_01630_harmony))

	(print "eye: ra'ishum. rimpuem.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_01820_harmony ss_eye_emitter_prison 1)
	(sleep (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_01820_harmony))

	(object_destroy ss_eye_emitter_prison)

)

(script dormant vo_prison_entry

	(ai_actor_dialogue_enable ai_johnson false) ; disables chatter for johnson
    (f_md_3d_play 25 ai_johnson m13_01830 "johnson: chief! give me cover and i'll crack the locks.")
    (f_md_3d_play 5 ai_williams m13_01840 "williams: we're exposed out here!")
    (f_md_3d_play 0 ai_johnson m13_01850 "johnson: you want fast or clean, lieutenant?")

)

(script dormant vo_prison_entry_hacked_no_marines

    (f_md_3d_play 10 ai_johnson m13_01860 "johnson: we're in!")
    (f_md_3d_play 0 ai_johnson m13_01890 "johnson: let's get inside. double time!")
	(sleep (game_ticks_from_seconds 1.5))
	(ai_actor_dialogue_enable ai_johnson true) ; re-enables chatter for johnson

)


;====================================================================================================================================================================================================
;================================================== beat 2 =========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant vo_prison_entry_interior

    (f_md_3d_play 0 ai_williams m13_01900 "williams: they didn't even clean up the mess we left on the way out. sloppy.")

)

(script dormant vo_observation_start

    (f_md_3d_play 0 ai_williams m13_01070 "williams: what the hell? we need to rescue those marines!")

)

(script dormant vo_marine_cells_start

	(f_md_3d_play 0 ai_williams m13_01168 "williams: damn. never wanted to see this again.")

)

(script dormant vo_marine_cells_environmental

	(sound_impulse_start sound\dialog\combat\trooper1\default\07_respond\hail sq_marine_cells_marines/marine0 1)
	(sleep (game_ticks_from_seconds 1))
	(sound_impulse_start sound\dialog\combat\sergeant2\default\07_respond\hail sq_marine_cells_marines/marine1 1)
	(sleep (game_ticks_from_seconds 0.8))
	(sound_impulse_start sound\dialog\combat\trooperfem1\default\07_respond\hail sq_marine_cells_marines/marine2 1)

)

(global boolean b_mcr_speech_starts false)
(global boolean b_mcr_lt_looks_at_mc false)
(global boolean b_mcr_sgt_looks_at_mc false)
(global boolean b_mcr_all_look_at_mc false)

(script dormant vo_marine_cells_rally

	(if (< s_conversation_id 10) (set s_conversation_id 10))

	(branch
		(> s_conversation_id 10) (f_md_abort)
	)

	(sleep (game_ticks_from_seconds 2))

	(set b_mcr_speech_starts 1)
    (f_md_3d_play 10 ai_johnson m13_01040 "johnson: i see that look! you're wondering if you've got the guts to fight after what you've been through.")
    (f_md_3d_play 45 ai_johnson m13_01050 "johnson: you think those covenant bastards broke you? hell no! you're unsc marines! you've endured the worst they've got, and you're still breathing.")
	(set b_mcr_lt_looks_at_mc 1)
	(f_md_3d_play 20 ai_williams m13_01020 "williams: not bad, spartan. i'm almost starting to believe the propaganda.")
	(set b_mcr_sgt_looks_at_mc 1)
    (f_md_3d_play 45 ai_johnson m13_01140 "johnson: (sighs) alright chief, what's next?")
	(set b_mcr_all_look_at_mc 1)

    (f_md_2d_play 0 m13_01150 "mc: we make them pay.")

	(set b_marine_cells_opened 1)

)

(script dormant vo_security_start
    (f_md_3d_play 0 ai_williams m13_01161 "williams: keep an eye out for extra supplies. gear adrift's a gift.")

)

(script dormant vo_armory_start

    (f_md_3d_play 0 ai_williams m13_01162 "williams: get strapped, we'll show these bastards the price for picking a fight with the unsc!")

	(sleep (game_ticks_from_seconds 5))
	(f_unblip_all)
	(f_blip_flag fl_armory_exit_blip 0)
	(device_set_power dm_covdoor_prison26 1)

)

(script dormant vo_brute_cells_doddle

	(sleep (game_ticks_from_seconds 1))
    (f_md_3d_play 25 ai_williams m13_01165 "williams: you never get used to the smell.")
    (f_md_3d_play 5 ai_johnson m13_01166 "johnson: what smell?")
    (f_md_3d_play 0 ai_williams m13_01167 "williams: you can't be seri--you know what, just nevermind.")

)

(script dormant vo_brute_cages_start
	(if (< conversation_id 12)(set s_conversation_id 12))
	(branch
		(> s_conversation_id 12) (f_md_abort)
	)

    (f_md_3d_play 30 ai_williams m13_01163 "williams: my god. are they packed for… shipping?")
    (f_md_3d_play 0 ai_johnson m13_01164 "johnson: all i see are more reasons to put a stop to whatever it is they're doing here.")

	(set b_shipping_line_end 1)

)

(script dormant vo_arena_start
	(set s_conversation_id 13)
	(object_create ss_eye_emitter_arena)

    (f_md_3d_play 0 ai_johnson m13_02410 "johnson: chief! i have eyes on a covenant hvt!")

	(f_blip_ai sq_arena_zealot 1)

    (f_md_3d_play 0 ai_williams m13_02420 "williams: that's the butcher of our marines!")

	(print "eye: pmichup. kupim. zus.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_01970_harmony ss_eye_emitter_arena 1)
	(sleep (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_01970_harmony))

	(print "harmony: defiance is a melody i have heard before. it ends, as all things do - in silence.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_01980_harmony ss_eye_emitter_arena 1)
	(sleep (+ (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_01980_harmony) 15))

    (f_md_3d_play 0 ai_johnson m13_01990 "johnson: yeah yeah yeah.")
	(object_destroy ss_eye_emitter_arena)

)

(script dormant vo_arena_marines_alive

	(f_md_3d_play 0 ai_johnson m13_01180 "johnson: that's right marines! you're the nightmare they wake up from!")

)

(global boolean b_arena_end_johnson_line false)

(script dormant vo_arena_end

	(sleep (game_ticks_from_seconds 1))
    (f_md_3d_play 0 ai_johnson m13_02000 "johnson: is that all you got?")

	(f_unblip_all)
	(f_blip_flag fl_arena_exit_blip 0)

	(set b_arena_end_johnson_line true)

)


;====================================================================================================================================================================================================
;================================================== beat 3 =========================================================================================================================================
;====================================================================================================================================================================================================

; unlocking the first bridge panel - enc 15
(script dormant vo_bridge_approach

    (f_md_3d_play 0 ai_williams m13_02010 "williams: that panel should activate the bridge.")

    (f_blip_flag navpoint_bridge_console_1 0)
	(device_set_power dc_bridge1_control 1)
)

(script dormant vo_bridge_first_gap
	(object_create ss_eye_emitter_bridge)

	(print "eye: rimpuem. rimshpmerp. ruwpumezu.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_02020_harmony ss_eye_emitter_bridge 1)
	(sleep (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_02020_harmony))

	(f_md_3d_play 5 ai_williams m13_02040 "williams: we have incoming! clear the covenant so we can move on!")
	(set mark_bridge true)

	(print "harmony: your defiance is a stain upon the path… yet even blemishes serve to reveal perfection.")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_02030_harmony ss_eye_emitter_bridge 1)
	(sleep (sound_impulse_time sound\scripted\vo_scr_m13dlc2\m13_02030_harmony))

	(object_destroy ss_eye_emitter_bridge)
)

(script dormant vo_bridge_start

	(sleep (game_ticks_from_seconds 1.5))

)

; unlocking the second bridge panel - enc 16
(script dormant vo_bridge_second_gap
	(f_unblip_all)
	(f_blip_flag navpoint_bridge_console_2 0)
	(device_set_power dc_bridge2_control 1)

	(sleep (game_ticks_from_seconds 1.8))
	(f_md_3d_play 5 ai_johnson m13_02050 "johnson: care to do the honors, chief?")
	(f_md_3d_play 5 ai_williams m13_02060 "williams: you think they made spartans to push buttons, sergeant major?")

)

(global boolean b_williams_makes_peace false)
(global boolean b_chief_always_had_peace false)

; before entering old arena
(script dormant vo_making_peace

	(sleep (game_ticks_from_seconds 1.5))
	(f_md_3d_play 45 ai_johnson m13_01240 "johnson: lieutenant, i know spartans and helljumpers have a history. but no matter what's happened in the past, we're on the same side in this war.")
	(set b_williams_makes_peace true)
	(f_md_3d_play 60 ai_williams m13_01260 "williams: marines like us used to be the heart and soul of the unsc, until we started playing second-fiddle to soldiers that were built instead of born.")
	(set b_chief_always_had_peace 1)
	(f_md_2d_play 35 m13_01280 "master chief: we can't change where we come from, only what we become.")
	(f_md_3d_play 0 ai_williams m13_01281 "williams: fair enough.")
	(set s_music_trigger_e20 230) ; plays mus_23_what_we_become
	(sleep (game_ticks_from_seconds 1.5))

)

;====================================================================================================================================================================================================
;================================================== beat 4 ==========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant vo_encounter_20_is_go

    (f_md_3d_play 15 ai_johnson m13_02070 "johnson: chief, take the flanks!")
    (f_md_3d_play 0 ai_williams m13_01300 "williams: did you see this coming, bastards?")
)

(script dormant vo_beat4_marine_spawn

	(sleep (game_ticks_from_seconds 1))
    (f_md_3d_play 0 ai_williams m13_02080 "williams: tiger company! converge on our position, pronto!")

)

; entering into encounter 23
(script dormant vo_entering_into_encounter_23

	(ai_actor_dialogue_enable ai_williams false)
	(ai_actor_dialogue_enable ai_johnson false)

	(sleep (game_ticks_from_seconds 1.5))
    (f_md_3d_play 45 ai_johnson m13_01570 "johnson: chief. you ever get tired of being the strong, almost-silent type?")
    (f_md_2d_play 0 m13_01580 "master chief: no.")
	(set s_music_trigger_e20 240)

	(sleep (game_ticks_from_seconds 2.5))
	(ai_actor_dialogue_enable ai_williams true)
	(ai_actor_dialogue_enable ai_johnson true)

)

; when the elite zealot appears in the final battle
(script dormant vo_command_hvt

	(sleep_until (= (ai_living_count sq_final_encounter_wv1_zealot) 1) 1)
	(set s_music_trigger_e20 260)

	(sleep (game_ticks_from_seconds 1.5))
    (f_md_3d_play 0 ai_johnson m13_02430 "johnson: hvt!")
	(f_blip_ai sq_final_encounter_wv1_zealot 1)
    (f_md_3d_play 0 ai_williams m13_02440 "williams: burn him down!")


)

; when elite zealot dies in the final battle
(script dormant vo_command_hvt_dead

    (f_md_3d_play 0 ai_williams m13_02450 "williams: covenant trash.")

)

; after the battle, when the zealot is dead
(script dormant vo_command_end

	(sleep_until (script_finished "vo_command_hvt_dead") 1)
	(sleep (game_ticks_from_seconds 1.5))
    (f_md_3d_play 0 ai_williams m13_02090 "williams: disable that power node.")

)

; after activating the controls - if any marines are still alive
(script dormant vo_activating_the_console
	(object_create ss_prophet_eye_final_arena)

	(print "harmony: you believe victory is yours? each breath you steal from my servants --")
	(sound_impulse_start sound\scripted\vo_scr_m13dlc2\m13_02110_harmony ss_prophet_eye_final_arena 1)
	(sleep (game_ticks_from_seconds 5.2))

	(sleep (game_ticks_from_seconds 2))
	(f_md_3d_play 30 ai_williams m13_02120 "williams: ah, sweet silence.")
	(f_md_2d_play 0 m13_01550 "johnson: rally at the exit, marines.")

	(object_destroy ss_prophet_eye_final_arena)

)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;================================================ e20 - music controller=======================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(global short s_music_trigger_e20 0)

(script dormant e20_music_controller
	(sleep_until (> s_music_trigger_e20 1) 1)
	(if (= s_music_trigger_e20 10) (begin (music_event sound/music/e20/mus_01_intro_cinematic) (print "mus_01_intro_cinematic")))

	(sleep_until (> s_music_trigger_e20 10) 1)
	(if (= s_music_trigger_e20 20) (begin (music_event sound/music/e20/mus_02_vacation_destination) (print "mus_02_vacation_destination")))

	(sleep_until (> s_music_trigger_e20 20) 1)
	(if (= s_music_trigger_e20 30) (begin (music_event sound/music/e20/mus_03_settlement_start) (print "mus_03_settlement_start")))

	(sleep_until (> s_music_trigger_e20 30) 1)
	(if (= s_music_trigger_e20 40) (begin (music_event sound/music/e20/mus_04_settlement_end) (print "mus_04_settlement_end")))

	(sleep_until (> s_music_trigger_e20 40) 1)
	(if (= s_music_trigger_e20 50) (begin (music_event sound/music/e20/mus_05_williams_cinematic) (print "mus_05_williams_cinematic")))

	(sleep_until (> s_music_trigger_e20 50) 1)
	(if (= s_music_trigger_e20 60) (begin (music_event sound/music/e20/mus_06_walk_and_talk) (print "mus_06_walk_and_talk")))

	(sleep_until (> s_music_trigger_e20 60) 1)
	(if (= s_music_trigger_e20 70) (begin (music_event sound/music/e20/mus_07_jackal_jungle_start) (print "mus_07_jackal_jungle_start")))

	(sleep_until (> s_music_trigger_e20 70) 1)
	(if (= s_music_trigger_e20 80) (begin (music_event sound/music/e20/mus_08_jackal_jungle_end) (print "mus_08_jackal_jungle_end")))

	(sleep_until (> s_music_trigger_e20 80) 1)
	(if (= s_music_trigger_e20 81) (begin (music_event sound/music/e20/mus_08a_jackal_jungle_end_alt) (print "mus_08a_jackal_jungle_end_alt")))

	(sleep_until (> s_music_trigger_e20 81) 1)
	(if (= s_music_trigger_e20 90) (begin (music_event sound/music/e20/mus_09_bridge_start) (print "mus_09_bridge_start")))

	(sleep_until (> s_music_trigger_e20 90) 1)
	(if (= s_music_trigger_e20 100) (begin (music_event sound/music/e20/mus_10_bridge_escalation) (print "mus_10_bridge_escalation")))

	(sleep_until (> s_music_trigger_e20 100) 1)
	(if (= s_music_trigger_e20 110) (begin (music_event sound/music/e20/mus_11_bridge_end) (print "mus_11_bridge_end")))

	(sleep_until (> s_music_trigger_e20 110) 1)
	(if (= s_music_trigger_e20 120) (begin (music_event sound/music/e20/mus_12_prison_intro) (print "mus_12_prison_intro")))

	(sleep_until (> s_music_trigger_e20 120) 1)
	(if (= s_music_trigger_e20 130) (begin (music_event sound/music/e20/mus_13_prisoners_dilemma) (print "mus_13_prisoners_dilemma")))

	(sleep_until (> s_music_trigger_e20 130) 1)
	(if (= s_music_trigger_e20 140) (begin (music_event sound/music/e20/mus_14_observation_start) (print "mus_14_observation_start")))

	(sleep_until (> s_music_trigger_e20 140) 1)
	(if (= s_music_trigger_e20 150) (begin (music_event sound/music/e20/mus_15_observation_end) (print "mus_15_observation_end")))

	(sleep_until (> s_music_trigger_e20 150) 1)
	(if (= s_music_trigger_e20 160) (begin (music_event sound/music/e20/mus_16_make_them_pay_start) (print "mus_16_make_them_pay_start")))

	(sleep_until (> s_music_trigger_e20 160) 1)
	(if (= s_music_trigger_e20 170) (begin (music_event sound/music/e20/mus_17_make_them_pay_escalation) (print "mus_17_make_them_pay_escalation")))

	(sleep_until (> s_music_trigger_e20 170) 1)
	(if (= s_music_trigger_e20 180) (begin (music_event sound/music/e20/mus_18_make_them_pay_end) (print "mus_18_make_them_pay_end")))

	(sleep_until (> s_music_trigger_e20 180) 1)
	(if (= s_music_trigger_e20 190) (begin (music_event sound/music/e20/mus_19_arena_start) (print "mus_19_arena_start")))

	(sleep_until (> s_music_trigger_e20 190) 1)
	(if (= s_music_trigger_e20 200) (begin (music_event sound/music/e20/mus_20_arena_end) (print "mus_20_arena_end")))

	(sleep_until (> s_music_trigger_e20 200) 1)
	(if (= s_music_trigger_e20 210) (begin (music_event sound/music/e20/mus_21_mind_the_gap_start) (print "mus_21_mind_the_gap_start")))

	(sleep_until (> s_music_trigger_e20 210) 1)
	(if (= s_music_trigger_e20 220) (begin (music_event sound/music/e20/mus_22_mind_the_gap_end) (print "mus_22_mind_the_gap_end")))

	(sleep_until (> s_music_trigger_e20 220) 1)
	(if (= s_music_trigger_e20 230) (begin (music_event sound/music/e20/mus_23_what_we_become) (print "mus_23_what_we_become")))

	(sleep_until (> s_music_trigger_e20 230) 1)
	(if (= s_music_trigger_e20 240) (begin (music_event sound/music/e20/mus_24_hunters_hunted_start) (print "mus_24_hunters_hunted_start")))

	(sleep_until (> s_music_trigger_e20 240) 1)
	(if (= s_music_trigger_e20 250) (begin (music_event sound/music/e20/mus_25_hunters_hunted_end) (print "mus_25_hunters_hunted_end")))

	(sleep_until (> s_music_trigger_e20 250) 1)
	(if (= s_music_trigger_e20 251) (begin (music_event sound/music/e20/mus_25a_control_wave_1) (print "mus_25a_control_wave_1")))

	(sleep_until (> s_music_trigger_e20 251) 1)
	(if (= s_music_trigger_e20 252) (begin (music_event sound/music/e20/mus_25b_control_wave_2) (print "mus_25b_control_wave_2")))

	(sleep_until (> s_music_trigger_e20 252) 1)
	(if (= s_music_trigger_e20 260) (begin (music_event sound/music/e20/mus_26_zealot_start) (print "mus_26_zealot_start")))

	(sleep_until (> s_music_trigger_e20 260) 1)
	(if (= s_music_trigger_e20 270) (begin (music_event sound/music/e20/mus_27_zealot_end) (print "mus_27_zealot_end")))

	(sleep_until (> s_music_trigger_e20 270) 1)
	(if (= s_music_trigger_e20 280) (begin (music_event sound/music/e20/mus_28_outro_cinematic) (print "mus_28_outro_cinematic")))
)

;====================================================================================================================================================================================================
;============================================= music - insertion points =========================================================================================================================================
;====================================================================================================================================================================================================

;;;insertion point 1 - start
(script dormant e20_music_triggers_ins_0
	(sleep_until (volume_test_players tv_dialogue_level_start) 1)
	(print "vacation destination music start")
	;plays song "mus_02_vacation_destination" at the start of the level
	(set s_music_trigger_e20 20)
)

;;;insertion point 2 - post settlement, before the brute ambush
;(script dormant e20_music_triggers_ins_1
	;(sleep_until (volume_test_players tv_settlement_end) 1)
	;(print "walk and talk music start")
	;;plays song "mus_06_walk_and_talk" at the start of insertion point 2
	;(set s_music_trigger_e20 60)
;)

;;;insertion point 3 - inside the prison entrance
(script dormant e20_music_triggers_ins_2
	(print "prison intro music start")
	;plays song "mus_12_prison_intro" at the start of insertion point 3
	(set s_music_trigger_e20 120)
)

;;;insertion point 4 - post arena hallway, right before the grav bridge
(script dormant e20_music_triggers_ins_3
	(sleep_until (volume_test_players tv_chapter_trigger_beat_three) 1)
	(print "mind the gap music start")
	;plays song "mus_21_mind_the_gap_start" at the start of insertion point 4
	(set s_music_trigger_e20 210)
)

;====================================================================================================================================================================================================
;================================================== music - beat 1 =========================================================================================================================================
;====================================================================================================================================================================================================

;settlement
(script dormant e20_music_triggers_settlement
	(sleep_until (volume_test_players tv_dialogue_settlement_start) 1)
	(print "settlement music start")
	;plays song "mus_03_settlement_start" at the start of settlement
	(set s_music_trigger_e20 30)

	(sleep_until (= (ai_living_count gr_settlement) 0) 1)
	(print "settlement music end")
	;trigger "mus_03_settlement_end" once all enemies at the settlement have perished
	(set s_music_trigger_e20 40)
)

;jackal jungle
(script dormant e20_music_triggers_jackal_jungle
	(sleep_until (volume_test_players tv_jackal_jungle) 1)
	;plays song "mus_07_jackal_jungle_start" at the start of jackal jungle
	(set s_music_trigger_e20 70)

	(sleep_until (= (ai_living_count gr_jackal_jungle) 0) 1)
	(if (>= (ai_living_count gr_jackal_jungle_marines) 0)
		;then
		;trigger "mus_08a_jackal_jungle_end_alt" once all enemies and marines at the jackal jungle have perished
		(set s_music_trigger_e20 81)
	)

	(if (>= (ai_living_count gr_jackal_jungle_marines) 2)
		;then
		;trigger "mus_08a_jackal_jungle_end" once all enemies at the jackal jungle have perished and the marines are alive
		(set s_music_trigger_e20 80)
	)
)

;prison bridge/exterior
(script dormant e20_music_triggers_prison_bridge
	(sleep_until (volume_test_players tv_prison_exterior_start) 1)
	(sleep_until (= (ai_living_count gr_prison_ext_defend_door) 0) 1)
	;trigger "mus_10_bridge_escalation" once the spirit drops off reinforcements at the prison exterior
	(set s_music_trigger_e20 100)

	(sleep_until (= b_prison_door_hacked 1) 1)
	;plays song "mus_11_bridge_end" once all enemies are dead at the prison exterior
	(set s_music_trigger_e20 110)
)

;====================================================================================================================================================================================================
;================================================== music - beat 2 =========================================================================================================================================
;====================================================================================================================================================================================================

;observation top
(script dormant e20_music_triggers_observation_top
	(print "observation top music start")
	;plays song "mus_13_prisoners_dilemma" at the start of observation top
	(set s_music_trigger_e20 130)
)

;observation bottom
(script dormant e20_music_triggers_observation_bottom
	(sleep_until (volume_test_players tv_observation_bottom_music) 1)
	(print "observation bottom music start")
	;plays song "mus_14_observation_start" at the start of observation bottom
	(set s_music_trigger_e20 140)
)

;marine cells, security, and armory
(script dormant e20_music_triggers_marine_cells
	;(sleep_until (= b_johnson_speech_end 1) 1)
	;(sleep (game_ticks_from_seconds 4.5)) ;wait a bit so the song ends right as johnson's speech ends
	;(sleep_until (= b_johnson_speech_end 1) 1)
	(sleep_until (= (ai_living_count gr_observation_bottom_wave2) 0) 1)
	(print "observation bottom music end")
	;trigger song end "mus_15_observation_end"
	(set s_music_trigger_e20 150)

	(sleep_until (= b_marine_cells_opened 1) 1)
	(sleep (game_ticks_from_seconds 6)) ;give the music breathing room from chief's line
	(print "marine cells music start")
	;plays song "mus_16_make_them_pay_start" after releasing the marines. starts right after the "we make them pay" line.
	(set s_music_trigger_e20 160)

	(sleep_until (volume_test_players tv_large_hallway_unblip) 1)
	(print "marine cells music escalation")
	;plays song "mus_17_make_them_pay_escalation" once combat starts at the brute cells
	(set s_music_trigger_e20 170)

	(sleep_until (or
				(= b_brute_cells_exit_blip true)
				(volume_test_players tv_dialogue_arena_start)
				)
				1
	)
	(print "marine cells music end")
	;triggers "mus_18_make_them_pay_end" at hallway to pre-arena room
	(set s_music_trigger_e20 180)
)

;arena
(script dormant e20_music_triggers_arena
	(sleep_until (volume_test_players tv_dialogue_arena_start) 1)
	(print "arena music start")
	;plays song "mus_19_arena_start" at the start of the arena
	(set s_music_trigger_e20 190)

	(sleep_until (= (ai_living_count gr_arena) 0) 1)
	(print "arena music end")
	;trigger song end "mus_20_arena_end" once all enemeies in the arena are killed
	(set s_music_trigger_e20 200)
)

;====================================================================================================================================================================================================
;==========================================`======== music - beat 3 =========================================================================================================================================
;====================================================================================================================================================================================================

;grav bridge end
(script dormant e20_music_triggers_grav_bridge_end
	(print "grav bridge music start")
	;plays song "mus_21_mind_the_gap_start" at the start of the grav bridge
	(set s_music_trigger_e20 220)
)

;====================================================================================================================================================================================================
;================================================== music - beat 4 ==========================================================================================================================================
;====================================================================================================================================================================================================

;control exterior
(script dormant e20_music_triggers_old_arena
	(sleep_until (and b_control_exterior_spawn (= (ai_living_count gr_control_exterior) 0)) 1)
	(print "end current music")
	;triggers "mus_25_hunters_hunted_end"
	(set s_music_trigger_e20 250)
)

;control center end
(script dormant e20_music_triggers_control_end
	(sleep_until (= b_final_encounter_defeated 1) 1)
	(print "end final battle music")
	;starts song "mus_27_zealot_end"
	(set s_music_trigger_e20 270)
)
