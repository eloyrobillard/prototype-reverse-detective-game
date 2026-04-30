extends Camera2D

@onready var mina: CharacterBody2D = $"../../Mina"
@onready var alucard: CharacterBody2D = $"../../Alucard"

var target: Node2D = null


func _process(delta: float) -> void:
	if target:
		global_position.x = lerpf(global_position.x, target.global_position.x, delta * 1.5)
	else:
		position.x = lerpf(position.x, 0, delta)


func _on_angle_1_trigger_start_angel_1() -> void:
	target = mina


func _on_mina_left_scene() -> void:
	target = alucard


func _on_dialogue_layer_alucard_dialogue_ended() -> void:
	target = null
