extends Node2D

signal in_reach(reached: bool)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_reach.emit(true)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_reach.emit(false)
