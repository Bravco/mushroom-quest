extends Node2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var health: Health = $Health
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer
@onready var respawn_timer: Timer = $RespawnTimer

@export var RESPAWN_TIME: float = 30.0
@export var drop_items: Array[Item] = []

var spawn_position: Vector2

func _ready() -> void:
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)
	
	spawn_position = global_position
	respawn_timer.wait_time = RESPAWN_TIME
	respawn_timer.one_shot = true

func handle_drop_items() -> void:
	for drop_item in drop_items:
		if randf() <= drop_item.drop_chance:
			call_deferred("instantiate_item", drop_item)

func instantiate_item(item: Item) -> void:
	var pickable_item: Node = preload("res://scenes/pickable_item.tscn").instantiate()
	pickable_item.item = item
	pickable_item.global_position = global_position
	get_parent().add_child(pickable_item)

func _on_health_harm() -> void:
	hit_flash_animation_player.play("hit_flash")

func _on_health_death() -> void:
	visible = false
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	if hurtbox:
		hurtbox.set_deferred("monitoring", false)
	respawn_timer.start()
	handle_drop_items()

func _on_respawn_timer_timeout() -> void:
	global_position = spawn_position
	visible = true
	health.reset()
	if collision_shape:
		collision_shape.disabled = false
	if hurtbox:
		hurtbox.monitoring = true
