; startup script =====================================================================================================================================================================================

; wake triggers on start
(script startup a30_start
	(ai_allegiance player human)
	(a30_insertion_point_fixups)
	(f_start_auto_save_loop)

	(f_objectives_a30)
	;(wake flare_rubble_hide)
	(wake music_a30)

	(if (f_insertion_point_area_pending ins_lz)
		(begin
			(f_play_cinematic cinematics\a30\a30_intro.cinematic)
			(fade_out 0 0 0 0) ;cut to black
			; landing zone
			(submit_incident "ins_a30_lz")
			(submit_incident "unlock_a30")
			(submit_incident_with_custom_string_id "game_activity_begin" "a30")
			(wake start_mission)

			;creat object folders
			(object_create_folder of_lz_weapons_ammo)
			(object_create_folder of_lz_bipeds)
			(object_create_folder of_first_bipeds)
		)
	)

 	(if (not (game_is_cooperative))
		(wake player_followers_from_mission_first)
	)


	; first arrival waves
	(sleep_until (or (volume_test_players first_arrival) (f_insertion_point_script_is_blocked ins_lz)) 1)
	(if (f_insertion_point_area_pending ins_mission_first) (wake mission_first))

	; warthog cave - bridge activation
	(sleep_until (or (volume_test_players cave_floor_entrance)
		(f_insertion_point_script_is_blocked ins_cave)) 1)

	(if (f_insertion_point_area_pending ins_cave)
		(begin
			(submit_incident_with_custom_string_id "game_activity_begin" "a30")
			(submit_incident "ins_a30_cave")
			(submit_incident "unlock_a30")
			(wake mission_cave)
		)
	)

	; holdouts
	(sleep_until
		(or
			(= global_cave_bridge_enabled 1)
			(volume_test_players cave_exit_fat) ;if player jetpacks or does something really to get passed the bridge without activating it let them play the rest of the level
		)
		1
	)
	(sleep_until
		(or
			(volume_test_players cave_exit_fat)
			(f_insertion_point_script_is_blocked ins_holdouts)
			(f_insertion_point_script_is_blocked ins_cliff)
			(f_insertion_point_script_is_blocked ins_river)
			(f_insertion_point_script_is_blocked ins_rubble)
		)
	1)

	(if (or (f_insertion_point_area_pending ins_holdouts)
			(f_insertion_point_area_pending ins_cliff)
			(f_insertion_point_area_pending ins_river)
			(f_insertion_point_area_pending ins_rubble)
		)
		(begin
			(if (f_insertion_point_area_pending ins_holdouts)
				(begin
					(submit_incident_with_custom_string_id "game_activity_begin" "a30")
					(submit_incident "ins_a30_holdouts")
					(submit_incident "unlock_a30")
					(wake mission_holdout_intro)
				)
			)
			(wake mission_cliff)
			(wake mission_rubble)
			(wake mission_river)
			(wake mission_obj)
			(wake holdout_teleporting_loop)
			(wake holdout_object_clean_up_loop)
			(wake dialogue_marine_signal)
;			(wake flare_rubble_trigger)
			(wake music_a30_triggers_holdouts)
		)
	)
)

;*
(script dormant flare_rubble_hide
	(object_hide bc_quarry_flare true)
)

(script dormant flare_rubble_trigger
	(object_hide bc_quarry_flare false)
	(sleep_until (or (volume_test_players rubble_1) (volume_test_players rubble_2)) 1)
	(object_destroy bc_quarry_flare)
)
*;
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; a30 missionlevel scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant start_mission
	(wake player_intro)
	(wake dialogue_intro)
	(sleep_until (not (volume_test_players_all lz_lifeboat)) 1)
	(wake save_mission_start)
	(wake mission_lz)
	(wake place_first_ship)
	(sleep (game_ticks_from_seconds 2))
	(set mark_evade true) ; show objective about evading
	(wake beat1_nav_loop)
	(wake nav_backtracking_loop)
	(wake vign_tower_beam_1_control)
)

(script dormant player_intro
	(fade_out 0 0 0 0)

	(player_disable_movement true)
	;disable floor is lava skull
	(skull_affects_players skull_floor_is_lava false)

	; hold black, then fade into chapter title
	(sleep (game_ticks_from_seconds 4))
	(fade_in 0 0 0 (game_ticks_from_seconds 1))
	(wake chapter_a30_1)

	(sleep_until b_player_awake 1)
	(player_disable_movement false)
	;enable floor is lava skull
	(skull_affects_players skull_floor_is_lava true)
)

(script dormant vign_tower_beam_1_control
	;turn on beam tower when player exits lifepod
	(print "vign tower beam 1 activated")
	(device_set_position_immediate dm_towerbeam_1 0.5)

	;turn off beam tower so we can trigger it when the player turns the corner
	(sleep_until (volume_test_players tv_towerbeam1_off) 1)
	(print "vign tower beam 1 deactivated")
	(device_set_position_immediate dm_towerbeam_1 0)

	;turn on beam tower when player first can see it
	(sleep_until
		(or
			;player is in best viewing spot and looks at the tower
			(and
				(objects_can_see_flag (players) fl_beamtower1 45)
				(volume_test_players tv_towerbeam1_look)
			)
			;incase player fails to look at the tower but gets past the best viewing spot
			(volume_test_players tv_towerbeam1_backup)
		)
		1
	)
	(print "vign tower beam 1 activated")
	(device_set_position_immediate dm_towerbeam_1 0.5)

	(sleep_until global_lifepods_flew 1)

	(print "vign tower beam 1 dectivated")
	(device_set_position_immediate dm_towerbeam_1 0)
)

(script dormant mission_lz
	;sleep until the players cross the forerunner pilon bridge or they find another way to the hill top.
	(sleep_until (or (volume_test_players lz_bridge)(volume_test_players lz_higher_ground)) 1)
	(wake mission_lz_banshee) ; script to spawn banshee

	(wake mission_lz_place_enemies)

	(sleep_until (or (volume_test_players lz_ledge_safe)(volume_test_players lz_higher_ground)) 1)
	;(if (< s_navpoint_index 2) (set s_navpoint_index 2))
	(set mark_higher true)
)

(script dormant place_first_ship
	(sleep_until (or lz_time_out (volume_test_players lz_bridge) (volume_test_players plant_trigger)) 1)
	(print "dropship trigger")
	(ai_place sq_lz_cship)
	(set lz_cship_global (ai_vehicle_get_from_spawn_point sq_lz_cship/pilot_spawn))
	(f_load_fork lz_cship_global "dual" sq_gr_lz_search_covenant none none none)
	(wake dialogue_lz_warning)

	(sleep_until (volume_test_object lz_landing sq_gr_lz_search_covenant) 1) ; waits until squad is placed
	(sleep_until (< (ai_nonswarm_count sq_gr_lz_search_covenant) 1) 1)
	
	(if (< s_music_trigger 30) (set s_music_trigger 30))
	(if (< conversation_id 3) (wake dialogue_lz_dawdle)) ; only wake dawdle if player has not arrived at first beam tower
	(if (< conversation_id 6) (wake dialogue_approach_waterfall)) ; only wake waterfall if player has not past point of no return (cave)
)

(script dormant first_ship_timer
	(sleep (game_ticks_from_seconds 30))
	(set lz_time_out true)
)

(script dormant mission_lz_place_enemies
	(sleep_until (or mark_lz_banshee
				     (volume_test_players lz_ledge)
					 (volume_test_players lz_higher_ground)) 1)

	(ai_place pass_grunt)
	(ai_place pass_elite)
)

(script command_script cs_lz_dropship_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport lz_cship_point_set/p0 lz_cship_point_set/p1)

	(cs_fly_by lz_cship_point_set/p1)
	(cs_fly_by lz_cship_point_set/p2)
	(cs_fly_by lz_cship_point_set/p3)
	(cs_fly_by lz_cship_point_set/p4)
	(cs_vehicle_speed 0.5)
	(cs_fly_by lz_cship_point_set/p5)
	(cs_fly_by lz_cship_point_set/p6)
	(unit_open lz_cship_global)
	(f_unload_fork_all lz_cship_global)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close lz_cship_global)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_by lz_cship_point_set/p7)
	(cs_fly_by lz_cship_point_set/p8)
	(wake lz_search_follow_player)
	(cs_fly_by lz_cship_point_set/p9)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant lz_search_follow_player
	(sleep_until (volume_test_players lz_ledge_safe) 1)

	(if (volume_test_players lz_ledge_safe) (set global_search_follow_player true))

	(sleep_until (= (ai_nonswarm_count sq_gr_lz_search_covenant) 0) 1)
	(set mark_lz_dropship true)
)

(script dormant mission_lz_banshee
	(sleep_until (or mark_lz_dropship
				     (volume_test_players lz_ledge_safe)) 1)

	(wake dialogue_banshee_spawn1)
	(ai_place lz_banshee_pilot_1)
	(ai_place lz_banshee_pilot_2)
	(wake flee_banshee1)
	(wake flee_banshee2)

	(cs_run_command_script lz_banshee_pilot_1 entry_banshee1)
	(sleep (game_ticks_from_seconds 2))
	(cs_run_command_script lz_banshee_pilot_2 entry_banshee2)

	(sleep_until (or (< (ai_strength sq_gr_lz_search_banshee) .6)
				     (volume_test_players pass_mouth)) 1 delay_fail)
	(sleep (game_ticks_from_seconds 3.0))
	(set mark_lz_banshee true)
)

(script command_script entry_banshee1
	(cs_teleport lz_banshee1_point_set/p0 lz_banshee1_point_set/p1)
	(cs_fly_by lz_banshee1_point_set/p1)
	(cs_fly_by lz_banshee1_point_set/p2)
	;banshee should be in the general area so if the player shoots at them let them go into comabt
	(cs_abort_on_damage true)
	(cs_fly_by lz_banshee1_point_set/p3)
	(cs_fly_by lz_banshee1_point_set/p4)
	(cs_fly_by lz_banshee1_point_set/p5)
)

(script command_script entry_banshee2
	(cs_teleport lz_banshee2_point_set/p0 lz_banshee2_point_set/p1)
	(cs_fly_by lz_banshee2_point_set/p1)
	(cs_fly_by lz_banshee2_point_set/p2)
	;banshee should be in the general area so if the player shoots at them let them go into comabt
	(cs_abort_on_damage true)
	(cs_fly_by lz_banshee2_point_set/p3)
	(cs_fly_by lz_banshee2_point_set/p4)
	(cs_fly_by lz_banshee2_point_set/p5)
)

(script dormant flee_banshee1
	(sleep_until (<= (ai_living_count lz_banshee_pilot_2) 0) 1)
	(if (> (ai_living_count lz_banshee_pilot_1) 0)
		(begin
			(print "banshee 1 fleeing")
			(cs_run_command_script lz_banshee_pilot_1 cs_flee_banshee)
		)
	)
)

(script dormant flee_banshee2
	(sleep_until (<= (ai_living_count lz_banshee_pilot_1) 0) 1)
	(if (> (ai_living_count lz_banshee_pilot_2) 0)
		(begin
			(print "banshee 2 fleeing")
			(cs_run_command_script lz_banshee_pilot_2 cs_flee_banshee)
		)
	)
)

(script command_script cs_flee_banshee
	(cs_vehicle_speed lz_banshee_pilot_1 1.0)
	(cs_fly_to banshee_first_point_set/p0)
	(cs_fly_to banshee_first_point_set/p1)
	(cs_fly_to banshee_first_point_set/p2)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant lifepods_fly
	(print "lifepods starting to fly overhead")
	; create the lifepods

	; set position => start moving
	(wake lifepod_1_control)

	(sleep (game_ticks_from_seconds 1.3))

	;start second lifepod
	(wake lifepod_2_control)

	(sleep (game_ticks_from_seconds 6))

	;start third lifepod
	(wake lifepod_3_control)

	(sleep_until (> (device_get_position lifepod_1_device3) .9) 1)
	(print "lifepods done")
	(set global_lifepods_flew true)
)

(script dormant lifepod_1_control
	;create and go
	(object_create lifepod_1_device)
	(device_set_power lifepod_1_device 1)
	(print "lifepod_1_device moving")
	(device_set_position lifepod_1_device 1)

	(sleep_until (> (device_get_position lifepod_1_device) 0.2) 1)
	(f_blip_object lifepod_1_device blip_objective)
	(print "lifepod_1_device blipped")

	(sleep_until (> (device_get_position lifepod_1_device) 0.8) 1)
	(f_unblip_object lifepod_1_device)
	(print "lifepod_1_device unblipped")

	(sleep_until (> (device_get_position lifepod_1_device) .95) 1)
	(object_destroy lifepod_1_device)
	(print "lifepod_1_device destroyed")
)

(script dormant lifepod_2_control
	;create and go
	(object_create lifepod_1_device2)
	(device_set_power lifepod_1_device2 1)
	(print "lifepod_1_device2 moving")
	(device_set_position lifepod_1_device2 1)

	(sleep_until (> (device_get_position lifepod_1_device2) 0.2) 1)
	(f_blip_object lifepod_1_device2 blip_objective)
	(print "lifepod_1_device2 blipped")

	(sleep_until (> (device_get_position lifepod_1_device2) 0.8) 1)
	(f_unblip_object lifepod_1_device2)
	(print "lifepod_1_device2 unblipped")

	(sleep_until (> (device_get_position lifepod_1_device2) .95) 1)
	(object_destroy lifepod_1_device2)
	(print "lifepod_1_device2 destroyed")
)

(script dormant lifepod_3_control
	;create and go
	(object_create lifepod_1_device3)
	(device_set_power lifepod_1_device3 1)
	(print "lifepod_1_device3 moving")
	(device_set_position lifepod_1_device3 1)

	(sleep_until (> (device_get_position lifepod_1_device3) 0.2) 1)
	(f_blip_object lifepod_1_device3 blip_objective)
	(print "lifepod_1_device3 blipped")

	(sleep_until (> (device_get_position lifepod_1_device3) 0.8) 1)
	(f_unblip_object lifepod_1_device3)
	(print "lifepod_1_device3 unblipped")

	(sleep_until (> (device_get_position lifepod_1_device3) .95) 1)
	(object_destroy lifepod_1_device3)
	(print "lifepod_1_device3 destroyed")
)

;the player must defend the marines near the first beam tower against waves of covenant.
(script dormant mission_first
	;wait until all players get close enough to trigger the encounter.
	(sleep_until (volume_test_players first_arrival) 1)
	(print "mission_first script started.")

	;wrap up the banshees from the previous encounter.
	(sleep_forever flee_banshee1)
	(sleep_forever flee_banshee2)

	;cortana calls out the beacon around the corner and johnson asks for help.
	(wake dialogue_first_arrival)

	;begin looking for a save.
	(wake save_first_arrival)

	(wake mission_first_clean_up)

	;place our marine survivors
	(ai_place sq_gr_first_marine);unnamed marines
	(ai_place sq_gr_first_marine_greetplayer);named marines

	;put nameplate on johnson
	(print "giving johnson his nameplate.")
	(wake nav_nameplate_johnson)

	;perserve our named npc's
	(ai_cannot_die first_marine_johnson true)
	(ai_cannot_die first_marine_bisenti true)
	(ai_cannot_die first_marine_fitzgerald true)
	(ai_cannot_die first_marine_mendoza true)

	;the first spirit approaches in the mountain pass
	(mission_first_wave_1)

	;sleep until the first spirt has unloaded all of its units.
	(sleep_until global_first_wave_1 1)
	;wait until all of the first wave has been killed or the delay_fail timer expires.
	(sleep_until (= 0 (ai_nonswarm_count sq_gr_holdout0_wave1)) 1 delay_fail)
	(ai_disposable sq_gr_holdout0_wave1 true)

	;look for a checkpoint.
	(wake save_first_wave_1)

	;the squad dedicated to walking to the player and greeting him will now do that.
	(set global_ai_greetplayer true)

	;wait 5 seconds so the marines have time to walk over to you
	(sleep (game_ticks_from_seconds 5))

	;if johnson is still alive, which he should be because he was set to invincible, play his dialogue and then wait to finish.
	(if (>= (ai_living_count first_marine_johnson) 1)
		(begin
			(wake dialogue_first_wave_1_defeated_johnson)
			(sleep_until (script_finished "dialogue_first_wave_1_defeated_johnson") 1)
		)
	)

	;let them die now
	(ai_cannot_die first_marine_johnson false)
	(ai_cannot_die first_marine_bisenti false)
	(ai_cannot_die first_marine_fitzgerald false)
	(ai_cannot_die first_marine_mendoza false)

	;pause until the next covenant waves.
	;(sleep (game_ticks_from_seconds 13))

	;_____begin wave 2_____

	;begin marine behaviors for the waves.
	(wake mission_first_marine)
	;cortana and marines call out an incoming spirits
	(wake dialogue_first_wave_2)
	(set mark_covstart true)

	;call in the 2nd wave spirit
	(mission_first_wave_2)

	;begin checking for player abandoning the marines.
	(wake obj_first_abandon)
	(wake dialogue_holdout1_failing)

	;update the players objectives to defend the marines, and checkpoint
	(wake save_first_welcome)

	;wait until the 2nd wave has landed
	(sleep_until global_first_wave_2 1)

	;wait until the wave is reduced to a threshold
	(sleep_until (< (ai_living_count sq_gr_holdout0_wave2) 3) 1)

	;marines are aware of the incoming spirit.
	(set b_first_wave_3_calledout true)

	;_____begin wave 3_____

	;call in the 3rd wave spirit.
	(mission_first_wave_3)
	(set s_music_trigger 60)
	(set mark_covmid true)

	;check to see how many wave 2 are left and wait to checkpoint when safe or time has passed
	(if (< (ai_living_count sq_gr_holdout0_wave2) 2) (sleep_until (game_all_quiet) 1 delay_dawdle))
	(wake save_first_wave_2)

	;wait until the 3rd wave has landed
	(sleep_until global_first_wave_3 1)

	;wait until the 3rd wave is wiped out
	(sleep_until (= (ai_nonswarm_count sq_gr_holdout0_wave3) 0) 1)

	;_____begin wave 4_____

	;marines call out the incoming spirit
	(wake dialogue_first_wave_4)

	;call in the 4th spirit
	(mission_first_wave_4)
	(set s_music_trigger 70)

	;check to see how many wave 3 are left and wait to checkpoint when safe or time has passed
	(if (< (ai_living_count sq_gr_holdout0_wave3) 2) (sleep_until (game_all_quiet) 1 delay_dawdle))
	(wake save_first_wave_3)

	;wait until the 4th wave has landed
	(sleep_until global_first_wave_4 1)

	;wait until the 4th wave is reduced below a threshold or the delay_fail timer expires then try to checkpoint.
	(sleep_until (< (ai_living_count sq_gr_holdout0_wave4) 3) 1)
	(wake save_first_wave_4)

	;_____begin wave 5_____

	;marines are aware of the 5th spirit.
	(set b_first_wave_5_calledout true)

	;call in the 5th spirit and trigger the music
	(mission_first_wave_5)
	(set s_music_trigger 80)
	(set mark_covend true)

	;wait until the 5th wave has landed.
	(sleep_until global_first_wave_5 1)

	;wait for a few seconds then begin the next wave.
	(sleep (game_ticks_from_seconds 15))

	(wake save_first_wave_5)

	;_____begin wave 6_____

	;marines are aware of the 6th spirit.
	(set b_first_wave_6_calledout true)

	;call in the 6th spirit and start music.
	(mission_first_wave_6)
	(set s_music_trigger 90)
	(wake dialogue_first_wave_6)

	;wait until all of the ai are dead and the wave landed or until the timer expired then checkpoint.
	(sleep_until (and global_first_wave_6 (>= 3 (ai_nonswarm_count sq_gr_holdout0_waves))) 1 delay_lost)
	(f_blip_ai sq_gr_holdout0_waves 1)

	(sleep_until (and global_first_wave_6 (= 0 (ai_nonswarm_count sq_gr_holdout0_waves))) 1 delay_lost)
	(wake save_first_wave_6)

	;wait until everything calms down then continue
	(sleep_until (game_all_quiet) 1 delay_dawdle)
	(set s_music_trigger 100)

	;_____pelican and warthog segment_____

	;end encounter and checkpoint
	(set global_first_end true)
	(wake save_first_waiting)

	(sleep (game_ticks_from_seconds 2))

	;spawn foehammer so she can fly in, update the objective, and begin foehammer dialog for pickup
	(ai_place sq_foehammer_first)
	(wake objective_cave)
	(wake lifepod_sequence)

	(print_if  debug "we've reached the end of mission_first")
)

(global boolean foehammer_setup_lifepods false)

(script dormant lifepod_sequence
	(sleep_until foehammer_setup_lifepods 1)
	(wake dialogue_escape_pods)
	(wake lifepods_fly)
	(wake dialogue_entered_warthog)
)

(script dormant mission_first_clean_up
	(sleep_until (volume_test_players cave_floor_entrance) 1)
	(print "set sq_gr_first disposable")
	(ai_disposable sq_gr_lz_search_banshee true)
	(ai_disposable sq_gr_lz_squads true)
	(ai_disposable sq_gr_first_starters true)
	(ai_disposable sq_foehammer_first true)
	(ai_disposable sq_gr_holdout0_waves true)
	(garbage_collect_now)

	;erase and destroy incase the dispoable
	(object_destroy (ai_vehicle_get_from_spawn_point sq_foehammer_first/pilot_spawn))

	(sleep (game_ticks_from_seconds 1))

	;incase disposable didn't get them, erase the squads
	(ai_erase sq_gr_lz_search_banshee)
	(ai_erase sq_gr_lz_squads)
	(ai_erase sq_gr_first_starters)
	(ai_erase sq_foehammer_first)
	(ai_erase sq_gr_holdout0_waves)

	;clean up bipeds
	(object_destroy_folder of_lz_bipeds)
	(object_destroy_folder of_first_bipeds)
)

(script dormant nav_nameplate_johnson
	(f_hud_hero_waypoint first_marine_johnson hero_johnson hero_default_max_dist)
)

;debug squad counts
(global short s_evac_marine_squad_count 0)
(global short s_evac_pelican_squad_count 0)

;have the marines from the encounter enter the pelican
(script static void (f_marines_enter_pelican (ai marine_squad) (ai pelican_squad))
	(print "marines_enter_pelican started")
	(sleep_until
		(begin
			(if (> (ai_living_count marine_squad) 0)
				(ai_vehicle_enter marine_squad foehammer_global "pelican_p")
			)
			;update debug squad count variables
			(set s_evac_marine_squad_count (ai_living_count marine_squad))
			(set s_evac_pelican_squad_count (ai_living_count pelican_squad))

			;exit condition
			(and
				(= (ai_living_count pelican_squad) (ai_in_vehicle_count pelican_squad))
				(= (ai_living_count marine_squad) (ai_in_vehicle_count marine_squad))
			)
		)
		1 ;runs every tick
		(game_ticks_from_seconds 30) ;time out after 30 seconds
	)

	;check if all the pelican squad and marine squads are in a vehicle, if not then try to load the marines that aren't in the pelican with the magic backup function.
	(if
		(!= (+ (ai_living_count marine_squad) (ai_living_count pelican_squad)) (+ (ai_in_vehicle_count marine_squad) (ai_in_vehicle_count pelican_squad)))
		;then
		(begin
			(print "vehicle load magic backup")
			;(ai_vehicle_enter_immediate marine_squad foehammer_global "pelican_p")
			(vehicle_load_magic foehammer_global "pelican_p" marine_squad)
		)
	)

	;clear debug squad count variables
	(set s_evac_marine_squad_count 0)
	(set s_evac_pelican_squad_count 0)

	(print "marines_enter_pelican ended")
)

(global boolean b_foehammer_first_hog_dropped false)

(script command_script cs_foehammer_first_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)
	(cs_enable_dialogue false)

	(set foehammer_global (ai_vehicle_get_from_spawn_point sq_foehammer_first/pilot_spawn))
	(wake jeep_enter_pelican)

	(sleep (game_ticks_from_seconds 2))

	; entry flight path, flies to each point in sequence
	(cs_teleport foehammer_first_point_set/p0 foehammer_first_point_set/p2)
	(cs_fly_by foehammer_first_point_set/p2)

	;fly around beam tower
	(cs_fly_by foehammer_first_point_set/p4)
	(cs_fly_by foehammer_first_point_set/p9)
	(set foehammer_setup_lifepods true)
	(cs_fly_by foehammer_first_point_set/p10)
	(cs_fly_by foehammer_first_point_set/p11)
	(cs_fly_by foehammer_first_point_set/p12)
	(cs_fly_by foehammer_first_point_set/p13)
	(cs_fly_by foehammer_first_point_set/p14)

	;fly to warthog drop
	(cs_fly_to_and_face foehammer_first_point_set/p5 foehammer_first_point_set/p7 2)

	(wake handle_first_jeep_navpoint)
	(set mark_warthog true)

	; drop the warthog
	(sleep (game_ticks_from_seconds 2))
	(sleep_until (= (volume_test_players jeep_drop) false) 1)
	(unit_exit_vehicle jeep_global)
	(set b_foehammer_first_hog_dropped true)

	(wake dialogue_first_evac_1)
	(sleep (game_ticks_from_seconds 1))

	;pick up marines
	(cs_vehicle_speed 0.4)
	(cs_fly_to_and_face foehammer_first_point_set/p8 foehammer_first_point_set/p5 0.01)

	(sleep (game_ticks_from_seconds 1))
	(print "marines enter pelican")
	;blocking function which wait for the marines to continue the script
	(f_marines_enter_pelican sq_gr_first_starters sq_foehammer_first)

	(sleep (game_ticks_from_seconds 1))
	(print "pelican leaving")

	;fly away
	(cs_vehicle_speed 1.0)
	(cs_fly_by foehammer_first_point_set/p3)
	(cs_fly_by foehammer_first_point_set/p1)
	(cs_fly_by foehammer_first_point_set/p15)
	(cs_fly_by foehammer_first_point_set/p16)
	(cs_fly_by foehammer_first_point_set/p17)
	(cs_fly_by foehammer_first_point_set/p18)

	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant first_marines_find_warthog
	(sleep_until
		(begin
			; do
			(ai_vehicle_reserve_seat jeep_global "warthog_d" true)
			(ai_vehicle_enter sq_player_followers jeep_global)
			(if (vehicle_test_seat jeep_global "warthog_p")
				(set followers_in_warthog true)
			)

			; while
			(or
				(= followers_in_warthog true)
				(volume_test_players tv_first_to_cave)
				(< (unit_get_health jeep_global) 0)
			)
		)
	90)

	(set followers_in_warthog false)
)

(script dormant mission_cave
	; todo - coop stuff
	;(if (and (game_is_cooperative) (not (or (vehicle_test_seat_list jeep w-gunner (players)) (vehicle_test_seat_list jeep w-passenger (players))))) (volume_teleport_players_not_inside cave_floor_entrance cave_flag))

	(wake save_cave_floor_enter)
	(wake mission_cave_clean_up)

	(wake player_followers_cave_over_bridge_loop)

	;spawn in enemies expect the plank elites
	(ai_place sq_gr_bridge_thin_covenant)
	(ai_place sq_gr_cave_floor_fat)
	(wake obj_cave_prompt)

	;sleep until players get to the area by the button to turn on the light bridge
	;  or the control position is moved somehow
	(sleep_until (or (volume_test_players cave_gap)
				     (> (device_group_get bridge_control_position) 0)) 1)

	;now spawn the plank elite
	(ai_place sq_gr_plank_elite_covenant)
	(wake mission_cave_elite_ambush)

	;sleep until the position is changed, most likely by the player pressing the button
	(sleep_until (> (device_group_get bridge_control_position) 0) 1)
	(set s_music_trigger 140)

	(print_if debug "bridge enabled!!")
	(set global_cave_bridge_enabled true)
	;setting mark_searchfirst to true to trigger the holdouts objective
	(set mark_searchfirst true)
	;(if (game_all_quiet) (cutscene_bridge))
	(wake save_cave_bridge)

	(sleep_until (volume_test_players cave_floor_exit) 1)
	(set s_music_trigger 150)
	(wake dialogue_second_driving)
	(wake save_cave_floor_exit)
)

(script dormant mission_cave_clean_up
	(sleep_until (volume_test_players cave_exit_cleanup) 1)
	(ai_disposable sq_gr_cave_floor true)
	(garbage_collect_now)

	(sleep (game_ticks_from_seconds 1))

	(sleep_forever mission_first)

	;incase disposable didn't get them, erase the squads
	(ai_erase sq_gr_cave_floor)
	(ai_erase sq_gr_holdout0_waves)

	;clean up lz weapons and ammo
	(object_destroy_folder of_lz_weapons_ammo)
)

;breaking out the elite ambush on way to the switch to not hold up script execution
(script dormant mission_cave_elite_ambush
	;wait until the player either enters the volume or the elite squad is dead.
	(sleep_until (or (volume_test_players cave_music_trigger_13)( < (ai_living_count sq_gr_plank_elite_covenant) 1)) 1)

	;if the elite is alive trigger the music.
	(if ( > (ai_living_count sq_gr_plank_elite_covenant) 0)
		(set s_music_trigger 130)
	)
)

(script dormant mission_holdout_intro
	(set s_music_trigger 170)
	(wake chapter_a30_2)
	(if (not (volume_test_objects holdouts_arrival jeep_global))
		(begin
			(set b_warthog_delivery true)
			(ai_place sq_foehammer_holdouts)
			(set foehammer_global (ai_vehicle_get_from_spawn_point sq_foehammer_holdouts/pilot_spawn))
		)
	)
	(wake mark_holdouts)
	(wake dialogue_holdouts_spotted)
	(wake fields_nav_loop)

	;beam tower vfx control:
	(wake vign_tower_beam_2_control)
	(wake vign_tower_beam_3_control)
	(wake initialize_flare_positions)
)

(script dormant initialize_flare_positions
	(if (= global_rubble_end false)
		(begin
			(object_create dm_flare_1)
			(print "flare 1 activated (rubble holdout)")

			(object_create dm_flare_5)
			(print "flare 5 activated (rubble holdout)")
		)
	)

	(if (= global_river_end false)
		(begin
			(object_create dm_flare_2)
			(print "flare 2 activated (river holdout)")

			(object_create dm_flare_6)
			(print "flare 6 activated (river holdout)")
		)
	)

	(if (= global_cliff_end false)
		(begin
			(object_create dm_flare_3)
			(print "flare 3 activated (river holdout)")

			(object_create dm_flare_4)
			(print "flare 4 activated (river holdout)")
		)
	)
)


(script dormant vign_tower_beam_2_control
	(if (= global_cliff_end false)
		(begin
			(device_set_position_immediate dm_towerbeam_2 0.5)
			(print "vign tower beam 2 activated (cliff holdout)")
		)
	)

	(sleep_until global_cliff_end 1)

	(print "vign tower beam 2 dectivated (cliff holdout)")
	(device_set_position_immediate dm_towerbeam_2 0)
)

(script dormant vign_tower_beam_3_control
	(if (= global_cliff_end false)
		(begin
			(device_set_position_immediate dm_towerbeam_3 0.5)
			(print "vign tower beam 3 activated (river holdout)")
		)
	)

	(sleep_until global_river_end 1)

	(print "vign tower beam 3 dectivated (river holdout)")
	(device_set_position_immediate dm_towerbeam_3 0)
)

(global trigger_volume current_holdout_volume rubble_all)
(global short s_holdouts_biped_count 0)

;once the player begins a holdout we want to ensure that players can only be in 1 holdout at a time.
(script dormant holdout_object_clean_up_loop
	(object_create_folder of_elysian_weapons_ammo)

	(print "holdout object_cleanup loop active")

	(sleep_until
		(begin
			(f_set_current_holdout_volume)
			(f_place_current_holdout_objects)
			(sleep_until (not (volume_test_players current_holdout_volume)) 1)
			;first pass
			(f_set_holdout_squads_as_dispoable)
			(sleep 2)
			(garbage_collect_now)

			;second pass
			(f_set_holdout_squads_as_dispoable)
			(sleep 2)
			(garbage_collect_now)

		(f_on_last_holdout))
	1)
)

(script static void f_set_holdout_squads_as_dispoable
	(set s_holdouts_biped_count (list_count (volume_return_objects_by_type tv_holdouts_bipeds 1)))
	(print "biped count updated")

	(if (> s_holdouts_biped_count 45)
		;then
		(begin
			(if	;the rubble encounter has started
				global_rubble_start
				;then
				(f_set_rubble_squads_as_dispoble)
			)

			(if	;the river encounter has started
				global_river_start
				;then
				(f_set_river_squads_as_dispoble)
			)

			(if	;the cliff encounter has started
				global_cliff_start
				;then
				(f_set_cliff_squads_as_dispoble)
			)

			;mid encounters
			(f_set_mid_squads_as_dispoble)
		)
	)

)

;before each rubble wave attempt to reduce biped count if needed
(script static void f_set_non_rubble_holdout_squads_as_dispoable
	(set s_holdouts_biped_count (list_count (volume_return_objects_by_type tv_holdouts_bipeds 1)))
	(print "biped count updated")

	(if (> s_holdouts_biped_count 45)
		;then
		(begin
			(if	;the river encounter has started
				global_river_start
				;then
				(f_set_river_squads_as_dispoble)
			)
			(if	;the cliff encounter has started
				global_cliff_start
				;then
				(f_set_cliff_squads_as_dispoble)
			)
		)
		;mid encounters
		(f_set_mid_squads_as_dispoble)
	)
	(garbage_collect_now)
	(sleep (game_ticks_from_seconds 0.5))
)

;before each rubble wave attempt to reduce biped count if needed
(script static void f_set_non_river_holdout_squads_as_dispoable
	(set s_holdouts_biped_count (list_count (volume_return_objects_by_type tv_holdouts_bipeds 1)))
	(print "biped count updated")

	(if (> s_holdouts_biped_count 45)
		;then
		(begin
			(if	;the river encounter has started
				global_rubble_start
				;then
				(f_set_rubble_squads_as_dispoble)
			)
			(if	;the cliff encounter has started
				global_cliff_start
				;then
				(f_set_cliff_squads_as_dispoble)
			)
		)
		;mid encounters
		(f_set_mid_squads_as_dispoble)
	)
	(garbage_collect_now)
	(sleep (game_ticks_from_seconds 0.5))
)

;before cliff squads spawn attempt to reduce biped count if needed
(script static void f_set_non_cliff_holdout_squads_as_dispoable
	(set s_holdouts_biped_count (list_count (volume_return_objects_by_type tv_holdouts_bipeds 1)))
	(print "biped count updated")

	(if (> s_holdouts_biped_count 45)
		;then
		(begin
			(if	;the river encounter has started
				global_rubble_start
				;then
				(f_set_rubble_squads_as_dispoble)
			)
			(if	;the cliff encounter has started
				global_river_start
				;then
				(f_set_river_squads_as_dispoble)
			)
		)
		;mid encounters
		(f_set_mid_squads_as_dispoble)
	)
	(garbage_collect_now)
	(sleep (game_ticks_from_seconds 0.5))
)

(script static void f_set_rubble_squads_as_dispoble
	(print "setting a rubble squad as dispoable")
	(cond ;is the squad living and been dropped off													set squad as disposable
		((and (> (ai_living_count sq_holdout_rubble_cov_wave_5) 0) (= global_rubble_wave_5 true)) 	(ai_disposable sq_holdout_rubble_cov_wave_5 true))
		((and (> (ai_living_count sq_holdout_rubble_cov_wave_4) 0) (= global_rubble_wave_4 true)) 	(ai_disposable sq_holdout_rubble_cov_wave_4 true))
		((and (> (ai_living_count sq_holdout_rubble_cov_wave_3) 0) (= global_rubble_wave_3 true)) 	(ai_disposable sq_holdout_rubble_cov_wave_3 true))
		((and (> (ai_living_count sq_holdout_rubble_cov_wave_2) 0) (= global_rubble_wave_2 true)) 	(ai_disposable sq_holdout_rubble_cov_wave_2 true))
		((> (ai_living_count sq_holdout_rubble_cov_wave_1) 0) 										(ai_disposable sq_holdout_rubble_cov_wave_1 true))
	)
)

(script static void f_set_river_squads_as_dispoble
	(print "setting a river squad as dispoable")
	(cond ;is the squad living and been dropped off													set squad as disposable
		((> (ai_living_count river_wave_1_grunt) 0)													(ai_disposable river_wave_1_grunt true))
		((> (ai_living_count river_wave_1_grunt_a) 0)												(ai_disposable river_wave_1_grunt_a true))
		((> (ai_living_count wave_1_jackal) 0)														(ai_disposable wave_1_jackal true))
		((> (ai_living_count wave_1_jackal_2) 0)													(ai_disposable wave_1_jackal_2 true))
		((and (> (ai_living_count river_wave_2_grunt) 0) (= global_river_wave_2 true)) 				(ai_disposable river_wave_2_grunt true))
		((> (ai_living_count river_wave_1_elite) 0)													(ai_disposable river_wave_1_elite true))
		((> (ai_living_count river_wave_1_elite_2) 0)												(ai_disposable river_wave_1_elite_2 true))
	)
)

(script static void f_set_cliff_squads_as_dispoble
	(print "setting a cliff squad as dispoable")
	(cond ;is the squad living and been dropped off													set squad as disposable
		((> (ai_living_count sq_cliffside_fort_left_grunt) 0)										(ai_disposable sq_cliffside_fort_left_grunt true))
		((> (ai_living_count sq_cliffside_fort_right_grunts) 0)										(ai_disposable sq_cliffside_fort_right_grunts true))
		((> (ai_living_count sg_cliffside_inside) 0)												(ai_disposable sg_cliffside_inside true))
		((> (ai_living_count sq_cliffside_main_grunt_cliff) 0)										(ai_disposable sq_cliffside_main_grunt_cliff true))
		((> (ai_living_count sq_cliffside_main_grunt_hill) 0)										(ai_disposable sq_cliffside_main_grunt_hill true))
	)
)

(script static void f_set_mid_squads_as_dispoble
	(print "setting a mid squad as dispoable")
	(cond ;is the squad living and been dropped off													set squad as disposable
		((> (ai_living_count sq_gr_mid_cliff1) 0)													(ai_disposable sq_gr_mid_cliff1 true))
		((> (ai_living_count sq_gr_mid_cliff2) 0)													(ai_disposable sq_gr_mid_cliff2 true))
		((> (ai_living_count sq_gr_mid_river1) 0)													(ai_disposable sq_gr_mid_river1 true))
		((> (ai_living_count sq_gr_mid_rubble1) 0)													(ai_disposable sq_gr_mid_rubble1 true))
		((> (ai_living_count sq_gr_mid_rubble2) 0)													(ai_disposable sq_gr_mid_rubble2 true))
	)
)

;check which holdout the players are in and set that to current_holdout_volume
(script static void f_set_current_holdout_volume
	(print "sleeping until players enter a holdout volume")
	(sleep_until
		(or
			(volume_test_players_all rubble_all)
			(volume_test_players_all river_all)
			(volume_test_players_all cliff_all)
		)
		1
	)
	(print "setting holdout volume")
	(cond
		((volume_test_players_all rubble_all)		(set current_holdout_volume rubble_all))
		((volume_test_players_all river_all)		(set current_holdout_volume river_all))
		((volume_test_players_all cliff_all)		(set current_holdout_volume cliff_all))
	)
)

;create objects folders for current holdout and destroy the other two
(script static void f_place_current_holdout_objects
	(print "placing holdout objects")
	;cond										destroy other holdout objects								create current holdout objects
	(cond
		((= current_holdout_volume rubble_all) 	(begin 	(f_river_object_destroy) (f_cliff_object_destroy) 	(f_rubble_object_create)))
		((= current_holdout_volume river_all) 	(begin 	(f_rubble_object_destroy) (f_cliff_object_destroy) 	(f_river_object_create)))
		((= current_holdout_volume cliff_all) 	(begin 	(f_rubble_object_destroy) (f_river_object_destroy) 	(f_cliff_object_create)))
	)
)

;create and destroy functions for each holdout
(script static void f_rubble_object_create
	(object_create_folder of_rubble_weapons_ammo)
	(object_create_folder of_rubble_bipeds)
)

(script static void f_rubble_object_destroy
	(object_destroy_folder of_rubble_weapons_ammo)
	(object_destroy_folder of_rubble_bipeds)
)

(script static void f_river_object_create
	(object_create_folder of_river_weapons_ammo)
	(object_create_folder of_river_bipeds)
)

(script static void f_river_object_destroy
	(object_destroy_folder of_river_weapons_ammo)
	(object_destroy_folder of_river_bipeds)
)

(script static void f_cliff_object_create
	(object_create_folder of_cliff_weapons_ammo)
	(object_create_folder of_cliff_bipeds)
)

(script static void f_cliff_object_destroy
	(object_destroy_folder of_cliff_weapons_ammo)
	(object_destroy_folder of_cliff_bipeds)
)


(script command_script cs_foehammer_holdouts_lid
	;enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)
	(cs_enable_dialogue false)

	; spawn the warthog and attach it to the dropship
	(object_create jeep4)
	(set jeep_global jeep4)
	(unit_enter_vehicle jeep4 (ai_vehicle_get_from_squad ai_current_squad 0) "pelican_lc")

	; warthog_t is the 4th seat at the back bumper - reserve it for the player
	(ai_vehicle_reserve_seat jeep4 "warthog_t" true)

	;entry flight path, flies to each point in sequence
	(cs_teleport foehammer_holdouts_point_set/p0 foehammer_holdouts_point_set/p1)
	(cs_vehicle_speed 1.0)
	(cs_fly_by foehammer_holdouts_point_set/p1)
	(cs_fly_by foehammer_holdouts_point_set/p2)
	(cs_fly_to foehammer_holdouts_point_set/p3)

	;slow down near the drop off point
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face foehammer_holdouts_point_set/p4 foehammer_holdouts_point_set/p4 .2)

	; drop the warthog
	(sleep (game_ticks_from_seconds 1))
	(sleep_until (= (volume_test_players jeep_drop4) false) 1)
	(unit_exit_vehicle jeep4)
	(wake handle_holdouts_jeep_navpoint)
	(sleep (game_ticks_from_seconds 1))

	;exit fly path
	(cs_vehicle_speed 1)
	(cs_fly_by foehammer_holdouts_point_set/p3)
	(cs_fly_by foehammer_holdouts_point_set/p2)
	(cs_fly_by foehammer_holdouts_point_set/p1)
	(cs_fly_by foehammer_holdouts_point_set/p0)
	;p5 is used so the player can't see the foehammer despawn. p5 is placed far behind the cliff

	(cs_fly_by foehammer_holdouts_point_set/p5)
	(ai_disposable ai_current_squad true)
	;despawn

)

(script dormant mission_cliff
	;set the objective for the player
	(wake obj_cliff_arrival)

	;wait until the player enters the holdout checking every 15 ticks.
	(sleep_until (or (volume_test_players cliff_1)
				     (volume_test_players cliff_2)) 1
	)

	;encounter has started and give the player a checkpoint
	(set global_cliff_start true)
	(wake save_cliff_arrival)

	;prompt cortana dialog for the encounter.
	(wake dialogue_cliff_prompt)

	;if the player has already completed another holdout when entering this holdout, destroy mid_banshee
	(if (or global_river_end global_rubble_end) (set cont_banshee_kill true))

	;place the covenant except for the jackals
	(ai_place sg_cliffside_fort_left)
	(ai_place sg_cliffside_fort_right)
	(ai_place sg_cliffside_main)
	(ai_place sq_cliffside_inside_grunt_right)
	(ai_place sq_cliffside_inside_grunt_left)

	;wait for everyone to spawn then wait for the player to move farther into the encounter.
	(sleep (game_ticks_from_seconds 3))
	(sleep_until (volume_test_players cliff_all) 1)
	(print_if debug "player in the cliff")

	;begin check for players leaving encounter
	(wake obj_cliff_abandon)

	(wake update_holdout_progress_cliff)

	;spawn marines and begin their fight
	(wake mission_cliff_marine)

	;wait until the player has both gone to the bottom of the inside and the jackals have been cleared or the timer expired after the play arrived at the bottom.
	(sleep_until global_cliff_welcome 1)

	;checkpoint
	(wake save_cliff_welcome)

	;wait until the covenant in the area are reduced to 5 units then mark them.
	(sleep_until (<= (ai_nonswarm_count enc_holdout_cliffside_cov) 3) 1)
	(f_blip_ai enc_holdout_cliffside_cov 1)

	;wait until all of the covenant in the encounter are killed
	(sleep_until (< (ai_nonswarm_count enc_holdout_cliffside_cov) 1) 1)

	;end the cliff encounter.
	(print_if debug "cliff end")
	(set last_blip_flag fl_cliff_marines)
	(set global_cliff_end true)

	;destroying flares
	(object_destroy dm_flare_3)
	(object_destroy dm_flare_4)

	;(sleep_until marines_follow_underground)

	;sleep scrips checking for encounter failure or abondonment.
	(sleep_forever obj_cliff_abandon)
	(sleep_forever obj_cliff_all_killed)

	;if this was the last holdout to be cleared end the mission.
	(if (and global_river_end global_rubble_end)
		(begin
			(wake mission_extraction_cliff)
			(sleep_forever)
		)
	)

	;if marines survived or the player needs a warthog foehammer should fly in
	(if (or
			(not global_cliff_all_killed)
			(or
				(not (volume_test_object cliff_all jeep_global))
				(<= (unit_get_health jeep_global) 0)
			)
		)
		;then
		(begin
			;call in foehammer if this was not the end of the mission.
			(print "end of the beat - foehammer is coming")
			(ai_place sq_foehammer_cliff)
		)
		;else
		(print "foehammer did not come since player has a hog and all marines died")
	)

	(print_if  debug "we've reached the end of mission_cliff")
)

(script dormant update_holdout_progress_cliff
	(sleep_until global_cliff_end 1)
	(sleep_until (or (volume_test_players cliff_1) (volume_test_players cliff_2)) 1)
	(set s_holdout_progress (+ s_holdout_progress 1))
)

(script command_script cs_foehammer_cliff_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)
	(cs_enable_dialogue false)

	(set foehammer_global (ai_vehicle_get_from_spawn_point sq_foehammer_cliff/pilot_spawn))

	(if (or (not (volume_test_object cliff_all jeep_global)) (<= (unit_get_health jeep_global) 0))
		(begin
			; spawn the warthog and attach it to the dropship
			(object_create jeep2)
			(set jeep_global jeep2)
			(unit_enter_vehicle jeep2 (ai_vehicle_get_from_squad ai_current_squad 0) "pelican_lc")

			; warthog_t is the 4th seat at the back bumper - reserve it for the player
			(ai_vehicle_reserve_seat jeep2 "warthog_t" true)
		)
	)

	(f_kill_faraway_followers sq_player_followers sq_holdout_cliffside_marine cliff_all)

	;check if there is room for another follower then add marine to squad
	(if (and (> (ai_living_count sq_holdout_cliffside_marine) 0) (< (ai_living_count sq_player_followers) s_followers_count))
		(ai_migrate (object_get_ai (list_get (ai_actors sq_holdout_cliffside_marine) 0)) sq_player_followers)
	)
	(sleep 2)
	;check if there is room for another follower again then add marine to squad
	(if (and (> (ai_living_count sq_holdout_cliffside_marine) 0) (< (ai_living_count sq_player_followers) s_followers_count))
		(ai_migrate (object_get_ai (list_get (ai_actors sq_holdout_cliffside_marine) 0)) sq_player_followers)
	)

	;if any marines are left head to the pelican area
	(if (> (ai_living_count enc_holdout_cliffside_marine) 0) (cs_run_command_script enc_holdout_cliffside_marine cliff_marines_to_pelican))

	;have the marines try to get into the warthog if any where saved
	(if (not (= 0 (ai_living_count sq_player_followers))) (wake cliff_marines_find_warthog))

	; entry flight path, flies to each point in sequence
	(cs_teleport foehammer_cliff_point_set/p0 foehammer_cliff_point_set/p4)
	(cs_fly_by foehammer_cliff_point_set/p6)
	(cs_fly_by foehammer_cliff_point_set/p5 0.5)
	(cs_vehicle_speed 0.4)

	(if (unit_in_vehicle jeep2)
		(begin
			(cs_fly_to_and_face foehammer_cliff_point_set/p4 foehammer_cliff_point_set/p7 0.5)
			(sleep (game_ticks_from_seconds 1))
			(cs_fly_to_and_face foehammer_cliff_point_set/p9 foehammer_cliff_point_set/p7)
			(sleep (game_ticks_from_seconds 1))
			; drop the warthog
			(sleep_until (= (volume_test_players jeep_drop2) false) 1)
			(unit_exit_vehicle jeep2)
			(wake handle_cliff_jeep_navpoint)
			(sleep (game_ticks_from_seconds 1))
		)
	)

	;(wake navpoint_cliff_exit)
	(set global_cliff_exit true)
	(if (= 0 (ai_living_count enc_holdout_cliffside_marine))
		;then
		(begin
			(wake save_cliff_killed)
			(cs_vehicle_speed 1.0)
		)
		;else
		(begin
			(cs_vehicle_speed 0.4)
			(cs_fly_to_and_face foehammer_cliff_point_set/p2 foehammer_cliff_point_set/p3 0.2)
			(print "marines boarding pelican")
			;blocking function which wait for the marines to continue the script
			(f_marines_enter_pelican enc_holdout_cliffside_marine sq_foehammer_cliff)
			(cs_vehicle_speed 1.0)
			(wake save_cliff_rescued)
		)
	)

	(cs_fly_by foehammer_cliff_point_set/p5)
	(cs_fly_by foehammer_cliff_point_set/p6)
	(cs_fly_by foehammer_cliff_point_set/p0)

	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script command_script cliff_marines_to_pelican
	(cs_go_to foehammer_cliff_point_set/p1 1)
)

(script dormant cliff_marines_find_warthog
	(sleep_until
		(begin
			; do
			(ai_vehicle_reserve_seat jeep_global "warthog_d" true)
			(ai_vehicle_enter sq_player_followers jeep_global)
			(if (vehicle_test_seat jeep_global "warthog_p")
				(set followers_in_warthog true)
			)

			; while
			(or
				(= followers_in_warthog true)
				(volume_test_players cliff_1)
			)
		)
	(* 30 3))
	(set followers_in_warthog false)
)

(script dormant mission_rubble
	(sleep_until (or (volume_test_players rubble_1)
				     (volume_test_players rubble_2))
	1)

	(print "mission_rubble script started.")
	(wake save_rubble_arrival)
	(wake rubble_marine_contact) ;stops backtracking navpoints from remarking the marine position

	(set global_rubble_start true)
	(wake dialogue_rubble_arrival)

	(wake mission_rubble_marine)
	(wake obj_rubble_all_killed)

	;if the player has already completed another holdout when entering this holdout, destroy mid_banshee
	(if (or global_cliff_end global_river_end) (set cont_banshee_kill true))

	;check if there are too many bipeds and clean some up
	(f_set_non_rubble_holdout_squads_as_dispoable)

	(ai_place sq_holdout_rubble_cov_wave_1)
	(ai_place sq_holdout_rubble_cov_snipers)

	(sleep_until (volume_test_players rubble_arrival) 1)
	(wake obj_rubble_abandon)
	(wake update_holdout_progress_rubble)

	(wake mission_rubble_wave_1)

	(wake save_rubble_welcome)

	(sleep_until (<= (ai_living_count sq_holdout_rubble_cov_wave_1) 2) 1 (game_ticks_from_seconds 90))
	(if (<= (ai_living_count sq_holdout_rubble_cov_wave_1) 2)
		(wake save_rubble_wave_1)
	)

	(set global_rubble_welcome true)

	(f_sleep_until_player_in_rubble_holdout)
	(print "rubble wave 2")
	(mission_rubble_wave_2)
	(sleep_until global_rubble_wave_2 1)

	(sleep_until (<= (ai_living_count sq_holdout_rubble_cov_wave_2) 2) 1 (game_ticks_from_seconds 90))
	(if (<= (ai_living_count sq_holdout_rubble_cov_wave_2) 2)
		(wake save_rubble_wave_2)
	)

	(f_sleep_until_player_in_rubble_holdout)
	(print "rubble wave 3")
	(mission_rubble_wave_3)

	(sleep_until global_rubble_wave_3 1)

	(sleep_until (<= (ai_living_count sq_holdout_rubble_cov_wave_3) 2) 1 (game_ticks_from_seconds 90))
	(if (<= (ai_living_count sq_holdout_rubble_cov_wave_3) 2)
		(wake save_rubble_wave_3)
	)

	(f_sleep_until_player_in_rubble_holdout)
	(print "rubble wave 4")
	(mission_rubble_wave_4)

	(sleep_until global_rubble_wave_4 1)

	(sleep_until (<= (ai_living_count sq_holdout_rubble_cov_wave_4) 2) 1 (game_ticks_from_seconds 90))
	(if (<= (ai_living_count sq_holdout_rubble_cov_wave_4) 2)
		(wake save_rubble_wave_4)
	)

	(f_sleep_until_player_in_rubble_holdout)
	(print "rubble wave 5")
	(mission_rubble_wave_5)

	(sleep_until global_rubble_wave_5 1)

	;(sleep_until (< (ai_living_count sq_gr_rubble_wave) 4) 1)

	;if sq_gr_rubble_wave's ai_living_count is compared to 0, the script will sleep here forever and events such as the foehammer won't trigger.
	;at the end of wave 5 there are probably some straglers that both the player and the marines can't find during gameplay. no clue where they would be.
	;therefore it's instead comparing to 3 and then killing off whatever is left after some time with the failsafe_rubble_kill function.

	(sleep_until (<= (ai_nonswarm_count enc_holdout_rubble_cov) 3) 1)
	(f_blip_ai enc_holdout_rubble_cov 1)

	(sleep_until (= (ai_nonswarm_count enc_holdout_rubble_cov) 0) 1)

	(print "rubble end")
	(set global_rubble_end true)

	;destroying flares
	(object_destroy dm_flare_1)
	(object_destroy dm_flare_5)

	(wake failsafe_rubble_kill)

	(sleep delay_calm)

	(sleep_forever obj_rubble_abandon)
	(sleep_forever obj_rubble_all_killed)

	(if (and global_river_end global_cliff_end)
		(begin
			(wake mission_extraction_rubble)
			(sleep_forever)
		)
	)

	;if marines survived or the player needs a warthog foehammer should fly in
	(if (or
			(not global_rubble_all_killed)
			(or
				(not (volume_test_object rubble_all jeep_global))
				(<= (unit_get_health jeep_global) 0)
			)
		)
		;then
		(begin
			;call in foehammer if this was not the end of the mission.
			(print "end of the beat - foehammer is coming")
			(ai_place sq_foehammer_rubble)
		)
		;else
		(print "foehammer did not come since player has a hog and all marines died")
	)

	(print "end of the beat - foehammer is coming")
)

;if player leaves the encounter area sleep the mission script until they come back to avoid spawning more enemies in when player is away
(script static void f_sleep_until_player_in_rubble_holdout
	(if
		(not (volume_test_players rubble_all))
		;then
		(begin
			(print "sleeping until player is back in rubble holdout area")
			(sleep_until (volume_test_players rubble_all) 1)
			(print "player is back in rubble holdout area continuing mission script" )
		)
		;else
		(print "player is already in rubble holdout area, continuing mission script" )
	)
)

(script dormant update_holdout_progress_rubble
	(sleep_until global_rubble_end 1)
	(sleep_until (or (volume_test_players rubble_1) (volume_test_players rubble_2)) 1)
	(set s_holdout_progress (+ s_holdout_progress 1))
)

(script dormant rubble_marine_contact
	(sleep_until (volume_test_players rubble_jackal)1)
	(set global_rubble_contact true)
)

(script command_script cs_foehammer_rubble
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)
	(cs_enable_dialogue false)

	(set foehammer_global (ai_vehicle_get_from_spawn_point sq_foehammer_rubble/pilot_spawn))

	(if (or (not (volume_test_object rubble_all jeep_global)) (<= (unit_get_health jeep_global) 0))
		(begin
			; spawn the warthog and attach it to the dropship
			(object_create jeep3)
			(set jeep_global jeep3)
			(unit_enter_vehicle jeep3 (ai_vehicle_get_from_squad ai_current_squad 0) "pelican_lc")

			; warthog_t is the 4th seat at the back bumper - reserve it for the player
			(ai_vehicle_reserve_seat jeep3 "warthog_t" true)
		)
	)

	(f_kill_faraway_followers sq_player_followers enc_holdout_rubble_marine rubble_all)

	;check if there is room for another follower then add marine to squad
	(if (and (> (ai_living_count enc_holdout_rubble_marine) 0) (< (ai_living_count sq_player_followers) s_followers_count))
		(ai_migrate (object_get_ai (list_get (ai_actors enc_holdout_rubble_marine) 0)) sq_player_followers)
	)
	(sleep 2)
	;check if there is room for another follower again then add marine to squad
	(if (and (> (ai_living_count enc_holdout_rubble_marine) 0) (< (ai_living_count sq_player_followers) s_followers_count))
		(ai_migrate (object_get_ai (list_get (ai_actors enc_holdout_rubble_marine) 0)) sq_player_followers)
	)

	(if (not (= 0 (ai_living_count sq_player_followers))) (wake rubble_marines_find_warthog))

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)

	; entry flight path, flies to each point in sequence
	(cs_teleport pts_foehammer_rubble/p0 pts_foehammer_rubble/p3)
	(cs_fly_by pts_foehammer_rubble/p3)
	(cs_fly_by pts_foehammer_rubble/p9)

	(if (unit_in_vehicle jeep3)
		(begin
			(cs_fly_to_and_face pts_foehammer_rubble/p1 pts_foehammer_rubble/p8)
			(sleep (game_ticks_from_seconds 1))
			(cs_vehicle_speed 0.6)
			(cs_fly_to_and_face pts_foehammer_rubble/p7 pts_foehammer_rubble/p8 .5)
			; drop the warthog
			(sleep (game_ticks_from_seconds 1))
			(sleep_until (= (volume_test_players jeep_drop3) false) 1)
			(unit_exit_vehicle jeep3)
			(wake handle_rubble_jeep_navpoint)
			(sleep (game_ticks_from_seconds 1))
			(cs_vehicle_speed 0.6)
			(cs_fly_to_and_face pts_foehammer_rubble/p1 pts_foehammer_rubble/p2)
		)
	)

	;(wake navpoint_rubble_exit)
	(set global_rubble_exit true)
	(if (= 0 (ai_living_count enc_holdout_rubble_marine))
		;then
		(begin
			(cs_vehicle_speed 1.0)

			(cs_fly_by pts_foehammer_rubble/p3)
			(ai_erase ai_current_squad)
			(sleep_forever)
		)
		;else
		(begin
			(cs_fly_by pts_foehammer_rubble/p2)
			;(cs_fly_by pts_foehammer_rubble/p5)
			(cs_vehicle_speed 0.4)
			(cs_fly_to_and_face pts_foehammer_rubble/p4 pts_foehammer_rubble/p2 0.2)

			(set cliff_marines_curr_index 0)
			(set cliff_marines_total (list_count (ai_actors enc_holdout_rubble_marine)) )

			(print "marines boarding pelican")
			;blocking function which wait for the marines to continue the script
			(f_marines_enter_pelican enc_holdout_rubble_marine sq_foehammer_rubble)
			(cs_vehicle_speed 0.6)
			(cs_fly_to_and_face pts_foehammer_rubble/p10 pts_foehammer_rubble/p2)
			(cs_vehicle_speed 1.0)
			(wake save_rubble_rescued)

		)
	)

	(cs_fly_by pts_foehammer_rubble/p9)
	(cs_fly_by pts_foehammer_rubble/p3)
	(cs_fly_by pts_foehammer_rubble/p0)

	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant rubble_marines_find_warthog
	(sleep_until
		(begin
			; do
			(ai_vehicle_reserve_seat jeep_global "warthog_d" true)
			(ai_vehicle_enter sq_player_followers jeep_global)
			(if (vehicle_test_seat jeep_global "warthog_p")
				(set followers_in_warthog true)
			)

			; while
			(or
				(= followers_in_warthog true)
				(or
					(volume_test_players rubble_1)
					(volume_test_players rubble_2)
				)
				(< (unit_get_health jeep_global) 0)
			)
		)
	90)

	(set followers_in_warthog false)
)

(script dormant failsafe_rubble_kill
	(sleep 1200)

	(ai_kill enc_holdout_rubble_cov )
)

;holdout - hilltop
;player needs to rescue a squad of marines at the top of the hill while covenant search below.
(script dormant mission_river

	;wait until a player has entered into the encounter.
	(sleep_until (or (volume_test_players river_1)
				     (volume_test_players river_2))
	1)

	;begin the hilltop encounter
	(set global_river_start true)
	(wake river_marine_contact)

	;if the player has already completed another holdout when entering this holdout, destroy mid_banshee
	(if (or global_cliff_end global_rubble_end) (set cont_banshee_kill true))

	;checkpoint
	(wake save_river_arrival)

	;check if there are too many bipeds and clean some up
	(f_set_non_river_holdout_squads_as_dispoable)

	;begin marine behaviors and place covenant
	(wake mission_river_marine)
	(wake mission_river_wave_1)

	;start encounter dialog with cortana and update the player's objectives
	(wake dialogue_river_arrival)
	(wake obj_river_all_killed)

	;begin checking if player is abandoned the marines.
	(wake obj_river_abandon)
	(wake update_holdout_progress_river)

	;marines welcome the player.
	(wake save_river_welcome)

	;_____begin reinforcements_____

	;wait until the covenant wave is reduced by half.
	(sleep_until (< (ai_living_fraction sq_gr_river_wave) .5) 1)

	;wait until the covenant wave is less than 9 units or the delay_late timer has expired.
	(sleep_until (< (ai_living_count sq_gr_river_wave) 9) 1 delay_late)

	;if covenant are down to less than 6 wait for a safe moment to save or just save after the timer.
	(if (> (ai_living_count sq_gr_river_wave) 6) (sleep_until (game_all_quiet) 1))
	(wake save_river_wave_1)

	(f_sleep_until_player_in_river_holdout)
	;check if there are too many bipeds and clean some up
	(f_set_non_river_holdout_squads_as_dispoable)

	;bring in the next wave.
	(mission_river_wave_2)

	;wait until the 2nd wave has landed.
	(sleep_until global_river_wave_2 1)

	;wait until the covenant are reduced to less than 6
	(sleep_until (< (ai_living_count sq_gr_river_wave) 6) 1)

	;sleep until player is safe or delay_dawdle has passed and attempt to save.
	;(sleep_until (game_all_quiet) 1 delay_dawdle)
	(wake save_river_wave_2)

	;sleep until the covenant are at 3 or less alive or the delay_late timer has passed and blip the enemy.
	(sleep_until (<= (ai_nonswarm_count sq_gr_river_wave) 3) 1)
	(f_blip_ai sq_gr_river_wave 1)

	;_____wrapping up encounter_____

	;wait until all of the covenant are dead then mark encounter done.
	(sleep_until (= (ai_nonswarm_count sq_gr_river_wave) 0) 1)
	(set global_river_end true)

	;destroying flares
	(object_destroy dm_flare_2)
	(object_destroy dm_flare_6)

	;save if no enemies are around the player
	(sleep_until (game_all_quiet) 1)
	(wake save_river_wave_4)

	;pause and wind down
	(sleep delay_calm)

	;clean up failure end condition scripts
	(sleep_forever obj_river_abandon)
	(sleep_forever obj_river_all_killed)

	;end mission if this was the last holdout
	(if (and global_rubble_end global_cliff_end)
		(begin
			(wake mission_extraction_river)
			(sleep_forever)
		)
	)

	;if marines survived or the player needs a warthog foehammer should fly in
	(if (or
			(not global_river_all_killed)
			(or
				(not (volume_test_object river_all jeep_global))
				(<= (unit_get_health jeep_global) 0)
			)
		)
		;then
		(begin
			;place and call in foehammer
			(ai_place sq_foehammer_river)
			(set foehammer_global (ai_vehicle_get_from_spawn_point sq_foehammer_river/pilot_spawn))

			;give player a checkpoint for succeeding encounter
			(wake save_river_rescued)
		)
		;else
		(print "foehammer did not come since player has a hog and all marines died")
	)

	(print_if  debug "we've reached the end of mission_river")
)

;if player leaves the encounter area sleep the mission script until they come back to avoid spawning more enemies in when player is away
(script static void f_sleep_until_player_in_river_holdout
	(if
		(not (volume_test_players river_all))
		;then
		(begin
			(print "sleeping until player is back in river holdout area")
			(sleep_until (volume_test_players river_all) 1)
			(print "player is back in river holdout area continuing mission script" )
		)
		;else
		(print "player is already in river holdout area, continuing mission script" )
	)
)

;wait until the encounter is over and the player leaves the area to update encounter progress
(script dormant update_holdout_progress_river
	(sleep_until global_river_end 1)
	(sleep_until (or (volume_test_players river_1) (volume_test_players river_2)) 1)
	(set s_holdout_progress (+ s_holdout_progress 1))
)

(script dormant river_marine_contact
	(sleep_until (volume_test_players river_retreat)1)
	(set global_river_contact true)
)

;call in foehammer for end of hilltop encounter.
;called from the foehammer spawner
(script command_script cs_foehammer_river_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(object_cannot_die ai_current_actor true)
	(cs_enable_dialogue false)

	;if the warthog is not in hilltop encounter or is dead then spawn a new warthog
	(if (or (not (volume_test_object river_all jeep_global)) (<= (unit_get_health jeep_global) 0))
		(begin
			; spawn the warthog and attach it to the dropship
			(object_create jeep5)
			(set jeep_global jeep5)
			(unit_enter_vehicle jeep5 (ai_vehicle_get_from_squad ai_current_squad 0) "pelican_lc")

			; warthog_t is the 4th seat at the back bumper - reserve it for the player
			(ai_vehicle_reserve_seat jeep5 "warthog_t" true)
		)
	)

	;kill any followers who were not in the hillotp encounter.
	(f_kill_faraway_followers sq_player_followers sq_gr_river_marine river_all)

	;check if there is room for another follower then add marine to squad
	(if (and (> (ai_living_count sq_gr_river_marine) 0) (< (ai_living_count sq_player_followers) s_followers_count))
		(ai_migrate (object_get_ai (list_get (ai_actors sq_gr_river_marine) 0)) sq_player_followers)
	)
	(sleep 2)
	;check if there is room for another follower then add marine to squad
	(if (and (> (ai_living_count sq_gr_river_marine) 0) (< (ai_living_count sq_player_followers) s_followers_count))
		(ai_migrate (object_get_ai (list_get (ai_actors sq_gr_river_marine) 0)) sq_player_followers)
	)

	;have the marines try to get into the warthog if any where saved.
	(if (not (= 0 (ai_living_count sq_player_followers))) (wake river_marines_find_warthog))

	; entry flight path, flies to each point in sequence
	(cs_teleport foehammer_river_point_set/p0 foehammer_river_point_set/p5)

	(cs_fly_by foehammer_river_point_set/p4)
	(cs_fly_by foehammer_river_point_set/p5)
	(cs_vehicle_speed 0.4)

	;deliver a warthog if needed.
	(if (unit_in_vehicle jeep5)
		(begin
			; drop the warthog
			(cs_fly_to_and_face foehammer_river_point_set/p5 foehammer_river_point_set/p7 0.50)
			(sleep (game_ticks_from_seconds 1))
			(cs_fly_to_and_face foehammer_river_point_set/p8 foehammer_river_point_set/p7 0.50)
			(sleep (game_ticks_from_seconds 1))
			(sleep_until (= (volume_test_players jeep_drop5) false) 1)
			(unit_exit_vehicle jeep5)
			(wake handle_river_jeep_navpoint)
		)
	)

	;(wake navpoint_river_exit)
	(set global_river_exit true)
	(if (= 0 (ai_living_count sq_gr_river_marine))
		(begin
			(game_save_no_timeout)
			(cs_vehicle_speed 1.0)
		)
		;else
		(begin
			;fly to evac point for marines
			(cs_fly_to_and_face foehammer_river_point_set/p11 foehammer_river_point_set/p12 0.50)
			(cs_fly_to_and_face foehammer_river_point_set/p9 foehammer_river_point_set/p13 0.50)
			;(cs_fly_by foehammer_river_point_set/p1)
			(cs_fly_to_and_face foehammer_river_point_set/p1 foehammer_river_point_set/p13 0.50)
			(cs_vehicle_speed 0.4)
			;(cs_fly_to_and_face foehammer_river_point_set/p2 foehammer_river_point_set/p3 0.25)

			(print_if debug "marines boarding pelican")
			;blocking function which wait for the marines to continue the script
			(f_marines_enter_pelican sq_gr_river_marine ai_current_squad)

			(cs_vehicle_speed 1.0)

			;foehammer flies up
			(game_save_no_timeout)
			(cs_fly_to_and_face foehammer_river_point_set/p9 foehammer_river_point_set/p13 0.50)
			(cs_fly_by foehammer_river_point_set/p14)
		)
	)

	;foehammer flies away
	(cs_fly_by foehammer_river_point_set/p4)
	(cs_fly_by foehammer_river_point_set/p0)

	(f_dropship_actor_scale_destroy ai_current_actor)
)

;have the marines in hilltop find and jump in the warthog.
(script dormant river_marines_find_warthog
	;while the ai followers are not in the seat attempt to have them get in the seat
	(sleep_until
		(begin
			; do
			(ai_vehicle_reserve_seat jeep_global "warthog_d" true)
			(ai_vehicle_enter sq_player_followers jeep_global)
			(if (vehicle_test_seat jeep_global "warthog_p")
				(set followers_in_warthog true)
			)

			; while
			(or
				(= followers_in_warthog true)
				(volume_test_players river_1)
				(volume_test_players river_2)
				(< (unit_get_health jeep_global) 0)
			)
		)
	90)

	(set followers_in_warthog false)
)

(script dormant mission_obj
	;this should place mid_cliff_1
	(ai_place sq_gr_mid_cliff1)

	;ensuring correct values
	(set global_cliff_end false)
	(set global_rubble_end false)
	(set global_river_end false)

	(sleep_until (or global_cliff_end
					 global_rubble_end
					 global_river_end)
	1)

	(set mark_search2 true) ; show next objective about searching for survivors
	(wake dialogue_reunion_tour_finished_1)

	(cond
		((volume_test_players_all cliff_all) 	(begin (wake mission_mid_rubble_1)))
		((volume_test_players_all rubble_all) 	(begin (wake mission_mid_cliff_1) (wake mission_mid_river_1)))
		((volume_test_players_all river_all) 	(begin (wake mission_mid_cliff_2) (ai_place sq_gr_mid_rubble2)))
	)

	(wake mission_mid_banshee)

	(sleep_until (not (or (volume_test_players_all cliff_all)
					  (volume_test_players_all rubble_all)
					  (volume_test_players_all river_all))) 1)
	(wake dialogue_reunion_tour_finished_1_exit)

	(sleep_until (or (and global_cliff_end
				  	  global_rubble_end)
				  (and global_cliff_end
				  	  global_river_end)
			  	  (and global_rubble_end
				  	  global_river_end)) 1)

	;*(if (not (or (and global_cliff_start
			  	   global_rubble_start
			  	   (or (volume_test_players cliff_all)
			  	   	  (volume_test_players rubble_all)))
			   (and global_cliff_start
			  	   global_river_start
			  	   (or (volume_test_players cliff_all)
			  	   	  (volume_test_players river_all)))
		  	   (and global_rubble_start
			  	   global_river_start
			  	   (or (volume_test_players rubble_all)
			  	   	  (volume_test_players river_all)))))
		(begin (print "wake dialog_one_rescued_prompt")
			  (cond ((and global_cliff_exit global_rubble_exit) (sleep 1))
				   ((and global_cliff_exit global_river_exit) (sleep 1))
			  	   ((and global_rubble_exit global_river_exit) (sleep 1))
			  	   ((not global_river_exit) (print "navpoint stub"))
				   ((not global_rubble_exit) (print "navpoint stub"))
				   ((not global_cliff_exit) (print "navpoint stub"))
	)))*;

	(set mark_search3 true) ; show next objective about searching for survivors
	(wake dialogue_reunion_tour_finished_2)

	(cond ((volume_test_players_all cliff_all) 	(begin (wake mission_mid_rubble_1)))
		  ((volume_test_players_all rubble_all) (begin (wake mission_mid_cliff_1) (wake mission_mid_river_1)))
		  ((volume_test_players_all river_all) 	(begin (wake mission_mid_cliff_2) (ai_place sq_gr_mid_rubble2)))
	)

;	(set mark_final_banshee true)

	(sleep_until (and global_cliff_end
				   global_rubble_end
			  	   global_river_end)
	1)

	(set mark_search4 true)
)

(script dormant mission_mid_banshee
	(print "running function mission_mid_banshee")

	;spawning logic
	(ai_place sq_gr_mid_banshee)

	;destroying logic
	;wait until cont_banshee_kill is set to true
	(sleep_until cont_banshee_kill 1)

	;now wait until the banshees are out of view of the player for long enough, then delete banshees (don't know if it works well enough)
	(sleep_until (not (objects_can_see_object (players) sq_gr_mid_banshee 1)) 1)
	(sleep (game_ticks_from_seconds 2.5))
	(if (not (objects_can_see_object (players) sq_gr_mid_banshee 1)) (begin (ai_erase sq_gr_mid_banshee)(print "destroying mid_banshee")))
)

; a30 mission first waves ==============================================================================================================================================

(script dormant mission_first_marine
	(set global_first_marine_attack true)

	(sleep_until
		(or
			global_first_wave_5
			(and (< (ai_living_count sq_gr_first_starters) 5) b_first_wave_2_calledout) ;if less than 5 marines are left and wave 2 is called out
		)
		1
	)

	(set global_first_marine_attack false)
	(set global_first_marine_defend true)
)

;task sq_follow_greetplayer of aiobjective_holdout_first_marine calls this cs
(script command_script cs_greet_player
	(print "cs_greet_player started")
	(cs_approach_player 2 15 3)
	(cs_face_player true)
	(cs_walk true)

	(sleep_until (script_finished dialogue_first_wave_1_defeated_johnson) 1)
	(cs_face_player false)
	(cs_walk false)
	(cs_approach_stop)
	(print "cs_greet_player over")
)

(script static void mission_first_wave_1

	(ai_place sq_pass_cship)
	(set cship_global (ai_vehicle_get_from_spawn_point  sq_pass_cship/pilot_spawn))
	(f_load_fork cship_global "dual" wave_1_lz_grunt none wave_1_lz_elite none)
	(sleep_until (not (volume_test_players_all first_arrival)) 1)

	(ai_magically_see_object sq_gr_holdout0_wave1 sq_gr_first_starters)

	(set global_first_wave_1 true)
)

(script command_script cs_pass_dropship_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_teleport pass_cship_point_set/p1 pass_cship_point_set/p1)
	(cs_vehicle_speed 0.6)
	(sleep_until (volume_test_players first_back_lz) 1)
	(unit_open cship_global)
	(f_unload_fork_all cship_global)
	(sleep (game_ticks_from_seconds 1.0))
	(unit_close cship_global)
	; fly away and despawn
	(cs_vehicle_speed 1.0)

	(cs_fly_by pass_cship_point_set/p2)
	(cs_fly_by pass_cship_point_set/p3)
	(cs_fly_by pass_cship_point_set/p4)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

; first_wave/wave_2_lz_toon -> wave_2_grunt
(script static void mission_first_wave_2

	(ai_place sq_fort_cship)
	(set cship_global (ai_vehicle_get_from_spawn_point  sq_fort_cship/pilot_spawn))
	(f_load_fork cship_global "any" sq_gr_holdout0_wave2 none none none)
	; the rest of the wave behavior is managed in cs_fort_dropship_lid
	(f_valid_fork_offload cship_global sq_gr_holdout0_wave2)
	(set global_first_wave_2 true)

)

(script command_script cs_fort_dropship_lid

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	; entry flight path, flies to each point in sequence
	(cs_teleport fort_cship_point_set/p0 fort_cship_point_set/p2)

	(sleep (game_ticks_from_seconds 0.33))
	(f_blip_object cship_global 1)
	(cs_fly_by fort_cship_point_set/p2)
	(cs_vehicle_speed 0.6)
	(cs_fly_to fort_cship_point_set/p1 0.25)
	(unit_open cship_global)
	(f_unload_fork_all cship_global)
	(sleep (game_ticks_from_seconds 4.0))
	(sleep_until (not (volume_test_players first_structure_back)) 1 delay_dawdle)
	(unit_close cship_global)

	(f_unblip_object cship_global)

	(ai_magically_see_object sq_gr_holdout0_wave2 sq_gr_first_starters)
	(ai_magically_see_object sq_gr_first_starters sq_gr_holdout0_wave2)
	(sleep_until (not (volume_test_players first_fort_lz)) 1)
	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_by fort_cship_point_set/p2)
	(cs_fly_by fort_cship_point_set/p3)
	(cs_fly_by fort_cship_point_set/p4)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

;first_wave/wave_3_lz_toon -> wave_3_grunt
(script static void mission_first_wave_3

	(ai_place sq_pipe_cship)
	(set cship1_global (ai_vehicle_get_from_spawn_point  sq_pipe_cship/pilot_spawn))
	(f_load_fork cship1_global "any" none sq_gr_holdout0_wave3 none none)
	(sleep_until (not (volume_test_players first_pipe_lz)) 1 delay_dawdle)
	(ai_magically_see_object sq_gr_holdout0_wave3 sq_gr_first_marine)
	(ai_magically_see_object sq_gr_first_marine sq_gr_holdout0_wave3)
	(f_valid_fork_offload cship1_global sq_gr_holdout0_wave3)
	(set global_first_wave_3 true)
	; the rest of the wave behavior is managed in cs_pipe_dropship_lid
)

(script command_script cs_pipe_dropship_lid

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)

	; entry flight path, flies to each point in sequence
	(cs_teleport pipe_cship_point_set/p0 pipe_cship_point_set/p1)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object cship1_global 1)

	(cs_vehicle_speed 0.6)
	(cs_fly_by pipe_cship_point_set/p2)
	(cs_fly_to pipe_cship_point_set/p1 0.25)
	(unit_open cship1_global)
	(f_unload_fork_all cship1_global)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close cship1_global)

	(f_unblip_object cship1_global)

	; fly away and despawn
	(cs_vehicle_speed 1.0)

	(cs_fly_to_and_face pipe_cship_point_set/p2 pipe_cship_point_set/p4)
	(cs_fly_by pipe_cship_point_set/p3)
	(cs_fly_by pipe_cship_point_set/p0)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

;first_wave/wave_3_lz_toon -> wave_3_grunt
(script static void mission_first_wave_4

	(ai_place sq_back_cship)
	(set cship_global (ai_vehicle_get_from_spawn_point  sq_back_cship/pilot_spawn))
	(f_load_fork cship_global "any" none none sq_gr_holdout0_wave4 none)
	(sleep_until (not (volume_test_players first_back_lz)) 1)
	(ai_magically_see_object sq_gr_holdout0_wave4 sq_gr_first_marine)
	(ai_magically_see_object sq_gr_first_marine sq_gr_holdout0_wave4)
	(f_valid_fork_offload cship_global sq_gr_holdout0_wave4)
	(set global_first_wave_4 true)
)

(script command_script cs_back_dropship_lid

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	; entry flight path, flies to each point in sequence
	(cs_teleport pass_cship_point_set/p4 pass_cship_point_set/p3)
	(cs_fly_by pass_cship_point_set/p3)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object cship_global 1)

	(cs_vehicle_speed 0.6)
	(cs_fly_by pass_cship_point_set/p2)
	(cs_fly_to pass_cship_point_set/p1 0.25)
	(unit_open cship_global)
	(f_unload_fork_all cship_global)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close cship_global)

	(f_unblip_object cship_global )

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face pass_cship_point_set/p5 pass_cship_point_set/p6)
	(cs_fly_by pass_cship_point_set/p6)
	(cs_fly_by pass_cship_point_set/p7)
	(f_dropship_actor_scale_destroy ai_current_actor)

)

(script static void mission_first_wave_5

	(ai_place sq_pipe_2_cship)
	(set cship1_global (ai_vehicle_get_from_spawn_point  sq_pipe_2_cship/pilot_spawn))
	(f_load_fork cship1_global "any"  none none sq_gr_holdout0_wave5 none)
	; the rest of the wave behavior is managed in cs_pipe_2_dropship_lid
	(sleep_until (not (volume_test_players first_pipe_lz)) 1 delay_dawdle)
	(ai_magically_see_object sq_gr_holdout0_wave5 sq_gr_first_marine)
	(ai_magically_see_object sq_gr_first_marine sq_gr_holdout0_wave5)
	(f_valid_fork_offload cship1_global sq_gr_holdout0_wave5)
	(set global_first_wave_5 true)
)

(script command_script cs_pipe_2_dropship_lid

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)

	; entry flight path, flies to each point in sequence
	(cs_teleport pipe_cship_point_set/p0 pipe_cship_point_set/p1)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object cship1_global 1)

	(cs_vehicle_speed 0.6)
	(cs_fly_by pipe_cship_point_set/p2)
	(cs_fly_to pipe_cship_point_set/p1 0.25)
	(unit_open cship1_global)
	(f_unload_fork_all cship1_global)

	;ensure marines spot the covenant faster
	(ai_magically_see_object sq_gr_first_marine sq_gr_holdout0_wave5)
	(sleep (game_ticks_from_seconds 4.0))

	(unit_close cship1_global)
	; fly away and despawn

	(f_unblip_object cship1_global)

	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face pipe_cship_point_set/p2 pipe_cship_point_set/p4)
	(cs_fly_by pipe_cship_point_set/p3)
	(cs_fly_by pipe_cship_point_set/p0)
	(f_dropship_actor_scale_destroy ai_current_actor)
)


(script static void mission_first_wave_6

	(ai_place sq_fort_2_cship)
	(set cship_global (ai_vehicle_get_from_spawn_point  sq_fort_2_cship/pilot_spawn))
	(f_load_fork cship_global "any" none sq_gr_holdout0_wave6 none none)
	; the rest of the wave behavior is managed in cs_fort_2_dropship_lid
	(sleep_until (not (volume_test_players first_structure_back)) 1 delay_dawdle)
	(ai_magically_see_object sq_gr_holdout0_wave6 sq_gr_first_marine)
	(ai_magically_see_object sq_gr_first_marine sq_gr_holdout0_wave6)
	(f_valid_fork_offload cship_global sq_gr_holdout0_wave6)
	(set global_first_wave_6 true)
)

(script command_script cs_fort_2_dropship_lid

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)

	; entry flight path, flies to each point in sequence
	(cs_teleport fort_cship_point_set/p0 fort_cship_point_set/p2)
	(cs_vehicle_speed 0.6)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object cship_global 1)

	(cs_fly_by fort_cship_point_set/p2 )
	(cs_fly_to fort_cship_point_set/p1 0.25)
	(unit_open cship_global)
	(f_unload_fork_all cship_global)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close cship_global)

	(f_unblip_object cship_global)

	; fly away and despawn
	(cs_vehicle_speed 1.0)

	(cs_fly_by fort_cship_point_set/p2)
	(cs_fly_by fort_cship_point_set/p3)
	(cs_fly_by fort_cship_point_set/p4)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

; a30 mission cave scripts ==============================================================================================================================================

(script dormant objective_cave
	;(activate_team_nav_point_object "default_red" player jeep .5)
	;(breadcrumbs_activate_team_nav_point_object "default" player jeep .5)

; please note that 'delay_lost' has not been increased to compensate for the fact that that objective_cave is now woken earlier.
	(sleep_until (or (volume_test_players cave_entrance)
				  (vehicle_test_seat_unit_list jeep_global "" (players))) 1 delay_lost)

	(if (vehicle_test_seat_unit_list jeep_global "" (players))
		(begin 	(print "****************************************")
		    	(print "player entered jeep")
		    	(print "warthog tutorial stub")
		    	(print "warthog tutorial stub")
		    	(print "warthog tutorial stub")
		    	(print "warthog tutorial stub")
		    	(print "warthog tutorial stub")
		    	(print "warthog tutorial stub")
		    	(print "warthog tutorial stub")
		    	(print "warthog tutorial stub")
		    	(print "****************************************")
				;(if (< s_navpoint_index 3) (set s_navpoint_index 3))
		)
	)

	(sleep_until (or (not (volume_test_players_all first_drop))
				  (volume_test_players cave_entrance)) 1 delay_late)

	(sleep_until (volume_test_players cave_entrance) 1)
	(set mark_searchstart true)
	(wake dialogue_cave_entrance)
	;(deactivate_team_nav_point_flag player cave_nav_flag)

	(sleep_until (volume_test_players cave_pretzel) 1)
	(set s_music_trigger 120)
)

(script dormant obj_cave_prompt
	(wake dialogue_cave_bridge_prompt)
	(wake dialogue_light_bridge_controls)
	(wake callout_controls)
)


; a30 mission holdout cliff scripts ==============================================================================================================================================

(script dormant obj_cliff_arrival
	(sleep_until (volume_test_players cliff_arrival) 1)

	(game_save_no_timeout)
)

(script dormant obj_cliff_abandon
	;make sure all players are now in the encounter after the teleport
	(sleep_until (volume_test_players_all cliff_all) 1)

	(sleep_until (not (volume_test_players_all cliff_all)) 1)
	(set b_leave_holdout_early_progress true)
	(dialogue_abandon)

)

(script dormant mission_cliff_marine
	;*player needs to get to the second floor underground
	(sleep_until (or (volume_test_players cliff_right_fort_second_floor)
		   			 (volume_test_players cliff_left_fort_second_floor)) 5
	)*;
	(sleep_until (or (volume_test_players cliff_marine_entrance_4)
		   			 (volume_test_players cliff_marine_entrance_2)) 1
	)

	;check if there is too many bipeds and clean some up
	(f_set_non_cliff_holdout_squads_as_dispoable)

	;spawn jackals and marines/crewman
	(ai_place sq_cliffside_inside_jackal)
	(ai_place enc_holdout_cliffside_marine)
	(ai_magically_see_object sq_cliffside_inside_jackal sq_holdout_cliffside_marine)
	(ai_magically_see_object sq_cliffside_inside_jackal sq_holdout_cliffside_marine)
	(ai_prefer_target_team sq_cliffside_inside_jackal "human")

	;begin checks for all marine/crewman killed
	(wake obj_cliff_all_killed)
	(wake dialogue_cliff_dawdle_prompt)

	;mark marines
	;(f_blip_allied_squad enc_holdout_cliffside_marine)

	;wait until the player gets the the bottom of the inside.
	(sleep_until (volume_test_players cliff_inside_left_bottom) 1)

	;wait until jackals are eliminated or the delay_late timer expires
	(sleep_until (< (ai_living_count sq_cliffside_inside_jackal) 1) 1 delay_late)

	;have the marines/crewman join the fireteam.
	(set marines_follow_underground true)
	(ai_magically_see_object sq_cliffside_inside_grunt_left sq_holdout_cliffside_marine)
	(ai_magically_see_object sq_cliffside_inside_grunt_right sq_holdout_cliffside_marine)

	;(ai_player_add_fireteam_squad player0 sq_holdout_cliffside_marine)
	;(ai_player_add_fireteam_squad player0 sq_holdout_cliffside_crewmen)
	;(print_if (ai_is_in_fireteam sq_holdout_cliffside_marine) "ai marines following the player")
	;(print_if (not (ai_is_in_fireteam sq_holdout_cliffside_marine)) "ai marines not following the player")

	;set value having rescued the marines
	(set global_cliff_welcome true)

	(sleep_until (or (volume_test_players cliff_right_fort_first_floor)
				 	 (volume_test_players cliff_left_fort_first_floor)) 1)

	(set global_marines_follow_player true)
)

(script dormant obj_cliff_all_killed
	;wait until all the marines are dead
	(sleep_until (= 0 (ai_living_count enc_holdout_cliffside_marine)) 1)

	(sleep_forever obj_cliff_abandon)
	(sleep (game_ticks_from_seconds 2))
	(set global_cliff_all_killed true)

	;if the player are present tell them the marines have died.
	(if (volume_test_players cliff_all)
		(dialogue_all_dead))

	;(if (not (and global_river_end global_rubble_end)) (set global_cliff_end true))
)

(script dormant mission_extraction_cliff
	(wake dialogue_third_reunion_tour_complete)
	(sleep_until (script_finished "dialogue_third_reunion_tour_complete") 1)

	(sleep (game_ticks_from_seconds 3))
	(wake mission_complete)
)

(script dormant marines_enter_pelican_cliff
	(sleep_until
		(begin
			; do
			(ai_vehicle_enter enc_holdout_cliffside_marine foehammer_global "pelican_p")
			(ai_vehicle_enter sq_player_followers foehammer_global "pelican_p")

			; while
			(vehicle_test_seat_unit_list foehammer_global "pelican_p" (players))
		) (game_ticks_from_seconds 1)
	)
)


; a30 mission holdout rubble scripts ==============================================================================================================================================

(script dormant mission_rubble_marine
	(ai_place enc_holdout_rubble_marine)
	(wake dialogue_rubble_sniper)
)

(script dormant obj_rubble_abandon
	;ensure all players have teleported to the encounter
	(sleep_until (volume_test_players_all rubble_all) 1)

	(sleep_until (not (volume_test_players_all rubble_all)) 1)
	(set b_leave_holdout_early_progress true)
	(dialogue_abandon)
)

(script dormant obj_rubble_all_killed
	;wait until the marines die
	(sleep_until (= 0 (ai_living_count enc_holdout_rubble_marine)) 1)

	(sleep_forever obj_rubble_abandon)
	(sleep (game_ticks_from_seconds 2))

	(set global_rubble_all_killed true)

	;if the player are present tell them the marines have died.
	(if (volume_test_players rubble_all)
		(dialogue_all_dead))
)

(script dormant mission_extraction_rubble
	(wake dialogue_third_reunion_tour_complete)
	(sleep_until (script_finished "dialogue_third_reunion_tour_complete") 1)
	(sleep (game_ticks_from_seconds 3))
	(wake mission_complete)
)

(script dormant mission_rubble_wave_1
	(sleep (game_ticks_from_seconds 5))

	(set global_rubble_wave_1_attack true)
	(ai_magically_see enc_holdout_rubble_cov enc_holdout_rubble_marine)
	(ai_magically_see enc_holdout_rubble_marine enc_holdout_rubble_cov)

)

(script static void mission_rubble_wave_2
	(print "wave 2 start")
	(f_set_non_rubble_holdout_squads_as_dispoable)

	(ai_place rubble_wave_2_cship)
	(set cship_global (ai_vehicle_get_from_spawn_point  rubble_wave_2_cship/pilot_spawn))
	(f_load_fork cship_global "any" none none sq_holdout_rubble_cov_wave_2 none)
	(set global_rubble_wave_2_attack true)
)

(script command_script cs_rubble_dropship_wave2

	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport pts_cship_rubble_1/p0 pts_cship_rubble_1/p5)
	(cs_fly_by pts_cship_rubble_1/p5)
	(cs_vehicle_speed 0.6)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object cship_global 1)

	(cs_fly_by pts_cship_rubble_1/p1)
	(cs_vehicle_speed 0.6)
	(cs_fly_to_and_face pts_cship_rubble_1/p2 pts_cship_rubble_1/p7 .1)
	(unit_open cship_global)
	(f_unload_fork_all cship_global)

	(set global_rubble_wave_2 true)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close cship_global)
	(set b_ship_safe_load true)

	(f_unblip_object cship_global)

	(sleep (game_ticks_from_seconds 3.0)) ;
	(ai_magically_see enc_holdout_rubble_cov enc_holdout_rubble_marine)
	(ai_magically_see enc_holdout_rubble_marine enc_holdout_rubble_cov)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face pts_cship_rubble_1/p6 pts_cship_rubble_1/p7)
	(cs_fly_by pts_cship_rubble_1/p3)
	(cs_fly_by pts_cship_rubble_1/p4)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script static void mission_rubble_wave_3
	(print "wave 3 start")
	(f_set_non_rubble_holdout_squads_as_dispoable)

	(ai_place rubble_wave_3_cship)
	(set cship1_global (ai_vehicle_get_from_spawn_point  rubble_wave_3_cship/pilot_spawn))

	(f_load_fork cship1_global "any" none none sq_holdout_rubble_cov_wave_3 none)
)

(script command_script cs_rubble_dropship_wave3
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport pts_cship_rubble_2/p0 pts_cship_rubble_2/p3)
	(cs_fly_by pts_cship_rubble_2/p5)
	(cs_vehicle_speed 0.6)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object cship1_global 1)

	(cs_fly_by pts_cship_rubble_2/p3)
	(cs_fly_to_and_face pts_cship_rubble_2/p7 pts_cship_rubble_2/p6 0.1)
	(cs_fly_to_and_face pts_cship_rubble_2/p1 pts_cship_rubble_2/p6 0.1)
	(unit_open cship1_global)
	(f_unload_fork_all cship1_global)
	(set global_rubble_wave_3 true)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close cship1_global)

	(f_unblip_object cship1_global )

	(ai_magically_see enc_holdout_rubble_cov enc_holdout_rubble_marine)
	(ai_magically_see enc_holdout_rubble_marine enc_holdout_rubble_cov)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face pts_cship_rubble_2/p7 pts_cship_rubble_2/p6 0.1)
	(cs_fly_by pts_cship_rubble_2/p2)
	(cs_fly_by pts_cship_rubble_2/p4)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script static void mission_rubble_wave_4
	(print "wave 4 start")
	; now let the marines gather on top of the rock

	(f_set_non_rubble_holdout_squads_as_dispoable)

	(ai_place rubble_wave_4_cship)
	(set cship_global (ai_vehicle_get_from_spawn_point  rubble_wave_4_cship/pilot_spawn))

	(f_load_fork cship_global "any" none none sq_holdout_rubble_cov_wave_4 none)

)

(script command_script cs_rubble_dropship_wave4
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence

	(cs_teleport pts_cship_rubble_1/p0 pts_cship_rubble_1/p5)
	(cs_fly_by pts_cship_rubble_1/p5)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object cship_global 1)

	(cs_fly_to pts_cship_rubble_1/p1 0.1)
	(cs_vehicle_speed 0.6)
	(cs_fly_to_and_face pts_cship_rubble_1/p2 pts_cship_rubble_1/p7 .1)
	;might be needed removed for now
	;(sleep_until (not (volume_test_objects rubble_rock_lz (players))) 15 delay_dawdle)
	(unit_open cship_global)
	(f_unload_fork_all cship_global)
	(set global_rubble_wave_4 true)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close cship_global)

	(f_unblip_object cship_global)

	(sleep (game_ticks_from_seconds 3.0))

	(ai_magically_see enc_holdout_rubble_cov enc_holdout_rubble_marine)
	(ai_magically_see enc_holdout_rubble_marine enc_holdout_rubble_cov)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face pts_cship_rubble_1/p6 pts_cship_rubble_1/p7)
	(cs_fly_by pts_cship_rubble_1/p3)
	(cs_fly_by pts_cship_rubble_1/p4)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script static void mission_rubble_wave_5
	(print "wave 5 start")

	(f_set_non_rubble_holdout_squads_as_dispoable)

	(ai_place rubble_wave_5_cship)
	(set cship1_global (ai_vehicle_get_from_spawn_point  rubble_wave_5_cship/pilot_spawn))

	(f_load_fork cship1_global "any" sq_holdout_rubble_cov_wave_5 none none none)

)

(script command_script cs_rubble_dropship_wave5
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport pts_cship_rubble_4/p0 pts_cship_rubble_4/p2)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object cship1_global 1)

	(cs_fly_by pts_cship_rubble_4/p2)
	(cs_vehicle_speed 0.6)
	(cs_fly_to_and_face pts_cship_rubble_4/p3 pts_cship_rubble_4/p4 0.1)
	(cs_fly_to_and_face pts_cship_rubble_4/p1 pts_cship_rubble_4/p4 0.1)

	(unit_open cship1_global)
	(f_unload_fork_all cship1_global)

	(set global_rubble_wave_5 true)
	(sleep (game_ticks_from_seconds 4.0))
	(unit_close cship1_global)

	(f_unblip_object cship1_global)

	(ai_magically_see enc_holdout_rubble_cov enc_holdout_rubble_marine)
	(ai_magically_see enc_holdout_rubble_marine enc_holdout_rubble_cov)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face pts_cship_rubble_4/p3 pts_cship_rubble_4/p2)
	(cs_fly_by pts_cship_rubble_4/p2)
	(cs_fly_by pts_cship_rubble_4/p0)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

; a30 mission holdout river scripts ==============================================================================================================================================

(script dormant mission_river_marine
	(ai_place sq_gr_river_marine)
)


(script dormant mission_river_wave_1
	(ai_place sq_gr_river_wave1)
)

(script static void mission_river_wave_2
	(ai_place sq_river_boat_cship)
	(set cship_global (ai_vehicle_get_from_spawn_point  sq_river_boat_cship/pilot_spawn))
	(f_load_fork cship_global "any" none sq_gr_river_wave2 none none)
)

(script command_script cs_river_dropship_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport river_boat_cship_point_set/p0 river_boat_cship_point_set/p3)
	(sleep (game_ticks_from_seconds 0.33))

	(f_blip_object ai_current_actor 1)

	(cs_vehicle_speed 0.6)
	(cs_fly_to river_boat_cship_point_set/p3)
	(cs_fly_to river_boat_cship_point_set/p1)
	(cs_fly_to_and_face river_boat_cship_point_set/p2 river_boat_cship_point_set/p5)
	(unit_open cship_global)

	(f_unload_fork_all ai_current_actor)
	(sleep (game_ticks_from_seconds 4.0))

	(set global_river_wave_2 true)
	;make sure this covenant wave is not ignored by the marines after they have exited the dropship

	(unit_close ai_current_actor)

	(f_unblip_object ai_current_actor)

	; fly away
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face river_boat_cship_point_set/p1 river_boat_cship_point_set/p5)
	(cs_fly_by river_boat_cship_point_set/p3)
	(cs_fly_by river_boat_cship_point_set/p4)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant obj_river_abandon
	;make sure all the players have made it in and one has made it far enough to ensure we don't accidently fail the player with a quick backtrack
	(sleep_until (volume_test_players_all river_all) 1)

	;sleep until all the player have left the river encounter.
	(sleep_until (not (volume_test_players_all river_all)) 1)
	(set b_leave_holdout_early_progress true)
	(dialogue_abandon)

)

(script dormant obj_river_all_killed
	;wait until the marines die.
	(sleep_until (= 0 (ai_living_count sq_gr_river_marine)) 1)

	(sleep_forever obj_river_abandon)
	(sleep (game_ticks_from_seconds 2))

	(set global_river_all_killed true)

	;if the player are present tell them the marines have died.
	(if (volume_test_players river_all)
		(dialogue_all_dead))

	;(if (not (and global_rubble_end global_cliff_end)) (set global_river_end true))
)

(script dormant mission_extraction_river
	(wake dialogue_third_reunion_tour_complete)
	(sleep_until (script_finished "dialogue_third_reunion_tour_complete") 1)
	(sleep (game_ticks_from_seconds 3))
	(wake mission_complete)
)

(script dormant mission_complete
	(print "end game")
	(submit_incident_with_custom_string_id "game_activity_end_completed" "a30")
	(f_play_cinematic cinematics\a30\a30_outro.cinematic)
	(submit_incident "unlock_a50")
	(game_won)
)

; a30 mission obj scripts ==============================================================================================================================================

(script dormant mission_mid_rubble_1
	(ai_place sq_gr_mid_rubble1)

	(ai_place sq_midrubble_cship)
	(set mid_ship_global (ai_vehicle_get_from_spawn_point  sq_midrubble_cship/pilot_spawn))
)

(script command_script cs_midrubble_dropship_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport mid_rubble_point_set/p2 mid_rubble_point_set/p1)
	(cs_vehicle_speed 0.7)
	(cs_fly_to_and_face mid_rubble_point_set/p1 mid_rubble_point_set/p3)
	(cs_fly_to_and_face mid_rubble_point_set/p0 mid_rubble_point_set/p3)

	(sleep_until (or (volume_test_players midrubble_1_trigger)
					(< (ai_strength sq_gr_mid_rubble1) .9)
				  	(objects_can_see_object (players) mid_ship_global 5)) 1
	)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face mid_rubble_point_set/p1 mid_rubble_point_set/p3)
	(cs_fly_by mid_rubble_point_set/p2)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant mission_mid_cliff_1
	; removed (ai_place sq_gr_mid_cliff1), now mission_mid_cliff_1 is only responsible for the sq_midcliff_1_cship logic
	(ai_place sq_midcliff_1_cship)
	(set mid_ship_global (ai_vehicle_get_from_spawn_point  sq_midcliff_1_cship/pilot_spawn))
)

(script command_script cs_midcliff1_dropship_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport mid_cliff_1_point_set/p2 mid_cliff_1_point_set/p1)
	(cs_vehicle_speed 0.7)
	(cs_fly_to mid_cliff_1_point_set/p1)
	(cs_fly_to mid_cliff_1_point_set/p0)

	(sleep_until (or (volume_test_players midcliff_1_trigger)
					(< (ai_strength sq_gr_mid_cliff1) .9)
				  	(objects_can_see_object (players) mid_ship_global 5)) 1
	)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_by mid_cliff_1_point_set/p1)
	(cs_fly_by mid_cliff_1_point_set/p2)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant mission_mid_cliff_2
	(ai_place sq_gr_mid_cliff2)

	(ai_place sq_midcliff_2_cship)
	(set mid_ship_global (ai_vehicle_get_from_spawn_point  sq_midcliff_2_cship/pilot_spawn))
)

(script command_script cs_midcliff2_dropship_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport mid_cliff_2_point_set/p2 mid_cliff_2_point_set/p2)
	(cs_vehicle_speed 0.7)
	(cs_fly_to mid_cliff_2_point_set/p1)
	(cs_fly_to mid_cliff_2_point_set/p0)

	(sleep_until (or (volume_test_players midcliff_2_trigger)
					(< (ai_strength sq_gr_mid_cliff2) .9)
				  	(objects_can_see_object (players) mid_ship_global 5)) 1
	)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face mid_cliff_2_point_set/p1 mid_cliff_2_point_set/p2)
	(cs_fly_by mid_cliff_2_point_set/p5)
	(cs_fly_by mid_cliff_2_point_set/p4)
	(cs_fly_by mid_cliff_2_point_set/p3)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant mission_mid_river_1
	(ai_place sq_gr_mid_river1)

	; todo -  midriver_cship_1
)

(script command_script cs_midriver_dropship_lid
	; enable failsafes for the scripted flight path
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; entry flight path, flies to each point in sequence
	(cs_teleport mid_river_point_set/p2 mid_river_point_set/p1)
	(cs_fly_to_and_face mid_river_point_set/p3 mid_river_point_set/p1)
	(cs_vehicle_speed 0.7)
	(cs_fly_to_and_face mid_river_point_set/p1 mid_river_point_set/p4)
	(cs_fly_to_and_face mid_river_point_set/p0 mid_river_point_set/p4)

	(sleep_until (or (volume_test_players midriver_1_trigger)
					(< (ai_strength sq_gr_mid_river1) .9)
				  	(objects_can_see_object (players) mid_ship_global 5)) 1
	)

	; fly away and despawn
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face mid_river_point_set/p1 mid_river_point_set/p3)
	(cs_fly_by mid_river_point_set/p3)
	(cs_fly_by mid_river_point_set/p2)
	(f_dropship_actor_scale_destroy ai_current_actor)
)


;========== first scripts ==========

(script dormant obj_first_abandon
	(sleep_until (or global_first_end
				  (and (< 0 (player_count))
					  (not (or (volume_test_players first_structure_1)
							   (volume_test_players first_structure_2))))) 1)

	;(if (not global_first_end) (ai_conversation first_abandon))
	(if (not global_first_end) (print "dialogue: first_abandon"))
)




; ================== player followers handling ==================
(script static void (f_add_to_follower_squad (ai newsquad))
	(print "adding ai to follower squad")

	(init_player_followers_fireteam)

	(if (< (ai_living_count sq_player_followers) s_followers_count)
		(sleep_until
			(begin ; loop over all ai in newsquad
				(if (> (ai_living_count (object_get_ai (list_get (ai_actors newsquad) 0))) 0) ; if the current ai in newsquad is alive
					(ai_migrate (object_get_ai (list_get (ai_actors newsquad) 0)) sq_player_followers) ; migrate to followers
				)
				(or ; exit conditions:
					(>= (ai_living_count sq_player_followers) 2)
					(= (ai_living_count newsquad) 0)
				)
			)
		1)
	)
)

;kill followers not in player_area_volume if they can be replaced by marines just rescued
(script static void (f_kill_faraway_followers (ai followers) (ai rescued_marines) (trigger_volume player_area_volume))
	(set s_current_follower_index 0)
	(set s_current_follower_killed 0)

	(sleep_until
		(begin
			(if (and (< s_current_follower_index (ai_living_count followers)) (< s_current_follower_killed (ai_living_count rescued_marines)))
				(begin
					(print "f_kill_faraway_followers")
					(if (volume_test_object player_area_volume (list_get (ai_actors sq_player_followers) s_current_follower_index))
						(set s_current_follower_index (+ s_current_follower_index 1))
						(begin
							(object_destroy (list_get (ai_actors sq_player_followers) s_current_follower_index))
							(set s_current_follower_killed (+ s_current_follower_killed 1))
						)
					)
					false
				)
				true
			)
		)
	1)
)

(script dormant player_followers_from_mission_first
	(print "player_followers active")
	(sleep_until volunteer_migrate_ready 1)
	(init_player_followers_fireteam)
)

(script static void init_player_followers_fireteam
	(ai_player_add_fireteam_squad player0 sq_player_followers)
	(ai_player_set_fireteam_max player0 2) ;needs to be set after the fireteam squad is added or else the max limit won't be accurate
)

(script dormant player_followers_cave_over_bridge_loop
	(sleep_until (= (device_group_get bridge_control_position) 1) 1)
	(print "bridge is up, starting to check for followers crossing")

	(sleep_until
		(begin
			(if (and
					(volume_test_players tv_cave_player_on_passed_bridge)
					(volume_test_objects tv_cave_followers_before_bridge (ai_actors sq_player_followers))
				)
				;then
				(begin
					(if
						(and
							(not (cs_command_script_running sq_player_followers cs_player_followers_cave_over_bridge))
							(not (unit_in_vehicle sq_player_followers))
						)
						;then
						(begin
							(print "followers crossing bridge")
							(cs_run_command_script sq_player_followers cs_player_followers_cave_over_bridge)
						)
						;else
						(print "followers already crossing, in vehicle, or are running command script")
					)
				)
			)
			(or
				(volume_test_objects tv_cave_followers_passed_bridge (ai_actors sq_player_followers)); stop loop when marines get passed the bridge trigger
				(volume_test_players followers_cave_to_connector_obj_switch2); stop loop if player is near the cave exit
			)
		)
		(game_ticks_from_seconds 1); run loop every x seconds
	)
)

(script command_script cs_player_followers_cave_over_bridge
	(cs_go_to ps_player_follower_over_bridge/p0 1)
	(cs_move_towards_point ps_player_follower_over_bridge/p3 1)
)

(global boolean volunteer_migrate_ready false)

(script dormant jeep_enter_pelican
	; spawn the warthog and attach it to the dropship
	(if (not (game_is_cooperative))
		;then spawn marine squad with warthog on cell so marines can ride while the pelican flys
		(begin
			(ai_place sq_first_marine_hog)
			(set jeep_global (ai_vehicle_get_from_spawn_point sq_first_marine_hog/gunner_spawn))
			;keep gunner from exiting early during the pelican ride
			(vehicle_set_unit_interaction (object_get_turret jeep_global 0) "warthog_g" true false)
		)
		;else
		(begin
			(object_create jeep)
			(set jeep_global jeep)
		)
	)

	(unit_enter_vehicle jeep_global foehammer_global "pelican_lc")

	;check when player gets in the warthog and let them exit the turret
	(if (not (game_is_cooperative))
		;then
		(begin
			;(sleep_until b_foehammer_first_hog_dropped 1)
			(sleep_until (not (unit_in_vehicle jeep_global)) 1)
			(print "jeep no longer in pelican")
			(sleep (game_ticks_from_seconds 2.0)) ;give time for the pelican squad and hog squad to be seperate
			(set volunteer_migrate_ready true)
			(ai_migrate sq_first_marine_hog sq_player_followers)
			;get a voluteer to join chief. check odsts first then marines
			(cond
				((> (ai_living_count sq_first_marine_odst) 0) (ai_migrate (object_get_ai (list_get (ai_actors sq_first_marine_odst) 0)) sq_player_followers))
				((> (ai_living_count sq_first_marine_marine) 0) (ai_migrate (object_get_ai (list_get (ai_actors sq_first_marine_marine) 0)) sq_player_followers))
			)

			(sleep 2)
			(wake first_marines_find_warthog)

			(sleep_until (any_players_in_vehicle) 1)
			(sleep (game_ticks_from_seconds 0.33)); wait a bit for the player to be fully in the warthog before allowing them to exit the turret
			(vehicle_set_unit_interaction (object_get_turret jeep_global 0) "warthog_g" true true)
		)
	)
)

;(script command_script cs_move_jeep
;	; in the first area we need to move gradually with the car (there are zoneset switches, i.e. the pathfinding cannot be done to the holdouts directly)
;	(if (= s_player_area_current 1)
;		(begin
;		(print "driving to point 0")
;		(cs_go_to pts_jeep_test/p0)
;		)
;	)
;
;	(if (and (= s_player_area_current 2) (= global_cave_bridge_enabled false))
;		(cs_go_to pts_jeep_test/p1)
;	)
;
;	(if (and (= s_player_area_current 2) (= global_cave_bridge_enabled true))
;		(cs_go_to pts_jeep_test/p3)
;	)
;
;	(if (>= s_player_area_current 3)
;		; don't drive if you are in an unfinished holdout
;		(if (and
;				(or (not (volume_test_players cliff_all)) global_cliff_end)
;				(or (not (volume_test_players river_all)) global_river_end)
;				(or (not (volume_test_players rubble_all)) global_rubble_end)
;			)
;			(begin
;				(if (not global_cliff_end)
;					(set s_player_distance_cliff (objects_distance_to_point player0 pts_jeep_test/p4))
;					(set s_player_distance_cliff s_distance_max)
;				)
;
;				(if (not global_river_end)
;					(set s_player_distance_river (objects_distance_to_point player0 pts_jeep_test/p5))
;					(set s_player_distance_river s_distance_max)
;				)
;
;				(if (not global_rubble_end)
;					(set s_player_distance_rubble (objects_distance_to_point player0 pts_jeep_test/p6))
;					(set s_player_distance_rubble s_distance_max)
;				)
;
;				(cond
;					((and (<= s_player_distance_cliff s_player_distance_river) (<= s_player_distance_cliff s_player_distance_rubble)) (cs_go_to pts_jeep_test/p4))
;					((<= s_player_distance_river s_player_distance_rubble) (cs_go_to pts_jeep_test/p5))
;					(true  (cs_go_to pts_jeep_test/p6))
;				)
;			)
;		)
;	)
;)

;(script command_script cs_stop_car
;	; command script attached to a driver of a car, executed when the player (who was not a driver) jumps out of the car
;	(sleep 1)
;)

;update the current warthog used
;(script dormant update_current_warthog
;	(sleep_until
;		(begin
;			(sleep_until (and (unit_in_vehicle_type player0 s_vehicle_type_warthog)
;			                  (!= jeep_global (unit_get_vehicle player0)))
;			1)
;			(set jeep_global (unit_get_vehicle player0))
;
;			false
;		)
;	1)
;)

;(script dormant update_followers_following_state
;	(sleep_until
;		(begin
;			(sleep_until (and (player_in_vehicle jeep_global) (!= (vehicle_driver jeep_global) player0) (!= (vehicle_driver jeep_global) none)) 1)
;			(set global_follow_player_on_foot false)
;
;			(sleep_until (not (player_in_vehicle jeep_global)) 1)
;			(set global_follow_player_on_foot true)
;
;			false
;		)
;	15)
;)

(script static boolean (f_check_followers_in_warthog)
	(set b_all_followers_in_warthog true)
	(set s_warthog_followers_index 0)

	(sleep_until
		(begin
			(if (not (vehicle_test_seat_unit jeep_global "" (unit (list_get (ai_actors sq_player_followers) s_warthog_followers_index))))
				(set b_all_followers_in_warthog false)
			)
			(set s_warthog_followers_index (+ s_warthog_followers_index 1))
			(or (>= s_warthog_followers_index (ai_living_count sq_player_followers)) (not b_all_followers_in_warthog))
		)
	1)

	b_all_followers_in_warthog
)

;(script dormant update_followers_driving_logic
;	(sleep_until
;		(begin
;			(sleep_until (and (player_in_vehicle jeep_global) (!= (vehicle_driver jeep_global) player0) (!= (vehicle_driver jeep_global) none)) 1)
;			(print "npc driving should begin here.")
;			;(sleep_until (or (<= (ai_living_count sq_player_followers) 1) (f_check_followers_in_warthog)) 1 (* 30 s_wait_for_other_follower_time))
;			(cs_run_command_script (object_get_ai (vehicle_driver jeep_global)) cs_move_jeep)
;
;			(sleep_until (not (player_in_vehicle jeep_global)) 1)
;			(cs_run_command_script (object_get_ai (vehicle_driver jeep_global)) cs_stop_car)
;
;			false
;		)
;	1)
;)

;(script dormant followers_driving_logic
;	(wake update_current_warthog)
;	(wake update_followers_following_state)
;	(wake update_followers_driving_logic)
;)
;====================================================================================================================================================
;=========== holdout teleporting and lod ============================================================================================================
;=========== teleport players in co-op between encounter to ensure only 1 active holdout at a time. =================================================
;=========== forces lod on the holdout with the player present ======================================================================================
;====================================================================================================================================================

;once the player begins a holdout we want to ensure that players can only be in 1 holdout at a time.
(script dormant holdout_teleporting_loop
	(print "holdout teleporting loop active")

	;wait for the players to begin a holdout encounter
	(sleep_until
		(or
			(f_player_in_cliff_teleport_volumes)
			(f_player_in_river_teleport_volumes)
			(f_player_in_rubble_teleport_volumes)
		)
		1
	)

	;initial teleport when first player hits a holdout approach
	(cond
		((f_player_in_cliff_teleport_volumes) 		(f_teleport_to_cliff_approach))
		((f_player_in_river_teleport_volumes) 		(f_teleport_to_river_approach))
		((f_player_in_rubble_teleport_volumes) 		(f_teleport_to_rubble_approach))
	)

	;begin looping, pulling players to the approach of the next holdout to stop multiple holdouts at the same time but allow them to progress if the player returns.
	(sleep_until
		(begin
			(cond
				((volume_test_players cliff_all)	(f_holdout_coop_tp_out_cliff))
				((volume_test_players river_all)	(f_holdout_coop_tp_out_river))
				((volume_test_players rubble_all)	(f_holdout_coop_tp_out_rubble))
			)
		(f_on_last_holdout))
	1)
)

(script static void f_holdout_coop_tp_out_cliff
	(print "f_holdout_coop_tp_out_cliff started")
	; if we've started cliff but haven't finished it yet...
	(if (and global_cliff_start	(not global_cliff_end))
		(begin
			;wait for the player to approach another holdout
			(sleep_until (or (f_player_in_river_teleport_volumes) (f_player_in_rubble_teleport_volumes)) 1)

			(cond
				((f_player_in_river_teleport_volumes)  (f_teleport_to_river_approach))
				((f_player_in_rubble_teleport_volumes) (f_teleport_to_rubble_approach))
			)
		)
	)
	(print "f_holdout_coop_tp_out_cliff ended")
)

(script static void f_holdout_coop_tp_out_river
	(print "f_holdout_coop_tp_out_river started")
	; if we've started river but haven't finished it yet...
	(if (and global_river_start	(not global_river_end))
		(begin
			;wait for the player to approach another holdout
			(sleep_until (or (f_player_in_cliff_teleport_volumes) (f_player_in_rubble_teleport_volumes)) 1)

			(cond
				((f_player_in_cliff_teleport_volumes)  (f_teleport_to_cliff_approach))
				((f_player_in_rubble_teleport_volumes) (f_teleport_to_rubble_approach))
			)
		)
	)
	(print "f_holdout_coop_tp_out_river ended")
)

(script static void f_holdout_coop_tp_out_rubble
	(print "f_holdout_coop_tp_out_rubble started")
	; if we've started rubble but haven't finished it yet...
	(if (and global_rubble_start (not global_rubble_end))
		(begin
			;wait for the player to approach another holdout
			(sleep_until (or (f_player_in_cliff_teleport_volumes) (f_player_in_river_teleport_volumes)) 1)

			(cond
				((f_player_in_cliff_teleport_volumes)  (f_teleport_to_cliff_approach))
				((f_player_in_river_teleport_volumes) (f_teleport_to_river_approach))
			)
		)
	)
	(print "f_holdout_coop_tp_out_rubble ended")
)

;teleport all player not near the lead player to the appropriate volume
(script static void f_teleport_to_cliff_approach
	(cond
		((volume_test_players cliff_tp_approach_left) (volume_teleport_players_not_inside cliff_tp_check fl_tp_coop_cliff_approach_l))
		((volume_test_players cliff_tp_approach_right) (volume_teleport_players_not_inside cliff_tp_check fl_tp_coop_cliff_approach_r))
	)

	(ai_force_full_lod enc_holdout_cliffside_cov)
	(ai_force_full_lod enc_holdout_cliffside_marine)

	(ai_clear_lod enc_holdout_rubble_cov)
	(ai_clear_lod enc_holdout_rubble_marine)

	(ai_clear_lod sq_gr_river_wave)
	(ai_clear_lod sq_gr_river_marine)
)

;teleport all player not near the lead player to the appropriate volume
(script static void f_teleport_to_river_approach
	(cond
		((volume_test_players river_tp_entrance_left) (volume_teleport_players_not_inside river_tp_check fl_tp_coop_river_approach_l))
		((volume_test_players river_tp_entrance_right) (volume_teleport_players_not_inside river_tp_check fl_tp_coop_river_approach_r))
	)

	(ai_force_full_lod sq_gr_river_wave)
	(ai_force_full_lod sq_gr_river_marine)

	(ai_clear_lod enc_holdout_rubble_cov)
	(ai_clear_lod enc_holdout_rubble_marine)

	(ai_clear_lod enc_holdout_cliffside_cov)
	(ai_clear_lod enc_holdout_cliffside_marine)
)

;teleport all player not near the lead player to the appropriate volume
(script static void f_teleport_to_rubble_approach
	(cond
		((volume_test_players rubble_tp_entrance_left) (volume_teleport_players_not_inside rubble_tp_check fl_tp_coop_rubble_approach_l))
		((volume_test_players rubble_tp_entrance_right) (volume_teleport_players_not_inside rubble_tp_check fl_tp_coop_rubble_approach_r))
	)

	(ai_force_full_lod enc_holdout_rubble_cov)
	(ai_force_full_lod enc_holdout_rubble_marine)

	(ai_clear_lod enc_holdout_cliffside_cov)
	(ai_clear_lod enc_holdout_cliffside_marine)

	(ai_clear_lod sq_gr_river_wave)
	(ai_clear_lod sq_gr_river_marine)
)

(script static boolean f_player_in_cliff_teleport_volumes
	(or
		(volume_test_players cliff_tp_entrance_left)
		(volume_test_players cliff_tp_entrance_right)
	)
)

(script static boolean f_player_in_river_teleport_volumes
	(or
		(volume_test_players river_tp_entrance_left)
		(volume_test_players river_tp_entrance_right)
	)
)

(script static boolean f_player_in_rubble_teleport_volumes
	(or
		(volume_test_players rubble_tp_entrance_left)
		(volume_test_players rubble_tp_entrance_right)
	)
)

;returns true if 2 holdouts have been completed indicating we are on our last holdout.
(script static boolean f_on_last_holdout
	(or
		(and global_river_end global_cliff_end)
		(and global_cliff_end global_rubble_end)
		(and global_rubble_end global_river_end)
	)
)

;=============================================
;=========== chapter titles ==================
;=============================================

(script dormant chapter_a30_1
	(print_if debug "chapter title 1 - flawless cowboy")
	(f_hud_chapter "arrival")
)

(script dormant chapter_a30_2
	(print_if debug "chapter title 2 - reunion tour")
	(f_hud_chapter "reunion")
)

;=========== breadcrumbs navpoints ===========

(global short s_navpoint_index 0)

(global cutscene_flag last_blip_flag fl_crash_site_bridge)
(global cutscene_flag second_last_blip_flag fl_crash_site_bridge)
(global cutscene_flag third_last_blip_flag fl_crash_site_bridge)
(global boolean b_nav_active false)
(global trigger_volume last_tv_nav lz_higher_ground)
(global trigger_volume last_backtrack_tv_nav lz_higher_ground)

(global short s_nav_point_delay (game_ticks_from_seconds 1))

(global boolean b_nav_backtrack_timer_needed false)
(global boolean b_nav_backtrack_timer_running false)
(global boolean b_nav_backtrack_timer_complete false)
(global boolean b_nav_backtrack_timer_used false)
(global short s_nav_backtrack_timer_delay (game_ticks_from_seconds 30))

(script static void beat1_nav_control
	(cond
		;(check)

		; -------------------landging zone---------------												(results)
		;cond - nav to bridge
		((f_nav_tv_check fl_crash_site_bridge tv_nav_lz)												(f_blip_one_with_tv fl_crash_site_bridge tv_nav_lz))
		;cond - nav to ledge
		((f_nav_tv_check fl_crash_site_ridge tv_nav_lz_bridge)											(f_blip_one_with_tv fl_crash_site_ridge tv_nav_lz_bridge))
		;cond - nav to ridge
		((f_nav_tv_check fl_crash_site_ridge tv_nav_lz_ledge)											(f_blip_one_with_tv fl_crash_site_ridge tv_nav_lz_ledge))
		((f_navend_fl_tv_check fl_crash_site_ridge tv_nav_lz_valley)									(f_unblip_with_tv fl_crash_site_ridge tv_nav_lz_valley))
		;cond - nav to marines
		((f_nav_bool_tv_check fl_first_marines global_first_marines_nav tv_nav_lz_valley)				(f_blip_one_with_tv fl_first_marines tv_nav_lz_valley))
		((f_navend_fl_tv_check fl_first_marines  tv_nav_first_arena) 									(f_unblip_with_tv fl_first_marines tv_nav_first_arena))

		; --------------------first marine----------------
		;cond - nav to ridge above cavern
		((f_nav_bool_tv_check fl_first_ridge mark_searchstart tv_nav_first_arena)						(f_blip_one_with_tv fl_first_ridge tv_nav_first_arena))

		;cond - nav to cavern
		((f_nav_tv_check fl_cave_entrance tv_nav_first_descent)											(f_blip_one_with_tv fl_cave_entrance tv_nav_first_descent))
		((f_nav_tv_check fl_cave_entrance tv_nav_first_lower)											(f_blip_one_with_tv fl_cave_entrance tv_nav_first_lower))
		;cond - nav to cavern combat
		((f_nav_tv_check fl_cave_arena tv_nav_cavern_entry) 											(f_blip_one_with_tv fl_cave_arena tv_nav_cavern_entry))
		((f_navend_fl_tv_check fl_cave_arena tv_nav_cavern_arena) 										(f_unblip_with_tv fl_cave_arena tv_nav_cavern_arena))

		; ----------------------cavern-------------------
		;cond - nav to bridge
		((f_nav_bool_tv_check fl_cave_bridge global_cave_bridge_enabled tv_nav_cavern_arena)			(f_blip_one_with_tv fl_cave_bridge tv_nav_first_arena))
		;cond - nav out of cavern
		((f_nav_tv_check fl_cave_exit tv_nav_cavern_bridge)												(f_blip_one_with_tv fl_cave_exit tv_nav_cavern_bridge))
		((f_nav_tv_check fl_fields_entrance tv_nav_cavern_exit) 										(f_blip_one_with_tv fl_fields_entrance tv_nav_cavern_exit))
		((f_navend_fl_tv_check fl_fields_entrance tv_nav_fields_enter) 									(f_unblip_with_tv fl_fields_entrance tv_nav_fields_enter))

	)
)

(script dormant beat1_nav_loop
	;loop while b_bridge_cinematic_played is false
	(sleep_until
		(begin
			(beat1_nav_control)
			false
		)
		1;run every 1 tick
	)
	(print "breadcrumbs: beat1_nav_loop over")
)

(script static void quarry_nav_control
	(cond
		;(check)

		; -------------------entry---------------																	(results)
		;cond - enter 1
		((f_nav_bool_tv_check fl_rubble_exit_left (not global_rubble_exit) rubble_1)								(f_blip_one_with_tv fl_rubble_exit_left rubble_1))
		;cond - enter 2
		((f_nav_bool_tv_check fl_rubble_exit_right (not global_rubble_exit) rubble_2)								(f_blip_one_with_tv fl_rubble_exit_right rubble_2))
		;cond - find marines
		((f_nav_bool_tv_check fl_quarry_marines (not (or global_rubble_exit global_rubble_contact)) rubble_arrival)	(f_blip_one_with_tv fl_quarry_marines rubble_arrival))
		((f_navend_bool_tv_check fl_quarry_marines (not global_rubble_exit) rubble_jackal)							(f_unblip_with_tv fl_quarry_marines rubble_jackal))

		; ---------------battle over--------------
		;cond - show one exit
		((f_nav_bool_tv_check fl_rubble_exit_right global_rubble_exit rubble_arrival)								(f_blip_one_with_tv fl_rubble_exit_right rubble_arrival))
		;cond - exit 1
		((f_nav_bool_tv_check  fl_quarry_field_entrance global_rubble_exit rubble_1)								(f_blip_one_with_tv fl_quarry_field_entrance rubble_1))
		;cond - exit 2
		((f_nav_bool_tv_check  fl_quarry_waterfall_entrance global_rubble_exit rubble_2)							(f_blip_one_with_tv fl_quarry_waterfall_entrance rubble_2))
	)
)

(script static void river_nav_control
	(cond
		;(check)

		; -------------------entry---------------																	(results)
		;cond - enter left
		((f_nav_bool_tv_check fl_river_exit_right (not global_river_exit) river_1)									(f_blip_one_with_tv fl_river_exit_right river_1))
		;cond - enter right
		((f_nav_bool_tv_check fl_river_exit_left (not global_river_exit) river_2)									(f_blip_one_with_tv fl_river_exit_left river_2))
		;cond - find marines
		((f_nav_bool_tv_check fl_river_marines (not (or global_river_exit  global_river_contact)) river_arrival)	(f_blip_one_with_tv fl_river_marines river_arrival))
		((f_navend_bool_tv_check fl_river_marines  (not global_river_exit) river_retreat)							(f_unblip_with_tv fl_river_marines river_retreat))

		; ---------------battle over--------------
		;cond - show one exit
		((f_nav_bool_tv_check fl_river_exit_left global_river_exit river_arrival)									(f_blip_one_with_tv fl_river_exit_left river_arrival))
		;cond - exit left
		((f_nav_bool_tv_check fl_river_field_entrance global_river_exit river_1)									(f_blip_one_with_tv fl_river_field_entrance river_1))
		;cond - exit right
		((f_nav_bool_tv_check fl_river_waterfall_entrance global_river_exit river_2)								(f_blip_one_with_tv fl_river_waterfall_entrance river_2))
	)
)

(script static void cliff_nav_control
	(cond
		;(check)

		; -------------------entry---------------																	(results)
		;cond - enter left
		((f_nav_bool_tv_check fl_cliff_exit_right (not global_cliff_exit) cliff_1)									(f_blip_one_with_tv fl_cliff_exit_right cliff_1))
		;cond - enter right
		((f_nav_bool_tv_check fl_cliff_exit_left (not global_cliff_exit) cliff_2)									(f_blip_one_with_tv fl_cliff_exit_left cliff_2))
		;cond - find marines
		((f_navend_bool_tv_check last_blip_flag  (not global_cliff_exit) cliff_arrival)								(f_unblip_with_tv last_blip_flag cliff_arrival))

		; ---------------battle over--------------
		;cond - show one exit
		((f_nav_bool_tv_check fl_cliff_exit_left global_cliff_exit cliff_arrival)									(f_blip_one_with_tv fl_cliff_exit_left cliff_arrival))
		;cond - exit left
		((f_nav_bool_tv_check fl_cliff_vista_entrance global_cliff_exit cliff_1)									(f_blip_one_with_tv fl_cliff_vista_entrance cliff_1))
		;cond - exit right
		((f_nav_bool_tv_check fl_cliff_riverbed_entrance global_cliff_exit cliff_2)									(f_blip_one_with_tv fl_cliff_riverbed_entrance cliff_2))
	)
)

(script dormant fields_nav_loop
	(sleep_until
		(begin
			;sleep until player enters a holdout
			(sleep_until
				(or
					(f_nav_holdout_enter_check global_rubble_end rubble_all)
					(f_nav_holdout_enter_check global_river_end river_all)
					(f_nav_holdout_enter_check global_cliff_end cliff_all)
				)
			1)

			;cleanup nav system
			(f_unblip_flag last_blip_flag)
			(set b_nav_active false)

			(f_navpoint_unblip_all)
			(sleep (game_ticks_from_seconds 0.17))

			;condition based on holdout- loops while in holdout
			(cond
				((f_nav_holdout_enter_check global_rubble_end rubble_all)
					(begin
						(sleep_until
							(begin
								(quarry_nav_control)
								(f_nav_holdout_exit_check global_rubble_end rubble_all)
							)
							1;run every 1 tick
						)
					)
				)
				((f_nav_holdout_enter_check global_river_end river_all)
					(begin
						(sleep_until
							(begin
								(river_nav_control)
								(f_nav_holdout_exit_check global_river_end river_all)
							)
							1;run every 1 tick
						)
					)
				)
				((f_nav_holdout_enter_check global_cliff_end cliff_all)
					(begin
						(sleep_until
							(begin
								(cliff_nav_control)
								(f_nav_holdout_exit_check global_cliff_end cliff_all)
							)
							1;run every 1 tick
						)
					)
				)
			)

			;cleanup nav system
			(f_unblip_flag last_blip_flag)
			(set b_nav_active false)

			;cleanup fields nav points
			(f_navpoint_unblip_all)

			;flags the incomplete holdouts
			(if (not global_rubble_end)
				(begin
					(f_blip_flag fl_quarry_field_entrance 0)
					;(f_blip_flag fl_quarry_waterfall_entrance 0)
				)
			)
			(if (not global_river_end)
				(begin
					(f_blip_flag fl_river_field_entrance 0)
					;(f_blip_flag fl_river_waterfall_entrance 0)
				)
			)
			(if (not global_cliff_end)
				(begin
					;(f_blip_flag fl_cliff_riverbed_entrance 0)
					(f_blip_flag fl_cliff_vista_entrance 0)
				)
			)
			false ;exit condition
		)
		(game_ticks_from_seconds 1) ;run every 1 seconds
	)
)

(script static boolean (f_nav_holdout_enter_check (boolean b_complete) (trigger_volume tv_area))
	;determines if we should enter a holdout nav loop relative to if the player has completed that nav loop
	(or
		(and ;if the holdout is done, we only nav point it if all players are in there
			(volume_test_players_all tv_area)
			b_complete
		)
		(and ;if the holdout is not done, we nav point it when a player enters the area
			(volume_test_players tv_area)
			(not b_complete)
		)
	)
)

(script static boolean (f_nav_holdout_exit_check (boolean b_complete) (trigger_volume tv_area))
	;determines if we should exit a holdout nav loop relative to if the player has completed that nav loop
	(or
		(and ;if the holdout is done, any player leaving will call out the other holdouts
			(not (volume_test_players_all tv_area))
			b_complete
		)
		(and ;if the holdout is not done, all players have to leave to stop pointing towards this holdout
			(not (volume_test_players tv_area))
			(not b_complete)
		)
	)
)

;nav control conditions checks
(script static boolean (f_nav_ai_tv_check (cutscene_flag f) (ai encounter_squad )(trigger_volume tv_nav))
	(f_nav_backtrack_need_check f tv_nav)

	;this boolean will be returned
	(and
		(f_nav_should_be_blipped_check f)
		(<= (ai_nonswarm_count encounter_squad) 0)
		(volume_test_players tv_nav)
	)
)

;nav control conditions checks
(script static boolean (f_nav_bool_tv_check (cutscene_flag f) (boolean bool )(trigger_volume tv_nav))
	(f_nav_backtrack_need_check f tv_nav)

	;this boolean will be returned
	(and
		(f_nav_should_be_blipped_check f)
		bool
		(volume_test_players tv_nav)
	)
)


(script static boolean (f_nav_tv_check (cutscene_flag f) (trigger_volume tv_nav))
	(f_nav_backtrack_need_check f tv_nav)

	;this boolean will be returned
	(and
		(f_nav_should_be_blipped_check f)
		(volume_test_players tv_nav)
	)
)

(script static boolean (f_bool_tv_check (boolean bool )(trigger_volume tv_nav))

	;this boolean will be returned
	(and
		bool
		(volume_test_players tv_nav)
	)
)

(script static boolean (f_navend_tv_check (trigger_volume tv_navend))
	(volume_test_players tv_navend)
)

(script static boolean (f_navend_fl_tv_check (cutscene_flag f) (trigger_volume tv_navend))
	(and
		(= last_blip_flag f)
		(= b_nav_active 1)
		(volume_test_players tv_navend)
	)
)

(script static boolean (f_navend_bool_tv_check (cutscene_flag f) (boolean bool )(trigger_volume tv_nav))

	;this boolean will be returned
	(and
		(= last_blip_flag f)
		(= b_nav_active 1)
		bool
		(volume_test_players tv_nav)
	)
)

;nav condition static scripts
(script static void (f_nav_backtrack_need_check (cutscene_flag f) (trigger_volume tv_nav))
	(if
		(and
			(= b_nav_backtrack_timer_running false)
			(or
				(and
					(= b_nav_active 1)
					(= second_last_blip_flag f)
				)
				(and
					(= b_nav_active 0)
					(= last_blip_flag f)
				)
			)
			(volume_test_players tv_nav)
		)
		(set b_nav_backtrack_timer_needed true)
	)
)

(script static boolean (f_nav_should_be_blipped_check (cutscene_flag f))
	(or
		;is f different than the last flag blipped and is there no active flag?
		(and
			(= b_nav_active 0)
			(!= last_blip_flag f)
		)
		;is f different than the last and second to last flag blipped?
		(and
			(!= last_blip_flag f)
			(!= second_last_blip_flag f)
		)
		(and
			(= b_nav_active 1)
			(!= second_last_blip_flag f)
			(= third_last_blip_flag f)
		)
		;has the backtrack timer completed?
		(= b_nav_backtrack_timer_complete 1)
	)
)

;nav control results
(script static void (f_blip_one_with_tv (cutscene_flag f) (trigger_volume tv_nav))
	(if (= b_nav_backtrack_timer_complete 1) (set b_nav_backtrack_timer_used true))
	(f_unblip_flag last_blip_flag)
	(sleep s_nav_point_delay)
	(f_blip_flag f 0)
	(set b_nav_active true)
	;want third to last & second to last flags to be unique
	(if
		(!= third_last_blip_flag second_last_blip_flag)
		;then
		(set third_last_blip_flag second_last_blip_flag)
		;else
		(print "third and second flags matched. did not update third flag")
	)
	;want second to last & last flags to be unique
	(if
		(!= second_last_blip_flag last_blip_flag)
		;then
		(set second_last_blip_flag last_blip_flag)
		;else
		(print "second and last flags matched. did not update second flag")
	)
	(set last_blip_flag f)
	(print "blipping flag")
	(set last_tv_nav tv_nav)
)

(script static void (f_unblip_with_tv (cutscene_flag f) (trigger_volume tv_navend))
	(print "unblipping flag")

	(set last_tv_nav tv_navend)
	(f_unblip_flag f)
	(set b_nav_active false)
)

;nav loops
(script dormant nav_backtracking_loop
	;loop while b_space_started is false
	(sleep_until
		(begin
			(print "backtracking timer waiting til needed")
			(sleep_until (= b_nav_backtrack_timer_needed 1) 1)

			(set last_backtrack_tv_nav last_tv_nav)
			(if (volume_test_players last_tv_nav) (print "backtracking timer player in last_tv_nav"))
			(sleep_until (= (volume_test_players last_tv_nav) 0) 1)

			(sleep (game_ticks_from_seconds 2)) ;wait a bit for the nav loop to go through again

			(if (!= last_backtrack_tv_nav last_tv_nav)
				;then
				(begin
					(print "backtracking timer player moved on")
					(set b_nav_backtrack_timer_needed false)
				)
				;else
				(begin
					(print "backtracking timer started")
					(set b_nav_backtrack_timer_running true)

					(sleep s_nav_backtrack_timer_delay)

					(if (= b_nav_backtrack_timer_used 0)
						;then
						(begin
							(print "backtracking timer completed")
							(set b_nav_backtrack_timer_complete true)

							;sleep until nav point is blipped
							(sleep_until b_nav_backtrack_timer_used 1)

							;reset variables
							(print "backtracking timer used - variables reset")
							(set b_nav_backtrack_timer_needed false)
							(set b_nav_backtrack_timer_running false)
							(set b_nav_backtrack_timer_complete false)
							(set b_nav_backtrack_timer_used false)
						)
						;else
						(begin
							(print "backtracking timer - nav recently blipped")
							(set b_nav_backtrack_timer_needed false)
							(set b_nav_backtrack_timer_running false)
						)
					)
				)
			)
			false ;exit condition
		)
		(game_ticks_from_seconds 1) ;run every 1 seconds
	)
	(print "breadcrumbs: beat1_nav_loop over")
)

;*(script dormant navpoints_a30
	; crash site bridge - temporary
	(sleep_until (> s_navpoint_index 0) 1)
	(if (= s_navpoint_index 1)
		(begin
			(f_blip_flag fl_crash_site_bridge 0)
			(sleep_until (or (< (objects_distance_to_flag (players) fl_crash_site_bridge) 3)(volume_test_players lz_higher_ground)) 1)
			(f_unblip_flag fl_crash_site_bridge)
		)
	)

	; crash site ridge
	(sleep_until (> s_navpoint_index 1) 1)
	(if (= s_navpoint_index 2)
		(begin
			(f_blip_flag fl_crash_site_ridge 0)
			(sleep_until (< (objects_distance_to_flag (players) fl_crash_site_ridge) 3) 1)
			(f_unblip_flag fl_crash_site_ridge)
		)
	)

	; forerunner cave entrance
	(sleep_until (> s_navpoint_index 2) 1)
	(if (= s_navpoint_index 3)
		(begin
			(f_blip_flag fl_cave_entrance 0)
			(sleep_until (< (objects_distance_to_flag (players) fl_cave_entrance) 4) 1)
			(f_unblip_flag fl_cave_entrance)
		)
	)

	; forerunner bridge controls - can be skipped
	(sleep_until (> s_navpoint_index 3) 1)
	(if (= s_navpoint_index 4)
		(begin
			(f_blip_object bridge_control 0)
			(sleep_until (= (device_group_get bridge_control_position) 1) 1)
			(f_unblip_object bridge_control)
		)
	)

	; reunion tour begins - quarry/cliff/river entrances
	(sleep_until (> s_navpoint_index 4) 1)
	(if (= s_navpoint_index 5)
		(begin
			(f_blip_flag fl_quarry_field_entrance 0)
			(sleep_until (= s_navpoint_index 6) 1)
			(f_blip_flag fl_cliff_vista_entrance 0)
			(sleep_until (= s_navpoint_index 7) 1)
			(f_blip_flag fl_river_field_entrance 0)
		)
	)

	; unblip all when 1st holdout begins
	(sleep_until (or global_cliff_start global_rubble_start global_river_start) 15)
	(f_navpoint_unblip_all)

	; remaining 2 holdouts
	(sleep_until (> s_navpoint_index 7) 1)
	(if (= s_navpoint_index 8)
			; blip remaining 2 depending on player location
		(cond
			; finished cliff
			(global_cliff_exit (begin
								(f_blip_flag fl_quarry_field_entrance 0)
								(f_blip_flag fl_river_field_entrance 0)))

			; finished river
			(global_river_exit (begin
								(f_blip_flag fl_cliff_riverbed_entrance 0)
								(f_blip_flag fl_quarry_field_entrance 0)
								(f_blip_flag fl_cliff_riverbed_entrance 0)
								(f_blip_flag fl_quarry_waterfall_entrance 0)))

			;finished rubble
			(global_rubble_exit (begin
								(f_blip_flag fl_cliff_vista_entrance 0)
								(f_blip_flag fl_river_field_entrance 0)
								(f_blip_flag fl_cliff_riverbed_entrance 0)
								(f_blip_flag fl_river_waterfall_entrance 0)))

		)
	)

	; unblip all when 2nd holdout begins
	(sleep_until
		(or
			(and global_cliff_exit (or global_river_start global_rubble_start))
			(and global_river_exit (or global_cliff_start global_rubble_start))
			(and global_rubble_exit (or global_cliff_start global_river_start))
		)
	1)
	(f_navpoint_unblip_all)

	; last holdout left
	(sleep_until (> s_navpoint_index 8) 1)
	(cond
		; cliff remaining
		((not global_cliff_exit) (begin
									(f_blip_flag fl_cliff_riverbed_entrance 0)
									(f_blip_flag fl_cliff_riverbed_entrance 0)
									(f_blip_flag fl_cliff_riverbed_entrance 0)
									(f_blip_flag fl_cliff_vista_entrance 0)))

		; river remaining
		((not global_river_exit) (begin
									(f_blip_flag fl_river_waterfall_entrance 0)
									(f_blip_flag fl_river_field_entrance 0)
									(f_blip_flag fl_river_field_entrance 0)
									(f_blip_flag fl_river_field_entrance 0)))

		; rubble remaining
		((not global_rubble_exit) (begin
									(f_blip_flag fl_quarry_waterfall_entrance 0)
									(f_blip_flag fl_quarry_field_entrance 0)
									(f_blip_flag fl_quarry_field_entrance 0)
									(f_blip_flag fl_quarry_field_entrance 0)))
	)

	; unblip all when final holdout begins
	(sleep_until
		(or
			(and global_rubble_exit global_river_exit global_cliff_start (not global_cliff_exit))
			(and global_rubble_exit global_cliff_exit global_river_start (not global_river_exit))
			(and global_river_exit global_cliff_exit global_rubble_start (not global_rubble_exit))
		)
	1)
	(f_navpoint_unblip_all)

	; extraction navpoint on pelican handled cs script
)

(script dormant navpoint_cliff_exit

	(f_blip_flag fl_cliff_exit_left 0)
	(f_blip_flag fl_cliff_exit_right 0)
	(sleep_until (not (volume_test_players cliff_all))1)
	(set global_cliff_exit true)
	(f_unblip_flag fl_cliff_exit_left)
	(f_unblip_flag fl_cliff_exit_right)
)

(script dormant navpoint_rubble_exit

	(f_blip_flag fl_rubble_exit_left 0)
	(f_blip_flag fl_rubble_exit_right 0)
	(sleep_until (not (volume_test_players rubble_all) )1)
	(set global_rubble_exit true)
	(f_unblip_flag fl_rubble_exit_left)
	(f_unblip_flag fl_rubble_exit_right)
)

(script dormant navpoint_river_exit

	(f_blip_flag fl_river_exit_left 0)
	(f_blip_flag fl_river_exit_right 0)
	(sleep_until (not (volume_test_players river_all)) 1)
	(set global_river_exit true)
	(f_unblip_flag fl_river_exit_left)
	(f_unblip_flag fl_river_exit_right)

)

(script static void (f_navpoint_holdout (trigger_volume volume) (cutscene_flag flag))
	(sleep_until (volume_test_players volume) 1)
	(f_blip_flag flag 0)
)



(script dormant first_marines_navpoints
	(f_blip_flag fl_first_marines 0)
	(sleep_until (not (volume_test_players first_arrival)) 1)
	;(sleep_until (< (objects_distance_to_flag (players) fl_first_marines) 10) 1)
	(f_unblip_flag fl_first_marines)
)
*;

(script static void f_navpoint_unblip_all
	(f_unblip_flag fl_quarry_field_entrance)
	(f_unblip_flag fl_quarry_waterfall_entrance)
	(f_unblip_flag fl_cliff_vista_entrance)
	(f_unblip_flag fl_cliff_riverbed_entrance)
	(f_unblip_flag fl_river_field_entrance)
	(f_unblip_flag fl_river_waterfall_entrance)
)

(script dormant mark_holdouts
	(sleep_until (= s_callout 1) 1)
	(f_blip_flag fl_quarry_field_entrance 0)

	(sleep_until (= s_callout 2) 1)
	(f_blip_flag fl_cliff_vista_entrance 0)

	(sleep_until (= s_callout 3) 1)
	(f_blip_flag fl_river_field_entrance 0)
	(set mark_search true)
)

(script dormant callout_controls
	(sleep_until global_cave_control_hint 1)

	(f_blip_object bridge_control 0)
	(sleep_until (= (device_group_get bridge_control_position) 1) 1)
	(f_unblip_object bridge_control)
)

(script dormant cliff_undertower_entrance_navpoints
	(f_blip_flag fl_cliff_undertower_entrance_1 0)
	(f_blip_flag fl_cliff_undertower_entrance_2 0)
	(sleep_until ( or (volume_test_players cliff_left_fort_first_floor) (volume_test_players cliff_right_fort_first_floor)) 1)
	(f_blip_flag fl_cliff_marines 0)
	(f_unblip_flag fl_cliff_undertower_entrance_1)
	(f_unblip_flag fl_cliff_undertower_entrance_2)
	(sleep_until (volume_test_players cliff_inside_left_bottom) 1)
	(f_unblip_flag fl_cliff_marines)
)

(script dormant handle_first_jeep_navpoint
	(f_blip_object jeep_global 0)
	(sleep_until (or (= (volume_test_players first_structure_1) false)
					 (player_in_vehicle jeep_global))
	1)
	(f_unblip_object jeep_global)
	(set mark_searchstart true)
)

(script dormant handle_holdouts_jeep_navpoint
	(f_handle_navpoint_warthog jeep4 holdouts_arrival false)
)

(script dormant handle_river_jeep_navpoint
	(f_handle_navpoint_warthog jeep5 river_all false)
)

(script dormant handle_cliff_jeep_navpoint
	(f_handle_navpoint_warthog jeep2 cliff_all false)
)

(script dormant handle_rubble_jeep_navpoint
	(f_handle_navpoint_warthog jeep3 rubble_all false)
)

(script static void (f_handle_navpoint_warthog (vehicle warthog) (trigger_volume volume_stop_navpoint) (boolean player_condition_volume))
	(f_blip_object warthog 0)
	(sleep_until (or (= (volume_test_players volume_stop_navpoint) player_condition_volume)
					 (player_in_vehicle warthog))
	1)
	(f_unblip_object warthog)
)

;====== ai nav blips ================================

(script static void (f_blip_allied_squad (ai allied_squad))
	(f_blip_ai allied_squad 2)
)

(script static void (f_blip_enemy_squad (ai enemy_squad))
	(f_blip_ai enemy_squad 1)
)

;*(script dormant mission_first_nav
	;waits until the player can see the marines
	(sleep_until (not (volume_test_players first_arrival)) 1 (game_ticks_from_seconds 3))

	;loop and update encounter nav markers as needed.
	(sleep_until
		(begin
			(cond
				((> (objects_distance_to_flag (players) fl_first_marines) 30)(begin (f_unblip_ai sq_gr_first_starters) (f_blip_mission_first_encounter)))
				((and (> (ai_living_count sq_gr_first_starters) 0) (<= (objects_distance_to_flag (players) fl_first_marines) 33) (and global_first_wave_6 (<= (ai_living_count sq_gr_holdout0_waves) 5)))(f_blip_mission_first_cov))
				((and (> (ai_living_count sq_gr_first_starters) 0) (<= (objects_distance_to_flag (players) fl_first_marines) 33) (not (and global_first_wave_6 (<= (ai_living_count sq_gr_holdout0_waves) 5))))(f_blip_mission_first_marine))
				(true (f_unblip_mission_first_encounter))
			)
			(and global_first_wave_6 (= 0 (ai_living_count sq_gr_holdout0_waves)))
		)
		3
	)

	(f_unblip_mission_first_encounter)
)
;mark the beam tower encounter area if player too far away
(script static void f_blip_mission_first_encounter
	(print_if debug "mission_first_nav | showing encounter")
	(f_blip_flag fl_first_marines 0)
	(f_unblip_ai sq_gr_first_starters)
	(f_unblip_ai sq_gr_holdout0_waves)
	(sleep (game_ticks_from_seconds 2))
)
;hide the encounter and ai if the player isn't where we want
(script static void f_unblip_mission_first_encounter
	(print_if debug "mission_first_nav | hiding encounter")
	(f_unblip_flag fl_first_marines)
	(f_unblip_ai sq_gr_first_starters)
	(f_unblip_ai sq_gr_holdout0_waves)
	(sleep (game_ticks_from_seconds 2))
)

;show the marines if they are alive
(script static void f_blip_mission_first_cov
	(print_if debug "mission_first_nav | showing covenant")
	(f_unblip_flag fl_first_marines)
	(f_unblip_ai sq_gr_first_starters)
	(f_blip_enemy_squad sq_gr_holdout0_waves)
	(sleep (game_ticks_from_seconds 2))
)

;show the covenant
(script static void f_blip_mission_first_marine
	(print_if debug "mission_first_nav | showing marine")
	(f_unblip_flag fl_first_marines)
	;(f_blip_allied_squad sq_gr_first_starters)
	(f_unblip_ai sq_gr_holdout0_waves)
	(sleep (game_ticks_from_seconds 2))
)*;

;=========================================================================================================================
; global fork section ====================================================================================================
;=========================================================================================================================

; everything below is copied from global_fork.hsc as we do not yet support additional script source files for scenarios

; == load parameters ==
; left, right, default, left_full, right_full, full
(script static void (f_load_fork (vehicle fork) (string load_side) (ai load_squad_01) (ai load_squad_02) (ai load_squad_03) (ai load_squad_04))
	(cond
		; left
		((= load_side "left")
			(begin
				(if b_debug_fork (print "load fork left..."))
				(ai_place_in_vehicle load_squad_01 fork "fork_p_l")
				(ai_place_in_vehicle load_squad_02 fork "fork_p_l")
				(ai_place_in_vehicle load_squad_03 fork "fork_p_l")
				(ai_place_in_vehicle load_squad_04 fork "fork_p_l")
			)
		)
		; right
		((= load_side "right")
			(begin
				(if b_debug_fork (print "load fork right..."))
				(ai_place_in_vehicle load_squad_01 fork "fork_p_r")
				(ai_place_in_vehicle load_squad_02 fork "fork_p_r")
				(ai_place_in_vehicle load_squad_03 fork "fork_p_r")
				(ai_place_in_vehicle load_squad_04 fork "fork_p_r")
			)
		)
		; dual
		((= load_side "dual")
			(begin
				(if b_debug_fork (print "load fork dual..."))
				(ai_place_in_vehicle load_squad_01 fork "fork_p_l")
				(ai_place_in_vehicle load_squad_02 fork "fork_p_l")
				(ai_place_in_vehicle load_squad_03 fork "fork_p_r")
				(ai_place_in_vehicle load_squad_04 fork "fork_p_r")
			)
		)

		((= load_side "any")
			(begin
				(if b_debug_fork (print "load fork any..."))
				(ai_place_in_vehicle load_squad_01 fork "fork_p")
				(ai_place_in_vehicle load_squad_02 fork "fork_p")
				(ai_place_in_vehicle load_squad_03 fork "fork_p")
				(ai_place_in_vehicle load_squad_04 fork "fork_p")
			)
		)
	)
)

; call this script when the fork is in place to drop off all the ai
(script static void (f_unload_fork (vehicle fork) (string drop_side))
	(if b_debug_fork (print "opening fork..."))
	(sleep 30)
	;(unit_open fork)
	(sleep 30)

	; determine how to unload the phantom
	(cond
		((= drop_side "left")
			(begin
				(f_unload_fork_left fork)
				(sleep 75)
			)
		)

		((= drop_side "right")
			(begin
				(f_unload_fork_right fork)
				(sleep 75)
			)
		)

		((= drop_side "dual")
			(begin
				(f_unload_fork_all fork)
				(sleep 75)
			)
		)
	)

	(if b_debug_fork (print "closing fork..."))
	(unit_close fork)
)

(script static void (f_unload_fork_left	(vehicle fork))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_l1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l8")
			(sleep (random_range 0 10))
		)
	)
)

(script static void (f_unload_fork_right (vehicle fork))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_r1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r8")
			(sleep (random_range 0 10))
		)
	)
)

(script static void (f_unload_fork_all	(vehicle fork))
	(sleep (game_ticks_from_seconds 1))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_l1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l8")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r8")
			(sleep (random_range 0 10))
		)
	)
)
(script static void (f_valid_fork_offload (vehicle fork) (ai squad))
	(sleep_until (vehicle_test_seat_unit_list fork "" (ai_actors squad)) 15)
	(sleep_until (not (vehicle_test_seat_unit_list fork "" (ai_actors squad))) 15)

)

