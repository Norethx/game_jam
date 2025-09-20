extends CharacterBody2D

@export var size_patrol_r = 200
@export var size_patrol_d = 200
@export var size_patrol_l = 200
@export var size_patrol_u = 200
@export var speed = 120.0
@export var speed_chase = 500.0
@export var animation_tree : AnimationTree
@export var vision_distance: float = 250.0
@export var vision_angle: float = 5.0


@onready var ray_center: RayCast2D = $RayCast2D
@onready var ray_left: RayCast2D = $RayCast2D2
@onready var ray_right: RayCast2D = $RayCast2D3

var len_walk
var sign_step
var side_walk
var size_max
var state = "patrol"
var player_ref: Node2D = null

func _ready() -> void:
	size_max = [size_patrol_r, size_patrol_d, size_patrol_l, size_patrol_u]
	len_walk = 0
	sign_step = Vector2(1.0,0.0)
	side_walk = 0

func _physics_process(delta: float) -> void:
	if state == "patrol":
		do_patrol()
	elif state == "chase" and player_ref:
		do_chase()

	update_vision()


func do_patrol():
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
		
func do_chase():
	var dir = (player_ref.global_position - global_position).normalized()
	velocity = dir * speed_chase
	animation_tree.set("parameters/blend_position", velocity)
	move_and_slide()
	
	
func update_vision():
	var forward = sign_step.normalized()
	var left_dir = forward.rotated(deg_to_rad(-vision_angle))
	var right_dir = forward.rotated(deg_to_rad(vision_angle))

	ray_center.target_position = forward * vision_distance
	ray_left.target_position = left_dir * vision_distance
	ray_right.target_position = right_dir * vision_distance

	if _can_see_player(ray_center): return
	if _can_see_player(ray_left): return
	if _can_see_player(ray_right): return
	
	if state == "chase":
		state = "patrol"
		player_ref = null


func _can_see_player(ray: RayCast2D) -> bool:
	ray.force_raycast_update()

	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("player"):
			state = "chase"
			player_ref = collider
			return true
	return false
