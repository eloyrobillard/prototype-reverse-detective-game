class_name DialogueMachine
extends CanvasLayer

@onready var dialogue_cursor: TextureRect = $"DialogueArea/DialogueCursor"
@onready var dialogue_text: Label = $DialogueArea/DialogueText
@onready var speaker_icon: TextureRect = $DialogueArea/SpeakerIcon
@onready var speaker_name: Label = $DialogueArea/SpeakerName

@export var dialogues: Array[Dialogue]

signal running_dialogue
signal dialogue_ended

var current_line = -1
var max_lines = 0
var visible_chars = 0

var default_dialogue: Dialogue
var current_dialogue: Dialogue
var dialogue_end_callback: Callable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	set_process(false)
	set_process_unhandled_input(false)


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


func set_dialogue(dialogue_idx: int, callback: Callable) -> void:
	dialogue_text.text = ""
	current_dialogue = dialogues[dialogue_idx]
	dialogue_end_callback = callback

	if len(current_dialogue.lines) > 0:
		running_dialogue.emit()
		max_lines = len(current_dialogue.lines)
		_set_line(0)
		set_process(true)
		set_process_unhandled_input(true)
		show()
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
	hide()
	current_dialogue = default_dialogue
	running_dialogue.emit()
	dialogue_ended.emit()
	dialogue_end_callback.call()
	dialogue_cursor.set_active(false)
	set_process(false)
	set_process_unhandled_input(false)
