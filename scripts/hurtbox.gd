class_name Hurtbox extends Area2D

const KNOCKBACK_ACCELERATION: float = 10.0
const KNOCKBACK_DURATION: float = 0.2

## Leave empty if it is Player Hurtbox
@export var health: Health
@export var knockback_disabled: bool = false

var knockback_dir: Vector2
var duration: float = KNOCKBACK_DURATION

func _ready() -> void:
	connect("area_entered", self._on_area_entered)

func _process(delta: float) -> void:
	if not knockback_disabled:
		duration -= delta
		if knockback_dir != Vector2.ZERO and duration > 0:
			owner.velocity = lerp(owner.velocity, knockback_dir, delta * KNOCKBACK_ACCELERATION)

func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox is Hitbox:
		if not knockback_disabled:
			knockback_dir = -owner.global_position.direction_to(hitbox.global_position) * hitbox.knockback
			duration = KNOCKBACK_DURATION
		if health:
			health.harm(hitbox.damage)
		elif owner is Player:
			PlayerData.harm(hitbox.damage)
		GameManager.ScreenShake.emit()
