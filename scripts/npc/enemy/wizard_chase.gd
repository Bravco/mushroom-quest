class_name WizardChase extends NPCState

func enter() -> void:
	npc.move_speed = npc.RUN_SPEED
	if "health" in npc and npc.health:
		npc.health.show_health_bar(true)

func update(_delta: float) -> void:
	if is_player_targetable():
		var player_dist: float = npc.global_position.distance_to(player.global_position)
		npc.target_position = player.global_position
		
		if (npc.health.MAX_HEALTH - npc.health.health) / (npc.health.MAX_HEALTH / len(npc.wave_enemy_counts)) >= npc.current_wave:
			if npc.wave_spawnpoint and not npc.wave_enemies.is_empty():
				for i in range(npc.wave_enemy_counts[npc.current_wave]):
					const spawn_radius: float = 50.0
					var enemy: Node = npc.wave_enemies.pick_random().instantiate()
					enemy.boss_add = true
					enemy.global_position = npc.wave_spawnpoint.global_position + \
						Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
					npc.get_parent().add_child(enemy)
				npc.current_wave += 1
		
		if player_dist < npc.ATTACK_RADIUS:
			transitioned.emit(self, "attack")
		
		if not GameManager.boss_fight_active:
			transitioned.emit(self, "return")
	else:
		transitioned.emit(self, "return")
