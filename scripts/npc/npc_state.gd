class_name NPCState extends State

@onready var npc: CharacterBody2D = owner
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var navigation_agent: NavigationAgent2D = owner.find_child("NavigationAgent2D")

func is_player_targetable() -> bool:
	if PlayerData.health > 0:
		return true
	else:
		return false
