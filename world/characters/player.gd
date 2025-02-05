extends CharacterBody2D

signal hit

@export var jump_speed: float = -250.0

var _run_speed: float


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jump()
	
	velocity.x = _run_speed
		  

	var _collided := move_and_slide()
	for index: int in range(get_slide_collision_count()):
		var collider := get_slide_collision(index).get_collider()
		if collider != null && (collider as Node).is_in_group("obstacles"):
			die()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if (event as InputEventScreenTouch).pressed and is_on_floor():
			_jump()


func _jump() -> void:
	velocity.y = jump_speed


func set_run_speed(run_speed: float) -> void:
	_run_speed = run_speed


func die() -> void:
	queue_free()
	hit.emit()
