(script static void probe_camera_api
  (begin
    (camera_control true)
    (camera_set_field_of_view 70 0)
    (camera_set_spline_point "autumn_glory_1" 0)
    (cinematic_set_active_camera "autumn_glory_1")
    (cinematic_scripting_create_scene 1)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 "capt_keyes" "idle" true)
  )
)
