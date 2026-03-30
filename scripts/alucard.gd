extends CharacterBody2D

signal on_screen

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

# NOTE: それぞれのアニメーションの向きはなぜか違う
# sitting -> 左を向いている
# kneeling -> 右を向いている


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("kneeling")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogue_layer_alucard_dialogue_ended() -> void:
	visible_on_screen_notifier_2d.free()
