extends DialogueMachine

signal chamber_1_ended
signal chamber_2_started


func _on_chamber_chamber_1() -> void:
	var _on_chamber_1_end = func():
		running_dialogue.emit()
		chamber_1_ended.emit()
		await get_tree().create_timer(1.0).timeout
		_on_chamber_2()

	set_dialogue(0, _on_chamber_1_end)


func _on_chamber_2() -> void:
	var _on_chamber_2_end = func():
		pass

	set_dialogue(1, _on_chamber_2_end)
	chamber_2_started.emit()
