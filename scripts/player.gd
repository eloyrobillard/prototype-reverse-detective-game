extends CharacterBody2D

@export var looking_right: bool
@export var can_move: bool
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -220.0

var direction: float


func _ready() -> void:
	set_process_input(can_move)
	animated_sprite_2d.flip_h = looking_right


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if event.is_action_pressed("left"):
		direction -= 1
	if event.is_action_released("left"):
		direction += 1
	if event.is_action_pressed("right"):
		direction += 1
	if event.is_action_released("right"):
		direction -= 1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

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
	set_process_input(false)
	direction = 0
	animated_sprite_2d.play("idle")


func _on_dialogue_layer_dialogue_ended() -> void:
	set_process_input(true)


func _on_alucard_left_scene() -> void:
	set_process_input(true)
