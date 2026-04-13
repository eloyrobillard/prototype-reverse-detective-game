extends CharacterBody2D

const SPEED = 100.0

@onready var halo: Sprite2D = $Halo
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal left_scene

var tween: Tween
var move: bool
var move_to_x: float
var move_cb: Callable
var delta_x: float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_scene.emit()
	_set_normal_halo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction_x = 0.0

	if move and absf(global_position.x - move_to_x) < delta_x:
		move_cb.call()
	elif move and global_position.x != move_to_x:
		direction_x = Vector2(move_to_x - global_position.x, 0.0).normalized().x

	velocity.x = SPEED * direction_x

	if velocity.x != 0:
		animated_sprite_2d.play("moon_walk")
		animated_sprite_2d.flip_h = direction_x > 0

	move_and_slide()


func _on_dialogue_layer_angel_1_ended(transformation_timing: float) -> void:
	if tween:
		tween.kill()

	var original_scale = halo.scale
	var original_y = halo.global_position.y

	tween = create_tween()
	tween.tween_property(halo, "rotation_degrees", 720, transformation_timing).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(halo, "scale", halo.scale * 7.5, transformation_timing).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(halo, "global_position:y", halo.global_position.y - 50, transformation_timing).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): halo.scale = original_scale)
	tween.tween_callback(func(): halo.global_position.y = original_y)


func _set_normal_halo() -> void:
	if tween:
		tween.kill()

	tween = create_tween().set_loops()
	tween.tween_property(halo, "rotation_degrees", 360, 3)
	tween.tween_callback(func(): halo.rotation_degrees = 0)


func _on_dialogue_layer_angel_2_ended() -> void:
	move = true
	move_to_x = 0.0
	move_cb = func():
		left_scene.emit()
		queue_free()
