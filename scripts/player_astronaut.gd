extends CharacterBody2D


func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("ui_up", "ui_down", "ui_left", "ui_right")
