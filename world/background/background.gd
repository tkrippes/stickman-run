extends Node2D

@onready var _sky: Parallax2D = $Sky
@onready var _mountains: Parallax2D = $Mountains
@onready var _forest: Parallax2D = $Forest
@onready var _grass: Parallax2D = $Grass
@onready var _grass_animation: AnimatedSprite2D = $Grass/Sprite


func _on_player_stopped(_player_position_x: int) -> void:
	_sky.autoscroll = Vector2(0, 0)
	_mountains.autoscroll = Vector2(0, 0)
	_forest.autoscroll = Vector2(0, 0)
	_grass.autoscroll = Vector2(0, 0)
	_grass_animation.stop()
	_grass_animation.frame = 1
	
