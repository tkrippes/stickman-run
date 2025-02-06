extends Node2D

signal player_died
signal player_scored
signal player_speed_updated(speed: float)

@export var initial_player_speed: float = 75.0
@export var player_speed_multiplier: float = 1.01

@export var obstacle_sceens: Array[PackedScene]
@export var obstacle_spawn_location: Vector2i
@export var obstacle_timer_multiplier: float = 0.99

@export var ball_fall_height: int = 16


var _player_speed: float
var _screen_size: Vector2i


func _ready() -> void:
	_set_player_speed(initial_player_speed)
	_screen_size = get_viewport_rect().size


func _set_player_speed(new_player_speed: float) -> void:
	_player_speed = new_player_speed
	player_speed_updated.emit(_player_speed)


func _on_player_hit() -> void:
	get_tree().call_group("obstacles", "queue_free")
	player_died.emit()


func _on_obstacle_left_screen() -> void:
	player_scored.emit()


func _on_obstacle_timer_timeout() -> void:
	var obstacle_sceen: PackedScene = obstacle_sceens.pick_random()
	var obstacle: Obstacle = obstacle_sceen.instantiate()
	
	var obstacle_position := Vector2(($Player as CharacterBody2D).position.x + _screen_size.x, _screen_size.y)
	if obstacle is Ball:
		obstacle_position.y -= ball_fall_height
	obstacle.position = obstacle_position
	
	var _error_code := obstacle.left_screen.connect(_on_obstacle_left_screen)
	
	add_child(obstacle)


func _on_speed_increase_timer_timeout() -> void:
	($Obstacletimer as Timer).wait_time *= obstacle_timer_multiplier
	
	_set_player_speed(_player_speed * player_speed_multiplier)
