extends CanvasLayer

func _on_start_button_pressed() -> void:
	GameManager.start_game()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
