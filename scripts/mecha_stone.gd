extends CharacterBody2D

var health = 100

var is_dead = false
var is_attacking = false
var has_melee_agro = false
var has_ranged_agro = false
var has_melee_reach = false
var has_ranged_reach = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../PlayerKnight"

func _ready() -> void:
	add_to_group("bosses")
	sprite.play("idle")

func flip_boss():
	if player.global_position.x < global_position.x:
		# player à esquerda
		if not sprite.flip_h: # só flipa se necessário
			sprite.flip_h = true
			$AgroMelee/CollisionShape2D.position.x *= -1
			$HitboxMelee/CollisionShape2D.position.x *= -1
	else:
		# player à direita
		if sprite.flip_h: # só flipa se necessário
			sprite.flip_h = false
			$AgroMelee/CollisionShape2D.position.x *= -1
			$HitboxMelee/CollisionShape2D.position.x *= -1



func _process(_delta: float) -> void:
	if not is_attacking and not is_dead:
		flip_boss()
		if has_melee_agro:
			do_melee_attack()
		elif has_ranged_agro:
			do_ranged_attack()

func do_melee_attack() -> void:
	if not is_dead:
		is_attacking = true
		sprite.play("melee_attack")
		await get_tree().create_timer(1).timeout  # tempo do impacto
		$HitboxMelee/CollisionShape2D.disabled = false
		await get_tree().create_timer(0.2).timeout  # tempo ativo
		$HitboxMelee/CollisionShape2D.disabled = true
		await sprite.animation_finished
		is_attacking = false


func do_ranged_attack() -> void:
	if not is_dead:
		is_attacking = true
		sprite.play("charge_beam")
		await sprite.animation_finished
		sprite.play("raio_da_galinha")
		await sprite.animation_finished
		is_attacking = false


func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	if not is_dead:
		is_dead = true
		$CollisionShape2D.queue_free()
		sprite.stop()
		sprite.position = sprite.position.lerp(Vector2.UP * 20, 1.0)
		sprite.play("die")
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")


# ---- AGRO ----
func _on_agro_body_entered(body: Node2D) -> void:
	if not is_dead:
		if body.is_in_group("player"):
			has_melee_agro = true

func _on_agro_body_exited(body: Node2D) -> void:
	if not is_dead:
		if body.is_in_group("player"):
			has_melee_agro = false

func _on_agro_ranged_body_entered(area: Area2D) -> void:
	if not is_dead:
		print("TEM ALCANCE")
		if area.is_in_group("player"):
			has_ranged_agro = true

func _on_agro_ranged_body_exited(area: Area2D) -> void:
	if not is_dead:
		if area.is_in_group("player"):
			has_ranged_agro = false
