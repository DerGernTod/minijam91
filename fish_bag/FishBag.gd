extends Pickable

var _fish = null
var _drop_zone = null


func _ready() -> void:
	connect("area_entered", self, "area_entered_bag")
	connect("area_exited", self, "area_exited_bag")
	connect("dropped", self, "dropped_bag")


func dropped_bag() -> void:
	if _cur_cursor and can_pick:
		modulate = Color.cyan


func area_entered_bag(area: Area2D) -> void:
	if area is Cursor and not area.has_content:
		modulate = Color.cyan


func area_exited_bag(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = null
		modulate = Color.white
