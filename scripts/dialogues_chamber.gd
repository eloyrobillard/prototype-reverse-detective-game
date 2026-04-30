extends DialogueMachine

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal chamber_0_ended
signal chamber_1_ended
signal chamber_2_started
signal chamber_2_ended
signal chamber_3_ended


func _on_chamber_1() -> void:
	var _on_chamber_1_end = func():
		running_dialogue.emit()
		chamber_1_ended.emit()
		await get_tree().create_timer(1.0).timeout
		_on_chamber_2()

	set_dialogue(0, _on_chamber_1_end)


func _on_chamber_2() -> void:
	var _on_chamber_2_end = func():
		chamber_2_ended.emit()

	set_dialogue(1, _on_chamber_2_end)
	chamber_2_started.emit()


func _on_genya_next_to_mina() -> void:
	var _on_chamber_3_end = func():
		chamber_3_ended.emit()

	set_dialogue(2, _on_chamber_3_end)


func _on_chamber_chamber_4_start() -> void:
	set_dialogue(3, func(): pass)


func _on_genya_chamber_0() -> void:
	var _on_chamber_0_end = func():
		chamber_0_ended.emit()
		running_dialogue.emit()
		await get_tree().create_timer(1.5).timeout
		_on_chamber_1()

	set_dialogue(4, _on_chamber_0_end)
	audio_stream_player.play()
