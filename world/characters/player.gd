class_name Player
extends CharacterBody2D

signal hit
signal maximum_run_speed_attained
signal position_updated(position: Vector2)
@export var initial_run_speed: float = 80.0
@export var maximum_run_speed: float = 180.0
@export var speed_multiplier: float = 1.019
@export var acceleration: float = 5.0
@export var jump_speed: float = -150.0
@export var gravity_multiplier: float = 0.4

@onready var _animation: AnimatedSprite2D = $AnimationSprite
@onready var _jump_sound: AudioStreamPlayer = $JumpSound
var _run_speed: float


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += _get_gravity() * delta
	else:
		_jump_sound.stop()

	if Input.is_action_just_pressed("jump"):
		_jump()

	velocity.x = lerp(velocity.x, _run_speed, delta * acceleration)

	_handle_animation()
	_handle_collision()

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
		_play_jump_sound()


func _die() -> void:
	hide()
	_reset()

	hit.emit()


func _reset() -> void:
	_run_speed = 0.0
	_animation.animation = "run"
	_animation.stop()
	_jump_sound.stop()


func _handle_animation() -> void:
	if _run_speed > 0.0:
		if is_on_floor():
			_animation.animation = "run"
		else:
			_animation.animation = "jump"

		_animation.play()
	else:
		_animation.stop()


func _handle_collision() -> void:
	var _collided := move_and_slide()
	for index: int in range(get_slide_collision_count()):
		var collider := get_slide_collision(index).get_collider()
		if collider != null && (collider as Node).is_in_group("obstacles"):
			_die()

			return


func _play_jump_sound() -> void:
	_jump_sound.pitch_scale = randf_range(0.9, 1.1)
	_jump_sound.play()