extends Node

signal state_changed(new_state: State)
signal score_changed(new_score: int)

enum State { MENU, PLAYING, GAME_OVER }

var state: State = State.MENU
var score: int = 0


func start_game() -> void:
	score = 0
	score_changed.emit(score)
	state = State.PLAYING
	state_changed.emit(state)


func game_over() -> void:
	state = State.GAME_OVER
	state_changed.emit(state)


func add_score() -> void:
	score += 1
	score_changed.emit(score)


func restart() -> void:
	state = State.MENU
	score = 0
	get_tree().call_deferred("reload_current_scene")
