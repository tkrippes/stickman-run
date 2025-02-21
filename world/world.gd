extends Node2D

signal player_died
signal player_scored(points: int)
signal player_speed_updated(speed: float)
signal player_maximum_speed_attained

@export var level_1_obstacle_scenes: Array[PackedScene]
@export var level_2_obstacle_scenes: Array[PackedScene]
@export var level_3_obstacle_scenes: Array[PackedScene]
@export var level_4_obstacle_scenes: Array[PackedScene]

@export var coin_scene: PackedScene

@export var ground_height: int = 6
@export var maximum_coin_height: int = 24
@export var obstacle_spawn_timer_wait_time_multiplier: float = 0.98

@export var obstacle_points: int = 1
@export var coin_points: int = 3

var _screen_size: Vector2i

var _player: Player
var _player_speed_increase_timer: Timer

var _obstacle_spawn_timer: Timer
var _initial_obstacle_spawn_timer_wait_time: float
var _obstacle_scenes: Array[PackedScene]

var _coin_spawn_timer: Timer


func _ready() -> void:
	_screen_size = get_viewport_rect().size
	
	_player = $Player
	_player_speed_increase_timer = $PlayerSpeedIncreaseTimer
	_emit_player_speed_updated()
	
	_obstacle_spawn_timer = $ObstacleSpawnTimer
	_initial_obstacle_spawn_timer_wait_time = _obstacle_spawn_timer.wait_time
	
	_coin_spawn_timer = $CoinSpawnTimer


func _on_game_started() -> void:
	_player.show()
	_emit_player_speed_updated()


func _on_level_started(level: int) -> void:
	_player.start_running()
	_emit_player_speed_updated()

	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("coins", "queue_free")
	
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
	
	_player_speed_increase_timer.start()
	_obstacle_spawn_timer.wait_time = _initial_obstacle_spawn_timer_wait_time
	_obstacle_spawn_timer.start()
	_coin_spawn_timer.start()


func _on_player_hit() -> void:
	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("coins", "queue_free")
	player_died.emit()


func _on_player_maximum_run_speed_attained() -> void:
	_player_speed_increase_timer.stop()
	player_maximum_speed_attained.emit()


func _on_obstacle_left_screen() -> void:
	player_scored.emit(obstacle_points)


func _on_coin_collected() -> void:
	($CoinCollectedSound as AudioStreamPlayer).play()
	player_scored.emit(coin_points)


func _on_obstacle_spawn_timer_timeout() -> void:
	var obstacle_sceen: PackedScene = _obstacle_scenes.pick_random()
	var obstacle: Obstacle          = obstacle_sceen.instantiate()
	obstacle.position = Vector2(_player.position.x + _screen_size.x, _screen_size.y - ground_height)

	var _error_code := obstacle.left_screen.connect(_on_obstacle_left_screen)

	add_child(obstacle)


func _on_coin_spawn_timer_timeout() -> void:
	var coin: Coin = coin_scene.instantiate()
	coin.position = Vector2(_player.position.x + _screen_size.x, _screen_size.y - ground_height - randf_range(0, maximum_coin_height))
	
	var _error_code := coin.collected.connect(_on_coin_collected)
	
	add_child(coin)


func _emit_player_speed_updated() -> void:
	player_speed_updated.emit(_player.velocity.x)


func _on_player_speed_increase_timer_timeout() -> void:
	_obstacle_spawn_timer.wait_time *= obstacle_spawn_timer_wait_time_multiplier

	_player.increase_speed()
	_emit_player_speed_updated()
