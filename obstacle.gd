class_name Obstacle
extends RigidBody2D

@export var speed: float = 75.0


func _physics_process(delta: float) -> void:
	var _collision := move_and_collide(Vector2(-speed * delta, 0))
