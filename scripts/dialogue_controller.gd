extends CanvasLayer

@onready var dialogue_cursor: TextureRect = $"DialogueArea/DialogueCursor"
@onready var dialogue_text: Label = $DialogueArea/DialogueText
@onready var speaker_icon: TextureRect = $DialogueArea/SpeakerIcon
@onready var speaker_name: Label = $DialogueArea/SpeakerName

@export var dialogues: Array[Dialogue]

signal running_dialogue
signal dialogue_ended
signal alucard_dialogue_ended
signal faceless_1_ended
signal faceless_2_ended
signal angel_1_ended(transformation_timing: float)
signal albus_1_ended

var current_line = -1
var max_lines = 0
var visible_chars = 0

var default_dialogue: Dialogue
var current_dialogue: Dialogue
var dialogue_end_callback: Callable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	default_dialogue = dialogues[0]
	current_dialogue = default_dialogue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible_chars < dialogue_text.text.length():
		visible_chars += 30 * delta
		dialogue_text.visible_characters = int(visible_chars)
		dialogue_cursor.set_active(false)
	else:
		dialogue_cursor.set_active(true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("select"):
			if visible_chars < len(dialogue_text.text):
				visible_chars = len(dialogue_text.text)
				dialogue_text.visible_characters = visible_chars
			else:
				if current_line < len(current_dialogue.lines) - 1:
					_set_line(current_line + 1)
				else:
					close_dialogue()


func set_dialogue(dialogue: Dialogue, callback: Callable) -> void:
	dialogue_text.text = ""
	current_dialogue = dialogue
	dialogue_end_callback = callback

	if len(dialogue.lines) > 0:
		running_dialogue.emit()
		max_lines = len(dialogue.lines)
		_set_line(0)
		set_process(true)
		set_process_unhandled_input(true)
		visible = true
	else:
		close_dialogue()


func _set_line(line_idx: int) -> void:
	if line_idx < max_lines:
		visible_chars = 0
		dialogue_text.visible_characters = 0
		dialogue_text.text = current_dialogue.lines[line_idx]
		current_line = line_idx

		var name_idx = current_dialogue.line_speaker_name_index[line_idx]
		var icon_idx = current_dialogue.line_speaker_icon_index[line_idx]

		speaker_name.text = current_dialogue.speaker_names[name_idx]
		speaker_icon.texture = current_dialogue.speaker_icons[icon_idx]


func close_dialogue() -> void:
	visible_chars = 0
	dialogue_text.visible_characters = 0
	visible = false
	current_dialogue = default_dialogue
	running_dialogue.emit()
	dialogue_ended.emit()
	dialogue_end_callback.call()
	dialogue_cursor.set_active(false)
	set_process(false)
	set_process_unhandled_input(false)


func _on_alucard_on_screen() -> void:
	var _on_alucard_dialogue_end = func() -> void:
		alucard_dialogue_ended.emit()

	set_dialogue(dialogues[1], _on_alucard_dialogue_end)


func _on_faceless_event_1_trigger_start_faceless_event_1() -> void:
	var _on_faceless_1_end = func() -> void:
		faceless_1_ended.emit()

	set_dialogue(dialogues[2], _on_faceless_1_end)


func _on_faceless_one_launch_dialogue_2() -> void:
	var _on_faceless_2_end = func() -> void:
		faceless_2_ended.emit()

	set_dialogue(dialogues[3], _on_faceless_2_end)


func _on_angle_1_trigger_start_angel_1() -> void:
	var _on_angel_1_end = func() -> void:
		angel_1_ended.emit(3)

	set_dialogue(dialogues[4], _on_angel_1_end)


# Not a signal function
func _trigger_start_albus_1(cb: Callable) -> void:
	var _on_albus_1_end = func() -> void:
		albus_1_ended.emit()
		cb.call()

	set_dialogue(dialogues[5], _on_albus_1_end)
