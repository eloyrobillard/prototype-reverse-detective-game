extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -220.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x == 0 and velocity.y == 0:
		animated_sprite_2d.play("idle")
	elif velocity.y != 0:
		animated_sprite_2d.play("jump")
	else:
		animated_sprite_2d.play("walk")

	move_and_slide()


func _on_dialogue_layer_running_dialogue() -> void:
	set_physics_process(false)
	animated_sprite_2d.play("idle")


func _on_dialogue_layer_dialogue_ended() -> void:
	set_physics_process(true)
