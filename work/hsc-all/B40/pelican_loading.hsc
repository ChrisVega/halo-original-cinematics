; =================================================================================================
; global_pelican.hsc
; =================================================================================================
(global boolean b_debug_pelican false)

(script static void	(f_load_pelican
								(vehicle pelican)		; pelican to load
								(string load_side)		; how to load it
								(ai load_squad_01)		; squads to load
								(ai load_squad_02)
				)
	; place ai
	(ai_place load_squad_01)
	(ai_place load_squad_02)
	(sleep 1)

	(cond
		; left
		((= load_side "left")
						(begin
							(if b_debug_pelican (print "load pelican left..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_l01")

						)
		)
		; right
		((= load_side "right")
						(begin
							(if b_debug_pelican (print "load pelican right..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_r01")

						)
		)
		; dual
		((= load_side "dual")
						(begin
							(if b_debug_pelican (print "load pelican dual..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_l01")
							(ai_vehicle_enter_immediate load_squad_02 pelican "pelican_p_r01")

						)
		)
	)

)


(script static void (f_unload_pelican_all	(vehicle pelican))
	(unit_open pelican)
	(sleep 60)
	(begin_random
		(begin
			(vehicle_unload pelican "pelican_p_l01")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_l02")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_l03")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_l04")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_l05")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r01")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r02")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r03")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r04")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r05")
			(sleep (random_range 0 10))
		)
	)
)

; new pelican global scripts =======================================================================================================================================

(script static void (f_load_pelican_cargo_ai
										(vehicle pelican)		; the pelican you are loading the cargo in to
										(ai load_squad_01)		; squad to load
				)
	; place ai
	(ai_place load_squad_01)
	(sleep 1)
	(vehicle_load_magic pelican "pelican_lc" (ai_vehicle_get_from_squad load_squad_01 0))
)

(script static void (f_load_pelican_cargo_vehicle
										(vehicle pelican)		; the pelican you are loading the cargo in to
										(object_name veh_to_load)	; vehicle to load
				)
	; create vehicle
	(object_create veh_to_load)
	(vehicle_load_magic pelican "pelican_lc" veh_to_load)
)

(script static void (f_unload_pelican_cargo	(vehicle pelican))
	; unload cargo seat
	(vehicle_unload pelican "pelican_lc")
)