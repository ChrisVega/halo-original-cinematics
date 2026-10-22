; todo replace level with your map's shorthand (f.ex. a20), ctrl+h

;====================================================================================================================================================================================================
; global vars ==============================================================================================================================================
;====================================================================================================================================================================================================

;every global variable used in the scripts

(global boolean b_debug_gameplay true)
(global boolean b_debug_audio false)

; (global boolean b_mission_setup_done false)
; (global boolean b_fast_setup_done false)

(global boolean b_lift_1_encounter_active false)
(global boolean b_lift_3_encounter_active false)

(global boolean b_monitor_lead_through_sp false)
(global boolean b_monitor_lead_after_sp false)
(global boolean b_monitor_show_index false)
(global boolean b_monitor_reached_cor_f3 false)
(global boolean b_monitor_lead_cor_f3 false)
(global boolean b_monitor_reached_door1 false)

(global boolean b_arena_encounter_active false)
(global boolean b_floor1_encounter_left false)
(global boolean b_floor2_encounter_clear false)
(global boolean b_need_unlocked_door_vo false)
(global boolean b_vo_reclaimer_done false)

(global short s_lift_1_state 0)
(global short s_lift_1_combat_form_max 3)
(global short s_lift_1_infectors_max 10)

;====================================================================================================================================================================================================
; default_save_loop ==============================================================================================================================================
;====================================================================================================================================================================================================
(script startup default_save_loop
	(print "no save")
	; (wake f_debug_global_save_loop)
)