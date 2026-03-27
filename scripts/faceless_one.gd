extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150

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
	else:
		animated_sprite_2d.play("kneeling")

	move_and_slide()


func _on_dialogue_layer_faceless_1_ended() -> void:
	visible = true
	go_left = true
	await get_tree().create_timer(2).timeout
	go_left = false
