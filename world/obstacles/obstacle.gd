class_name Obstacle
extends RigidBody2D

signal left_screen

@export var is_bouncing: bool
@export var bounce_speed: float = 125

@export var is_moving: bool
@export var move_speed: float = 15

@export var is_flying: bool
@export var fly_height: float = 24


func _ready() -> void:
	if is_bouncing:
		linear_velocity -= Vector2(0, bounce_speed)
	if is_moving:
		linear_velocity -= Vector2(move_speed, 0)
	if is_flying:
		position -= Vector2(0, fly_height)


func _physics_process(_delta: float) -> void:
	if is_moving:
		linear_velocity.x = - move_speed


func _on_screen_exited() -> void:
	left_screen.emit()
	queue_free()
