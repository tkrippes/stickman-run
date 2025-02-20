class_name Obstacle
extends RigidBody2D

signal left_screen
@export var bounce_speed: float = 0
@export var move_speed: float = 0
@export var fly_height: float = 0

var _initial_angular_velocity: float


func _ready() -> void:
	linear_velocity -= Vector2(0, bounce_speed)
	linear_velocity -= Vector2(move_speed, 0)
	position -= Vector2(0, fly_height)

	_initial_angular_velocity = angular_velocity


func _physics_process(_delta: float) -> void:
	# ensure that obstacles are not slowed down by moving platform
	linear_velocity.x = - move_speed
	angular_velocity = _initial_angular_velocity


func _on_screen_exited() -> void:
	left_screen.emit()
	queue_free()
