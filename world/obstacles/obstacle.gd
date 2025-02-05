class_name Obstacle
extends RigidBody2D

signal left_screen


func _on_screen_exited() -> void:
	left_screen.emit()
	queue_free()
