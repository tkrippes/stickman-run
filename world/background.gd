extends Node2D

@export var sky_speed_multiplier: float = 0.1
@export var mountains_speed_multiplier: float = 0.3
@export var forest_speed_multiplier: float = 0.7
@export var grass_speed_multiplier: float = 1.0

var _speed: float


func set_speed(speed: float) -> void:
	_speed = speed
	
	($Sky as Parallax2D).autoscroll = Vector2(-_speed * sky_speed_multiplier, 0.0)
	($Mountains as Parallax2D).autoscroll = Vector2(-_speed * mountains_speed_multiplier, 0.0)
	($Forest as Parallax2D).autoscroll = Vector2(-_speed * forest_speed_multiplier, 0.0)
	($Grass as Parallax2D).autoscroll = Vector2(-_speed * grass_speed_multiplier, 0.0)
