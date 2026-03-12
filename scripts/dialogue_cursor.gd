extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween().bind_node(self).set_loops()
	tween.tween_property(self, "visible", false, 0.15)
	tween.tween_property(self, "visible", true, 0.15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
