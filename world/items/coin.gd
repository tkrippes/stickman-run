class_name Coin
extends Area2D

signal collected


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collected.emit()
		queue_free()
