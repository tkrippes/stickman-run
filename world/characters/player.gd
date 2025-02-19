class_name Player
extends CharacterBody2D

signal hit
signal maximum_run_speed_attained

@export var initial_run_speed: float = 75.0
@export var maximum_run_speed: float = 200.0
@export var speed_multiplier: float = 1.02
@export var acceleration: float = 5.0

@export var jump_speed: float = -150.0
@export var gravity_multiplier: float = 0.4

var run_speed: float
var animation: AnimatedSprite2D
var jump_sound: AudioStreamPlayer2D


func _ready() -> void:
	run_speed = 0.0
	animation = $AnimationSprite
	jump_sound = $JumpSound


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += _get_gravity() * delta
	else:
		jump_sound.stop()

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		_jump()

	velocity.x = lerp(velocity.x, run_speed, delta * acceleration)

	if run_speed > 0.0:
		if is_on_floor():
			animation.animation = "run"
		else:
			animation.animation = "jump"
		animation.play()
	else:
		animation.stop()

	var _collided := move_and_slide()
	for index: int in range(get_slide_collision_count()):
		var collider := get_slide_collision(index).get_collider()
		if collider != null && (collider as Node).is_in_group("obstacles"):
			_die()


func start_running() -> void:
	run_speed = initial_run_speed
	animation.speed_scale = 1.0


func increase_speed() -> void:
	if (run_speed * speed_multiplier < maximum_run_speed):
		run_speed *= speed_multiplier
		animation.speed_scale *= speed_multiplier
	elif run_speed < maximum_run_speed:
		animation.speed_scale *= maximum_run_speed / run_speed
		run_speed = maximum_run_speed
		maximum_run_speed_attained.emit()


func _get_gravity() -> Vector2:
	if velocity.y < 0.0 and Input.is_action_pressed("jump"):
		return get_gravity() * gravity_multiplier

	return get_gravity()


func _jump() -> void:
	if is_on_floor() and run_speed > 0.0:
		velocity.y = jump_speed
		jump_sound.pitch_scale = randf_range(0.9, 1.1)
		jump_sound.play()


func _die() -> void:
	hide()
	
	run_speed = 0.0
	animation.animation = "run"
	animation.stop()
	jump_sound.stop()
	
	hit.emit()
