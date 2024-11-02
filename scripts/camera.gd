extends Camera2D

const SHAKE_INTENSITY: float = 5.0
const SHAKE_DURATION: float = 0.2

func _ready() -> void:
	GameManager.ScreenShake.connect(screen_shake)
	set_process(false)
	randomize()

func _process(_delta: float) -> void:
	var shake_vector: Vector2 = Vector2(randf_range(-1, 1) * SHAKE_INTENSITY, randf_range(-1, 1) * SHAKE_INTENSITY)
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset", shake_vector, 0.1)

func screen_shake() -> void:
	set_process(true)
	await get_tree().create_timer(SHAKE_DURATION).timeout
	set_process(false)
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset", Vector2.ZERO, 0.1)
