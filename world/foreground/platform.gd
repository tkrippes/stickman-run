class_name Platform
extends StaticBody2D

var _platform_length: float


func _ready() -> void:
	_platform_length = ($Hitbox as CollisionShape2D).position.x * 2
	

func _on_visible_on_screen_notifier_screen_entered() -> void:
	var new_platform: Platform = self.duplicate()
	new_platform.position.x = position.x + _platform_length
	get_parent().add_child(new_platform)


func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
