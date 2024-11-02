extends TextureRect

@export_enum("attack", "roll", "journal") var action: String
@export var texture_size: int = 16

func _process(_delta: float) -> void:
	if GameManager.process_input and action and Input.is_action_pressed(action):
		texture.region = Rect2i(texture_size, 0, texture_size, texture_size)
	else:
		texture.region = Rect2i(0, 0, texture_size, texture_size)
