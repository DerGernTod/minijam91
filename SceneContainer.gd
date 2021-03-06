extends Node

signal goal_props_loaded

const UFO_CAPACITY = 3

var _ufo_content = []
var _droppable_content = {}
var goal_properties = {}
var _known_props = {
	"speed": -1,
	"size": -1,
	"color": -1,
	"scales": -1,
	"front_fin": -1,
	"back_fin": -1,
}

func _ready() -> void:
	randomize()
	roll_goal_properties()


func roll_goal_properties() -> void:
	goal_properties = {
		"speed": randi() % Globals.SPEED_MAP.size(),
		"size": randi() % Globals.SIZE_MAP.size(),
		"color": randi() % Globals.COLOR_MAP.size(),
		"scales": randi() % Globals.SCALES_MAP.size(),
		"front_fin": randi() % Globals.COLOR_MAP.size(),
		"back_fin": randi() % Globals.COLOR_MAP.size(),
	}
	emit_signal("goal_props_loaded", goal_properties)


func push_pickable(node: Node) -> bool:
	if _ufo_content.size() < UFO_CAPACITY and not _ufo_content.has(node):
		_ufo_content.push_back(node)
		return true
	return false


func remove_pickable(node: Node) -> void:
	_ufo_content.erase(node)


func pop_pickable() -> Node:
	return _ufo_content.pop_front()


func get_pickables() -> Array:
	return _ufo_content


func store_pickables() -> void:
	for pickable in _ufo_content:
		pickable.set_owner(get_tree().get_root())
		pickable.get_parent().remove_child(pickable)
		add_child(pickable)


func store_droppable_content(droppable_name: String, pickables: Array) -> void:
	for pickable in pickables:
		pickable.set_owner(get_tree().get_root())
		pickable.get_parent().remove_child(pickable)
	_droppable_content[droppable_name] = pickables


func get_droppable_content(droppable_name: String) -> Array:
	if _droppable_content.has(droppable_name):
		return _droppable_content[droppable_name]
	return []


func store_known_props(known_props: Dictionary) -> void:
	_known_props = known_props


func get_known_props() -> Dictionary:
	return _known_props


func reset() -> void:
	_known_props = {
		"speed": -1,
		"size": -1,
		"color": -1,
		"scales": -1,
		"front_fin": -1,
		"back_fin": -1,
	}
	while _ufo_content.size() > 0:
		_ufo_content.pop_back().queue_free()
	for value in _droppable_content.values():
		while value.size() > 0:
			value.pop_back().queue_free()
	_droppable_content = {}
	goal_properties = {}
	roll_goal_properties()
