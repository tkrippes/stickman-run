extends Node2D

## The offset of the platform from the player
@export var position_offset: float = - 24


func _on_player_position_updated(_position: Vector2) -> void:
	($Platform as StaticBody2D).position.x = _position.x + position_offset

	
func _on_stop(_player_position_x: int) -> void:
	# TODO: add delay
	await get_tree().create_timer(1.5).timeout
	($Ground as Parallax2D).hide()
	($Platform/Hitbox as CollisionShape2D).set_disabled(true)
