class_name WizardIdle extends NPCState

func enter() -> void:
	super()
	call_deferred("setup_health")

func update(delta: float) -> void:
	super(delta)
	if is_player_targetable():
		var player_dist = npc.global_position.distance_to(player.global_position)
		if player_dist < npc.CHASE_TRIGGER_RADIUS:
			transitioned.emit(self, "chase")

func setup_health() -> void:
	if "health" in npc and npc.health:
		npc.health.reset()
		npc.health.show_health_bar(false)
