extends Area2D

var initial_position: Vector2
@export var speed: float = 100.0
@export var target: Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	add_to_group("penemies")
	initial_position = global_position


func _process(delta: float) -> void:
	if not target: return # segurança

	var direction = ((target.global_position + Vector2.UP * 20) - global_position).normalized()

	$AnimatedSprite2D.flip_h = direction.x < 0

	var distance = global_position.distance_to(target.global_position)
	if distance < 200.0:
		sprite.play("run")
		global_position += direction * speed * delta
	else:
		direction = ((initial_position) - global_position).normalized()
		if global_position.distance_to(initial_position) < 20:
			sprite.play("idle")
		else:
			global_position += direction * speed * delta
			sprite.play("run")
