extends Node2D


func _ready() -> void:
	pass


func _on_MothershipButton_released() -> void:
	SceneContainer.store_pickables()
	get_tree().change_scene("res://Main.tscn")
