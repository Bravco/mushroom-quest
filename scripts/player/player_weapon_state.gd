class_name PlayerWeaponState extends State

@onready var weapon: Node2D = owner
@onready var animation_player: AnimationPlayer = owner.find_child("AnimationPlayer")

func update_transform() -> void:
	if weapon and "update_transform" in weapon:
		weapon.update_transform()
