extends Node2D

@export var position_offset: float = - 24


func _on_player_position_updated(_position: Vector2) -> void:
	($Platform as StaticBody2D).position.x = _position.x + position_offset
