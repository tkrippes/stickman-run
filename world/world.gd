extends Node2D

signal player_died
signal player_scored
signal obstacle_speed_updated(speed: float)

@export var obstacle_sceen: PackedScene
@export var obstacle_spawn_location: Vector2i

@export var initial_obstacle_speed: float = 75.0
@export var obstacle_speed_multiplier: float = 1.01

@export var obstacle_timer_multiplier: float = 0.99


var obstacle_speed: float


func _ready() -> void:
	_set_obstacle_speed(initial_obstacle_speed)


func _set_obstacle_speed(new_obstacle_speed: float) -> void:
	obstacle_speed = new_obstacle_speed
	obstacle_speed_updated.emit(obstacle_speed)


func _on_player_hit() -> void:
	get_tree().call_group("obstacles", "queue_free")
	player_died.emit()
	
func _on_obstacle_left_screen() -> void:
	player_scored.emit()


func _on_obstacle_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_sceen.instantiate()
	obstacle.position = obstacle_spawn_location
	obstacle.speed = obstacle_speed
	var _error_code := obstacle.left_screen.connect(_on_obstacle_left_screen)
	
	add_child(obstacle)


func _on_speed_increase_timer_timeout() -> void:
	($Obstacletimer as Timer).wait_time *= obstacle_timer_multiplier
	
	_set_obstacle_speed(obstacle_speed * obstacle_speed_multiplier)
	get_tree().call_group("obstacles", "set_speed", obstacle_speed)
