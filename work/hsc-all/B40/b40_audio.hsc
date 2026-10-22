;====================================================================================================================================================================================================
; vo ==============================================================================================================================================
;====================================================================================================================================================================================================

(global boolean b_players_unloaded false)

(script dormant vo_tower_intro
	(sleep_until (= (cinematic_in_progress) false) 1)
	(sleep (game_ticks_from_seconds 3))

	(if (< conversation_id 1) (set conversation_id 1))
	; golden path - no abort needed

	(f_md_2d_play 45 m05_00010 "echo: this is as far as i can go.")
	(f_md_2d_play_cortana 15 m05_00020 "cortana: roger that. we'll be able to find our way to the control center from here.")
	(f_md_2d_play 0 m05_00030 "echo: good luck, foehammer out.")

	(sleep_until b_players_unloaded 1)
	(sleep (game_ticks_from_seconds 1.5))
	(f_md_2d_play_cortana 0 m05_00040 "cortana: the covenant presence here is stronger than i anticipated. they seem to have the entire region secured.")
)

(script dormant vo_arena_a
	(sleep_until
		(or
			(volume_test_players tv_vo_arena_a)
			(volume_test_players tv_vo_arena_a2)
			(volume_test_players tv_vo_arena_a3)
		)
	1)

	(if (< conversation_id 2) (set conversation_id 2))
	; golden path - no abort needed

	(f_md_2d_play_cortana 0 m05_09010 "cortana: interesting. these lights seem to be responding to our proximity and guiding us to the exit.")
)

(script dormant vo_bridge_a_trigger
	(sleep_until (volume_test_players tv_vo_bridge_a) 1)
	(wake vo_bridge_a)

	(sleep_until (script_finished "vo_bridge_a") 1)
	(wake vo_dawdle_to_snowfield_a)
)

(script dormant vo_bridge_a
	(if (< conversation_id 3) (set conversation_id 3))
	(branch (> conversation_id 3) (f_md_skip_next))

	(f_md_2d_play_cortana -10 m05_00050 "cortana: interesting. the weather patterns here seem natural, not artificial. i wonder if the ring's environment systems are malfunctioning... or if the designers wanted the installation to have inclement weather.")
	(set b_zulupelicancallsforhelp true)
	(set s_music_trigger_b40 20)
	(f_md_2d_play 10 m05_00060 "bisenti: this is fireteam zulu! can anyone hear me?! we've got covenant all over us! can anyone hear me?!")
	(f_md_2d_play_cortana 0 m05_00080 "cortana: cortana to fireteam zulu i read you.")
	(f_md_2d_play 0 m05_00090 "bisenti: cortana? oh, man am i glad to hear from you! we're in a bad way here... covenant forces are all over us. transmitting our position now!")
	(f_md_2d_play_cortana 0 m05_00100 "cortana: coordinates received. fireteam zulu.")
	(set b_cortanahascalledoutrendezvous true)
	(sleep (game_ticks_from_seconds 0.5))
	(f_md_2d_play 15 m05_00120 "bisenti: roger that! but, with all due respect... step on it!")
	(f_md_2d_play_cortana 0 m05_00130 "cortana: wait... tracking data indicates we're almost on top of them, chief. they should be in the canyon below us... get a visual.")
)

(script dormant vo_dawdle_to_snowfield_a
	(branch (or (volume_test_players ext_a_trigger) (> conversation_id 5)) (f_md_abort)) ; aborts when player reaches snowfield_a

	(f_md_dawdle_play 0 m05_00170 "cortana: we should hurry. they can't hold out much longer." 5)
)

(script dormant vo_arena_b
	(sleep_until (volume_test_players tv_vo_arena_b) 1)

	(if (< conversation_id 4) (set conversation_id 4))
	(branch (> conversation_id 5) (f_md_abort))

	(sleep (game_ticks_from_seconds 0.8))
	(f_md_2d_play_cortana 0 m05_00140 "cortana: analyzing... if halo is a weapon, this entire valley must be the firing mechanism.")
)

(script dormant vo_elevator_a_trigger
	(sleep_until (volume_test_players tv_vo_elevator_a) 1)
	(wake vo_elevator_a)
)

(script dormant vo_elevator_a
	(if (< conversation_id 5) (set conversation_id 5))
	(branch (> conversation_id 5) (f_md_abort))

	(f_md_2d_play 0 m05_00150 "bisenti: cortana, i don't wanna be a pain the ass or anything, but... we need some help down here! where's the reinforcements?!")
	(f_md_2d_play_cortana 0 m05_00160 "cortana: we read you, fireteam zulu. on our way.")
)

(script dormant vo_snowfield_a_hijack_tip
	(branch
		(or														; branch if:
			(> conversation_id 5)									; the conversation proceeds, or
			(or														; you can no longer hijack the vehicle
				(= 0 (ai_living_count ext_a_area_a_cov_gpa))     			; check if pilot is gone
				(= 0 (object_get_health ext_a_dropship_ghost_a)) 			; distance check seems to automatically pass if the ghost is destroyed
			)
		) (f_md_abort)
	)

	(sleep_until
		(and											; the pilot is in the ghost and the player is close enough to the object
			(= (unit_get_vehicle ext_a_area_a_cov_gpa) ext_a_dropship_ghost_a)
			(> 11.5 (objects_distance_to_object (players) ext_a_dropship_ghost_a))	; 11.5 is the distance the ghost begins circle-strafing the player with the twin cannons.
		)
	1 )
	(f_md_2d_play_cortana 0 m05_09090 "cortana: it's risky, but if you get close we can hijack that covenant vehicle.")
)

(script dormant vo_snowfield_a_warthog_destroyed
	(branch (> conversation_id 5) (f_md_abort)) ; cleanup when vo_snowfield_a_reunion plays

	(sleep_until (<= (unit_get_health ext_a_pelican_whog) 0) 1)
	(if (> (ai_living_count ai_gr_marines_all) 0)
		(begin_random_count 1
			(f_md_2d_play 0 m05_00790 "bisenti: we lost the hog! this is not good! this is not good, man!")
			(f_md_2d_play 0 m05_00800 "mendoza: scratch one warthog. damn!")
			(f_md_2d_play 0 m05_00810 "dubbo: damn! there goes the warthog!")
			(f_md_2d_play 0 m05_00820 "fitzgerald: warthog eliminated, sir!")
		)
	)
)

(script dormant vo_snowfield_a_warning
	(branch (> conversation_id 5) (f_md_abort)) ; cleanup when vo_snowfield_a_reunion plays

	(sleep_until (>= (ai_combat_status ext_a_area_a_cov_wp) clear_los) 1)

	(if (> (ai_living_count ai_gr_marines_all) 0) (f_md_2d_play 0 m05_00190 "bisenti: here they come! take cover or those mortar tanks'll tear us apart!"))
	(set b_fireteamzulufoundinsnowfielda true)
)

(script dormant vo_snowfield_a_tank_clear
	(branch (> conversation_id 5) (f_md_abort)) ; cleanup when vo_snowfield_a_reunion plays

	(sleep_until (= 0 (ai_living_count ext_a_area_a_cov_wp)) 1)
	(if (> (ai_living_count ai_gr_marines_all) 0) (f_md_2d_play 0 m05_00200 "bisenti: looks like that armor wasn't so tough after all... let's mop up the rest of them."))
)

(script dormant vo_snowfield_a_reunion_trigger
	(branch (> conversation_id 6) (f_md_abort))
	(sleep_until
		(and
			(= (ai_living_count sq_gr_snowfield_a_conditionals) 0)
			(= (ai_living_count sq_gr_snowfield_a_front) 0)
			(= (ai_living_count sq_gr_snowfield_a_vehicles) 0)
		)
	1)
	(set s_music_trigger_b40 110)
	(if (> (ai_living_count ai_gr_marines_all) 0) (wake vo_snowfield_a_reunion))
)

(script dormant vo_snowfield_a_reunion
	(if (< conversation_id 6) (set conversation_id 6))
	(branch (> conversation_id 6) (f_md_abort))

	(f_md_2d_play 0 m05_00210 "bisenti: hostiles eliminated... we cooked 'em good, sir!")
	(f_md_2d_play_cortana 0 m05_00220 "cortana: i thought the covenant had eliminated all the marine forces in this area.")
	(f_md_2d_play 0 m05_00230 "bisenti: they gave it their best shot, but they didn't count on running into the biggest squad of marine bad-asses in the corps.")
)

(script dormant vo_snowfield_a_scorpion
	(sleep_until (volume_test_players tv_vo_snowfield_a_scorpion) 1)
	(if (< conversation_id 7) (set conversation_id 7))
	; golden path - no abort needed

	(f_md_2d_play_cortana 0 m05_09020 "cortana: alert! i'm detecting a scorpion tank up ahead. we should use that to punch through the covenant defenses.")
	(set b_cortanahascalledoutscorpion true)
)

(script dormant vo_snowfield_b_reunion_trigger
	(branch (> conversation_id 8) (f_md_abort))
	(sleep_until (volume_test_players tv_vo_snowfield_b_reunion) 1)
	(wake vo_snowfield_b_reunion)
)

(script dormant vo_snowfield_b_reunion
	(if (< conversation_id 8) (set conversation_id 8))
	(branch (> conversation_id 8) (f_md_abort))

	(f_md_3d_play -5 ai_gr_marines_snowfield_b m05_00250 "fitzgerald: hell! we can't hold them off again. we need to bug out!")
	(f_md_3d_play 15 ai_gr_marines_snowfield_b m05_00260 "mendoza: shut up! show some backbone, amigo. we're all in this together.")
	(f_md_2d_play_cortana 0 m05_00270 "cortana: negative, team. no evac available at this time... but the chief and i could use some assistance.")
)

(script dormant vo_scorpion_destroyed
	(branch (volume_test_players np_trigger_14_small_cave) (f_md_abort)) ; aborts when player reaches small cave to snowfield_g, which is the last location the scorpion can reach

	(sleep_until (<= (unit_get_health ext_a_tank) 0) 1)
	(if (> (ai_living_count ai_gr_marines_all) 0)
		(begin_random_count 1
			(f_md_2d_play 15 m05_00830 "bisenti: damn it! we just lost the scorpion... oh man, we're screwed...")
			(f_md_2d_play 15 m05_00840 "mendoza: damn it. the scorpion just bought it!")
			(f_md_2d_play 15 m05_00850 "dubbo: the covenant just scrapped our tank! ")
			(f_md_2d_play 15 m05_00860 "fitzgerald: our scorpion has been destroyed... say again: our scorpion has been destroyed.")
		)
	)
)

(script dormant vo_snowfield_b_cleared_trigger
	(branch (> conversation_id 9) (f_md_abort))
	(sleep_until
		(and
			(script_finished "vo_snowfield_b_reunion")
			(< (ai_living_count ext_a_area_b_cov_bug_audio_out) 3)
			(> (ai_living_count ai_gr_marines_all) 0)
		)
	1)
	(wake vo_snowfield_b_cleared)
)

(script dormant vo_snowfield_b_cleared
	(if (< conversation_id 9) (set conversation_id 9))
	(branch (> conversation_id 9) (f_md_abort))

	(f_md_3d_play 0 ai_gr_marines_all m05_00290 "dubbo: chief! good thing you showed up when you did, sir.")
	(f_md_2d_play_cortana 0 m05_00300 "cortana: we could use a hand, yankee. link up with zulu and follow us.")
	(f_md_3d_play 0 ai_gr_marines_all m05_00310 "dubbo: affirmative. form up on the master chief and get ready to move out!")
)

(script dormant vo_snowfield_c_ice_tunnel
	(branch (> conversation_id 9) (f_md_abort)) ; cleanup when vo_snowfield_c_intro plays

	(sleep_until
		(and
			(= (any_players_in_vehicle) false)
			(volume_test_players tv_vo_ice_tunnel)
		)
	1)

	(f_md_2d_play_cortana 0 m05_00320 "cortana: we need to get to that tunnel, marines. let's move in.")
	(set b_cortanahascalledouticetunnel true)
)

(script dormant vo_snowfield_c_intro_trigger
	(sleep_until
		(or
			; through path
			(volume_test_players tv_vo_snowfield_c_intro)

			; past ice tunnel
			(volume_test_players tv_vo_snowfield_c_intro2)
		)
	1)

	(wake vo_snowfield_c_intro)
)

(script dormant vo_snowfield_c_intro
	(if (< conversation_id 10) (set conversation_id 10))
	; golden path - no abort needed

	(if (> (ai_living_count ai_gr_marines_all) 0) (f_md_2d_play 30 m05_00330 "dubbo: bloody hell... enemy forces have armor support. time to earn our pay, boys."))
	(set b_cortanahascalledouttunnela true)
	(f_md_2d_play_cortana 0 m05_00340 "cortana: the covenant placed their tanks to defend the entrance to the tunnel.")
)

(script dormant vo_snowfield_c_wraith_destroyed
	(branch (> conversation_id 10) (f_md_abort)) ; abort ensures this doesn't play if wraith is the last enemy of the encounter, vo_snowfield_c_clear should play instead

	(sleep_until
		(and
			(script_finished "encounter_snowfield_c")
			(= (ai_living_count ext_a_area_c_cov_wcp) 0)
			(= (ai_living_count ext_a_area_c_cov_wbp) 0)
			(> (ai_living_count ext_a_area_c_cov) 0) ; only play if rest of encounter is still alive
		)
	1)

	(sleep (game_ticks_from_seconds 1))
	(f_md_2d_play 0 m05_00360 "dubbo: bingo! that's the last of the mortar tanks! let's sweep and clear the stragglers, team!")
)

(script dormant vo_snowfield_c_clear
	(branch (> conversation_id 11) (f_md_abort))

	(sleep_until
		(and
			(script_finished "encounter_snowfield_c")
			(= (ai_living_count ext_a_area_c_cov_eu) 0)
			(= (ai_living_count ext_a_area_c_cov_ew) 0)
			(= (ai_living_count ext_a_area_c_cov_gbp) 0)
			(= (ai_living_count ext_a_area_c_cov_gcp) 0)
			(= (ai_living_count ext_a_area_c_cov_gu) 0)
			(= (ai_living_count ext_a_area_c_cov_gw) 0)
			(= (ai_living_count ext_a_area_c_cov_gw2) 0)
			(= (ai_living_count ext_a_area_c_cov_gy) 0)
			(= (ai_living_count ext_a_area_c_cov_jq) 0)
			(= (ai_living_count ext_a_area_c_cov_ju) 0)
			(= (ai_living_count ext_a_area_c_cov_jy) 0)
			(= (ai_living_count ext_a_area_c_cov_tag) 0)
			(= (ai_living_count ext_a_area_c_cov_tbg) 0)
			(= (ai_living_count ext_a_area_c_cov_tcg) 0)
			(= (ai_living_count ext_a_area_c_cov_tdg) 0)
			(= (ai_living_count ext_a_area_c_cov_teg) 0)
			(= (ai_living_count ext_a_area_c_cov_wbp) 0)
			(= (ai_living_count ext_a_area_c_cov_wcp) 0)
			(= (ai_living_count ext_a_area_c_cov_bp) 0)
		)
	1)

	(if (< conversation_id 11) (set conversation_id 11))
	(sleep (game_ticks_from_seconds 1))
	(if (> (ai_living_count ai_gr_marines_all) 0) (f_md_2d_play 0 m05_00370 "dubbo: well that's the last of them. we might be home in time for dinner, everyone."))
)

(script dormant vo_tunnel_a_door
	(sleep_until (volume_test_players tv_vo_tunnel_a) 1)
	(if (< conversation_id 12) (set conversation_id 12))
	; golden path - no abort needed

	(f_md_2d_play_cortana 0 m05_00380 "cortana: the tunnel door is locked... we need to find the door's controls and open it.")
	(set b_cortanahascalledoutchasmdoor true)
)

(script dormant vo_crevasse_intro
	(branch (> conversation_id 12) (f_md_abort))
	(sleep_until (volume_test_players tv_vo_crevasse_intro) 1)

	(if (> (ai_living_count ai_gr_marines_all) 0) (f_md_2d_play 0 m05_00390 "dubbo: contact! more covenant forces sighted!"))
)

(script dormant vo_large_tunnel_b_intro
	(branch (> conversation_id 12) (f_md_abort))
	(sleep_until (objects_can_see_object (players) (ai_get_object gr_ext_b_area_a_cov_t) 15) 1)

	(if (> (ai_living_count ai_gr_marines_all) 0) (f_md_2d_play 0 m05_00400 "fitzgerald: more covenant sighted! man, these guys are like cockroaches!"))
)

(script dormant vo_snowfield_g_intro_trigger
	(sleep_until (volume_test_players tv_vo_snowfield_g_intro) 1)
	(wake vo_snowfield_g_intro)
)

(script dormant vo_snowfield_g_intro
	(if (< conversation_id 13) (set conversation_id 13))
	; golden path - no abort needed

	(f_md_2d_play 0 m05_00410 "dubbo: looks like the covenant are dug in up there in those rocks, chief. we're totally hemmed in.")
	(set s_music_trigger_b40 170)
	(if (volume_test_object tv_vo_ridge_marine_check (ai_get_object ai_gr_marines_all))
		; if marines have followed you to ridge
		(f_md_2d_play_cortana 0 m05_00430 "cortana: marines: hold your positions. we'll handle those guns. master chief: we should scale the ridge and get below those stationary guns.")

		; else - if alone
		(f_md_2d_play_cortana 0 m05_00420 "cortana: we need to get up this ridge.")
	)
	(set b_marines_halted true)
	(f_md_2d_play 0 m05_00440 "bisenti: i'm in no hurry for a heroic charge on those guns, cortana. holding position.")

	(wake vo_snowfield_g_in_vehicle_dawdle)
)

(script dormant vo_snowfield_g_in_vehicle_dawdle
	(branch (> conversation_id 13) (f_md_abort)) ; cleanup when vo_snowfield_g_outro plays

	(sleep_until
		(begin
			(if (and (game_safe_to_save) (any_players_in_vehicle))
				(f_md_2d_play_cortana 0 m05_09100 "cortana: it looks like we need to continue on foot.")
			)
			false ; never stop, will be put to sleep by branch
		)
	(game_ticks_from_seconds 120)) ; loop every 2 mins
)

(script dormant vo_snowfield_g_outro_trigger
	(sleep_until
		(or
			(and
				(= 0 (ai_living_count gr_ext_b_area_b_cave_reinf)) 	; cave reinforcements
				(= 0 (ai_living_count gr_ext_b_area_b_rocks)) 		; rocks squad, rock turret, and the banshee(s) (part of rocks because of when it spawns)
				(= 0 (ai_living_count gr_ext_b_area_c_cov_bunker)) 	; door turrets and the three ghosts
			)
			(volume_test_players tv_vo_small_tunnel_e) ; if player runs past encounters in snowfield g to small tunnel e
		)
	1)
	(wake vo_snowfield_g_outro)
)

(script dormant vo_snowfield_g_outro
	(if (< conversation_id 14) (set conversation_id 14))
	; golden path - no abort needed

	(sleep (game_ticks_from_seconds 1)) ; a breath after the last kill so the line isn't too abrupt.
	(set s_music_trigger_b40 190)
	(set b_cortanahastoldbisentitowait true) ; set before the line so the marines start moving early

	(f_md_2d_play_cortana 0 m05_00460 "cortana: cortana to fireteam zulu: i've sent a distress call tagged with your current position. hold your current position and await evac. the master chief and i are going to continue on ahead.")
	(f_md_2d_play 0 m05_00470 "bisenti: roger! okay people... evac bird's on its way! ")
)

(script dormant vo_bridge_e_hunters
	(sleep_until (volume_test_players tv_vo_bridge_e) 1)

	(if (< conversation_id 15) (set conversation_id 15))
	; golden path - no abort needed

	(f_md_2d_play_cortana 0 m05_00490 "cortana: resistance appears to be increasing. we must be close to the control center.")
)

(script dormant vo_ziggurat
	(sleep_until (= (device_get_position c_bridge_door_near) 1) 1)

	(if (< conversation_id 16) (set conversation_id 16))
	; golden path - no abort needed

	(f_md_2d_play_cortana 0 m05_00500 "cortana: analyzing... this must be the control room. subtle.")
	(set b_cortanahascalledoutziggurat true)
)

(script dormant vo_ziggurat_banshee_trigger
	(sleep_until (volume_test_players tv_vo_ziggurat_banshee) 1)
	(sleep_until (script_finished "vo_ziggurat") 1)
	(wake vo_ziggurat_banshee)
)

(script dormant vo_ziggurat_banshee
	(if (< conversation_id 17) (set conversation_id 17))
	(branch (> conversation_id 17) (f_md_abort))

	(set s_music_trigger_b40 300)
	(f_md_2d_play_cortana 0 m05_00510 "cortana: look! covenant banshees. we can use them to fly straight to the control structure. don't let anyone else touch them.")
)

(script dormant vo_ziggurat_directive
	(branch (volume_test_players tv_music_trigger_31) (f_md_abort)) ; aborts when player reaches the top of the ziggurat
	(sleep_until
		(or
			(player_in_banshee)
			(volume_test_players tv_vo_ziggurat_directive)
		)
	1)

	(if (< conversation_id 18) (set conversation_id 18))
	; golden path - no abort needed

	(sleep 15)
	(f_md_2d_play_cortana 0 m05_00530 "cortana: the entrance to the control center is at the top of that pyramid structure. bring me up there and i should be able to get us inside. ")
)

(script dormant vo_snowfield_h_ghosts
	(branch (volume_test_players tv_music_trigger_31) (f_md_abort)) ; aborts when player reaches the top of the ziggurat

	(sleep_until (volume_test_players tv_vo_snowfield_h_ghosts) 1)
	(if (and
			(> (unit_get_health ext_c_ghost_a) 0)
			(> (unit_get_health ext_c_ghost_b) 0)
			(> (unit_get_health ext_c_ghost_c) 0)
		)
		(f_md_2d_play_cortana 0 m05_00550 "cortana: we should commandeer that covenant vehicle... we're going to need the firepower.")
	)
)

;====================================================================================================================================================================================================
; music ==============================================================================================================================================
;====================================================================================================================================================================================================

(global short s_music_trigger_b40 0)

(script dormant b40_music_controller
	(print "b40_music_controller started")

	; mus_01 removed from design
	(sleep_until (> s_music_trigger_b40 10) 1)
	(if (= s_music_trigger_b40 20)
		(begin (music_event sound/music/b40/mus_02_bridge_encouter_start) (print "mus_02_bridge_encouter_start")))

	(sleep_until (> s_music_trigger_b40 20) 1)
	(if (= s_music_trigger_b40 30)
		(begin (music_event sound/music/b40/mus_03_bridge_encounter_stop) (print "mus_03_bridge_encounter_stop")))

	(sleep_until (> s_music_trigger_b40 30) 1)
	(if (= s_music_trigger_b40 40)
		(begin (music_event sound/music/b40/mus_04_small_tunnel_k_encounter_start) (print "mus_04_small_tunnel_k_encounter_start")))

	(sleep_until (> s_music_trigger_b40 40) 1)
	(if (= s_music_trigger_b40 50)
		(begin (music_event sound/music/b40/mus_05_arena_b_encounter_start) (print "mus_05_arena_b_encounter_start")))

	(sleep_until (> s_music_trigger_b40 50) 1)
	(if (= s_music_trigger_b40 60)
		(begin (music_event sound/music/b40/mus_06_arena_b_encouter_clear) (print "mus_06_arena_b_encouter_clear")))

	(sleep_until (> s_music_trigger_b40 60) 1)
	(if (= s_music_trigger_b40 70)
		(begin (music_event sound/music/b40/mus_07_arena_b_encounter_clear_safety) (print "mus_07_arena_b_encounter_clear_safety")))

	; mus_08 and mus_09 removed from design

	(sleep_until (> s_music_trigger_b40 90) 1)
	(if (= s_music_trigger_b40 100)
		(begin (music_event sound/music/b40/mus_10_snow_field_b_encounter_start) (print "mus_10_snow_field_b_encounter_start")))

	(sleep_until (> s_music_trigger_b40 100) 1)
	(if (= s_music_trigger_b40 110)
		(begin (music_event sound/music/b40/mus_11_snow_field_b_encounter_end) (print "mus_11_snow_field_b_encounter_end")))

	(sleep_until (> s_music_trigger_b40 110) 1)
	(if (= s_music_trigger_b40 120)
		(begin (music_event sound/music/b40/mus_12_snow_field_encounter_end_saftey) (print "mus_12_snow_field_encounter_end_saftey")))

	(sleep_until (> s_music_trigger_b40 120) 1)
	(if (= s_music_trigger_b40 130)
		(begin (music_event sound/music/b40/mus_13_large_tunnel_a_hunter_encounter_start) (print "mus_13_large_tunnel_a_hunter_encounter_start")))

	(sleep_until (> s_music_trigger_b40 130) 1)
	(if (= s_music_trigger_b40 140)
		(begin (music_event sound/music/b40/mus_14_chasm_encounter_start) (print "mus_14_chasm_encounter_start")))

	(sleep_until (> s_music_trigger_b40 140) 1)
	(if (= s_music_trigger_b40 150)
		(begin (music_event sound/music/b40/mus_15_chasm_encounter_end) (print "mus_15_chasm_encounter_end")))

	(sleep_until (> s_music_trigger_b40 150) 1)
	(if (= s_music_trigger_b40 151)
		(begin (music_event sound/music/b40/mus_15a_mor1_start) (print "mus_15a_mor1_start")))

	(sleep_until (> s_music_trigger_b40 151) 1)
	(if (= s_music_trigger_b40 152) 
		(begin (music_event sound/music/b40/mus_15b_mor1_safety) (print "mus_15b_mor1_safety")))

	(sleep_until (> s_music_trigger_b40 159) 1)
	(if (= s_music_trigger_b40 160)
		(begin (music_event sound/music/b40/mus_16_meet_marineds_encounter_start) (print "mus_16_meet_marineds_encounter_start")))

	(sleep_until (> s_music_trigger_b40 160) 1)
	(if (= s_music_trigger_b40 170)
		(begin (music_event sound/music/b40/mus_17_up_the_ridge_encounter_start) (print "mus_17_up_the_ridge_encounter_start")))

	(sleep_until (> s_music_trigger_b40 170) 1)
	(if (= s_music_trigger_b40 180)
		(begin (music_event sound/music/b40/mus_18_up_the_ridge_encounter_end) (print "mus_18_up_the_ridge_encounter_end")))

	(sleep_until (> s_music_trigger_b40 180) 1)
	(if (= s_music_trigger_b40 190)
		(begin (music_event sound/music/b40/mus_19_up_the_ridge_encounter_end_safety) (print "mus_19_up_the_ridge_encounter_end_safety")))

	(sleep_until (> s_music_trigger_b40 190) 1)
	(if (= s_music_trigger_b40 200)
		(begin (music_event sound/music/b40/mus_20_arena_c_encounter_start) (print "mus_20_arena_c_encounter_start")))

	(sleep_until (> s_music_trigger_b40 200) 1)
	(if (= s_music_trigger_b40 210)
		(begin (music_event sound/music/b40/mus_21_arena_c_ecnounter_end) (print "mus_21_arena_c_ecnounter_end")))

	(sleep_until (> s_music_trigger_b40 210) 1)
	(if (= s_music_trigger_b40 220)
		(begin (music_event sound/music/b40/mus_22_arena_d_encounter_start) (print "mus_22_arena_d_encounter_start")))

	(sleep_until (> s_music_trigger_b40 220) 1)
	(if (= s_music_trigger_b40 230)
		(begin (music_event sound/music/b40/mus_23_arena_d_intense_encounter_start) (print "mus_23_arena_d_intense_encounter_start")))

	(sleep_until (> s_music_trigger_b40 230) 1)
	(if (= s_music_trigger_b40 240)
		(begin (music_event sound/music/b40/mus_24_arena_d_intense_encounter_end) (print "mus_24_arena_d_intense_encounter_end")))

	(sleep_until (> s_music_trigger_b40 240) 1)
	(if (= s_music_trigger_b40 250)
		(begin (music_event sound/music/b40/mus_25_bridge_f_encounter_start)(print "mus_25_bridge_f_encounter_start")))

	(sleep_until (> s_music_trigger_b40 250) 1)
	(if (= s_music_trigger_b40 260)
		(begin (music_event sound/music/b40/mus_26_bridge_f_encounter_end)(print "mus_26_bridge_f_encounter_end")))

	(sleep_until (> s_music_trigger_b40 260) 1)
	(if (= s_music_trigger_b40 270)
		(begin (music_event sound/music/b40/mus_27_arena_f_encounter_start)(print "mus_27_arena_f_encounter_start")))

	(sleep_until (> s_music_trigger_b40 270) 1)
	(if (= s_music_trigger_b40 280)
		(begin (music_event sound/music/b40/mus_28_arena_f_encounter_end)(print "mus_28_arena_f_encounter_end")))

	(sleep_until (> s_music_trigger_b40 280) 1)
	(if (= s_music_trigger_b40 290)
		(begin (music_event sound/music/b40/mus_29_arena_f_encounter_end_safety)(print "mus_29_arena_f_encounter_end_safety")))

	(sleep_until (> s_music_trigger_b40 290) 1)
	(if (= s_music_trigger_b40 300)
		(begin (music_event sound/music/b40/mus_30_pyramid_instructions_encounter_start)(print "mus_30_pyramid_instructions_encounter_start")))

	(sleep_until (> s_music_trigger_b40 300) 1)
	(if (= s_music_trigger_b40 310)
		(begin (music_event sound/music/b40/mus_31_pyramid_instructions_encounter_end_safety)(print "mus_31_pyramid_instructions_encounter_end_safety")))
)

; woken in enc script encounter_bridge_a
(script dormant music_trigger_3
	(sleep_until
		(or
			(volume_test_players tv_music_trigger_03)
			(= 0 (+ (ai_living_count sq_bridge_a_elite_general) (ai_living_count sq_gr_bridge_a)))
		)
	1)
	(set s_music_trigger_b40 30)
)

(script dormant music_trigger_4
	(sleep_until (volume_test_players tv_music_trigger_04) 1)
	(set s_music_trigger_b40 40)
)

(script dormant music_trigger_5
	(sleep_until (volume_test_players tv_music_trigger_05) 1)
	(set s_music_trigger_b40 50)
)

; woken in enc script encounter_arena_b
(script dormant music_trigger_6_7
	(sleep_until
		(or
			(= 0 (ai_living_count sq_gr_a2_top_cov)) ; player clears encounter in arena b
			(volume_test_players tv_music_trigger_06) ; safety check
		)
	1)

	(if (= 0 (ai_living_count sq_gr_a2_top_cov))
		(set s_music_trigger_b40 60)
		; else
		(set s_music_trigger_b40 70)
	)
)

(script dormant music_trigger_10
	(sleep_until (volume_test_players tv_music_trigger_10) 1)
	(set s_music_trigger_b40 100)
)

(script dormant music_trigger_12
	(sleep_until (volume_test_players tv_music_trigger_12) 1)
	(set s_music_trigger_b40 120)
)

(script dormant music_trigger_14
	(sleep_until (volume_test_players tv_music_trigger_14) 1)
	(set s_music_trigger_b40 140)
)

; woken in enc script enc_crevasse
(script dormant music_trigger_15
	(sleep_until
		(or
			(volume_test_players tv_music_trigger_15)
			(= 0 (+ (ai_living_count gr_chasm_cov_a) (ai_living_count gr_chasm_cov_b)))
		)
	1)
	(set s_music_trigger_b40 150)
)

(script dormant music_trigger_15a
	(sleep_until (volume_test_players tv_music_trigger_15a) 1)
	(set s_music_trigger_b40 151)
)

(script dormant music_trigger_15b
	(sleep_until (volume_test_players tv_music_trigger_15b) 1)
	(set s_music_trigger_b40 152)
)

(script dormant music_trigger_16
	(sleep_until (volume_test_players tv_music_trigger_16) 1)
	(set s_music_trigger_b40 160)
)

(script dormant music_trigger_18
	(sleep_until (volume_test_players tv_music_trigger_18) 1)
	(set s_music_trigger_b40 180)
)

(script dormant music_trigger_20
	(sleep_until (volume_test_players tv_music_trigger_20) 1)
	(set s_music_trigger_b40 200)
)

(script dormant music_trigger_21
	(sleep_until (volume_test_players tv_music_trigger_21) 1)
	(set s_music_trigger_b40 210)
)

; woken in enc script encounter_arena_d
(script dormant music_trigger_22
	(sleep_until
		(or
			(= (ai_combat_status gr_arena_d_room) clear_los)
			(volume_test_players tv_music_trigger_22)
		)
	1)
	(set s_music_trigger_b40 220)
)

; woken in enc script encounter_arena_d
(script dormant music_trigger_23
	(sleep_until (volume_test_players tv_music_trigger_23) 1)
	(set s_music_trigger_b40 230)
)

(script dormant music_trigger_24
	(sleep_until (volume_test_players tv_music_trigger_24) 1)
	(set s_music_trigger_b40 240)
)

(script dormant music_trigger_25
	(sleep_until (volume_test_players tv_music_trigger_25) 1)
	(set s_music_trigger_b40 250)
)

(script dormant music_trigger_26
	(sleep_until (volume_test_players tv_music_trigger_26) 1)
	(set s_music_trigger_b40 260)
)

(script dormant music_trigger_27
	(sleep_until (volume_test_players tv_music_trigger_27) 1)
	(set s_music_trigger_b40 270)
)

; woken in enc script enc_b5_a_cov
(script dormant music_trigger_28
	(sleep_until (= (ai_living_count sq_arena_f_hunters) 0) 1)
	(set s_music_trigger_b40 280)
)

(script dormant music_trigger_31
	(sleep_until (volume_test_players tv_music_trigger_31) 1)
	(set s_music_trigger_b40 310)
)



;====================================================================================================================================================================================================
; marine variables ==============================================================================================================================================
;====================================================================================================================================================================================================

(global ai ai_gr_marines_all 			gr_marines_all)				; squad group containing all marines

; marine subgroups
	; note that marines may move from individual groups to followers at any point, including between dialogue calls
	; it's best to just use ai_gr_marines_all to get all living marines if you can.
(global ai ai_gr_marines_snowfield_a 	ext_a_area_a_marines_ini)		; squad group containing just marines from snowfield a that have not yet joined the fireteam-followers
(global ai ai_gr_marines_snowfield_b 	ext_a_area_b_marines)			; squad group containing just marines from snowfield b that have not yet joined the fireteam-followers
(global ai ai_gr_marines_postchasm		ext_b_postchasm_marines)		; squad group containing just marines from the postchasm (charlie) rally point that have not yet joined the fireteam-followers.  does not spawn unless the player uses the postchasm insertion point.
(global ai ai_gr_marines_spiral_bunker	ext_b_marines)					; squad group containing just marines from the spiral that have not yet joined the fireteam-followers
(global ai ai_player_followers 			sq_player_followers)			; squad (not group) containing just the marines in the player's fireteam following player0.

;====================================================================================================================================================================================================
; marine helpers ==============================================================================================================================================
;====================================================================================================================================================================================================

; captures both marines in snowfield b and those that have joined the fireteam in snowfield a
(script static boolean f_snowfield_a_has_living_marines
	(or
		(> (ai_living_count ai_gr_marines_snowfield_a) 0)
		(> (ai_living_count ai_player_followers) 0)
	)
)

; captures both marines in snowfield b, those that have joined the fireteam in snowfield b, or those that joined the fireteam from snowfield a
(script static boolean f_snowfield_b_has_living_marines
	(or
		(> (ai_living_count ai_gr_marines_snowfield_b) 0)
		(> (ai_living_count ai_player_followers) 0)
	)
)

; captures both marines in the spiral/bunker, those that have joined the fireteam in the spiral/bunker, or those that joined the fireteam from snowfield a and b
(script static boolean f_spiral_bunker_has_marines_for_vo
	(or
		(> (ai_living_count ai_gr_marines_spiral_bunker) 0)
		(> (ai_living_count ai_player_followers) 0)
	)
)