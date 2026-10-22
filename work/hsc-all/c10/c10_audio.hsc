;====================================================================================================================================================================================================
; vo
;====================================================================================================================================================================================================

(global short s_crazy_marine_vo 0)

(script dormant play_vo_pelican_radio
	; delay custom duration after initial cutscene and play the first transmission.
	(sleep (game_ticks_from_seconds 4)) 			; silence cushion from intro cinematic
	(f_md_object_play 0 pelican_radio m06_00740)
	(print "victor 933: 'this is dropship victor 9(33 from (the starship)) pillar of autumn. if anyone can (read me i need) immediate assistance. we are (under heavy attack by some) new kind of hostile (alien that) isn't covenant. captain keyes has been captured by (hostiles). we're dug in at a large structure in a swampy (area, but i don't know how) long we can hold out. please send (assistance if you can read this transmission). i will set this message to repeat at one minute intervals. dropship victor 933 clear.")

	; message is set to repeat every 60 seconds, per the vo content.
	; loop until the flood reveal where swamp a access is cut off by the elevator
	; only play if the player in the hearing distance trigger volume.
	(sleep_until
		(begin
			(if (volume_test_players pelican_radio_trigger)
				(begin
					(f_md_object_play 0 pelican_radio m06_00740)
					(print "victor 933: 'this is dropship victor 9(33 from (the starship)) pillar of autumn. if anyone can (read me i need) immediate assistance. we are (under heavy attack by some) new kind of hostile (alien that) isn't covenant. captain keyes has been captured by (hostiles). we're dug in at a large structure in a swampy (area, but i don't know how) long we can hold out. please send (assistance if you can read this transmission). i will set this message to repeat at one minute intervals. dropship victor 933 clear.")
				)
				(begin
					; player out of range of pelican radio trigger, do not start vo loop and sleep for the audio duration instead.  this prevents the vo from playing immediately upon re-entry.
					(sleep (game_ticks_from_seconds 4))
				)
			)
			false
		)
		(game_ticks_from_seconds 60)
	)
)

(global boolean b_dubbo_intro_line_finished  false)
(script dormant play_vo_start_swamp_b
	(sleep_until (volume_test_players swamp_b_vo_trigger) 1)
	(f_md_2d_play 15 m06_00630 "echo 419: this is echo-419: chief is that you!?! i lost your signal when you disappeared inside the structure. what's going on down there? i'm tracking movement all over the place!")
)

(script dormant play_vo_marines
	(branch (ai_allegiance_broken human player) (f_md_abort)) ; aborts if the player betrays the marines

	(f_sleep_until_dubbo_should_approach)	; has its own manual delay before approach, set there so all 3 command scripts can benefit from it

	; give time to let dubbo get into position, then play line
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_3d_play 30 sq_swamp_bdubbo m06_00620 "dubbo: sir, thank god you're here! we've been lost out here for hours. after we lost contact with the rest of the mission we headed for the rv point and then these... things ambushed us. we need to get out of here!")
	(set b_dubbo_intro_line_finished true)
)

; this script blocks until the player is at the top of the lift and dubbo starts to move
; needs to be a helper so the two standing marines can react to dubbo's movements without an additional bool in the level script
(script static void f_sleep_until_dubbo_should_approach

	; sleep until the player is on the surface and the lift is all the way up
	(sleep_until
		(and
			(volume_test_players tv_player_on_surface_swamp_b)
			(= (device_get_position lift_d) 1)
		)
	1)

	; dubbo will stand and look at the players as they enter. this is a manual delay set by audio that determines how long he looks at you before moving
	; we want this sleep here so that all 3 marine command scripts get the same and the reactions look natural
	(sleep (game_ticks_from_seconds 1.5))
)

(script dormant play_vo_echo_extraction
	(sleep_until (or b_dubbo_intro_line_finished  (volume_test_players swamp_b_trigger_1)) 1) ; go when dubbo is finished, or when the player runs out of the room
	(f_md_2d_play 0 m06_00650 "echo 419: there's a large tower a few hundred meters from your current position. find a way above the fog and foliage canopy, and i can move in and pick you up.")
	(set s_music_trigger_c10 200)
	(set b_pick_up_destination_set true)
)

(script dormant play_vo_tower_backtrack
	(sleep_until (volume_test_players swamp_b_trigger_4) 1) ; wait until last tower encounter starts - same trigger as swamp_b_gauntlet
	(sleep_until
		(and
			(not (script_finished "swamp_b_gauntlet"))
			(not (volume_test_players swamp_b_tower))
		)
	1)
	(f_md_3d_play 0 sq_gr_swamp_b_marines m06_00660 "dubbo: i've got movement! there's more of them! fall back to the structure!")
)

(script dormant play_vo_last_wave_killed
	(f_md_3d_play 0 sq_gr_swamp_b_marines m06_00670 "dubbo: i... i think that's the last of them. lets get out of here before any more show up!")
)

(script static boolean keep_crazy_alive
	(if (or (volume_test_players tv_crazy_marine_keep_alive) (objects_can_see_object (players) sq_lab_b_bot_crazymarine 45))
		(begin
			(sleep (random_range (game_ticks_from_seconds 5) (game_ticks_from_seconds 7)))
			(sound_impulse_start sound\dialog\combat\crazy\default\08_idle\injured sq_lab_b_bot_crazymarine 1)
		)
	)
	true
)

;====================================================================================================================================================================================================
; vignettes
;====================================================================================================================================================================================================

(global boolean b_start_oom3_scream false)
(global boolean b_start_oom5_scream false)

(script dormant vig_oom3_flood_elite_scream
	(sleep_until b_start_oom3_scream 1)
	(sound_impulse_start sound\dialog\combat\flood_elite\default\13_script\c10_log_scream ss_oom3_flood 1)
)

(script dormant vig_oom5_flood_elite_scream
	(sleep_until b_start_oom5_scream 1)
	(sound_impulse_start sound\dialog\combat\flood_elite\default\13_script\c10_log_scream ss_oom5_flood 1)
)

;====================================================================================================================================================================================================
; music
;====================================================================================================================================================================================================

(global short s_music_trigger_c10 0)

(script dormant c10_music_controller
	(sleep_until (> s_music_trigger_c10 1) 1)
	(if (= s_music_trigger_c10 20) (begin (music_event sound/music/c10/mus_02_swamp1b_encounter_start) (print "mus_02_swamp1b_encounter_start")))

	(sleep_until (> s_music_trigger_c10 20) 1)
	(if (= s_music_trigger_c10 30) (begin (music_event sound/music/c10/mus_03_forerunner_structure_enter) (print "mus_03_forerunner_structure_enter")))

	(sleep_until (> s_music_trigger_c10 30) 1)
	(if (= s_music_trigger_c10 70) (begin (music_event sound/music/c10/mus_07_bridge_b_end) (print "mus_07_bridge_b_end")))

	(sleep_until (> s_music_trigger_c10 70) 1)
	(if (= s_music_trigger_c10 90) (begin (music_event sound/music/c10/mus_09_flood_reveal_glass_prison) (print "mus_09_flood_reveal_glass_prison")))

	(sleep_until (> s_music_trigger_c10 90) 1)
	(if (= s_music_trigger_c10 100) (begin (music_event sound/music/c10/mus_10_flood_reveal_final_wave_start) (print "mus_10_flood_reveal_final_wave_start")))

	(sleep_until (> s_music_trigger_c10 100) 1)
	(if (= s_music_trigger_c10 110) (begin (music_event sound/music/c10/mus_11_flood_reveal_encounter_clear) (print "mus_11_flood_reveal_encounter_clear")))

	(sleep_until (> s_music_trigger_c10 110) 1)
	(if (= s_music_trigger_c10 120) (begin (music_event sound/music/c10/mus_12_trick_elevator) (print "mus_12_trick_elevator")))

	(sleep_until (> s_music_trigger_c10 120) 1)
	(if (= s_music_trigger_c10 130) (begin (music_event sound/music/c10/mus_13_activate_elevator_b) (print "mus_13_activate_elevator_b")))

	(sleep_until (> s_music_trigger_c10 130) 1)
	(if (= s_music_trigger_c10 140) (begin (music_event sound/music/c10/mus_14_elevator_b_end) (print "mus_14_elevator_b_end")))

	(sleep_until (> s_music_trigger_c10 140) 1)
	(if (= s_music_trigger_c10 180) (begin (music_event sound/music/c10/mus_18_enter_bay_e) (print "mus_18_enter_bay_e")))

	(sleep_until (> s_music_trigger_c10 180) 1)
	(if (= s_music_trigger_c10 190) (begin (music_event sound/music/c10/mus_19_activate_elevator_c) (print "mus_19_activate_elevator_c")))

	(sleep_until (> s_music_trigger_c10 190) 1)
	(if (= s_music_trigger_c10 200) (begin (music_event sound/music/c10/mus_20_exit_structure) (print "mus_20_exit_structure")))

	(sleep_until (> s_music_trigger_c10 200) 1)
	(if (= s_music_trigger_c10 210) (begin (music_event sound/music/c10/mus_21_flood_gauntlet_clear) (print "mus_21_flood_gauntlet_clear")))
)

(script dormant c10_music_triggers_ins_0
	(sleep_until (volume_test_players enc_swamp_a_trigger_01) 1)
	(set s_music_trigger_c10 20)

	(sleep_until (volume_test_players structure_entrance_trigger) 1)
	(set s_music_trigger_c10 30)
)

(script dormant c10_music_triggers_ins_1
	(sleep_until (volume_test_players bay_b_bridgemusic_trigger) 1)
	(set s_music_trigger_c10 70)
)

(script dormant c10_music_triggers_ins_2
	(sleep_until b_flood_revealed 1)
	(wake c10_music_triggers_ins_postflood)
)

(script dormant c10_music_trigger_11
	(print "starting c10_music_trigger_11")
	;mus_09 and mus_10 triggered in main script

	(sleep_until
		(or
			(volume_test_players control_table_music_trigger_11)
			(<= (ai_living_count sq_gr_prison_last_wave) 0)
		)
 	1)

	(set s_music_trigger_c10 110)
	(print "c10_music_trigger_11 done")
)

(script dormant c10_music_triggers_ins_postflood
	; (print "starting c10_music_triggers_ins_postflood")

	; mus_12 done in main script - can be skippable

	(sleep_until (volume_test_players elevator_b_music_trigger_13) 1) ; using trigger volume instead of device_get_position as lift_b changes position multiple times
	(set s_music_trigger_c10 130)
		(sleep_until ;flood spawners may not be active when the music hits, so it may immediately quit if we don't wait for them to actually deliver
		(or
				(> (ai_living_count sq_gr_lift_b) 0)
				(> (ai_living_count sq_gr_lift_b_infection) 0)
		)
	1)
	(sleep_until
		(or
			(volume_test_players int_lift_infector_trigger1)
			(= 0 (+ (ai_living_count sq_gr_lift_b_infection_top) (ai_living_count sq_gr_lift_b)))
		)
	1)
	(set s_music_trigger_c10 140)
	; (print "c10_music_triggers_ins_postflood done")
)

(script dormant c10_music_triggers_ins_3
	(sleep_until (volume_test_players tv_bay_e_enter) 1)
	(set s_music_trigger_c10 180)

	(sleep_until
		(or
			(= (device_get_position lift_d_cont_a) 1)
			(and
				(script_finished "int_b_lift")
				(= 0 (ai_living_count sq_gr_lift_c))
			)
		)
	1)
	(set s_music_trigger_c10 190)
)

(script dormant c10_music_triggers_lift_b
	(sleep_until (volume_test_players elevator_b_music_trigger_13) 1) ; using trigger volume instead of device_get_position as lift_b changes position multiple times
	(set s_music_trigger_c10 130)
	(sleep_until
		(or ;flood spawners may not be active when the music hits, so it may immediately quit if we don't wait for them to actually deliver
				(> (ai_living_count sq_gr_lift_b) 0)
				(> (ai_living_count sq_gr_lift_b_infection) 0)
		)
	1 )
	(sleep_until
		(or
			(and
				(<= (ai_living_count sq_gr_lift_b) 0)
				(<= (ai_living_count sq_gr_lift_b_infection) 0)
			)
			(volume_test_players np_trigger_12_bay_c_l)
		)
	1)
	(set s_music_trigger_c10 140)
)
