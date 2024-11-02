extends CharacterBody2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var item: Item
@export var MAX_SPEED = 50.0
@export var ACCELERATION = 0.5

var speed = 0.0
var slide_to_player = false

func _ready() -> void:
	sprite.texture = item.texture
	animation_player.play("float")
	await get_tree().create_timer(2).timeout
	slide_to_player = true

func _physics_process(delta: float) -> void:
	if slide_to_player:
		speed = lerp(speed, MAX_SPEED, ACCELERATION * delta)
		velocity = global_position.direction_to(player.global_position) * speed
	
	var collision = move_and_collide(velocity)
	if collision:
		pick_up()

func pick_up() -> void:
	QuestManager.process_item_pick_up(item)
	queue_free()

func _on_mouse_entered() -> void:
	slide_to_player = true
