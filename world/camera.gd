extends Camera2D

# TODO: documentation
@export var stop_offset: int = 192


func _on_stop(player_position_x: int) -> void:
	set_limit(SIDE_RIGHT, player_position_x + stop_offset)