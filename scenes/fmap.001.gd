extends Node2D

var puzz_1_check = 0
@onready var body_char: CharacterBody2D = $CharacterBody2D/Body
@onready var puzz_1_1: TileMapLayer = $puzz1_1
@onready var puzz_1_2: TileMapLayer = $puzz1_2
@onready var puzz_1_3: TileMapLayer = $puzz1_3
@onready var puzz_1_4: TileMapLayer = $puzz1_4


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && puzz_1_check <= 1 && puzz_1_3.position.distance_to(body_char.position) < 9.5:
		puzz_1_check = 1
	elif puzz_1_check > 1:
		puzz_1_check = 0
	if Input.is_action_just_pressed("interact") && puzz_1_check == 1 && puzz_1_2.position.distance_to(body_char.position) < 9.5:
		puzz_1_check = 2
	elif puzz_1_check == 2:
		puzz_1_check = puzz_1_check
	elif puzz_1_check < 1:
		puzz_1_check = 0
	if Input.is_action_just_pressed("interact") && puzz_1_check == 2 && puzz_1_4.position.distance_to(body_char.position) < 9.5:
		puzz_1_check = 3
	elif puzz_1_check == 3:
		puzz_1_check = puzz_1_check
	elif puzz_1_check < 2:
		puzz_1_check = 0
	if Input.is_action_just_pressed("interact") && puzz_1_check < 3 && puzz_1_1.position.distance_to(body_char.position) < 9.5:
		puzz_1_check = 0
	elif puzz_1_check == 3:
		puzz_1_check = 4
