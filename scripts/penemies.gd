extends Node


func _on_strike_area_area_entered(area: Area2D) -> void:
	print(area)
	if area.is_in_group("penemies"):
		var sprite = area.get_node("AnimatedSprite2D")
		sprite.play("die")
		await sprite.animation_finished
		area.queue_free()
	elif area.is_in_group("bosses"):
		var sprite = area.get_node("AnimatedSprite2D")
		sprite.play("take_damage")
		area.take_damage(50)
		await sprite.animation_finished


func _on_strike_area_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group("penemies"):
		var sprite = body.get_node("AnimatedSprite2D")
		sprite.play("die")
		await sprite.animation_finished
		body.queue_free()
	elif body.is_in_group("bosses"):
		var sprite = body.get_node("AnimatedSprite2D")
		sprite.play("take_damage")
		body.take_damage(10)
		await sprite.animation_finished
