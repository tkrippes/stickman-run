extends Node2D

## The offset of the platform from the player
@export var position_offset: float = - 24.0
## The timeout before the platform disappears after the player stops.
@export var platform_disappear_timeout: float = 6.0


func _on_player_position_updated(_position: Vector2) -> void:
	($Platform as StaticBody2D).position.x = _position.x + position_offset


func _on_player_stopped(_player_position_x: int) -> void:
	await get_tree().create_timer(platform_disappear_timeout).timeout
	($Ground as Parallax2D).hide()
	($Platform/Hitbox as CollisionShape2D).set_disabled(true)
