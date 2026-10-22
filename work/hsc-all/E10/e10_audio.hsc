;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;================================================== e10 - vo ========================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
;================================================== beat 1 ==========================================================================================================================================
;====================================================================================================================================================================================================

;triggers after the copilot cinematic.
(script dormant dialogue_dockingbay_johnson_post_intro
	(sleep_until (= (cinematic_in_progress) false) 1)
	(print "i got the message")

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_goto_first_door)
	(sleep (game_ticks_from_seconds 3))
	(f_md_2d_play 20 m12_00580 "master chief: layout matches what naval intelligence provided. confirming a route to the ship's command center.")
	;(cs_run_command_script ai_johnson cs_johnson_goto_first_door)
	(f_md_3d_play 20 ai_johnson m12_01870 "johnson: if that nav data has what we need, we can finally strike back at these bastards.")
	(f_md_2d_play 15 m12_01880 "master chief: oni seemed confident.")
	(f_md_3d_play 35 ai_johnson m12_00590 "johnson: we keep quiet and play our cards right, we'll be in, out, and back by dinner.")
	(f_md_2d_play 5 m12_00600 "master chief: you're always hungry.")
	(f_md_3d_play 0 ai_johnson m12_00610 "johnson: damn right i am.")
)

(script dormant dialogue_any_way_to_speed_this_up
	(sleep (game_ticks_from_seconds 3.5))
	(f_md_2d_play 15 m12_00740 "mc: any way to speed this up?")
	(f_md_3d_play 90 ai_johnson m12_00750 "johnson: until we find a way to cram an ai into that suit of yours, it's the best option we got.")
	(f_md_3d_play 20 ai_johnson m12_00760 "johnson: and…done.")
	(set b_johnson_says_done true)
	(f_md_3d_play 30 ai_johnson m12_00770 "johnson: you ready?")
	(f_md_2d_play 0 m12_00780 "mc: always.")
	(set b_johnson_first_hack_complete true)
	;;;; note - dm_johnson_hack_door_hanger is opened in the e10_audio.hsc file (right here) when johnson hacks it open for a vignette
	;;;; but is closed in the main script file (e10.hsc) when encounter 1 triggers
	;(device_set_power dm_johnson_hack_door_hanger 1)
	;(device_set_position dm_johnson_hack_door_hanger 1)
	;(ai_player_add_fireteam_squad player0 ai_johnson)
	;(ai_set_objective ai_johnson obj_johnson_follow)
	(f_blip_flag fl_hanger_forcefield 0)
	(sleep_until (= (device_get_position dm_johnson_hack_door_hanger) 1) 1)
	(device_set_power dm_johnson_hack_door_hanger 0)
)

(script dormant dialogue_johnson_opens_path
	(f_md_3d_play 0 ai_johnson m12_02310 "johnson: hold position here, chief. it'll be quieter if i go ahead."); x
	(ai_player_remove_fireteam_squad player0 ai_johnson)

	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1) ; make sure johnson has health before the script proceeds
	(cs_run_command_script ai_johnson cs_johnson_enters_the_airlock)
)

(script dormant dialogue_johnson_two_for_one
	(f_md_3d_play 0 ai_johnson m12_02220 "johnson: two for one special!")
)

(script dormant dialogue_johnson_shooting_gallery
	(f_md_3d_play 0 ai_johnson m12_02260 "johnson: welcome to my shooting gallery!")
)

(script dormant dialogue_johnson_strike
	(f_md_3d_play 0 ai_johnson m12_02270 "johnson: s-s-s-trike!")
)

;;;;;;;;;; note - this bit now triggers in e10_base as a looping element function in e10_base.hsc: trigger_chief_snuck_in_airlock
;(script dormant dialogue_chief_snuck_in_airlock
;	(f_md_2d_play 0 none "johnson: your comms down, chief? i need you to stay back until i drop that shield."); currently not recorded
;)

(script dormant dialogue_omg_its_hunters
	(set b_hanger_hunters_begin true)
	(sound_impulse_start sound\dialog\combat\hunter\default\02_combat\brsrk sq_dockingbay_lift_hunter 1)
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play 30 m12_02400 "master chief: hunters.")
	(f_md_2d_play 0 m12_02390 "master chief: concentrate fire on their exposed areas. fire at will.")
)

(script dormant dialogue_first_hunter_is_dead
	(f_md_3d_play 0 ai_johnson m12_02410 "johnson: i've seen a lot of weird stuff in my time, chief. but this? this takes the cake. worm…priests?")
)

(script dormant dialogue_hunters_are_dead
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play 0 m12_00800 "master chief: you call that quiet?")
	(f_md_3d_play 0 ai_johnson m12_00810 "johnson: dead folks are quiet, chief. and now they're dead.")
	(sleep_until b_johnson_hacked_hanger_lift 1)
	(sleep (game_ticks_from_seconds 1))
	(f_md_3d_play 0 ai_johnson m12_02300 "johnson: oni's pocket hacker is suppressing their internal alerts. the good doctor delivers once again."); x
)

;====================================================================================================================================================================================================
;================================================== beat 2 ==========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant dialogue_mc_johnson_first_split
	(f_md_3d_play 0 ai_johnson m12_00630 "johnson: i'll take the high ground, chief.")
	(set b_johnson_takes_high_ground true)
	(sleep_until (volume_test_players tv_vo_mc_splits) 1)
	(f_md_2d_play 0 m12_00950 "master chief: i'll take point.")
)

(script dormant dialogue_sophie_says_hi
	(f_md_2d_play 60 m12_01900 "mc: cover me."); x
	(f_md_3d_play 0 ai_johnson m12_01890 "johnson: sophie wants to say a few words!"); x
)

(script dormant dialogue_mc_dawdles_in_rr
	(f_md_3d_play 15 ai_johnson m12_01910 "johnson: make your way to the other side, chief."); x
	(f_md_2d_play 0 m12_01920 "mc: acknowledged. moving to position."); x
)

(script dormant dialogue_entering_the_dojo
	(sleep_forever chief_dawdling_timer) ; stops rr dawdle timer
	(sleep_forever trigger_mc_dawdles_in_rr) ; stops rr dawdle trigger
	(f_md_3d_play 0 ai_johnson m12_01930 "johnson: huh. saw this on the orientation vid. war crime training room."); x
	(set b_johnson_sees_cov_combat true)
)

(script dormant dialogue_why_is_the_sand_moving
	(set b_somethings_moving_on_sand true)
	(f_md_3d_play 15 ai_johnson m12_01950 "johnson: chief! that sand ain't movin' on its own!")
	(set b_dojo_specops_can_kill true)
	(f_md_2d_play 5 m12_01960 "mc: contact on tracker."); x
	(f_md_3d_play 0 ai_johnson m12_01970 "johnson: stealth elites!"); x
	(print "specops elites can now attack")
)

(script dormant dialogue_mind_the_gap
	(f_md_3d_play 0 ai_johnson m12_01980 "johnson: mind the gap, chief."); x
)

(script dormant dialogue_give_me_a_second
	(f_md_3d_play 0 ai_johnson m12_01990 "johnson: give me a sec…"); x
)

(script dormant dialogue_lets_hustle
	(f_md_3d_play 0 ai_johnson m12_02000 "johnson: we're good. let's hustle."); x
)
;====================================================================================================================================================================================================
;================================================== beat 3 ==========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant dialogue_the_human_museum
	(f_md_3d_play 0 ai_johnson m12_02010 "johnson: ever seen anything like this before, chief?"); x
	(f_md_2d_play 0 m12_02020 "mc: negative. this wasn't in the oni brief."); x
)

(script dormant dialogue_geneforge_testing1
	;(sleep_until (volume_test_players tv_geneforge_testing1) 1) ; moved to trigger_geneforge_testing1
	;(sleep_until (volume_test_object tv_geneforge_testing1 ai_johnson) 1) ; moved to trigger_geneforge_testing1

	(f_md_3d_play 30 ai_johnson m12_01090 "johnson: what do you think all this is for?")
	(f_md_2d_play 15 m12_01100 "master chief: nothing good.")
	(f_md_3d_play 20 ai_johnson m12_02040 "johnson: something really weird about all this. what do you think these are? trophies?."); x
	(f_md_2d_play 30 m12_02050 "master chief: unlikely, they look more like… experiments."); x
	(f_md_3d_play 30 ai_johnson m12_02060 "johnson: that's even worse."); x
	(wake vo_testing_facility_random_johnson)
)

(script dormant dialogue_ill_crack_it_open
	(sleep_until (script_finished "dialogue_geneforge_testing1") 1)
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_3d_play 0 ai_johnson m12_02030 "johnson: that's our exit. i'll get it cracked open."); x
)

(script dormant dialogue_the_brute_storage_room
	(ai_actor_dialogue_enable ai_johnson 0) ; disables johnson's chatter
	(sleep (game_ticks_from_seconds 0.5))
	(f_md_3d_play 0 ai_johnson m12_02070 "johnson: what the hell is all this?"); x
	(sleep (game_ticks_from_seconds 1.5))
	(ai_actor_dialogue_enable ai_johnson 1) ; re-enables johnson's chatter
)

; johnson - dawdle remarks if you stay in the testing facility for too long
(script dormant vo_testing_facility_random_johnson
	(branch (volume_test_players tv_johnson_combat_ready_tf) (f_md_skip_next)) ; aborts script when player exits geneforge testing facility

    (sleep_until
		(begin
			;(sleep_until b_path_forward_is_open 1) ; this prevents the dawdle from playing ever
			(sleep (game_ticks_from_seconds 15))
			(begin_random_count 1
				(f_md_3d_play 0 ai_johnson m12_01120 "johnson: this place gives me the creeps.")
				(f_md_3d_play 0 ai_johnson m12_01130 "johnson: i know a few folks who would kill to get a look at this tech.")
				(f_md_3d_play 0 ai_johnson m12_01140 "johnson: see the galaxy they said. see beautiful locations they said.")
			)

            (sleep (game_ticks_from_seconds 55))
			false
		)
	1)
)

;====================================================================================================================================================================================================
;================================================== beat 4 ==========================================================================================================================================
;====================================================================================================================================================================================================

; mc/chief post geneforge cinematic - encounter 13
(script dormant vo_shoot_our_way_out
	(ai_actor_dialogue_enable ai_johnson 0) ; disables johnson's chatter
	(sleep_until (= (cinematic_in_progress) false) 1)

	(sleep (game_ticks_from_seconds 2))
    (f_md_3d_play 15 ai_johnson m12_01620 "johnson: there's a lot of angry aliens in our way, what's the plan?")
    (f_md_2d_play 10 m12_01630 "master chief: we shoot our way out.")
    (f_md_3d_play 0 ai_johnson m12_01640 "johnson: nice and subtle, just the way i like it!")
	(ai_actor_dialogue_enable ai_johnson 1) ; re-enables johnson's chatter
)

; mc/chief - vo for eliminating the first wave in encounter 13
(script dormant vo_geneforge_ll_wv1_eliminated
	(object_create ss_prophet_tannoy) ; create sound scenery object for prophet tannoy line
	(sleep (game_ticks_from_seconds 2))
	(sound_impulse_start sound\scripted\vo_scr_m12dlc1\m12_01820_harmony ss_prophet_tannoy 1) ; "harmony: unseal the chambers! now!"
	(sleep (sound_impulse_time sound\scripted\vo_scr_m12dlc1\m12_01820_harmony))

	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play 0 m12_01540 "master chief: we've got company.")
	(object_destroy ss_prophet_tannoy) ; delete sound scenery object for prophet tannoy line
)

; johnson - remarks at the end of the waves in enc 13
(script dormant vo_geneforge_ll_combat_concludes
	(sleep (game_ticks_from_seconds 1))
	(f_md_3d_play 25 ai_johnson m12_01430 "johnson: that seems to be the last of 'em, chief.")
    (f_md_2d_play 0 m12_01440 "master chief: for now.")
)

; johnson - callout when first augmented brute dies in enc 13
(script dormant vo_first_augmented_brute_dies
	(branch (script_started "vo_geneforge_ll_wv1_eliminated") (f_md_abort)) ; if brute is last enemy in enc 13, don't say this line, play vo_geneforge_11_combat_instead

	(sleep_until (script_finished "vo_shoot_our_way_out") 1)
	(begin_random_count 1
				    (f_md_3d_play 0 ai_johnson m12_01560 "johnson: bigger, meaner, uglier...but not bulletproof.")
					(f_md_3d_play 0 ai_johnson m12_01160 "johnson: a brute? they look even uglier up close.")
			)
)

; mc/chief - vo for eliminating all enemies in encounter 15
(script dormant vo_stasis_chamber_main_encounter_eliminated
	(sleep (game_ticks_from_seconds 1.5))
    (f_md_3d_play 0 ai_johnson m12_01581 "johnson: damn it, chief. these bastards are more unhinged than normal."); x
)

; johnson - seeing the stasis chamber monitors
(script dormant vo_stasis_chamber_monitors_seen
    (sleep_until (volume_test_players tv_vo_stasis_chamber_monitors_seen) 1)
    (f_md_3d_play 0 ai_johnson m12_01660 "johnson: those grunts are having a bit too much fun at our expense, chief.")
)

(script dormant dialogue_turn_on_the_lift
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_3d_play 0 ai_johnson m12_02370 "johnson: i'll have this lift up and running in no time."); x
)


(script dormant vo_final_encounter_wave1
	(object_create ss_prophet_tannoy2) ; create sound scenery object for upper geneforge - destroy is in vo_final_encounter_finished
	(sound_impulse_start sound\scripted\vo_scr_m12dlc1\m12_01840_harmony ss_prophet_tannoy2 1) ; "harmony: these are the instruments of your demise, forged through my divine insight!"
)

(script dormant vo_final_encounter_wave2
	(sound_impulse_start sound\scripted\vo_scr_m12dlc1\m12_01830_harmony ss_prophet_tannoy2 1) ; "harmony: you will prove to be a suitable test for my creations, demon."
)

(script dormant vo_final_encounter_wave2half
	(sound_impulse_start sound\scripted\vo_scr_m12dlc1\m12_01850_harmony ss_prophet_tannoy2 1) ; "harmony: every foe you fell ensures our ultimate victory!"
)

(script dormant vo_final_encounter_wave3
	(sound_impulse_start sound\scripted\vo_scr_m12dlc1\m12_01860_harmony ss_prophet_tannoy2 1) ; "harmony: let us find your limits."
)

(script dormant vo_final_encounter_finished
	(object_destroy ss_prophet_tannoy2) ; destroy sound scenery object in upper geneforge 
	(ai_actor_dialogue_enable ai_johnson 0) ; disables johnson's chatter
	(sleep (game_ticks_from_seconds 3))
	(f_md_3d_play 20 ai_johnson m12_01210 "johnson: so what now?")
	(f_md_2d_play 0 m12_01220 "master chief: we get back to the mission. ")
	(sleep (game_ticks_from_seconds 3))
	(ai_actor_dialogue_enable ai_johnson 1) ; re-enables johnson's chatter
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;================================================ e10 - music =======================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;;; music controller
(script dormant e10_music_controller

	(sleep_until (> s_music_trigger_e10 19) 1)
	(if (= s_music_trigger_e10 20)(music_event sound/music/e10/mus_02_grunts_start));;

	(sleep_until (> s_music_trigger_e10 29) 1)
	(if (= s_music_trigger_e10 30)(music_event sound/music/e10/mus_03_grunts_end));;

	(sleep_until (> s_music_trigger_e10 49) 1)
	(if (= s_music_trigger_e10 50)(music_event sound/music/e10/mus_05_docking_bay_start));;

	(sleep_until (> s_music_trigger_e10 59) 1)
	(if (= s_music_trigger_e10 60)(music_event sound/music/e10/mus_06_docking_bay_escalation));;

	(sleep_until (> s_music_trigger_e10 69) 1)
	(if (= s_music_trigger_e10 70)(music_event sound/music/e10/mus_07_docking_bay_hunters));;

	(sleep_until (> s_music_trigger_e10 79) 1)
	(if (= s_music_trigger_e10 80)(music_event sound/music/e10/mus_08_docking_bay_end));;

	(sleep_until (> s_music_trigger_e10 89) 1)
	(if (= s_music_trigger_e10 90)(music_event sound/music/e10/mus_09_rest_and_respite));;

	(sleep_until (> s_music_trigger_e10 90) 1)
	(if (= s_music_trigger_e10 91) (music_event sound/music/e10/mus_09a_rar_encounter_start))

	(sleep_until (> s_music_trigger_e10 91) 1)
	(if (= s_music_trigger_e10 92) (music_event sound/music/e10/mus_09b_rar_encounter_end))

	(sleep_until (> s_music_trigger_e10 99) 1)
	(if (= s_music_trigger_e10 100)(music_event sound/music/e10/mus_10_dojo_start));;

	(sleep_until (> s_music_trigger_e10 109) 1)
	(if (= s_music_trigger_e10 110)(music_event sound/music/e10/mus_11_dojo_escalation));;

	(sleep_until (> s_music_trigger_e10 119) 1)
	(if (= s_music_trigger_e10 120)(music_event sound/music/e10/mus_12_dojo_end));;

	(sleep_until (> s_music_trigger_e10 129) 1)
	(if (= s_music_trigger_e10 130)(music_event sound/music/e10/mus_13_forge_reconnaissance));;

	(sleep_until (> s_music_trigger_e10 139) 1)
	(if (= s_music_trigger_e10 140)(music_event sound/music/e10/mus_14_specimen_room_start));;

	(sleep_until (> s_music_trigger_e10 159) 1)
	(if (= s_music_trigger_e10 160)(music_event sound/music/e10/mus_16_brutes_part_1));;

	(sleep_until (> s_music_trigger_e10 169) 1)
	(if (= s_music_trigger_e10 170)(music_event sound/music/e10/mus_17_brutes_part_2));;

	(sleep_until (> s_music_trigger_e10 179) 1)
	(if (= s_music_trigger_e10 180)(music_event sound/music/e10/mus_18_brutes_part_3));;

	(sleep_until (> s_music_trigger_e10 189) 1)
	(if (= s_music_trigger_e10 190)(music_event sound/music/e10/mus_19_brutes_end));;

	(sleep_until (> s_music_trigger_e10 190) 1)
	(if (= s_music_trigger_e10 191) (music_event sound/music/e10/mus_19a_grav_lift_start))

	(sleep_until (> s_music_trigger_e10 191) 1)
	(if (= s_music_trigger_e10 192) (music_event sound/music/e10/mus_19b_grav_lift_end))

	(sleep_until (> s_music_trigger_e10 199) 1)
	(if (= s_music_trigger_e10 200)(music_event sound/music/e10/mus_20_final_encounter_start));;

	(sleep_until (> s_music_trigger_e10 209) 1)
	(if (= s_music_trigger_e10 210)(music_event sound/music/e10/mus_21_final_encounter_escalation));;

	(sleep_until (> s_music_trigger_e10 219) 1)
	(if (= s_music_trigger_e10 220)(music_event sound/music/e10/mus_22_final_encounter_end));;

)

;====================================================================================================================================================================================================
;================================================== beat 1 ==========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant e10_music_hanger
	(sleep_until (= b_let_the_games_begin true) 1)
	(set s_music_trigger_e10 20)

	(sleep_until (and
				(= (ai_nonswarm_count gr_dock_intro_a) 0)
				(= (ai_nonswarm_count gr_dock_intro_a_wv2) 0)
				)
				1
	)
	(set s_music_trigger_e10 30)

	(sleep_until (= b_johnson_first_hack_complete true) 1)
	(set s_music_trigger_e10 50)

	(sleep_until (volume_test_players tv_trigger_mus06) 1)
	(set s_music_trigger_e10 60)

	(sleep_until (= b_hanger_hunters_begin true) 1)
	(set s_music_trigger_e10 70)

	(sleep_until (= (ai_living_count gr_exit_hunters) 0) 1)
	(set s_music_trigger_e10 80)
)

;====================================================================================================================================================================================================
;================================================== beat 2 ==========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant e10_music_rest_respite
	(sleep_until (= b_johnson_takes_high_ground true) 1)
	(set s_music_trigger_e10 90)

	(sleep_until (volume_test_players tv_sophie_says_hi) 1)
	(set s_music_trigger_e10 91)
)

(script dormant e10_music_rest_respite_complete
	(sleep_until
		(or
			(and ; clear encounter
				(= 0 (ai_nonswarm_count gr_rest_respite)) ; encounter_6
				(= 0 (ai_nonswarm_count gr_rest_respite_hallway)) ; encounter_7
				(= 0 (ai_nonswarm_count gr_rest_respite_wave3)) ; encounter_8
				(= 0 (ai_nonswarm_count gr_rest_respite_wave_final)) ; encounter_9
			)
			(volume_test_players tv_mus_trigger_9b_safety)
		)
	1)
	(set s_music_trigger_e10 92)
)

(script dormant e10_music_dojo
	(sleep_until (= b_johnson_sees_cov_combat true) 1)
	(set s_music_trigger_e10 100)

	(sleep_until (= b_somethings_moving_on_sand true) 1)
	(set s_music_trigger_e10 110)
)

(script dormant e10_music_dojo_end_trigger
	(sleep_until (= 0 (ai_nonswarm_count gr_dojo_reins)) 1) ; this blamsquadgroup includes gr_dojo_reins_part1, gr_dojo_reins_part2 and gr_dojo_reins_snipers
	(set s_music_trigger_e10 120)
)

;====================================================================================================================================================================================================
;================================================== beat 3 ==========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant e10_music_testing_facility
	(sleep_until (volume_test_players tv_trigger_chapter_three) 1)
	(set s_music_trigger_e10 130)

	(sleep_until (volume_test_players tv_geneforge_testing1) 1)
	(set s_music_trigger_e10 140)
)

;====================================================================================================================================================================================================
;================================================== beat 4 ==========================================================================================================================================
;====================================================================================================================================================================================================

;; insertion point - ins_main_lab_lower insertion point
(script dormant e10_music_lower_lab_ambush
	(sleep_until (= b_ambush_cinematic_concludes true) 1)
	(set s_music_trigger_e10 160)

	(sleep_until (= b_geneforge_ambush_ends true) 1)
	(set s_music_trigger_e10 170)
)

;; insertion point - ins_testing_facility_revisit insertion point
(script dormant e10_music_tf_revisit
	(sleep_until (and
			(volume_test_players tv_johnson_combat_testing_facility)
			(= b_backtracking_through_level true)
			1)
	)
	(set s_music_trigger_e10 180)

	(sleep_until (or
				(= b_tf_ambush_ends true)
				(volume_test_players tv_objective_geneforge_ul)
				)
				1
	)
	(set s_music_trigger_e10 190)
)
;; insertion point - ins_double_grav_lift insertion point
;;;;;;; currently there is no music here

;; insertion point - ins_final_encounter insertion point
(script dormant e10_music_final_encounter
	(sleep_until (volume_test_players tv_ponr_final_encounter) 1)
	(set s_music_trigger_e10 200)

	(sleep_until (= b_final_wave_attacks true) 1)
	(set s_music_trigger_e10 210)

	(sleep_until (= b_final_wave_eliminated true) 1)
	(set s_music_trigger_e10 220)
)