extends Node

signal goal_props_loaded

const UFO_CAPACITY = 3

var _ufo_content = []
var goal_properties = {}

func _ready() -> void:
	randomize()
	roll_goal_properties()


func roll_goal_properties() -> void:
	goal_properties = {
		"speed": randi() % Globals.SPEED_MAP.size(),
		"size": randi() % Globals.SIZE_MAP.size(),
		"color": randi() % Globals.COLOR_MAP.size(),
	}
	emit_signal("goal_props_loaded", goal_properties)


func push_pickable(node: Node) -> bool:
	if _ufo_content.size() < UFO_CAPACITY:
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
		pickable.get_parent().remove_child(pickable)
		add_child(pickable)
