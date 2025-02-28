extends Camera2D

## The offset of the camera when the player stops.
@export var stop_offset: int = 192


func _on_player_stopped(player_position_x: int) -> void:
	set_limit(SIDE_RIGHT, player_position_x + stop_offset)