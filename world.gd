extends Node2D

signal game_over

@export var obstacle_sceen: PackedScene
@export var obstacle_spawn_location: Vector2i
@export var initial_obstacle_speed: float = 75.0
@export var obstacle_speed_increase: float = 1

var obstacle_speed: float


func _ready() -> void:
	obstacle_speed = initial_obstacle_speed


func _on_player_hit() -> void:
	get_tree().call_group("obstacles", "queue_free")
	game_over.emit()


func _on_obstacle_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_sceen.instantiate()
	obstacle.position = obstacle_spawn_location
	obstacle.speed = obstacle_speed
	
	add_child(obstacle)


func _on_speed_increase_timer_timeout() -> void:
	obstacle_speed += obstacle_speed_increase
	get_tree().call_group("obstacles", "set_speed", obstacle_speed)
