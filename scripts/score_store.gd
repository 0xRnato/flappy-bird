extends Node

const SAVE_PATH := "user://score.cfg"
const SECTION := "score"
const KEY_BEST := "best"

var best: int = 0


func _ready() -> void:
	_load()


func record(score: int) -> bool:
	if score <= best:
		return false
	best = score
	_save()
	return true


func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	best = int(cfg.get_value(SECTION, KEY_BEST, 0))


func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value(SECTION, KEY_BEST, best)
	cfg.save(SAVE_PATH)
