extends Node

signal ScreenShake

const theme: Theme = preload("res://theme.tres")
const scene_forest: PackedScene = preload("res://scenes/scenes/forest.tscn")
const scene_shop: PackedScene = preload("res://scenes/scenes/shop.tscn")
const scene_cave: PackedScene = preload("res://scenes/scenes/cave.tscn")

var spawn_gateway_name: String
var process_input: bool = true
var boss_fight_active: bool = false

func _ready() -> void:
	SceneManager.scene_loaded.connect(_on_scene_loaded)
	Dialogic.timeline_started.connect(_on_dialogic_timeline_started)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	await get_tree().physics_frame
	Dialogic.Styles.load_style()

func change_scene(destination_scene_tag: String, destination_gateway_name: String):
	var scene_to_load: PackedScene
	
	match destination_scene_tag:
		"forest":
			scene_to_load = scene_forest
		"shop":
			scene_to_load = scene_shop
		"cave":
			scene_to_load = scene_cave
	
	if scene_to_load != null:
		spawn_gateway_name = destination_gateway_name
		SceneManager.change_scene(scene_to_load)

func start_game() -> void:
	SceneManager.change_scene(scene_forest)

func reload_game() -> void:
	SceneManager.reload_scene()
	PlayerData.reset()

func _on_scene_loaded() -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	process_input = true
	if player and spawn_gateway_name:
		for gateway in get_tree().get_nodes_in_group("Gateways"):
			if gateway.name == spawn_gateway_name:
				player.global_position = gateway.spawnpoint.global_position

func _on_dialogic_timeline_started() -> void:
	process_input = false

func _on_dialogic_timeline_ended() -> void:
	process_input = true
