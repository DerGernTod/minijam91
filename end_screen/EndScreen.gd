extends Control


func _ready() -> void:
	pass


func _on_Button_button_up() -> void:
	SceneContainer.reset()
	get_tree().change_scene("res://Main.tscn")
