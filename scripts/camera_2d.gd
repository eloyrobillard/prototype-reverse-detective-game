extends Camera2D

@onready var marker_2d: Marker2D = $"../../Marker2D"

var go_to_marker = false


func _process(delta: float) -> void:
	if go_to_marker:
		global_position.x = lerpf(global_position.x, marker_2d.global_position.x, delta)
	else:
		position.x = lerpf(position.x, 0, delta)


func _on_angle_1_trigger_start_angel_1() -> void:
	go_to_marker = true


func _on_dialogue_layer_alucard_dialogue_ended() -> void:
	go_to_marker = false
