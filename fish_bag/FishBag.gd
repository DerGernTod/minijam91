extends Area2D

var _cur_cursor: Cursor = null
var _fish = null


func _ready() -> void:
	connect("area_entered", self, "area_entered")
	connect("area_exited", self, "area_exited")


func area_entered(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = area
		var cursor_has_content = area.content != null
		


func area_exited(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = null
