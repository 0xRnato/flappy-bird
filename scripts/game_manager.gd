extends Node

signal state_changed(new_state: State)
signal score_changed(new_score: int)

enum State { MENU, PLAYING, GAME_OVER }

var state: State = State.MENU
var score: int = 0
var last_is_new_best: bool = false

var _ui_player: AudioStreamPlayer


func _ready() -> void:
	_ui_player = AudioStreamPlayer.new()
	_ui_player.stream = load("res://assets/sfx/ui.ogg")
	_ui_player.volume_db = -8.0
	add_child(_ui_player)


func _play_ui() -> void:
	if _ui_player != null:
		_ui_player.play()


func start_game() -> void:
	score = 0
	last_is_new_best = false
	score_changed.emit(score)
	state = State.PLAYING
	state_changed.emit(state)


func game_over() -> void:
	if state == State.GAME_OVER:
		return
	last_is_new_best = ScoreStore.record(score)
	state = State.GAME_OVER
	state_changed.emit(state)


func add_score() -> void:
	score += 1
	score_changed.emit(score)


func restart() -> void:
	_play_ui()
	state = State.MENU
	score = 0
	get_tree().call_deferred("reload_current_scene")
