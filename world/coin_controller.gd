class_name CoinController
extends Node2D

signal coin_collected(points: int)
@export var coin_scene: PackedScene
@export var base_position: Vector2 = Vector2(192, 90)
@export var minimum_height: int = 8
@export var maximum_height: int = 32
@export var level_1_spawn_rate: float = 21
@export var level_2_spawn_rate: float = 13
@export var level_3_spawn_rate: float = 8
@export var level_4_spawn_rate: float = 5
@export var minimum_random_spawn_rate_multiplier: float = 0.8
@export var maximum_random_spawn_rate_multiplier: float = 1.2
@export var points: int = 3

var _player_position: Vector2
var _spawn_timer: Timer
var _base_spawn_rate: float = level_1_spawn_rate


func _ready() -> void:
	_spawn_timer = $SpawnTimer


func _on_coin_collected() -> void:
	($CoinCollectedSound as AudioStreamPlayer).play()
	coin_collected.emit(points)


func _on_coin_destroyed() -> void:
	var coin := _create_coin()

	call_deferred("add_child", coin)


func _on_spawn_timer_timeout() -> void:
	_set_spawn_rate()
	var coin := _create_coin()

	add_child(coin)


func _on_player_position_updated(player_position: Vector2) -> void:
	_player_position = player_position


func start_spawning() -> void:
	_spawn_timer.start()


func stop_spawning() -> void:
	_spawn_timer.stop()
	
	
func set_spawn_rate(level: int) -> void:
	match level:
		1: _base_spawn_rate = level_1_spawn_rate
		2: _base_spawn_rate = level_2_spawn_rate
		3: _base_spawn_rate = level_3_spawn_rate
		4: _base_spawn_rate = level_4_spawn_rate
		_: push_warning("Cannot set spawn rate for unknown level '%d'" % level)
	
	_set_spawn_rate()


func delete_coins() -> void:
	get_tree().call_group("coins", "queue_free")


func _create_coin() -> Coin:
	var coin: Coin = coin_scene.instantiate()
	coin.position = Vector2(base_position.x + _player_position.x,
	base_position.y - randf_range(minimum_height, maximum_height))

	var _error_code := coin.player_hit.connect(_on_coin_collected)
	_error_code = coin.obstacle_hit.connect(_on_coin_destroyed)

	return coin


func _set_spawn_rate() -> void:
	_spawn_timer.wait_time = randf_range(
		minimum_random_spawn_rate_multiplier * _base_spawn_rate,
		maximum_random_spawn_rate_multiplier * _base_spawn_rate)