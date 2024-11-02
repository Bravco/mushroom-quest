class_name Gateway extends Area2D

@onready var spawnpoint: Marker2D = $Spawnpoint

@export var gateway_tag: String
@export var destination_scene_tag: String
@export var destination_gateway_tag: String

func _ready() -> void:
	if gateway_tag:
		name = "gateway_" + gateway_tag

func _on_body_entered(body: Node2D) -> void:
	if body is Player and destination_scene_tag:
		GameManager.change_scene(destination_scene_tag, name)
