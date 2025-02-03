extends Node

signal score_updated(score: int)

var score: int = 0


func _on_player_scored() -> void:
	score += 1
	score_updated.emit(score)
