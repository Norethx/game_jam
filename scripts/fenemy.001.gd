extends CharacterBody2D

@export var size_patrol_r = 200
@export var size_patrol_d = 200
@export var size_patrol_l = 200
@export var size_patrol_u = 200
@export var speed = 120.0
@export var animation_tree : AnimationTree
@onready var ray_cast_2d: RayCast2D = $Area2D/RayCast2D

#var idle = 20
var len_walk
var sign_step
var side_walk
var size_max

func _ready() -> void:
	size_max = [size_patrol_r, size_patrol_d, size_patrol_l, size_patrol_u]
	len_walk = 0
	sign_step = Vector2(1.0,0.0)
	side_walk = 0

func _physics_process(delta: float) -> void:
	var int_speed = speed
	if(size_max[side_walk] != 0 and len_walk < size_max[side_walk]):
		velocity = sign_step * int_speed
		animation_tree.set("parameters/blend_position", velocity)
		len_walk += 1
		move_and_slide()
	if (len_walk == size_max[side_walk] || size_max[side_walk] == 0):
		change_direction()


func change_direction()-> void:
	if (side_walk == 0 and size_patrol_r == len_walk):
		sign_step = Vector2(0.0,1.0)
		side_walk = 1
		len_walk = 0
	elif (side_walk == 1 and size_patrol_d == len_walk):
		sign_step = Vector2(-1.0,0.0)
		side_walk = 2
		len_walk = 0
	elif (side_walk == 2 and size_patrol_l == len_walk):
		sign_step = Vector2(0.0,-1.0)
		side_walk = 3
		len_walk = 0
	elif (side_walk == 3 and size_patrol_u == len_walk):
		sign_step = Vector2(1.0,0.0)
		side_walk = 0
		len_walk = 0




func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group("player"):
		ray_cast_2d.target_position = to_local(body.global_position)
		ray_cast_2d.force_raycast_update()
		print(body)

		if not ray_cast_2d.is_colliding():
			print("Player avistado! CAMINHO LIVRE.")
		else:
			print("Player está na área, mas atrás de uma parede.")
