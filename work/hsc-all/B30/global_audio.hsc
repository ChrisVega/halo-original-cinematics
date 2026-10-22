; mission dialogue functions

; global variables for aborting mission dialogue conversations
(global short conversation_id 0)
(global short vo_abort_padding 15)
(global short vo_aborted_time 0)
(global long vo_triggered_time 0)

; plays a spatialized (3d) line on an ai character (if alive and with correct dialogue designator). example usage: (f_md_3d_play 15 unique_beach_lz/stacker m04_01050 "stacker: go go go!")
; delay is time after the line plays. use negative to make it a cutoff
; note - for guilty spark, use f_md_3d_play_guilty_spark
(script static void (f_md_3d_play (short delay) (ai character) (ai_line line) (string debug_line))
	(print_if b_print_vo_lines debug_line)
	(if (>= (ai_living_count character) 1)
		(begin
			(sleep_until (= b_is_dialogue_playing false) 1)
			(set b_is_dialogue_playing true)
			(set s_last_played_ai_line line)
			(set s_md_play_time (+ (ai_play_line character line) delay))
			(if
				(<= (- s_md_play_time (if (< delay 0) (* delay -1) delay)) 0) ; if delay is a negative value, returns absolute value
				(begin
					(print "vo error: line duration is 0 and or dialogue designator is incorrect") ; fails with specified character and or line or cutoff > line duration
				)
				(begin
					(set vo_triggered_time (game_tick_get))
					(sleep s_md_play_time)
				)
			)
			(set b_is_dialogue_playing false)
		)
		(print "vo info: character is not alive to speak")
	)
)

; plays an unspatialized (2d) lin. example usage: (f_md_2d_play 0 m04_00360 "cortana: wake up, chief!")
; delay is time after the line plays. use negative to make it a cutoff
; note - for cortana, use f_md_2d_play_cortana
(script static void (f_md_2d_play (short delay) (ai_line line) (string debug_line))
	(print_if b_print_vo_lines debug_line)
	(f_md_object_play delay none line)
)

; plays cortana dialogue with console effects enabled during the line
; use blamgamepadeventhandlersubsystem.togglecolordebugprint for debug
(script static void (f_md_2d_play_cortana (short delay) (ai_line line) (string debug_line))
	(submit_incident "cortana_starts_speaking")
	(f_md_2d_play delay line debug_line)
	(submit_incident "cortana_stops_speaking")
)

; play guilty spark line with console effects enabled during the line
; use blamgamepadeventhandlersubsystem.togglecolordebugprint for debug
(script static void (f_md_3d_play_guilty_spark (short delay) (ai character) (ai_line line) (string debug_line))
    (submit_incident "guilty_spark_starts_speaking")
	(f_md_3d_play delay character line debug_line)
    (submit_incident "guilty_spark_stops_speaking")
)

; plays a cortana dawdle line every x minutes (reminder_duration_in_minutes). example usage: example usage: (f_md_dawdle_play 0 m04_00710 "cortana: we should now have access... let's find the map room." 5)
; use (branch) in the dormant script that this function is used to kill the dawdle when player has progressed
(script static void (f_md_dawdle_play (short delay) (ai_line line) (string debug_line) (short reminder_duration_in_minutes))
	(sleep_until
		(begin
			(sleep_until (game_safe_to_save) 1) ; waits until safe to say dawdle line without resetting reminder duration
			(f_md_2d_play_cortana delay line debug_line)
			false
		)
	(game_ticks_from_seconds (* reminder_duration_in_minutes 60))) ; checks every reminder_duration
)

; for branching scipts in dialog
; sleep duration calculated as the full duration of aborted line - remaining duration of aborted line
; remaining duration of aborted line is divided by 2 due to doubled rate of game_tick_get
; sleep padding set in global variable vo_abort_padding.
; -- important -- this function lets the current line play to its end, unlike f_md_abort which will cut off the line immediately.
(global short sleep_duration 0)
(script static void f_md_skip_next
	(print "dialog script skipped to next!")
	(set vo_aborted_time (game_tick_get))
	(set sleep_duration (f_get_absolute_value (+ (- s_md_play_time (/ (- vo_aborted_time vo_triggered_time) 2)) vo_abort_padding)))
	(if (< sleep_duration 0)
		(print "negative sleep duration!!")
		(sleep sleep_duration)
	)
	(set b_is_dialogue_playing false)
	(ai_dialogue_enable true)
)

; for interrupting mission dialogue conversations
(script static void (f_md_abort)
	(print "vo info: dialogue script aborted!")
	(if (!= s_last_played_ai_line "")
		(begin
			(ai_stop_line s_last_played_ai_line)
			(set s_last_played_ai_line "")
		)
	)
	(set b_is_dialogue_playing false)
	(ai_dialogue_enable true)
)

(script static void (f_md_abort_no_combat_dialog)
	(f_md_abort)
	(sleep 1)
	(ai_dialogue_enable false)
)

(script static boolean f_is_dialogue_playing
	b_is_dialogue_playing
)

; legacy mission dialogue functions
; these are not used anymore but kept for posterity

; play the specified line if character is alive, then delay afterwards for a specified amount of time.
; added if statement to check if character exists so we don't get into bad situations- dmiller 5/25
; added sleep_until to avoid overlapping vo
; use only for vignettes as that is vs_cast's intended use case - kymin 6/05/2025
(script static void (f_md_ai_play (short delay) (ai character) (ai_line line))
	(sleep_until (not b_is_dialogue_playing) 1)
	(set b_is_dialogue_playing true)
	(if (>= (ai_living_count character) 1)
		(begin
			(if (vs_cast character false 10 line)
				(begin
					(set s_last_played_ai_line line)
					(set s_md_play_time (+ (ai_play_line (vs_role 1) line) delay))
					(set vo_triggered_time (game_tick_get))
					(sleep s_md_play_time)
				)
				(print "vo error: this actor could not be cast to play f_md_ai_play")
			)
		)
		(print "vo info: this actor is not alive to play f_md_ai_play")
	)
	(set b_is_dialogue_playing false)
)

; play the specified line, then delay afterwards for a specified amount of time.
; added sleep_until to avoid overlapping vo
(script static void (f_md_object_play (short delay) (object obj) (ai_line line))
	(sleep_until (not b_is_dialogue_playing) 1)
	(set b_is_dialogue_playing true)
	(set s_last_played_ai_line line)
	(set s_md_play_time (+ (ai_play_line_on_object obj line) delay))
	(set vo_triggered_time (game_tick_get))
	(sleep s_md_play_time)
	(set b_is_dialogue_playing false)
)

