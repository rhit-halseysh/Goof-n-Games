class_name ToggleTileLayer
extends TileMapLayer

@export var hidden_by_default: bool = false
@export var fade_duration: float = 0.4

var _tween: Tween = null

func _ready() -> void:
	modulate.a = 0.0 if hidden_by_default else 1.0

func on_plate_pressed() -> void:
	_fade_to(1.0 if hidden_by_default else 0.0)

func on_plate_released() -> void:
	_fade_to(0.0 if hidden_by_default else 1.0)

func _fade_to(target_alpha: float) -> void:
	if _tween:
		_tween.kill()  # cancel any in-progress fade
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", target_alpha, fade_duration)
	# Disable collision immediately when fading out, re-enable when fully visible
	if target_alpha == 0.0:
		collision_enabled = false
	else:
		_tween.tween_callback(func(): collision_enabled = true)
