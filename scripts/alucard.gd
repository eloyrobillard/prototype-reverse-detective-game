extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2

signal alucard_1

const SPEED = 100.0
const JUMP_VELOCITY = -240.0

# NOTE: それぞれのアニメーションの向きはなぜか違う
# sitting -> 左を向いている
# kneeling -> 右を向いている

var jump_backwards = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("kneeling")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	if velocity.y > 0:
		set_collision_mask_value(2, true)

	if jump_backwards and is_on_floor():
		jump_backwards = false
		velocity.x = 0
		animated_sprite_2d.play("sitting")
		animated_sprite_2d.flip_h = true
		await get_tree().create_timer(2).timeout
		alucard_1.emit()


func _on_mina_left_scene() -> void:
	animated_sprite_2d.play("kneel-to-stand")
	await animated_sprite_2d.animation_finished
	velocity.y = JUMP_VELOCITY
	velocity.x = -50
	jump_backwards = true
	collision_shape_2d.disabled = true
	collision_shape_2d_2.disabled = false
