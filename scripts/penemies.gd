extends Node


func _on_strike_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("penemies"):
		var sprite = area.get_node("AnimatedSprite2D")
		sprite.play("die")

		# Espera a animação terminar antes de liberar o inimigo
		await sprite.animation_finished
		area.queue_free()
