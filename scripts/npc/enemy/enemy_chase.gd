class_name EnemyChase extends NPCState

func enter() -> void:
	npc.move_speed = npc.RUN_SPEED
	if "health" in npc and npc.health:
		npc.health.show_health_bar(true)

func update(_delta: float) -> void:
	if is_player_targetable():
		var player_dist: float = npc.global_position.distance_to(player.global_position)
		npc.target_position = player.global_position
		
		if player_dist < npc.ATTACK_RADIUS:
			transitioned.emit(self, "attack")
		
		if not npc.boss_add and player_dist > npc.CHASE_EXIT_RADIUS:
			transitioned.emit(self, "return")
	else:
		transitioned.emit(self, "return")
