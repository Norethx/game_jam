#extends CharacterBody2D
#
#
#enum Direction {
	#LEFT,
	#RIGHT,
	#IDLE,
#}
#
#const SPEED = 150.0
#const JUMP_VELOCITY = -400.0
#
#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var hitbox: CollisionShape2D = $CollisionShape2D
#
#var is_attacking = false
#var is_dashing = false
#
#
#func _ready() -> void:
	#floor_max_angle = 45.0
	#floor_snap_length = 2.0
#
#
#
#func _physics_process(delta: float) -> void:
	#handle_combat()
	#handle_movement()
	#if not is_on_floor():
		#handle_in_air(delta)
	#else:
		#handle_on_ground()
#
	#move_and_slide()
#
#func handle_in_air(delta: float):
	#velocity += get_gravity() * delta
	#if not is_attacking and not is_dashing: # só troca animação se não estiver atacando
		#if velocity.y < 0:
			#sprite.play("jump")
		#elif velocity.y > 0:
			#sprite.play("fall")
#
#func handle_on_ground():
	#if not is_attacking and not is_dashing: # idem
		#if Input.is_action_just_pressed("jump"):
			#velocity.y = JUMP_VELOCITY
		#if velocity.x == 0:
			#sprite.play("idle")
		#else:
			#sprite.play("run")
#
#func get_direction():
	#var direction = Input.get_axis("move_left", "move_right")
	#if direction < 0:
		#return Direction.LEFT
	#elif direction > 0:
		#return Direction.RIGHT
	#return Direction.IDLE
#
#func handle_movement():
	#var direction = Input.get_axis("move_left", "move_right")
	#if direction and not is_dashing:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#if not is_attacking: # só flipar sprite/hitbox se não atacar
		#if direction < 0:
			#sprite.flip_h = true
			#hitbox.position.x = 5.0
		#elif direction > 0:
			#sprite.flip_h = false
			#hitbox.position.x = -5.0
#
#func handle_combat():
	#handle_atack1()
	#handle_dash()
#
#func handle_atack1():
	#if Input.is_action_just_pressed("attack1") and not is_attacking:
		#if velocity.x != 0:
			#attack_moving()
		#else:
			#attack_still()
		#return # evita que o resto da lógica rode nesse frame
#
#func attack_moving():
	#is_attacking = true
	#sprite.play("attack_moving")
	#hitbox.position.x += 25.0
	#await sprite.animation_finished
	#hitbox.position.x -= 25.0
	#is_attacking = false
#
#func attack_still():
	#is_attacking = true
	#sprite.play("attack_still")
	#await sprite.animation_finished
	#is_attacking = false
#
#func dash():
	#var current_direction: Direction
	#is_dashing = true
	#sprite.play("dash")
	#if get_direction() == Direction.LEFT:
		#velocity.x -= 1300
		#current_direction = Direction.LEFT
	#elif get_direction() == Direction.RIGHT:
		#velocity.x += 1300
		#current_direction = Direction.RIGHT
	#await get_tree().create_timer(0.1).timeout
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	#is_dashing = false
	#is_attacking = false
#
#func handle_dash():
	#if Input.is_action_just_pressed("dash") and not is_dashing:
		#dash()
		#


extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# SPRITE E HITBOX DO PLAYER
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

# HITBOXES DA ESPADA
@onready var attack_still_hitbox: CollisionShape2D = $Area2D/AttackStillHitbox
@onready var attack_moving_hitbox: CollisionShape2D = $Area2D/AttackMovingHitbox

var is_attacking = false
var is_dashing = false


func _ready() -> void:
	floor_max_angle = 45.0
	floor_snap_length = 2.0


func _physics_process(delta: float) -> void:
	################################ INPUT #####################################
	var direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("attack1"): attack(direction)
	if Input.is_action_just_pressed("jump"): jump()
	if Input.is_action_just_pressed("dash"): dash(direction)
	move(direction)

	############################## CÁLCULO #####################################

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	############################### UPDATE #####################################
	play_animation(direction)

	move_and_slide()


func move(direction):
	if direction and not is_dashing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func jump():
	if not is_attacking and is_on_floor():
			velocity.y = JUMP_VELOCITY

func attack(direction):
	#if not is_attacking:
		if velocity.x != 0:
			attack_moving(direction)
		else:
			attack_still()

func attack_moving(direction):
	is_attacking = true
	if direction < 0:
		hitbox.position.x = -10.0
	elif direction > 0:
		hitbox.position.x = 10.0
	attack_moving_hitbox.disabled = false
	sprite.play("attack_moving")
	await sprite.animation_finished
	attack_moving_hitbox.disabled = true
	if sprite.flip_h:
		hitbox.position.x = 5.0
	else:
		hitbox.position.x = -5.0
	is_attacking = false

func attack_still():
	is_attacking = true
	attack_still_hitbox.disabled = false
	sprite.play("attack_still")
	await sprite.animation_finished
	attack_still_hitbox.disabled = true
	is_attacking = false
	
func dash(direction: float):
	is_dashing = true
	sprite.play("dash")
	if sprite.flip_h:
		velocity.x -= 1300
	else:
		velocity.x += 1300
	await get_tree().create_timer(0.1).timeout
	velocity.x = move_toward(velocity.x, 0, SPEED)
	is_dashing = false
	is_attacking = false
	attack_still_hitbox.disabled = true
	attack_moving_hitbox.disabled = true

func play_animation(direction):
	if not is_attacking and not is_dashing:
		if not is_on_floor():
			if velocity.y < 0:
				sprite.play("jump")
			elif velocity.y > 0:
				sprite.play("fall")
		else:
			if velocity.x == 0:
				sprite.play("idle")
			else:
				sprite.play("run")
		if direction < 0:
			sprite.flip_h = true
			hitbox.position.x = 5.0
			attack_still_hitbox.position.x = -19
			attack_moving_hitbox.position.x = -40
		elif direction > 0:
			sprite.flip_h = false
			hitbox.position.x = -5.0
			attack_still_hitbox.position.x = 19
			attack_moving_hitbox.position.x = 40
