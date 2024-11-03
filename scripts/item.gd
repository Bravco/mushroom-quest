class_name Item extends Resource

enum UsableType { NONE, HEAL }

@export var title: String
@export var texture: Texture2D
@export_range(0, 1) var drop_chance: float = 1.0

@export var is_usable: bool = false
@export var usable_type: UsableType = UsableType.NONE
@export var usable_amount: int = 0

func use():
	if is_usable:
		match usable_type:
			UsableType.HEAL:
				PlayerData.heal(usable_amount)
