extends RayCast3D

@export var camera : Camera3D
@onready var ray_cast_3d: RayCast3D = $"."
@export var click_effect : PackedScene

func _process(delta: float) -> void:
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	target_position = camera.project_local_ray_normal(mouse_pos) * 100.0
	force_raycast_update()
	
	if is_colliding():
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		if Input.is_action_just_pressed("left_click"):
			var collision_point = get_collision_point()
			print(collision_point)
			pass
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
