extends Node


func _on_strike_area_area_entered(area: Area2D) -> void:
	breakpoint
	if area.is_in_group("penemies"):
		var sprite = area.get_node("AnimatedSprite2D")
		sprite.play("die")
		await sprite.animation_finished
		area.queue_free()
