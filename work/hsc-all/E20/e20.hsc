(script startup e20_start
	(ai_allegiance player human)
	(ai_allegiance human player)
	(e20_insertion_point_fixups)
	(f_start_auto_save_loop)

	(f_objectives_e20)

	;(ai_player_set_fireteam_max player0 10)
	(ai_player_set_fireteam_no_max player0)

	(wake create_needed_objects)

	(wake e20_music_controller)

	(cond
		((game_is_cooperative) (fast_setup))
		((not (= normal (game_difficulty_get))) (fast_setup))
		(true (mission_setup))
	)

	(main_setup)

	(wake eye_spawner)

	; start
	(if (f_insertion_point_area_pending ins_e20_start)
		(begin
			(wake spawn_buddy_johnson)
			(wake start_level)

			(wake start_brute_bowl)
			(wake start_settlement)

			;wake hero death failsafe scripts
			(wake start_johnson_failsafe)
			(wake start_williams_failsafe)
			(wake settlement_johnson_failsafe)
			(wake settlement_williams_failsafe)

			;wake crates
			(wake create_settlement_crates)
			(wake create_jackaljungle_crates)

			;wake music scripts
			(wake e20_music_triggers_ins_0)
			(wake e20_music_triggers_settlement)

			(wake trigger_vo_level_start)
			(wake trigger_vo_settlement_start)
			(wake trigger_vo_settlement_williams1)

		)
	)

	; post-settlement
	(sleep_until (or (volume_test_players tv_settlement_end)(f_insertion_point_script_is_blocked ins_e20_settlement_end)) 1)
	(if (f_insertion_point_area_pending ins_e20_settlement_end)
		(begin
			(wake spawn_buddy_johnson)
			(wake spawn_buddy_williams)

			;(wake e20_music_triggers_ins_1)
			(wake e20_music_triggers_jackal_jungle)
			(wake e20_music_triggers_prison_bridge)

			;wake hero death failsafe scripts
			(wake bruteambush_johnson_failsafe)
			(wake bruteambush_williams_failsafe)
			(wake prisonbridge_johnson_failsafe)
			(wake prisonbridge_williams_failsafe)

			;wake crates
			(wake create_settlement_crates)
			(wake destroy_settlement_crates)
			(wake destroy_jackaljungle_crates)
			(wake create_prisonbridge_crates)
			(wake manage_prison_bridge_weapons_and_ammo)

			(wake start_brute_ambush)
			(wake start_jackal_jungle)
			(wake start_prison_bridge)
			(wake start_prison_exterior)
			(wake prison_door_open)

			(wake trigger_vo_brute_ambush_start)
			(wake trigger_vo_brute_ambush_puck)
			(wake trigger_vo_brute_ambush_fail)
			(wake trigger_vo_prison_bridge_view)
			(wake trigger_vo_prison_bridge_start)
			(wake trigger_vo_prison_entry_hacked)

			; temp script to allow buddy transition
			;(wake ambush_to_jungle_buddy_guide)

		)
	)

	; prison entry
	(sleep_until (or (volume_test_players tv_prison_room_bottom)(f_insertion_point_script_is_blocked ins_e20_prison_start)) 1)
	(if (f_insertion_point_area_pending ins_e20_prison_start)
		(begin
			(wake spawn_buddy_johnson)
			(wake spawn_buddy_williams)

			;wake crates
			(wake create_prisonbridge_crates)
			(wake destroy_prisonbridge_crates)
			(wake create_prison_crates_a)

			(wake e20_music_triggers_ins_2)

			(wake start_prison_bottom)
			(wake start_prison_top)
			(wake start_observation_top)
			(wake start_observation_bottom)
			(wake start_marine_cells_prep)

			(wake trigger_vo_prison_entry_interior)
			(wake trigger_vo_observation_start)
			(wake trigger_vo_marine_cells)

		)
	)

	; prison marine cells/armory
	(sleep_until (or (volume_test_players tv_marine_cells)(f_insertion_point_script_is_blocked ins_e20_prison_armory)) 1)
	(if (f_insertion_point_area_pending ins_e20_prison_armory)
		(begin

			(wake spawn_buddy_johnson)
			(wake spawn_buddy_williams)

			;wake crates
			(wake create_prison_crates_a)
			(wake destroy_prison_crates_a)
			(wake create_prison_crates_b)
			(wake manage_armory_weapons_and_ammo)
			(wake create_gravbridge_crates)

			(set s_music_trigger_e20 140) ; plays mus_14_observation_start
			(wake e20_music_triggers_marine_cells)

			(f_unblip_all)
			(f_blip_flag navpoint_marine_cells_console_1 0)

			;unlock door since it normally only unlocks after killing a squad that appears before this insertion point
			(device_set_power dm_covdoor_prison22 1)

			(wake start_marine_cells)
			(wake start_security_room)
			(wake start_armory)
			(wake start_large_hallway)
			(wake start_brute_cells)
			(wake start_pre_arena)
			(wake start_arena)

			(wake trigger_vo_marine_cells)
			(wake trigger_vo_security)
			(wake trigger_vo_armory)
			(wake trigger_vo_brute_cells)
			(wake trigger_vo_brute_cages)
			(wake trigger_vo_arena_start)

		)
	)

	; beat 3 - pre-bridge
	(if (f_insertion_point_area_pending ins_e20_pre_bridge)
		(begin
			;wake the encounter triggering scripts for 18-20
			(wake start_post_arena)
			(wake start_bridge_encounter)
			;wake crates
			(wake destroy_prison_crates_b)
			(wake create_gravbridge_crates)
			(wake destroy_gravbridge_crates)
			(wake create_oldarena_crates)
			;wake hero death failsafe scripts
			(wake gravbridge1_johnson_failsafe)
			(wake gravbridge1_williams_failsafe)
			(wake gravbridge2_johnson_failsafe)
			(wake gravbridge2_williams_failsafe)
			;(wake spawn_the_bridge_snipers)
			(wake start_post_bridge_making_peace)
			(wake start_old_arena_encounter)
			;wake the encounter clean up scripts for marine cells and encounters 18-20
			(wake e20_e18_cleanup)
			(wake e20_e20_cleanup)
			;wake music scripts
			(wake e20_music_triggers_ins_3)
			(wake e20_music_triggers_old_arena)
			;(wake e20_music_triggers_control_center)
			;wake any vo trigering scripts that need to occur
			(wake trigger_vo_bridge_first_gap)
			(wake trigger_vo_bridge_start)
			(wake trigger_vo_encounter_20_is_go)
			;wake the chapter title triggers
			(wake trigger_chapter_three)
			;wake buddy marine scripts
			(wake spawn_buddy_johnson)
			(wake spawn_buddy_williams)
			; temp script to allow buddy transition
			;(wake teleport_buddies_bridge)
			;(wake teleport_buddies_post_bridge)
			(wake swap_objectives_post_bridge)
			(wake teleport_coop_players_pre_bridge)
		)
	)

	; beat 3 - landing structure
	(if (f_insertion_point_area_pending ins_e20_landing_structure)
		(begin
			;wake the encounter triggering scripts for 21-24
			(wake start_landing_structure_encounter)
			;wake the encounter clean up scripts for 21-22
			(wake e20_e21_cleanup)
			(wake e20_e22_cleanup)
			;wake hero death failsafe scripts
			(wake landing_johnson_failsafe)
			(wake landing_williams_failsafe)
			;wake crates
			(wake create_oldarena_crates)
			(wake create_control_crates)
			;wake music scripts
			;(wake e20_music_triggers_control_center)
			;wake buddy marine scripts
			(wake spawn_buddy_johnson)
			(wake spawn_buddy_williams)
		)
	)

	; beat 4 - path to control room
	(if (f_insertion_point_area_pending ins_e20_path_to_control_room)
		(begin
			;wake the encounter triggering scripts for 20-22
			(wake start_settlement_encounter)
			(wake start_lodge_entrance_encounter)
			;wake the encounter clean up scripts for 20-22
			(wake e20_e20_cleanup)
			;wake hero death failsafe scripts
			(wake ctrl_ext_johnson_failsafe)
			(wake ctrl_ext_williams_failsafe)
			;wake crates
			(wake create_oldarena_crates)
			(wake create_control_crates)
			;wake the chapter title triggers
			(wake trigger_chapter_four)
			;wake music scripts
			;(wake e20_music_triggers_control_center)
			(wake e20_music_triggers_control_end)
			;wake buddy marine scripts
			(wake spawn_buddy_johnson)
			(wake spawn_buddy_williams)
			;set door to control path as open
			;(device_set_position dm_landing_door 1)
			;(device_set_power dm_landing_door 1)
		)
	)

	; beat 4 - final encounter
	(if (f_insertion_point_area_pending ins_e20_final_encounter)
		(begin
			;wake the encounter triggering scripts for 24
			(wake start_final_encounter)
			;(wake e20_music_triggers_control_center)
			(wake e20_music_triggers_control_end)
			;wake crates
			(wake create_oldarena_crates)
			(wake create_control_crates)
			;wake buddy marine scripts
			(wake spawn_buddy_johnson)
			(wake spawn_buddy_williams)
			;wake vo
			(wake trigger_vo_command_hvt_spawned)
		)
	)
)

;====================================================================================================================================================================================================
; setup ==============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant create_needed_objects
	(print_if b_debug_gameplay "creating needed objects")
    ; (object_create_folder <folder>) -> create needed objects
)

(script static void mission_setup
    (print_if b_debug_gameplay "mission setup")
    ; set up the mission for not cooperative play and easy/normal difficulty
)

(script static void fast_setup
    (print_if b_debug_gameplay "fast setup")
    ; set up the mission for cooperative play heroic/legendary difficulty
)

(script static void main_setup
	; setup for the map regardless of mission or fast
	(print_if b_debug_gameplay "setup complete")
)

;====================================================================================================================================================================================================
; 												e20 - eye of prophet
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant eye_spawner
	(sleep_until (= (cinematic_in_progress) false) 1)

	(ai_place gr_eye_of_prophet)
	(ai_cannot_die gr_eye_of_prophet true)
)

(script command_script cs_eye_look
	(sleep 1)
	(print "eye_look_player")
	(cs_aim_player true)
	(sleep_forever)
)

(script command_script cs_eye_intro
	(sleep 1)
	(print "eye_look_intro")
	(sleep_until
		(begin
			(sleep 1)
			(cs_aim 1 ps_look_intro/p0)
			(sleep 90)
			(cs_aim 1 ps_look_intro/p1)
			(sleep 90)
			(cs_aim 1 ps_look_intro/p2)
			(sleep 90)
			(cs_aim 1 ps_look_intro/p3)
			(sleep 90)

			false
		)
	30)
)

(script command_script cs_eye_settlement
	(sleep 1)
	(print "eye_look_settlement")
	(sleep_until
		(begin
			(sleep 1)
			(cs_aim true ps_look_settlement/p0)
			(sleep 60)
			(cs_aim true ps_look_settlement/p1)
			(sleep 60)
			(cs_aim true ps_look_settlement/p2)
			(sleep 45)
			(cs_aim true ps_look_settlement/p4)
			(sleep 45)
			(cs_aim true ps_look_settlement/p1)
			(sleep 80)
			(cs_aim true ps_look_settlement/p2)
			(sleep 50)
			false ; exit condition
		)
		30
	)
)

(script command_script cs_eye_jungle
	(print "eye_search_jungle")
	(sleep_until
		(begin
			(sleep 1)
			(print "eye_search_jungle")
			(cs_aim true ps_search_jungle/p0)
			(sleep 60)
			(cs_aim true ps_search_jungle/p1)
			(sleep 60)
			(cs_aim true ps_search_jungle/p2)
			(sleep 45)
			(cs_aim true ps_search_jungle/p4)
			(sleep 45)
			(cs_aim true ps_search_jungle/p5)
			(sleep 80)
			(cs_aim true ps_search_jungle/p6)
			(sleep 50)
			(cs_aim true ps_search_jungle/p4)
			(sleep 200)
			(cs_aim true ps_search_jungle/p0)
			(sleep 80)
			(cs_aim true ps_search_jungle/p3)
			(sleep 45)
			(cs_aim true ps_search_jungle/p5)
			(sleep 40)
			(cs_aim true ps_search_jungle/p2)
			(sleep 70)
			(cs_aim true ps_search_jungle/p6)
			(sleep 80)
			(cs_aim true ps_search_jungle/p1)
			(sleep 55)
			(cs_aim true ps_search_jungle/p3)
			(sleep 200)
			false ; exit condition
		)
		30
	)
)

(script command_script cs_eye_search
	(print "eye_search_normal")
	(sleep_until
		(begin
			(sleep 1)
			(print "eye_search_around")
			(cs_aim true ps_search_prison/p0)
			(sleep 60)
			(cs_aim true ps_search_prison/p1)
			(sleep 60)
			(cs_aim true ps_search_prison/p2)
			(sleep 45)
			(cs_aim true ps_search_prison/p5)
			(sleep 80)
			(cs_aim true ps_search_prison/p1)
			(sleep 50)
			(cs_aim true ps_search_prison/p4)
			(sleep 200)
			(cs_aim true ps_search_prison/p0)
			(sleep 80)
			(cs_aim true ps_search_prison/p5)
			(sleep 40)
			(cs_aim true ps_search_prison/p2)
			(sleep 70)
			(cs_aim true ps_search_prison/p0)
			(sleep 80)
			(cs_aim true ps_search_prison/p1)
			(sleep 55)
			(cs_aim true ps_search_prison/p3)
			(sleep 200)
			(cs_aim true ps_search_oob/p0)
			(sleep 80)
			(cs_aim true ps_search_oob/p1)
			(sleep 40)
			(cs_aim true ps_search_oob/p2)
			(sleep 200)
			(cs_aim true ps_search_oob/p3)
			(sleep 70)
			(cs_aim true ps_search_oob/p4)
			(sleep 300)
			(cs_aim true ps_search_oob/p2)
			(sleep 50)
			(cs_aim true ps_search_oob/p0)
			(sleep 80)
			(cs_aim true ps_search_oob/p4)
			(sleep 65)
			(cs_aim true ps_search_oob/p2)
			(sleep 80)
			(cs_aim true ps_search_oob/p0)
			(sleep 200)
			(cs_aim true ps_search_oob/p1)
			(sleep 50)
			(cs_aim true ps_search_oob/p3)
			(sleep 65)
			false ; exit condition
		)
		30
	)
)


;====================================================================================================================================================================================================
; 												e20 - buddy marine - johnson and williams
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================


; spawn johnson / set to be invulnerable / add to my fireteam
(script dormant spawn_buddy_johnson
	(cond
		((f_insertion_point_matches ins_e20_start) (begin
			(ai_place sq_johnson_start)
			(set ai_johnson sq_johnson_start)
			(ai_actor_dialogue_enable ai_johnson 0) ; disables johnson chatter so he doesn't quip right before the transition to intro cinematic starting
		))
		((f_insertion_point_matches ins_e20_settlement_end) (begin
			(ai_place sq_johnson_settlement)
			(set ai_johnson sq_johnson_settlement)
		))
		((f_insertion_point_matches ins_e20_prison_start) (begin
			(ai_place sq_johnson_prison)
			(set ai_johnson sq_johnson_prison)
		))
		((f_insertion_point_matches ins_e20_prison_armory) (begin
			(ai_place sq_johnson_security)
			(set ai_johnson sq_johnson_security)
			(print "johnson is at the marine cells")
		))
		((f_insertion_point_matches ins_e20_pre_bridge) (begin
			(ai_place sq_johnson)
			(set ai_johnson sq_johnson)
			(print "johnson is at the location before the double bridge")
		))
		((f_insertion_point_matches ins_e20_landing_structure) (begin
			(ai_place sq_johnson_ls)
			(set ai_johnson sq_johnson_ls)
			(print "johnson is at the landing structure")
		))
		((f_insertion_point_matches ins_e20_path_to_control_room) (begin
			(ai_place sq_johnson_ptcr)
			(set ai_johnson sq_johnson_ptcr)
			(print "johnson is on the path to the control room")
		))
		((f_insertion_point_matches ins_e20_final_encounter) (begin
			(ai_place sq_johnson_fe)
			(set ai_johnson sq_johnson_fe)
			(print "johnson is in the control room")
		))
	)

	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(wake johnson_waypoint_control)
)

(script dormant johnson_waypoint_control
	(sleep (game_ticks_from_seconds 1))
	(f_hud_hero_waypoint ai_johnson hero_johnson hero_default_max_dist)
)

; spawn williams / set to be invulnerable / add to my fireteam
(script dormant spawn_buddy_williams
	(cond
		((f_insertion_point_matches ins_e20_start) (begin
			(ai_place sq_williams_initial)
			(set ai_williams sq_williams_initial)
		))
		((f_insertion_point_matches ins_e20_settlement_end) (begin
			(ai_place sq_williams_settlement)
			(set ai_williams sq_williams_settlement)
		))
		((f_insertion_point_matches ins_e20_prison_start) (begin
			(ai_place sq_williams_prison)
			(set ai_williams sq_williams_prison)
		))
		((f_insertion_point_matches ins_e20_prison_armory) (begin
			(ai_place sq_williams_security)
			(set ai_williams sq_williams_security)
		))
		((f_insertion_point_matches ins_e20_pre_bridge) (begin
			(ai_place sq_williams)
			(set ai_williams sq_williams)
			(print "williams is at the location before the double bridge")
		))
		((f_insertion_point_matches ins_e20_landing_structure) (begin
			(ai_place sq_williams_ls)
			(set ai_williams sq_williams_ls)
			(print "williams is at the landing structure")
		))
		((f_insertion_point_matches ins_e20_path_to_control_room) (begin
			(ai_place sq_williams_ptcr)
			(set ai_williams sq_williams_ptcr)
			(print "williams is on the path to the control room")
		))
		((f_insertion_point_matches ins_e20_final_encounter) (begin
			(ai_place sq_williams_fe)
			(set ai_williams sq_williams_fe)
			(print "williams is in the control room")
		))
	)

	(ai_player_add_fireteam_squad player0 ai_williams)
	(ai_set_objective ai_williams obj_global_ai_follow)
	(wake williams_waypoint_control)
)

(script dormant williams_waypoint_control
	(sleep (game_ticks_from_seconds 1))
	(f_hud_hero_waypoint ai_williams hero_williams hero_default_max_dist)
)

;============================================================================================
;teleport (progression)
;============================================================================================

; teleport my coop players to settlement - ponr
(script dormant teleport_coop_players_settlement
	(sleep_until (volume_test_players tv_teleport_set) 1)

	;remove any remaining enemies from the previous areas
	(ai_disposable gr_brute_bowl true)
	(ai_disposable gr_settlement true)

	(print_if b_debug_gameplay "ai disposal: removing remaining enemies from brute bowl and settlement")

	(print_if b_debug_gameplay "teleporting coop players into the settlement building")

	(volume_teleport_players_not_inside tv_teleport_set_safezone fl_teleport_set)

	;check if williams and johnson made it in before setting door off
	(sleep_until
		(and
			(volume_test_object tv_teleport_set_safezone (ai_get_object ai_williams))
			(volume_test_object tv_teleport_set_safezone (ai_get_object ai_johnson))
		)
	1)
	(device_set_power dm_settlement_cine 0)
)

; teleport my buddies to brute ambush
(script dormant teleport_buddies_brute_ambush

	(sleep_until (volume_test_players tv_brute_ambush_teleport) 1)

	(sleep_until
		(and
			(volume_test_objects tv_brute_ambush_heros_tele ai_johnson)
			(volume_test_objects tv_brute_ambush_heros_tele ai_williams)
		)
		1
		(game_ticks_from_seconds 15) ;timeout after 15 seconds
	)

	(print "checking if williams and johnson need to be teleported to brute ambush")

	(if (not (volume_test_objects tv_brute_ambush_heros_tele ai_johnson))
		;then
		(wake teleport_johnson_brute_ambush)
		;else
		(print "johnson did not need teleported to brute ambush")
	)

	(if (not (volume_test_objects tv_brute_ambush_heros_tele ai_williams))
		;then
		(wake teleport_williams_brute_ambush)
		;else
		(print "williams did not need teleported to brute ambush")
	)
)

(script dormant teleport_johnson_brute_ambush
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)
	(object_teleport ai_johnson fl_brute_ambush_teleport)
	(print "johnson did need teleported to brute ambush")
)

(script dormant teleport_williams_brute_ambush
	(sleep_until (> (object_get_health (object_get_ai ai_williams)) 0) 1)
	(object_teleport ai_williams fl_brute_ambush_teleport)
	(print "williams did need teleported to brute ambush")
)

(script dormant teleport_buddies_prison_bridge

	(sleep_until (or (volume_test_players tv_teleport_pb1) (volume_test_players tv_teleport_pb2)) 1)

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai teleport:initializing catchup teleport for ai allies")

	;kill any command scripts that were running on johnson and williams
	(if (not (volume_test_object tv_teleport_pb_safezone ai_johnson)) (cs_run_command_script ai_johnson cs_tele_kill_command_script))
	(if (not (volume_test_object tv_teleport_pb_safezone ai_williams)) (cs_run_command_script ai_williams cs_tele_kill_command_script))

	;teleport johnson/williams to their proper places for the prison bridge encounter
	(if (not (volume_test_object tv_teleport_pb_safezone ai_johnson)) (object_teleport ai_johnson fl_teleport_pb2))
	(if (not (volume_test_object tv_teleport_pb_safezone ai_williams)) (object_teleport ai_williams fl_teleport_pb1))

	;run command script for johnson snipe sequence
	(cs_run_command_script ai_johnson cs_pb_johnson_kill_jackal)

	;same with the jungle marines
	(if (not (volume_test_object tv_teleport_pb_safezone sq_jackal_jungle_marines/marine0)) (object_teleport sq_jackal_jungle_marines/marine0 fl_teleport_pb3))
	(if (not (volume_test_object tv_teleport_pb_safezone sq_jackal_jungle_marines/marine1)) (object_teleport sq_jackal_jungle_marines/marine1 fl_teleport_pb4))

	;set objectives williams/johnson and marines
	(ai_set_objective ai_johnson obj_prison_bridge_ext)
	(ai_set_objective ai_williams obj_prison_bridge_ext)
	(ai_set_objective sq_jackal_jungle_marines/marine0 obj_prison_bridge_ext)
	(ai_set_objective sq_jackal_jungle_marines/marine1 obj_prison_bridge_ext)
)

; teleport my coop players to prison bridge (normal path) - ponr
(script dormant teleport_coop_players_prison_bridge_1

	(sleep_until (volume_test_players tv_teleport_pb1) 1)

	(device_ignore_player_set dm_jungle_bigdoor2 1)
	(device_set_position dm_jungle_bigdoor2 0) ;shut and lock the door behind the player so they can't go back.
	(device_set_power dm_jungle_bigdoor2 0)

	(sleep_until (= 0 (device_get_position dm_jungle_bigdoor2)) 1) ;wait until the door is shut and locked before teleporting!

	;remove any remaining enemies from the previous areas
	(ai_disposable gr_e11_brute_ambush true)
	(ai_disposable gr_jackal_jungle true)

	(print_if b_debug_gameplay "ai disposal: removing remaining enemies from brute ambush and jackal jungle")

	(print_if b_debug_gameplay "teleporting coop players into the prison bridge cave")

	(volume_teleport_players_not_inside tv_teleport_pb_safezone fl_teleport_pb1)

	(device_set_power dm_jungle_secret2 0)
	(device_set_position dm_jungle_secret2 0) ;make sure the other door shuts and locks just in case the other zone isn't triggered.

)

; teleport my coop players to prison bridge (secret path) - ponr
(script dormant teleport_coop_players_prison_bridge_2

	(sleep_until (volume_test_players tv_teleport_pb2) 1)

	(device_set_power dm_jungle_secret2 0)
	(device_set_position dm_jungle_secret2 0) ;shut and lock the door behind the player so they can't go back.
	(device_set_position dm_jungle_secret 0) ;shut and lock the door behind the player so they can't go back.

	(sleep_until (= 0 (device_get_position dm_jungle_secret2)) 1) ;wait until the door is shut and locked before teleporting!

	(print "teleporting coop players to the prison bridge overlook")

	(volume_teleport_players_not_inside tv_teleport_pb_safezone fl_teleport_pb2)

	(device_ignore_player_set dm_jungle_bigdoor 1)
	(device_set_power dm_jungle_bigdoor 0)
	(device_set_position dm_jungle_bigdoor 0) ;make sure the other door shuts and locks just in case the other zone isn't triggered.

)

(script dormant teleport_buddies_prison_entrance

	(sleep_until (volume_test_players tv_prison_entrance) 1)

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai teleport:initializing catchup teleport for ai allies")

	;kill any command scripts that were running on johnson and williams
	(if (not (volume_test_object tv_teleport_pb_safezone ai_johnson)) (cs_run_command_script ai_johnson cs_tele_kill_command_script))
	(if (not (volume_test_object tv_teleport_pb_safezone ai_williams)) (cs_run_command_script ai_williams cs_tele_kill_command_script))

	;teleport johnson/williams to the prison exterior if they've fallen behind too far
	(if (not (volume_test_object tv_teleport_pb_safezone ai_johnson)) (object_teleport ai_johnson fl_teleport_pb2))
	(if (not (volume_test_object tv_teleport_pb_safezone ai_williams)) (object_teleport ai_williams fl_teleport_pb1))

	;same with the jungle marines
	(if (not (volume_test_object tv_teleport_pb_safezone sq_jackal_jungle_marines/marine0)) (object_teleport sq_jackal_jungle_marines/marine0 fl_teleport_pb1))
	(if (not (volume_test_object tv_teleport_pb_safezone sq_jackal_jungle_marines/marine1)) (object_teleport sq_jackal_jungle_marines/marine1 fl_teleport_pb1))

	;set objectives williams/johnson
	(if (not (volume_test_object tv_teleport_pb_safezone ai_johnson)) (ai_set_objective ai_johnson obj_bridge_marine_buddies))
	(if (not (volume_test_object tv_teleport_pb_safezone ai_williams)) (ai_set_objective ai_williams obj_bridge_marine_buddies))
)

(script dormant teleport_marines_prison_lift

	(sleep_until (volume_test_players tv_teleport_pgl2) 1)

	;teleport any living jackal jungle marines into the grav lift
	(if (not (volume_test_object tv_teleport_pgl_safezone2 sq_jackal_jungle_marines/marine0)) (object_teleport sq_jackal_jungle_marines/marine0 fl_teleport_pgl))
	(if (not (volume_test_object tv_teleport_pgl_safezone2 sq_jackal_jungle_marines/marine1)) (object_teleport sq_jackal_jungle_marines/marine1 fl_teleport_pgl))

)

; teleport my coop players to prison grav lift - ponr
(script dormant teleport_coop_players_prison_grav_lift

	(sleep_until (volume_test_players tv_teleport_pgl) 1)

	(print "teleporting coop players into the prison grav lift")

	(volume_teleport_players_not_inside tv_teleport_pgl_safezone fl_teleport_pgl)

	(device_set_power dm_prison_entrance 0)
)

; teleport my coop players to observation bottom hallway - ponr
(script dormant teleport_coop_players_obs_bottom_hall

	(sleep_until (volume_test_players tv_teleport_obh) 1)

	(print "teleporting coop players into the observation bottom hallway")

	(volume_teleport_players_not_inside tv_teleport_obh_safezone fl_teleport_obh)

	(device_set_power dm_covdoor_prison10 0)
)

(script dormant teleport_buddies_obs_bottom

	(sleep_until (volume_test_players tv_observation_bottom) 1)

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai teleport: sending allies who fell behind to observation bottom hallway")

	;kill any command scripts that were running on johnson and williams
	(if (not (volume_test_object tv_teleport_obh_safezone ai_johnson)) (cs_run_command_script ai_johnson cs_tele_kill_command_script))
	(if (not (volume_test_object tv_teleport_obh_safezone ai_williams)) (cs_run_command_script ai_williams cs_tele_kill_command_script))

	;teleport johnson/williams to observation botton hallway if they've fallen behind too far
	(if (not (volume_test_object tv_teleport_obh_safezone ai_johnson)) (object_teleport ai_johnson fl_obs_bottom_teleport))
	(if (not (volume_test_object tv_teleport_obh_safezone ai_williams)) (object_teleport ai_williams fl_obs_bottom_teleport))

	;same with the jungle marines
	(if (not (volume_test_object tv_teleport_obh_safezone sq_jackal_jungle_marines/marine0)) (object_teleport sq_jackal_jungle_marines/marine0 fl_obs_bottom_teleport))
	(if (not (volume_test_object tv_teleport_obh_safezone sq_jackal_jungle_marines/marine1)) (object_teleport sq_jackal_jungle_marines/marine1 fl_obs_bottom_teleport))
)

(script dormant teleport_prearena_failsafe_johnson

	(sleep_until (volume_test_players tv_arena2) 1)

	;making sure johnson is alive before teleporting
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)

	;check if they're in the safezone trigger volume.
	(sleep_until (not (volume_test_object tv_arena_tele_safezone ai_johnson)) 1)

	;force teleport
	(object_teleport ai_johnson fl_arena_teleport)

	;kill any command scripts that were running on williams and set objective to follow player
	(cs_run_command_script ai_johnson cs_tele_kill_command_script)
	(ai_set_objective ai_johnson obj_global_ai_follow)

)

(script dormant teleport_prearena_failsafe_williams

	(sleep_until (volume_test_players tv_arena2) 1)

	;making sure williams is alive before teleporting
	(sleep_until (> (object_get_health (object_get_ai ai_williams)) 0) 1)

	;check if they're in the safezone trigger volume
	(sleep_until (not (volume_test_object tv_arena_tele_safezone ai_williams)) 1)

	;force teleport
	(object_teleport ai_williams fl_arena_teleport)

	;kill any command scripts that were running on williams and set objective to follow player
	(cs_run_command_script ai_williams cs_tele_kill_command_script)
	(ai_set_objective ai_williams obj_global_ai_follow)

)

; teleport my coop players to observation bottom hallway - ponr
(script dormant teleport_coop_players_pre_arena

	(sleep_until (volume_test_players tv_teleport_pre_arena) 1)

	(print "teleporting coop players into the observation bottom hallway")

	(volume_teleport_players_not_inside tv_teleport_pre_arena_safezone fl_teleport_pre_arena)
)

;; ponr - post arena / pre-bridge
(script dormant teleport_coop_players_pre_bridge
	(sleep_until (volume_test_players tv_ponr_pre_bridge) 1)
	(device_set_power dm_covdoor_prison30 0)
	(sleep_until (= (device_get_position dm_covdoor_prison32) 0) 1) ;;wait until the door closes
	(volume_teleport_players_not_inside tv_ponr_pre_bridge_safezone fl_coop_teleport_pre_bridge)
)

; teleport my buddies onto the bridge center - temp
(script dormant teleport_buddies_bridge
	;(branch
		;(and
			;(volume_test_object tv_bridge_buddy_teleport ai_johnson)
			;(volume_test_object tv_bridge_buddy_teleport ai_williams)
		;)
		;(f_md_abort)
	;)

	;might want a check for if the ai are running a certain command script
	;(sleep_until (volume_test_players tv_bridge_buddy_teleport) 1)

	;(sleep (game_ticks_from_seconds 30)) ;give the ai a chance to catch up

	;(print "trying to teleport")

	; teleport williams/johnson
	;(ai_bring_forward ai_williams 3)
	;(ai_bring_forward ai_johnson 3)

	;(cs_run_command_script ai_johnson cs_kill_command_script)
	;(cs_run_command_script ai_williams cs_kill_command_script)

	;force teleport
	(object_teleport ai_williams fl_grav_bridge_teleport)
	(object_teleport ai_johnson fl_grav_bridge_teleport)
	;settlement marines
	;(object_teleport sq_settlement_marines/marine0 fl_grav_bridge_teleport)
	;(object_teleport sq_settlement_marines/marine1 fl_grav_bridge_teleport)
	;(object_teleport sq_settlement_marines/marine2 fl_grav_bridge_teleport)
	;(object_teleport sq_settlement_marines/marine3 fl_grav_bridge_teleport)
	;jungle marines
	(object_teleport sq_jackal_jungle_marines/marine0 fl_grav_bridge_teleport)
	(object_teleport sq_jackal_jungle_marines/marine1 fl_grav_bridge_teleport)
	;cell marines
	(object_teleport sq_marine_cells_marines/marine0 fl_grav_bridge_teleport)
	(object_teleport sq_marine_cells_marines/marine1 fl_grav_bridge_teleport)
	(object_teleport sq_marine_cells_marines/marine2 fl_grav_bridge_teleport)

	; set objectives williams/johnson
	(ai_set_objective ai_johnson obj_bridge_marine_buddies)
	(ai_set_objective ai_williams obj_bridge_marine_buddies)
)

; teleport my buddies past the 2nd bridge (old arena cave) if they fall too far behind
(script dormant teleport_buddies_post_bridge

	(sleep_until (volume_test_players tv_teleport_old_arena) 1)

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print "ai teleport:sending allies who fell behind to the old arena cave")

	;kill any command scripts that were running on johnson and williams
	(if (not (volume_test_object tv_teleport_old_arena_safezone ai_johnson)) (cs_run_command_script ai_johnson cs_tele_kill_command_script))
	(if (not (volume_test_object tv_teleport_old_arena_safezone ai_williams)) (cs_run_command_script ai_williams cs_tele_kill_command_script))

	;teleport johnson/williams to the post bridge cave if they've fallen behind too far
	(if (not (volume_test_object tv_teleport_old_arena_safezone ai_johnson)) (object_teleport ai_johnson fl_old_arena_teleport))
	(if (not (volume_test_object tv_teleport_old_arena_safezone ai_williams)) (object_teleport ai_williams fl_old_arena_teleport))

	;same with the jungle marines
	(if (not (volume_test_object tv_teleport_old_arena_safezone sq_jackal_jungle_marines/marine0)) (object_teleport sq_jackal_jungle_marines/marine0 fl_old_arena_teleport))
	(if (not (volume_test_object tv_teleport_old_arena_safezone sq_jackal_jungle_marines/marine1)) (object_teleport sq_jackal_jungle_marines/marine1 fl_old_arena_teleport))

	;and your escaped-convict friends
	(if (not (volume_test_object tv_teleport_old_arena_safezone sq_marine_cells_marines/marine0)) (object_teleport sq_marine_cells_marines/marine0 fl_old_arena_teleport))
	(if (not (volume_test_object tv_teleport_old_arena_safezone sq_marine_cells_marines/marine1)) (object_teleport sq_marine_cells_marines/marine1 fl_old_arena_teleport))
	(if (not (volume_test_object tv_teleport_old_arena_safezone sq_marine_cells_marines/marine2)) (object_teleport sq_marine_cells_marines/marine2 fl_old_arena_teleport))
)

; setting the buddies obj post bridge
(script dormant swap_objectives_post_bridge

	(sleep_until (volume_test_players tv_post_bridge_objective_swap) 1)

	; set objectives williams/johnson
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_player_add_fireteam_squad player0 ai_williams)

	(ai_set_objective ai_williams obj_old_arena_marine_buddies)
	(ai_set_objective ai_johnson obj_old_arena_marine_buddies)

)

; teleport my coop players to old arena cave - ponr
(script dormant teleport_coop_players_old_arena

	(sleep_until (volume_test_players tv_teleport_old_arena) 1)

	(print "teleporting coop players into the old arena cave")

	(volume_teleport_players_not_inside tv_teleport_old_arena_safezone fl_teleport_old_arena)
)

(script dormant teleport_buddies_landing_structure

	(sleep_until (volume_test_players tv_landing_structure_teleport) 1)

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai teleport: sending allies who fell behind to landing structure")

	;force teleport
	(object_teleport ai_williams fl_landing_teleport)
	(object_teleport ai_johnson fl_landing_teleport)

	;jungle marines
	(object_teleport sq_jackal_jungle_marines/marine0 fl_landing_teleport)
	(object_teleport sq_jackal_jungle_marines/marine1 fl_landing_teleport)

	;cell marines
	(object_teleport sq_marine_cells_marines/marine0 fl_landing_teleport)
	(object_teleport sq_marine_cells_marines/marine1 fl_landing_teleport)
	(object_teleport sq_marine_cells_marines/marine2 fl_landing_teleport)

	; set objectives williams/johnson
	(ai_set_objective ai_williams obj_post_bridge_marine_buddies)
	(ai_set_objective ai_johnson obj_post_bridge_marine_buddies)

)

(script dormant teleport_buddies_cont_approach_teleport

	(sleep_until (volume_test_players tv_lodge_entrance_teleport) 1)

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai teleport: sending allies who fell behind to lodge entrance")

	;force teleport
	(object_teleport ai_williams fl_lodge_entrance_teleport)
	(object_teleport ai_johnson fl_lodge_entrance_teleport)

	;jungle marines
	(object_teleport sq_jackal_jungle_marines/marine0 fl_lodge_entrance_teleport)
	(object_teleport sq_jackal_jungle_marines/marine1 fl_lodge_entrance_teleport)

	;cell marines
	(object_teleport sq_marine_cells_marines/marine0 fl_lodge_entrance_teleport)
	(object_teleport sq_marine_cells_marines/marine1 fl_lodge_entrance_teleport)
	(object_teleport sq_marine_cells_marines/marine2 fl_lodge_entrance_teleport)

	; set objectives williams/johnson
	(ai_set_objective ai_williams obj_post_bridge_marine_buddies)
	(ai_set_objective ai_johnson obj_post_bridge_marine_buddies)

)

(script dormant teleport_final_encounter

	;(sleep (game_ticks_from_seconds 2))

	(sleep_until (volume_test_players tv_final_encounter) 1)

	(sleep_until (= 0 (device_get_position dm_control_entrance3)) 1)

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai teleport: sending allies who fell behind to final encounter")

	;kill any command scripts that were running on johnson and williams
	(if (not (volume_test_object tv_ctrl_tele_safezone ai_johnson)) (cs_run_command_script ai_johnson cs_tele_kill_command_script))
	(if (not (volume_test_object tv_ctrl_tele_safezone ai_williams)) (cs_run_command_script ai_williams cs_tele_kill_command_script))

	;teleport johnson/williams to the control center if they've fallen behind too far
	(if (not (volume_test_object tv_ctrl_tele_safezone ai_johnson)) (object_teleport ai_johnson fl_final_encounter_teleport))
	(if (not (volume_test_object tv_ctrl_tele_safezone ai_williams)) (object_teleport ai_williams fl_final_encounter_teleport))

	;make johnson can die for the final battle (williams should be left invincible)
	(ai_cannot_die ai_johnson false)

)

; teleport my coop players and ai allies to control center hallway for airlock
(script dormant teleport_players_and_ai_airlock

	(sleep_until (volume_test_players tv_ctrl_airlock) 1)

	(wake teleport_johnson_to_airlock)
	(wake teleport_williams_to_airlock)

	;shut the entrance door to the control hallway
	(device_set_power dm_control_entrance 1) ;enable power to front door
	(device_set_position dm_control_entrance 0) ;shut and lock the door behind the player so they can't go back.

	;wait until the door is shut to teleport coop players
	(sleep_until (= 0 (device_get_position dm_control_entrance)) 1)

	(device_set_power dm_control_entrance 0) ;disable power to front door

	(device_set_power dm_control_entrance3 1) ;enable power to control center atrium

	(print "teleporting coop players into the control center hallway for the airlock")

	;teleport coop players that have fallen behind into the hallway - ponr
	(volume_teleport_players_not_inside tv_ctrl_airlock_safezone fl_airlock_teleport)

)

(script dormant teleport_johnson_to_airlock
	;making sure johnson is alive before teleporting
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)

	;teleport johnson to the hallway if they've fallen behind
	(if (not (volume_test_object tv_ctrl_airlock_safezone ai_johnson)) (object_teleport ai_johnson fl_airlock_teleport))

	(print "johnson was teleported if needed")
)

(script dormant teleport_williams_to_airlock
	;making williams is alive before teleporting
	(sleep_until (> (object_get_health (object_get_ai ai_williams)) 0) 1)

	;teleport williams to the hallway if they've fallen behind
	(if (not (volume_test_object tv_ctrl_airlock_safezone ai_williams)) (object_teleport ai_williams fl_airlock_teleport))

	(print "willaims was teleported if needed")
)

; teleport my coop players to control center - ponr
(script dormant teleport_coop_players_control

	;(sleep (game_ticks_from_seconds 2))

	(sleep_until (volume_test_players tv_final_encounter) 1)

	(sleep_until (= 0 (device_get_position dm_control_entrance3)) 1)

	(print "teleporting coop players into the control center")

	(volume_teleport_players_not_inside tv_ctrl_tele_safezone fl_teleport_control)
)


;====================================================================================================================================================================================================
; e20 mission scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
; naming convention for major logic functions: e20_beat_name, e.g. a10_start_tutorial
; todo replace e20 with your map's shorthand (f.ex. a20), ctrl+h
; todo rename all trigger volumes and the word "title" with appropriate names

;====================================================================================================================================================================================================
; <e20 beat 1>
;
; description: this is the description for e20 beat 1.
;====================================================================================================================================================================================================


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 											e20 beat 1 - vo and music
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant trigger_vo_level_start

	(sleep_until (= (cinematic_in_progress) false) 1)
	(wake e20_music_triggers_ins_0)

	; lock player movement and gaze to be slightly up towards the vista and eye
	(player_disable_movement true)
	(player_control_lock_gaze player0 ps_player_gaze_start/p0 1000)
	(player_control_lock_gaze player1 ps_player_gaze_start/p0 1000)
	(player_control_lock_gaze player2 ps_player_gaze_start/p0 1000)
	(player_control_lock_gaze player3 ps_player_gaze_start/p0 1000)

	;disable floor is lava skull
	(skull_affects_players skull_floor_is_lava false)

	(sleep (game_ticks_from_seconds 2))
	(set mark_signal true) ; show objective about investigating signal
	(wake vo_eye_intro)

	; unlock player gaze
	(player_control_unlock_gaze player0)
	(player_control_unlock_gaze player1)
	(player_control_unlock_gaze player2)
	(player_control_unlock_gaze player3)
	(player_disable_movement false)

	;enable floor is lava skull
	(skull_affects_players skull_floor_is_lava true)

)

(script dormant trigger_vo_brute_bowl_end
	(sleep_until (= (ai_living_count gr_brute_bowl) 0) 1)
	; wait until player is near and looking at one of the dead marines
	(sleep_until
		(or
			(and
				(>= 2 (objects_distance_to_object (players) dead_marine_brutebowl_1))
				(objects_can_see_object (players) dead_marine_brutebowl_1 10)
			)
			(and
				(>= 2 (objects_distance_to_object (players) dead_marine_brutebowl_2))
				(objects_can_see_object (players) dead_marine_brutebowl_2 10)
			)
			(and
				(>= 2 (objects_distance_to_object (players) dead_marine_brutebowl_3))
				(objects_can_see_object (players) dead_marine_brutebowl_3 10)
			)
		)

	1)
	(wake vo_brute_bowl_end)
)

(script dormant trigger_vo_settlement_start
	(sleep_until (volume_test_players tv_dialogue_settlement_start) 1)
	(wake vo_settlement_start)
	(sleep_forever vo_level_start_dawdle) ; ends the dawdle vo
)

(script dormant trigger_vo_settlement_williams1
	; trigger walk and talk after williams cinematic
	(sleep_until (= (ai_living_count gr_settlement) 0) 1)
	(sleep_until (= 1 (device_get_position dm_settlement_cine)) 1)
	(sleep_until (= (cinematic_in_progress) false) 1)

	; turns off combat chatter for williams and johnson for walk and talk
	(ai_actor_dialogue_enable ai_williams false)
	(ai_actor_dialogue_enable ai_johnson false)

	(wake vo_settlement_williams1)

	;plays song "mus_06_walk_and_talk" once dialogue for williams begins after the cutscene
	(wake e20_music_triggers_settlement)

)

(global boolean b_settlement_ramp_blip 0)
(global boolean b_walk_and_talk_finished false)

(script dormant trigger_post_walk_and_talk
	(sleep_until
		(or
			(volume_test_players tv_dialogue_settlement_williams2)
			(script_finished "vo_settlement_williams1")
		)
	1)

	(set b_walk_and_talk_finished 1)
	(set mark_survive true)
	(wake vo_williams_dawdle)

	(if (volume_test_players tv_dialogue_settlement_williams2)
		(set s_conversation_id 5)
	)

	(set b_settlement_ramp_blip true)
	(wake settlement_ramp_blip) ; navpoint the ramp down - script contains logic if player has already gone down the ramp

	(ai_set_objective ai_williams obj_global_ai_follow)
	(ai_set_objective ai_johnson obj_global_ai_follow)

	(ai_cannot_die ai_johnson false) ; allows johnson to die again after the walk and talk conversation has been aborted
	(ai_cannot_die ai_williams false) ; allows williams to die again after the walk and talk conversation has been aborted
)

(script dormant trigger_vo_brute_ambush_start
	(sleep_until (volume_test_players tv_dialogue_brute_ambush_start) 1)
	(wake vo_brute_ambush_start)

	; turns on combat chatter for williams and johnson post walk and talk
	(ai_actor_dialogue_enable ai_williams true)
	(ai_actor_dialogue_enable ai_johnson true)
)

(script dormant trigger_vo_brute_ambush_puck
	(sleep_until (volume_test_players tv_dialogue_brute_ambush_puck) 1)
	(if b_brute_ambush_failed
		; if brute ambush failed, wait for the failed conversation to finish before triggering puck hint
		(begin
			(sleep_until (script_finished "vo_brute_ambush_fail") 1)
			(if (> (ai_living_count sq_brute_ambush_brutes) 0) (wake vo_brute_ambush_puck)) ; final check to ensure brutes are still alive
		)
		; if brute ambush succeeded, trigger puck hint immediately
		(if (> (ai_living_count sq_brute_ambush_brutes) 0) (wake vo_brute_ambush_puck)) ; final check to ensure brutes are still alive
	)
)

(script dormant trigger_vo_brute_ambush_fail
	(sleep_until (= b_brute_ambush_failed 1) 1)
	(wake vo_brute_ambush_fail)
)

(script dormant trigger_vo_brute_ambush_cleared
	(sleep_until (= (ai_living_count gr_brute_ambush) 0) 1)
	(wake vo_brute_ambush_cleared)
)

(script dormant trigger_vo_jackal_jungle_intro
	(sleep_until (volume_test_players tv_dialogue_jackal_jungle_start) 1)
	(wake vo_jackal_jungle_intro)
)

(script dormant trigger_vo_jackal_jungle_fail
(sleep_until (= (ai_living_count gr_jackal_jungle) 0) 1)
	(if (= (ai_living_count gr_jackal_jungle_marines) 0)
		;then
		(wake vo_jackal_jungle_fail)
	)
)

(script dormant trigger_vo_jackal_jungle_success
	(sleep_until (= (ai_living_count gr_jackal_jungle) 0) 1)
	(if (>= (ai_living_count gr_jackal_jungle_marines) 2)
		;then
		(wake vo_jackal_jungle_success)
	)
)

(script dormant trigger_vo_prison_bridge_view
	(sleep_until (volume_test_players tv_dialogue_prison_bridge_view) 1)
	(wake vo_prison_bridge_view)
	(set mark_prison true) ; show objective about saving the marines
)

(script dormant trigger_vo_prison_bridge_start
	(sleep_until (volume_test_players tv_eye_look_bridge) 1)
	(wake vo_prison_bridge_start)
)

(script dormant trigger_vo_prison_entry_hacked
	(sleep_until (= b_prison_door_hacked 1) 1)
	(wake vo_prison_entry_hacked_no_marines)

	; (if (> (ai_living_count gr_jackal_jungle_marines) 1)
	; 	; if there are surviving marines
	; 	(wake vo_prison_entry_hacked_marines)

	; 	; if there are no surviving marines
	; 	(wake vo_prison_entry_hacked_no_marines)
	; )
)

;====================================================================================================================================================================================================
; brute bowl
; beat 1 - encounter 1
;
; description: chief and johnson happen upon some brutes who have killed some marines.
;====================================================================================================================================================================================================
(global boolean b_hero_tele_start false) ; if false, this will teleport the hero ai back to start if they fall out of the map

(script dormant start_johnson_failsafe
	(print "hero_ai_died_active - johnson start")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_start ai_johnson) 1)
			(print "hero_ai_died - johnson start - teleporting them to set cutscene flag")
			(object_teleport ai_johnson fl_brute_bowl_teleport)
			(= b_hero_tele_start true)
		)
	1
	)
)

(script dormant start_williams_failsafe
	(print "hero_ai_died_active - williams start")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_start ai_williams) 1)
			(print "hero_ai_died - williams start - teleporting them to set cutscene flag")
			(object_teleport ai_williams fl_brute_bowl_teleport)
			(= b_hero_tele_start true)
		)
	1
	)
)

(script dormant start_level
	(submit_incident_with_custom_string_id "game_activity_begin" "e20")
	(f_play_cinematic cinematics\e20\e20_dome.cinematic)

	;eye is set to search mode by default
	;(print "set eye objective to search")
	(cs_run_command_script sq_eye_of_prophet cs_eye_intro)

	(f_hud_chapter chapter_e20_1)
)

(script dormant start_brute_bowl

	(print "****** beat 1 - encounter 1 ******")

	(sleep_until (volume_test_players tv_brute_bowl) 1)

	(wake trigger_vo_brute_bowl_end)

	(print "place brute bowl enemies")
	(ai_place gr_brute_bowl)
	(ai_disregard (ai_actors gr_brute_bowl) true)

	(ai_place gr_brute_bowl_marine)
	(ai_disregard (ai_actors gr_brute_bowl_marine) true)

	(sleep_until (volume_test_players tv_brute_brutality) 1)

	(sleep (game_ticks_from_seconds 30))
	(ai_disregard (ai_actors gr_brute_bowl) false)

	(print "set johnson's objective to obj_brute_bowl")
	(ai_set_objective ai_johnson obj_brute_bowl)
)

(script command_script cs_brute_brutality_1
	(wake wake_brute_1_if_shot)
	;brute 1 waits and then stomps on the marine
	(custom_animation_loop sq_brute_bowl_brute_1 "objects\characters\brute\brute" "patrol:unarmed:idle" true)
	(sleep_until (volume_test_players tv_brute_brutality) 1)
	(sleep (game_ticks_from_seconds 1.5))
	(sound_impulse_start sound\dialog\combat\brute1\default\02_combat\strk_grnd sq_brute_bowl_brute_1/brute1 1)
	(custom_animation sq_brute_bowl_brute_1 "objects\characters\brute\brute" "act:beatdown_1:var4" true)
	;brute 3 is surprised to see the player and johnson
	(sleep (game_ticks_from_seconds 2))
	(cs_face_player true)
	(sleep (game_ticks_from_seconds 2))
	;(sound_impulse_start sound\dialog\combat\brute1\default\02_combat\brsrk sq_brute_bowl_brute_1/brute1 1)
	(custom_animation sq_brute_bowl_brute_1 "objects\characters\brute\brute" "combat:pistol:surprise_front" true)
	(sleep (game_ticks_from_seconds 2))
	(sleep_forever wake_brute_1_if_shot)
)
;;script forces a clearing cs if brute 1 is shot
(script dormant wake_brute_1_if_shot
	(sleep_until (< (object_get_health (object_get_ai sq_brute_bowl_brute_1)) 1) 1)
	(ai_disregard (ai_actors gr_brute_bowl) false)
	(cs_run_command_script sq_brute_bowl_brute_1 cs_clear_cs_kill_anims)
)

(script command_script cs_brute_brutality_2
	(wake wake_brute_2_if_shot)
	;brute 2 gestures to the other brutes to kill the marine
	(custom_animation_loop sq_brute_bowl_brute_2 "objects\characters\brute\brute" "patrol:unarmed:idle" true)
	(sleep_until (volume_test_players tv_brute_brutality) 1)
	(print "sound triggering")
	;(sound_impulse_start sound\dialog\combat\brute2\default\02_combat\thrtn sq_brute_bowl_brute_2/brute2 1)
	(custom_animation sq_brute_bowl_brute_2 "objects\characters\brute\brute" "armored:pistol:warn" true)
	;brute 2 notices the player and johnson and points them out
	(sleep (game_ticks_from_seconds 2))
	(cs_face_player true)
	(sleep (game_ticks_from_seconds 2))
	(sound_impulse_start sound\dialog\combat\brute2\default\02_combat\charge sq_brute_bowl_brute_2/brute2 1)
	(custom_animation sq_brute_bowl_brute_2 "objects\characters\brute\brute" "armored:pistol:point" true)
	(sleep (game_ticks_from_seconds 3))
	(sleep_forever wake_brute_2_if_shot)
)
;;script forces a clearing cs if brute 2 is shot
(script dormant wake_brute_2_if_shot
	(sleep_until (< (object_get_health (object_get_ai sq_brute_bowl_brute_2)) 1) 1)
	(ai_disregard (ai_actors gr_brute_bowl) false)
	(cs_run_command_script sq_brute_bowl_brute_2 cs_clear_cs_kill_anims)
)

(script command_script cs_brute_brutality_3
	(wake wake_brute_3_if_shot)
	;brute 3 cheers on the other brutes
	(custom_animation_loop sq_brute_bowl_brute_3 "objects\characters\brute\brute" "patrol:unarmed:idle" true)
	(sleep_until (volume_test_players tv_brute_brutality) 1)
	(sleep (game_ticks_from_seconds 2))
	(sound_impulse_start sound\dialog\combat\brute1\default\02_combat\brsrk sq_brute_bowl_brute_3/brute3 1)
	(custom_animation sq_brute_bowl_brute_3 "objects\characters\brute\brute" "global:rifle:celebrate_var2" true)
	;brute 3 is surprised to see the player and johnson
	(sleep (game_ticks_from_seconds 2))
	(cs_face_player true)
	(sleep (game_ticks_from_seconds 2))
	;(sound_impulse_start sound\dialog\combat\brute1\default\02_combat\warn_incmn sq_brute_bowl_brute_3/brute3 1)
	(custom_animation sq_brute_bowl_brute_3 "objects\characters\brute\brute" "armored:pistol:signal_attack" true)
	(sleep (game_ticks_from_seconds 3))
	(sleep_forever wake_brute_3_if_shot)
)
;;script forces a clearing cs if brute 3 is shot
(script dormant wake_brute_3_if_shot
	(sleep_until (< (object_get_health (object_get_ai sq_brute_bowl_brute_3)) 1) 1)
	(ai_disregard (ai_actors gr_brute_bowl) false)
	(cs_run_command_script sq_brute_bowl_brute_3 cs_clear_cs_kill_anims)
)

(script command_script cs_brute_brutality_m
;marine screams to help players understand that a marine is being killed in the brutality vignette
	(ai_braindead ai_current_actor true)

	(sleep_until (volume_test_players tv_brute_brutality) 1)

	;initial scream - in pain
	(sound_impulse_start sound\dialog\combat\trooper1\default\11_involuntary\thrwn sq_brute_bowl_marine/marine1 1)

	(sleep_until (volume_test_players tv_brute_brutality) 1)

	;final scream - dies
	(sleep (game_ticks_from_seconds 2))
	(sound_impulse_start sound\dialog\combat\trooper1\default\11_involuntary\dth_fall sq_brute_bowl_marine/marine1 1)
	(sleep (game_ticks_from_seconds 7))

	(object_destroy ai_current_actor)
)
;; clear the command script and stop any custom animation the characters are currently in
(script command_script cs_clear_cs_kill_anims
	(unit_stop_custom_animation ai_current_actor)
	(sleep 1)
)
;====================================================================================================================================================================================================
; settlement
; beat 1 - encounter 2
;
; description: chief and johnson find williams' troop being attacked by covennant forces
;====================================================================================================================================================================================================

(global boolean b_hero_tele_settlement false) ; if false, this will teleport the hero ai back to start if they fall out of the map

(script dormant settlement_johnson_failsafe
	(print "hero_ai_died_active - johnson settlement")

	;scripts to teleport hero ai back into the playspace if they fall out of the level
	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_settlement ai_johnson) 1)
			(print "hero_ai_died - johnson settlement - teleporting them to set cutscene flag")
			(object_teleport ai_johnson fl_settlement_teleport)
			(= b_hero_tele_settlement true)
		)
	1
	)
)

(script dormant settlement_williams_failsafe
	(print "hero_ai_died_active - williams settlement")

	;scripts to teleport hero ai back into the playspace if they fall out of the level
	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_settlement ai_williams) 1)
			(print "hero_ai_died - williams settlement - teleporting them to set cutscene flag")
			(object_teleport ai_williams fl_settlement_teleport)
			(= b_hero_tele_settlement true)
		)
	1
	)
)

(script dormant start_settlement

	(sleep_until (volume_test_players tv_settlement_encounter) 1)

	;set eye to look at settlement because a battle started over there
	(print "set eye objective to settlement")
	(cs_run_command_script sq_eye_of_prophet cs_eye_settlement)

	(wake teleport_coop_players_settlement)

	;williams
	(wake spawn_buddy_williams)

	;marines
	(ai_place gr_settlement_marines)
	(print "marines joins player's fireteam")
	(ai_player_add_fireteam_squad player0 sq_settlement_marines)

	;covenant
	(ai_place gr_settlement_wave1)

	;wait till player is closer to the encounter area before swapping johnson's objective
	(sleep_until (volume_test_players tv_settlement_obj_swap) 1)

	(print "set johnson's objective to obj_brute_bowl")
	(ai_set_objective ai_johnson obj_settlement)

	(sleep_until (< (ai_living_count gr_settlement) 3) 1)

	(ai_place gr_settlement_wave2)

	(sleep_until (<= (ai_nonswarm_count gr_settlement) 3) 1)
	(f_blip_ai gr_settlement 1)

	(sleep_until (= (ai_nonswarm_count gr_settlement) 0) 1)
	(f_unblip_all)

	;breath a little bit before playing the cinematic
	(sleep (game_ticks_from_seconds 4))

	(f_play_cinematic cinematics\e20\e20_williams.cinematic ps_post_settlement_cine)

	;opens up after cinematic so player can progress
	(print "dm_settlement_cine door opened")
	(device_set_power dm_settlement_cine 1)

	;set eye back to search mode
	(print "set eye objective to search")
	(cs_run_command_script sq_eye_of_prophet cs_eye_search)

	;tiger company regroups with player in beat 4
	(ai_erase gr_settlement_marines)

	;objective setup
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(ai_set_objective ai_williams obj_global_ai_follow)

	;teleport johnson and williams to the door leading ahead and start the "walk and talk" sequence

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai teleport: johnson and williams are alive, proceeding with teleport and walk and talk")

	(object_teleport ai_johnson fl_settlement_teleport2)
	(object_teleport ai_williams fl_settlement_teleport3)
	(print "starting walk and talk for johnson")
	(cs_queue_command_script ai_johnson cs_johnson_walk_and_talk)
	(print "starting walk and talk for williams")
	(cs_queue_command_script ai_williams cs_williams_walk_and_talk)

	;wake script that handles logic for aborting/finishing walk and talk
	(wake trigger_post_walk_and_talk)

	;save game
	(game_save_no_timeout) ;checkpoint

)

;start "walk and talk" sequence for johnson
(script command_script cs_johnson_walk_and_talk

	;abort if player runs ahead
	(branch
		(> s_conversation_id 4) (cs_kill_command_script)
	)

	(ai_cannot_die ai_current_actor true) ; keeps johnson from dying during the walk and talk
	(cs_enable_pathfinding_failsafe false) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck
	(cs_force_combat_status 1)
	(cs_lower_weapon 1) ; lowers weapon
	(cs_walk 1) ; forces johnson to walk
	(cs_face_object 1 (ai_get_object ai_williams))

	(sleep_until b_head_into_settlement 1)
	(sleep (game_ticks_from_seconds 4))
	(cs_face_object 0 (ai_get_object ai_williams)) ; stop facing williams
	(cs_go_by ps_johnson_walk_and_talk/p0 ps_johnson_walk_and_talk/p0)
	(cs_go_by ps_johnson_walk_and_talk/p1 ps_johnson_walk_and_talk/p1)
	(cs_go_by ps_johnson_walk_and_talk/p2 ps_johnson_walk_and_talk/p2)
	(cs_go_by ps_johnson_walk_and_talk/p3 ps_johnson_walk_and_talk/p3)
	(cs_go_by ps_johnson_walk_and_talk/p4 ps_johnson_walk_and_talk/p4)
	(cs_go_by ps_johnson_walk_and_talk/p5 ps_johnson_walk_and_talk/p5)
	(cs_go_to ps_johnson_walk_and_talk/p6 0.2)
	(cs_face_object 1 (ai_get_object ai_williams))

	(sleep_until b_walk_and_talk_finished 1)
	(ai_cannot_die ai_current_actor false) ; allows johnson to die again after the walk and talk conversation is over

)

;start "walk and talk" sequence for williams
(script command_script cs_williams_walk_and_talk

	;abort if player runs ahead
	(branch
		(> s_conversation_id 4) (cs_kill_command_script)
	)

	(ai_cannot_die ai_current_actor true) ; keeps williams from dying during the walk and talk
	(cs_enable_pathfinding_failsafe false) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck
	(cs_force_combat_status 1)
	(cs_lower_weapon 1) ; lowers weapon
	(cs_walk 1) ; forces williams to walk
	(cs_face_object 1 (ai_get_object ai_johnson))

	(sleep_until b_head_into_settlement 1)
	(sleep (game_ticks_from_seconds 2))
	(cs_face_object 0 (ai_get_object ai_johnson)) ; stop facing johnson
	(cs_face 1 ps_williams_walk_and_talk/p0)
	(cs_go_by ps_williams_walk_and_talk/p0 ps_williams_walk_and_talk/p0)
	(cs_face 0 ps_williams_walk_and_talk/p0)
	(cs_go_by ps_williams_walk_and_talk/p1 ps_williams_walk_and_talk/p1)
	(cs_go_by ps_williams_walk_and_talk/p2 ps_williams_walk_and_talk/p2)
	(cs_go_by ps_williams_walk_and_talk/p3 ps_williams_walk_and_talk/p3)
	(cs_go_by ps_williams_walk_and_talk/p4 ps_williams_walk_and_talk/p4)
	(cs_go_by ps_williams_walk_and_talk/p5 ps_williams_walk_and_talk/p5)
	(cs_go_to ps_williams_walk_and_talk/p6 0.2)
	(cs_face_object 1 (ai_get_object ai_johnson))

	(sleep_until b_walk_and_talk_finished 1)
	(ai_cannot_die ai_current_actor false) ; allows williams to die again after the walk and talk conversation is over

)

(script dormant settlement_ramp_blip

	(sleep_until (= b_settlement_ramp_blip 1) 1)

	(if (volume_test_players tv_settlement_ramp_blip)
		;then
		(begin
			(f_unblip_all)
			(f_blip_flag fl_settlement_ramp_blip 0)
			(print "placed settlement ramp blip")
			(sleep_until (not (volume_test_players tv_settlement_ramp_blip)) 1)
			(f_unblip_flag fl_settlement_ramp_blip)
		)
		;else
		(print "skipped settlement ramp blip")
	)
)


;====================================================================================================================================================================================================
; brute ambush
; beat 1 - encounter 3
;
; description: chief, johnson, and williams happen upon a brute ambush setup.
;====================================================================================================================================================================================================
(global boolean b_brute_ambush_failed 0)
(global boolean b_hero_tele_bruteambush false) ; if false, this will teleport the hero ai back to start if they fall out of the map

(script dormant bruteambush_johnson_failsafe
	;scripts to teleport hero ai back into the playspace if they fall out of the level
	(print "hero_ai_died_active - johnson brute ambush")

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_settlement2 ai_johnson) 1)
			(print "hero_ai_died - johnson brute ambush - teleporting them to set cutscene flag")
			(object_teleport ai_johnson fl_brute_ambush_teleport)
			(= b_hero_tele_bruteambush true)
		)
	1
	)
)

(script dormant bruteambush_williams_failsafe
	;scripts to teleport hero ai back into the playspace if they fall out of the level
	(print "hero_ai_died_active - williams brute ambush")

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_settlement2 ai_williams) 1)
			(print "hero_ai_died - williams brute ambush - teleporting them to set cutscene flag")
			(object_teleport ai_williams fl_brute_ambush_teleport)
			(= b_hero_tele_bruteambush true)
		)
	1
	)
)

(script dormant start_brute_ambush
	(wake brute_ambush_check)

	(sleep_until (volume_test_players tv_ba_williams_runs_ahead) 1)

	;making sure both johnson and williams are alive before running command scripts
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print "johnson runs ahead")
	(cs_run_command_script ai_johnson cs_ba_johnson_run_ahead)
	(print "williams runs ahead")
	(cs_run_command_script ai_williams cs_ba_williams_run_ahead)

	(sleep_until (volume_test_players tv_brute_ambush) 1)

	;unlock the second insertion point
	(print_if b_debug_gameplay "insertion point: ins_e20_settlement_end unlocked")
	(submit_incident "ins_e20_settlement_end")
	(submit_incident_with_custom_string_id "game_activity_begin" "e20")

	(wake teleport_buddies_brute_ambush)

	(ai_erase gr_brute_bowl)

	(ai_place gr_brute_ambush)
	(ai_place gr_brute_ambush2)
	(ai_activity_set sq_brute_ambush_grunts asleep)

	(wake trigger_vo_brute_ambush_cleared)

	;objective setup
	(ai_set_objective ai_johnson obj_brute_ambush)
	(ai_set_objective ai_williams obj_brute_ambush)

	(ai_player_remove_fireteam_squad player0 ai_johnson) ; keeps johnson from following the player
	(ai_player_remove_fireteam_squad player0 ai_williams) ; keeps williams from following the player

	(sleep_until (= (ai_living_count gr_brute_ambush) 0) 1)

	;save game (after the main ambush!)
	(f_game_save) ;save the game

	(sleep_until (= (ai_living_count gr_e11_brute_ambush) 0) 1)

	;have johnson and williams rejoin the fireteam after waves 1 and 2 are clear
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_player_add_fireteam_squad player0 ai_williams)


)

(script command_script cs_ba_johnson_run_ahead
	(cs_abort_on_damage true)

	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(branch
		(or
			(= (ai_living_count sq_brute_ambush_jackal1) 0)
			(= b_brute_ambush_failed true)
		)
		(cs_kill_command_script)
	)

	;johnson heads to the entrance of the brute ambush and waits
	(cs_go_to ps_ba_johnson_wait/p0 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_ba_williams_route) 1)

	(sleep (game_ticks_from_seconds 1)) ; give a little bit of time for player to see williams running ahead

	;johnson stops facing the player and runs up the hill
	(cs_face_player false)
	(cs_go_to ps_ba_johnson_wait/p1 .2)
)

(script command_script cs_ba_williams_run_ahead
	(cs_abort_on_damage true)

	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	;williams heads to the entrance of the brute ambush and waits
	(print "cs_ba_williams_run_ahead - before go to")

	(branch
		(or
			(= (ai_living_count sq_brute_ambush_jackal1) 0)
			(= b_brute_ambush_failed true)
		)
		(cs_kill_command_script)
	)

	(cs_go_to ps_ba_williams_route/p0 .2)
	(cs_face_player true)

	(print "cs_ba_williams_run_ahead - after go to")
	(sleep_until (volume_test_players tv_ba_williams_route) 1)

	(print "cs_ba_williams_run_ahead - after sleep go to")

	;williams stops facing the player and runs up the hill
	(cs_face_player false)
	(cs_go_to ps_ba_williams_route/p1 .2)


	(print "williams will attempt to kill the jackal")

	;williams goes and melees the jackal
	(cs_move_towards sq_brute_ambush_jackal1 1 1)

	;this kills the jackal since williams' melee doesn't kill it reliably.
	(unit_kill sq_brute_ambush_jackal1)

	(sleep_until
		(or
			(= (ai_living_count sq_brute_ambush_jackal1) 0)
			(volume_test_players tv_jackal_jungle)
		)
		1
	)
)

(script command_script cs_be_braindead

	(cs_abort_on_alert true)

	(units_set_current_vitality ai_current_actor 1 1)

	(ai_braindead ai_current_actor true)

)

(script command_script cs_brute_ambush
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_abort_on_alert true)
	(cs_crouch true)
	(cs_aim true ps_ambush_look/p0)
	(sleep_forever)
)

(script dormant brute_ambush_check
	(print "ambush brute checking")
	(sleep_until (objects_can_see_object (ai_actors gr_brute_ambush) player0 .5) 1)
	(print "ambush brute active")
	(if (volume_test_players tv_brute_ambush_trap)
		;then
		(begin
			(set b_brute_ambush_failed 1)
			(print "player failed brute ambush")
		)
		;else
		(print "player succeeded brute ambush")
	)

	;set eye to search jungle area
	(print "set eye objective to search jungle")
	(cs_run_command_script sq_eye_of_prophet cs_eye_jungle)
)

(script command_script cs_ba_johnson_run_to_jj
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_jj_johnson_wait1/p0 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_jungle_zealot_watch) 1)
)

(script command_script cs_ba_williams_run_to_jj
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_jj_johnson_wait1/p1 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_jungle_zealot_watch) 1)
)

;====================================================================================================================================================================================================
; jackal jungle
; beat 1 - encounter 4
;
; description: chief, johnson, and williams enter a jungle filled with jackal snipers.
;====================================================================================================================================================================================================
(global boolean b_jj_spawned 0)
(global boolean b_jj_zealot_erased 0)
(global boolean b_arena_skull_unlock_1 0)

(script dormant start_jackal_jungle

	(sleep_until (volume_test_players tv_jackal_jungle) 1)

	(ai_erase gr_settlement)

	(ai_place gr_jackal_jungle_marines)

	(print "marines joins player's fireteam")
	(ai_player_add_fireteam_squad player0 sq_jackal_jungle_marines)

	(ai_place gr_jackal_jungle_wave1)

	(ai_place gr_jackal_jungle_wave2)

	(ai_place gr_jackal_jungle_zealot)

	(set b_jj_spawned 1) ; confirm that this encounter has started for other scripts that are waiting on it

	;don't let the zealot die during the command
	(ai_cannot_die gr_jackal_jungle_zealot true)
	(ai_disregard (ai_actors sq_jackal_jungle_zealot) true)

	(wake trigger_vo_jackal_jungle_intro)
	(wake trigger_vo_jackal_jungle_fail)
	(wake trigger_vo_jackal_jungle_success)

	;objective setup
	(ai_set_objective gr_settlement_marines obj_jackal_jungle)
	(ai_set_objective ai_johnson obj_jackal_jungle)
	(ai_set_objective ai_williams obj_jackal_jungle)

	;set eye to search jungle area
	(print "set eye objective to search jungle")
	(cs_run_command_script sq_eye_of_prophet cs_eye_jungle)

	;blip last enemies remaining
	(sleep_until (<= (ai_nonswarm_count gr_jackal_jungle) 3) 1)
	(f_blip_ai gr_jackal_jungle 1) ; blip remaining enemies

	(sleep_until (and (= b_jj_spawned 1) (= (ai_nonswarm_count gr_jackal_jungle) 0)) 1)

	(print "unlock big door")
	(device_set_power dm_jungle_bigdoor 1)
	(device_set_position dm_jungle_bigdoor 1)
	(device_set_power dm_jungle_bigdoor2 1)
	(device_set_position dm_jungle_bigdoor2 1)
	(device_set_power dm_jungle_secret2 1)

	; blip waypoint to primary exit door
	(print "placed waypoint at primary exit door")
	(f_unblip_all)
	(f_blip_flag fl_jj_door_open 0)

	(print "unlock secret door")
	;intially ignores player so zealot can use it
	(device_operates_automatically_set dm_jungle_secret true)
	(device_ignore_player_set dm_jungle_secret false)
	(device_set_power dm_jungle_secret 1)

	(wake jj_ai_allies_post_encounter)

	;save game
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_prison_bridge) 1)

	(f_unblip_all)

)

(script dormant jj_ai_allies_post_encounter
	;making sure both johnson and williams are alive before running command scripts
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai command scripts: johnson and williams are alive - running jj command scripts")

	(print "johnson runs to upper exit")
	(cs_queue_command_script ai_johnson cs_jj_johnson_run_to_exit)

	(print "williams and marines run to lower exit")
	(cs_queue_command_script ai_williams cs_jj_williams_run_to_exit)

	(print "marines are removed from fireteam")
	(ai_player_remove_fireteam_squad player0 sq_jackal_jungle_marines/marine0) ; allows the jj marine fireteam to attack the bridge with williams
	(ai_player_remove_fireteam_squad player0 sq_jackal_jungle_marines/marine1)
)

;triggered by the zealot's placement script
(script command_script cs_jungle_zealot_observation
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(wake open_door_zealot)
	(wake first_time_seeing_zealot)
	(sleep_until (volume_test_players tv_jungle_zealot_watch) 1)
	(wake zealot_shield_skull1_monitor)

	;don't let the zealot move until it's done observing
	(print "zealot can not move")
	(cs_enable_moving false)
	(cs_face_player true)

	;sleep until the player enters the area
	(sleep_until (< (object_get_shield (object_get_ai gr_jackal_jungle_zealot)) 1) 1 (game_ticks_from_seconds 15))
	(sleep_forever first_time_seeing_zealot)
	;zealot leaves after shields are damaged
	(print "zealot can move again 1")
	(cs_enable_moving true)
	(cs_face_player false)
	;(cs_go_to_and_face ps_jungle_zealot/p0 ps_jungle_zealot/p1)
	(cs_move_towards_point ps_jungle_zealot/p0 .3)
	(cs_go_to ps_jungle_zealot/p1)
	(sleep_until (= 0 (device_get_position dm_jungle_secret)) 1) ;wait until the door is shut before deleting the zealot
	(sleep_forever zealot_shield_skull1_monitor)
	(ai_erase ai_current_actor)
	(print "set b_jj_zealot_erased to true")
	(set b_jj_zealot_erased true)
	(device_set_power dm_jungle_secret 0) ; set door to locked state again
)
;;; zealot calls attention to his first sighting
(script dormant first_time_seeing_zealot
	(sleep_until (volume_test_players tv_first_sighting_zealot) 1)
	(ai_berserk sq_jackal_jungle_zealot true)

	(sleep (game_ticks_from_seconds 2.5))
	(sound_impulse_start sound\dialog\combat\newelite2\default\09_order\foeordr_advance sq_jackal_jungle_zealot 2)
	(sleep (sound_impulse_time sound\dialog\combat\newelite2\default\09_order\foeordr_advance))
)

(script dormant zealot_shield_skull1_monitor
	;shooting the zealot at the jackal jungle activates the first boolean for the arena skull
	(sleep_until (<= (object_get_shield (object_get_ai gr_jackal_jungle_zealot)) .9) 1)

	(set b_arena_skull_unlock_1 true)

	(print "skull:set b_arena_skull_unlock_1 to true")
)

(script dormant open_door_zealot
	(sleep_until (volume_test_object tv_jungle_zealot_door gr_jackal_jungle_zealot) 1)
	(print "closing door behind zealot")
	(device_set_power dm_jungle_secret 1) ;enable power so door an shut
	(device_set_position dm_jungle_secret 0) ;shut door behind zealot
	(sleep_until (= 0 (device_get_position dm_jungle_secret)) 1) ;wait until the door is shut
	(device_set_power dm_jungle_secret 0) ;disable power behind zealot once door is shut
	(sleep (game_ticks_from_seconds 5))
	(device_ignore_player_set dm_jungle_secret true)

	(sleep_until (volume_test_players tv_jungle_zealot_door_failsafe) 1)
	(print "there is a player in here!!! activate softlock failsafe")
	(sleep (game_ticks_from_seconds 5))
	(device_ignore_player_set dm_jungle_secret false)
)

(script command_script cs_jj_elite_trap_1
	(cs_stow true)
	(ai_set_active_camo ai_current_actor true)
	(cs_abort_on_damage true)

	(sleep_until
		(or
			(<= (ai_living_count gr_jackal_jungle) 6)
			(volume_test_players tv_elite_trap_1)
		)
		1
	)
)

(script command_script cs_jj_elite_trap_2
	(cs_stow true)
	(ai_set_active_camo ai_current_actor true)
	(cs_abort_on_damage true)

	(sleep_until
		(or
			(<= (ai_living_count gr_jackal_jungle) 5)
			(volume_test_players tv_elite_trap_2)
		)
		1
	)
)

(script command_script cs_jj_elite_trap_3
	(cs_stow true)
	(ai_set_active_camo ai_current_actor true)
	(cs_abort_on_damage true)

	(sleep_until
		(or
			(<= (ai_living_count gr_jackal_jungle) 4)
			(volume_test_players tv_elite_trap_3)
		)
		1
	)
)

(script command_script cs_jj_elite_trap_4
	(cs_stow true)
	(ai_set_active_camo ai_current_actor true)
	(cs_abort_on_damage true)

	(sleep_until
		(or
			(<= (ai_living_count gr_jackal_jungle) 3)
			(volume_test_players tv_elite_trap_4)
		)
		1
	)
)

(script command_script cs_jj_elite_trap_5
	(cs_stow true)
	(ai_set_active_camo ai_current_actor true)
	(cs_abort_on_damage true)

	(sleep_until
		(or
			(<= (ai_living_count gr_jackal_jungle) 3)
			(volume_test_players tv_elite_trap_5)
		)
		1
	)
)

(script command_script cs_jj_johnson_run_to_exit
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_jj_johnson_wait2/p0 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_prison_bridge) 1)
)

(script command_script cs_jj_williams_run_to_exit
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_jj_williams_wait/p0 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_prison_bridge) 1)
)

;====================================================================================================================================================================================================
; prison bridge
; beat 1 - encounter 5
;
; description: chief, johnson, and williams must cross a covenant bridge to reach the prison.
;====================================================================================================================================================================================================
(global boolean b_hero_tele_prisonbridge false) ; if false, this will teleport the hero ai back to start if they fall out of the map

(script dormant prisonbridge_johnson_failsafe
	(print "hero_ai_died_active - johnson prison bridge")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (or (volume_test_object tv_fs_under_prison_bridge_1 ai_johnson)(volume_test_object tv_fs_under_prison_bridge_2 ai_johnson)) 1)
			(print "hero_ai_died - johnson prison bridge - teleporting them to set cutscene flag")
			(object_teleport ai_johnson fl_teleport_pb1)
			(= b_hero_tele_prisonbridge true)
		)
	1
	)
)

(script dormant prisonbridge_williams_failsafe
	(print "hero_ai_died_active - williams prison bridge")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (or (volume_test_object tv_fs_under_prison_bridge_1 ai_williams)(volume_test_object tv_fs_under_prison_bridge_2 ai_williams)) 1)
			(print "hero_ai_died - williams prison bridge - teleporting them to set cutscene flag")
			(object_teleport ai_williams fl_teleport_pb1)
			(= b_hero_tele_prisonbridge true)
		)
	1
	)
)

(script dormant start_prison_bridge

	(wake secret_garage)

	;don't spawn the next squad until the jackal jungle encounter is over and the player is inside the jackal jungle area. this keeps the squad from spawning too early.
	(sleep_until (and (= b_jj_spawned 1) (= (ai_living_count gr_jackal_jungle) 0)) 1)

	(ai_player_remove_fireteam_squad player0 ai_johnson) ; keeps johnson from following the player - this lets him snipe from the ridge for a bit.
	(ai_player_remove_fireteam_squad player0 ai_williams) ; keeps williams from following the player - she will attack the bridge on her own

	;(ai_player_remove_fireteam_squad player0 sq_jackal_jungle_marines/marine0) ; allows the jj marine fireteam to attack the bridge with williams
	;(ai_player_remove_fireteam_squad player0 sq_jackal_jungle_marines/marine1)

	(wake teleport_coop_players_prison_bridge_1)
	(wake teleport_coop_players_prison_bridge_2)
	(wake teleport_buddies_prison_bridge)

	(ai_place gr_prison_bridge_wave1)
	(ai_place gr_prison_bridge_sniper)

	;snipers will focus on shooting players rather than picking off marines
	(ai_prefer_target_team gr_prison_bridge_sniper player)

	(sleep_until (volume_test_players tv_prison_bridge) 1)

	;objective setup
	(ai_set_objective gr_jackal_jungle_marines obj_prison_bridge_ext)
	(ai_set_objective ai_johnson obj_prison_bridge_ext)
	(ai_set_objective ai_williams obj_prison_bridge_ext)

	;making sure johnson is alive before running command script
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)

	(print_if b_debug_gameplay "ai command scripts: johnson is alive - running pb snipe command script")

	(print "johnson gets into sniper position")
	(cs_run_command_script ai_johnson cs_pb_johnson_kill_jackal)

	(cs_run_command_script ai_johnson cs_tele_kill_command_script)

	;eye of the prophet looks at the player as they cross the bridge
	(sleep_until (volume_test_players tv_eye_look_bridge) 1)
	;set eye to look at player
	(print "set eye objective to look at player")
	(cs_run_command_script sq_eye_of_prophet cs_eye_look)

	;spawn second wave when player kills enough of first wave or gets close to the monster closet
	(sleep_until
		(or
			(< (ai_living_count gr_prison_bridge) 7)
			(volume_test_players tv_pcheck_on_dam)
		)
		1
	)

	(ai_place gr_prison_bridge_wave2)
	(ai_erase gr_brute_ambush)

	;once the player is halfway across the bridge/dam, have johnson and williams rejoing the fireteam
	(sleep_until (volume_test_players tv_prison_bridge_halfway) 1)

	;make sure all friendly ai is now back in the player's fireteam
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_player_add_fireteam_squad player0 ai_williams)

	(ai_player_add_fireteam_squad player0 sq_jackal_jungle_marines/marine0)
	(ai_player_add_fireteam_squad player0 sq_jackal_jungle_marines/marine1)

)

(script dormant secret_garage
	(sleep_until
		(and
			(<= (object_get_health cr_garage_explosive_crate_1) 0)
			(<= (object_get_health cr_garage_explosive_crate_2) 0)
		)
		1
	)

	(device_set_power dm_prisonpath_large_onesided2 1)
	(device_set_position dm_prisonpath_large_onesided2 1)
	(object_create we_mdg_skull_1)
	(print_if b_debug_gameplay "secret garage unlocked! skull placed!")
)

(script command_script cs_pb_johnson_kill_jackal
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_pb_johnson_snipe/p0 .2)

	;abort command script of jackal is already dead or leaves sniping position
	(if
		(or
			(= (ai_living_count sq_brute_ambush_jackal1) 0)
			(not (volume_test_object tv_pb_sniper_zone sq_prison_bridge_jackal_sniper))
		)
		;then
			(cs_run_command_script ai_johnson cs_tele_kill_command_script)
		;else
		(print "johnson will attempt to kill the jackal")
	)

	;johnson runs up to melee the jackal sniper
	(cs_move_towards sq_prison_bridge_jackal_sniper 1 1)

	;temp - this kills the jackal since johnson's melee doesn't kill it reliably.
	(unit_kill sq_prison_bridge_jackal_sniper)

)

;====================================================================================================================================================================================================
; prison exterior
; beat 1 - encounter 6
;
; description: vehicle bowl combat in front of the prison
;====================================================================================================================================================================================================
(global boolean b_prison_hacking_started 0)
(global boolean b_prison_door_hacked 0)
(global boolean b_arena_skull_unlock_2 0)

(script dormant start_prison_exterior
	(sleep_until (and (= b_jj_spawned 1) (= (ai_living_count gr_jackal_jungle) 0) (volume_test_players tv_prison_exterior_start)) 1)

	(wake teleport_buddies_prison_entrance)

	(ai_place gr_prison_exterior_wave1)
	(ai_place gr_prison_exterior_zealot)
	;don't let the zealot die during the command
	(ai_cannot_die gr_prison_exterior_zealot true)

	(wake vo_prison_exterior_battle_mid)

	(sleep_until (= (ai_living_count sq_prison_bridge_wv1_wraith) 0) 1)

	(f_game_save) ; checkpoint after wraith is destroyed

	(sleep_until (<= (ai_living_count gr_prison_bridge) 4) 1) ;wait for reduced enemy count and the wraith being destroyed

	(ai_place sq_prison_ext_wv2_spirit)
	(ai_place gr_prison_exterior_wave2)
	(vehicle_load_magic (unit_get_vehicle sq_prison_ext_wv2_spirit/pilot_spawn) "fork" (ai_actors gr_prison_exterior_wave2))

	(sleep_until (and (= (ai_living_count gr_prison_ext_defend_door) 0) (= (ai_living_count gr_prison_exterior_wave2) 0)) 1)

	(sleep_until (= (ai_living_count sq_prison_ext_wv2_spirit) 0) 1) ;make sure this spirit has despawned before bringing in the next spirit

	;(wake vo_prison_exterior_battle_end)
	(wake vo_prison_entry)

	(set b_prison_hacking_started 1) ; set this true so enemy squads will change ai objectives to attack the prison entrance

	(f_game_save) ; checkpoint as johnson starts hacking the door

	(wake prison_entrance_buddy_guide)

	(ai_place gr_prison_ext_ghosts_wave2)

	(ai_place sq_prison_exterior_spirit)
	(ai_place gr_prison_exterior_wave3)
	(vehicle_load_magic (unit_get_vehicle sq_prison_exterior_spirit/pilot_spawn) "fork" (ai_actors gr_prison_exterior_wave3))

	(sleep_until (<= (+ (ai_nonswarm_count gr_prison_exterior) (ai_nonswarm_count gr_prison_bridge)) 5) 1)
	(f_blip_ai gr_prison_exterior 1)
	(f_blip_ai gr_prison_bridge 1)

	; blip waypoint to prison entrance if you kill the squad from the drop ship and haven't yet reached the prison entrance
	(sleep_until (= (+ (ai_nonswarm_count gr_prison_exterior) (ai_nonswarm_count gr_prison_bridge)) 0) 1)

	(print "placed waypoint at prison entrance")
	(f_unblip_all)
	(f_blip_flag fl_prison_fight 0)

	;(wake vo_prison_exterior_battle_mid)

	(sleep_until (volume_test_players tv_prison_inside) 1)

	;objective setup
	(ai_set_objective gr_jackal_jungle_marines obj_global_ai_follow)
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(ai_set_objective ai_williams obj_global_ai_follow)

	(sleep_until (volume_test_players tv_prison_room_bottom) 1)
	(f_unblip_all)
)

;triggered by the zealot's placement script
(script command_script cs_prison_entrance_zealot_observation
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_force_combat_status 2)

	;don't let the zealot move until it's done observing
	(print "zealot can not move")
	(cs_enable_moving false)

	;sleep until the player enters the area
	(sleep_until (volume_test_players tv_prison_entrance_watch) 1)
	(wake zealot_shield_skull2_monitor)
	;watch a player for a bit
	(cs_face_player true)

	; sleep until the zealot is shot or a player gets too close.  times out after a period in case neither is done
	(sleep_until (or
				(volume_test_players tv_zealot_flees_into_prison)
				(< (object_get_shield (object_get_ai gr_prison_exterior_zealot)) 1)
				)
				1 (game_ticks_from_seconds 150) ;2 1/2 minutes until timeout
	)
	;zealot leaves after shields are damaged
	(print "zealot can move again 2")
	(cs_face_player false)
	(cs_face true ps_prison_ext_zealot_watch/p2)
	(cs_move_towards_point ps_prison_ext_zealot_watch/p0 .3)
	(device_set_power dm_prison_entrance 1)
	(device_set_position dm_prison_entrance 1)
	(cs_move_towards_point ps_prison_ext_zealot_watch/p1 .3)
	(device_set_position dm_prison_entrance 0)
	(device_set_power dm_prison_entrance 0)
	(cs_go_to ps_prison_ext_zealot_watch/p2)
	(sleep_until (= (device_get_position dm_prison_entrance) 0) 1)
	(device_set_power dm_prison_entrance 0)
	(sleep_forever zealot_shield_skull2_monitor)
	(ai_erase ai_current_actor)
)

(script dormant zealot_shield_skull2_monitor
	;shooting the zealot at the arena activates the third boolean for the arena skull
	(sleep_until (<= (object_get_shield (object_get_ai gr_prison_exterior_zealot)) .9) 1)

	(set b_arena_skull_unlock_2 true)

	(print "skull:set b_arena_skull_unlock_2 to true")
)

(script command_script cs_prison_spirit_wv3_dropoff
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	;blip dropship
	(f_blip_object ai_current_actor 1)

	(cs_fly_by ps_prison_ext_spirit/p0)
	;fly above drop off point
	(cs_fly_to_and_face ps_prison_ext_spirit/p1 ps_prison_ext_spirit/p3_face)
	;descend to drop off point
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_prison_ext_spirit/p2 ps_prison_ext_spirit/p3_face)
	;drop off units
	(unit_open (ai_vehicle_get_from_spawn_point sq_prison_exterior_spirit/pilot_spawn))
	(cs_pause 1)
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_prison_exterior_spirit/pilot_spawn) "fork_p")
	(cs_pause 3)

	;unblip dropship
	(f_unblip_object ai_current_actor)
	(unit_close (ai_vehicle_get_from_spawn_point sq_prison_exterior_spirit/pilot_spawn))
	;fly above drop off point again
	(cs_fly_to_and_face ps_prison_ext_spirit/p1 ps_prison_ext_spirit/p4_face)
	(cs_vehicle_speed 1)
	(cs_fly_to ps_prison_ext_spirit/p0)
	(cs_fly_to ps_prison_ext_spirit/p4_face)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script command_script cs_prison_spirit_wv2_dropoff
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	;blip dropship
	(f_blip_object ai_current_actor 1)

	(cs_fly_by ps_prison_ext_spirit2/p0)
	;fly above drop off point
	(cs_fly_to_and_face ps_prison_ext_spirit2/p1 ps_prison_ext_spirit2/p3_face)
	;descend to drop off point
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_prison_ext_spirit2/p2 ps_prison_ext_spirit2/p3_face)
	;drop off units
	(unit_open (ai_vehicle_get_from_spawn_point sq_prison_ext_wv2_spirit/pilot_spawn))
	(cs_pause 1)
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_prison_ext_wv2_spirit/pilot_spawn) "fork_p")
	(cs_pause 3)

	;unblip dropship
	(f_unblip_object ai_current_actor)
	(unit_close (ai_vehicle_get_from_spawn_point sq_prison_ext_wv2_spirit/pilot_spawn))
	;fly above drop off point again
	(cs_fly_to_and_face ps_prison_ext_spirit2/p1 ps_prison_ext_spirit2/p4_face)
	(cs_vehicle_speed 1)
	(cs_fly_to ps_prison_ext_spirit2/p0)
	(cs_fly_to ps_prison_ext_spirit2/p4_face)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

(script dormant prison_door_open
	(sleep_until (= b_prison_door_hacked 1) 1)
	(device_set_power dm_prison_entrance 1)
	(device_set_position dm_prison_entrance 1)

	;making sure both johnson and williams are alive before teleporting
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	(print_if b_debug_gameplay "ai command scripts: johnson and williams are alive - running prison entrance command scripts")

	(print "johnson runs inside the prison and waits")
	(cs_queue_command_script ai_johnson cs_pe_johnson_run_inside)

	(print "williams runs inside the prison and waits")
	(cs_queue_command_script ai_williams cs_pe_williams_run_inside)
)

(script dormant prison_entrance_buddy_guide

	;making sure both johnson is alive before running prison entrance command script
	(sleep_until (> (object_get_health (object_get_ai ai_johnson)) 0) 1)

	(ai_player_remove_fireteam_squad player0 ai_johnson) ; keeps johnson from following the player
	(ai_player_remove_fireteam_squad player0 ai_williams) ; keeps williams from following the player so she can cover johnson

	;objective setup
	(ai_set_objective gr_jackal_jungle_marines obj_prison_bridge_ext)
	(ai_set_objective ai_williams obj_prison_bridge_ext)

	(ai_cannot_die ai_johnson true) ; ensure johnson doesn't die during the hack sequence

	;eject johnson from vehicle if he's in one
	(if (unit_in_vehicle ai_johnson)
		(unit_exit_vehicle ai_johnson)
	)

	(print_if b_debug_gameplay "ai command scripts: if johnson is in a vehicle, eject him for the prison hack")

	(print "starting hacking sequence")
	(cs_run_command_script ai_johnson cs_prison_entrance_hack)

	(sleep_until (= (ai_living_count gr_prison_exterior) 0) 1)

	;sleep until johnson hacks the door or a certain amount of time passes for a fallback
	(sleep_until (= b_prison_door_hacked 1) 1 (game_ticks_from_seconds 60))
	(if (= b_prison_door_hacked 0)
		(set b_prison_door_hacked 1)
	)

	(f_unblip_all)
	(f_blip_flag fl_prison_opened 0)

	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_player_add_fireteam_squad player0 ai_williams)
)


(script command_script cs_prison_entrance_hack
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck
	(ai_cannot_die ai_current_actor true) ; ensure johnson doesn't die during the hack sequence
	(ai_player_remove_fireteam_squad player0 ai_current_squad) ; enables johnson to walk slow
	(ai_set_objective ai_johnson obj_global_ai_calm)
	(cs_force_combat_status 1)
	(cs_go_to ps_to_prison_entrance_buddy/p3)

	(cs_walk true)

	(cs_go_to ps_to_prison_entrance_buddy/p4_hack_stand)
	(sleep 2)
	(cs_face true ps_to_prison_entrance_buddy/p5_hack_look)
	(sleep (game_ticks_from_seconds 1))

	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true) ;johnson anim starts for hacking device
	(f_attach_hacking_device ai_current_actor)

	(custom_animation_loop ai_johnson "objects\characters\marine\marine" "using_device_loop" true) ;johnson hacking anim continues

	(device_set_position_immediate dm_control_panel_01 0.5) ;vignette machine

	(sleep_until (= (ai_living_count gr_prison_exterior) 0) 1)

	(sleep (game_ticks_from_seconds 1)) ;was3
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true) ;johnson anim ends for hacking device

	(device_set_position_immediate dm_control_panel_01 1) ;vignette machine

	(f_destroy_hacking_device ai_current_actor)
	(cs_walk false)
	(set b_prison_door_hacked 1)
)

(script command_script cs_pe_johnson_run_inside
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck
	(ai_cannot_die ai_current_actor true)
	;eject johnson from vehicle if he's in one
	(if (unit_in_vehicle ai_johnson)
		(unit_exit_vehicle ai_johnson)
	)

	(sleep 2)
	(cs_go_to ps_to_prison_bottom_hack/p2 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_prison_room_bottom) 1)

	;sleep a bit for the queued command script to hit
	(sleep 2)
)

(script command_script cs_pe_williams_run_inside
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	;eject williams from vehicle if she's in one
	(if (unit_in_vehicle ai_williams)
		(unit_exit_vehicle ai_williams)
	)

	(cs_go_to ps_pe_williams_wait/p0 .2)
	(cs_face_player true)

	(sleep_until (= b_prison_bottom_door_hacked 1) 1)
)

;command script to keep the ghosts from hitting the door before it opens - prevents them from flipping
(script command_script cs_patient_ghost
	(ai_braindead ai_current_actor true)

	;wait until door is confirmed open before moving
	(sleep_until (= 1 (device_get_position dm_prisonpath_large_onesided1)) 1)

	(ai_braindead ai_current_actor false)
)

(script command_script cs_enemy_use_turret

	;is turret available and operable?
	(sleep_until (= (is_turret_operable ve_prison_shade) true) 1)

	(sleep 1)

	;go and get in the turret
	(ai_vehicle_enter ai_current_actor ve_prison_shade)

)

(script static boolean (is_turret_operable (vehicle turret))
	(and (> (unit_get_health turret) .25) (not (vehicle_test_seat turret "")) (not (vehicle_overturned turret)))
)

;====================================================================================================================================================================================================
; prison bottom
; beat 1 - encounter 7
;
; description: entry way to the prison were chief meets johnson and williams
;====================================================================================================================================================================================================

(global boolean b_prison_bottom_door_hacked 0)

(script dormant start_prison_bottom
	(sleep_until (volume_test_players tv_prison_inside) 1)
	(ai_set_objective ai_johnson obj_global_ai_calm)
	;unlock the third insertion point
	(print_if b_debug_gameplay "insertion point: ins_e20_prison_start unlocked")
	(submit_incident "ins_e20_prison_start")
	(submit_incident_with_custom_string_id "game_activity_begin" "e20")

	(sleep_until (volume_test_players tv_prison_room_bottom) 1)

	(wake teleport_coop_players_prison_grav_lift)
	(wake teleport_marines_prison_lift)

	;(ai_place gr_prison_room_bottom) ;removing this encounter to give more breathing room between encounters (mtr-61183)

	(object_create gravlift_a_prison)

	;save game
	(game_save_no_timeout) ;checkpoint

	(cs_queue_command_script ai_johnson cs_prison_bottom_hack)

	; wait for johnson to hack the door, but have a failsafe in case he gets stuck of 60 seconds
	(sleep_until (= b_prison_bottom_door_hacked 1) 1 (game_ticks_from_seconds 60))
	(device_set_power dm_prison_bottom 1)
	(device_set_position dm_prison_bottom 1)
	(cs_run_command_script ai_johnson johnson_head_into_chamber)
	(cs_run_command_script ai_williams williams_head_into_chamber)
)

(script command_script cs_prison_bottom_hack
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck
	(ai_cannot_die ai_current_actor true)
	(ai_player_remove_fireteam_squad player0 ai_current_actor)
	(cs_force_combat_status 1)
	(cs_face true ps_to_prison_bottom_hack/p4_hack_stand)
	(sleep (game_ticks_from_seconds 1))
	(cs_walk true)
	(cs_go_to ps_to_prison_bottom_hack/p4_hack_stand)
	(cs_face true ps_to_prison_bottom_hack/p5_hack_look)

	(sleep (game_ticks_from_seconds 1))
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_start" true) ;johnson anim starts for hacking device
	(f_attach_hacking_device ai_current_actor)

	(custom_animation_loop ai_johnson "objects\characters\marine\marine" "using_device_loop" true) ;johnson hacking anim continues

	(device_set_position_immediate dm_control_panel_02 0.5) ;vignette machine

	(sleep (game_ticks_from_seconds 1)) ;was3
	(custom_animation ai_johnson "objects\characters\marine\marine" "using_device_end" true) ;johnson anim ends for hacking device
	;(cs_pause 2)
	(device_set_position_immediate dm_control_panel_02 1) ;vignette machine

	(f_destroy_hacking_device ai_current_actor)
	(unit_stop_custom_animation ai_johnson)

	(ai_cannot_die ai_current_actor false)
	(set b_prison_bottom_door_hacked 1)
)

(script command_script johnson_head_into_chamber
	(ai_cannot_die ai_current_actor true)
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck
	(cs_walk true)
	(cs_force_combat_status 2)
	(cs_face true ps_pe_johnson_transition_in/p0)
	(sleep (game_ticks_from_seconds 1))
	(cs_go_by ps_pe_johnson_transition_in/p0 ps_pe_johnson_transition_in/p0)
	(cs_face false ps_pe_johnson_transition_in/p0)
	(cs_go_to ps_pe_johnson_transition_in/p1)
	(sleep_until (volume_test_players tv_prison_free_the_minions) 1)
	(cs_walk false)
	(ai_player_add_fireteam_squad player0 ai_current_actor)
	(ai_set_objective ai_current_actor obj_global_ai_follow)
	(ai_cannot_die ai_current_actor false)
)

(script command_script williams_head_into_chamber
	(ai_cannot_die ai_current_actor true)
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck
	(cs_go_to ps_pe_williams_transition_in/p0)
	(sleep_until (volume_test_players tv_prison_free_the_minions) 1)
	(ai_player_add_fireteam_squad player0 ai_current_actor)
	(ai_set_objective ai_current_actor obj_global_ai_follow)
	(ai_cannot_die ai_current_actor false)
)

;====================================================================================================================================================================================================
; prison top
; beat 1 - encounter 8
;
; description: top of the grav lift
;====================================================================================================================================================================================================
(script dormant start_prison_top
	(sleep_until (volume_test_players tv_prison_room_top) 1)

	(ai_disposable gr_prison_bridge true)
	(ai_disposable gr_prison_bridge_sniper true)
	(ai_disposable gr_prison_exterior true)

	(print_if b_debug_gameplay "ai disposal: removing remaining enemies from prison bridge and prison exterior")

	(ai_place gr_prison_room_top)

	(cs_run_command_script ai_johnson cs_to_prison_top_buddy_guide)
	(cs_run_command_script ai_williams cs_to_prison_top_buddy_guide)

	(sleep_until (= (ai_living_count gr_prison_room_top) 0) 1)

	(print "johnson runs ahead")
	(cs_queue_command_script ai_johnson cs_johnson_run_ahead)
	(print "williams runs ahead")
	(cs_queue_command_script ai_williams cs_williams_run_ahead)

)

(script command_script cs_to_prison_top_buddy_guide
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_go_to ps_to_prison_bottom_hack/p6)
)


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 											e20 beat 2 - vo and music
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant trigger_vo_prison_entry_interior
	(sleep_until (volume_test_players tv_dialogue_prison_entry_interior) 1)
	(wake vo_prison_entry_interior)
)

(script dormant trigger_vo_observation_start
	(sleep_until (volume_test_players tv_dialogue_observation_start) 1)

	;play music "mus_13_prisoners_dilemma" when chapter 2 title activates
	(wake e20_music_triggers_observation_top)

	;show chapter title for observation
	(f_hud_chapter chapter_e20_2)

	(sleep_until (volume_test_object tv_dialogue_observation_start ai_williams) 1)
	(wake vo_observation_start)
)

(script dormant trigger_vo_marine_cells
	(wake trigger_vo_marine_cells_environmental)
	(wake trigger_vo_marine_cells_start)
	(wake trigger_vo_marine_cells_rally)
)

(script dormant trigger_vo_marine_cells_environmental
	(sleep_until (volume_test_players tv_dialogue_marine_cells) 1)
	(wake vo_marine_cells_environmental)

)

(script dormant trigger_vo_marine_cells_start
	(sleep_until (volume_test_object tv_dialogue_marine_cells ai_williams) 1)
	(wake vo_marine_cells_start)
)

(script dormant trigger_vo_marine_cells_rally
	(sleep_until (= (device_group_get dg_marine_cell_pos) 1) 1)
	(wake vo_marine_cells_rally)

	(print "marines group around johnson for his speech")
	(cs_run_command_script sq_marine_cells_marines/marine0 cs_marine0_johnson_speech)
	(cs_run_command_script sq_marine_cells_marines/marine1 cs_marine1_johnson_speech)
	(cs_run_command_script sq_marine_cells_marines/marine2 cs_marine2_johnson_speech)
)

(script dormant trigger_vo_security
	(sleep_until (volume_test_players tv_dialogue_security_start) 1)
	(wake vo_security_start)
)

(script dormant trigger_vo_armory
	(sleep_until (and (volume_test_players tv_dialogue_armory_start) (= (ai_living_count gr_armory) 0)) 1)
	(wake vo_armory_start)
)

(script dormant trigger_vo_brute_cells

	(sleep_until (volume_test_players tv_dialogue_brute_cells) 1)
	(sleep_until (= (ai_living_count gr_brute_cells_wave1) 0) 1)
	(wake vo_brute_cells_doddle)
)

(script dormant trigger_vo_brute_cages
	(sleep_until (volume_test_object tv_dialogue_brute_cages ai_williams) 1)

	(wake vo_brute_cages_start)
)

(script dormant trigger_vo_arena_start
	(sleep_until (volume_test_players tv_dialogue_arena_start) 1)
	(wake vo_arena_start)
)

(script dormant trigger_vo_arena_marines_alive
	(sleep_until (> (ai_living_count gr_arena_wave1_brutes) 2) 1)
	(if (and (>= (ai_living_count gr_non_hero_marines) 1) (volume_test_objects tv_dialogue_arena_rally (ai_get_object gr_non_hero_marines)))
		;then
		(wake vo_arena_marines_alive)
		;else
		(print "vo_arena_marines_alive did not play since no non-hero marines are alive")
	)
)

(script dormant trigger_vo_arena_end
	(wake vo_arena_end)
)


;====================================================================================================================================================================================================
; beat 2 - encounter 9
;
; description: top of the observation area above the prison cells
;====================================================================================================================================================================================================
(script dormant start_observation_top

	(sleep_until (volume_test_players tv_observation_top) 1)

	;disables hero teleport failsafe code for previous areas
	(print "disabled hero teleport failsafe code for previous areas")
	(set b_hero_tele_start true)
	(set b_hero_tele_settlement true)
	(set b_hero_tele_bruteambush true)
	(set b_hero_tele_prisonbridge true)

	;plays song "mus_14_observation_start" at the start of observation bottom
	(wake e20_music_triggers_observation_bottom)

	(ai_place gr_observation_top)

	(sleep_until (volume_test_players tv_observation_vignette) 1)

	(ai_place gr_observation_vignette)
	(ai_cannot_die gr_observation_vignette true)
	;save game
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_observation_bottom) 1)
	(ai_erase gr_observation_vignette)

)

(script command_script cs_johnson_run_ahead
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_force_combat_status 1)
	(cs_go_to ps_obs_top_run_ahead/p0 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_obs_top_run_ahead) 1)
	(ai_set_objective ai_johnson obj_global_ai_follow)
)

(script command_script cs_williams_run_ahead
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_force_combat_status 1)
	(cs_go_to ps_obs_top_run_ahead/p1 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_obs_top_run_ahead) 1)
	(ai_set_objective ai_williams obj_global_ai_follow)
)

;kennel vignette scripts

;elite left
(script command_script cs_obs_vignette_cov_left
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_walk true)
	(cs_push_stance patrol)
	(cs_pause 2)

	(cs_move_towards sq_obs_vignette_marines/marine_left) ;this won't stop unless the commandscript is terminated
	;(cs_move_towards_point ps_obs_vignette_left/p0 .3)
	;(cs_move_towards_point ps_obs_vignette_left/p1 .3)
	;(cs_move_towards_point ps_obs_vignette_left/p2 .3)
	;(cs_walk false)
	;(cs_move_towards_point ps_obs_vignette_left/p3 .3)
	;(cs_move_towards_point ps_obs_vignette_left/p4 .3)
	;(cs_move_towards_point ps_obs_vignette_left/p5 .3)
	;(cs_move_towards_point ps_obs_vignette_left/p6 .3)
	;(cs_move_towards_point ps_obs_vignette_left/p7 .3)
)

;brute
(script command_script cs_obs_vignette_cov_mid
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_walk true)
	(cs_push_stance patrol)
	(cs_pause 1)

	(cs_move_towards sq_obs_vignette_marines/marine_mid)
	;(cs_move_towards_point ps_obs_vignette_mid/p0 .3)
	;(cs_move_towards_point ps_obs_vignette_mid/p1 .3)
	;(cs_move_towards_point ps_obs_vignette_mid/p2 .3)
	;(cs_move_towards sq_obs_vignette_marines/marine_mid true) ;true will cause brute to melee the marine
	(cs_walk false)
	;(cs_move_towards_point ps_obs_vignette_mid/p3 .3)
	;(cs_move_towards_point ps_obs_vignette_mid/p4 .3)
	;(cs_move_towards_point ps_obs_vignette_mid/p5 .3)
	;(cs_move_towards_point ps_obs_vignette_mid/p6 .3)
	;(cs_move_towards_point ps_obs_vignette_mid/p7 .3)
)

;elite right
(script command_script cs_obs_vignette_cov_right
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_walk true)
	(cs_push_stance patrol)
	(cs_pause 2)

	(cs_move_towards_point ps_obs_vignette_right/p0 .3)
	(cs_move_towards_point ps_obs_vignette_right/p1 .3)
	(custom_animation sq_obs_vignette_cov/brute_right "objects\characters\brute\brute" "armored:pistol:warn" true)
	(cs_move_towards_point ps_obs_vignette_right/p2 .3)
	;(cs_walk false)
	(cs_move_towards_point ps_obs_vignette_right/p3 .3)
	(cs_move_towards_point ps_obs_vignette_right/p4 .3)
	(cs_move_towards_point ps_obs_vignette_right/p5 .3)
	(cs_move_towards_point ps_obs_vignette_right/p6 .3)
	(cs_move_towards_point ps_obs_vignette_right/p7 .3)
)

(script command_script cs_obs_vignette_marines_left
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_walk true)
	;(cs_pause 1)
	(cs_push_stance patrol)

	(cs_move_towards_point ps_obs_vignette_left/p0 .3)
	(cs_move_towards_point ps_obs_vignette_left/p1 .3)
	(cs_move_towards_point ps_obs_vignette_left/p2 .3)
	(sleep (game_ticks_from_seconds 1))
	(cs_move_towards_point ps_obs_vignette_left/p4 .3)
	(cs_move_towards_point ps_obs_vignette_left/p5 .3)
	(cs_move_towards_point ps_obs_vignette_left/p6 .3)
	(cs_move_towards_point ps_obs_vignette_left/p7 .3)
)

(script command_script cs_obs_vignette_marines_mid
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_push_stance patrol)

	(cs_walk true)
	(cs_move_towards_point ps_obs_vignette_mid/p0 .3)
	(cs_walk false)
	(cs_move_towards_point ps_obs_vignette_mid/p1 .3)

	(cs_move_towards_point ps_obs_vignette_mid/p2 .3)

	(cs_move_towards_point ps_obs_vignette_mid/p3 .3)
	(cs_walk true)
	(cs_move_towards_point ps_obs_vignette_mid/p4 .3)
	(cs_move_towards_point ps_obs_vignette_mid/p5 .3)

	(cs_move_towards_point ps_obs_vignette_mid/p6 .3)
	(cs_move_towards_point ps_obs_vignette_mid/p7 .3)
)

(script command_script cs_obs_vignette_marines_right
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_walk true)
	(cs_push_stance patrol)

	(cs_move_towards_point ps_obs_vignette_right/p0 .3)
	(cs_move_towards_point ps_obs_vignette_right/p1 .3)
	(cs_move_towards_point ps_obs_vignette_right/p2 .3)
	(cs_move_towards_point ps_obs_vignette_right/p3 .3)
	(cs_move_towards_point ps_obs_vignette_right/p4 .3)
	(cs_move_towards_point ps_obs_vignette_right/p5 .3)
	(cs_move_towards_point ps_obs_vignette_right/p6 .3)
	(cs_move_towards_point ps_obs_vignette_right/p7 .3)
)

(script command_script cs_obs_vignette_elite_lead

	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(ai_set_active_camo ai_current_actor false) ;deactivate active camo on stealth/spec ops elites


	(cs_push_stance patrol)
    (cs_force_combat_status 2)
	;(ai_squad_patrol_enable sq_obs_vignette_lead true)

	(cs_pause 1)

	(cs_walk true)
	(cs_go_by ps_obs_vignette_lead/p0 ps_obs_vignette_lead/p1 .3)
	(cs_go_by ps_obs_vignette_lead/p2 ps_obs_vignette_lead/p3 .3)
	(cs_go_by ps_obs_vignette_lead/p4 ps_obs_vignette_lead/p5 .3)
	(cs_go_by ps_obs_vignette_lead/p6 ps_obs_vignette_lead/p7 .3)
)

(script command_script cs_ot_grunt_flees
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_force_combat_status 1)

	(sleep_until (volume_test_players tv_observation_top_grunt_flee) 1)
	(ai_flee_from_object sq_observation_top_grunts player0)
)

;====================================================================================================================================================================================================
; beat 2 - encounter 10
;
; description: bottom of the observation area above the prison cells
;====================================================================================================================================================================================================

(global boolean b_emerg_cell_opened 0)

(global boolean b_johnson_speech_end 0)

(script dormant start_observation_bottom

	(wake teleport_coop_players_obs_bottom_hall)

	(wake emerg_cell_open_check)

	(sleep_until (volume_test_players tv_observation_bottom) 1)

	(wake teleport_buddies_obs_bottom)

	(ai_place gr_observation_bottom_wave1)

	;spawn in second wave when player kills enough of the first wave or when getting close to wave 2 spawn
	(sleep_until
		(or
			(<= (ai_living_count gr_observation_bottom_wave1) 3)
			(volume_test_players tv_observation_wave2)
		)
		1
	)

	(ai_place gr_observation_bottom_wave2)

	(ai_erase gr_prison_room_bottom)

	(sleep_until (= (ai_living_count gr_observation_bottom_wave2) 0) 1)

	(device_set_power dm_covdoor_prison22 1)

	(print "johnson runs to marine cells")
	(cs_queue_command_script ai_johnson cs_johnson_runs_to_marine_cells)
	(print "williams runs to marine cells")
	(cs_queue_command_script ai_williams cs_williams_runs_to_marine_cells)

)

(script command_script cs_obs_elite_opening_brute_cells
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_action_at_player ai_action_point)
	(cs_go_to_and_face ps_obs_bottom/p0_stand ps_obs_bottom/p1_face)
	(cs_action_at_object dc_brute_emerg_cell_control ai_action_point)
	;(cs_stow true)
	(cs_pause 1)
	(device_group_set dc_brute_emerg_cell_control dg_brute_emerg_cell_pos 1)
	(device_group_set dc_brute_emerg_cell_control dg_brute_emerg_cell_pow 0)
	(sound_impulse_start sound\dialog\combat\newelite1\default\09_order\newordr_advance ai_current_actor 1)
)

(script dormant emerg_cell_open_check
	(sleep_until (= (device_group_get dg_brute_emerg_cell_pos) 1) 1)
	(print "emergency brute cell opened")
	;will cause the task condition to be false so the ai will go to another task
	(set b_emerg_cell_opened 1)
	(ai_prefer_target_team gr_obs_emergency_brutes human)
)

(script command_script cs_brute_stand_at_ready
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(custom_animation_loop ai_current_actor "objects\characters\brute\brute" "berserk:unarmed:idle" true)
	(sleep_until b_emerg_cell_opened 1)
	(sleep (game_ticks_from_seconds 1.5))
	(unit_stop_custom_animation ai_current_actor)
	(ai_berserk ai_current_actor true)
)

;====================================================================================================================================================================================================
; beat 2 - encounter 11 prep
;
; description: nav points guiding player to the marine cells
;====================================================================================================================================================================================================
(script dormant start_marine_cells_prep

	(sleep_until (volume_test_players tv_marine_cells_door_nav) 1)

	(f_blip_flag navpoint_marine_cells 0)

	(sleep_until (volume_test_players tv_marine_cells_door_nav_end) 1)

	(f_unblip_flag navpoint_marine_cells)
	(f_unblip_all)
	(f_blip_flag navpoint_marine_cells_console_1 0)

)

;====================================================================================================================================================================================================
; beat 2 - encounter 11
;
; description: the cell where the marines are held after the cells are opened
;====================================================================================================================================================================================================
(global boolean b_marine_cells_opened 0)

(global boolean b_marine_cells_exit_blip 0)

(script dormant start_marine_cells

	(sleep_until (volume_test_players tv_marine_cells) 1)

	(sleep_until (= (ai_living_count gr_observation_bottom_wave2) 0) 1)

	(print "johnson runs to marine cells")
	(cs_queue_command_script ai_johnson cs_johnson_runs_to_marine_cells)
	(print "williams runs to marine cells")
	(cs_queue_command_script ai_williams cs_williams_runs_to_marine_cells)

	(ai_place gr_marine_cells_marines)

	;objective setup
	;(ai_set_objective gr_settlement_marines obj_marine_cells)
	;(ai_set_objective gr_jackal_jungle_marines obj_marine_cells)
	;(ai_set_objective gr_marine_cells_marines obj_marine_cells)
	;(ai_set_objective ai_johnson obj_marine_cells)
	;(ai_set_objective ai_williams obj_marine_cells)


	(sleep_until (= (device_group_get dg_marine_cell_pos) 1) 1)

	(f_unblip_all)


	;save game
	(sleep_until (volume_test_players tv_marine_cells_save) 1)
	(game_save_no_timeout) ;checkpoint

	; sleeps until johnson sppech ends or if player tries to leave early.
	; marines join fireteam. johnson and williams follow again.
	(sleep_until (or (= b_marine_cells_opened 1) (volume_test_players tv_marine_cells_spawn_elites)) 1)

	(set b_marine_cells_opened 1)

	; skips johnson speech if player enters arena before dialogue triggers
	(if (< s_conversation_id 11) (set s_conversation_id 11))

	;abort command scripts for johnson speech if player moves ahead
	(cs_run_command_script ai_johnson cs_tele_kill_command_script)
	(cs_run_command_script ai_williams cs_tele_kill_command_script)
	(cs_run_command_script gr_marine_cells_marines cs_tele_kill_command_script)
	(cs_run_command_script gr_jackal_jungle_marines cs_tele_kill_command_script)

	;objective setup
	(ai_set_objective gr_marine_cells_elites obj_marine_cells)
	(ai_set_objective gr_jackal_jungle_marines obj_global_ai_follow)
	(ai_set_objective gr_marine_cells_marines obj_global_ai_follow)
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(ai_set_objective ai_williams obj_global_ai_follow)
	(ai_player_add_fireteam_squad player0 sq_marine_cells_marines)

	(wake e20_music_triggers_marine_cells) ; starts music for marine cells, security, and armory

	;elites spawn after dialogue when leaving room
	(sleep_until (and b_marine_cells_opened (volume_test_players tv_marine_cells_spawn_elites) 1) 1)

	(ai_place gr_marine_cells_elites)
	(device_set_power dm_to_security 1)

	;set boolean when prison elites die
	(sleep_until (= (ai_living_count gr_marine_cells_elites) 0) 1)

	(set b_marine_cells_exit_blip 1)
	(wake marine_cells_exit_blip)

)

(script command_script cs_johnson_runs_to_marine_cells
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	;get in position and lower weapon for speech
	(cs_force_combat_status 1)
	(cs_go_to ps_johnson_speech/p_johnson)
	(cs_push_stance patrol)

	;johnson faces the marines for his speech
	(cs_face true ps_johnson_speech/p_johnson_face)

	;williams talks to chief, so johnson looks at williams
	(sleep_until (= b_mcr_lt_looks_at_mc 1) 1)
	(cs_look_object 1 (ai_get_object ai_williams))

	;johnson faces chief to talk to him
	(sleep_until (= b_mcr_sgt_looks_at_mc 1) 1)
	(cs_face_player 1)

	;speech sequence over, back to gameplay
	(sleep_until (= b_marine_cells_opened 1) 1)
	(cs_face_player 0)
)

(script command_script cs_williams_runs_to_marine_cells
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	;get in position and lower weapon for speech
	(cs_force_combat_status 1)
	(cs_go_to ps_johnson_speech/p_williams)
	(cs_push_stance patrol)

	;williams faces the marines
	(cs_face true ps_johnson_speech/p_johnson_face)

	;williams faces chief for her comment
	(sleep_until (= b_mcr_lt_looks_at_mc 1) 1)
	(cs_face_player 1)

	;williams faces johnson for when he speaks to chief
	(sleep_until (= b_mcr_sgt_looks_at_mc 1) 1)
	(cs_look_object 1 (ai_get_object ai_johnson))

	;williams faces chief for his response to johnson
	(sleep_until (= b_mcr_all_look_at_mc 1) 1)
	(cs_look_player 1)

	;speech sequence over, back to gameplay
	(sleep_until (= b_marine_cells_opened 1) 1)
)

(script command_script cs_marine0_johnson_speech
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(sleep (game_ticks_from_seconds 1))

	;get in position for speech
	(cs_stow true)
	(cs_push_stance patrol)
	(cs_go_to ps_johnson_speech/p_marine0)

	;face johnson for speech
	(cs_face_object 1 (ai_get_object ai_johnson))

	;marines face williams for her comment
	(sleep_until (= b_mcr_lt_looks_at_mc 1) 1)
	(cs_look_object 1 (ai_get_object ai_williams))

	;marines face johnson for when he speaks to chief
	(sleep_until (= b_mcr_sgt_looks_at_mc 1) 1)
	(cs_look_object 1 (ai_get_object ai_johnson))

	;marines face chief for his response to johnson
	(sleep_until (= b_mcr_all_look_at_mc 1) 1)
	(cs_face_player 1)

	;speech sequence over, back to gameplay
	(sleep_until (= b_marine_cells_opened 1) 1)
)

(script command_script cs_marine1_johnson_speech
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(sleep (game_ticks_from_seconds 1))

	;get in position for speech
	(cs_stow true)
	(cs_push_stance patrol)
	(cs_go_to ps_johnson_speech/p_marine1)

	;face johnson for speech
	(cs_face_object 1 (ai_get_object ai_johnson))

	;marines face williams for her comment
	(sleep_until (= b_mcr_lt_looks_at_mc 1) 1)
	(cs_look_object 1 (ai_get_object ai_williams))

	;marines face johnson for when he speaks to chief
	(sleep_until (= b_mcr_sgt_looks_at_mc 1) 1)
	(cs_look_object 1 (ai_get_object ai_johnson))

	;marines face chief for his response to johnson
	(sleep_until (= b_mcr_all_look_at_mc 1) 1)
	(cs_face_player 1)

	;speech sequence over, back to gameplay
	(sleep_until (= b_marine_cells_opened 1) 1)
)

(script command_script cs_marine2_johnson_speech
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(sleep (game_ticks_from_seconds 1))

	;get in position for speech
	(cs_stow true)
	(cs_push_stance patrol)
	(cs_go_to ps_johnson_speech/p_marine2)

	;face johnson for speech
	(cs_face_object 1 (ai_get_object ai_johnson))

	;marines face williams for her comment
	(sleep_until (= b_mcr_lt_looks_at_mc 1) 1)
	(cs_look_object 1 (ai_get_object ai_williams))

	;marines face johnson for when he speaks to chief
	(sleep_until (= b_mcr_sgt_looks_at_mc 1) 1)
	(cs_look_object 1 (ai_get_object ai_johnson))

	;marines face chief for his response to johnson
	(sleep_until (= b_mcr_all_look_at_mc 1) 1)
	(cs_face_player 1)

	;speech sequence over, back to gameplay
	(sleep_until (= b_marine_cells_opened 1) 1)
)

; blip for armory after prison elites die unless players are already heading towards or are beyond the armory
(script dormant marine_cells_exit_blip

	(sleep_until (= b_marine_cells_exit_blip 1) 1)

	(if (volume_test_players tv_marine_cells_exit_blip)
		;then
		(begin
			(f_unblip_all)
			(f_blip_flag fl_marine_cells_exit_blip 0)
			(print "marine cells exit blip")
		)
		;else
		(print "skipped marine cells exit blip")
	)

	(sleep_until (volume_test_players tv_marine_cells_exit_unblip) 1)
	(f_unblip_all)

)

(script command_script cs_marine_cell_elites_move_helper
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_move_towards_point ps_marine_cells/p0 .3)
)

(script command_script cs_stare_at_chief_until_cell_open
	(cs_face_player 1)
	(sleep_until (= (device_group_get dg_marine_cell_pos) 1) 1)
)

;====================================================================================================================================================================================================
; beat 2 - encounter 12
;
; description: the security room after the marine cells
;====================================================================================================================================================================================================
(script dormant start_security_room

	(sleep_until (volume_test_players tv_security_room) 1)

	(ai_place gr_security_room)

	(ai_erase gr_prison_room_top)

	(sleep_until (= (ai_living_count gr_security_room) 0) 1)

	(print "johnson runs ahead to the armory")
	(ai_set_objective ai_johnson obj_armory)
	(print "williams runs ahead to the armory")
	(ai_set_objective ai_williams obj_armory)

	(sleep_until (volume_test_players tv_large_hallway_unblip) 1)

	(f_unblip_all)

)

;====================================================================================================================================================================================================
; beat 2 - encounter 13
;
; description: the armory where humnan gladiators are armed with unsc weapons for the fight ahead in the arena
;====================================================================================================================================================================================================
(script dormant start_armory

	(sleep_until (volume_test_players tv_armory) 1)

	(ai_place gr_armory)

	(sleep_until (= (ai_living_count gr_armory) 0) 1)

	(wake marine_security_weapon_pickup)

	(print "johnson runs to the armory exit and waits")
	(cs_queue_command_script ai_johnson cs_armory_johnson_wait)
	(print "williams runs to the armory exit and waits")
	(cs_queue_command_script ai_williams cs_armory_williams_wait)

	(device_set_power dm_covdoor_prison26 0)
	(device_set_power dm_covdoor_prison27 0)

	;save game
	(sleep_until (= (ai_living_count gr_armory) 0) 1)

	(print "johnson runs ahead to the armory")
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(print "williams runs ahead to the armory")
	(ai_set_objective ai_williams obj_global_ai_follow)

	(f_game_save) ;save the game

)

(script dormant marine_security_weapon_pickup
	(cs_run_command_script sq_marine_cells_marines/marine0 cs_marine_weapon_pickup)
	(cs_run_command_script sq_marine_cells_marines/marine1 cs_marine_weapon_pickup)
	(cs_run_command_script sq_marine_cells_marines/marine2 cs_marine_weapon_pickup)
)

(script command_script cs_marine_weapon_pickup
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_weapon_pickup/p0 .2)
	(unit_add_equipment ai_current_actor psp_marines_cell_ar true true)
)

(script command_script cs_armory_johnson_wait
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_arm_johnson_wait/p0)
	(cs_face_player true)
	(sleep_until (volume_test_players tv_large_hallway_unblip) 1)
)

(script command_script cs_armory_williams_wait
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_arm_johnson_wait/p1)
	(cs_face_player true)
	(sleep_until (volume_test_players tv_large_hallway_unblip) 1)
)

;====================================================================================================================================================================================================
; beat 2 - encounter 14
;
; description: hallway leading to the brute cells
;====================================================================================================================================================================================================
(script dormant start_large_hallway

	(sleep_until (volume_test_players tv_large_hallway) 1)

	(ai_place gr_large_hallway)

	(sleep_until (volume_test_players tv_large_hallway_wave2) 1)

	(ai_place gr_large_hallway_wave2)

	(ai_erase gr_observation_top)


	(sleep_until (= (ai_living_count sq_large_hallway_jackals) 0) 1)

	(print "johnson runs ahead to the end of the large hallway")
	(ai_set_objective ai_johnson obj_large_hallway)
	(print "williams runs ahead to the end of the large hallway")
	(ai_set_objective ai_williams obj_large_hallway)

	(sleep_until (volume_test_players tv_brute_cells_junction) 1)

	(print "set johnson back to follow")
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(print "set williams back to follow")
	(ai_set_objective ai_williams obj_global_ai_follow)
)

;====================================================================================================================================================================================================
; beat 2 - encounter 15
;
; description: the cells were the brutes are kept
;====================================================================================================================================================================================================
(global boolean b_brute_cells_exit_blip 0)

(global boolean b_leave_brute_cells 0)

(global boolean b_shipping_line_end 0)

(script dormant start_brute_cells

	(sleep_until (volume_test_players tv_brute_cells) 1)

	(ai_place gr_brute_cells_wave1)

	(sleep_until (< (ai_living_count gr_brute_cells) 2) 1)

	(ai_place gr_brute_cells_wave2)
	(device_set_power dm_covdoor_prison27 1)

	(sleep_until (< (ai_living_count gr_brute_cells) 2) 1)

	(ai_erase gr_observation_bottom)

	;set boolean when brute prison enemies die
	(sleep_until (= (ai_living_count gr_brute_cells_wave2) 0) 1)

	(set b_brute_cells_exit_blip 1)
	(wake brute_cells_exit_blip)
	(device_set_power dm_covdoor_prison29 1)

	;save game
	(f_game_save) ;save the game
)

; blip for armory after pre-arena enemies die unless players are already heading towards or are beyond the pre-arena exit
(script dormant brute_cells_exit_blip

	(sleep_until (= b_brute_cells_exit_blip 1) 1)

	(if (volume_test_players tv_brute_cells_exit_blip)
		;then
		(begin
			(f_unblip_all)
			(f_blip_flag fl_brute_cells_exit_blip 0)
			(print "brute cells exit blip")
		)
		;else
		(print "skipped brute cells exit blip")
	)

	(sleep_until (volume_test_players tv_brute_cells_leave) 1)

	(print "johnson runs to the pre-arena window")
	(cs_run_command_script ai_johnson cs_pre_arena_johnson)
	(print "williams runs to the pre-arena window")
	(cs_run_command_script ai_williams cs_pre_arena_williams)

	(sleep_until (volume_test_players tv_brute_cells_exit_unblip) 1)
	(f_unblip_all)

)

(script command_script cs_pre_arena_johnson
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_force_combat_status 1)
	(cs_go_to ps_williams_vo/p1)
	(cs_face true ps_williams_vo/p2)
	(sleep_until b_shipping_line_end 1)
)

(script command_script cs_pre_arena_williams
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_force_combat_status 1)
	(cs_go_to ps_williams_vo/p0)
	(cs_face true ps_williams_vo/p2)
	(sleep_until b_shipping_line_end 1)
)

;====================================================================================================================================================================================================
; beat 2 - encounter 16
;
; description: the hall leading up to the brute arena
;====================================================================================================================================================================================================
(script dormant start_pre_arena

	(wake teleport_coop_players_pre_arena)

	(sleep_until (volume_test_players tv_pre_arena) 1)

	;failsafes if johnson or williams aren't making it to pre arena
	;(wake teleport_prearena_failsafe_johnson)
	;(wake teleport_prearena_failsafe_williams)

	(ai_place gr_pre_arena)

	(ai_erase gr_security_room)

	(sleep_until (= b_shipping_line_end 1) 1 (volume_test_players tv_arena_unblip))

	(f_unblip_all)
	(f_blip_flag fl_arena_blip 0)
	(device_set_power dm_covdoor_prison28 1)
	(device_set_power dm_covdoor_prison30 1)
	(device_set_power dm_covdoor_prison9 1)

	(game_save_no_timeout) ;checkpoint

	; skips williams dialogue about brutes marked for shipping if player enters arena before dialogue triggers
	(set s_conversation_id 13)
	(set b_shipping_line_end 1)

	(print "set johnson back to follow")
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(print "set williams back to follow")
	(ai_set_objective ai_williams obj_global_ai_follow)

	(sleep_until (volume_test_players tv_arena_unblip) 1)

	(f_unblip_all)

	(sleep_until (= (ai_living_count gr_brute_cells_wave2) 0) 1)

	(print "johnson runs to and waits by the hallway to the arena")
	(cs_run_command_script ai_johnson cs_arena_johnson_wait)
	(print "williams runs to and waits by the hallway to the arena")
	(cs_run_command_script ai_williams cs_arena_williams_wait)
)

(script command_script cs_arena_johnson_wait
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_arena_wait/p1)
	(cs_face_player true)
	(sleep_until (or (volume_test_players tv_arena) (volume_test_players tv_arena2)) 1)
)

(script command_script cs_arena_williams_wait
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_arena_wait/p0)
	(cs_face_player true)
	(sleep_until (or (volume_test_players tv_arena) (volume_test_players tv_arena2)) 1)
)

;====================================================================================================================================================================================================
; beat 2 - encounter 17
;
; description: the brute arena in the prison
;====================================================================================================================================================================================================
(global boolean b_arena_skull_unlock_3 0)

(script dormant start_arena

	(wake e20_music_triggers_arena) ; starts music for the arena

	(print "****** encounter 17 - arena")
	(sleep_until (volume_test_players tv_arena) 1)

	;have johnson abandon all command scripts so they don't get stuck
	(cs_run_command_script ai_johnson cs_tele_kill_command_script)
	(cs_run_command_script ai_williams cs_tele_kill_command_script)

	(f_game_save) ; checkpoint

	;objective setup
	(ai_set_objective gr_jackal_jungle_marines obj_arena)
	(ai_set_objective gr_marine_cells_marines obj_arena)
	(ai_set_objective ai_johnson obj_arena)
	(ai_set_objective ai_williams obj_arena)

	;set eye to look at player
	(print "set eye objective to look at player")
	(cs_run_command_script sq_eye_of_prophet cs_eye_look)

	(ai_place gr_arena_zealot)
	;don't let the zealot die during the command
	(ai_cannot_die gr_arena_zealot true)
	(sleep (game_ticks_from_seconds 2))

	(print "arena wave 1")
	(ai_place gr_arena_wave1_brutes)
	(ai_place gr_arena_wave1_jackals)
	(ai_place gr_arena_wave1_grunts)
	(wake trigger_vo_arena_marines_alive)


	(sleep_until (< (ai_living_count gr_arena) 2) 1)

	(print "arena wave 2")
	(ai_place gr_arena_wave2)

	(sleep_until (<= (ai_living_count gr_arena) 2) 1)

	(print "arena wave 3")
	(ai_place gr_arena_wave3)

	(sleep_until (<= (ai_living_count gr_arena) 3) 1)

	(print "arena wave final")
	(ai_place gr_arena_wave4_final_elite)

	;the arena boss will focus on the player rather than marines
	(ai_prefer_target_team gr_prison_bridge_sniper player)

	(sleep_until (<= (ai_nonswarm_count gr_arena) 3) 1)
	(f_blip_ai gr_arena_wave1 1)
	(f_blip_ai gr_arena_wave2 1)
	(f_blip_ai gr_arena_wave3 1)
	(f_blip_ai gr_arena_wave4_final_elite 1)

	(wake arena_skull_check) ; spawn the skull at the end of the encounter if the conditions are met

	(sleep_until (= (ai_nonswarm_count gr_arena) 0) 1)

	(wake trigger_vo_arena_end)

	(sleep_until (= b_arena_end_johnson_line 1)  1)

	(print "arena exit opened")
	(device_set_power dm_arena_exit 1)

	(print "johnson runs to and waits in the hallway leading to the grav bridge")
	(cs_queue_command_script ai_johnson cs_post_arena_johnson_wait)
	(print "williams runs to and waits in the hallway leading to the grav bridge")
	(cs_queue_command_script ai_williams cs_post_arena_williams_wait)

	;objective setup
	(ai_set_objective gr_jackal_jungle_marines obj_global_ai_follow)
	(ai_set_objective gr_marine_cells_marines obj_global_ai_follow)
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(ai_set_objective ai_williams obj_global_ai_follow)

	(ai_erase gr_large_hallway)

	;save game
	(game_save_no_timeout) ;checkpoint

	(sleep_until (volume_test_players tv_arena_exit_unblip) 1)
	(device_set_position_immediate dm_gravity_bridge_e20_enter 1) ;this activates the gravity bridge the player sees when they enter the area
	(f_unblip_all)

)

(script dormant arena_skull_check
;if the player shoots the zealot every time it appears before you face it in the final battle, the arena skull will spawn between the antennas at the center of the arena.
	(print "skull: secret arena skull check started!")
	(sleep_until
		(and
				(= b_arena_skull_unlock_1 true)
				(= b_arena_skull_unlock_2 true)
				(= b_arena_skull_unlock_3 true)
				(= (ai_living_count gr_arena) 0)
		)
	1 )

	(object_create we_mdg_skull_2)
	(print "skull: secret arena skull unlocked! skull placed!")
)

;triggered by the zealot's placement script
(script command_script cs_arena_zealot_observation
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(sleep_until (volume_test_players tv_arena_zealot_watch) 1)
	(wake zealot_shield_skull3_monitor)
	;don't let the zealot move until it's done observing
	(print "zealot can not move")
	(cs_enable_moving false)
	(cs_face_player true)
	(ai_berserk sq_arena_zealot true)

	(sleep (game_ticks_from_seconds 2.5))
	;zealot gestures to his elites to jump into the arena
	(cs_action_at_player ai_action_point)
	(set b_trigger_arena_ambush true)
	(ai_place gr_arena_wave1_elites)

	(sleep (game_ticks_from_seconds 1))
	(sound_impulse_start sound\dialog\combat\newelite2\default\09_order\newordr_advance sq_arena_zealot 2)
	(sleep (sound_impulse_time sound\dialog\combat\newelite2\default\09_order\newordr_advance))

	;sleep until the player shoots the zealot or the sleep times out
	(sleep_until (< (object_get_shield (object_get_ai gr_arena_zealot)) 1) 1 (game_ticks_from_seconds 10))
	(cs_pause 2)

	;zealot leaves after shields are damaged
	(print "zealot can move again 3")
	(cs_enable_moving true)
	(cs_face_player false)
	(cs_move_towards_point ps_arena_zealot/p0 .3)
	(cs_move_towards_point ps_arena_zealot/p1 .3)
	(sleep_forever zealot_shield_skull3_monitor)
	(ai_erase ai_current_actor)
)

(script dormant zealot_shield_skull3_monitor
	;shooting the zealot at the arena activates the third boolean for the arena skull
	(sleep_until (<= (object_get_shield (object_get_ai gr_arena_zealot)) .9) 1)

	(set b_arena_skull_unlock_3 true)

	(print "skull: set b_arena_skull_unlock_3 to true")
)


(script command_script cs_arena_elite_left
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_move_towards_point ps_arena_zealot/p2 .3)
	(cs_move_towards_point ps_arena_zealot/p4 1)
)

(script command_script cs_arena_elite_right
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_move_towards_point ps_arena_zealot/p3 .3)
	(cs_move_towards_point ps_arena_zealot/p5 1)
)

(script command_script cs_arena_jump2_left
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_move_towards_point ps_arena_jump2/p2 .3)
	(cs_move_towards_point ps_arena_jump2/p4 1)
)

(script command_script cs_arena_jump2_right
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_move_towards_point ps_arena_jump2/p3 .3)
	(cs_move_towards_point ps_arena_jump2/p5 1)
)

(script command_script cs_arena_jump3_left
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_move_towards_point ps_arena_jump3/p2 .3)
	(cs_move_towards_point ps_arena_jump3/p4 1)
)

(script command_script cs_arena_jump3_right
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	(cs_move_towards_point ps_arena_jump3/p3 .3)
	(cs_move_towards_point ps_arena_jump3/p5 1)
)

(script command_script cs_post_arena_johnson_wait
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_post_arena_wait/p1)
	(cs_face_player true)
	(sleep_until (volume_test_players tv_post_arena_follow) 1)
)

(script command_script cs_post_arena_williams_wait
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_post_arena_wait/p0)
	(cs_face_player true)
	(sleep_until (volume_test_players tv_post_arena_follow) 1)
)

;====================================================================================================================================================================================================
; flavor scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
; flavor scripts are rumbles, explosions etc - one-off things with no implication for gameplay

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; e20 beat 3 - mind the gap
;
; description: after escaping the prison mc and group make their way to the lodge
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant e20_beat_3
	;(sleep_until (volume_test_players tv_start_beat_3) 1)

    (print_if b_debug_gameplay "starting beat 3")

	;(wake title_beat_3)

	;erase any ai from previous beats
	;destroy any objects or folders from previous beats
	;place any ai for this beat
	;create any objects or folders for this beat

    ; mission logic goes here
)


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 											e20 beat 3 - vo and music
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant trigger_vo_bridge_approach
	(sleep_until
		(or
			(volume_test_players tv_to_bridge1_buddy)
			(= (ai_living_count gr_post_arena) 0)
		)
	1)
	(if (= b_grav_bridge1_hacked 0)
		(wake vo_bridge_approach)
	)

	; ai_set_objective section was moved to start_post_arena as vo trigger changed; same logic though
	; (sleep_until (= (ai_living_count gr_post_arena_wave1) 0) 1)
	; (if (= b_grav_bridge1_hacked 0)
	; 	;then
	; 	(begin
	; 		(sleep (game_ticks_from_seconds 2))
	; 		(wake vo_bridge_approach)
	; 		(print "williams tells the player that the switch activates the bridge")
	; 		(sleep (game_ticks_from_seconds 10))
	; 		(ai_set_objective ai_williams obj_post_arena_marine_buddies)
	; 	)
	; 	;else
	; 	(print "no nav or vo needed for bridge switch since player already pressed it")
	; )
)

(script dormant trigger_vo_bridge_first_gap
	(sleep_until (volume_test_players tv_dialogue_bridge_first_gap) 1)
	(wake vo_bridge_first_gap)
)

(script dormant trigger_vo_bridge_start
	(sleep_until (volume_test_players tv_dialogue_bridge_start) 1)
	(wake vo_bridge_start)
	;(set mark_bridge true) ; show objective about crossing the grav bridge and surviving the banshee assault
)

; unlocking the second bridge panel - enc 16
(script dormant trigger_vo_bridge_second_gap
	(wake vo_bridge_second_gap)
	(wake e20_music_triggers_grav_bridge_end) ;end grav bridge combat music

)

(script dormant trigger_vo_encounter_20_is_go
	(sleep_until (volume_test_players tv_dialogue_encounter_20_is_go) 1)
	(wake vo_encounter_20_is_go)
)

(script dormant trigger_vo_beat4_marine_spawn
	(sleep_until
		(or
			(volume_test_players tv_dialogue_beat4_marine_spawn)
			(= 0 (ai_living_count gr_old_arena))
		)
	1)
	(wake vo_beat4_marine_spawn)
)

(script dormant trigger_vo_command_hvt_spawned
	(wake vo_command_hvt)
)

; final cinematic for the level.  triggers when encounter 23 is defeated
(script dormant trigger_final_cinematic
	;unlock e30
	(print_if b_debug_gameplay "level unlock: e30 is unlocked")


	;unlock e30
	(submit_incident "unlock_e30")
	;unlock the first insertion point for e30
	(print_if b_debug_gameplay "insertion point:ins_e30_start unlocked")
	(submit_incident "ins_e30_start")

	;music
	(set s_music_trigger_e20 280) ; play mus_28_outro_cinematic

	(submit_incident_with_custom_string_id "game_activity_end_completed" "e20")
	(set b_cinematic_lower_weapon true)
	(f_play_cinematic cinematics\e20\e20_split.cinematic)
	(set b_cinematic_lower_weapon false)
	(game_won)
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 												beat 3 - encounters
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; e20 chapter - mind the gap
; beat 3 - encounter 18 spawning
; location - post arena
; inserion point - ins_pre_bridge
; zone set - set_lodge
; description: chief and johnson fight the covenant while williams extends the first light bridge
;====================================================================================================================================================================================================

(global boolean b_grav_bridge1_hacked 0)

(global boolean b_control_exterior_spawn 0)

(global boolean b_hero_tele_gravbridge1 false) ; if false, this will teleport the hero ai back to start if they fall out of the map

(script dormant gravbridge1_johnson_failsafe
	(print "hero_ai_died_active - johnson grav bridge 1")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_grav_bridge ai_johnson) 1)
			(print "hero_ai_died - johnson grav bridge 1 - teleporting them to set cutscene flag")
			(object_teleport ai_johnson fl_post_arena_teleport)
			(= b_hero_tele_gravbridge1 true)
		)
	1
	)
)

(script dormant gravbridge1_williams_failsafe
	(print "hero_ai_died_active - williams grav bridge 1")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_grav_bridge ai_williams) 1)
			(print "hero_ai_died - williams grav bridge 1 - teleporting them to set cutscene flag")
			(object_teleport ai_williams fl_post_arena_teleport)
			(= b_hero_tele_gravbridge1 true)
		)
	1
	)
)

(script dormant start_post_arena

	;set the gravity bridge to be inactive
	(print "grav bridges active but need reversed polarity")
	(object_set_phantom_power cr_grav_bridge0a true)
	(object_set_phantom_power cr_grav_bridge1a true)
	(wake bridge1_control)

	;(wake to_bridge1_buddy_guide)

	(sleep_until (volume_test_players tv_post_arena_encounter) 1)

	;set eye to look at player
	(print "set eye objective to look at player")
	(cs_run_command_script sq_eye_of_prophet cs_eye_look)

	;unblip all navs
	(f_unblip_all)

	;unlock the forth insertion point
	(print_if b_debug_gameplay "insertion point:ins_e20_pre_bridge unlocked")
	(submit_incident "ins_e20_pre_bridge")
	(submit_incident_with_custom_string_id "game_activity_begin" "e20")

	;(device_set_power dm_covdoor_prison30 0)

	(set b_beat_3_buddies_spawned true) ; bool to keep multiple buddies from spawning when i load the next ins point

	(print "placing post arena wave 1")
	(ai_place gr_post_arena_wave1)

	;place the enemies on center grav bridge early so they aren't seen spawning in when the player crosses the bridge
	(ai_place gr_bridge_onfoot)

	(sleep_until (volume_test_players tv_bridge_switch) 1)
	(wake trigger_vo_bridge_approach)

	; activate blip at console to reverse grav bridge 1 polarity
	(sleep_until (= (ai_living_count gr_post_arena_wave1) 0) 1)
	(set b_first_bridge_guards_are_dead true)
	(ai_set_objective ai_williams obj_post_arena_marine_buddies) ; moved this out of vo script as the trigger for vo has changed

	(if (= b_grav_bridge1_hacked 1)
		;then
		(begin
			(f_unblip_flag navpoint_bridge_console_1)
		)
		;else
		(print "nav appears at bridge terminal")
	)

	(sleep_until (= b_grav_bridge1_hacked 1)  1)

	(ai_place gr_post_arena_reins)

	(ai_erase gr_brute_cells)


	; get the gravity bridge 1 script ready for each actor indiviually
	(wake run_gb1_on_johnson_once_alive)
	(wake run_gb1_on_williams_once_alive)

	(sleep_until (= (ai_living_count gr_post_arena) 0) 1)
	(f_game_save)
)

(script dormant run_gb1_on_johnson_once_alive
	(sleep_until (or
					(and
						(= (ai_living_count gr_post_arena) 0)
						(> (unit_get_health ai_johnson) 0)
					)
					(volume_test_object tv_bridge_buddy_teleport ai_johnson) ; if johnson makes it to center platform, this will be irrelevant and we can let the thread end.
				)
	1 )

	(if (volume_test_object tv_gb1_failsafe ai_johnson)
		(begin ; then
			(print "johnson runs and jumps through first grav bridge")
			(cs_run_command_script ai_johnson cs_gb1_johnson)
		)
		(begin ; else
			(print "johnson is already across the bridge and doesn't need to run cs_gb1_johnson")
		)
	)
)

(script dormant run_gb1_on_williams_once_alive
	; wait until the grav_bridge_1 guards are dead williams need to cross the grav bridge and are alive for the command script
	(sleep_until
				(or
					(and
						(= (ai_living_count gr_post_arena) 0)
						(> (unit_get_health ai_williams) 0)
					)
					(volume_test_object tv_bridge_buddy_teleport ai_williams) ; if williams makes it to center platform, this will be irrelevant and we can let the thread end.
				)
	1 )

	(if (volume_test_object tv_gb1_failsafe ai_williams)
		(begin ; then
			(print "williams runs and jumps through first grav bridge")
			(cs_run_command_script ai_williams cs_gb1_williams)
		)
		(begin ; else
			(print "williams is already across the bridge and doesn't need to run cs_gb1_williams")
		)
	)
)

(script dormant bridge1_control
	(sleep_until (= (device_get_position dc_bridge1_control) 1) 1)
	(set b_grav_bridge1_hacked 1)
	(device_set_position_immediate dm_gravity_bridge_e20_enter .25) ;vignette machine that fades out the first grav bridge that was on when the player entered the zone
	(sleep (game_ticks_from_seconds 1.0))
	(device_set_position_immediate dm_gravity_bridge_e20_exit .5) ;vignette machine fades in grav bridge that is now going the forward direction
	(sleep (game_ticks_from_seconds 2))
	(device_set_position_immediate dm_gravity_bridge_e20_exit 1) ;set the first grav bridge to be on now that it has been activated in case of save state reload
	(device_set_position_immediate dm_gravity_bridge_e20_enter 0) ;set the first grav bridge to be off now that it has been activated in case of save state reload

	(print "grav bridge 1 gravity flipped!")
	(object_create cr_grav_bridge0b)
	(object_destroy cr_grav_bridge0a)

	(f_unblip_all)
	(f_blip_flag navpoint_bridge1 0)
)

(script command_script cs_gb1_johnson
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_grav_bridge_wait1/p1)
	(cs_go_to ps_grav_bridge_wait1/p3) ; jump through first grav bridge

	(print "runs and jumps | johnson sleeps for follow")
	(sleep_until (volume_test_players tv_gb1_follow) 1)
)

(script command_script cs_gb1_williams
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_grav_bridge_wait1/p0)
	(cs_go_to ps_grav_bridge_wait1/p3) ; jump through first grav bridge

	(print "runs and jumps | williams sleeps for follow")
	(sleep_until (volume_test_players tv_gb1_follow) 1)
)

;====================================================================================================================================================================================================
; beat 3 - encounter 18 cleanup
;====================================================================================================================================================================================================
(script dormant e20_e18_cleanup
    (sleep_until (volume_test_players tv_kill_encounter_18) 1)
    (ai_erase gr_post_arena)

	(ai_erase gr_armory)

	(ai_erase gr_pre_arena)
)

;====================================================================================================================================================================================================
; e20 chapter - mind the gap
; beat 3 - encounter 19 spawning
; location - bridge
; inserion point - ins_pre_bridge
; zone set - set_lodge
; description: the group is ambushed on the bridge by banshees and other forces
;====================================================================================================================================================================================================

(global boolean b_grav_bridge2_hacked 0)

(global boolean b_hero_tele_gravbridge2 false) ; if false, this will teleport the hero ai back to start if they fall out of the map

(script dormant gravbridge2_johnson_failsafe
	(print "hero_ai_died_active - johnson grav bridge 2")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_grav_bridge2 ai_johnson) 1)
			(print "hero_ai_died - johnson grav bridge 2 - teleporting them to set cutscene flag")
			(object_teleport ai_johnson fl_grav_bridge_teleport)
			(= b_hero_tele_gravbridge2 true)
		)
	1
	)
)

(script dormant gravbridge2_williams_failsafe
	(print "hero_ai_died_active - williams grav bridge 2")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_grav_bridge2 ai_williams) 1)
			(print "hero_ai_died - williams grav bridge 2 - teleporting them to set cutscene flag")
			(object_teleport ai_williams fl_grav_bridge_teleport)
			(= b_hero_tele_gravbridge2 true)
		)
	1
	)
)

(global boolean b_gb_spawned 0)
(global boolean b_banshee_assualt_finished 0)

(script dormant start_bridge_encounter

	(sleep_until (volume_test_players tv_bridge_encounter) 1)

	;(wake teleport_buddies_bridge)

	(wake bridge2_control)

	;place the banshees and make them unable to be entered by the player
	(ai_place sq_bridge_wv1_banshees)
	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point sq_bridge_wv1_banshees/spawnpoint1) "" false true)
	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point sq_bridge_wv1_banshees/spawnpoint2) "" false true)

	(ai_set_combat_status sq_bridge_wv1_banshees dangerous)

	(set b_gb_spawned 1) ;confirm that all squads in this encounter have spawned

	(ai_erase gr_arena)
	(f_unblip_all)

	; wait until we've killed at least 1 banshee
	(sleep_until (< (ai_living_count sq_bridge_wv1_banshees) 2) 1)

	(ai_place sq_bridge_wv2_banshees)
	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point sq_bridge_wv2_banshees/spawnpoint) "" false true)
	(vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point sq_bridge_wv2_banshees/spawnpoint1) "" false true)
	(ai_set_combat_status sq_bridge_wv2_banshees dangerous)

	; johnson and williams will hard target the banshees to help clear them out.
	(ai_prefer_target_ai ai_johnson gr_bridge_banshees 1)
	(ai_prefer_target_ai ai_williams gr_bridge_banshees 1)

	(sleep_until (<= (ai_nonswarm_count gr_bridge) 3) 1)
	(print "grav_test: blipping bridge enemies")
	(f_blip_ai gr_bridge 1)

	;objective setup - hard target the banshees!
	(ai_set_objective gr_jackal_jungle_marines obj_bridge_encounter)
	(ai_set_objective gr_marine_cells_marines obj_bridge_encounter)
	(ai_set_objective ai_johnson obj_bridge_encounter)
	(ai_set_objective ai_williams obj_bridge_encounter)

	(sleep_until
		(and
			(= b_gb_spawned 1)
			(= (ai_nonswarm_count gr_bridge_onfoot) 0)
		)
		1
	)

	(print "grav_test: on foot are dead - start timer")

	(sleep_until (= (ai_living_count gr_bridge_banshees) 0) 1 (game_ticks_from_seconds 30))

	(set b_banshee_assualt_finished true)

	;objective setup - back to follow
	(ai_set_objective gr_jackal_jungle_marines obj_global_ai_follow)
	(ai_set_objective gr_marine_cells_marines obj_global_ai_follow)
	;(ai_set_objective ai_johnson obj_global_ai_follow)
	;(ai_set_objective ai_williams obj_global_ai_follow)

	(print "grav_test: banshees are dead or 30 seconds has passed - unblipping remaining enemies on the bridge")

	(f_unblip_ai gr_bridge) ; unblips ai in case of timeout

	;save game
	(game_save_no_timeout) ;checkpoint - before dialogue and second crossing

	(wake trigger_vo_bridge_second_gap)

	(print "johnson runs and goes through second grav bridge")
	(cs_run_command_script ai_johnson cs_gb2_johnson)
	(cs_queue_command_script ai_johnson cs_making_peace_johnson)
	(print "williams runs and goes through second grav bridge")
	(cs_run_command_script ai_williams cs_gb2_williams)
	(cs_queue_command_script ai_williams cs_making_peace_williams)

)

(script dormant bridge2_control
	(sleep_until (= (device_get_position dc_bridge2_control) 1) 1)
	(set b_grav_bridge2_hacked 1)
	(device_set_position_immediate dm_gravity_bridge_e20_enter2 .25) ;vignette machine fades out the second grav bridge
	(sleep (game_ticks_from_seconds 1.0))
	(device_set_position_immediate dm_gravity_bridge_e20_exit2 .5) ;vignette machine fades in the second grav bridge going the forward direction
	(sleep (game_ticks_from_seconds 2))
	(device_set_position_immediate dm_gravity_bridge_e20_exit2 1) ;set the second grav bridge to be on now that it has been activated in case of save state reload
	(device_set_position_immediate dm_gravity_bridge_e20_enter2 0) ;set the second grav bridge to be off now that it has been activated in case of save state reload

	(print "grav bridge 2 gravity flipped!")
	(object_create cr_grav_bridge1b)
	(object_destroy cr_grav_bridge1a)

	(f_unblip_all)
	(f_blip_flag navpoint_bridge2 0)

	(sleep_until (volume_test_players tv_bridge_console) 1)
	(f_unblip_all)
)

(script command_script cs_gb2_johnson

	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(sleep 5)
	(cs_go_to ps_grav_bridge_wait2/p2 0.2)
	(sleep_until (= (device_get_position dc_bridge2_control) 1) 1) ; wait until player activates bridge
	(sleep 5)
	(cs_go_to ps_grav_bridge_wait2/p4)
	(sleep_until (volume_test_players tv_vo_setup_make_peace) 1 (game_ticks_from_seconds 5))

)

(script command_script cs_gb2_williams

	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	;(sleep_until (volume_test_players tv_gb2_follow) 1)
	(cs_go_to ps_grav_bridge_wait2/p3 0.2)
	(sleep_until (= (device_get_position dc_bridge2_control) 1) 1) ; wait until player activates bridge
	(sleep 5)
	(cs_go_to ps_grav_bridge_wait2/p4)
	(sleep_until (volume_test_players tv_vo_setup_make_peace) 1 (game_ticks_from_seconds 5))

)

(script command_script cs_banshee_retreat
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_vehicle_boost true)
	(cs_fly_by ps_banshee_retreat/p0)
	(cs_fly_by ps_banshee_retreat/p1)
	(cs_fly_by ps_banshee_retreat/p2)

	(ai_erase ai_current_actor)
)


;====================================================================================================================================================================================================
; e20 chapter - mind the gap
; beat 3 - encounter 20 spawning
; location - old arena
; inserion point - ins_pre_bridge
; zone set - set_lodge
; description: the group fights their way through the old arena
;====================================================================================================================================================================================================

(script dormant start_post_bridge_making_peace

	(sleep_until (volume_test_players tv_vo_setup_make_peace) 1)

	(cs_run_command_script ai_johnson cs_making_peace_johnson)
	(cs_run_command_script ai_williams cs_making_peace_williams)

	(sleep_until b_start_vo_making_peace 1 (game_ticks_from_seconds 3)) ;timeout in case cs_making_peace scripts never sets flag
	(wake vo_making_peace)
	(sleep_until (script_finished "vo_making_peace") 1 (game_ticks_from_seconds 30)) ;timeout in case vo_making_peace never finishes, duration of conversation

	(f_game_save) ;save game

	(set mark_clear true) ; show objective about clearing the path to the control room
	(device_set_power dm_big_door4 1) ; open door to arena
	(device_set_position dm_big_door4 1) ; open door to arena

)

(global boolean b_old_arena_complete 0)

(script dormant start_old_arena_encounter

	(wake teleport_coop_players_old_arena)

	(wake teleport_buddies_post_bridge)

	(sleep_until (volume_test_players tv_old_arena_encounter) 1)

	;set eye to look at player
	(print "set eye objective to look at player")
	(cs_run_command_script sq_eye_of_prophet cs_eye_look)

	(ai_place gr_old_arena_defend)

	(sleep_until
		(or
			(< (ai_living_count gr_old_arena_defend) 2)
			(volume_test_players tv_old_arena_reins)
		)
		1
	)

	(device_set_position dm_big_door2 1)

	(ai_place gr_old_arena_reins)

	(wake trigger_vo_beat4_marine_spawn)

	(sleep_until (> (ai_living_count gr_old_arena_reins) 0) 1) ; wait until old arena reins squad spawns

	(sleep_until (<= (ai_nonswarm_count gr_old_arena) 3) 1) ; now see if there are less than or equl to 3 remaining enemies
	(f_blip_ai gr_old_arena 1) ; blip last 3 enemies of the encounter

	;save game
	(sleep_until (= (ai_nonswarm_count gr_old_arena) 0) 1)

	(set b_old_arena_complete 1)

	(device_set_position dm_big_door3 1)

	(f_game_save) ;save the game
)

(global boolean b_start_vo_making_peace false)

(script command_script cs_making_peace_johnson
	(print "running cs_making_peace_johnson")

	(set b_start_vo_making_peace true)
	(cs_go_by ps_making_peace/p0 ps_making_peace/p0)
	(cs_go_by ps_making_peace/p1 ps_making_peace/p1)
	(cs_jump_to_point 0.5 0.5)
	(cs_go_by ps_making_peace/p2 ps_making_peace/p2)
	(cs_go_to ps_making_peace/p3_johnson 0.2)
	(cs_lower_weapon 1)
	(cs_face_object 1 (ai_get_object ai_williams))
	(sleep_until b_chief_always_had_peace 1) ; set in vo_making_space
	(cs_face_player 1)

	(sleep_until (script_finished "vo_making_peace") 1)

)

(script command_script cs_making_peace_williams
	(print "running cs_making_peace_williams")

	(set b_start_vo_making_peace true)
	(cs_go_by ps_making_peace/p0 ps_making_peace/p0)
	(cs_go_by ps_making_peace/p1 ps_making_peace/p1)
	(cs_jump_to_point 0.5 0.5)
	(cs_go_by ps_making_peace/p2 ps_making_peace/p2)
	(cs_go_to ps_making_peace/p3_williams 0.2)
	(cs_lower_weapon 1)
	(cs_face_object 1 (ai_get_object ai_johnson))
	(sleep_until b_williams_makes_peace 1) ; set in vo_making_space
	(sleep (game_ticks_from_seconds 3)) ; turn on "until we started playing" which is 3 seconds in line m13_01260
	(cs_face_player 1)

	(sleep_until (script_finished "vo_making_peace") 1)

)


;====================================================================================================================================================================================================
; beat 3 - encounter 20 cleanup
;====================================================================================================================================================================================================
(script dormant e20_e20_cleanup
    (sleep_until (volume_test_players tv_kill_encounter_20) 1)
    (ai_erase gr_old_arena)
)

;====================================================================================================================================================================================================
; e20 chapter - mind the gap
; beat 3 - encounter 21 spawning
; location - landing structure
; inserion point - ins_landing_structure
; zone set - set_lodge
; description: the group faces covenant forces while a dropship ambushed them with reinforcements
;====================================================================================================================================================================================================
(global boolean b_landing_units_dropped 0)

(global boolean b_hero_tele_landing false) ; if false, this will teleport the hero ai back to start if they fall out of the map

(script dormant landing_johnson_failsafe
	(print "hero_ai_died_active - johnson landing structure")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_landing ai_johnson) 1)
			(print "hero_ai_died - johnson landing structure - teleporting them to set cutscene flag")
			(object_teleport ai_johnson fl_landing_teleport)
			(= b_hero_tele_landing true)
		)
	1
	)
)

(script dormant landing_williams_failsafe
	(print "hero_ai_died_active - williams landing structure")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_landing ai_williams) 1)
			(print "hero_ai_died - williams landing - teleporting them to set cutscene flag")
			(object_teleport ai_williams fl_landing_teleport)
			(= b_hero_tele_landing true)
		)
	1
	)
)

(script dormant start_landing_structure_encounter

	; the scripts for this encounter should start in just after the previous encounter ends.
	; this ensures that the door to the landing structure isn't open before the enemies spawn.
	(sleep_until b_old_arena_complete 1)

	;set eye to look at player
	(print "set eye objective to look at player")
	(cs_run_command_script sq_eye_of_prophet cs_eye_look)

	(ai_place gr_landing_structure_wv1)
	(ai_vehicle_enter sq_landing_structure_grunts ve_landing_shade1 "")
	(ai_vehicle_enter sq_landing_structure_grunts ve_landing_shade2 "")
	(ai_erase gr_bridge)

	(sleep_until (< (ai_living_count gr_landing_structure) 4)  1 (game_ticks_from_seconds 30))

	(ai_place gr_landing_structure_wv2)
	(ai_place gr_landing_struct_spirit)
	(vehicle_load_magic (unit_get_vehicle sq_landing_spirit/pilot_spawn) "fork" (ai_actors gr_landing_structure_wv2))

	(sleep_until (= b_landing_units_dropped 1) 1)

	;(ai_vehicle_enter sq_landing_structure_wv2_grunts ve_landing_shade1 "")
	;(ai_vehicle_enter sq_landing_structure_wv2_grunts ve_landing_shade2 "") ;removed this squad to tone down the encounter. part of the ticket to reduce enemy counts between larger encounters - mtr-61184


	(sleep_until (<= (ai_nonswarm_count gr_landing_structure) 3) 1)
	(f_blip_ai gr_landing_structure 1)

	(sleep_until
		(and
			(<= (ai_nonswarm_count gr_landing_structure_wv2) 0)
			(<= (ai_nonswarm_count gr_landing_structure_wv1) 0)
		)
		1
	)

	(wake vo_entering_into_encounter_23)

	(ai_place gr_landing_lodge_door)

	(print "landing structure door opened")
	(sleep_until (script_finished "vo_entering_into_encounter_23") 1) ; waits until punchline is delivered before opening door for gr_landing_lodge_door
	(device_set_position dm_landing_door 1)

	;save game
	(sleep_until (= (ai_living_count gr_landing_structure) 0)  1)
	(game_save_no_timeout) ;checkpoint
)

(script command_script cs_landing_spirit_dropoff
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles true) ; this helps with ai from getting stuck

	;blip dropship
	(f_blip_object ai_current_actor 1)

	(cs_fly_by ps_landing_spirit/p0)
	;fly above drop off point
	(cs_fly_to_and_face ps_landing_spirit/p1 ps_landing_spirit/p3_face)
	;descend to drop off point
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_landing_spirit/p2 ps_landing_spirit/p3_face)
	;drop off units
	(unit_open (ai_vehicle_get_from_spawn_point sq_landing_spirit/pilot_spawn))
	(cs_pause 1)
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_landing_spirit/pilot_spawn) "fork_p")
	(cs_pause 3)
	(set b_landing_units_dropped 1)

	;unblip dropship
	(f_unblip_object ai_current_actor)
	(unit_close (ai_vehicle_get_from_spawn_point sq_landing_spirit/pilot_spawn))
	;fly above drop off point again
	(cs_fly_to_and_face ps_landing_spirit/p1 ps_landing_spirit/p4_face)
	(cs_vehicle_speed 1)
	(cs_fly_to ps_landing_spirit/p0)
	(cs_fly_to ps_landing_spirit/p4_face)
	(f_dropship_actor_scale_destroy ai_current_actor)
)

;====================================================================================================================================================================================================
; beat 3 - encounter 21 cleanup
;====================================================================================================================================================================================================
(script dormant e20_e21_cleanup
    (sleep_until (volume_test_players tv_kill_encounter_21) 1)
    (ai_erase gr_landing_structure)
)



;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; e20 beat 4 - hunters hunted
;
; description: making their way into the lodge the group seeks info from the command center
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 											e20 beat 4 - encounters
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
; e20 chapter - hunters hunted
; beat 4 - encounter 22 spawning
; location - path to the control room
; inserion point - ins_path_to_control_room
; zone set - set_lodge
; description:
;====================================================================================================================================================================================================
(global boolean b_hero_tele_ctrl_ext false) ; if false, this will teleport the hero ai back to start if they fall out of the map

(script dormant ctrl_ext_johnson_failsafe
	(print "hero_ai_died_active - johnson control exterior")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_control ai_johnson) 1)
			(print "hero_ai_died - johnson control exterior - teleporting them to set cutscene flag")
			(object_teleport ai_johnson fl_lodge_entrance_teleport)
			(= b_hero_tele_ctrl_ext true)
		)
	1
	)
)

(script dormant ctrl_ext_williams_failsafe
	(print "hero_ai_died_active - williams control exterior")

	;scripts to teleport hero ai back into the playspace if they fall out of the level

	(sleep_until
		(begin
			(sleep_until (volume_test_object tv_fs_under_control ai_williams) 1)
			(print "hero_ai_died - williams control exterior - teleporting them to set cutscene flag")
			(object_teleport ai_williams fl_lodge_entrance_teleport)
			(= b_hero_tele_ctrl_ext true)
		)
	1
	)
)

(script dormant start_lodge_entrance_encounter
	;(wake teleport_buddies_cont_approach_teleport)
	(sleep_until (volume_test_players tv_lodge_entrance_encounter) 1)
	(ai_place gr_lodge_entrance)

	;set eye to look at player
	(print "set eye objective to look at player")
	(cs_run_command_script sq_eye_of_prophet cs_eye_look)
)

;====================================================================================================================================================================================================
; beat 4 - encounter 22 cleanup
;====================================================================================================================================================================================================
(script dormant e20_e22_cleanup
    (sleep_until (volume_test_players tv_kill_encounter_22) 1)
    (ai_erase gr_lodge_entrance)
)


;====================================================================================================================================================================================================
; e20 chapter - hunters hunted
; beat 4 - encounter 23 spawning
; location - control exterior
; inserion point - ins_path_to_control_room
; zone set - set_lodge
; description:
;====================================================================================================================================================================================================
(script dormant start_settlement_encounter

	(sleep_until (volume_test_players tv_control_exterior) 1)

	(ai_place sq_control_ext_grunts)
	(ai_place sq_control_ext_jackals)

	(set b_control_exterior_spawn true)

	(ai_place sq_control_ext_elites)

	; set objectives williams/johnson
	(ai_set_objective ai_johnson obj_control_exterior)
	(ai_set_objective ai_williams obj_control_exterior)

	(sleep_until (<= (ai_living_count gr_control_exterior_wv1) 6) 1)

	(ai_place gr_settlement_beat4_marines) ;tiger squads that the player saw at the settlement
	;(wake trigger_vo_beat4_marine_spawn)
	;(wake vo_beat4_marine_spawn)

	; set objective for marines
	(ai_set_objective sq_settlement_beat4_marines obj_control_exterior)

	(sleep_until (<= (ai_living_count gr_control_exterior_wv1) 3) 1)

	(ai_place gr_control_exterior_wv2)

	(sleep_until (<= (ai_nonswarm_count gr_control_exterior) 3) 1)

	(f_blip_ai gr_control_exterior 1)

	(sleep_until (<= (ai_nonswarm_count gr_control_exterior) 0) 1)

	; set objectives williams/johnson
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(ai_set_objective ai_williams obj_global_ai_follow)

	(f_unblip_all)
	(f_blip_flag fl_control_doorway_blip 0)

	;open door to final encounter area
	(device_set_power dm_control_entrance 1)
	(device_set_position dm_control_entrance 1)
	(device_set_power dc_final_interact 0)

	;wake airlock scripts
	(wake teleport_players_and_ai_airlock)

	;save game
	(game_save_no_timeout) ;checkpoint

	;making sure both johnson and williams are alive before executing run ahead scripts
	(sleep_until
		(and
			(> (object_get_health (object_get_ai ai_johnson)) 0)
			(> (object_get_health (object_get_ai ai_williams)) 0)
		)
		1
	)

	;make these heros invincible
	(ai_cannot_die ai_johnson true)
	(ai_cannot_die ai_williams true)

	;johnson and williams run to the door entrance and wait for the player
	(print "johnson runs ahead")
	(cs_run_command_script ai_johnson cs_ctrl_johnson_run_ahead1)
	(print "williams runs ahead")
	(cs_run_command_script ai_williams cs_ctrl_williams_run_ahead1)

	(sleep_until (volume_test_players tv_control_run_ahead1) 1)

	;johnson and williams run down the hall to the next door and wait for the player
	(print "johnson runs ahead")
	(cs_run_command_script ai_johnson cs_ctrl_johnson_run_ahead2)
	(print "williams runs ahead")
	(cs_run_command_script ai_williams cs_ctrl_williams_run_ahead2)

	;wait until the door is fully open before running into the control center
	(sleep_until (= 1 (device_get_position dm_control_entrance3)) 1)
	(sleep_until (volume_test_players tv_control_run_ahead2) 1)

	;johnson and williams run onto the pedestal in the control center
	(print "johnson runs ahead")
	(cs_run_command_script ai_johnson cs_ctrl_johnson_run_ahead3)
	(print "williams runs ahead")
	(cs_run_command_script ai_williams cs_ctrl_williams_run_ahead3)
)

(script command_script cs_ctrl_johnson_run_ahead1
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_control_entrance_wait/p0 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_control_run_ahead1) 1)
)

(script command_script cs_ctrl_williams_run_ahead1
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_control_entrance_wait/p1 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_control_run_ahead1) 1)
)

(script command_script cs_ctrl_johnson_run_ahead2
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_control_entrance_wait2/p0 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_control_run_ahead2) 1)
)

(script command_script cs_ctrl_williams_run_ahead2
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_control_entrance_wait2/p1 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_control_run_ahead2) 1)
)

(script command_script cs_ctrl_johnson_run_ahead3
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_control_wait/p0 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_final_encounter) 1)
	(ai_cannot_die ai_johnson false)
)

(script command_script cs_ctrl_williams_run_ahead3
	(cs_enable_pathfinding_failsafe true) ; this helps with ai from getting stuck
	(cs_ignore_obstacles false) ; this helps with ai from getting stuck

	(cs_go_to ps_control_wait/p1 .2)
	(cs_face_player true)

	(sleep_until (volume_test_players tv_final_encounter) 1)
	(ai_cannot_die ai_williams false)
)

;====================================================================================================================================================================================================
; beat 4 - encounter 23 cleanup
;====================================================================================================================================================================================================
(script dormant e20_e23_cleanup
    (sleep_until (volume_test_players tv_kill_encounter_23) 1)
    (ai_erase gr_settlement)
)

;====================================================================================================================================================================================================
; e20 chapter - hunters hunted
; beat 4 - encounter 24 spawning - final encounter
; location - lodge entry
; inserion point - ins_final_encounter
; zone set - set_lodge
; description: the group faces off against an ambush inside the control room
;====================================================================================================================================================================================================
(global boolean b_final_e_wave_3 0)
(global boolean b_zealot_spawned 0)
(global boolean b_zealot_defeated 0)

(script dormant start_final_encounter

	;keep williams from dying for the whole encounter to esnure she can run the revenge script at the end of the fight
	(ai_cannot_die ai_williams true)

	(wake final_interact)

	;disables hero teleport failsafe code for previous areas
	(print "disabled hero teleport failsafe code for previous areas")
	(set b_hero_tele_gravbridge1 true)
	(set b_hero_tele_gravbridge2 true)
	(set b_hero_tele_landing true)
	(set b_hero_tele_ctrl_ext true)

	;save game
	(sleep_until (volume_test_players tv_final_encounter_save) 1)
	(f_unblip_all)
	(f_game_save) ;save the game

	(sleep_until (volume_test_players tv_final_encounter) 1)

	(set mark_escape true) ; show objective about escaping the hunting dome

	(sleep (game_ticks_from_seconds 2))
	(ai_place gr_final_encounter_wv1)
	(set s_music_trigger_e20 251)

	(wake trigger_vo_command_hvt_spawned)

	(wake final_encounter_door_control)

	(sleep_until (<= (ai_living_count gr_final_encounter_wv1) 1) 1)

	(sleep (game_ticks_from_seconds 3))
	(ai_place sq_final_encounter_wv2_jackals)
	(ai_place sq_final_encounter_wv2_brutes)
	(set s_music_trigger_e20 252)

	(sleep_until (<= (ai_living_count gr_final_encounter_wv2) 2) 1)

	(ai_place sq_final_encounter_wv2_elites)

	(sleep_until (<= (ai_living_count gr_final_encounter_wv2) 1) 1)
	(set b_final_e_wave_3 1)

	(ai_place sq_final_encounter_wv3_snipers)
	(ai_place sq_final_encounter_wv3_specops)

	(sleep_until (<= (ai_living_count gr_final_encounter_wv3) 2) 1)
	(ai_place sq_final_encounter_wv3_brutes)

	(sleep_until (<= (ai_living_count sq_final_encounter_wv3_specops) 1) 1)

	;prep williams to take out the zealot - she heads for the overlook and cannot die
	(ai_set_objective ai_williams obj_final_encounter) ; tells williams to head to the overlook via ai objective
	(ai_player_remove_fireteam_squad player0 ai_williams) ; keeps williams from following the player so she heads to the overlook
	(ai_disregard (ai_actors ai_williams) true) ; keeps ai from targeting williams so she can get to the overlook
	(object_cannot_take_damage ai_williams) ;keeps williams from flinching if attacked
	(ai_cannot_die ai_williams true) ;make sure she cannot die so she can recieve and execute her revenge script

	(sleep_until (and
			(= (ai_living_count gr_final_encounter_wv1) 0)
			(= (ai_living_count gr_final_encounter_wv2) 0)
			(= (ai_living_count gr_final_encounter_wv3) 0)
			)
			1
	)

	(ai_player_remove_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_zealot_johnson)
	(ai_set_objective ai_williams obj_zealot_williams)

	(sleep (game_ticks_from_seconds 2))
	(ai_place sq_final_encounter_wv1_zealot)
	(sleep (game_ticks_from_seconds .1))

	;make this door two-way in case the zealot dies inside the spawn closet
	(device_one_sided_set dm_oneway_04 false)
	(ai_disregard (ai_actors ai_williams) false)
	(set ai_victim sq_final_encounter_wv1_zealot)
	(wake time_for_revenge)
	(wake vo_command_end)
	(cs_run_command_script sq_final_encounter_wv1_zealot cs_hvt_enters_in_berserk_state)

	(sleep_until (= b_revenge_achieved 1) 1 (game_ticks_from_seconds 15)); waits until the revenge is achieved or times out after 10 seconds in case the player kills the zealot before williams can get there

	(f_blip_flag navpoint_control_room_console_1 0)
	(device_set_power dc_final_interact 1)
	(set b_final_encounter_defeated true)
	(set b_zealot_defeated 1)
	(ai_cannot_die ai_williams false)

	;save game
	(game_save_no_timeout) ;checkpoint
)

(script dormant final_interact
	(sleep_until (= b_final_encounter_defeated 1) 1)
	(f_blip_flag navpoint_control_room_console_1 0)

	(print "waiting for player to interact with final button")
	(sleep_until (= (device_get_position dc_final_interact) 1) 1)
	(f_unblip_all)
	(print "final button pressed")
	(wake vo_activating_the_console)
	(sleep_until (script_finished "vo_activating_the_console") 1)

	;open the exit doors
	;door 1
	(sleep (game_ticks_from_seconds 0.5))
	(device_set_power dm_control_entrance3 1)
	(device_set_position dm_control_entrance3 1)
	(sleep (game_ticks_from_seconds 0.5))
	(device_operates_automatically_set dm_control_entrance3 false)

	;navpoint
	(f_blip_flag navpoint_control_room_exit 0)

	;williams and johnson rejoin the fireteam and are set to follow the player
	(ai_player_add_fireteam_squad player0 ai_williams)
	(ai_player_add_fireteam_squad player0 ai_johnson)
	(ai_set_objective ai_johnson obj_global_ai_follow)
	(ai_set_objective ai_williams obj_global_ai_follow)
	(object_can_take_damage ai_williams) ;williams can take damage again
	(ai_cannot_die ai_williams false) ;williams can die again

	;leaving the dome - mission complete
	(sleep_until (volume_test_players tv_end_mission) 1)
	(f_unblip_all)

	;control entrance opens
	(device_set_power dm_control_entrance 1)
	(device_set_position dm_control_entrance 1)
	(device_operates_automatically_set dm_control_entrance false)

	(sleep (game_ticks_from_seconds 3)) ; this gives time for the door to show the outside for a moment before the cinematic starts

	;game_won is called after cinematic plays
    (wake trigger_final_cinematic)

)

(script dormant final_encounter_door_control

	(sleep_until (volume_test_players tv_final_encounter) 1)

	;make sure the doors to the final encounter are closed until the end of the encounter
	(device_set_power dm_control_entrance 0)
	(device_set_position dm_control_entrance 0)
	(device_set_power dm_control_entrance3 0)
	(device_set_position dm_control_entrance3 0)

	;teleport hero ai and coop players once the doors are shut
	(wake teleport_final_encounter)
	(wake teleport_coop_players_control)
)

;====================================================================================================================================================================================================
;crate object management scripts (blam object folders)
;====================================================================================================================================================================================================

;settlement crates
(script dormant create_settlement_crates

	;creates settlement crates when player is in this volume
	(sleep_until (volume_test_players tv_create_of_01_settlement) 1)

	(print "cratespawner: creating settlement crates")

	(object_create_folder of_01_settlement)

)

(script dormant destroy_settlement_crates

	;waits for players to reach prison to destroy the settlement crates
	(sleep_until (volume_test_players tv_destroy_of_01_settlement) 1)

	(print "cratespawner: destroying settlement crates")

	(object_destroy_folder of_01_settlement)

)

;jackal jungle crates
(script dormant create_jackaljungle_crates

	;creates jackal jungle crates when player is in this volume
	(sleep_until (volume_test_players tv_create_of_02_jackaljungle) 1)

	(print "cratespawner: creating jackal jungle crates")

	(object_create_folder of_02_jackaljungle)

	;waits for players to reach prison to destroy the jackal jungle crates
	(sleep_until (volume_test_players tv_destroy_of_02_jackaljungle) 1)

	(print "cratespawner: destroying settlement crates")

	(object_destroy_folder of_02_jackaljungle)

)

;jackal jungle crates
(script dormant destroy_jackaljungle_crates

	;creates jackal jungle crates when player is in this volume
	(sleep_until (volume_test_players tv_create_of_02_jackaljungle) 1)

	(print "cratespawner: creating jackal jungle crates")

	(object_create_folder of_02_jackaljungle)

	;waits for players to reach prison to destroy the jackal jungle crates
	(sleep_until (volume_test_players tv_destroy_of_02_jackaljungle) 1)

	(print "cratespawner: destroying settlement crates")

	(object_destroy_folder of_02_jackaljungle)

)

;create prison bridge crates
; seems i have to separate create/destroy scripts so insertion points don't destroy object folders early... not sure why it does
(script dormant create_prisonbridge_crates

	;creates prison bridge crates when player is in this volume
	(sleep_until (volume_test_players tv_create_of_03_prisonbridge) 1)

	(print "cratespawner: creating prison bridge crates")

	(object_create_folder of_03_prisonbridge)

)

;destroy prison bridge crates
; seems i have to separate create/destroy scripts so insertion points don't destroy object folders early... not sure why it does
(script dormant destroy_prisonbridge_crates

	;waits for players to reach prison to destroy the prison bridge crates
	(sleep_until (volume_test_players tv_destroy_of_03_prisonbridge) 1)

	(print "cratespawner: destroying prison bridge crates")

	(object_destroy_folder of_03_prisonbridge)

)

;create prison crates a
; seems i have to separate create/destroy scripts so insertion points don't destroy object folders early... not sure why it does
(script dormant create_prison_crates_a

	;creates prison crates (a) when player is in this volume
	(sleep_until (volume_test_players tv_create_of_04_prison) 1)

	(print "cratespawner: creating prison crates a")

	(object_create_folder of_04_prison)

)

;destroy prison crates a
; seems i have to separate create/destroy scripts so insertion points don't destroy object folders early... not sure why it does
(script dormant destroy_prison_crates_a

	;waits for players to reach this volume to destroy the prison a crates
	(sleep_until (volume_test_players tv_destroy_of_04_prison) 1)

	(print "cratespawner: destroying prison crates a")

	(object_destroy_folder of_04_prison)

)

;create prison crates b
; seems i have to separate create/destroy scripts so insertion points don't destroy object folders early... not sure why it does

(script dormant create_prison_crates_b

	;creates prison crates (b) when player is in this volume
	(sleep_until (volume_test_players tv_create_of_04_prison_b) 1)

	(print "cratespawner: creating prison crates b")

	(object_create_folder of_04_prison_b)

)

;destroy prison crates b
; seems i have to separate create/destroy scripts so insertion points don't destroy object folders early... not sure why it does
(script dormant destroy_prison_crates_b

	;waits for players to reach this volume to destroy the prison b crates
	(sleep_until (volume_test_players tv_destroy_of_04_prison_b) 1)

	(print "cratespawner: destroying prison crates b")

	(object_destroy_folder of_04_prison_b)

)

;create grav bridge crates
; seems i have to separate create/destroy scripts so insertion points don't destroy object folders early... not sure why it does
(script dormant create_gravbridge_crates

	;creates grav bridge crates when player is in this volume
	(sleep_until (volume_test_players tv_create_of_05_gravbridge) 1)

	(print "cratespawner: creating grav bridge crates")

	(object_create_folder of_05_gravbridge)

)

;destroy grav bridge crates
; seems i have to separate create/destroy scripts so insertion points don't destroy object folders early... not sure why it does
(script dormant destroy_gravbridge_crates

	;waits for players to reach this volume to destroy the grav bridge crates
	(sleep_until (volume_test_players tv_destroy_of_05_gravbridge) 1)

	(print "cratespawner: destroying grav bridge crates")

	(object_destroy_folder of_05_gravbridge)

)

;create old arena crates
(script dormant create_oldarena_crates

	;creates old arena crates when player is in this volume
	(sleep_until (volume_test_players tv_create_of_06_oldarena) 1)

	(print "cratespawner: creating old arena crates")

	(object_create_folder of_06_oldarena)

)

;create control crates
(script dormant create_control_crates

	;creates control crates when player is in this volume
	(sleep_until (volume_test_players tv_create_of_07_control) 1)

	(print "cratespawner: creating control crates")

	(object_create_folder of_07_control)

)

;====================================================================================================================================================================================================
;coop and difficulty object management scripts (weapons/ammo/equipment)
;====================================================================================================================================================================================================

; configures the sandbox items available on different difficulties in the prison_bridge encounter
(script dormant manage_prison_bridge_weapons_and_ammo

	;prison bridge crates are created when player is in this volume
	(sleep_until (volume_test_players tv_create_of_03_prisonbridge) 1)

    ; we don't need the player to have the extra rocket and sniper ammo on legendary - wouldn't want to be too generous or anything.
    (if (= (game_difficulty_get) legendary)
        (begin
            (object_destroy eg_rocket_ammo_1)
            (object_destroy eg_sniper_ammo)
        )
		;else
        (begin
            (object_create_if_necessary eg_rocket_ammo_1)
            (object_create_if_necessary eg_sniper_ammo)
        )
    )

	 ; rockets placed at prison bridge intro for easy/normal to make wraith easier to fight - changed to magnum for heroic/legendary
    (if (or (= (game_difficulty_get) heroic) (= (game_difficulty_get) legendary))
        (begin
            (object_destroy we_rocket_launcher_3)
			(object_destroy eg_rocket_ammo_3)
			(object_create_if_necessary we_magnum_10)
        )
		;else
        (begin
            (object_create_if_necessary we_rocket_launcher_3)
			(object_create_if_necessary eg_rocket_ammo_3)
			(object_destroy we_magnum_10)
        )
    )
)

; configures the sandbox items available on different difficulties in the armory
(script dormant manage_armory_weapons_and_ammo

	;prison crates (b) are created when player is in this volume
	(sleep_until (volume_test_players tv_create_of_04_prison_b) 1)

    ; again - this is legendary, not a charity.
    (if (= (game_difficulty_get) legendary)
        (begin
            (object_destroy eg_rocket_ammo_2)
            (object_destroy eg_sniper_ammo_16)
        )
		;else
        (begin
            (object_create_if_necessary eg_rocket_ammo_2)
            (object_create_if_necessary eg_sniper_ammo_16)
        )
    )
)

;====================================================================================================================================================================================================
;utlility scripts
;====================================================================================================================================================================================================
(script static void cs_kill_command_script
	(print "killing current command script")
	(sleep 1)
)

(script command_script cs_tele_kill_command_script
	(print "killing current command script")
	(sleep 1)
)

(script static void kill_branch
	(print "killing script since branch condition met")
)

(script static void (f_unblip_all)
	(f_unblip_flag fl_brute_cells_exit_blip)
	(f_unblip_flag fl_armory_exit_blip)
	(f_unblip_flag fl_arena_blip)
	(f_unblip_flag fl_jj_door_open)
	(f_unblip_flag fl_settlement_ramp_blip)
	(f_unblip_flag fl_control_doorway_blip)
	(f_unblip_flag fl_marine_cells_exit_blip)
	(f_unblip_flag fl_arena_exit_blip)
	(f_unblip_flag fl_prison_fight)
	(f_unblip_flag fl_prison_opened)
	(f_unblip_flag navpoint_prison_bottom_terminal)
	(f_unblip_flag navpoint_marine_cells)
	(f_unblip_flag navpoint_marine_cells_console_1)
	(f_unblip_flag navpoint_bridge_console_1)
	(f_unblip_flag navpoint_bridge1)
	(f_unblip_flag navpoint_bridge_console_2)
	(f_unblip_flag navpoint_bridge2)
	(f_unblip_flag navpoint_control_room_console_1)
	(f_unblip_flag navpoint_control_room_exit)
)

(script static void (f_attach_hacking_device (ai hacking_character))
    (sleep (game_ticks_from_seconds 1.8))
	(print "attach hacking device to johnson")
	(object_create sc_hacking_device)
	(objects_attach hacking_character "attach_hacking_device" sc_hacking_device "attach")
	(sleep_until ( = (unit_is_playing_custom_animation hacking_character) false) 1 )
	(print "attach_hacking_device sleep complete")
)

(script static void (f_destroy_hacking_device (ai hacking_character))
	(sleep (game_ticks_from_seconds 2.33))
	(object_destroy sc_hacking_device)
	(sleep_until ( = (unit_is_playing_custom_animation hacking_character) false) 1 )
	(print "destroy_hacking_device sleep complete")
)

;====================================================================================================================================================================================================
; beat 4 - vignette
; williams gets even with the zealot
;====================================================================================================================================================================================================

(script dormant time_for_revenge
	(sleep_until (<= (object_get_health sq_final_encounter_wv1_zealot) 0) 1)
	(ai_actor_dialogue_enable ai_johnson 0)
	(ai_actor_dialogue_enable ai_williams 0)

	(sleep_until (> (object_get_health (object_get_ai ai_williams)) 0) 1) ;check if williams is alive to take revenge

	(cs_run_command_script ai_williams cs_williams_do_your_thing)
)

(script command_script cs_williams_do_your_thing
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(ai_actor_dialogue_enable ai_current_actor false)

	(ai_place_cue williams_accuracy_cue)
	(cs_approach ai_victim 3 40 50)
	(cs_approach_stop)

	(sleep (game_ticks_from_seconds .5))

	;williams won't walk until she is close to the zealot's corpse
	;(sleep_until (>= 10 (objects_distance_to_object ai_williams ai_victim)) 1)
	(cs_walk true)
	(cs_approach ai_victim .5 40 50)
	(cs_approach_stop)

	(sleep (game_ticks_from_seconds .5))
	(cs_face_object true ai_victim)
	(sleep (game_ticks_from_seconds 1.5))
	(wake vo_command_hvt_dead)
	(sleep_until (script_finished "vo_command_hvt_dead") 1)
	(sleep (game_ticks_from_seconds .5))
	(cs_shoot true sq_final_encounter_wv1_zealot)

	(sleep (game_ticks_from_seconds .25))
	(cs_shoot false sq_final_encounter_wv1_zealot)
	(ai_remove_cue williams_accuracy_cue)
	(set b_revenge_achieved true)
	(cs_walk false)
	(sleep (game_ticks_from_seconds 1))
	(ai_actor_dialogue_enable ai_current_actor true)
)

(script command_script cs_hvt_enters_in_berserk_state
	(ai_set_blind sq_final_encounter_wv1_zealot true)
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles false)
	(cs_go_by pts_elite_advances_into_room/p0 pts_elite_advances_into_room/p0)
	(cs_go_by pts_elite_advances_into_room/p1 pts_elite_advances_into_room/p1)
	(ai_berserk sq_final_encounter_wv1_zealot true)
	(ai_set_blind sq_final_encounter_wv1_zealot false)
)