extends Node2D

signal player_died
signal player_scored
signal player_speed_updated(speed: float)

@export var obstacle_sceens: Array[PackedScene]
@export var obstacle_timer_multiplier: float = 0.99

@export var bounce_velocity: Vector2 = Vector2(0, -125)

var _player: Player
var _obstacle_timer: Timer
var _speed_increase_timer: Timer
var _screen_size: Vector2i
var _initial_obstacle_timer_wait_time: float


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


func _on_level_started() -> void:
	_player.start_running()
	_emit_player_speed_updated()
	
	_obstacle_timer.wait_time = _initial_obstacle_timer_wait_time
	_obstacle_timer.start()
	_speed_increase_timer.start()


func _on_player_hit() -> void:
	get_tree().call_group("obstacles", "queue_free")
	player_died.emit()


func _on_obstacle_left_screen() -> void:
	player_scored.emit()


func _on_obstacle_timer_timeout() -> void:
	var obstacle_sceen: PackedScene = obstacle_sceens.pick_random()
	var obstacle: Obstacle = obstacle_sceen.instantiate()
	
	var obstacle_position := Vector2(_player.position.x + _screen_size.x, _screen_size.y)
	if obstacle.is_bouncing:
		obstacle.linear_velocity = bounce_velocity
	obstacle.position = obstacle_position
	
	var _error_code := obstacle.left_screen.connect(_on_obstacle_left_screen)
	
	add_child(obstacle)


func _emit_player_speed_updated() -> void:
	player_speed_updated.emit(_player.run_speed)


func _on_speed_increase_timer_timeout() -> void:
	_obstacle_timer.wait_time *= obstacle_timer_multiplier
	
	_player.increase_speed()
	_emit_player_speed_updated()
