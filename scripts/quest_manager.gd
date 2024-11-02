extends Node

signal quest_activated
signal quest_deactivated
signal quest_updated
signal quest_completed

var quests: Array[Quest]
var active_quest_count: int = 0

func add_quest(quest: Quest) -> void:
	if quest != null and quest not in QuestManager.quests:
		QuestManager.quests.append(quest)

func activate_quest(quest: Quest) -> void:
	quest.active = true
	active_quest_count += 1
	quest_activated.emit(quest)

func deactivate_quest(quest: Quest) -> void:
	quest.active = false
	active_quest_count -= 1
	quest_deactivated.emit(quest)

func process_enemy_death(enemy_scene_path: String) -> void:
	for quest in quests:
		if not quest.active or quest.completed:
			continue
		if quest.objective_entity.resource_path == enemy_scene_path:
			quest.objective_quantity_progress += 1
			quest_updated.emit(quest)

func process_item_pick_up(item: Item) -> void:
	for quest in quests:
		if not quest.active or quest.completed:
			continue
		if quest.objective_entity is Item:
			if quest.objective_entity.title == item.title:
				quest.objective_quantity_progress += 1
				quest_updated.emit(quest)
