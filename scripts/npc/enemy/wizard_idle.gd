class_name WizardIdle extends NPCState

func enter() -> void:
	super()
	call_deferred("setup_health")

func update(delta: float) -> void:
	super(delta)
	if GameManager.boss_fight_active:
		transitioned.emit(self, "chase")

func setup_health() -> void:
	if "health" in npc and npc.health:
		npc.health.reset()
		npc.health.show_health_bar(false)
