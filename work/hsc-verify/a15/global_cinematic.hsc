; global cinematic scripts

; here be load bearing scripts, make any changes with great care and caution!

(script static boolean cinematic_should_play_internal
	(and
		cinematic_should_play
		(not (editor_behavior))
	)
)

(script static void (f_play_cinematic
						(cinematic_definition cinematic)
					)
	(if
		(cinematic_should_play_internal)
		(begin
			; check for skipping
			(if
				(cinematic_skip_start)
				(cinematic_playing_internal cinematic)
			)
			(cinematic_over_internal cinematic)
		)
		; else
		(pseudo_cinematic)
	)
)

; variant with optional teleport point set
(script static void (f_play_cinematic
						(cinematic_definition cinematic)
						(point_reference point_set) ; teleport
					)
	(if
		(cinematic_should_play_internal)
		(begin
			; check for skipping
			(if
				(cinematic_skip_start_teleport point_set) ; teleport
				(cinematic_playing_internal cinematic)
			)
			(cinematic_over_internal cinematic)
		)
		; else
		(pseudo_cinematic_teleport point_set) ; teleport
	)
)

; fade out from gameplay, lower weapons, etc... in preparation for a cinematic
; if called directly, be sure to play the cinematic via f_manual_cinematic_play to fade into and start the cinematic
(script static void (f_manual_cinematic_prepare
						(cinematic_definition cinematic)
						(boolean weapon_lower)
					)
	(if
		(cinematic_should_play_internal)
		(begin
			; game
			(ai_disregard (players) true)
			(object_cannot_take_damage (players))
			(ai_enable false)
			(ai_dialogue_enable false)
			(campaign_metagame_time_pause true)

			; weapon
			(if
				weapon_lower
				(begin
					; lower
					(unit_lower_weapon player0 30)
					(unit_lower_weapon player1 30)
					(unit_lower_weapon player2 30)
					(unit_lower_weapon player3 30)
				)
			)

			; fade
			(if
				(not (cinematic_at_gameplay_start))
				(begin
					(player_control_fade_out_all_input 1)
					(chud_cinematic_fade 0 15)
					(sleep (cinematic_fade_out_from_game cinematic))
				)
			)
		)
	)
)

; play a cinematic that has already been prepared (faded out, weapon lowered, etc...)
(script static void (f_manual_cinematic_play
						(cinematic_definition cinematic)
					)
	(if
		(cinematic_should_play_internal)
		(begin
			; check for skipping
			(if
				(cinematic_skip_start)
				(begin
					(cinematic_hide_players_internal)
					(cinematic_set cinematic)
					(cinematic_start)
					(cinematic_fade_in_to_cinematic cinematic)
					(sleep_until (= (cinematic_in_progress) false) 1)
				)
			)
			(cinematic_over_internal cinematic)
		)
		; else
		(pseudo_cinematic)
	)
)

(script static void (f_manual_cinematic_play
						(cinematic_definition cinematic)
						(point_reference point_set) ; teleport
					)
	(if
		(cinematic_should_play_internal)
		(begin
			; check for skipping
			(if
				(cinematic_skip_start_teleport point_set) ; teleport
				(begin
					(cinematic_set cinematic)
					(cinematic_start)
					(cinematic_fade_in_to_cinematic cinematic)
					(sleep_until (= (cinematic_in_progress) false) 1)
				)
			)
			(cinematic_over_internal cinematic)
		)
		; else
		(pseudo_cinematic_teleport point_set) ; teleport
	)
)

(script static void (f_play_fail_cinematic
						(cinematic_definition cinematic)
					)
	(game_save_cancel)
	; play failure cinematic
	(cinematic_enter cinematic true)

	; wait until it's over, or player can revert on their own
	(sleep_until (= (cinematic_in_progress) false) 1)
	(game_lost true)
	(game_revert)
)

(script static boolean cinematic_skip_start
	; listen for the button which reverts (skips)
	(cinematic_skip_start_internal)
	; save the game state
	(game_save_cinematic_skip)
	; sleep until the game is done saving
	(sleep_until (not (game_saving)) 1)
	; return whether or not the game has been reverted
	(not (game_reverted))
)

(script static boolean (cinematic_skip_start_teleport
							(point_reference point_set)
						)
	(cinematic_skip_start)
	; teleport
	(if
		(game_reverted)
		(cinematic_teleport point_set)
	)
	; return whether or not the game has been reverted
	(not (game_reverted))
)

; defaulting to false for met.
(global boolean b_cinematic_lower_weapon false)

(script static void (cinematic_playing_internal
						(cinematic_definition cinematic)
					)
	; play cinematic
	(cinematic_enter cinematic b_cinematic_lower_weapon)

	; wait until it's over
	(sleep_until (= (cinematic_in_progress) false) 1)
)

(script static void (cinematic_over_internal
						(cinematic_definition cinematic)
					)
	(if
		(cinematic_is_outro cinematic)
		; then
		(begin
			(cinematic_skip_stop_internal)

			; keep control off even if reverted
			(player_enable_input false)
			(player_disable_movement true)
			(camera_control true)
			(if
				(editor_mode)
				(begin
					; get back in!
					(sleep (game_ticks_from_seconds 2))
					(cinematic_exit cinematic true)
				)
			)
		)
		; else
		(begin
			(cinematic_skip_stop)
			(cinematic_exit cinematic true)
		)
	)
)

(script static void pseudo_cinematic
	; handle saving like the cinematic would have
	(game_save_immediate)
	(sleep_until (not (game_saving)) 1)
	(if
		(not (game_reverted))
		(game_revert)
	)
)

(script static void (pseudo_cinematic_teleport
						(point_reference point_set)
					)
	(pseudo_cinematic)
	; teleport
	(cinematic_teleport point_set)
)

(script static void (cinematic_teleport
						(point_reference point_set)
					)
	(object_teleport_to_ai_point player0 (ai_point_set_get_point point_set 0))
	(object_teleport_to_ai_point player1 (ai_point_set_get_point point_set 1))
	(object_teleport_to_ai_point player2 (ai_point_set_get_point point_set 2))
	(object_teleport_to_ai_point player3 (ai_point_set_get_point point_set 3))
)

(script static void cinematic_skip_stop
	; stop listening for the button
	(cinematic_skip_stop_internal)
	; if the player didn't revert, do it for them
	(if (not (game_reverted)) (game_revert))
)

(script static boolean game_at_gameplay_start
	; check if we're near start
	(if
		(and
			(< (game_tick_get_editor_adjusted) (game_ticks_from_seconds 5))
			(> (game_tick_get_editor_adjusted) 0)
		)
		(begin
			; warn if we're not close enough to true start
			(print "game_at_gameplay_start: warning: game_at_gameplay_start called on a tick after zero!")
			(inspect (game_tick_get_editor_adjusted))
		)
	)
	; return rough answer
	(< (game_tick_get_editor_adjusted) (game_ticks_from_seconds 5))
)

(script static boolean cinematic_at_gameplay_start
	(< (game_tick_get_editor_adjusted) (game_ticks_from_seconds 5))
)

(script static void (f_cinematic_handle_intro_snap
						(cinematic_definition cinematic)
					)
	(f_editor_wait_for_player)
	(if
		(and
			(game_at_gameplay_start)
			(cinematic_should_play_internal)
		)
		(begin
			; snap to cinematic color
			(player_control_fade_out_all_input 0)
			(cinematic_snap_fade_in_to_cinematic cinematic)
			(f_game_wait_for_player_start)
			(sleep 1)
		)
	)
)

(script static void (cinematic_enter
						(cinematic_definition cinematic)
						(boolean weapon_lower)
					)
	(cinematic_preroll cinematic)
	(cinematic_set cinematic)

	(f_manual_cinematic_prepare cinematic weapon_lower)
	(cinematic_hide_players_internal)

	; cinematic
	(cinematic_start)
	(cinematic_fade_in_to_cinematic cinematic)
)

(script static void (cinematic_exit
						(cinematic_definition cinematic)
						(boolean weapon_lowered)
					)
	; unstash
	(object_hide player0 false)
	(object_hide player1 false)
	(object_hide player2 false)
	(object_hide player3 false)

	; control
	(camera_control false)
	(player_enable_input true)
	(player_disable_movement false)

	; weapon
	(if
		weapon_lowered
		(begin
			; snap lowered
			(unit_lower_weapon player0 1)
			(unit_lower_weapon player1 1)
			(unit_lower_weapon player2 1)
			(unit_lower_weapon player3 1)

			; give the weapon a chance to lower for a tick before raising.
			; otherwise the lower state will be a->b->a within a single tick
			; and no state change will be detected for replication to clients.
			(sleep 1)

			; raise
			(unit_raise_weapon player0 30)
			(unit_raise_weapon player1 30)
			(unit_raise_weapon player2 30)
			(unit_raise_weapon player3 30)
		)
	)

	; fade
	(player_control_fade_in_all_input 1)
	(chud_cinematic_fade 1 15)
	(sleep (cinematic_fade_in_to_game cinematic))

	; game
	(ai_disregard (players) false)
	(object_can_take_damage (players))
	(ai_enable true)
	(ai_dialogue_enable true)
	(campaign_metagame_time_pause false)
)

; removes control & hides players
(script static void cinematic_hide_players_internal
	; control
	(player_enable_input false)
	(player_disable_movement true)
	(camera_control true)

	; stash
	(object_hide player0 true)
	(object_hide player1 true)
	(object_hide player2 true)
	(object_hide player3 true)
)

(script static void f_insertion_fade_to_gameplay
	; snap
	(game_at_gameplay_start)
	(f_editor_wait_for_player)
	(player_control_fade_out_all_input 0)
	(chud_cinematic_fade 0 0)
	(fade_out 0 0 0 0)
	(f_game_wait_for_player_start)
	(sleep 1)

	; fade
	(player_control_fade_in_all_input 1)
	(chud_cinematic_fade 1 30)
	(fade_in 0 0 0 30)

	; snap lowered
	(unit_lower_weapon player0 1)
	(unit_lower_weapon player1 1)
	(unit_lower_weapon player2 1)
	(unit_lower_weapon player3 1)

	; save
	(game_save_immediate)

	; give the weapon a chance to lower for a tick before raising.
	; otherwise the lower state will be a->b->a within a single tick
	; and no state change will be detected for replication to clients.
	(sleep 1)

	; raise
	(unit_raise_weapon player0 30)
	(unit_raise_weapon player1 30)
	(unit_raise_weapon player2 30)
	(unit_raise_weapon player3 30)
)