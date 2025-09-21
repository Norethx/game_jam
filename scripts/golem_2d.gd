#extends Area2D
#
#enum InitialDirectionMode {LEFT, RIGHT}
#
#@export var speed: float = 80.0
#@export var target: Node2D
#
#@onready var start_position: Vector2 = global_position
#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#
#var velocity = Vector2.ZERO
#var direction: int = randi_range(-1, 1)
#
#
#func _ready() -> void:
	#add_to_group("penemies")
#
#func _physics_process(delta: float) -> void:
	#if target:
		#var direction = ((target.global_position + Vector2.UP * 20) - global_position).normalized()
##
		#$AnimatedSprite2D.flip_h = direction.x < 0
##
		#var distance = global_position.distance_to(target.global_position + Vector2.UP * 20)
		#if distance < 200.0:
			#if distance < 10:
				#sprite.play("idle")
			#else:
				#sprite.play("run")
				#global_position += direction * speed * delta
		#else:
			#direction = (start_position - global_position).normalized()
			#if global_position.distance_to(start_position) < 20:
				#sprite.play("idle")
			#else:
				#global_position += direction * speed * delta
				##$CollisionShape2D.force_update_transform()
				#sprite.play("run")

extends Area2D

@export var speed: float = 80.0
@export var target: Node2D = null
@onready var start_position: Vector2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("penemies")
	start_position = global_position
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if target:
		var direction = (target.global_position + Vector2.UP * 20 - global_position).normalized()
		global_position += direction * speed * delta

		# garante que a hitbox acompanha a posição
		hitbox.force_update_transform()

# Chamada pelo player quando acerta o inimigo
#func take_damage(amount: int = 1) -> void:


func die() -> void:
	sprite.play("die")
	await sprite.animation_finished
	queue_free()
