extends CharacterBody2D

@onready var halo: Sprite2D = $Halo

var tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_normal_halo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogue_layer_angel_1_ended() -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(halo, "rotation_degrees", 720, 3).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(halo, "scale", halo.scale * 7.5, 3).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(halo, "global_position:y", halo.global_position.y - 50, 3).set_ease(Tween.EASE_IN)


func _set_normal_halo() -> void:
	if tween:
		tween.kill()

	tween = create_tween().set_loops()
	tween.tween_property(halo, "rotation_degrees", 360, 3)
	tween.tween_callback(func(): halo.rotation_degrees = 0)
