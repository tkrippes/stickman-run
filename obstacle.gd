class_name Obstacle
extends RigidBody2D

var speed: float


func _physics_process(delta: float) -> void:
	var _collision := move_and_collide(Vector2(-speed * delta, 0))


func delete() -> void:
	queue_free()


func set_speed(new_speed: float) -> void:
	speed = new_speed
