class_name WizardReturn extends NPCState

func enter() -> void:
	npc.move_speed = npc.RUN_SPEED
	npc.target_position = npc.spawn_position
	npc.reset_boss_fight()

func update(_delta: float) -> void:
	var spawn_dist: float = npc.global_position.distance_to(npc.spawn_position)
	
	if spawn_dist < 1:
		transitioned.emit(self, "idle")
