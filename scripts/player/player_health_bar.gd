extends ProgressBar

func _ready() -> void:
	PlayerData.Harm.connect(_update_value)
	PlayerData.Heal.connect(_update_value)
	max_value = PlayerData.MAX_HEALTH
	value = PlayerData.health

func _update_value() -> void:
	value = PlayerData.health
