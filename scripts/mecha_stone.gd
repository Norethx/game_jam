extends CharacterBody2D


var is_attacking = false
var has_reach = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("penemies");


func _process(delta: float) -> void:
	if not is_attacking and has_reach:
		sprite.play("melee_attack")


func _on_agro_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_attacking = true
		sprite.play("melee_attack")
		await get_tree().create_timer(2).timeout
		await sprite.animation_finished
		is_attacking = false

func _on_agro_body_exited(body: Node2D) -> void:
	has_reach = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_attacking:
		body.take_health_damge(10)
		await sprite.animation_finished
