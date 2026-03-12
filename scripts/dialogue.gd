extends Label

@onready var dialogue_cursor: TextureRect = $"../DialogueCursor"

var final_text = self.text
var text_idx = 0
var waiting_for_player = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text_idx < final_text.length():
		text += final_text[text_idx]
		text_idx += 1
	elif not waiting_for_player:
		dialogue_cursor.set_active(true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if text_idx < final_text.length():
			text = final_text
			text_idx = final_text.length()
