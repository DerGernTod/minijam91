extends Pickable
class_name Fish

export var init_properties = {
	"speed": 0,
	"size": 0,
	"color": 0,
	"scales": 0,
}

var _cur_properties = init_properties

onready var _collision_shape = $CollisionShape2D
onready var _init_extents = _collision_shape.shape.extents
onready var _cur_body = $BodyBig
onready var _bodies = [
	$BodyBig,
	$BodyMedium,
	$BodySmall,
]

func get_prop(prop: String) -> int:
	return _cur_properties[prop]


func setup_properties(properties: Dictionary = {}) -> void:
	for body in _bodies:
		body.visible = false
	if properties.size() == 0:
		_cur_properties = {
			"speed": randi() % Globals.SPEED_MAP.size(),
			"size": randi() % Globals.SIZE_MAP.size(),
			"color": randi() % Globals.COLOR_MAP.size(),
			"scales": randi() % Globals.SCALES_MAP.size(),
		}
	else:
		_cur_properties = properties
	_cur_body = _bodies[_cur_properties.size]
	_cur_body.visible = true
	_cur_body.modulate = Globals.COLOR_MAP[_cur_properties.color]
	_cur_body.get_child(1).frame = Globals.SCALES_MAP[_cur_properties.scales]
	_collision_shape.shape.extents = _init_extents * Globals.SIZE_MAP[_cur_properties.size]


func create_offsprint(mother_props, father_props) -> void:
	pass


func _ready() -> void:
	var col_shape = RectangleShape2D.new()
	col_shape.extents = _init_extents
	_collision_shape.shape = col_shape
	connect("dropped", self, "_on_dropped")


func _on_dropped(droppable: Area2D) -> void:
	print("%s dropped into %s" % [name, droppable.name])
