extends Area2D

enum InitialDirectionMode {LEFT, RIGHT}

@export var speed: float = 80.0
@export var initial_direction: InitialDirectionMode
@onready var ray_chao: RayCast2D = $RayCast2DChao
@onready var ray_borda: RayCast2D = $RayCast2DBorda
@onready var ray_parede: RayCast2D = $RayCast2DParede
@onready var start_position: Vector2 = global_position
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var velocity = Vector2.ZERO
var direction: int = randi_range(-1, 1)


func _ready() -> void:
	if initial_direction == InitialDirectionMode.LEFT:
		direction = -1
		sprite.flip_h = true
		ray_borda.position.x = -15.0
		ray_parede.rotation_degrees = 90
	else:
		direction = 1
		sprite.flip_h = false
		ray_borda.position.x = 15.0
		ray_parede.rotation_degrees = -90
	add_to_group("penemies")

func _process(delta: float) -> void:
	# FLIPPAR O INIMIGO
	if ray_parede.is_colliding():
		direction *= -1
		sprite.flip_h = !sprite.flip_h
		if direction > 0:
			ray_borda.position.x = 15.0
		else:
			ray_borda.position.x = -15.0
		ray_parede.rotation += PI
	elif not ray_borda.is_colliding():
		direction *= -1
		sprite.flip_h = !sprite.flip_h
		if direction > 0:
			ray_borda.position.x = 15.0
		else:
			ray_borda.position.x = -15.0
		ray_parede.rotation += PI


	gravity = 500.0
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
