;====================================================================================================================================================================================================
; vo ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant vo_initial_orders
	(ai_actor_dialogue_enable ai_fireteam_johnson false)
	(sleep_until (= (cinematic_in_progress) false) 1)
	(sleep (game_ticks_from_seconds 2))

	(if (< s_conversation_id 1) (set s_conversation_id 1))
	(branch (> s_conversation_id 1) (f_md_skip_next))

	(f_md_2d_play_cortana 0 m03_00120 "cortana: according to the topographic surveys i've obtained from the covenant battle network we should be able to access the covenant battle cruiser truth and reconciliation on foot. head through the series of plateaus and foot trails up ahead.")
	(sleep_until b_the_mission_has_begun 1)
	(f_md_3d_play 0 ai_fireteam_johnson m03_00064 "johnson: hit it, marines! go, go, go! the corps ain't payin' us by the hour!")
	(ai_actor_dialogue_enable ai_fireteam_johnson true)
)

(script dormant vo_area2_enter
	(if (< s_conversation_id 2) (set s_conversation_id 2))
	(branch (or (> s_conversation_id 2) (f_area2_combat_started)) (f_md_abort))

	(set s_music_trigger 20)
	(f_md_2d_play_cortana 30 m03_00130 "cortana: stick to the higher ground to the right. we should be able to recon the covenant position without being spotted.")
	(set b_stick_to_the_right_navpoint true)
	(f_md_2d_play_cortana 10 m03_00170 "cortana: get ready to move in to support us, sergeant. the master chief is going to covertly take out as many of the covenant as he can. don't open fire until you hear the enemy return fire on us. that should let us keep the element of surprise.")
	(f_md_2d_play 0 m03_00110 "johnson: yes ma'am.")
)

(script dormant vo_area2_encounter_start
	; moved to ai_play_line as these shouldn't prevent scripted dialogue progression with b_is_dialogue_playing
	(sleep (game_ticks_from_seconds 1))
	(ai_play_line ai_fireteam_johnson m03_00190)
	(print "johnson: open fire! open fire!")
	(sleep (game_ticks_from_seconds 0.8))
	(ai_play_line ai_fireteam_marines m03_00200)
	(print "bisenti: let em have it!")
)

(script dormant vo_area2_grunt_warning
	(if (< s_conversation_id 3)(set s_conversation_id 3))
	(branch	(> s_conversation_id 3) (f_md_abort))

	(if (>= (ai_living_count area2_gun_runner) 1)
		(f_md_2d_play_cortana 0 m03_00210 "cortana: alert! a covenant is making a run for that stationary gun. take him out!")
	)
)

(script dormant vo_area2_finish
	(if (< s_conversation_id 4) (set s_conversation_id 4))
	(branch (> s_conversation_id 4) (f_md_abort))
	
	(set s_music_trigger 40)
	(sleep (game_ticks_from_seconds 1))
	(f_md_3d_play 15 ai_fireteam_johnson m03_00220 "johnson: good work, marines. i guess you'll want to take point. we'll advance right behind you, sir.")
	(f_md_3d_play 0 ai_fireteam_marines m03_00230 "mendoza: that's why they pay us the big bucks, sarge. ")
	(set b_up_around_bend_navpoint true)

	(wake vo_area2_dawdle)
)

(script dormant vo_area2_dawdle
	(branch (> s_conversation_id 5) (f_md_abort)) ; abort when player reaches area3

	(sleep_until
		(begin
			(sleep_until (and (game_safe_to_save) (not b_is_dialogue_playing)) 1)
			(f_md_3d_play 0 ai_fireteam_johnson m03_00250 "johnson: okay men, same as last time. we'll hold up here while the chief scouts ahead. stay ready to advance as soon as the covenant open fire.")
			false
		)
	(game_ticks_from_seconds 45))
)

(script dormant vo_area3_approach
	(sleep_until
		(and
				(volume_test_players area3_music_trigger)
				(<= (ai_living_count area2_encounter) 0)
		)
	1)

	(if (< s_conversation_id 5) (set s_conversation_id 5))
	(branch (> s_conversation_id 5) (f_md_abort))

	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 0 m03_00240 "cortana: stop. motion tracker shows movement around the next bend.")
	(set s_music_trigger 50)
)

(script dormant vo_area3_encounter_start
	(sleep_until
		(and
			(volume_test_players area3_trigger_a)
			(= (ai_combat_status area3_encounter) dangerous)
		)
	1)

	(branch (> s_conversation_id 7) (f_md_abort))

	(ai_play_line ai_fireteam_marines m03_00260)
	(print "bisenti: let em have it!")
)

(script dormant vo_area3_ends
	(if (< s_conversation_id 7) (set s_conversation_id 7))
	(branch (> s_conversation_id 7) (f_md_abort))

	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play_cortana 15 m03_00270 "cortana: covenant forces detected up ahead. the path up on the left should let us sneak up around them.")
	(set b_sneak_up_canyon_navpoint true)
	(f_md_2d_play 0 m03_00280 "johnson: we'll hang back while you get into position, chief.")
)

(script dormant vo_area4_encounter_start
	(if (< s_conversation_id 8) (set s_conversation_id 8))
	(branch (> s_conversation_id 8) (f_md_abort))

	(f_md_2d_play_cortana 15 m03_00290 "cortana: cortana to fireteam charlie: move up on the left…you should be able to flank the enemy.")
	(set b_stick_to_the_left_navpoint true)
	(f_md_2d_play 0 m03_00300 "johnson: affirmative. moving up now.")
)

(script dormant vo_area4_end
	(sleep_until (volume_test_players area4_vo_music_end_trigger) 1)

	(if (< s_conversation_id 9)	(set s_conversation_id 9))
	(branch (> s_conversation_id 9) (f_md_abort))

	(f_md_2d_play_cortana 0 m03_00310 "cortana: we're directly under the ship now.")
	(f_md_2d_play 15 m03_00320 "johnson: good work, marines.")
	(f_md_2d_play 15 m03_00330 "bisenti: all right! are we bad or what?")
	(f_md_2d_play 15 m03_00340 "mendoza: mother of god…i never thought i'd get this close to one of those things. how the hell are we going to get inside that monster?")
	(f_md_2d_play_cortana 20 m03_00350 "cortana: the covenant use a gravity lift to move troops and supplies between the ship and the surface. we need to ambush them at the gravlift's loading zone and use the lift to enter the ship.")
	(if (= b_highground_encounter_cleared false) ; safety in case the players didn't properly clear the high-ground encounter previously.
		(set s_music_trigger 80) (print_if debug "safety music trigger")
	)
	(f_md_2d_play 0 m03_00360 "bisenti: oh, is that all. that's us: the few, the proud…the expendable. ")
)

(script dormant vo_area5_turret
	(sleep_until
		(and
			(script_finished "vo_area4_end")
			(volume_test_players area5_vo_trigger)
			(= (ai_combat_status area5_turret_gunners) dangerous)
			(or
				(vehicle_test_seat_unit_list area5_turret_a "" (ai_actors area5_turret_gunners))
				(vehicle_test_seat_unit_list area5_turret_b "" (ai_actors area5_turret_gunners))
				(vehicle_test_seat_unit_list area5_turret_c "" (ai_actors area5_turret_gunners))
				(vehicle_test_seat_unit_list area5_turret_d "" (ai_actors area5_turret_gunners))
				(vehicle_test_seat_unit_list area5_turret_e "" (ai_actors area5_turret_gunners))
			)
		)
	1)

	(if (< s_conversation_id 10) (set s_conversation_id 10))
	(branch (> s_conversation_id 10) (f_md_abort))

	(if (> (ai_living_count ai_fireteam_marines) 0)
			(begin
				(sleep (game_ticks_from_seconds 5))
				(f_md_2d_play 25 m03_00370 "fitzgerald: sir…those freakin' guns have us pinned down!")
			)
	)
)

(script dormant vo_area5_turret_response
	(sleep_until
		(and
			(script_finished "vo_area5_turret")
			(or
				(objects_can_see_object (players) area5_turret_a 30)
				(objects_can_see_object (players) area5_turret_b 30)
				(objects_can_see_object (players) area5_turret_c 30)
				(objects_can_see_object (players) area5_turret_d 30)
				(objects_can_see_object (players) area5_turret_e 30)
			)
		)

	1)

	(if (< s_conversation_id 11) (set s_conversation_id 11))
	(branch (> s_conversation_id 11) (f_md_abort))

	(f_md_2d_play_cortana 0 m03_00380 "cortana: we need to deal with those stationary guns. i recommend we clear out the gun emplacements on the ridges surrounding the pass. that should let the marines advance.")
)

(script dormant vo_area5_dropship_arrival
	(branch (script_started "vo_area5_hunters_arrival") (f_md_abort))


	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 30 m03_00390 "cortana: alert: covenant dropships are inbound…")
	(if (> (ai_living_count ai_fireteam_marines) 0)
		(f_md_2d_play 0 m03_00400 "bisenti: man, it's always something…")
	)

	(sleep_until
		(and
			(> (list_count_not_dead (ai_actors ai_fireteam_marines)) 1) ; checks if 1+ marines are alive
			(volume_test_objects area5_vo_trigger (ai_actors ai_fireteam_marines)) ; checks if marines are in area5
			(= (ai_combat_status ai_fireteam_marines) dangerous) ; checks if marines are in combat
			(> (list_count (volume_return_objects_by_type area5_vo_trigger 2)) 0) ; checks if turrets are still active
		)
	1)
	(f_md_2d_play_cortana 0 m03_00410 "cortana: those marines are outnumbered. we could secure one of those stationary guns and provide fire support...")

)

(script dormant vo_area5_hunters_arrival
	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play_cortana 30 m03_09080 "cortana: hunters!")
	(if (> (ai_living_count area5_hunters) 0)
		(f_md_2d_play_cortana 0 m03_09090 "cortana: flank and hit their exposed…worm bits.")
	)
)

(script dormant vo_area5_end
	(sleep (game_ticks_from_seconds 2.5))
	(f_md_2d_play_cortana 30 m03_00420 "cortana: cortana to echo-419. we've reached the gravity lift and are ready for reinforcements. ")
	(f_md_2d_play 0 m03_00430 "echo 419: copy that, cortana. hold tight, gentlemen … foehammer out.")
	(set b_gravpad_reins_dialogue_over true)
	(sleep_until (volume_test_object area5_dropship_trigger area5_pelican) 1)
	(f_md_2d_play 30 m03_00440 "echo 419: echo-419 inbound. clear the drop zone.")
	(f_md_2d_play 30 m03_00450 "bisenti: we've secured the area. let's square away the gravlift. marines: prepare for boarding action.")
	(f_md_2d_play_cortana 0 m03_00460 "cortana: once we're inside the ship, i can home in on the captain's command neural interface. he'll probably be in or near the ship's brig, which should narrow our search.")
)

(script dormant vo_gravroom_start
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 0 m03_00470 "cortana: we're in. i've got a good lock on the captain's cni transponder. no covenant defenses detected.")
	(set s_music_trigger 130)
	(sleep (game_ticks_from_seconds 4))
	(f_md_3d_play 0 ai_fireteam_marines m03_00480 "bisenti: what? there's no covenant here? you think maybe nobody's home? ")

	(sleep_until
		(and
			(volume_test_object gravity_trigger stealth_ini) ; make sure elite is in the room
			(> (ai_living_count stealth_ini) 0)	; make sure the elite is alive
		)
	1)
	(sleep_until (< (ai_living_fraction ai_player_fireteam) 1) 1) ; make sure someone found out the hard way

	(sleep (game_ticks_from_seconds 1))
	(f_md_3d_play -10 ai_fireteam_marines m03_00930 "bisenti: what th--?")
	(f_md_3d_play -10 ai_fireteam_marines m03_00940 "fitzgerald: hey! what the hell?")
	(f_md_2d_play_cortana 0 m03_00950 "cortana: stealth elites! watch your motion tracker and look for distortions in the air.")
	(f_md_3d_play -10 ai_fireteam_marines m03_00490 "mendoza: contact! lots of contact!")
	(f_md_3d_play 0 ai_fireteam_marines m03_00500 "fitzgerald: no covenant. you had to open your mouth.")

)

(script dormant vo_gravroom_end
	(if (< s_conversation_id 12) (set s_conversation_id 12))
	(branch (> s_conversation_id 12) (f_md_abort))
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_3d_play 15 ai_player_fireteam m03_00510 "mendoza: area secure, sir.")
	(f_md_3d_play 15 ai_player_fireteam m03_00520 "fitzgerald: quiet! they'll hear you…")
	(f_md_3d_play 0 ai_player_fireteam m03_00530 "mendoza: we'd better keep moving. how about that door?")
)

(script dormant vo_musterbay_locked_door_trigger
	(sleep_until
		(or
			(volume_test_players muster_bay_big_entrance) ; player runs to the locked musterbay door
			(volume_test_players tv_vo_post_gravlift) ; player goes through corridor first
		)
	1)

	(cond
		((volume_test_players muster_bay_big_entrance) (wake vo_musterbay_locked_door))
		((volume_test_players tv_vo_post_gravlift) (wake vo_post_gravlift))
	)
)

(script dormant vo_musterbay_locked_door
	(if (< s_conversation_id 13) (set s_conversation_id 13))
	(branch (> s_conversation_id 13) (f_md_abort))

	; if any marines survive gravroom encounter (johnson always survives) the fireteam marine lines are self-contained enough that we don't need all of them alive.
	(if (>= (ai_living_count ai_player_fireteam) 2)
		(begin
			(f_md_3d_play 25 ai_player_fireteam m03_00540 "mendoza: the door's locked, sir…i can't bypass it. we can't get through here.")
			(f_md_2d_play_cortana 0 m03_00550 "cortana: let's head back to the gravity lift bay. the side passages should provide an alternate route.")
			(set b_start_ship_navpoints true)
			(sleep (game_ticks_from_seconds 0.5))
			(f_md_3d_play 30 ai_player_fireteam m03_00560 "bisenti: we'd be sitting ducks in that narrow space. we can hold this position if you can find a way around and open the door from the other side, chief.")
			(f_md_2d_play_cortana 0 m03_00570 "cortana: chief, let's see if can find a way to open this door.")
		)
		; else
		(begin
			(f_md_2d_play_cortana 0 m03_00550 "cortana: let's head back to the gravity lift bay. the side passages should provide an alternate route.")
			(set b_start_ship_navpoints true) ; ensures navpoints still enable if player runs to locked door without surviving marines
		)
	)
)

(script dormant vo_post_gravlift
	(if (< s_conversation_id 14) (set s_conversation_id 14))
	(branch (> s_conversation_id 14) (f_md_abort))

	(f_md_2d_play_cortana 0 m03_00550 "cortana: let's head back to the gravity lift bay. the side passages should provide an alternate route.")
	(set b_start_ship_navpoints true)
)

(script dormant vo_musterbay_unlock_door_prompt
	(if (< s_conversation_id 15) (set s_conversation_id 15))
	(branch (> s_conversation_id 15) (f_md_abort))

	(set s_music_trigger 140)
	(if (> (ai_living_count ai_player_fireteam) 0)
		(f_md_2d_play_cortana 0 m03_00580 "cortana: wait … that's the locked door down there. the marines are waiting on the other side…the controls to open it must be somewhere in this room.")
	)
)

(script dormant vo_musterbay_door_open
	(branch (volume_test_players hangar_trigger) (f_md_abort)) ; abort if player is about to enter hangar bay

	(set s_music_trigger 150)
	(if (and
			(>= (ai_living_count ai_player_fireteam) 2)
			(= (ai_living_count muster_ini_encounter) 0)
		)
		(f_md_3d_play 0 ai_player_fireteam m03_00590 "bisenti: all clear, sir.")
	)

	(f_md_2d_play_cortana 15 m03_00600 "cortana: we should keep moving…but there's a danger of the covenant ambushing us from behind.")

	(if (and
			(>= (ai_living_count ai_player_fireteam) 3)
			(= (ai_living_count muster_ini_encounter) 0)
		)
		(f_md_3d_play 0 ai_player_fireteam m03_00610 "fitzgerald: allright everybody stay cool. yell if you see anything.")
	)
)

(script dormant vo_hangar_pelican_call
	(f_md_2d_play_cortana 30 m03_00640 "cortana: cortana to echo-419: requesting reinforcements at our position.")
	(f_md_2d_play -8 m03_00650 "echo 419: foehammer here, cortana. i read you -- but you're inside the covenant ship. i'm not sure i can --")
	(f_md_2d_play_cortana 10 m03_00660 "cortana: lock on to my signal and approach fast and low. there's a shuttle bay on the ship's starboard side.")
	(f_md_2d_play 0 m03_00670 "echo 419: roger, cortana. echo-419 on approach.")
	(set b_hangar_pelican_dialogue_over true)
)

(script dormant vo_hangarbay_end
	(if (< s_conversation_id 16) (set s_conversation_id 16))
	(branch (> s_conversation_id 16) (f_md_abort))

	(sleep (game_ticks_from_seconds 1))
	(if
		(and ; if marines survive hangar encounter and are in hangar
			(volume_test_objects hangar_area (ai_actors ai_player_fireteam))
			(> (list_count_not_dead (ai_actors ai_player_fireteam)) 2)
		)
		(begin
			(f_md_2d_play 0 m03_00680 "bisenti: hey, which way should we go now? all the doors on this level are locked!")
			(f_md_2d_play_cortana 0 m03_00690 "cortana: wait a moment…i'm going to access the covenant battle net and locate an override code to open a door.")
			(f_md_2d_play 0 m03_00700 "mendoza: you better hurry, cortana. we can't hold 'em off all day…")
			(f_md_2d_play_cortana 60 m03_00710 "cortana: working on it. i'd like to see you crack a hundred twenty-eight thousand bit modulating encryption key.")
			(set b_hangar_door_should_open true)
			(f_md_2d_play_cortana 0 m03_00720 "cortana: got it. the door is open. everyone should move through now: i can't guarantee that it won't lock again when it closes.")
		)
		; else (no marines survive hangar encounter or are in hangar)
		(begin
			(f_md_2d_play_cortana 90 m03_00690 "cortana: wait a moment…i'm going to access the covenant battle net and locate an override code to open a door.")
			(set b_hangar_door_should_open true)
			(sleep (game_ticks_from_seconds 1))
			(f_md_2d_play_cortana 0 m03_00720 "cortana: got it. the door is open. everyone should move through now: i can't guarantee that it won't lock again when it closes.")
		)
	)
)

(script dormant vo_bridge_cleared
	(f_md_2d_play_cortana 30 m03_00730 "cortana: this looks like the ship's command center.  the captain's transponder signal is strong, we must be close.")
	(f_md_2d_play_cortana 0 m03_09180 "cortana: cross-referencing covenant ship layouts... this area matches the configuration of a prisoner containment area.")

	(wake vo_bridge_dawdle)
)

(script dormant vo_bridge_dawdle
	(branch (>= s_conversation_id 18) (f_md_abort)) ; abort when player arrives to keyes' prison

	(f_md_dawdle_play 0 m03_00750 "cortana: there are probably multiple detention stations. the captain must be in one of them. we need to keep looking for him." 1)
)

(script dormant vo_prison
	(sleep_until
		(or
			(volume_test_players cellblock_a_trigger)
			(volume_test_players cellblock_b_trigger)
		)
	1)

	(if (< s_conversation_id 17) (set s_conversation_id 17))
	(branch (> s_conversation_id 17) (f_md_abort))

	(f_md_2d_play_cortana 0 m03_01160 "cortana: we must be in the brig…these look like holding cells. the captain should be nearby.")
)

(script dormant vo_prison_keyes
	(if (< s_conversation_id 18) (set s_conversation_id 18))
	(branch (= (cinematic_in_progress) true) (f_md_abort)) ; abort when cinematic starts

	(f_md_3d_play 0 captain m03_00760 "keyes: watch out, chief! the covenant guards are using some kind of stealth armor!")

	(sleep_until
		(and
			(= (ai_living_count stealth_elites_control) 0)
			(= (ai_living_count prison_cell_d_encounter) 0)
			(not b_captain_rescued)
		)
	1)

	(wake vo_prison_marine_chatter)
	(sleep_until (script_finished "vo_prison_marine_chatter"))
	(f_md_3d_play 60 captain m03_00790 "keyes: good work, chief. ")
	(f_md_3d_play 0 captain m03_00810 "keyes: chief: open these cells and let's get the hell out of here. the power control is along the back wall.")
)

(script dormant vo_prison_marine_chatter
	(sleep (game_ticks_from_seconds 1))
	(ai_play_line mar_nocap_cell_c m03_00770)
	(print "fitzgerald: it's the chief!")
	(sleep (game_ticks_from_seconds 1))
	(begin_random_count 1
		(begin
			(ai_play_line mar_nocap_cell_c m03_00800)
			(print "bisenti: that was amazing, sir! you really kicked the sh--")
			(sleep (game_ticks_from_seconds 1))
		)
		(begin
			(ai_play_line mar_nocap_cell_c m03_00780)
			(print "bisenti: chief! chief! let me out, man!")
			(sleep (game_ticks_from_seconds 1))
		)
	)
)

(script dormant vo_prison_freed_keyes
	(sleep (game_ticks_from_seconds 1.8))
	(f_md_2d_play_cortana 0 m03_00990 "cortana: we should head back to the shuttle bay and call for evac.")
	(set b_head_back_for_evac true)
	(sleep_until (volume_test_players vo_stealth_elite_keyes_trigger) 1)
	(set s_music_trigger 240)
	(f_md_2d_play_cortana 0 m03_01010 "cortana: cortana to echo-419. we have the captain and need extraction on the double! ")
	(f_md_2d_play 15 m03_01020 "echo 419: negative, cortana. i've been engaged by covenant air patrols…and i'm having a tough time shaking them. you'll be better off finding your own ride. sorry.")
	(f_md_2d_play_cortana 0 m03_01030 "cortana: acknowledged, foehammer. cortana out.")
	(f_md_3d_play 0 ai_fireteam_marines m03_01050 "bisenti: oh, man…we're trapped in here? we're screwed, we're screwed man!")
	(f_md_3d_play 15 captain m03_01060 "keyes: stow the belly aching soldier, remember you're a leatherneck!  cortana, if you and the chief can get us into one of those covenant dropships i can fly us out of here.")
	(f_md_2d_play_cortana 0 m03_01070 "cortana: yes, captain. there's a covenant dropship still docked.")
)

(script dormant vo_keyes_stealth_elites
	(sleep_until (volume_test_players control_prison_follow_player_trigger) 1)
	; wait to call out the elites
	(sleep_until
		(or
			(>= (ai_combat_status stealth_elites_control) visible) ; elites see enemies
			(<= (ai_nonswarm_count stealth_elites_control) 0) ; elites never saw them and died
		)
		1
	)
	; if the elites are alive at this point, they saw the player or marines so lets warn the player.
	(if (>= (ai_nonswarm_count stealth_elites_control) 1) (f_md_2d_play_cortana 0 m03_00950 "cortana: stealth elites! watch your motion tracker and look for distortions in the air."))

	(sleep_until (= (ai_nonswarm_count stealth_elites_control) 0) 1) ; nonswarm as the squad can be remixed
	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play_cortana 0 m03_00980 "cortana: that was close. marines: stay with the captain. the chief and i will sweep and clear the area of covenant forces. follow us, but keep the captain out of harm's way.")

)

(script dormant vo_entering_hangar
	(branch (= (device_group_get extraction_control_group) 1) (f_md_abort))

	(sleep_until (volume_test_players hangar_return_vo_trigger) 1)
	(f_md_2d_play_cortana 0 m03_01000 "cortana: we made it! use that panel to unlock the dropship.")
)

(script dormant vo_tutorial_camo
	(sleep_until (unit_has_equipment player0 objects\equipment\active_camouflage\active_camouflage.equipment) 1)
	(f_md_2d_play_cortana 0 m03_09290 "cortana: this is a covenant active camouflage device. it will make us invisible for a short time, or until we open fire.")
)

;=====================================================================w===============================================================================================================================
; music =============================================================d=================================================================================
;====================================================================================================================================================================================================

(global short s_music_trigger 0)

(script dormant music_a50
	(sleep_until (> s_music_trigger 10) 1)
	(if (= s_music_trigger 20) (begin (music_event sound/music/a50/mus_02_sniper_ambush_encounter_approach) (print "mus_02_sniper_ambush_encounter_approach")))

	(sleep_until (> s_music_trigger 20) 1)
	(if (= s_music_trigger 30) (begin (music_event sound/music/a50/mus_03_sniper_ambush_encounter_start) (print "mus_03_sniper_ambush_encounter_start")))

	(sleep_until (> s_music_trigger 30) 1)
	(if (= s_music_trigger 40) (begin (music_event sound/music/a50/mus_04_sniper_ambush_encounter_clear) (print "mus_04_sniper_ambush_encounter_clear")))

	(sleep_until (> s_music_trigger 40) 1)
	(if (= s_music_trigger 50) (begin (music_event sound/music/a50/mus_05_cliff_walk_transition_encounter_start) (print "mus_05_cliff_walk_transition_encounter_start")))

	(sleep_until (> s_music_trigger 50) 1)
	(if (= s_music_trigger 60) (begin (music_event sound/music/a50/mus_06_cliff_walk_transition_encounter_clear) (print "mus_06_cliff_walk_transition_encounter_clear")))

	(sleep_until (> s_music_trigger 60) 1)
	(if (= s_music_trigger 70) (begin (music_event sound/music/a50/mus_07_high_ground_encounter_start) (print "mus_07_high_ground_encounter_start")))

	(sleep_until (> s_music_trigger 70) 1)
	(if (= s_music_trigger 71) (begin (music_event sound/music/a50/mus_07a_high_ground_encounter_intense) (print "mus_07a_high_ground_encounter_intense")))

	(sleep_until (> s_music_trigger 71) 1)
	(if (= s_music_trigger 80) (begin (music_event sound/music/a50/mus_08_high_ground_encounter_clear) (print "mus_08_high_ground_encounter_clear")))

	(sleep_until (> s_music_trigger 80) 1)
	(if (= s_music_trigger 90) (begin (music_event sound/music/a50/mus_09_gravity_lift_encounter_start) (print "mus_09_gravity_lift_encounter_start")))

	(sleep_until (> s_music_trigger 90) 1)
	(if (= s_music_trigger 91) (begin (music_event sound/music/a50/mus_09a_gravity_lift_encounter_intense) (print "mus_09a_gravity_lift_encounter_intense")))

	(sleep_until (> s_music_trigger 91) 1)
	(if (= s_music_trigger 100) (begin (music_event sound/music/a50/mus_10_gravity_lift_encounter_hunters) (print "mus_10_gravity_lift_encounter_hunters")))

	(sleep_until (> s_music_trigger 100) 1)
	(if (= s_music_trigger 110) (begin (music_event sound/music/a50/mus_11_gravity_lift_encounter_clear) (print "mus_11_gravity_lift_encounter_clear")))

	; mus_12 removed from design

	(sleep_until (> s_music_trigger 110) 1)
	(if (= s_music_trigger 130) (begin (music_event sound/music/a50/mus_13_ship_gravity_lift_encounter_start) (print "mus_13_ship_gravity_lift_encounter_start")))

	(sleep_until (> s_music_trigger 130) 1)
	(if (= s_music_trigger 140) (begin (music_event sound/music/a50/mus_14_vehicle_access_hallway_locked_door) (print "mus_14_vehicle_access_hallway_locked_door")))

	(sleep_until (> s_music_trigger 140) 1)
	(if (= s_music_trigger 150) (begin (music_event sound/music/a50/mus_15_vehicle_access_hallway_unlocked_door) (print "mus_15_vehicle_access_hallway_unlocked_door")))

	(sleep_until (> s_music_trigger 150) 1)
	(if (= s_music_trigger 160) (begin (music_event sound/music/a50/mus_16_hangar_bay_encounter_start) (print "mus_16_hangar_bay_encounter_start")))

	(sleep_until (> s_music_trigger 160) 1)
	(if (= s_music_trigger 170) (begin (music_event sound/music/a50/mus_17_hangar_bay_encounter_intense_start) (print "mus_17_hangar_bay_encounter_intense_start")))

	(sleep_until (> s_music_trigger 170) 1)
	(if (= s_music_trigger 180) (begin (music_event sound/music/a50/mus_18_hangar_first_floor_encounter_clear) (print "mus_18_hangar_first_floor_encounter_clear")))

	(sleep_until (> s_music_trigger 180) 1)
	(if (= s_music_trigger 190) (begin (music_event sound/music/a50/mus_19_bridge_space_enter) (print "mus_19_bridge_space_enter")))

	(sleep_until (> s_music_trigger 190) 1)
	(if (= s_music_trigger 200) (begin (music_event sound/music/a50/mus_20_bridge_space_leave) (print "mus_20_bridge_space_leave")))

	(sleep_until (> s_music_trigger 200) 1)
	(if (= s_music_trigger 210) (begin (music_event sound/music/a50/mus_21_brig_access_passage_keyes_approach) (print "mus_21_brig_access_passage_keyes_approach")))

	(sleep_until (> s_music_trigger 230) 1)
	(if (= s_music_trigger 240) (begin (music_event sound/music/a50/mus_24_return_hangar_bay_encounter_start) (print "mus_24_return_hangar_bay_encounter_start")))

	; mus_25 conditional on keyes death, handled in separate script music_keyes_dies

	; mus_26 removed from design

	(sleep_until (> s_music_trigger 260) 1)
	(if (= s_music_trigger 270) (begin (music_event sound/music/a50/mus_27_bridge_escape) (print "mus_27_bridge_escape")))
)

(script dormant music_keyes_dies
	(music_event sound/music/a50/mus_25_keyes_death)
	(print "mus_25_keyes_death")
)