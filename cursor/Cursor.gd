extends Area2D
class_name Cursor

var has_content: bool = false setget _set_content, _has_content

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	position = pos


func _has_content() -> bool:
	return has_content


func _set_content(c: bool) -> void:
	has_content = c
