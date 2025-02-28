extends Node2D

## The signal emitted when the player dies.
signal player_died
## The signal emitted when the player falls.
signal player_fell
## The signal emitted when the player scores points.
signal player_scored(points: int)
## The signal emitted when the player's speed is updated.
signal player_speed_updated(speed: float)
## The signal emitted when the player reaches the maximum run speed.
signal player_maximum_speed_attained
## The signal emitted when the player stops running.
signal player_stopped(player_position_x: int)
## The scene of the secret item.
@export var secret_item_scene: PackedScene
## The base position of the secret item.
@export var secret_item_base_position: Vector2 = Vector2(156, 90)

@onready var _player: Player = $Player
@onready var _player_speed_increase_timer: Timer = $Player/SpeedIncreaseTimer
@onready var _coin_controller: CoinController = $CoinController
@onready var _obstacle_controller: ObstacleController = $ObstacleController


func _on_game_started() -> void:
	_player.show()
	_emit_player_speed_updated()


func _on_level_started(level: int) -> void:
	_player.start_running()
	_emit_player_speed_updated()
	_player_speed_increase_timer.start()

	_obstacle_controller.delete_obstacles()
	_obstacle_controller.set_obstacles_scenes(level)
	_obstacle_controller.start_spawning()

	_coin_controller.delete_coins()
	_coin_controller.set_spawn_rate(level)
	_coin_controller.start_spawning()


func _on_game_won() -> void:
	_obstacle_controller.delete_obstacles()
	_obstacle_controller.stop_spawning()

	_coin_controller.delete_coins()
	_coin_controller.stop_spawning()


func _on_secret_end() -> void:
	var secret_item: SecretItem = secret_item_scene.instantiate()
	secret_item.position = Vector2(secret_item_base_position.x + _player.position.x, secret_item_base_position.y)
	add_child(secret_item)

	_player.stop_running()
	player_stopped.emit(_player.position.x)


func _on_player_hit() -> void:
	_obstacle_controller.delete_obstacles()
	_obstacle_controller.stop_spawning()

	_coin_controller.delete_coins()
	_coin_controller.stop_spawning()

	player_died.emit()


func _on_player_fell() -> void:
	player_fell.emit()


func _on_player_maximum_run_speed_attained() -> void:
	_player_speed_increase_timer.stop()
	player_maximum_speed_attained.emit()


func _on_player_speed_increase_timer_timeout() -> void:
	_player.increase_speed()
	_emit_player_speed_updated()

	_obstacle_controller.increase_spawn_rate()


func _emit_player_speed_updated() -> void:
	player_speed_updated.emit(_player.velocity.x)


func _emit_player_scored(points: int) -> void:
	player_scored.emit(points)
