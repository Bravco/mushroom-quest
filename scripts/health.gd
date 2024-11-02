class_name Health extends Node

signal Heal
signal Harm
signal Death

@export var health_bar: ProgressBar
@export_enum("High:6", "Medium:4", "Low:3") var MAX_HEALTH: int = 3

var health: int = MAX_HEALTH:
	set(value):
		health = clamp(value, 0, MAX_HEALTH)
		if health_bar:
			health_bar.value = health

func _ready() -> void:
	reset()
	if health_bar:
		health_bar.max_value = MAX_HEALTH

func reset() -> void:
	health = MAX_HEALTH

func heal(amount: int) -> void:
	health += amount
	Heal.emit()

func harm(amount: int) -> void:
	health -= amount
	Harm.emit()
	if health <= 0:
		Death.emit()

func show_health_bar(value: bool) -> void:
	if health_bar:
		health_bar.visible = value
