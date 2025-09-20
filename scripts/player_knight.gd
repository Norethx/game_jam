extends CharacterBody2D


enum Direction {
	LEFT,
	RIGHT,
	IDLE,
}

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

var is_attacking = false
var is_dashing = false


func _ready() -> void:
	floor_max_angle = 45.0
	floor_snap_length = 2.0



func _physics_process(delta: float) -> void:
	handle_combat()
	handle_movement()
	if not is_on_floor():
		handle_in_air(delta)
	else:
		handle_on_ground()
	
	move_and_slide()

func handle_in_air(delta: float):
	velocity += get_gravity() * delta
	if not is_attacking and not is_dashing: # só troca animação se não estiver atacando
		if velocity.y < 0:
			sprite.play("jump")
		elif velocity.y > 0:
			sprite.play("fall")
			
func handle_on_ground():
	if not is_attacking and not is_dashing: # idem
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		if velocity.x == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
	
func get_direction():
	var direction = Input.get_axis("move_left", "move_right")
	if direction < 0:
		return Direction.LEFT
	elif direction > 0:
		return Direction.RIGHT
	return Direction.IDLE

func handle_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction and not is_dashing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if not is_attacking: # só flipar sprite/hitbox se não atacar
		if direction < 0:
			sprite.flip_h = true
			hitbox.position.x = 5.0
		elif direction > 0:
			sprite.flip_h = false
			hitbox.position.x = -5.0

func handle_combat():
	handle_atack1()
	handle_dash()

func handle_atack1():
	if Input.is_action_just_pressed("attack1") and not is_attacking:
		if velocity.x != 0:
			attack_moving()
		else:
			attack_still()
		return # evita que o resto da lógica rode nesse frame

func attack_moving():
	is_attacking = true
	sprite.play("attack_moving")
	await sprite.animation_finished
	is_attacking = false

func attack_still():
	is_attacking = true
	sprite.play("attack_still")
	await sprite.animation_finished
	is_attacking = false
	
func dash():
	var current_direction: Direction
	is_dashing = true
	sprite.play("dash")
	if get_direction() == Direction.LEFT:
		velocity.x -= 1300
		current_direction = Direction.LEFT
	elif get_direction() == Direction.RIGHT:
		velocity.x += 1300
		current_direction = Direction.RIGHT
	await get_tree().create_timer(0.1).timeout
	if current_direction == Direction.LEFT:
		velocity.x += 1300
	elif current_direction == Direction.RIGHT:
		velocity.x -= 1300
	is_dashing = false
	is_attacking = false
	
func handle_dash():
	if Input.is_action_just_pressed("dash") and not is_dashing:
		dash()
