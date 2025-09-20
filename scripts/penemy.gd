extends Area2D

@export var speed: float = 80.0
@onready var ray_chao: RayCast2D = $RayCast2DChao
@onready var ray_borda: RayCast2D = $RayCast2DBorda
@onready var start_position: Vector2 = global_position
@onready var sprite: Sprite2D = $Sprite2D

var velocity = Vector2.ZERO
var direction: int = -1

func _process(delta: float) -> void:
	if not ray_borda.is_colliding():
		direction *= -1
		sprite.flip_h = true
		if direction > 0:
			ray_borda.position.x = 15.0
		else:
			ray_borda.position.x = -15.0

	var gravity = 500.0
	# CALCULA O MOVIMENTO HORIZONTAL
	velocity.x = direction * speed

	# GRAVIDADE (MOVIMENTO VERTICAL)
	if ray_chao.is_colliding():
		var ground_pos = ray_chao.get_collision_point()
		global_position.y = ground_pos.y - 16
		velocity.y = 0
	else:
		velocity.y += gravity * delta

	# APLICA MOVIMENTO
	global_position += velocity * delta
