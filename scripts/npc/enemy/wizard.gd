extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var state_machine: StateMachine = $StateMachine
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var health: Health = $Health
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = get_node_or_null("Hitbox")

@export var ACCELERATION: int = 12
@export_enum("Fast:75", "Medium:60", "Slow:50") var RUN_SPEED: int = 50
@export var ATTACK_RADIUS: int = 20
@export var drop_items: Array[Item] = []
@export var wave_spawnpoint: Marker2D
@export var wave_enemies: Array[Resource] = []
@export var wave_enemy_counts = [2, 3, 4]

var move_dir: Vector2
var move_speed: int = RUN_SPEED
var target_position: Vector2
var spawn_position: Vector2
var facing_right: bool = true
var current_wave: int = 0

func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)
	health.Harm.connect(_on_health_harm)
	health.Death.connect(_on_health_death)
	
	set_physics_process(false)
	call_deferred("actor_setup")
	
	spawn_position = global_position

func _process(_delta: float) -> void:
	animate()

func _physics_process(delta: float) -> void:
	if target_position:
		navigation_agent.target_position = target_position
	
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	move_dir = global_position.direction_to(next_path_position).normalized()
	
	if navigation_agent.distance_to_target() > 1:
		velocity = lerp(velocity, move_dir * move_speed, delta * ACCELERATION)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func actor_setup() -> void:
	NavigationServer2D.map_changed.connect(Callable(map_loaded))
	
func map_loaded(_rdi) -> void:
	set_physics_process(true)
	NavigationServer2D.map_changed.disconnect(Callable(map_loaded))

func animate():
	if move_dir.x > 0:
		facing_right = true
		animated_sprite.flip_h = false
	elif move_dir.x < 0:
		facing_right = false
		animated_sprite.flip_h = true

	if health.health > 0:
		if velocity == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			match move_speed:
				RUN_SPEED:
					animated_sprite.play("run")
				_:
					animated_sprite.play("idle")

func reset_boss_fight() -> void:
	health.reset()
	current_wave = 0

func _on_animated_sprite_animation_finished() -> void:
	if health.health <= 0:
		visible = false
		collision_shape.set_deferred("disabled", true)

func _on_health_harm() -> void:
	hit_flash_animation_player.play("hit_flash")

func _on_health_death() -> void:
	QuestManager.process_enemy_death(scene_file_path)
	state_machine.current_state.transitioned.emit(state_machine.current_state, "dead")
	animated_sprite.play("death")
	hurtbox.set_deferred("monitoring", false)
	if hitbox:
		hitbox.set_deferred("monitorable", false)
