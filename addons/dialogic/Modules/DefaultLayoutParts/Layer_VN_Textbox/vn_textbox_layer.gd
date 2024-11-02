@tool
extends DialogicLayoutLayer

enum AnimationsIn {NONE, POP_IN, FADE_UP}
enum AnimationsOut {NONE, POP_OUT, FADE_DOWN}
enum AnimationsNewText {NONE, WIGGLE}

@export_group("Box")

@export_subgroup("Size & Position")
@export var box_size: Vector2 = Vector2(550, 110)
@export var box_margin_bottom: int = 15

@export_subgroup("Animation")
@export var box_animation_in: AnimationsIn = AnimationsIn.FADE_UP
@export var box_animation_out: AnimationsOut = AnimationsOut.FADE_DOWN
@export var box_animation_new_text: AnimationsNewText = AnimationsNewText.NONE

@export_group("Indicators")

@export_subgroup("Next Indicator")
@export var next_indicator_enabled: bool = true
@export var next_indicator_show_on_questions: bool = true
@export var next_indicator_show_on_autoadvance: bool = false
@export_enum('bounce', 'blink', 'none') var next_indicator_animation: int = 0

@export_subgroup("Autoadvance")
@export var autoadvance_progressbar: bool = true

@export_group('Sounds')

@export_subgroup('Typing Sounds')
@export var typing_sounds_enabled: bool = true
@export var typing_sounds_mode: DialogicNode_TypeSounds.Modes = DialogicNode_TypeSounds.Modes.INTERRUPT
@export_dir var typing_sounds_sounds_folder: String = "res://addons/dialogic/Example Assets/sound-effects/"
@export_file("*.wav", "*.ogg", "*.mp3") var typing_sounds_end_sound: String = ""
@export_range(1, 999, 1) var typing_sounds_every_nths_character: int = 1
@export_range(0.01, 4, 0.01) var typing_sounds_pitch: float = 1.0
@export_range(0.0, 3.0) var typing_sounds_pitch_variance: float = 0.0
@export_range(-80, 24, 0.01) var typing_sounds_volume: float = -10
@export_range(0.0, 10) var typing_sounds_volume_variance: float = 0.0
@export var typing_sounds_ignore_characters: String = " .,!?"

func _apply_export_overrides() -> void:
	if !is_inside_tree():
		await ready

	## BOX SETTINGS
	_apply_box_settings()

	## BOX ANIMATIONS
	_apply_box_animations_settings()

	## NEXT INDICATOR SETTINGS
	_apply_indicator_settings()

	## OTHER
	var progress_bar: ProgressBar = %AutoAdvanceProgressbar
	progress_bar.set(&'enabled', autoadvance_progressbar)

	#### SOUNDS

	## TYPING SOUNDS
	_apply_sounds_settings()

## Applies all text box settings to the scene.
## Except the box animations.
func _apply_box_settings() -> void:
	var sizer: Control = %Sizer
	sizer.size = box_size
	sizer.position = box_size * Vector2(-0.5, -1)+Vector2(0, -box_margin_bottom)


## Applies box animations settings to the scene.
func _apply_box_animations_settings() -> void:
	var animations: AnimationPlayer = %Animations
	animations.set(&'animation_in', box_animation_in)
	animations.set(&'animation_out', box_animation_out)
	animations.set(&'animation_new_text', box_animation_new_text)

## Applies all indicator settings to the scene.
func _apply_indicator_settings() -> void:
	var next_indicator: DialogicNode_NextIndicator = %NextIndicator
	next_indicator.enabled = next_indicator_enabled

	if next_indicator_enabled:
		next_indicator.animation = next_indicator_animation as DialogicNode_NextIndicator.Animations
		next_indicator.show_on_questions = next_indicator_show_on_questions
		next_indicator.show_on_autoadvance = next_indicator_show_on_autoadvance


## Applies all sound settings to the scene.
func _apply_sounds_settings() -> void:
	var type_sounds: DialogicNode_TypeSounds = %DialogicNode_TypeSounds
	type_sounds.enabled = typing_sounds_enabled
	type_sounds.mode = typing_sounds_mode

	if not typing_sounds_sounds_folder.is_empty():
		type_sounds.sounds = DialogicNode_TypeSounds.load_sounds_from_path(typing_sounds_sounds_folder)
	else:
		type_sounds.sounds.clear()

	if not typing_sounds_end_sound.is_empty():
		type_sounds.end_sound = load(typing_sounds_end_sound)
	else:
		type_sounds.end_sound = null

	type_sounds.play_every_character = typing_sounds_every_nths_character
	type_sounds.base_pitch = typing_sounds_pitch
	type_sounds.base_volume = typing_sounds_volume
	type_sounds.pitch_variance = typing_sounds_pitch_variance
	type_sounds.volume_variance = typing_sounds_volume_variance
	type_sounds.ignore_characters = typing_sounds_ignore_characters
