extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var state_machine: StateMachine = $StateMachine

@export var ACCELERATION: float = 12.0
@export var WALK_SPEED: float = 10.0
@export var WANDER_RADIUS: float = 10.0

var move_dir: Vector2
var move_speed: float = WALK_SPEED
var target_position: Vector2
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = global_position

func _process(_delta: float) -> void:
	animate()

func _physics_process(delta: float) -> void:
	var target_position_dist: float = global_position.distance_to(target_position)
	navigation_agent.target_position = target_position
	move_dir = global_position.direction_to(target_position).normalized()
	
	if target_position_dist > 1:
		velocity = lerp(velocity, move_dir * move_speed, delta * ACCELERATION)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func animate():
	if move_dir.x > 0:
		animated_sprite.flip_h = false
	elif move_dir.x < 0:
		animated_sprite.flip_h = true

	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	elif move_speed == WALK_SPEED:
		animated_sprite.play("walk")
