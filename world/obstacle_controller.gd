class_name ObstacleController
extends Node2D

@export var level_1_scenes: Array[PackedScene]
@export var level_2_scenes: Array[PackedScene]
@export var level_3_scenes: Array[PackedScene]
@export var level_4_scenes: Array[PackedScene]


func get_obstacles_scenes(level: int) -> Array[PackedScene]:
	if level == 1:
		return level_1_scenes
	elif level == 2:
		return level_2_scenes
	elif level == 3:
		return level_3_scenes
	elif level == 4:
		return level_4_scenes
	else:
		push_warning("Unknown level '%d' started" % level)
		
		return []
