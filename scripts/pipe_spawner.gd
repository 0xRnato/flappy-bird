extends Node2D

@export var pipe_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var min_gap_y: float = 80.0
@export var max_gap_y: float = 176.0
@export var pipe_speed: float = 60.0

var _timer: float = 0.0


func _physics_process(delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING:
		_timer = 0.0
		return

	_timer += delta
	if _timer >= spawn_interval:
		_timer = 0.0
		_spawn_pipe()


func _spawn_pipe() -> void:
	if pipe_scene == null:
		return
	var pipe: Node2D = pipe_scene.instantiate()
	pipe.position = Vector2(position.x, randf_range(min_gap_y, max_gap_y))
	pipe.speed = pipe_speed
	pipe.scored.connect(GameManager.add_score)
	get_parent().add_child(pipe)
