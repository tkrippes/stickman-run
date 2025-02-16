extends Node2D

signal player_died
signal player_scored
signal player_speed_updated(speed: float)
signal player_maximum_speed_attained

@export var level_1_obstacle_scenes: Array[PackedScene]
@export var level_2_obstacle_scenes: Array[PackedScene]
@export var level_3_obstacle_scenes: Array[PackedScene]
@export var level_4_obstacle_scenes: Array[PackedScene]

@export var ground_height: int = 6
@export var obstacle_timer_multiplier: float = 0.98
@export var obstacle_bounce_speed: float = 125
@export var obstacle_move_speed: float = 15
@export var obstacle_fly_height: float = 24

var _player: Player
var _obstacle_timer: Timer
var _speed_increase_timer: Timer
var _screen_size: Vector2i
var _initial_obstacle_timer_wait_time: float
var _obstacle_scenes: Array[PackedScene]


func _ready() -> void:
	_player = $Player
	_obstacle_timer = $Obstacletimer
	_speed_increase_timer = $SpeedIncreaseTimer
	_initial_obstacle_timer_wait_time = _obstacle_timer.wait_time

	_emit_player_speed_updated()

	_screen_size = get_viewport_rect().size


func _on_game_started() -> void:
	_player.show()
	_emit_player_speed_updated()


func _on_level_started(level: int) -> void:
	_player.start_running()
	_emit_player_speed_updated()

	get_tree().call_group("obstacles", "queue_free")
	if level == 1:
		_obstacle_scenes = level_1_obstacle_scenes
	elif level == 2:
		_obstacle_scenes = level_2_obstacle_scenes
	elif level == 3:
		_obstacle_scenes = level_3_obstacle_scenes
	elif level == 4:
		_obstacle_scenes = level_4_obstacle_scenes
	else:
		push_warning("Unknown level '%d' started" % level)

	_obstacle_timer.wait_time = _initial_obstacle_timer_wait_time
	_obstacle_timer.start()
	_speed_increase_timer.start()


func _on_player_hit() -> void:
	get_tree().call_group("obstacles", "queue_free")
	player_died.emit()


func _on_player_maximum_run_speed_attained() -> void:
	player_maximum_speed_attained.emit()


func _on_obstacle_left_screen() -> void:
	player_scored.emit()


func _on_obstacle_timer_timeout() -> void:
	var obstacle_sceen: PackedScene = _obstacle_scenes.pick_random()
	var obstacle: Obstacle          = obstacle_sceen.instantiate()

	var obstacle_position := Vector2(_player.position.x + _screen_size.x, _screen_size.y - ground_height)
	if obstacle.is_bouncing:
		obstacle.linear_velocity -= Vector2(0, obstacle_bounce_speed)
	if obstacle.is_moving:
		obstacle.linear_velocity -= Vector2(obstacle_move_speed, 0)
		
	obstacle.position = obstacle_position
	if obstacle.is_flying:
		obstacle.position -= Vector2(0, obstacle_fly_height)

	var _error_code := obstacle.left_screen.connect(_on_obstacle_left_screen)

	add_child(obstacle)


func _emit_player_speed_updated() -> void:
	player_speed_updated.emit(_player.run_speed)


func _on_speed_increase_timer_timeout() -> void:
	_obstacle_timer.wait_time *= obstacle_timer_multiplier

	_player.increase_speed()
	_emit_player_speed_updated()
