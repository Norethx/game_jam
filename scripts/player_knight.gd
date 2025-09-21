extends CharacterBody2D

signal upate_health(amount: float)
signal upate_armor(amount: float)
signal update_stamina(amount: float)

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# SPRITE E HITBOX DO PLAYER
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

# HITBOXES DA ESPADA
@onready var strike_area: Area2D = $StrikeArea
@onready var attack_still_hitbox: CollisionShape2D = $StrikeArea/AttackStillHitbox
@onready var attack_moving_hitbox: CollisionShape2D = $StrikeArea/AttackMovingHitbox

var is_attacking = false
var is_dashing = false
var is_damage_enabled = false
var is_armor_enabled = true
var is_death_enabled = true
var is_dead = false
var is_uncouncious = false

# STATUS
@export var health: float = 100
@export var armor: float = 0
var slash_damage: float = 100
var blunt_damage: float = 20
@export var stamina: float = 100


var stamina_cooldown: float = 0.5
var stamina_last_use_time: int = 0
var stamina_last_cooldown_tick: int = 0
var stamina_total: float = 100
enum Stamina {
	JUMP_LOSS = 10,
	DASH_LOSS = 25,
	HIT_LOSS = 5,
}


func _ready() -> void:
	add_to_group("player")
	floor_max_angle = 45.0
	floor_snap_length = 2.0


func _physics_process(delta: float) -> void:
	init_gravity(delta)

	################################ INPUT #####################################
	var direction = Input.get_axis("move_left", "move_right")


	if not is_dead:
		init_animations()
		init_hitbox(direction)
		init_movement(direction)
		colldown_stamina()
		if Input.is_action_just_pressed("attack1"): attack1_handler(direction)
		if Input.is_action_just_pressed("jump"): jump_handler()
		if Input.is_action_just_pressed("dash"): dash_handler()

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
			if not use_stamina(Stamina.JUMP_LOSS):
				return
			velocity.y = JUMP_VELOCITY

# =============================================
# =================== ATACK ===================
# =============================================

func attack1_handler(direction):
	if not is_attacking:
		if not use_stamina(Stamina.HIT_LOSS):
			return
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

func dash_handler():
	if not use_stamina(Stamina.DASH_LOSS):
		return
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

# --------------------------------------------------------------------------------------------
# ------------------------------------------ COMBAT ------------------------------------------
# --------------------------------------------------------------------------------------------

# ==============================================
# =================== DAMAGE ===================
# ==============================================

func take_health_damge(amount: float):
	var damage: float = take_armor_damge(amount)
	if damage and not is_dead:
		velocity.x = 0
		sprite.play("hit")
		if damage > health:
			health = 0
			upate_health.emit(health)
			die()
			return
		health -= damage
		upate_health.emit(health)

func take_armor_damge(amount: float) -> float:
	var damage: float = 0

	if amount <= 0:
		return 0
	if not is_armor_enabled:
		return amount
	if amount > armor:
		damage = amount - armor
		armor = 0
		upate_armor.emit(armor)
		return damage
	armor -= amount
	upate_armor.emit(armor)
	return 0;

func die():
	if is_death_enabled:
		is_dead = true
		sprite.play(("die_moving"))
		await sprite.animation_finished
		print("You are Dead")
	else:
		is_uncouncious = true
		print("You are Uncouncious")

# ===============================================
# =================== STAMINA ===================
# ===============================================

func use_stamina(amount: float) -> bool:
	print("amount:", amount)
	if amount > stamina:
		print("Stamina: not enougth!")
		return false
	stamina -= amount
	update_stamina.emit(stamina)
	stamina_last_use_time = get_ms()
	print("Stamina:", stamina)
	return true

func colldown_stamina():
	if get_ms() - stamina_last_use_time < 1.5 * 1000:
		return
	if stamina >= stamina_total:
		return
	if get_ms() - stamina_last_cooldown_tick > 0.1 * 1000:
		if stamina + 2 >= stamina_total:
			stamina = stamina_total
			update_stamina.emit(stamina)
		else:
			stamina += 2
			update_stamina.emit(stamina)
		print("stamina regen:", stamina)
		stamina_last_cooldown_tick = get_ms()

# ===============================================
# =================== SYSTEM TIME ===================
# ===============================================

func get_ms():
	var time: int = Time.get_ticks_msec()
	return time


func _on_penemy_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		take_health_damge(10);


func _on_character_body_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		take_health_damge(10);
