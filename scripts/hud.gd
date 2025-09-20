extends Node2D

@onready var progress_bar_health: ProgressBar = $CanvasLayer/HBoxContainer/ProgressBarHealth
@onready var progress_bar_armor: ProgressBar = $CanvasLayer/HBoxContainer/ProgressBarArmor
@onready var progress_bar_stamina: ProgressBar = $CanvasLayer/HBoxContainer/ProgressBarStamina


func _on_player_knight_upate_armor(amount: float) -> void:
	progress_bar_armor.value = amount


func _on_player_knight_upate_health(amount: float) -> void:
	progress_bar_health.value = amount

func _on_player_knight_update_stamina(amount: float) -> void:
	progress_bar_stamina.value = amount
