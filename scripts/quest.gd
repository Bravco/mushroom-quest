class_name Quest extends Resource

@export var title: String
@export_multiline var description: String
@export var objective_entity: Resource
@export var objective_entity_texture: Texture2D
@export var objective_quantity: int
@export var timeline: DialogicTimeline
@export var timeline_completed: DialogicTimeline

var active: bool = false
var completed: bool = false
var objective_quantity_progress: int = 0:
	set(value):
		objective_quantity_progress = clamp(value, 0, objective_quantity)
		if not completed and objective_quantity_progress >= objective_quantity:
			completed = true
			QuestManager.quest_completed.emit(self)
