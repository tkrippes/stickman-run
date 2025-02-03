extends Node2D

signal game_over

@export var obstacle_sceen: PackedScene
@export var obstacle_spawn_location: Vector2i


func _on_mob_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_sceen.instantiate()
	obstacle.position = obstacle_spawn_location
	
	add_child(obstacle)


func _on_player_hit() -> void:
	get_tree().call_group("obstacles", "queue_free")
	game_over.emit()
