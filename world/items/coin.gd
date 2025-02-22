class_name Coin
extends Area2D

signal player_hit
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
