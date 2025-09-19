extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var sprite_3_frames: Sprite2D = $Sprite3Frames
@onready var sprite_10_frames: Sprite2D = $Sprite10Frames
@export var animation_tree: AnimationTree

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		sprite_10_frames.visible = true
		sprite_3_frames.visible = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		sprite_10_frames.visible = false
		sprite_3_frames.visible = true
		velocity.y = JUMP_VELOCITY

	# Flippar o sprite de acordo com a direção
	if direction > 0:
		sprite_10_frames.flip_h = false
		sprite_3_frames.flip_h = false
	elif direction < 0:
		sprite_10_frames.flip_h = true
		sprite_3_frames.flip_h = true

	animation_tree.set("parameters/blend_position", velocity)

	move_and_slide()
