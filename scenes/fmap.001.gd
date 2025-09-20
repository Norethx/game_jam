extends Node2D

@onready var puzz_check = 0
@onready var puzz_1: Node2D = $Puzz_1
@onready var puzz_4: Node2D = $Puzz_4
@onready var puzz_2: Node2D = $Puzz_2
@onready var puzz_3: Node2D = $Puzz_3
@onready var comm_take: Node2D = $communicator/comm_take
@onready var communicator: Node2D = $communicator
var	past_comunicator = false
@onready var bool_puzz = [false,false,false,false,false]


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && bool_puzz[0] && puzz_1.visible:
		puzz_1.visible = false
		puzz_check += 1
	elif Input.is_action_just_pressed("interact") && bool_puzz[1] && puzz_4.visible:
		puzz_4.visible = false
		puzz_check += 1
	elif Input.is_action_just_pressed("interact") && bool_puzz[2] && puzz_2.visible:
		puzz_2.visible = false
		puzz_check += 1
	elif Input.is_action_just_pressed("interact") && bool_puzz[3] && puzz_3.visible:
		puzz_3.visible = false
		puzz_check += 1
	elif Input.is_action_just_pressed("interact") && bool_puzz[4] && communicator.visible:
		past_comunicator = true
		print("I have the communicator!!")
		communicator.visible = false
	if puzz_check == 4 && !past_comunicator:
		communicator.visible = true
		

func _on_puzz_1_in_reach(reached: bool) -> void:
	bool_puzz[0] = reached


func _on_puzz_4_in_reach(reached: bool) -> void:
	bool_puzz[1] = reached


func _on_puzz_2_in_reach(reached: bool) -> void:
	bool_puzz[2] = reached


func _on_puzz_3_in_reach(reached: bool) -> void:
	bool_puzz[3] = reached


func _on_communicator_in_reach(reached: bool) -> void:
	bool_puzz[4] = reached
