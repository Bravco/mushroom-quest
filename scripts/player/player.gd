class_name Player extends CharacterBody2D

@onready var player_animated_sprite: AnimatedSprite2D = $PlayerAnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var roll_timer: Timer = $RollTimer
@onready var roll_cooldown_timer: Timer = $RollCooldownTimer
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer

@export var MOVE_SPEED: int  = 110
@export var ACCELERATION: int = 12
@export var ROLL_SPEED: int  = 220
@export var ROLL_DURATION: float  = 0.2
@export var ROLL_COOLDOWN: float = 0.8

var input_dir: Vector2 = Vector2.ZERO
var is_rolling: bool = false
var can_roll: bool = true

func _ready() -> void:
	PlayerData.Harm.connect(_on_player_harm)
	PlayerData.Death.connect(_on_player_death)
	animation_tree.active = true
	roll_timer.wait_time = ROLL_DURATION
	roll_cooldown_timer.wait_time = ROLL_COOLDOWN

func _process(_delta: float) -> void:
	animate()

func _physics_process(delta: float) -> void:
	var speed: float = ROLL_SPEED if is_rolling else MOVE_SPEED
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if GameManager.process_input:
		velocity = lerp(velocity, input_dir * speed, delta * ACCELERATION)
		if can_roll and input_dir != Vector2.ZERO and Input.is_action_just_pressed("roll"):
			roll()
		move_and_slide()

func animate() -> void:
	if GameManager.process_input:
		var mouse_position: Vector2 = get_global_mouse_position()
		if mouse_position.x - global_position.x > 0:
			player_animated_sprite.flip_h = false
		else:
			player_animated_sprite.flip_h = true

	if input_dir == Vector2.ZERO or not GameManager.process_input:
		animation_tree["parameters/conditions/is_idling"] = true
		animation_tree["parameters/conditions/is_running"] = false
	else:
		animation_tree["parameters/conditions/is_idling"] = false
		animation_tree["parameters/conditions/is_running"] = true

	if is_rolling:
		animation_tree["parameters/conditions/is_rolling"] = true
	else:
		animation_tree["parameters/conditions/is_rolling"] = false

func roll() -> void:
	is_rolling = true
	can_roll = false
	roll_timer.start()
	roll_cooldown_timer.start()

func _on_roll_timer_timeout() -> void:
	is_rolling = false

func _on_roll_cooldown_timer_timeout() -> void:
	can_roll = true

func _on_player_harm() -> void:
	hit_flash_animation_player.play("hit_flash")

func _on_player_death() -> void:
	GameManager.process_input = false
	animation_tree.active = false
	animation_player.play("death")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		GameManager.reload_game()
