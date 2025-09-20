extends CharacterBody2D

@export var size_patrol_l = 4
@export var size_patrol_r = 4
var len_walk = 0
var side_walk = 1

func _physics_process(delta: float) -> void:
	velocity = Vector2(1.0,0.0) * delta * 700
	len_walk += 1
	if (side_walk == 1 && size_patrol_l == len_walk):
		 pass
	move_and_slide()
