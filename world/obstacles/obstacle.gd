class_name Obstacle
extends RigidBody2D

signal left_screen

@export var is_bouncing: bool


func _on_screen_exited() -> void:
	left_screen.emit()
	queue_free()
