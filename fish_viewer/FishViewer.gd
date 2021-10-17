extends MarginContainer

const PROPS_HIDDEN = { "speed": -2, "size": -2, "color": -2 }

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
	-2: preload("res://properties/empty.png"),
	-1: preload("res://properties/unknown.png"),
	0: preload("res://properties/triangle.png"),
	1: preload("res://properties/quad.png"),
	2: preload("res://properties/quint.png"),
	3: preload("res://properties/hex.png"),
	4: preload("res://properties/sept.png"),
}

var content = {
	"left": null,
	"right": null,
}
var hovers = []
var goal_props = {
	"speed": -1,
	"size": -1,
	"color": -1,
}


func _connect_pickable(node: Pickable) -> void:
	node.connect("hover_start", self, "_on_Pickable_hover_start", [node])
	node.connect("hover_end", self, "_on_Pickable_hover_end", [node])


func _disconnect_pickable(node: Pickable) -> void:
	node.disconnect("hover_start", self, "_on_Pickable_hover_start")
	node.disconnect("hover_end", self, "_on_Pickable_hover_end")


func _ready() -> void:
	_container.modulate = Color.transparent
	get_tree().connect("node_added", self, "_on_SceneTree_node_added")
	get_tree().connect("node_removed", self, "_on_SceneTree_node_removed")
	for pickable in get_tree().get_nodes_in_group("Pickables"):
		_connect_pickable(pickable)


func _populate(side: String, props: Dictionary) -> void:
	for prop in ["speed", "size", "color"]:
		_content[prop][side].texture = _prop_textures[props[prop]]


func _populate_hover(node: Pickable) -> void:
	_container.modulate = Color.white
	var props = {
		"left": goal_props.duplicate(),
		"right": goal_props.duplicate(),
	}
	for side in ["left", "right"]:
		if content[side] is Fish:
			for prop in ["speed", "size", "color"]:
				props[side][prop] = content[side].get_prop(prop)

	
	match [node == content.right, node == content.left, content.right == null, content.left == null]:
		[true, _, _, true]:
			props.left = PROPS_HIDDEN
		[_, true, true, _]:
			props.right = PROPS_HIDDEN
		[false, false, _, _]:
			props.right = PROPS_HIDDEN
			match node.pickable_name:
				"Fish":
					props.left = {
						"speed": node.get_prop("speed"),
						"size": node.get_prop("size"),
						"color": node.get_prop("color"),
					}
				"Goo": props.left = PROPS_HIDDEN
				"Alien", "Egg": props.left = goal_props
	
	_populate("left", props.left)
	_populate("right", props.right)

func _on_SceneTree_node_added(node: Node) -> void:
	if node is Pickable:
		_connect_pickable(node)
		
		
func _on_SceneTree_node_removed(node: Node) -> void:
	if node is Pickable:
		_disconnect_pickable(node)


func _on_Pickable_hover_start(node: Pickable) -> void:
	hovers.push_back(node)
	match node.pickable_name:
		"Fish", "Egg": _populate_hover(node)


func _on_Pickable_hover_end(node: Pickable) -> void:
	hovers.erase(node)
	if hovers.size() == 0:
		_container.modulate = Color.transparent
	else:
		_populate_hover(hovers.back())


func _on_BreedingMachine_breeding_left_entered(node: Pickable) -> void:
	content.left = node


func _on_BreedingMachine_breeding_left_exited() -> void:
	content.left = null


func _on_BreedingMachine_breeding_right_entered(node: Pickable) -> void:
	content.right = node


func _on_BreedingMachine_breeding_right_exited() -> void:
	content.right = null


func _on_BreedingMachine_goal_props_detected(detected_props: Dictionary) -> void:
	for prop in detected_props.keys():
		goal_props[prop] = detected_props[prop]
