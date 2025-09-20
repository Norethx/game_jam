extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

var is_attacking = false


func _ready() -> void:
	floor_max_angle = 45.0
	floor_snap_length = 2.0



func _physics_process(delta: float) -> void:
	################################ INPUT ######################################
	if Input.is_action_just_pressed("attack1") and not is_attacking:
		if velocity.x != 0:
			attack_moving()
		else:
			attack_still()
		return # evita que o resto da lógica rode nesse frame

	############################## CÁLCULO #####################################
	var direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor():
		velocity += get_gravity() * delta
		if not is_attacking: # só troca animação se não estiver atacando
			if velocity.y < 0:
				sprite.play("jump")
			elif velocity.y > 0:
				sprite.play("fall")
	else:
		if Input.is_action_just_pressed("jump") and not is_attacking:
			velocity.y = JUMP_VELOCITY
		if not is_attacking: # idem
			if velocity.x == 0:
				sprite.play("idle")
			else:
				sprite.play("run")

	############################### UPDATE #####################################
	if not is_attacking: # só flipar sprite/hitbox se não atacar
		if direction < 0:
			sprite.flip_h = true
			hitbox.position.x = 5.0
		elif direction > 0:
			sprite.flip_h = false
			hitbox.position.x = -5.0

	move_and_slide()


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
