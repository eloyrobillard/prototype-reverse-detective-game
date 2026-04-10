extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var opening_jump = false


func _ready() -> void:
	await get_tree().create_timer(1.3).timeout
	velocity.y = JUMP_VELOCITY
	opening_jump = true
	animated_sprite_2d.play("spin_jump")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if velocity.y == 0 and opening_jump:
		opening_jump = false
		animated_sprite_2d.play("landing")
		await get_tree().create_timer(1).timeout
		animated_sprite_2d.play("laughing")

	move_and_slide()
