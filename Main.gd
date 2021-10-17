extends Node2D


func _ready() -> void:
	pass


func _on_SeaSideButton_released() -> void:
	SceneContainer.store_pickables()
	get_tree().change_scene("res://seaside/SeaSide.tscn")


func _on_BreedingMachine_successful_breed() -> void:
	get_tree().paused = true
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene("res://end_screen/EndScreen.tscn")
	get_tree().paused = false
