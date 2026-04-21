extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var standing_collision_shape: CollisionShape2D = $CollisionShape2D
@onready var seated_collision_shape: CollisionShape2D = $CollisionShape2D2
@onready var collision_shape_2d_3: CollisionShape2D = $CollisionShape2D3
@onready var static_mud_man: StaticBody2D = $"../StaticMudMan"
@onready var marker_2d: Marker2D = $"../Marker2D"

const SPEED = 100.0


func _ready() -> void:
	animated_sprite_2d.play("sitting")
	animated_sprite_2d.flip_h = true
	standing_collision_shape.disabled = true
	seated_collision_shape.disabled = false
	collision_shape_2d_3.disabled = true
	set_collision_mask_value(2, true)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_chamber_chamber_4_setup() -> void:
	animated_sprite_2d.play("idle")
	global_position = marker_2d.global_position
	standing_collision_shape.disabled = false
	seated_collision_shape.disabled = true
