extends Node

signal Heal
signal Harm
signal Death

const MAX_HEALTH: int = 24

var health: int = MAX_HEALTH:
	set(value):
		health = clamp(value, 0, MAX_HEALTH)

func _ready() -> void:
	reset()

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
