extends Area2D

signal died

@export var fall_gravity: float = 600.0
@export var flap_impulse: float = -180.0
@export var max_fall_speed: float = 300.0
@export var rotation_lerp_speed: float = 8.0
@export var hitstop_duration: float = 0.55

var _velocity_y: float = 0.0
var _alive: bool = true


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING:
		return

	_velocity_y += fall_gravity * delta
	_velocity_y = min(_velocity_y, max_fall_speed)
	position.y += _velocity_y * delta

	# Tilt bird based on vertical speed
	var target_rotation := clampf(_velocity_y * 0.004, deg_to_rad(-30), deg_to_rad(90))
	rotation = lerp(rotation, target_rotation, rotation_lerp_speed * delta)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flap"):
		if GameManager.state == GameManager.State.MENU:
			GameManager.start_game()
			_flap()
		elif GameManager.state == GameManager.State.PLAYING and _alive:
			_flap()
		elif GameManager.state == GameManager.State.GAME_OVER:
			GameManager.restart()


func _flap() -> void:
	_velocity_y = flap_impulse
	$FlapSFX.play()
	$FlapPuff.restart()


func _die() -> void:
	if not _alive:
		return
	_alive = false
	$HitSFX.play()
	$HitBurst.restart()
	died.emit()
	await get_tree().create_timer(hitstop_duration).timeout
	GameManager.game_over()


func _on_area_entered(_area: Area2D) -> void:
	_die()
