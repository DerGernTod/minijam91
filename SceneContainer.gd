extends Node

signal goal_props_loaded

const UFO_CAPACITY = 3

var _ufo_content = []
var goal_properties = {}

func _ready() -> void:
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
