extends CharacterBody2D

@export var speed = 120
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cool_dash: Timer = $CoolDash
@onready var dash: Timer = $Dash
var dash_ready = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dash") and dash_ready:
		dash_ready = false
		speed = 400
		dash.start(0.5)
		await speed == 120
		cool_dash.start(3)

func _physics_process(delta: float) -> void:
	var vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = vector * speed
	animation_tree.set("parameters/blend_position", velocity)
	move_and_slide()


func _on_cool_dash_timeout() -> void:
	dash_ready = true


func _on_dash_timeout() -> void:
	speed = 120
