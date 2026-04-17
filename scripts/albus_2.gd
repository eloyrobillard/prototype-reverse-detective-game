extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0


func _ready() -> void:
	animated_sprite_2d.play("laughing")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_dialogue_machine_chamber_1_ended() -> void:
	animated_sprite_2d.stop()


func _on_dialogue_machine_chamber_2_started() -> void:
	animated_sprite_2d.play("idle")
	animated_sprite_2d.stop()
