extends Node2D

func _on_start_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.boss_fight_active = not GameManager.boss_fight_active

func _on_reset_body_entered(body: Node2D) -> void:
	if body is Player and GameManager.boss_fight_active:
		GameManager.boss_fight_active = false
