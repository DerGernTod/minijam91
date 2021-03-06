extends Node2D

signal goal_props_detected
signal breeding_left_entered
signal breeding_right_entered
signal breeding_left_exited
signal breeding_right_exited
signal successful_breed

var left_content = null
var right_content = null
var target_props = {}
var known_props = {
	"speed": false,
	"size": false,
	"color": false,
	"scales": false,
	"front_fin": false,
	"back_fin": false,
}
var _output_blocked = false

onready var FishScene = load("res://fish/Fish.tscn")
onready var GooScene = load("res://goo/Goo.tscn")
onready var EggScene = load("res://egg/Egg.tscn")
onready var AlienBabyScene = load("res://alien_baby/AlienBaby.tscn")
onready var AlienFishBabyScene = load("res://alien_baby/AlienFishBaby.tscn")
onready var _breeding_output = $BreedingOutput
onready var _breed_label = $AnimatedSprite


func _ready() -> void:
	SceneContainer.connect("goal_props_loaded", self, "_on_SceneContainer_goal_props_loaded")
	target_props = SceneContainer.goal_properties


func _on_SceneContainer_goal_props_loaded(goal_props: Dictionary) -> void:
	target_props = goal_props


func _create_fish() -> void:
	var parents = [left_content, right_content]
	var child_props = {
		"speed": parents[randi() % 2].get_prop("speed"),
		"size": parents[randi() % 2].get_prop("size"),
		"color": parents[randi() % 2].get_prop("color"),
		"scales": parents[randi() % 2].get_prop("scales"),
		"front_fin": parents[randi() % 2].get_prop("front_fin"),
		"back_fin": parents[randi() % 2].get_prop("back_fin"),
	}
	var fish = _create_output(FishScene)
	fish.call_deferred("setup_properties", child_props)


func _create_output(type: Resource) -> Resource:
	_output_blocked = true
	var instance = type.instance()
	instance.position = _breeding_output.global_position
	$"/root/Main".add_child(instance)
	instance.connect("dropped", self, "_on_output_dropped", [], CONNECT_ONESHOT)
	return instance


func _match_fish(fish: Fish) -> void:
	var matching_props = {
		"speed": fish.get_prop("speed") == target_props.speed,
		"size": fish.get_prop("size") == target_props.size,
		"color": fish.get_prop("color") == target_props.color,
		"scales": fish.get_prop("scales") == target_props.scales,
		"front_fin": fish.get_prop("front_fin") == target_props.front_fin,
		"back_fin": fish.get_prop("back_fin") == target_props.back_fin,
	}
	var found_goal = true
	var detected_this_round = {}
	for prop in matching_props.keys():
		if not matching_props[prop]:
			found_goal = false
		elif not known_props[prop]:
			print("detected goal prop %s" % prop)
			detected_this_round[prop] = target_props[prop]
			known_props[prop] = true
	emit_signal("goal_props_detected", detected_this_round)
	if found_goal:
		_create_output(AlienFishBabyScene)
		emit_signal("successful_breed")
		print("congrats, that's the correct fish!")
	else:
		_create_output(GooScene)


func _on_output_dropped(_droppable: Area2D) -> void:
	_output_blocked = false
	_update_btn_state()


func _on_BreedingButton_released() -> void:
	if _output_blocked:
		print("output blocked, please move first")
	elif left_content and right_content:
		print("breeding %s with %s" % [left_content.name, right_content.name])
		match [left_content.pickable_name, right_content.pickable_name]:
			["Fish", "Fish"]: _create_fish()
			["Egg", "Egg"], ["Alien", "Egg"], ["Egg", "Alien"]: _create_output(AlienBabyScene)
			["Fish", "Egg"]: _match_fish(left_content)
			["Egg", "Fish"]: _match_fish(right_content)
			["Alien", "Alien"]: _create_output(EggScene)
			["Goo", _], [_, "Goo"], ["Alien", "Fish"], ["Fish", "Alien"]: _create_output(GooScene)
	else:
		print("please fill both breeding boxes before breeding")
	_update_btn_state()


func _update_btn_state() -> void:
	match [right_content, left_content, _output_blocked]:
		[null, _, _], [_, null, _], [_, _, true]: _breed_label.frame = 0
		[_, _, false]: _breed_label.frame = 1


func _on_BreedingBoxRight_dropped(pickable: Area2D) -> void:
	right_content = pickable
	_update_btn_state()
	emit_signal("breeding_right_entered", pickable)


func _on_BreedingBoxLeft_dropped(pickable: Area2D) -> void:
	left_content = pickable
	_update_btn_state()
	emit_signal("breeding_left_entered", pickable)


func _on_BreedingBoxRight_pulled(_pickable: Area2D) -> void:
	right_content = null
	_update_btn_state()
	emit_signal("breeding_right_exited")


func _on_BreedingBoxLeft_pulled(_pickable: Area2D) -> void:
	left_content = null
	_update_btn_state()
	emit_signal("breeding_left_exited")
