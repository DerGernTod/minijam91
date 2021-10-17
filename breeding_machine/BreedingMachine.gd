extends Node2D

var left_content = null
var right_content = null
var target_props = {
	"speed": randi() % Globals.SPEED_MAP.size(),
	"size": randi() % Globals.SIZE_MAP.size(),
	"color": randi() % Globals.COLOR_MAP.size(),
}
var _output_blocked = false

onready var FishScene = preload("res://fish/Fish.tscn")
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
	_output_blocked = true
	var instance = FishScene.instance()
	instance.position = _breeding_output.global_position
	get_tree().get_root().add_child(instance)
	instance.connect("dropped", self, "_on_output_dropped", [], CONNECT_ONESHOT)
	instance.call_deferred("setup_properties", child_props)


func _create_alien() -> void:
	pass


func _match_fish(fish: Fish) -> void:
	pass


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


func _on_BreedingBoxLeft_pulled(pickable: Area2D) -> void:
	left_content = null


func _on_BreedingBoxRight_pulled(pickable: Area2D) -> void:
	right_content = null
