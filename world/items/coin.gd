class_name Coin
extends Area2D

## The signal emitted when the player hits the coin.
signal player_hit
## The signal emitted when an obstacle hits the coin.
signal obstacle_hit


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_hit.emit()
		queue_free()
	elif body is Obstacle:
		obstacle_hit.emit()
		queue_free()


func _on_screen_exited() -> void:
	queue_free()
