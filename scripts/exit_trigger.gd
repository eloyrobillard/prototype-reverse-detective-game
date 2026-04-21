extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal player_entered
signal player_left


func _on_alucard_left_scene() -> void:
	collision_shape_2d.disabled = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entered.emit()
		get_tree().change_scene_to_file("res://scenes/chamber.tscn")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_left.emit()
