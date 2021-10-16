extends Area2D
class_name Droppable

signal dropped
signal pulled
export var capacity: int = 1

var can_drop = false setget , _get_can_drop
var _content = 0
var _cur_cursor: Cursor = null


func area_entered(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = area 


func area_exited(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = null


func pickable_dropped() -> void:
	_content += 1
	emit_signal("dropped")


func pickable_pulled() -> void:
	_content -= 1
	emit_signal("pulled")


func _ready() -> void:
	connect("area_entered", self, "area_entered")
	connect("area_exited", self, "area_exited")


func _get_can_drop() -> bool:
	return _content < capacity

