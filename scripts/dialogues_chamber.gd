extends DialogueMachine

func _on_chamber_chamber_1() -> void:
	var _on_chamber_1_end = func(): pass

	set_dialogue(0, _on_chamber_1_end)
