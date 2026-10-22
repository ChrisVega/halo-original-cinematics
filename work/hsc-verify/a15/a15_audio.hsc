;====================================================================================================================================================================================================
; tutorial vo
;====================================================================================================================================================================================================

(global short s_conversation_id_a15 0)

(script dormant dialog_cryo_intro
	(sleep_until (= (cinematic_in_progress) false) 1)
	(sleep (game_ticks_from_seconds 3))

	(f_md_3d_play 30 sq_cryo_tech/tech m01_00460 "cryotech: sorry for the quick thaw, master chief. things are a little hectic right now.")
	; sound_impulse_start for lip sync of the line below it, this is present on all cryoassistant lines.
	; this allows the audio to come from the speaker in the room with the player, while the lipsync event gets sent to the biped up in the control room.
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00490_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 60 ss_cryobay m01_00490) ; cryoassistant: welcome back, sir! we'll have you battle ready, stat.
	(f_md_3d_play 15 sq_cryo_tech/tech m01_00530 "cryotech: vital signs look normal, no freezer burn.")

	(if (not b_bypass_tutorials)
		(begin
			(wake skip_tutorial_option)
			(player_enable_input true)
			(sleep_until
				(begin
					(set s_idle_check (+ s_idle_check 1))
					(if (and (= s_idle_check 10)
					 		(or (not b_fast_setup_decline) (not b_fast_setup_done))) ;check if player has not made the coice and prompt again every 10 sec
						(f_hud_obj_repeat "tutorial_skip")
						(if (= s_idle_check 11) (set s_idle_check 0)) ;reset the idle check value
					)
					(or b_fast_setup_decline b_fast_setup_done) ;exit loop once player chooses train or skip
				)
				30 ;loop once per second
			)
		)
		(set b_fast_setup_done true) ;if there are multiple players or they are at heroic or legendary difficulty, automatically skip the tutorial
	)

	(set b_cryo_intro_done true)
)

(script static void dialog_cryo_tech_wakeup
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00550 "cryotech: i gave you a double dose of the 'wakeup' stim. take a quick walk around the cryo bay and join me at the optical diagnostic station when you're ready.")

)

(script dormant dialog_red_square_tech
	(if (not (objects_can_see_object (players) sq_cryo_tech/tech 10))
		(begin
			(sleep_until
				(begin
					(f_md_3d_play 0 sq_cryo_tech/tech m01_00570 "cryotech: ok sir, look at me so we can begin.")
					(hud_set_training_text "training_look") ;prompt look at tech with tooltip
					(hud_show_training_text true)

					(sleep_until (and (volume_test_players tv_red_square) (objects_can_see_object (players) sq_cryo_tech/tech 15)) 1 (game_ticks_from_seconds 10))
					(sleep_until (volume_test_players tv_red_square)1) ;don't prompt again until the player is back in the square as they'll be prompted to get back in the square

					(and (volume_test_players tv_red_square) (objects_can_see_object (players) sq_cryo_tech/tech 15))
				)
			1)
 			; test player looking at tech

			(hud_show_training_text false)
			(hud_set_training_text "")

			(f_md_3d_play 0 sq_cryo_tech/tech m01_00580 "cryotech: thank you, sir.")
		)
	)
	(set b_look_at_tech_done true)
	(f_md_3d_play 30 sq_cryo_tech/tech m01_00590 "cryotech: i know the ordnance techs usually take care of your targeting sensors, but we're short on time, chief.")
	(set b_cryo_tech_calib_point true)
	(sleep_until (and (not b_cryo_tech_free) b_is_player_in_red_square)1)
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00600 "cryotech: just look at each of the flashing panels to target them. when you lock on, it'll change color.")
	(sleep_until (> g_red_square_progress 0) 1)
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00610 "cryotech: okay... that looks good.")

	(set s_idle_check 0)
	(sleep_until
		(begin
			(set s_idle_check (+ s_idle_check 1))
			(if (and (= s_idle_check 10)
					 (or (not b_is_player_chose_yinversion0) (not b_is_player_chose_yinversion1))) ;check if player has not made the coice and prompt again every 10 sec
				(f_hud_obj_repeat "tutorial_looking_choose_2")
				(if (= s_idle_check 11) (set s_idle_check 0)) ;reset the idle check value
			)
			(or b_is_player_chose_yinversion0 b_is_player_chose_yinversion1) ;exit loop once player chooses train or skip
		)
		30 ;loop once per second
	)
)

(script dormant dialog_red_square_invert
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00620_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 15 ss_cryobay m01_00620) ; cryoassistant: sir, i'm getting some calibration errors. i'm going to invert your looking pitch so you can see if you like it better that way.
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00630_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 0 ss_cryobay m01_00630) ; cryoassistant: try targeting the flashing lights again.
	(sleep_until (> g_red_square_progress 1) 1)
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00640_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 0 ss_cryobay m01_00640) ; cryoassistant: is that better or should i switch it back?

	(set s_idle_check 0)
	(sleep_until
		(begin
			(set s_idle_check (+ s_idle_check 1))
			(if (and (= s_idle_check 10)
					 (or (not b_is_player_chose_yinversion0) (not b_is_player_chose_yinversion1))) ;check if player has not made the coice and prompt again every 10 sec
				(f_hud_obj_repeat "tutorial_looking_choose_4")
				(if (= s_idle_check 11) (set s_idle_check 0)) ;reset the idle check value
			)
			(or b_is_player_chose_yinversion0 b_is_player_chose_yinversion1) ;exit loop once player chooses train or skip
		)
		30 ;loop once per second
	)
)

(script static void dialog_red_square_complete
	(if b_is_player_chose_yinversion0
		(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00680_cryoassistant_lipsync sq_cryo_tech/asst 0)
		(f_md_object_play 0 ss_cryobay m01_00670) ; cryoassistant: ok, i'll leave the pitch inverted, but if you want you can change it yourself later.
	)
	(if b_is_player_chose_yinversion1
		(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00670_cryoassistant_lipsync sq_cryo_tech/asst 0)	
		(f_md_object_play 0 ss_cryobay m01_00680) ; cryoassistant: ok, i'll leave the pitch normal, but if you want you can change it yourself later.
	)
)

(script dormant dialog_yellow_square_test
	(hud_enable_training false)
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00690_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 0 ss_cryobay m01_00690) ; cryoassistant: i'm ready for the energy shield tests now.
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00700 "cryotech: please follow me to the energy shield test station.")
	(sleep_until (> g_cryo_shield_progress 0) 1)
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00740 "cryotech: ok, bring his energy shields online, please.")
	(sleep_until (> g_cryo_shield_progress 1) 1)
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00750_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 0 ss_cryobay m01_00750) ; cryoassistant: all right... shields read as fully charged.
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00760 "cryotech: ok sir, bring them down to test the automatic recharge.")
	(hud_enable_training true)
	(sleep_until (> g_cryo_shield_progress 2) 1)
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00770_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 0 ss_cryobay m01_00770) ; cryoassistant: recharging normally. we're showing green across the board.
)

(script dormant dialog_cryo_captain_orders
	(f_md_object_play 0 ss_cryobay m01_00780) ; keyes: bridge to cryo 2, this is captain keyes. send the master chief to the bridge immediately.
	(set g_cryo_captain_order_progress 1)

	(f_md_3d_play -15 sq_cryo_tech/tech m01_00790 "cryotech: captain, we'll have to skip the weapons diagnostics and i...")
	(f_md_object_play 15 ss_cryobay m01_00800) ; keyes: on the double, crewman.
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00810 "cryotech: aye aye sir.")

	(f_md_3d_play 0 sq_cryo_tech/tech m01_00820 "cryotech: the skipper seems jumpy.  we'd better get moving.  we'll find you weapons later.")
	(set g_cryo_captain_order_progress 2)

	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00830_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 0 ss_cryobay m01_00830) ; cryoassistant: ok, i'll leave the self-diagnostics running, at least.
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00840 "cryotech: good idea.  you'd better get to your evac group, sam.")
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00850_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 0 ss_cryobay m01_00850) ; cryoassistant: affirmative. i just have to reset the computer and i'm out of here.
	(set g_cryo_captain_order_progress 3)
)

(script dormant dialog_drama_asst
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00860_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(f_md_object_play 5 ss_cryobay m01_00860) ; cryoassistant: oh, god! they're trying to get through the door! security!  intruders in cryo 2!
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautmn_lipsync\m01_00880_cryoassistant_lipsync sq_cryo_tech/asst 0)
	(sound_impulse_start sound\scripted\vo_scr_m01pillarofautumn\m01_00880_cryoassistant ss_cryobay 1) ; cryoassistant: no! please don't--
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00870 "cryotech: sam! sam!")
	(set g_cryo_captain_order_progress 4)
	(object_destroy ss_cryobay)
)

(script dormant dialog_cryo_get_out
	(f_md_3d_play 60 sq_cryo_tech/tech m01_00890 "cryotech: come on! we've got to get the hell out of here.")
	(f_md_3d_play 0 sq_cryo_tech/tech m01_00900 "cryotech: this way!")
)

;====================================================================================================================================================================================================
; play vo under condition
;====================================================================================================================================================================================================

(script dormant dialog_containment
	(f_md_3d_play 0 sq_containment_1/flee_crewman m01_00910 "crewman #1: behind us! they're right behind us!")
	(f_md_3d_play 0 sq_containment_1/rear_security m01_00920 "crewman #2: secure those blast doors! move! move!")
	(sleep_until b_doom_crewman_ready 1)
	(f_md_3d_play 0 sq_containment_1/doom_crewman m01_00930 "crewman #3: wait for me!")
)

(script dormant dialog_containment_dawdle
	(f_md_3d_play 0 sq_containment_1 m01_00950 "crewman #1: master chief sir, the situation is secure here, you're probably needed somewhere else.")
)

(script dormant dialog_first_contact
	(f_md_3d_play 30 sq_first_contact_rm1 m01_00970 "bisenti: those alien bastards are everywhere!")
	(sleep_until b_first_contact_dawdle 1)
	(f_md_3d_play 0 sq_first_contact_rm1 m01_00990 "bisenti: chief! cortana says get to the bridge, double-quick.")
)

(script dormant dialog_fetch
	(sleep_until (> g_fetch_marine_progress 0) 1)
	(f_md_3d_play 0 sq_fetch_f m01_01000 "dubbo: sir, the captain needs you on the bridge asap. better follow me.")
	(sleep_until (volume_test_object tv_crossfire_trigger_5 sq_fetch_f) 1)
	(sleep 30)
	(f_md_3d_play 0 sq_fetch_f m01_00980 "dubbo: get clear, chief!")
	(sleep_until (volume_test_object tv_bridge_trigger_1 sq_fetch_f) 1)
	(if (not (volume_test_objects tv_bridge_trigger_2 (players)))
		(if (objects_can_see_object (players) (list_get (ai_actors sq_fetch_f) 0) 20)
			(f_md_3d_play 0 sq_fetch_f m01_01020 "dubbo: follow me, sir.")
			(f_md_3d_play 0 sq_fetch_f m01_01030 "dubbo: over here, chief.") ;else
		)
	)
	(sleep_until
		(and
			(objects_can_see_object (players) (list_get (ai_actors sq_fetch_f) 0) 20)
			(volume_test_objects tv_bridge_entrance (players))
		)
		1
	)
	(set s_music_trigger 41)
	(if (not mark_bridge_cutscene)
		(f_md_3d_play 0 sq_fetch_f m01_01040 "dubbo: captain keyes is waiting for us, sir!")
	)
)

(script dormant dialog_kill_kill_kill
	(f_md_2d_play_cortana 45 m01_09360 "cortana: what the hell are you doing!?")
	(f_md_2d_play_cortana 60 m01_09370 "cortana: security to the bridge, the master chief has gone rampant! take him down boys!")
	(f_md_2d_play_cortana 0 m01_09380 "cortana: that's it... i'm shutting you down.")
)

(script dormant dialog_shield_down
	(f_md_2d_play_cortana 0 m01_01870 "cortana: keep your head down! there's two of us in here now, remember?")
)

(script dormant dialog_post_bridge_cinematic
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 0 m01_01460 "cortana: the covenant have breached the command-deck! we have to stop them from taking the bridge!")
)

(script dormant dialog_cafeteria
	(f_md_2d_play_cortana 0 m01_01550 "cortana: those marines could use some help, chief. do what you do best.")
)

(script dormant dialog_airlock_explosion
	(if (< s_conversation_id_a15 1) (set s_conversation_id_a15 1))
	(branch
		(> s_conversation_id_a15 1) (f_md_abort)
	)

	(f_md_3d_play 0 sq_airlock_1_im m01_01500 "fitzgerald: what the hell? did something just hit us?")
	(set b_explosion_reacted true)
	(f_md_3d_play 30 sq_airlock_1_im m01_01510 "mendoza: move it! back to the airlock!" )
	(f_md_2d_play_cortana 0 m01_01520 "cortana: the damage to the superstructure is extensive. i don't know how much more abuse the autumn can take.")
)

(script dormant dialog_airlock
	(if (< s_conversation_id_a15 2) (set s_conversation_id_a15 2))
	(branch
		(> s_conversation_id_a15 2) (f_md_abort)
	)

	(f_md_2d_play_cortana 0 m01_01540 "cortana: they're using our lifeboat airlocks to attach their boarding craft! we go out and they come in. clever bastards.")
)

(script dormant dialog_overshield
	(sleep_until
		(or
			(unit_has_equipment player0 objects\equipment\overshield\overshield.equipment)
			(unit_has_equipment player1 objects\equipment\overshield\overshield.equipment)
			(unit_has_equipment player2 objects\equipment\overshield\overshield.equipment)
			(unit_has_equipment player3 objects\equipment\overshield\overshield.equipment)
		)
	)
	(f_md_2d_play_cortana 0 m01_09310 "cortana: that's a covenant overshield. i've created an interface patch that will let you use the device to augment your shields.")
)

(script dormant dialog_blast_door_warning
	(f_md_2d_play_cortana 15 m01_01630 "cortana: warning: blast doors closing. ")
)

(script dormant dialog_stairs
	(f_md_2d_play_cortana 0 m01_01570 "cortana: covenant! on the landing above us!")
)

(script dormant dialog_lifepod_launch
	(if (< s_conversation_id_a15 3) (set s_conversation_id_a15 3))
	(branch
		(> s_conversation_id_a15 3) (f_md_abort)
	)

	(f_md_2d_play_cortana 0 m01_01610 "cortana: the lifepods are launching! we should hurry.")
)

(script dormant dialog_lifepod_destroyed
	(if (< s_conversation_id_a15 4) (set s_conversation_id_a15 4))
	(branch
		(> s_conversation_id_a15 4) (f_md_skip_next)
	)

	(f_md_2d_play_cortana 0 m01_01620 "cortana: the covenant are destroying the lifepods. they really don't want us on that ring.")
)

(script dormant dialog_accessway
	(if (< s_conversation_id_a15 6) (set s_conversation_id_a15 6))
	(branch
		(> s_conversation_id_a15 6) (f_md_abort)
	)

	(f_md_2d_play_cortana 0 m01_01640 "cortana: we have to use the ship's maintenance accessways. follow the nav point, it will lead you to an opening.")
	(set s_navpoint_index 16)
)

(script dormant dialog_tracker
	(set b_show_radar true)
	(f_md_2d_play_cortana 15 m01_01650 "cortana: i'm detecting covenant movement outside the accessways. ")
	(if (not b_bypass_tutorials)
		(wake dialog_tutorial_tracker)
	)
)

(script dormant dialog_tutorial_tracker
	(if (< s_conversation_id_a15 7)
		(set s_conversation_id_a15 7)
	)
	(branch
		(> s_conversation_id_a15 7) (f_md_abort)
	)
	(f_md_2d_play_cortana 0 m01_09330 "cortana: my analysis suggests our exit will be behind a green-lit door. scan the area, chief.")
)

(script dormant dialog_too_close
	(branch
		(volume_test_players tv_melee_trigger_1) (f_md_abort) ;kill this script if the player leaves the tunnel without wandering this way.
	)
	(sleep_until
		(or
			(volume_test_objects tv_motiontracker_2 (players))
			(volume_test_objects tv_motiontracker_3 (players))
		) 1
	)
	(f_md_2d_play_cortana 0 m01_09340 "cortana: i've placed a nav point to mark a potential route.")
	(set s_navpoint_index 17)
)

(script dormant dialog_cortana_melee_tutorial
	(sleep_until (volume_test_players tv_melee_trigger_1) 1)
	(if (< s_conversation_id_a15 8)
		(set s_conversation_id_a15 8)
	)
	(branch
		(> s_conversation_id_a15 8) (f_md_abort)
	)
	(f_md_2d_play_cortana 0 m01_09320 "cortana: if you can get behind them, one melee hit to the back will neutralize most hostiles.")
	(sleep_until (<= (ai_living_count sq_tunnel_anti) 0))
	(f_md_2d_play_cortana 0 m01_01680 "cortana: motion tracker shows all-clear.")

)

(script dormant dialog_cryo_search
	(if (< s_conversation_id_a15 9)
		(set s_conversation_id_a15 9)
	)
	(branch
		(> s_conversation_id_a15 9) (f_md_abort)
	)
	(f_md_2d_play_cortana 0 m01_01660 "cortana: it looks like the covenant wanted to catch you napping.")
)

(script dormant dialog_final
	(set global_intercom false)
	(object_destroy_folder fo_ssobjects_captaincharlie)

	(f_md_2d_play_cortana 0 m01_01690 "cortana: there's one last lifeboat. quickly, get aboard before it launches.")

	(sleep_until b_dialog_final 1)

	(object_create ss_escape_pod_tubes_l)
	(sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01700_keyes ss_escape_pod_tubes_l 1) ; keyes: all remaining combat teams, pull out and abandon ship.
	(sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01700_keyes))
	(sleep (game_ticks_from_seconds 1.5))
	(sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01600_keyes ss_escape_pod_tubes_l 1) ; keyes: good luck. keyes out.
	(sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01600_keyes))
	(object_destroy ss_escape_pod_tubes_l)

	(if (> (ai_living_count sq_lifepod_2_anti) 0)
		(f_md_2d_play_cortana 0 m01_01710 "cortana: that lifeboat is our only way off this ship! kill those covenant before they blow the airlocks!")
	)
	(set s_music_trigger 200)
)

;====================================================================================================================================================================================================
; tannoys
;====================================================================================================================================================================================================

(global boolean global_intercom false)
(global short s_intercom_index 0)
(global short s_min_delay (game_ticks_from_seconds 30))
(global short s_max_delay (game_ticks_from_seconds 40))

; decides the emitter of each intercom vo based on player location
; separated out into multiple (cond) as it was running out of memory, due to nature of (cond) acting like nested if else statements
(script continuous flavor_intercom
	(sleep_until global_intercom 1)
	(cond
		((= s_intercom_index 10) (f_intercom_cortana ss_ship_hallway_cryo))
		((= s_intercom_index 20) (begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_00961_cortana ss_armory_access 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_00961_cortana)))) ; this one is specific to this vignette
		((and (> s_intercom_index 20) (< s_intercom_index 29)) (f_intercom_cortana ss_armory_access_2))
		((= s_intercom_index 30) (f_intercom_cortana ss_armory))
	)
	(cond
		((= s_intercom_index 40) (f_intercom_cortana ss_ship_hallway_starboard_l))
		((= s_intercom_index 41) (f_intercom_cortana ss_ship_hallway_starboard_l_2))
		((= s_intercom_index 50) (f_intercom_keyes_low ss_cafeteria))
		((= s_intercom_index 51) (f_intercom_keyes_low ss_cafeteria_2))
		((= s_intercom_index 52) (f_intercom_keyes_low ss_medical_access_r))
	)
	(cond
		((= s_intercom_index 60) (f_intercom_keyes_low ss_medical_triage_r))
		((= s_intercom_index 61) (f_intercom_keyes_low ss_ship_hallway_triage_l))
		((= s_intercom_index 62) (f_intercom_keyes_low ss_access_main_a_l))
	)
	(cond
		((= s_intercom_index 70) (f_intercom_keyes_low ss_access_main_a_l_2))
		((= s_intercom_index 71) (f_intercom_keyes_low ss_ship_hallway_blocked_l))
		((= s_intercom_index 72) (f_intercom_keyes_low ss_access_main_b_l))
		((= s_intercom_index 73) (f_intercom_keyes_low ss_access_main_b_l_2))
		((= s_intercom_index 74) (f_intercom_keyes_low ss_ship_hallway_aft_l))
		((= s_intercom_index 75) (f_intercom_keyes_low ss_ship_hallway_aft_l_2))

	)
	(cond
		((= s_intercom_index 80) (f_intercom_keyes_med ss_ship_hallway_aft_l_3))
		((= s_intercom_index 81) (f_intercom_keyes_med ss_stairs))
		((= s_intercom_index 82) (f_intercom_keyes_med ss_ship_hallway_stairs_a_l))
		((= s_intercom_index 83) (f_intercom_keyes_med ss_ship_hallway_stairs_a_l_2))

	)
	(cond
		((= s_intercom_index 90) (f_intercom_keyes_med ss_obs_lounge))
		((= s_intercom_index 91) (f_intercom_keyes_med ss_escape_pod_bay_c_l))
		((= s_intercom_index 100) (f_intercom_keyes_med ss_ship_hallway_flanking_b_l))
		((= s_intercom_index 101) (f_intercom_keyes_med ss_ship_hallway_flanking_b_l_2))
		((= s_intercom_index 102) (f_intercom_keyes_med ss_ship_hallway_cryo_a_l))

	)
	(cond
		((= s_intercom_index 110) (f_intercom_keyes_high ss_ship_hallway_cryo_b))
		((= s_intercom_index 120) (f_intercom_keyes_high ss_ship_hallway_damaged_l))
		((= s_intercom_index 130) (f_intercom_keyes_high ss_ship_hallway_escape_pod_a_l))
		((= s_intercom_index 131) (f_intercom_keyes_high ss_ship_hallway_escape_pod_a_l_2))
		((= s_intercom_index 132) (f_intercom_keyes_high ss_ship_hallway_escape_pod_a_l_3))
	)
	(sleep (random_range s_min_delay s_max_delay))
)

(script static void (f_intercom_cortana (object emitter))
	(begin_random_count 1
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_00941_cortana emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_00941_cortana)))
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01011_cortana emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01011_cortana)))
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01051_cortana emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01051_cortana)))
	)
)

; bucket of keyes intercom lines low urgency
(script static void (f_intercom_keyes_low (object emitter))
	(begin_random_count 1
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01441_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01441_keyes)))
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01471_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01471_keyes)))
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01491_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01491_keyes)))
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01581_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01581_keyes)))
	)
)

; bucket of keyes intercom lines medium urgency
(script static void (f_intercom_keyes_med (object emitter))
	(begin_random_count 1
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01531_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01531_keyes)))
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01481_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01481_keyes)))
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01451_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01451_keyes)))
	)
)

; bucket of keyes intercom lines high urgency
(script static void (f_intercom_keyes_high (object emitter))
	(begin_random_count 1
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01561_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01561_keyes)))
		(begin (sound_impulse_start sound/scripted/vo_scr_m01pillarofautumn/m01_01671_keyes emitter 1) (sleep (sound_impulse_language_time sound/scripted/vo_scr_m01pillarofautumn/m01_01671_keyes)))
	)
)

; dialog_flavor_ scripts sets index which chooses the intercom vo line based on player location, divided up by rally points
(script dormant dialog_flavor_cortana
	(sleep_until (volume_test_players tv_containment_1_trigger_1) 1)
	(object_create_folder fo_ssobjects_cortana) ; creates all sound scenery objects related to this section
	(set global_intercom true)
	(set s_intercom_index 10)

	(sleep_until (volume_test_players tv_first_contact_trigger_1) 1)
	(set s_intercom_index 20)

	(sleep_until (volume_test_players tv_first_contact_trigger_2) 1)
	(set s_intercom_index 21)

	(sleep_until (volume_test_players tv_crossfire_trigger_2) 1)
	(set s_intercom_index 22)

	(sleep_until (volume_test_players tv_crossfire_trigger_3) 1)
	(set s_intercom_index 30)

	(sleep_until (volume_test_players tv_crossfire_trigger_5) 1)
	(set s_intercom_index 40)

	(sleep_until (volume_test_players tv_bridge_trigger_1) 1)
	(set s_intercom_index 41)

	(sleep_until (volume_test_players tv_bridge_cinematic) 1)
	(set global_intercom false)
	(object_destroy_folder fo_ssobjects_cortana) ; destroys all sound scenery objects related to this section
)

(script dormant dialog_flavor_captain_bravo
	(sleep_until (volume_test_players tv_cafeteria_trigger_2) 1)
	(object_create_folder fo_ssobjects_captainbravo) ; creates all sound scenery objects related to this section
	(set global_intercom true)
	(set s_intercom_index 50)

	(sleep_until (volume_test_players tv_cafeteria_trigger_6) 1)
	(set s_intercom_index 51)

	(sleep_until (volume_test_players tv_cafeteria_trigger_5) 1)
	(set s_intercom_index 52)

	(sleep_until (volume_test_players tv_airlock_1_trigger_1) 1)
	(set s_intercom_index 60)

	(sleep_until (volume_test_players tv_airlock_1_trigger_3) 1)
	(set s_intercom_index 61)

	(sleep_until (volume_test_players tv_airlock_1_trigger_6) 1)
	(set s_intercom_index 62)

	(sleep_until (volume_test_players tv_flank_trigger_1) 1)
	(set s_intercom_index 70)

	(sleep_until (or (volume_test_players tv_flank_fireteam) (volume_test_players tv_flank_trigger_2)) 1)
	(set s_intercom_index 71)

	(sleep_until (volume_test_players tv_flank_trigger_5) 1)
	(set s_intercom_index 72)

	(sleep_until (or (volume_test_players tv_loop_trigger_2) (volume_test_players tv_loop_trigger_3)) 1)
	(set s_intercom_index 73)

	(sleep_until (volume_test_players tv_airlock_2_trigger_1) 1)
	(set s_intercom_index 74)

	(sleep_until (volume_test_players tv_airlock_2_trigger_2) 1)
	(set s_intercom_index 75)

	(sleep_until (volume_test_players tv_knot_trigger_2) 1)
	(set s_intercom_index 80)
)

(script dormant dialog_flavor_captain_charlie
	(sleep_until (volume_test_players tv_stairs_trigger_5) 1)
	(object_destroy_folder fo_ssobjects_captainbravo) ; destroys all sound scenery objects related to the previous section
	(object_create_folder fo_ssobjects_captaincharlie) ; creates all sound scenery objects related to this section
	(set s_intercom_index 81)

	(sleep_until (volume_test_players tv_containment_2_trigger_1) 1)
	(set s_intercom_index 82)

	(sleep_until (volume_test_players tv_intercom_trigger_83) 1)
	(set s_intercom_index 83)

	(sleep_until (volume_test_players tv_lifepod_1_trigger_1) 1)
	(set s_intercom_index 90)

	(sleep_until (volume_test_players tv_lifepod_trigger_3) 1)
	(set s_intercom_index 91)

	(sleep_until (volume_test_players tv_melee_trigger_2) 1)
	(set s_intercom_index 100)

	(sleep_until (volume_test_players tv_intercom_trigger_101) 1)
	(set s_intercom_index 101)

	(sleep_until (volume_test_players tv_tunnel_exit_trigger_2) 1)
	(set s_intercom_index 102)

	(sleep_until (volume_test_players tv_intercom_trigger_110) 1)
	(set s_intercom_index 110)

	(sleep_until (volume_test_players tv_boom_trigger_2) 1)
	(set s_intercom_index 120)

	(sleep_until (volume_test_players tv_intercom_trigger_130) 1)
	(set s_intercom_index 130)

	(sleep_until (volume_test_players tv_final_trigger_5) 1)
	(set s_intercom_index 131)

	(sleep_until (volume_test_players tv_intercom_trigger_132) 1)
	(set s_intercom_index 132)

	; object_destroy_folder is in dialog_final script
	; final intercom is in dialog_final script
)

;====================================================================================================================================================================================================
; play music
;====================================================================================================================================================================================================

(global short s_music_trigger 0)

(script dormant music_a15
	(print "music_a15 started")

	(sleep_until (> s_music_trigger 10) 1)
	(if (= s_music_trigger 20) (begin (music_event sound/music/a10/mus_02_opening_cinematic_end) (print "mus_02_cinematic_end")))

	(sleep_until (> s_music_trigger 20) 1)
	(if (= s_music_trigger 30) (begin (music_event sound/music/a10/mus_03_command_deck_cryo_death_hallway_encounter_start) (print "mus_03_command_deck_cryo_death_hallway_encounter_start")))

	(sleep_until (> s_music_trigger 30) 1)
	(if (= s_music_trigger 40) (begin (music_event sound/music/a10/mus_04_blast_door_elite_encounter_start) (print "mus_04_blast_door_elite_encounter_start")))

	(sleep_until (> s_music_trigger 40) 1)
	(if (= s_music_trigger 41) (begin (music_event sound/music/a10/mus_04a_blast_door_elite_encounter_end) (print "mus_04_blast_door_elite_encounter_end")))

	(sleep_until (> s_music_trigger 50) 1)
	(if (= s_music_trigger 60) (begin (music_event sound/music/a10/mus_06_messhall_encounter_start) (print "mus_06_messhall_encounter_start")))

	(sleep_until (> s_music_trigger 60) 1)
	(if (= s_music_trigger 70) (begin (music_event sound/music/a10/mus_07_messhall_encounter_end) (print "mus_07_messhall_encounter_end")))

	(sleep_until (> s_music_trigger 70) 1)
	(if (= s_music_trigger 80) (begin (music_event sound/music/a10/mus_08_ship_hit_encounter_start) (print "mus_08_ship_hit_encounter_start")))

	(sleep_until (> s_music_trigger 80) 1)
	(if (= s_music_trigger 90) (begin (music_event sound/music/a10/mus_09_airlock_encounter_start) (print "mus_09_airlock_encounter_start")))

	(sleep_until (> s_music_trigger 90) 1)
	(if (= s_music_trigger 100) (begin (music_event sound/music/a10/mus_10_airlock_encounter_intense_start) (print "mus_10_airlock_encounter_intense_start")))

	(sleep_until (> s_music_trigger 100) 1)
	(cond
		((= s_music_trigger 110) ; if player cleared encounter
			(begin
				(print "mus_11_airlock_encounter_intense_end")
				(music_event sound/music/a10/mus_11_airlock_encounter_intense_end)

				(sleep_until (> s_music_trigger 110) 1) ; ensures if player cleared encounter, mus_12 still triggers
				(if (= s_music_trigger 120) (begin (music_event sound/music/a10/mus_12_airlock_encounter_intense_end_safety) (print "mus_12_airlock_encounter_intense_end_safety")))
			)
		)
		((= s_music_trigger 120) ; if player ran ahead - safety
			(begin
				(print "mus_12_airlock_encounter_intense_end_safety")
				(music_event sound/music/a10/mus_12_airlock_encounter_intense_end_safety)
			)
		)
	)

	(sleep_until (> s_music_trigger 120) 1)
	(if (= s_music_trigger 130) (begin (music_event sound/music/a10/mus_13_stairwell_combat_encounter_start) (print "mus_13_stairwell_combat_encounter_start")))

	(sleep_until (> s_music_trigger 130) 1)
	(if (= s_music_trigger 140) (begin (music_event sound/music/a10/mus_14_stairwell_encounter_end) (print "mus_14_stairwell_encounter_end")))

	(sleep_until (> s_music_trigger 140) 1)
	(if (= s_music_trigger 150) (begin (music_event sound/music/a10/mus_15_stairwell_encounter_end_safety) (print "mus_15_stairwell_encounter_end_safety")))

	(sleep_until (> s_music_trigger 150) 1)
	(if (= s_music_trigger 160) (begin (music_event sound/music/a10/mus_16_escape_pods_access_tubes_encounter_start) (print "mus_16_escape_pods_access_tubes_encounter_start")))

	(sleep_until (> s_music_trigger 160) 1)
	(if (= s_music_trigger 170) (begin (music_event sound/music/a10/mus_17_escape_pods_access_tubes_encounter_end) (print "mus_17_escape_pods_access_tubes_encounter_end")))

	(sleep_until (> s_music_trigger 170) 1)
	(if (= s_music_trigger 180) (begin (music_event sound/music/a10/mus_18_final_combat_encounter_start) (print "mus_18_final_combat_encounter_start")))

	(sleep_until (> s_music_trigger 180) 1)
	(if (= s_music_trigger 190) (begin (music_event sound/music/a10/mus_19_final_combat_encounter_end) (print "mus_19_final_combat_encounter_end")))

	(sleep_until (> s_music_trigger 190) 1)
	(if (= s_music_trigger 200) (begin (music_event sound/music/a10/mus_20_heading_to_escape_pods_encounter_start) (print "mus_20_heading_to_escape_pods_encounter_start")))
)