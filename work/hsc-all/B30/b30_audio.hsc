;====================================================================================================================================================================================================
; vo
;====================================================================================================================================================================================================

; ==== beat one =============================================================================================================
; from beach encounter to shaft a (locking door) to valley entrance to hunter bowl to jackal forest

(script dormant play_vo_beach_encounter_start
	(sleep_until (= (cinematic_in_progress) false) 1)
	(sleep (game_ticks_from_seconds 2.5)) ; safety to ensure marines have spawned

	(f_md_2d_play 10 m04_01040 "echo419: touchdown! hit it, marines!")
	(f_md_3d_play 15 unique_beach_lz/stacker m04_01050 "stacker: go go go!")
	(f_md_3d_play 0 unique_beach_lz/mendoza m04_00460 "mendoza: we got a covenant welcoming party, sir. they're dug in real tight, too.")
)

(script dormant trigger_vo_post_beach_encounter
	(branch (script_started "play_vo_shaft_a_outside") (f_md_abort)) ; cleaner - aborts when player sees shaft a

	(sleep_until
		(or
			(volume_test_players beach_2d) ; player ignores beach encounter and heads to shaft b
			(volume_test_players beach_1c) ; player ignores beach encounter and heads to shaft a
			(<= (ai_nonswarm_count sq_gr_beach) 0) ; player clears beach and arch encounter
		)
	1)

	(cond
		((<= (ai_nonswarm_count sq_gr_beach) 0) (wake play_vo_foehammer_warthog_drop))
		((volume_test_players beach_2d) (wake play_vo_wrong_way))
		((volume_test_players beach_1c) (wake play_vo_shafta_safety))
	)
)

(script dormant play_vo_wrong_way
	(f_md_2d_play_cortana 60 m04_00440 "cortana: the main facility must be nearby. look for a large entrance structure built into the cliffs.")
	(f_md_2d_play_cortana 0 m04_00430 "cortana: i've been able to pin point the main facility by cross-referencing covenant survey data and religious texts.  we were right, it's on this island.  i've marked the entrance with a nav point.")
	(set s_b30_music_request 41)
	(wake navpoint_beach_loop_1) ; activates navpoint breadcrumbing
)

(script dormant play_vo_shafta_safety
	(f_md_2d_play_cortana 0 m04_00430 "cortana: i've been able to pin point the main facility by cross-referencing covenant survey data and religious texts.  we were right, it's on this island.  i've marked the entrance with a nav point.")
	(wake navpoint_beach_loop_1) ; activates navpoint breadcrumbing - to do this is broken
	(set s_b30_music_request 31)
)

(script dormant play_vo_foehammer_warthog_drop
	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play_cortana 30 m04_00360 "cortana: area secure.")
	(f_md_2d_play 30 m04_00370 "echo 419: affirmative. echo-419 inbound. somebody order a warthog?")
	(f_md_2d_play 30 m04_00380 "stacker: hey i didn't know you made house calls, foehammer.")
	(f_md_2d_play 30 m04_00400 "echo 419: you know our motto--we deliver.")

	(sleep_until
		(or
			(player_in_vehicle v_beach_lz_warthog)
			(volume_test_players beach_1c) ; safety condition if player ignores warthog and heads to shaft a
		)
	1)

	(wake obj_find_map_room) ; find the entrance to the map room
	(f_md_2d_play_cortana 90 m04_00410 "cortana: let's go find the map room that will show us the location of halo's control center.")
	(f_md_2d_play_cortana 0 m04_00430 "cortana: i've been able to pin point the main facility by cross-referencing covenant survey data and religious texts.  we were right, it's on this island.  i've marked the entrance with a nav point.")
	(wake navpoint_beach_loop_1) ; activates navpoint breadcrumbing
)

(script dormant trigger_vo_shaft_a_outside
	; no branch needed - we still want to trigger if player unlocks shaft a without seeing the locked door

	(sleep_until b_shafta_seen 1) ; set true in b30.hsc/shafta_seen (trigger volume beach_3) or b30.hsc/set_shafta_already_seen (insertion point)
	(wake play_vo_shaft_a_outside)
)

(script dormant play_vo_shaft_a_outside
	(set s_b30_music_request 40)
	(f_md_2d_play_cortana 30 m04_00450 "cortana: there! in the cliff-wall. i'll bet the silent cartographer is somewhere inside that facility.")
	(sleep_until (volume_test_players shafta_platform) 1)
	(f_md_2d_play_cortana 0 m04_00480 "cortana: they're already inside! we have to get in there, and stop them before they learn the location of the control center.")
)

(script dormant trigger_vo_shaft_a_interior
	; no branch needed - we still want to trigger if player unlocks shaft a without seeing the locked door

	(sleep_until
		(or
			; if player goes deeper inside shaft a
			(volume_test_players shaft_a_path_down)
			; platform encounter (if player goes to shaft a first) is cleared
			(and
				(= b_shafta_unlocked false)
				(script_finished "place_shaft_a_beach") ; ensures encounter is placed
		   		(<= (ai_nonswarm_count interior_elite) 0)
				(<= (ai_nonswarm_count interior_grunt) 0)
			)
		)
	1)
	(wake play_vo_shaft_a_interior)
)

(script dormant play_vo_shaft_a_interior
	(if (< conversation_id 1) (set conversation_id 1))
	(branch (> conversation_id 1) (f_md_abort))

	(set s_b30_music_request 50)
	(f_md_2d_play_cortana 15 m04_00510 "cortana: the covenant are putting up a real fight... the cartographer must be here.")
	(f_md_2d_play_cortana 15 m04_00520 "cortana: my analysis indicates that the map room should be at the bottom floor of this facility.")
	(f_md_2d_play_cortana 0 m04_00530 "cortana: let's keep going inside. ")
)

(script dormant trigger_vo_shaft_a_door_warning
	(branch b_shafta_unlocked (f_md_abort)) ; aborts if player has already unlocked shaft a

	(sleep_until (volume_test_players shafta_door_warning) 1)
	(wake play_vo_door_will_be_locked)
)

(script dormant play_vo_door_will_be_locked
	(if (< conversation_id 2) (set conversation_id 2)) ; aborts play_vo_shaft_a_interior conversation if player sprints to locked door before conversation ends

	(sleep (game_ticks_from_seconds 0.3))
	(f_md_2d_play_cortana 0 m04_00540 "cortana: don't let them lock the doors!")
	(f_unblip_all)
)

(script dormant trigger_vo_shaft_a_door_locked
	(branch b_shafta_unlocked (f_md_abort)) ; aborts if player has already unlocked shaft a

	(sleep_until
		(and
			b_shafta_door_locked_seen ; set true in b30.hsc/players_arrive_shafta
			(or
				(<= (ai_nonswarm_count sq_gr_shaft_a_locked) 0)
				(volume_test_players shafta_platform) ; safety if player ignores encounter and goes back up to the beach
			)
		)
	1)

	(wake play_vo_door_is_locked)
	(wake play_vo_move_down_beach)
)

(script dormant play_vo_door_is_locked
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 30 m04_00550 "cortana: interesting. i underestimated the covenant's understanding of halo's subsystems.")
	(f_md_2d_play_cortana 30 m04_00570 "cortana: we need to find the security override to get this door open.")
	(f_blip_flag navpoint_main_facility 0)

	(wake remove_entrance_navpoint)
	(wake obj_door_is_locked) ; objective update: find the main security override

	(f_md_2d_play_cortana 45 m04_00580 "cortana: cortana to keyes.")
	(f_md_2d_play 25 m04_00590 "keyes: go ahead, cortana. have you found the control center?")
	(f_md_2d_play_cortana 30 m04_00600 "cortana: negative, captain. the covenant have impeded our progress.  we can't proceed unless we can disable this installation's security system.")
	(f_md_2d_play 30 m04_00610 "keyes: understood. we're still en route to the objective... i may be out of contact when we get there. ")
	(f_md_2d_play 30 m04_00620 "keyes: here are your orders: i want you to use any means necessary to force your way into the facility and find halo's control center.")
	(f_md_2d_play 0 m04_00640 "keyes: good luck, people. keyes out.")
)

(script dormant play_vo_move_down_beach
	(sleep_until (script_finished "play_vo_door_is_locked") 1)
	(sleep_until
		(or
			(volume_test_players beach_3)
			(volume_test_players beach_5)
		)
	1 (game_ticks_from_seconds 10)) ; safety time out in case player dawdles

	(sleep (game_ticks_from_seconds 2))
	(f_md_2d_play_cortana 0 m04_01005 "cortana: let's move down the beach. keep an eye out for any unusual structures that could house the security system.")

	(wake play_vo_dawdle_shaftb)
)

(script dormant play_vo_dawdle_shaftb
	(branch (volume_test_players valley_entrance) (f_md_abort)) ; abort dawdle when shaft b is discovered
	(sleep (game_ticks_from_seconds 300))
	(f_md_2d_play_cortana 0 m04_00650 "cortana: i've found the security system's override sub station and marked the entrance with a nav point.")
	(wake shaft_b_dawdle_nav_point)
)

(script dormant trigger_vo_ufo_remark
	(branch b_shafta_unlocked (f_md_abort)) ; aborts if player has already unlocked shaft a

	(sleep_until
		(and
			(volume_test_players downed_trigger)
			b_shafta_door_locked_seen
			(= b_shafta_unlocked false)
		)
	1)
	(wake play_vo_entrance_shaft_b_after_door)
)

(script dormant play_vo_entrance_shaft_b_after_door
	(f_md_2d_play_cortana 0 m04_00490 "cortana: well, there's the entrance to the security sub station, but it looks like we'll have to look for another way up.")
)

(script dormant trigger_vo_path_valley
	; no branch needed - this logic will trigger regardless

	(sleep_until
		(and
			(volume_test_players valley_arrival_trigger)
			b_shafta_door_locked_seen
		)
	1)
	(wake play_vo_path_valley)
)

(script dormant play_vo_path_valley
	(f_md_2d_play_cortana 0 m04_00500 "cortana: it looks like there is a path into the interior of the island.")
	(set b_valley_entrance_seen true)
	(wake put_np_valley_and_vo) ; navpoint for valley
)

(script dormant trigger_vo_hunter_bowl
	(sleep_until (volume_test_players valley_hunter_bowl) 1)
	(if (volume_test_object valley_hunter_bowl (ai_get_object sq_gr_marine_beach_lz)) (f_md_3d_play 0 sq_gr_marine_beach_lz m04_00470 "bisenti: anyone else see what i see? how're we supposed to get around that, huh?"))
)

; ==== beat two =============================================================================================================
; from jackal forest to shaft b (unlocking shaft a)

(script dormant vo_beat_two
	(print "vo_beat_two woken")

	(sleep_until (volume_test_players shaftb_control_entrance) 1)
	(if b_shafta_door_locked_seen (wake play_vo_security_system_seen))

	(sleep_until b_door_cinematic_played 1)
	(wake play_vo_security_system_disabled)

	(print "vo_beat_two complete")
)

(script dormant play_vo_security_system_seen
	(f_md_2d_play_cortana 0 m04_00660 "cortana: use the holo-panel to shut-down the security system.")
)

(script dormant play_vo_security_system_disabled
	(wake obj_after_door_unlocked); find the silent cartographer
	(if b_shafta_door_locked_seen
		(begin
			(sleep (game_ticks_from_seconds 1))
			(f_md_2d_play_cortana 30 m04_00680 "cortana: good. that should open the door that leads into the main shaft.")
		)
		; else - player did not see locked door in shaft a
		(begin
			(sleep (game_ticks_from_seconds 1))
			(f_md_2d_play_cortana 30 m04_00690 "cortana: this isn't the map room. analyzing. this is a security override station for the main facility, located somewhere else on this island.")
		)
	)
)

(script dormant chatter_hunter_shaft_b
	(sleep_until (script_finished "place_shaft_b_hunters") 1) ; finishes initializing hunters
	(sleep_until
		(and
			(volume_test_objects shaftb_encounter_room (ai_get_object wide_hunters))
			(objects_can_see_object (players) (ai_get_object wide_hunters) 30)
		)
	1)

	(sound_impulse_start sound\dialog\combat\hunter\default\02_combat\brsrk wide_hunters/spawnpoint 1)
	(sound_impulse_start sound\dialog\combat\hunter\default\02_combat\brsrk wide_hunters/spawnpoint1 1)
)

; ==== beat three =============================================================================================================
; from shaft b (after unlocking shaft a) to shaft a entrance

(script dormant vo_beat_three
	(print "vo_beat_three woken")

	(sleep_until (volume_test_players shaftb_control_hall) 1)
	(wake play_vo_after_door_unlocked)
	(wake play_vo_dawdle_shaft_a_not_returned)

	(sleep_until (volume_test_players downed_trigger_2) 1)
	(wake play_vo_bravo22_crash)

	(print "vo_beat_three complete")
)

(script dormant play_vo_after_door_unlocked
	(wake navpoints_to_shafta_awake)
	(set s_b30_music_request 80)
	(f_md_2d_play_cortana 15 m04_00700 "cortana: we need to go to the main facility. let's head back down the beach.")
	(f_md_2d_play 15 m04_00960 "bravo 22: mayday! mayday! dropship bravo-22 taking enemy fire. repeat: we are under heavy fire and are losing altitude. ")
	(f_md_2d_play_cortana 0 m04_01000 "cortana: understood. we're on our way.")
	(sound_impulse_start sound/levels/b30_scriptedevents_sfx/amb_scre_b30_pelican_crash b30_scenery_pelican_crashed 0)
)

(script dormant play_vo_bravo22_crash
	(f_md_2d_play_cortana 0 m04_01010 "cortana: chief, bravo-22 was bringing us some heavy weapons. after i saw we were up against hunters i thought you could use them.")
)

(script dormant play_vo_dawdle_shaft_a_not_returned
	(branch (script_started "vo_beat_four") (f_md_abort))
	(f_md_dawdle_play 30 m04_00710 "cortana: we should now have access to the main facility... let's find the map room." 5)
)


; ==== beat four =============================================================================================================
; from shaft a entrance to activating silent cartographer

(script dormant vo_beat_four
	(print "vo_beat_four woken")

	(sleep_until (volume_test_players shafta_vo_echo) 1)
	(wake play_vo_foehammer_to_groundteams)
	(wake play_vo_foehammer_to_groundteams_dawdle)

	(print "vo_beat_four complete")
)

(script dormant play_vo_foehammer_to_groundteams
	(branch b_shafta_switched (f_md_abort))

	(set s_b30_music_request 130)
	(f_md_2d_play 0 m04_00720 "echo 419: foehammer to ground teams. you've got two enemy dropships coming in fast. ")
	(f_md_2d_play 0 m04_00730 "stacker: damn it ... okay people... company's coming. engage enemy forces on sight.")
	(f_md_2d_play 0 m04_00740 "fitzgerald: everybody get ready for company!")
	(f_md_2d_play_cortana 0 m04_00750 "cortana: it'll be easier to hold them off from inside the structure. can you get inside?")
	(f_md_2d_play 0 m04_00760 "fitzgerald: negative. they're coming too fast -- they're right on top of us!")
	(f_md_2d_play 0 m04_00770 "stacker: chief, you've got to find the cartographer. we'll keep them busy as long as we can.")
	(f_md_2d_play_cortana 0 m04_00780 "cortana: give them hell, marine.")
	(set s_b30_music_request 140)
)

(script dormant play_vo_foehammer_to_groundteams_dawdle
	(branch (volume_test_players shafta_floor_cartographer) (f_md_abort))
	(sleep_until
		(begin
			(sleep_until (game_safe_to_save) 1)
			(f_md_2d_play 15 m04_00790 "fitzgerald: you better go for the cartographer, chief. we'll hold them off as long as we can. good luck, sir.")
			(f_md_2d_play_cortana 0 m04_00800 "cortana: we'll be in a tight spot if we don't get out of here before additional reinforcements arrive. the map room should be below us!")
			false
		)
	(game_ticks_from_seconds 180)) ; every 3 minutes
)

; ==== beat five =============================================================================================================
; from activating silent cartographer to leaving shaft a for extraction

(script dormant vo_beat_five
	(print "vo_beat_five woken")

	(sleep_until
		(or
			(volume_test_players map_room)
			(volume_test_players map_room2)
		)
	1)
	(wake play_vo_leave_map_room)

	(sleep_until (volume_test_players shafta_entrance) 1)
	(wake play_vo_requesting_pickup)

	(print "vo_beat_five complete")
)

(script dormant play_vo_leave_map_room
	(f_md_2d_play_cortana 0 m04_01900 "cortana: we have what we came for. let's get back to the upper floor.")

	(wake obj_leave_map_room) ; return to the surface for extraction
)

(script dormant play_vo_requesting_pickup
	(f_md_2d_play_cortana 0 m04_00890 "cortana: cortana to echo-419: the chief and i are topside. requesting pickup.")
	(f_md_2d_play 0 m04_00900 "echo 419: roger. on my way. ")
	(wake obj_rendezvous)
)

;====================================================================================================================================================================================================
; music
;====================================================================================================================================================================================================

(global short s_b30_music_request 0)
(global short s_b30_music_current 0)

(script continuous b30_music
	(sleep_until (!= s_b30_music_request s_b30_music_current) 1)
	(f_music_event_trigger s_b30_music_request)
)

(script static void (f_music_event_trigger (short request_number))
	(cond
		((= request_number 20) (begin (music_event sound/music/b30/mus_02_beach_encounter_start) (print "mus_02_beach_encounter_start")))
		((= request_number 30) (begin (music_event sound/music/b30/mus_03_beach_encounter_clear) (print "mus_03_beach_encounter_clear")))
		((= request_number 31) (begin (music_event sound/music/b30/mus_03a_beach_encounter_safety) (print "mus_03a_beach_encounter_safety")))
		((= request_number 41) (begin (music_event sound/music/b30/mus_04a_shaft_a_encounter_start_safety) (print "mus_04a_shaft_a_encounter_start_safety")))
		((= request_number 40) (begin (music_event sound/music/b30/mus_04_shaft_a_encounter_start) (print "mus_04_shaft_a_encounter_start")))
		((= request_number 50) (begin (music_event sound/music/b30/mus_05_shaft_a_encounter_clear) (print "mus_05_shaft_a_encounter_clear")))
		((= request_number 60) (begin (music_event sound/music/b30/mus_06_indoor_traversal) (print "mus_06_indoor_traversal")))
		((= request_number 61) (begin (music_event sound/music/b30/mus_06a_indoor_traversal_safety) (print "mus_06a_indoor_traversal_safety")))
		((= request_number 71) (begin (music_event sound/music/b30/mus_07a_door_cinematic_safety) (print "mus_07a_door_cinematic_safety")))
		((= request_number 80) (begin (music_event sound/music/b30/mus_08_mayday) (print "mus_08_mayday")))
		((= request_number 81) (begin (music_event sound/music/b30/mus_08a_invisible_elite_start) (print "mus_08a_invisible_elite_start")))
		((= request_number 90) (begin (music_event sound/music/b30/mus_09_outdoor_exit) (print "mus_09_outdoor_exit")))
		((= request_number 100) (begin (music_event sound/music/b30/mus_10_skip_ledge_cine_safety) (print "mus_10_skip_ledge_cine_safety")))
		((= request_number 120) (begin (music_event sound/music/b30/mus_12_cinematic_ledge_spawn) (print "mus_12_cinematic_ledge_spawn")))
		((= request_number 130) (begin (music_event sound/music/b30/mus_13_two_enemy_stinger) (print "mus_13_two_enemy_stinger")))
		((= request_number 140) (begin (music_event sound/music/b30/mus_14_map_room_search) (print "mus_14_map_room_search")))
		((= request_number 160) (begin (music_event sound/music/b30/mus_16_heading_there) (print "mus_16_heading_there")))
		((= request_number 170) (begin (music_event sound/music/b30/mus_17_indoor_enemies_clear) (print "mus_17_indoor_enemies_clear")))
		((= request_number 180) (begin (music_event sound/music/b30/mus_18_outdoor_enemies_clear) (print "mus_18_outdoor_enemies_clear")))
	)
	(set s_b30_music_current request_number)
)

; for dynamic music events based on player location for shaft b
(script dormant shaft_b_entrance_music_trigger
	; when player first enters shaft b
	(sleep_until (volume_test_players shaftb_entrance_music_ramp_mid) 1)
	(set s_b30_music_request 60)

	; checks player location to switch between indoor and outdoor music. exits sleep_until/while loop when unlocking shaft a
	(sleep_until
		(begin
			(cond
				((and (volume_test_players shaftb_entrance_music_safety) (= s_b30_music_current 60)) (set s_b30_music_request 61))
				((and (volume_test_players shaftb_entrance_music_ramp_mid) (= s_b30_music_current 61)) (set s_b30_music_request 60))
			)
			(= (device_get_position shaftb_control) 1)
		)
	1)
)

(script dormant shaft_b_inv_elite_music
	(sleep_until (script_finished "place_shaft_b_inv") 1) ; ensures invisible elites are placed
	(sleep_until
		(or
			(volume_test_players shaftb_encounter_room)
			(>= (ai_combat_status sq_gr_shaft_b_elites) "clear_los") ; safety - if elites start engaging player in hallway
		)
	1)
	(set s_b30_music_request 81)
)

(script dormant shaft_b_inv_exit_music
	(sleep_until (script_finished "place_shaft_b_inv") 1) ; ensures invisible elites are placed
	(sleep_until
		(or
			(= 0 (+ (ai_nonswarm_count sq_gr_shaft_b_elites) (ai_nonswarm_count sq_gr_shaft_b_hunters))) ; player clears encounter
			(volume_test_players shaftb_entrance_inv)
		)
	1)
	(set s_b30_music_request 90)
)

(script dormant music_trigger_16
	(sleep_until
		(or
			(volume_test_players shafta_jackal_music)
			(>= (ai_combat_status sq_gr_shafta_ramp_inv) "clear_los")

		)
	1)

	(set s_b30_music_request 160)
)

(script dormant music_trigger_17
	(sleep_until (volume_test_players shafta_slam) 1)
	(set s_b30_music_request 170)
)

(script dormant music_trigger_18
	(sleep_until (script_finished "exit_shaft_a_encounter") 1) ; wait until sq_gr_shaft_a_entrance_inv squad is placed
	(sleep_until (= 0 (ai_nonswarm_count sq_gr_shafta_entrance_inv)) 1)
	(set s_b30_music_request 180)
)