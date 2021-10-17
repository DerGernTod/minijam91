extends Pickable
class_name Fish

export var init_properties = {
	"speed": 1,
	"size": 1,
	"color": 1,
}

var _cur_properties = init_properties

onready var _sprite = $AnimatedSprite
onready var _init_sprite_scale = $AnimatedSprite.scale
onready var _collision_shape = $CollisionShape2D
onready var _init_extents = _collision_shape.shape.extents


func get_prop(prop: String) -> int:
	return _cur_properties[prop]


func setup_properties(properties: Dictionary = {}) -> void:
	if properties.size() == 0:
		_cur_properties = {
			"speed": randi() % Globals.SPEED_MAP.size(),
			"size": randi() % Globals.SIZE_MAP.size(),
			"color": randi() % Globals.COLOR_MAP.size(),
		}
	else:
		_cur_properties = properties
	_sprite.scale = _init_sprite_scale * Globals.SIZE_MAP[_cur_properties.size]
	_sprite.modulate = Globals.COLOR_MAP[_cur_properties.color]
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
