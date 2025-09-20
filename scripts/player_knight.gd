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
var is_damage_enabled = false

# STATUS
var health = 100
var damage = 100
var stamina = 100


func _ready() -> void:
	floor_max_angle = 45.0
	floor_snap_length = 2.0


func _physics_process(delta: float) -> void:
	init_gravity(delta)
	
	################################ INPUT #####################################
	var direction = Input.get_axis("move_left", "move_right")
	
	init_animations()
	init_hitbox(direction)
	init_movement(direction)
	if Input.is_action_just_pressed("attack1"): attack1_handler(direction)
	if Input.is_action_just_pressed("jump"): jump_handler()
	if Input.is_action_just_pressed("dash"): dash_handler(direction)

	move_and_slide()

# ================================================
# =================== GRAVITY ===================
# ================================================

func init_gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

# ==================================================
# =================== ANIMATIONS ===================
# ==================================================

func init_animations():
	if not is_attacking and not is_dashing:
		if not is_on_floor():
			on_air_handler()
		else:
			on_floor_handler()

func on_air_handler():
	if velocity.y < 0:
		sprite.play("jump")
	elif velocity.y > 0:
		sprite.play("fall")

func on_floor_handler():
	if velocity.x == 0:
		sprite.play("idle")
	else:
		sprite.play("run")

# ==============================================
# =================== HITBOX ===================
# ==============================================

func init_hitbox(direction: float):
	if not is_attacking and not is_dashing:
		hitbox_handler(direction)

func hitbox_handler(direction: float):
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

# ================================================
# =================== MOVEMENT ===================
# ================================================

func init_movement(direction: float):
	if direction and not is_dashing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func jump_handler():
	if not is_attacking and is_on_floor():
			velocity.y = JUMP_VELOCITY

# =============================================
# =================== ATACK ===================
# =============================================

func attack1_handler(direction):
	if not is_attacking:
		if velocity.x != 0:
			attack1_moving(direction)
		else:
			attack1_still()

func attack1_moving(direction):
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

func attack1_still():
	is_attacking = true
	attack_still_hitbox.disabled = false
	sprite.play("attack_still")
	await sprite.animation_finished
	attack_still_hitbox.disabled = true
	is_attacking = false

# ============================================
# =================== DASH ===================
# ============================================

func dash_handler(direction: float):
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
