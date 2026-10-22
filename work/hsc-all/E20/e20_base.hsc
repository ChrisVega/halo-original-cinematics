;====================================================================================================================================================================================================
; global vars ==============================================================================================================================================
;====================================================================================================================================================================================================

;every global variable used in the scripts
(global boolean b_at_settlement true)

(global boolean b_debug_gameplay true)
(global boolean b_debug_audio false)
(global boolean b_encounter_19_eliminated false)
(global boolean b_made_it_to_command_tower false)
(global boolean b_final_encounter_defeated false)
(global boolean b_beat_3_buddies_spawned false)
(global boolean b_first_bridge_guards_are_dead false)
(global boolean b_revenge_achieved false)
(global boolean b_trigger_arena_ambush false)

(global ai ai_johnson none)
(global ai ai_williams none)
(global object ai_victim none)

;objectives
(global boolean mark_signal false)
(global boolean mark_survive false)
(global boolean mark_prison false)
(global boolean mark_bridge false)
(global boolean mark_clear false)
(global boolean mark_escape false)

;====================================================================================================================================================================================================
; default_save_loop ==============================================================================================================================================
;====================================================================================================================================================================================================
; (script startup default_save_loop
; 	(wake f_debug_global_save_loop)
; )

;====================================================================================================================================================================================================
; objectives ================================================================================================================================================
;====================================================================================================================================================================================================
(script static void f_objectives_e20
	(print "objectives ready.")
	(wake obj_settlement)
	(wake obj_survivehunt)
	(wake obj_prison_start)
	(wake obj_crossbridge)
	(wake obj_clearpath)
	(wake obj_prison_end)
)

(script dormant obj_settlement
	(sleep_until mark_signal 1)
	(sleep 30) ; wait for hud to be ready when using insertion points
	(print "showing objective: obj_settlement")
	(f_hud_obj_new "obj_settlement" "obj_settlement")
)

(script dormant obj_survivehunt
	(sleep_until mark_survive 1)
	(sleep 30) ; wait for hud to be ready when using insertion points
	(print "showing objective: obj_survivehunt")
	(f_hud_obj_new "obj_survivehunt" "obj_survivehunt")
)

(script dormant obj_prison_start
	(sleep_until mark_prison 1)
	(sleep 30) ; wait for hud to be ready when using insertion points
	(print "showing objective: obj_prison_start")
	(f_hud_obj_new "obj_prison_start" "obj_prison_start")
)

(script dormant obj_crossbridge
	(sleep_until mark_bridge 1)
	(sleep 30) ; wait for hud to be ready when using insertion points
	(print "showing objective: obj_crossbridge")
	(f_hud_obj_new "obj_crossbridge" "obj_crossbridge")
)

(script dormant obj_clearpath
	(sleep_until mark_clear 1)
	(sleep 30) ; wait for hud to be ready when using insertion points
	(print "showing objective: obj_clearpath")
	(f_hud_obj_new "obj_clearpath" "obj_clearpath")
)

(script dormant obj_prison_end
	(sleep_until mark_escape 1)
	(sleep 30) ; wait for hud to be ready when using insertion points
	(print "showing objective: obj_prison_end")
	(f_hud_obj_new "obj_prison_end" "obj_prison_end")
)
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; 											e20 - chapter titles
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

; beat 3 - chapter 3
(script dormant trigger_chapter_three
	(sleep_until (volume_test_players tv_chapter_trigger_beat_three) 1)
	(f_hud_chapter chapter_e20_3)
)

;beat 4 - chapter 4
(script dormant trigger_chapter_four
	(sleep_until (script_finished "vo_entering_into_encounter_23") 1)
	(f_hud_chapter chapter_e20_4)
)

;====================================================================================================================================================================================================
; music ==============================================================================================================================================
;====================================================================================================================================================================================================
