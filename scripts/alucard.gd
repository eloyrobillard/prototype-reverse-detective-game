extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var seated_collision_shape: CollisionShape2D = $CollisionShape2D2
@onready var collision_shape_2d_3: CollisionShape2D = $CollisionShape2D3
@onready var static_mud_man: StaticBody2D = $"../StaticMudMan"

signal left_scene
signal alucard_1

const SPEED = 100.0
const JUMP_VELOCITY = -240.0

# NOTE: それぞれのアニメーションの向きはなぜか違う
# sitting -> 左を向いている
# kneeling -> 右を向いている

var jump_backwards = false

var move: bool
var move_to_x: float
var move_cb: Callable
var delta_x: float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("kneeling")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not jump_backwards:
		var direction_x = 0.0
		if move and absf(global_position.x - move_to_x) < delta_x:
			move_cb.call()
		elif move and global_position.x != move_to_x:
			direction_x = Vector2(move_to_x - global_position.x, 0.0).normalized().x

		velocity.x = SPEED * direction_x

	move_and_slide()
	if jump_backwards and velocity.y > 0:
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
	seated_collision_shape.disabled = false


func _on_dialogue_layer_alucard_dialogue_ended() -> void:
	seated_collision_shape.disabled = true
	collision_shape_2d_3.disabled = false
	set_collision_mask_value(2, false)
	static_mud_man.reparent(self)

	move = true
	move_to_x = 0.0
	move_cb = func():
		left_scene.emit()
		queue_free()
