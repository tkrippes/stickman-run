class_name CoinController
extends Node2D

signal coin_collected(points: int)
@export var coin_scene: PackedScene
@export var base_position: Vector2 = Vector2(192, 90)
@export var maximum_height: int = 24
@export var points: int = 3

var _player_position: Vector2


func _on_coin_collected() -> void:
	($CoinCollectedSound as AudioStreamPlayer).play()
	coin_collected.emit(points)


func _on_coin_destroyed() -> void:
	var coin := _create_coin()

	call_deferred("add_child", coin)


func _on_spawn_timer_timeout() -> void:
	var coin := _create_coin()

	add_child(coin)


func _on_player_position_updated(player_position: Vector2) -> void:
	_player_position = player_position


func start_spawning() -> void:
	($SpawnTimer as Timer).start()


func stop_spawning() -> void:
	($SpawnTimer as Timer).stop()


func delete_coins() -> void:
	get_tree().call_group("coins", "queue_free")


func _create_coin() -> Coin:
	var coin: Coin = coin_scene.instantiate()
	coin.position = Vector2(base_position.x + _player_position.x,
	base_position.y - randf_range(0, maximum_height))

	var _error_code := coin.player_hit.connect(_on_coin_collected)
	_error_code = coin.obstacle_hit.connect(_on_coin_destroyed)

	return coin
