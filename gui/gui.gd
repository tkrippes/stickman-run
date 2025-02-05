extends CanvasLayer


func _on_player_died() -> void:
	($Control/GameOverLabel as Label).show()


func _on_score_updated(score: int) -> void:
	($Control/ScoreLabel as Label).text = "Score: %d" % score


func _on_player_speed_updated(speed: float) -> void:
	($Control/SpeedLabel as Label).text = "Speed: %.1f" % speed
