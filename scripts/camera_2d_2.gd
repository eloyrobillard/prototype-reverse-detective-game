extends Camera2D

@onready var mina_corpse: Sprite2D = $"../MinaCorpse"

var target: Node2D


func _on_dialogue_machine_chamber_0_ended() -> void:
	target = mina_corpse
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(20.0, 20.0), 1.0)
	tween.parallel()
	tween.tween_property(self, "global_position", mina_corpse.global_position, 1.0)


func _on_dialogue_machine_chamber_1_ended() -> void:
	await get_tree().create_timer(0.5).timeout
	zoom = Vector2(6.66, 6.66)
