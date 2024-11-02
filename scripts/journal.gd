extends CanvasLayer

@onready var wrapper: GridContainer = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer
@onready var no_quests_available_label: Label = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Label2
@onready var quest_label_container: VBoxContainer = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var selected_quest_container: VBoxContainer = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/VBoxContainer2
@onready var selected_quest_title_label: Label = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/VBoxContainer2/SelectedQuestTitle
@onready var selected_quest_description_label: Label = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/VBoxContainer2/SelectedQuestDescription
@onready var selected_quest_objective_progress_label: Label = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/VBoxContainer2/HBoxContainer/SelectedQuestObjectiveProgress
@onready var selected_quest_objective_item_label: Label = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/VBoxContainer2/HBoxContainer/SelectedQuestObjectiveItem
@onready var selected_quest_objective_item_texture: TextureRect = $Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/VBoxContainer2/HBoxContainer/SelectedQuestObjectiveItemTexture

var selected_quest: Quest = null

func _ready() -> void:
	QuestManager.quest_activated.connect(_on_quest_activated)
	QuestManager.quest_deactivated.connect(_on_quest_deactivated)
	QuestManager.quest_updated.connect(_on_quest_updated)
	visible = false
	render_quest_buttons()

func _process(_delta: float) -> void:
	if Dialogic.current_timeline == null and Input.is_action_just_pressed("journal"):
		visible = not visible
		GameManager.process_input = not visible

func select_quest(quest: Quest) -> void:
	if selected_quest != quest:
		selected_quest = quest
		selected_quest_container.visible = true
		selected_quest_title_label.text = quest.title
		selected_quest_description_label.text = quest.description
		selected_quest_objective_progress_label.text = "%d / %d" % [quest.objective_quantity_progress, quest.objective_quantity]
		selected_quest_objective_item_texture.visible = true
		selected_quest_objective_item_texture.texture = quest.objective_entity_texture
		if quest.objective_entity is Item:
			selected_quest_objective_item_label.text = quest.objective_entity.title
		else:
			selected_quest_objective_item_label.text = quest.objective_entity.resource_path.get_file().get_basename().replace("_", " ").capitalize()

func deselect_quest() -> void:
	selected_quest = null
	selected_quest_container.visible = false
	selected_quest_title_label.text = ""
	selected_quest_description_label.text = ""
	selected_quest_objective_progress_label.text = ""
	selected_quest_objective_item_label.text = ""
	selected_quest_objective_item_texture.visible = false
	selected_quest_objective_item_texture.texture = null

func check_active_quest_count() -> void:
	var has_active_quests: bool = QuestManager.active_quest_count > 0
	wrapper.visible = has_active_quests
	no_quests_available_label.visible = not has_active_quests

func add_quest_button(quest: Quest) -> void:
	var button: Button = Button.new()
	button.text = quest.title
	button.theme = GameManager.theme
	button.theme_type_variation = "FlatButton"
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	button.pressed.connect(select_quest.bind(quest))
	quest_label_container.add_child(button)

func render_quest_buttons() -> void:
	for button in quest_label_container.get_children():
		quest_label_container.remove_child(button)
		button.queue_free()
	for quest in QuestManager.quests:
		if quest.active:
			add_quest_button(quest)
			if selected_quest == null:
				select_quest(quest)
	check_active_quest_count()

func _on_quest_activated(_quest: Quest) -> void:
	render_quest_buttons()

func _on_quest_deactivated(quest: Quest) -> void:
	if quest == selected_quest:
		deselect_quest()
	for button in quest_label_container.get_children():
		if button.text == quest.title:
			quest_label_container.remove_child(button)
			button.queue_free()
			break
	check_active_quest_count()

func _on_quest_updated(quest: Quest) -> void:
	if quest == selected_quest:
		selected_quest_objective_progress_label.text = "%d / %d" % [quest.objective_quantity_progress, quest.objective_quantity]
