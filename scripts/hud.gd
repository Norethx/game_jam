extends Node2D

@onready var health_label: Label = $CanvasLayer/HealthLabel
@onready var armor_layer: Label = $CanvasLayer/ArmorLayer
@onready var stamina_layer: Label = $CanvasLayer/StaminaLayer


func _on_player_knight_upate_armor(amount: float) -> void:
	armor_layer.text = str(amount) + "/100" 


func _on_player_knight_upate_health(amount: float) -> void:
	health_label.text = str(amount) + "/100" 


func _on_player_knight_update_stamina(amount: float) -> void:
	stamina_layer.text = str(amount) + "/100" 
