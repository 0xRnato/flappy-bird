extends Node2D

signal scored

@export var speed: float = 60.0

var _scored: bool = false


func _physics_process(delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING:
		return

	position.x -= speed * delta

	if position.x < -30:
		queue_free()


func _on_score_area_entered(_area: Area2D) -> void:
	if _scored:
		return
	_scored = true
	$ScoreSFX.play()
	scored.emit()
