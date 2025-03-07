class_name ObstacleController
extends Node2D

## The signal emitted when an obstacle is destroyed.
signal obstacle_destroyed(points: int)
## The scenes used for level 1 obstacles.
@export var level_1_scenes: Array[PackedScene]
## The scenes used for level 2 obstacles.
@export var level_2_scenes: Array[PackedScene]
## The scenes used for level 3 obstacles.
@export var level_3_scenes: Array[PackedScene]
## The scenes used for level 4 obstacles.
@export var level_4_scenes: Array[PackedScene]
## The base position of the obstacles relative to the player's horizontal position. The vertical position is always the same, no matter the vertical position of the player.
@export var base_position: Vector2 = Vector2(192, 90)
## The rate at which the spawn rate (timer wait time) will get multiplied when the spawn rate increases.
@export var spawn_rate_multiplier: float = 0.98
## The minimum random multiplier for the spawn rate. The spawn rate is always between the minimum and maximum random spawn rate multipliers multiplied by the base spawn rate.
@export var minimum_random_spawn_rate_multiplier: float = 2.0 / 3.0
## The maximum random multiplier for the spawn rate. The spawn rate is always between the minimum and maximum random spawn rate multipliers multiplied by the base spawn rate.
@export var maximum_random_spawn_rate_multiplier: float = 3.0 /2.0
## The points given when an obstacle is destroyed.
@export var points: int = 1

@onready var _spawn_timer: Timer = $SpawnTimer
var _initial_spawn_rate: float
var _base_spawn_rate: float
var _scenes: Array[PackedScene]
var _player_position: Vector2


func _ready() -> void:
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
	match level:
		1: _scenes = level_1_scenes
		2: _scenes = level_2_scenes
		3: _scenes = level_3_scenes
		4: _scenes = level_4_scenes
		_: push_warning("Cannot set obstacles scenes for unknown level '%d'" % level)


func start_spawning() -> void:
	_reset_spawn_rate()
	_spawn_timer.start()


func stop_spawning() -> void:
	_spawn_timer.stop()


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


func _reset_spawn_rate() -> void:
	_base_spawn_rate = _initial_spawn_rate
	_set_spawn_rate()


func _set_spawn_rate() -> void:
	_spawn_timer.wait_time = randf_range(
		minimum_random_spawn_rate_multiplier * _base_spawn_rate,
		maximum_random_spawn_rate_multiplier * _base_spawn_rate)
