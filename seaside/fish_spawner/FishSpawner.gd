extends Position2D

export(bool) var target_right = true

var SwimFish = preload("res://seaside/swim_fish/SwimFish.tscn")
var lifetime = 0.0

onready var height_offset = position.y
onready var screen_height = ProjectSettings.get_setting("display/window/size/height") - 20
onready var amplitude = (screen_height - height_offset) / 2.0
onready var timer = $Timer

func _ready() -> void:
	yield(get_tree().get_root(), "ready")
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	print("screen width is %s" % screen_width)
	for i in randi() % 5 + 5:
		_spawn_fish(Vector2(randi() % screen_width, height_offset + randf() * (screen_height - height_offset)))
	
	while is_instance_valid(self):
		_spawn_fish()
		timer.start(randf() * 5 + 2)
		yield(timer, "timeout")


func _process(delta: float) -> void:
	lifetime += delta
	position.y = height_offset + sin(lifetime) * amplitude + amplitude


func _spawn_fish(custom_pos: Vector2 = Vector2.ZERO) -> void:
	var fish = SwimFish.instance()
	if custom_pos == Vector2.ZERO:
		fish.position = position
	else:
		fish.position = custom_pos
	fish.direction = 1 if target_right else -1
	$"/root/SeaSide".add_child(fish)
	fish.call_deferred("setup_properties")
