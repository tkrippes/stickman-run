class_name Obstacle
extends RigidBody2D

signal left_screen

var speed: float


func _physics_process(delta: float) -> void:
	var _collision := move_and_collide(Vector2(-speed * delta, 0))


func set_speed(new_speed: float) -> void:
	speed = new_speed


func _on_screen_exited() -> void:
	left_screen.emit()
	queue_free()
