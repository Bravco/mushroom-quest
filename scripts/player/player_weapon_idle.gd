class_name PlayerWeaponIdle extends PlayerWeaponState

func physics_update(_delta: float) -> void:
	if GameManager.process_input:
		update_transform()
		if Input.is_action_just_pressed("attack"):
			transitioned.emit(self, "swing1")
