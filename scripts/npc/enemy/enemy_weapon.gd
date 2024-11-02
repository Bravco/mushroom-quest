extends Node2D

@onready var enemy: CharacterBody2D = owner
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var health: Health = owner.get_node("Health")
@onready var respawn_timer: Timer = owner.get_node("RespawnTimer")
@onready var swing_cooldown_timer: Timer = $SwingCooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Pivot/Weapon/Hitbox

@export var swing_cooldown : float = 1.0

var rotate_towards_player: bool = false
var can_swing: bool = true

func _ready() -> void:
	swing_cooldown_timer.wait_time = animation_player.get_animation("swing").length + swing_cooldown
	health.Death.connect(_on_health_death)
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)

func _process(_delta: float) -> void:
	var current_state: String = enemy.state_machine.current_state.name.to_lower()
	match current_state:
		"chase":
			rotate_towards_player = true
		"attack":
			rotate_towards_player = false
			if can_swing:
				swing()
		_:
			rotate_towards_player = false

func _physics_process(_delta: float) -> void:
	if enemy.facing_right:
		scale.x = 1
	else:
		scale.x = -1
	
	if rotate_towards_player:
		if animation_player.current_animation == "":
			rotate(get_angle_to(player.position) - PI * int(!enemy.facing_right))
	else:
		rotate(0.0)

func swing() -> void:
	can_swing = false
	swing_cooldown_timer.start()
	animation_player.play("swing")

func _on_swing_cooldown_timer_timeout() -> void:
	can_swing = true

func _on_health_death() -> void:
	visible = false
	animation_player.active = false
	hitbox.set_deferred("monitorable", false)

func _on_respawn_timer_timeout() -> void:
	visible = true
	animation_player.active = true
	hitbox.monitorable = true
