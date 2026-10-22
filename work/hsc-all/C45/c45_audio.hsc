;====================================================================================================================================================================================================
; play vo under condition
;====================================================================================================================================================================================================
(script dormant dialog_control_room
	(sleep_until (= (cinematic_in_progress) false) 1)
	(sleep (game_ticks_from_seconds 2.5))

	(f_md_2d_play_cortana 75 m08_00440 "cortana: look out!")
	(f_md_2d_play_cortana 0 m08_00450 "cortana: we can't let the monitor activate halo. we have to stop him. we have to destroy halo.")
)

(script dormant dialog_control_room_leaving
	(sleep_until (script_finished "dialog_control_room") 1)

	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 60 m08_00460 "cortana: according to my analysis of the available data, i believe the best course of action is somewhat...risky. an explosion of sufficient size will help destabilize the ring and will cut through a number of primary systems. we need to trigger a detonation on a large scale, however. a starship's fusion reactors going critical would do the job.")
	(f_md_2d_play_cortana 0 m08_00470 "cortana: i'm going to search what's left of the covenant battlenet and see if i can locate the pillar of autumn's crash site. if the ship's fusion reactors are still relatively intact, we can use them to destroy halo.")
)

(script dormant dialog_gen1_marked
	(sleep_until (script_finished "dialog_control_room_leaving") 1)

	(sleep (game_ticks_from_seconds 0.5))
	(f_md_2d_play_cortana 75 m08_00480 "cortana: i haven't located the crash site yet…but we need to buy some time, in case the monitor or his sentinels find a way to activate halo's 'final weapon' without the index.")
	(f_md_2d_play_cortana 30 m08_00490 "cortana: the machinery in these canyons are halo's primary firing mechanisms. they consist of three phase-pulse generators that amplify halo's signal and allow it to fire deep into space. the power levels are enormous...i can't even begin to calculate the pulse's range.")
	(f_md_2d_play_cortana 50 m08_00500 "cortana: so, if we damage or destroy these generators, the monitor will need to repair them before halo can be used. that should buy us some time.")
	(waypoint_1)
	(f_md_2d_play_cortana 0 m08_00510 "cortana: i'm marking the location of the nearest pulse generator with a nav point. we need to move in and neutralize the device.")
)

(script dormant dialog_need_banshee
	(branch (any_players_in_vehicle_type s_vehicle_type_banshee) (f_md_abort)) ; if player gets in banshee before dialog starts

	(sleep_until (script_finished "dialog_gen1_marked") 1)
	(f_blip_flag fl_fly_away_1 0)
	(sleep (game_ticks_from_seconds 0.5))
	(f_md_2d_play_cortana 0 m08_00520 "cortana: commandeer that banshee. we'll need it to reach the pulse generator in time.")
	(set s_music_trigger 50)

)

(script dormant dialog_gen1_enter_banshee
	(f_md_2d_play_cortana 0 m08_00540 "cortana: good. let's get moving....the nav point marks our target.")
)

(script dormant dialog_gen1_approach
	(f_md_2d_play_cortana 30 m08_00550 "cortana: that's the pulse generator. the center core is the signal amplifier. that's what we need to shut down.")
	(f_md_2d_play_cortana 0 m08_00560 "cortana: there should be three power conduits nearby, focus your attention there.")
	(f_unblip_all)
	(wake pg1_generator_blips)
	(f_hud_obj_new "obj_c40_0" "obj_c40_0")
)

(script dormant dialog_gen1_dally
	(sleep_until (script_finished "dialog_gen1_approach") 1)
	(branch b_pulse_gen1_downed (f_md_abort)) ; dally aborts when objective is complete

	(f_md_dawdle_play 30 m08_00570 "cortana: destroy the three conduits." 2)
)

(script dormant dialog_gen1_leave_before_disabled
	(branch b_pulse_gen1_downed (f_md_abort)) ; conditional dialog aborts when objective is complete
	(sleep_until (volume_test_players tv_pulse_gen1_leave_early) 1)
	(if (not b_pulse_gen1_downed)
		(f_md_2d_play_cortana 0 m08_00610 "cortana: wait. we haven't destroyed the pulse generator yet. take out the power conduits, we're running out of time!")
	)
)

(script dormant dialog_gen1_disabled
	; sleep 1 frame to allow the other scripts to clear out their f_md_abort before we start ours
	(sleep 1)
	(f_md_2d_play_cortana 60 m08_00580 "cortana: objective accomplished. the pulse generator has overloaded. scanning... the generator's central core is offline. well done.")
	(f_md_2d_play_cortana 0 m08_00590 "cortana: the second pulse generator is located in the adjacent canyon. move out and i'll mark the target with a nav point when we get closer.")
)

(script dormant dialog_flood_ambush
	(f_md_2d_play_cortana 0 m08_09140 "cortana: warning! incoming flood!")
)

(script dormant dialog_gen2_marked
	(f_md_2d_play_cortana 0 m08_00600 "cortana: ok, let's take care of the next pulse generator.")
)

(script dormant dialog_gen2_approach
	(f_md_2d_play_cortana 0 m08_00615 "cortana: same as the last generator. we need to destroy the three power conduits.")
	(f_unblip_all)
	(wake pg2_generator_blips)
)

(script dormant dialog_gen2_in_room_dally
	(sleep_until (script_finished "dialog_gen2_approach") 1)
	(branch b_pulse_gen2_downed (f_md_abort)) ; dally aborts when objective is complete

	(f_md_dawdle_play 30 m08_09170 "cortana: i've marked the conduit locations." 2)
)

(script dormant dialog_gen2_leave_before_disabled
	(branch b_pulse_gen2_downed (f_md_abort)) ; conditional dialog aborts when objective is complete
	(sleep_until (volume_test_players tv_pulse_gen2_leave_early) 1)
	(if (not b_pulse_gen2_downed)
		(f_md_2d_play_cortana 0 m08_00610 "cortana: wait. we haven't destroyed the pulse generator yet. take out the power conduits, we're running out of time!")
	)
)

(script dormant dialog_gen2_disabled
	(f_md_2d_play_cortana 0 m08_00620 "cortana: that did it!  the pulse generator overloaded. one more to go.")
)

(script dormant dialog_gen2_leaving
	(f_md_2d_play_cortana 60 m08_00640 "cortana: i've located the pillar of autumn. she put down 1,200 kilometers up-spin. energy readings show her fusion reactors are still powered up!")
	(f_md_2d_play_cortana 0 m08_09130 "cortana: the systems on the pillar of autumn have failsafes even i can't override without authorization from the captain. the code is stored in his neural implants. we'll need to find him to start the fusion core deonation.")
)

(script dormant dialog_gen3_canyon
	(sleep_until (script_finished "dialog_gen2_leaving") 1)
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 0 m08_00660 "cortana: that tunnel leads to the next section of canyon. the final pulse generator we need to destroy is through there.")
)

(script dormant dialog_gen3_approach
	(f_md_2d_play_cortana 0 m08_00670 "cortana: one target remaining. let's take care of the final pulse generator.")
	(f_unblip_all)
	(wake pg3_generator_blips)
)

(script dormant dialog_gen3_in_room_dally
	(sleep_until (script_finished "dialog_gen3_approach") 1)
	(branch b_pulse_gen3_downed (f_md_abort)) ; dally aborts when objective is complete

	(f_md_dawdle_play 30 m08_09170 "cortana: i've marked the conduit locations." 2)
)

(script dormant dialog_gen3_leave_before_disabled
	(branch b_pulse_gen3_downed (f_md_abort)) ; conditional dialog aborts when objective is complete
	(sleep_until (volume_test_players tv_pulse_gen3_leave_early) 1)
	(if (not b_pulse_gen3_downed)
		(f_md_2d_play_cortana 0 m08_00610 "cortana: wait. we haven't destroyed the pulse generator yet. take out the power conduits, we're running out of time!")
	)
)

(script dormant dialog_gen3_disabled
	; sleep 1 frame to allow the other scripts to clear out their f_md_abort before we start ours
	(sleep 1)
	(f_md_2d_play_cortana 0 m08_00680 "cortana: final target neutralized. let's get out of here.")
)

(script dormant dialog_general_dawdle
	(sleep_until
		(begin
			(sleep_until (or (volume_test_players tv_general_dawdle_1) (volume_test_players tv_general_dawdle_2) (volume_test_players tv_general_dawdle_3)) 1)
				(if (and (= (f_player_in_banshee) false) (game_safe_to_save))
					(begin
						(f_md_2d_play_cortana 0 m08_00530 "cortana: alert! pulse generator is still online. we need to neutralize all three. i recommend seizing a banshee and flying to the nav point on your display.")
						(set l_general_dawdle_sleep (+ l_general_dawdle_sleep (game_ticks_from_seconds 30))) ; adds delay for next reminder
					)
					(print "dawdle message - player is in banshee, no reminder given. begin loop again")
				)

			b_general_dawdle_end
		)
	l_general_dawdle_sleep)
)

(script static boolean f_player_in_banshee
	(or
		(unit_in_vehicle_type player0 30)
		(unit_in_vehicle_type player1 30)
		(unit_in_vehicle_type player2 30)
		(unit_in_vehicle_type player3 30)
	)
)

;====================================================================================================================================================================================================
; play music under condition
;====================================================================================================================================================================================================

(global short s_music_trigger 0)
(global short s_music_current 0)

(script continuous c45_music
	(sleep_until (!= s_music_trigger s_music_current) 1)
	(f_c45_music_event_update s_music_trigger)
)

(script static void (f_c45_music_event_update (short request_number))
	(cond
		((= request_number 20) (begin (music_event sound/music/c40/mus_02_opening_cinematic_end) (print "mus_02_opening_cinematic_end")))
		((= request_number 30) (begin (music_event sound/music/c40/mus_03_control_room_hallway_enter) (print "mus_03_control_room_hallway_enter")))
		((= request_number 40) (begin (music_event sound/music/c40/mus_04_ziggurat_exit) (print "mus_04_ziggurat_exit")))
		((= request_number 50) (begin (music_event sound/music/c40/mus_05_tank_encounter) (print "mus_05_tank_encounter")))
	)
	(cond
		((= request_number 60) (begin (music_event sound/music/c40/mus_06_generator_a_enter) (print "mus_06_generator_a_enter")))
		; mus_07 cut from design
		((= request_number 80) (begin (music_event sound/music/c40/mus_08_fight_to_bridge_f_start) (print "mus_08_fight_to_bridge_f_start")))
		((= request_number 90) (begin (music_event sound/music/c40/mus_09_fight_to_bridge_f_end) (print "mus_09_fight_to_bridge_f_end")))
		((= request_number 100) (begin (music_event sound/music/c40/mus_10_bridge_f_encounter_start) (print "mus_10_bridge_f_encounter_start")))
	)
	(cond
		((= request_number 110) (begin (music_event sound/music/c40/mus_11_bridge_f_encounter_end) (print "mus_11_bridge_f_encounter_end")))
		; mus_12 cut from design
		((= request_number 130) (begin (music_event sound/music/c40/mus_13_bridge_e_encounter_start) (print "mus_13_bridge_e_encounter_start")))
		((= request_number 140) (begin (music_event sound/music/c40/mus_14_bridge_e_encounter_end) (print "mus_14_bridge_e_encounter_end")))
		((= request_number 150) (begin (music_event sound/music/c40/mus_15_spooky_explore_start) (print "mus_15_spooky_explore_start")))
	)
	(cond
		((= request_number 160) (begin (music_event sound/music/c40/mus_16_spooky_explore_end) (print "mus_16_spooky_explore_end")))
		((= request_number 170) (begin (music_event sound/music/c40/mus_17_generator_b) (print "mus_17_generator_b")))
		((= request_number 180) (begin (music_event sound/music/c40/mus_18_chasm_encounter_start) (print "mus_18_chasm_encounter_start")))
		((= request_number 190) (begin (music_event sound/music/c40/mus_19_chasm_encounter_end) (print "mus_19_chasm_encounter_end")))
		((= request_number 200) (begin (music_event sound/music/c40/mus_20_final_run) (print "mus_20_final_run")))
	)
	(cond
		((= request_number 210) (begin (music_event sound/music/c40/mus_21_snowfield_a_encounter_start) (print "mus_21_snowfield_a_encounter_start")))
		((= request_number 220) (begin (music_event sound/music/c40/mus_22_snowfield_a_encounter_end) (print "mus_22_snowfield_a_encounter_end")))
		; mus_23 cut from design - placeholder cinematic mix
		((= request_number 240) (begin (music_event sound/music/c40/mus_24_mythic_arena_start) (print "mus_24_mythic_arena_start")))
		((= request_number 250) (begin (music_event sound/music/c40/mus_25_mythic_arena_end) (print "mus_25_mythic_arena_end")))
	)
	(cond
		((= request_number 260) (begin (music_event sound/music/c40/mus_26_mythic_hallway_start) (print "mus_26_mythic_hallway_start")))
		((= request_number 270) (begin (music_event sound/music/c40/mus_27_mythic_hallway_end) (print "mus_27_mythic_hallway_end")))
		((= request_number 280) (begin (music_event sound/music/c40/mus_28_mythic_generator_start) (print "mus_28_mythic_generator_start")))
		((= request_number 290) (begin (music_event sound/music/c40/mus_29_mythic_generator_end) (print "mus_29_mythic_generator_end")))
		((= request_number 300) (begin (music_event sound/music/c40/mus_30_mythic_flee) (print "mus_30_mythic_flee")))
	)

	(print "setting request to current")
	(set s_music_current request_number)
)

(script dormant e2_music_trigger
	(sleep_until
		(and
			(= 0 (ai_living_count gr_e1_a))
			(= 0 (ai_living_count gr_e2_a))
			(= 0 (ai_living_count gr_e2_b))
			(= 0 (ai_living_count gr_e2_c))
		)
	1)
	(set s_music_trigger 30)
)

(script dormant e6_music_trigger
	(sleep_until (volume_test_players tv_pulse_gen1_leave_early) 1)
	(set s_music_trigger 60)
)

(script dormant e20_music_trigger
	(sleep_until (script_finished "e21_a") 1)

	(sleep_until
		(or
			(volume_test_players tv_save_checkpoint9) ; runs past arena f into small tunnel j
			(and ; clears arena f and small tunnel j encounters
				(= 0 (+ (ai_living_count gr_e21_a) (ai_living_count sq_e21_b_sb0)))
				(= 0 (+ (ai_living_count gr_e22_a) (ai_living_count gr_e22_b) (ai_living_count gr_e23_c)))
				(= 0 (+ (ai_living_count gr_e23_a) (ai_living_count gr_e23_b)))
			)
		)
	1)
	(set s_music_trigger 90)
)

(script dormant e30_music_trigger
	(sleep_until
		(or
			(volume_test_players tv_save_checkpoint20) ; runs past bridge f into small tunnel i
			(= 0 (ai_living_count gr_e30_a))
		)
	1)
	(set s_music_trigger 110)
)

(script dormant e40_music_trigger
	(sleep_until (volume_test_players tv_e40_music_trigger_13) 1)
	(set s_music_trigger 130)
)

(script dormant e41_music_trigger
	(sleep_until 
		(and 
			(= 0 (ai_living_count gr_e40_a))
			(= 0 (+ (ai_living_count sq_e41_a_fepa) (ai_living_count sq_e41_a_fepb) (ai_living_count sq_e41_a_fhrc) (ai_nonswarm_count sq_e41_a_fhuc)))
			(= 0 (ai_living_count gr_e41_b))
		)
	1) 

	(if (< s_music_trigger 140) (set s_music_trigger 140))
)

(script dormant e59_music_trigger
	(sleep_until (volume_test_players tv_e59_music_trigger_19) 1)
	(set s_music_trigger 190)
)

(script dormant e60_music_trigger
	(sleep_until (volume_test_players tv_e60_music_trigger_21) 1)
	(set s_music_trigger 210)
)

(script dormant e65_music_trigger
	(sleep_until
		(or
			(volume_test_players tv_e65_music_trigger_22)
			(= 0 (+ (ai_living_count gr_e60_a) (ai_living_count gr_e60_banshee) (ai_living_count gr_e60_c) (ai_living_count gr_e60_d) (ai_living_count gr_e60_e)))
		)
	1)
	(set s_music_trigger 220)
)

;====================================================================================================================================================================================================
; extra room (mythic skull) music managers
;     the extra room doesn't have music playing when entering it, so this is implemented as a self contained manager.
;====================================================================================================================================================================================================

(script dormant extra_room_music_manager
	; outer loop means, once woken, the music manager runs until the extra room is completed
	(sleep_until
		(begin
			(print_if b_debug "extra room music manager: looping")
			(cond
				((and (volume_test_players tv_extra_room_music_trigger_26) (= b_extra_room_arena_finished false)) (set s_music_trigger 240))
				((and (volume_test_players tv_extra_room_hallway_elbow) (= b_extra_room_hallway_finished false)) (set s_music_trigger 260))
				((and (volume_test_players tv_extra_room_music_trigger_28) (= b_extra_room_generator_finished false)) (set s_music_trigger 280))
			)
			extra_room_completed	; extra room script marks completed, at which point no more enemies will spawn and entrance/exit handling stops
		)
	1)

	(print_if b_debug "extra room music manager: manager quit")
)

(script dormant extra_room_backtrack_music_manager
	(sleep_until (volume_test_players tv_extra_room_1_entrance) 1) ; wait for player to enter extra room

	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_extra_room_1_exit) 1)
			(set s_music_trigger 300)

			extra_room_completed ; extra room script marks completed, at which point no more enemies will spawn and exit music stops
		)
	1)
)

(script dormant extra_room_banshee_music_manager
	(if (= b_pulse_gen2_downed false) ; if player enters extra room before destroying second pulse generator, ensure mus_17 still plays when entering banshee
		(begin
			(sleep_until
				(or
					(vehicle_test_seat_unit_list v_ban_extraplat_a "banshee_d" (players))
					(vehicle_test_seat_unit_list v_ban_extraplat_b "banshee_d" (players))
					(vehicle_test_seat_unit_list v_ban_extraplat_c "banshee_d" (players))
					(vehicle_test_seat_unit_list v_ban_extraplat_d "banshee_d" (players))
				)
 			1)
			(set s_music_trigger 170)
		)
	)
)

;====================================================================================================================================================================================================