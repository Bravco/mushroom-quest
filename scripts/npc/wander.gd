class_name Wander extends NPCState

var wander_time: float
var target_position: Vector2

func enter() -> void:
	npc.move_speed = npc.WALK_SPEED
	randomize_wander()

func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func randomize_wander() -> void:
	wander_time = randf_range(1, 3)
	npc.target_position = npc.spawn_position + Vector2(
		randf_range(-npc.WANDER_RADIUS, npc.WANDER_RADIUS),
		randf_range(-npc.WANDER_RADIUS, npc.WANDER_RADIUS)
	)
