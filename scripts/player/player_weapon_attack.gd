class_name PlayerWeaponAttack extends PlayerWeaponState

@export_enum("swing1", "swing2", "pierce") var current_animation_name: String
@export_enum("swing1", "swing2", "pierce") var next_animation_name: String
@export_enum("swing1_return", "swing2_return", "pierce_return") var return_animation_name: String

@export var swing_cooldown: float = 0.2
@export var wait_time: float = 0.4

var next_swing: bool = false
var waiting: bool = false

func enter() -> void:
	next_swing = false
	waiting = false
	update_transform()
	if animation_player:
		if !animation_player.is_connected("animation_finished", _on_animation_finished):
			animation_player.connect("animation_finished", _on_animation_finished)
		animation_player.play(current_animation_name)

func exit() -> void:
	if animation_player and animation_player.is_connected("animation_finished", _on_animation_finished):
		animation_player.disconnect("animation_finished", _on_animation_finished)

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		next_swing = true
		if waiting:
			transitioned.emit(self, next_animation_name)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == current_animation_name:
		get_tree().create_timer(swing_cooldown, false).timeout.connect(_on_cooldown_timer_timeout)

func _on_cooldown_timer_timeout() -> void:
	if next_swing:
		transitioned.emit(self, next_animation_name)
	else:
		waiting = true
		get_tree().create_timer(wait_time, false).timeout.connect(_on_wait_timer_timeout)

func _on_wait_timer_timeout() -> void:
	if !next_swing:
		animation_player.play(return_animation_name)
		transitioned.emit(self, "idle")
