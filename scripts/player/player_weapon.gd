extends Node2D

func update_transform() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	scale.x = sign(mouse_position.x - global_position.x)
	rotate(get_angle_to(mouse_position) - PI * int(scale.x < 0))
