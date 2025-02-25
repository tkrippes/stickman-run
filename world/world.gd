extends Node2D

signal player_died
signal player_scored(points: int)
signal player_speed_updated(speed: float)
signal player_maximum_speed_attained

var _player: Player
var _player_speed_increase_timer: Timer
var _coin_controller: CoinController
var _obstacle_controller: ObstacleController


func _ready() -> void:
	_player = $Player
	_player_speed_increase_timer = $PlayerSpeedIncreaseTimer
	_emit_player_speed_updated()

	_coin_controller = $CoinController
	_obstacle_controller = $ObstacleController


func _on_game_started() -> void:
	_player.show()
	_emit_player_speed_updated()


func _on_level_started(level: int) -> void:
	_player.start_running()
	_emit_player_speed_updated()

	_obstacle_controller.delete_obstacles()
	_coin_controller.delete_coins()
	
	_obstacle_controller.set_obstacles_scenes(level)

	_player_speed_increase_timer.start()
	_obstacle_controller.reset_spawn_rate()
	_obstacle_controller.start_spawning()
	_coin_controller.start_spawning()


func _on_player_hit() -> void:
	_obstacle_controller.delete_obstacles()
	_obstacle_controller.stop_spawning()
	
	_coin_controller.delete_coins()
	_coin_controller.stop_spawning()
	
	player_died.emit()


func _on_player_maximum_run_speed_attained() -> void:
	_player_speed_increase_timer.stop()
	player_maximum_speed_attained.emit()


func _on_obstacle_destroyed(points: int) -> void:
	player_scored.emit(points)


func _on_coin_collected(points: int) -> void:
	player_scored.emit(points)


func _on_player_speed_increase_timer_timeout() -> void:
	_obstacle_controller.increase_spawn_rate()

	_player.increase_speed()
	_emit_player_speed_updated()


func _emit_player_speed_updated() -> void:
	player_speed_updated.emit(_player.velocity.x)
