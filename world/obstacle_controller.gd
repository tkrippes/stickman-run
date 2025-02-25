class_name ObstacleController
extends Node2D

signal obstacle_destroyed(points: int)
@export var level_1_scenes: Array[PackedScene]
@export var level_2_scenes: Array[PackedScene]
@export var level_3_scenes: Array[PackedScene]
@export var level_4_scenes: Array[PackedScene]
@export var base_position: Vector2 = Vector2(192, 90)
@export var spawn_rate_multiplier: float = 0.98
@export var minimum_random_spawn_rate_multiplier: float = 0.8
@export var maximum_random_spawn_rate_multiplier: float = 1.2
@export var points: int = 1

var _spawn_timer: Timer
var _initial_spawn_rate: float
var _base_spawn_rate: float
var _scenes: Array[PackedScene]
var _player_position: Vector2


func _ready() -> void:
	_spawn_timer = $SpawnTimer
	_initial_spawn_rate = _spawn_timer.wait_time
	_base_spawn_rate = _initial_spawn_rate


func _on_obstacle_left_screen() -> void:
	obstacle_destroyed.emit(points)


func _on_spawn_timer_timeout() -> void:
	var obstacle := _create_obstacle()
	
	add_child(obstacle)


func _on_player_position_updated(player_position: Vector2) -> void:
	_player_position = player_position


func set_obstacles_scenes(level: int) -> void:
	if level == 1:
		_scenes = level_1_scenes
	elif level == 2:
		_scenes = level_2_scenes
	elif level == 3:
		_scenes = level_3_scenes
	elif level == 4:
		_scenes = level_4_scenes
	else:
		push_warning("Unknown level '%d' started" % level)


func start_spawning() -> void:
	_spawn_timer.start()


func stop_spawning() -> void:
	_spawn_timer.stop()


func reset_spawn_rate() -> void:
	_base_spawn_rate = _initial_spawn_rate
	_set_spawn_rate()


func increase_spawn_rate() -> void:
	_base_spawn_rate *= spawn_rate_multiplier
	_set_spawn_rate()


func delete_obstacles() -> void:
	get_tree().call_group("obstacles", "queue_free")


func _create_obstacle() -> Obstacle:
	var scene: PackedScene = _scenes.pick_random()
	var obstacle: Obstacle = scene.instantiate()
	obstacle.position = Vector2(base_position.x + _player_position.x,
	base_position.y)

	var _error_code := obstacle.left_screen.connect(_on_obstacle_left_screen)

	return obstacle


func _set_spawn_rate() -> void:
	_spawn_timer.wait_time = randf_range(
		minimum_random_spawn_rate_multiplier * _base_spawn_rate,
		maximum_random_spawn_rate_multiplier * _base_spawn_rate)
