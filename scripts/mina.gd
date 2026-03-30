extends CharacterBody2D

@onready var halo: Sprite2D = $Halo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(halo, "rotation_degrees", 360, 3)
	tween.tween_callback(func(): halo.rotation_degrees = 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
