extends Node2D


func _ready() -> void:
	pass


func _on_SeaSideButton_released() -> void:
	SceneContainer.store_pickables()
	get_tree().change_scene("res://seaside/SeaSide.tscn")
