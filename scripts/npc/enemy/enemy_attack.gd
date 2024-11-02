class_name EnemyAttack extends NPCState

func enter() -> void:
	npc.move_speed = 0
	await get_tree().create_timer(0.2).timeout
	transitioned.emit(self, "chase")
