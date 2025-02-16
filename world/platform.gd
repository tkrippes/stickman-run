class_name Platform
extends StaticBody2D


func _on_visible_on_screen_notifier_screen_entered() -> void:
	var new_platform: Platform = self.duplicate()
	new_platform.position.x = position.x + 200
	get_parent().add_child(new_platform)
	print("created new platform")


func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
	print("delete old platform")
