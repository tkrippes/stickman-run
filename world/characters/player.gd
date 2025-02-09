class_name Player
extends CharacterBody2D

signal hit

@export var initial_run_speed: float = 75.0
@export var run_speed_multiplier: float = 1.01
@export var jump_speed: float = -250.0

var run_speed: float
var animation: AnimatedSprite2D


func _ready() -> void:
	run_speed = 0.0
	animation = $Animation


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		_jump()
	
	velocity.x = run_speed
	if velocity.x > 0.0:
		animation.animation = "running"
		animation.play()
	else:
		animation.stop()

	var _collided := move_and_slide()
	for index: int in range(get_slide_collision_count()):
		var collider := get_slide_collision(index).get_collider()
		if collider != null && (collider as Node).is_in_group("obstacles"):
			_die()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if (event as InputEventScreenTouch).is_pressed():
			_jump()


func start_running() -> void:
	run_speed = initial_run_speed


func increase_run_speed() -> void:
	run_speed *= run_speed_multiplier


func _jump() -> void:
	if is_on_floor() and run_speed > 0.0:
		velocity.y = jump_speed


func _die() -> void:
	hide()
	run_speed = 0.0
	hit.emit()
