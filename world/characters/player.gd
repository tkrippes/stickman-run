class_name Player
extends CharacterBody2D

signal hit
signal maximum_run_speed_attained
signal position_updated(position: Vector2)
@export var initial_run_speed: float = 75.0
@export var maximum_run_speed: float = 200.0
@export var speed_multiplier: float = 1.02
@export var acceleration: float = 5.0
@export var jump_speed: float = -150.0
@export var gravity_multiplier: float = 0.4

var _run_speed: float
var _animation: AnimatedSprite2D
var _jump_sound: AudioStreamPlayer


func _ready() -> void:
	_run_speed = 0.0
	_animation = $AnimationSprite

	_jump_sound = $JumpSound


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += _get_gravity() * delta
	else:
		_jump_sound.stop()

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		_jump()

	velocity.x = lerp(velocity.x, _run_speed, delta * acceleration)

	if _run_speed > 0.0:
		if is_on_floor():
			_animation.animation = "run"
		else:
			_animation.animation = "jump"
		_animation.play()
	else:
		_animation.stop()

	var _collided := move_and_slide()
	for index: int in range(get_slide_collision_count()):
		var collider := get_slide_collision(index).get_collider()
		if collider != null && (collider as Node).is_in_group("obstacles"):
			_die()

	position_updated.emit(position)


func start_running() -> void:
	_run_speed = initial_run_speed
	_animation.speed_scale = 1.0


func increase_speed() -> void:
	if (_run_speed * speed_multiplier < maximum_run_speed):
		_run_speed *= speed_multiplier
		_animation.speed_scale *= speed_multiplier
	elif _run_speed < maximum_run_speed:
		_animation.speed_scale *= maximum_run_speed / _run_speed
		_run_speed = maximum_run_speed
	elif velocity.x >= maximum_run_speed - 0.1:
		velocity.x = maximum_run_speed
		maximum_run_speed_attained.emit()


func _get_gravity() -> Vector2:
	if velocity.y < 0.0 and Input.is_action_pressed("jump"):
		return get_gravity() * gravity_multiplier

	return get_gravity()


func _jump() -> void:
	if is_on_floor() and _run_speed > 0.0:
		velocity.y = jump_speed
		_jump_sound.pitch_scale = randf_range(0.9, 1.1)
		_jump_sound.play()


func _die() -> void:
	hide()

	_run_speed = 0.0
	_animation.animation = "run"
	_animation.stop()
	_jump_sound.stop()

	hit.emit()
