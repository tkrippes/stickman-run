extends RigidBody2D

@export var speed: float = 300.0


func _physics_process(delta: float) -> void:
    move_and_collide(Vector2(-speed * delta, 0))