extends CanvasLayer

@onready var _score_label: Label = $Root/ScoreLabel
@onready var _best_label: Label = $Root/BestLabel
@onready var _game_over_panel: Control = $Root/GameOverPanel
@onready var _final_score_label: Label = $Root/GameOverPanel/FinalScore
@onready var _final_best_label: Label = $Root/GameOverPanel/FinalBest
@onready var _new_best_label: Label = $Root/GameOverPanel/NewBest
@onready var _menu_panel: Control = $Root/MenuPanel


func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.state_changed.connect(_on_state_changed)
	_refresh_best()
	_on_state_changed(GameManager.state)
	_on_score_changed(GameManager.score)


func _on_score_changed(new_score: int) -> void:
	_score_label.text = str(new_score)


func _on_state_changed(new_state: int) -> void:
	match new_state:
		GameManager.State.MENU:
			_score_label.visible = false
			_menu_panel.visible = true
			_game_over_panel.visible = false
			_refresh_best()
		GameManager.State.PLAYING:
			_score_label.visible = true
			_menu_panel.visible = false
			_game_over_panel.visible = false
		GameManager.State.GAME_OVER:
			_score_label.visible = false
			_menu_panel.visible = false
			_game_over_panel.visible = true
			_final_score_label.text = "SCORE %d" % GameManager.score
			_final_best_label.text = "BEST %d" % ScoreStore.best
			_new_best_label.visible = GameManager.last_is_new_best
			_refresh_best()


func _refresh_best() -> void:
	_best_label.text = "BEST %d" % ScoreStore.best
