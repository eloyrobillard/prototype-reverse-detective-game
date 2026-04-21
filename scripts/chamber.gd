extends StaticBody2D

signal chamber_1
signal chamber_4_setup
signal chamber_4_start


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	chamber_1.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogue_machine_chamber_3_ended() -> void:
	# White fade-in effect
	var cl = CanvasLayer.new()
	get_tree().root.add_child(cl)
	var cr = ColorRect.new()
	# Set alpha to zero to prepare for tween
	cr.color = Color(1, 1, 1, 0)
	cr.set_anchors_preset(Control.PRESET_FULL_RECT)
	cl.add_child(cr)

	var alpha_tween = create_tween()
	alpha_tween.tween_property(cr, "color:a", 1, 2.8).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	alpha_tween.tween_callback(func(): chamber_4_setup.emit())
	alpha_tween.tween_interval(0.2)
	alpha_tween.tween_callback(func(): cl.queue_free())
	alpha_tween.tween_interval(1.0)
	alpha_tween.tween_callback(func(): chamber_4_start.emit())
