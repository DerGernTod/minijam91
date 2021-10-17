extends Node2D

signal goal_props_detected

var left_content = null
var right_content = null
var target_props = {
	"speed": randi() % Globals.SPEED_MAP.size(),
	"size": randi() % Globals.SIZE_MAP.size(),
	"color": randi() % Globals.COLOR_MAP.size(),
}
var known_props = {
	"speed": false,
	"size": false,
	"color": false,
}
var _output_blocked = false

onready var FishScene = preload("res://fish/Fish.tscn")
onready var GooScene = preload("res://goo/Goo.tscn")
onready var _breeding_output = $BreedingOutput

func _ready() -> void:
	pass


func _create_fish() -> void:
	var parents = [left_content, right_content]
	var child_props = {
		"speed": parents[randi() % 2].get_prop("speed"),
		"size": parents[randi() % 2].get_prop("size"),
		"color": parents[randi() % 2].get_prop("color"),
	}
	var fish = _create_output(FishScene)
	fish.call_deferred("setup_properties", child_props)


func _create_output(type: Resource) -> Resource:
	_output_blocked = true
	var instance = type.instance()
	instance.position = _breeding_output.global_position
	get_tree().get_root().add_child(instance)
	instance.connect("dropped", self, "_on_output_dropped", [], CONNECT_ONESHOT)
	return instance


func _create_alien() -> void:
	print("eggs can only be fertilized with other species!")


func _match_fish(fish: Fish) -> void:
	var matching_props = {
		"speed": fish.get_prop("speed") == target_props.speed,
		"size": fish.get_prop("size") == target_props.size,
		"color": fish.get_prop("color") == target_props.color
	}
	var found_goal = true
	var detected_this_round = []
	for prop in matching_props.keys():
		if not matching_props[prop]:
			found_goal = false
		elif not known_props[prop]:
			print("detected goal prop %s" % prop)
			detected_this_round.push_back(prop)
			known_props[prop] = true
	emit_signal("goal_props_detected", detected_this_round)
	if found_goal:
		print("congrats, that's the correct fish!")
	else:
		_create_output(GooScene)


func _on_output_dropped(_droppable: Area2D) -> void:
	_output_blocked = false


func _on_BreedingButton_released() -> void:
	if _output_blocked:
		print("output blocked, please move first")
	elif left_content and right_content:
		print("breeding %s with %s" % [left_content.name, right_content.name])
		match [left_content is Fish, right_content is Fish]:
			[true, true]: _create_fish()
			[false, false]: _create_alien()
			[true, false]: _match_fish(left_content)
			[false, true]: _match_fish(right_content)
	else:
		print("please fill both breeding boxes before breeding")


func _on_BreedingBoxRight_dropped(pickable: Area2D) -> void:
	right_content = pickable


func _on_BreedingBoxLeft_dropped(pickable: Area2D) -> void:
	left_content = pickable


func _on_BreedingBoxLeft_pulled(_pickable: Area2D) -> void:
	left_content = null


func _on_BreedingBoxRight_pulled(_pickable: Area2D) -> void:
	right_content = null
