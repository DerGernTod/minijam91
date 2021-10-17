extends Position2D

export(bool) var target_right = true

var SwimFish = preload("res://seaside/swim_fish/SwimFish.tscn")
var lifetime = 0.0

onready var height_offset = position.y
onready var screen_height = ProjectSettings.get_setting("display/window/size/height") - 20
onready var amplitude = (screen_height - height_offset) / 2.0

func _ready() -> void:
	print("settings height %s" % ProjectSettings.get_setting("display/window/size/height"))
	while true:
		yield(get_tree().create_timer(randf() * 5 + 2), "timeout")
		_spawn_fish()


func _process(delta: float) -> void:
	lifetime += delta
	position.y = height_offset + sin(lifetime) * amplitude + amplitude


func _spawn_fish() -> void:
	var fish = SwimFish.instance()
	fish.position = global_position
	fish.direction = 1 if target_right else -1
	get_tree().get_root().add_child(fish)
	fish.call_deferred("setup_properties")
