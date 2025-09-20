extends Area2D

@export var speed: float = 60.0
@export var target: Node2D


func _process(delta: float) -> void:
	if not target: return # segurança

	var direction = ((target.global_position + Vector2.UP * 20) - global_position).normalized()
	var distance = global_position.distance_to(target.global_position)

	if distance < 200.0:
		global_position += direction * speed * delta


	global_position += direction * speed * delta
	$Sprite2D.flip_h = direction.x < 0


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("O inimigo atingiu o player!")
		body.take_health_damge(10) # exemplo: chamar método do player
