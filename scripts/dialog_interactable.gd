extends Area2D

@onready var interact_key: Sprite2D = $InteractKey
@onready var quest_indicator: Sprite2D = $QuestIndicator

@export var timeline: DialogicTimeline
@export var quest: Quest

var can_interact: bool = false

func _ready() -> void:
	QuestManager.quest_activated.connect(_on_quest_activated)
	QuestManager.quest_completed.connect(_on_quest_completed)
	QuestManager.add_quest(quest)
	interact_key.visible = false
	if quest:
		quest_indicator.visible = quest.active or not quest.completed
		if quest.active:
			quest_indicator.frame = 1 if quest.completed else 2
		else:
			quest_indicator.frame = 0
	else:
		quest_indicator.visible = false

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact") and Dialogic.current_timeline == null:
		if quest:
			if quest.active and quest.completed:
				Dialogic.start(quest.timeline_completed)
				QuestManager.deactivate_quest(quest)
				quest_indicator.visible = false
			elif not quest.active and not quest.completed:
				Dialogic.start(quest.timeline)
				QuestManager.activate_quest(quest)
			elif timeline:
				Dialogic.start(timeline)
		elif timeline:
			Dialogic.start(timeline)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		can_interact = true
		interact_key.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		can_interact = false
		interact_key.visible = false

func _on_quest_activated(activated_quest: Quest) -> void:
	if activated_quest == quest:
		quest_indicator.frame = 2

func _on_quest_completed(completed_quest: Quest) -> void:
	if completed_quest == quest:
		quest_indicator.frame = 1
