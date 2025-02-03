extends Control


func _on_player_died() -> void:
	($GameOverLabel as Label).show()


func _on_score_updated(score: int) -> void:
	($ScoreLabel as Label).text = "Score: %d" % score
