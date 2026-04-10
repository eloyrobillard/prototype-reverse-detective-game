extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var dialogue_layer: CanvasLayer

signal launch_dialogue_2

const SPEED = 150

var prostrated = false
var go_left = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if go_left:
		velocity.x = -SPEED
	else:
		velocity.x = 0

	if velocity.x != 0:
		animated_sprite_2d.play("rolling")
		if velocity.x < 0:
			animated_sprite_2d.flip_h = true
		elif velocity.x > 0:
			animated_sprite_2d.flip_h = false
	elif prostrated:
		animated_sprite_2d.play("prostrated")
	else:
		animated_sprite_2d.play("kneeling")

	move_and_slide()


func _on_dialogue_layer_faceless_1_ended() -> void:
	visible = true
	go_left = true
	await get_tree().create_timer(2).timeout
	go_left = false

	# make faceless face right
	animated_sprite_2d.flip_h = false
	launch_dialogue_2.emit()


func _on_dialogue_layer_faceless_2_ended() -> void:
	visible = true
	go_left = true
	await get_tree().create_timer(1).timeout
	go_left = false
	prostrated = true


func _on_dialogue_layer_angel_1_ended(transformation_timing: float) -> void:
	var albus: CharacterBody2D = preload("res://scenes/albus.tscn").instantiate()

	# White fade-in effect
	var cl = CanvasLayer.new()
	get_tree().root.add_child(cl)
	var cr = ColorRect.new()
	# Set alpha to zero to prepare for tween
	cr.color = Color(1, 1, 1, 0)
	cr.set_anchors_preset(Control.PRESET_FULL_RECT)
	cl.add_child(cr)

	var alpha_tween = create_tween()
	alpha_tween.tween_property(cr, "color:a", 1, transformation_timing).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	alpha_tween.tween_callback(func(): get_tree().root.add_child(albus))
	alpha_tween.tween_callback(func(): albus.global_position = Vector2(global_position.x, global_position.y - 7))
	alpha_tween.tween_callback(func(): albus.launch_dialogue_1.connect(dialogue_layer._trigger_start_albus_1))
	alpha_tween.tween_callback(func(): cl.queue_free())
	alpha_tween.tween_callback(func(): queue_free())
