extends CharacterBody2D

@export var looking_right: bool
@export var can_move: bool
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal next_to_mina
signal chamber_0

const SPEED = 100.0
const JUMP_VELOCITY = -220.0

var direction: float
var move = false
var move_to: float
var move_cb: Callable


func _ready() -> void:
	set_process_input(can_move)
	animated_sprite_2d.flip_h = looking_right
	await get_tree().create_timer(1.0).timeout
	chamber_0.emit()


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

	if move and absf(global_position.x - move_to) > 5.0:
		direction = Vector2(move_to - global_position.x, 0).normalized().x
	elif move:
		_end_move_to()

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


func _on_dialogue_machine_running_dialogue() -> void:
	set_process_input(false)
	animated_sprite_2d.play("idle")


func _on_dialogue_machine_dialogue_ended() -> void:
	set_process_input(true)


func _on_dialogue_machine_chamber_2_ended() -> void:
	var cb = func():
		next_to_mina.emit()
		_end_pass_through_npcs()

	_set_move_to(0, cb)
	_set_pass_through_npcs()


func _set_move_to(mv_to: float, cb: Callable):
	set_process_input(false)
	move = true
	move_to = mv_to
	move_cb = cb


func _end_move_to():
	direction = 0
	set_process_input(true)
	move = false
	move_cb.call()


func _set_pass_through_npcs():
	set_collision_mask_value(2, false)
	set_collision_layer_value(3, false)


func _end_pass_through_npcs():
	set_collision_mask_value(2, true)
	set_collision_layer_value(3, true)
