extends Control

@export var first_map: PackedScene
@export var continue_button: Button


func _ready() -> void:
	if not Main.can_continue():
		continue_button.disabled = true


func _on_button_pressed() -> void:
	await DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"))
	Main.load_map(first_map.resource_path)


func _on_button_2_pressed() -> void:
	Main.load_continue_map()


func _on_button_3_pressed() -> void:
	get_tree().quit()
