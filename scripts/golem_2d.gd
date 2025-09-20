extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	attack()

func attack():
	sprite.play("attack")
	await sprite.animation_finished
	sprite.play("spikes")
