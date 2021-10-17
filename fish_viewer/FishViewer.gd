extends MarginContainer

onready var _content = {
	"speed": {
		"left": $GridContainer/SpeedTex,
		"right": $GridContainer/SpeedTex2,
	},
	"size": {
		"left": $GridContainer/SizeTex,
		"right": $GridContainer/SizeTex2,
	},
	"color": {
		"left": $GridContainer/ColorTex,
		"right": $GridContainer/ColorTex2,
	},
}
onready var _container = $GridContainer
onready var _prop_textures = {
	0: preload("res://properties/triangle.png"),
	1: preload("res://properties/quad.png"),
	2: preload("res://properties/quint.png"),
	3: preload("res://properties/hex.png"),
	4: preload("res://properties/sept.png"),
}

var left_content = null
var right_content = null
var goal_props = {}


func _connect_pickable(node: Pickable) -> void:
	node.connect("hover_start", self, "_on_Pickable_hover_start", [node])
	node.connect("hover_end", self, "_on_Pickable_hover_end", [node])


func _ready() -> void:
	get_tree().connect("node_added", self, "_on_SceneTree_node_added")
	for pickable in get_tree().get_nodes_in_group("Pickables"):
		_connect_pickable(pickable)


func _populate_left(speed: int, size: int, color: int) -> void:
	_content.speed.left.texture = _prop_textures[speed]
	_content.size.left.texture = _prop_textures[size]
	_content.color.left.texture = _prop_textures[color]


func _on_SceneTree_node_added(node: Node) -> void:
	if node is Pickable:
		_connect_pickable(node)


func _on_Pickable_hover_start(node: Pickable) -> void:
	if node.pickable_name == "Fish":
		_populate_left(
			node.get_prop("speed"),
			node.get_prop("size"),
			node.get_prop("color"))
		_container.modulate = Color.white
	if node.pickable_name == "Egg":
		_container.modulate = Color.white


func _on_Pickable_hover_end(node: Pickable) -> void:
	_container.modulate = Color.transparent


func _on_BreedingMachine_breeding_left_entered(node: Pickable) -> void:
	left_content = node


func _on_BreedingMachine_breeding_left_exited() -> void:
	left_content = null


func _on_BreedingMachine_breeding_right_entered(node: Pickable) -> void:
	right_content = node


func _on_BreedingMachine_breeding_right_exited() -> void:
	right_content = null


func _on_BreedingMachine_goal_props_detected(detected_props: Dictionary) -> void:
	for prop in detected_props.keys():
		goal_props[prop] = detected_props[prop]
