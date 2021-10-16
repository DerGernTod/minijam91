extends Area2D
class_name Cursor

var content: Area2D = null setget _set_content, _get_content

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	position = pos


func _get_content() -> Area2D:
	return content


func _set_content(c: Area2D) -> void:
	content = c
