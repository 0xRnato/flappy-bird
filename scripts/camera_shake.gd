extends Camera2D

@export var shake_strength: float = 6.0
@export var shake_duration: float = 0.25

var _shake_time_left: float = 0.0
var _current_strength: float = 0.0


func _ready() -> void:
	GameManager.state_changed.connect(_on_state_changed)


func _process(delta: float) -> void:
	if _shake_time_left <= 0.0:
		offset = Vector2.ZERO
		return
	_shake_time_left -= delta
	var t := clampf(_shake_time_left / shake_duration, 0.0, 1.0)
	var amount := _current_strength * t
	offset = Vector2(randf_range(-amount, amount), randf_range(-amount, amount))
	if _shake_time_left <= 0.0:
		offset = Vector2.ZERO


func _on_state_changed(new_state: int) -> void:
	if new_state == GameManager.State.GAME_OVER:
		shake()


func shake() -> void:
	_current_strength = shake_strength
	_shake_time_left = shake_duration
