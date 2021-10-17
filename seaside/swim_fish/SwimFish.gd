extends Fish

var velocity = Vector2.ZERO
var is_collected = false
var lifetime = 0
var direction = 1

func _ready() -> void:
	while not is_collected:
		yield(get_tree().create_timer(randi() % 2 + 2), "timeout")


func _physics_process(delta: float) -> void:
	lifetime += delta
	position += Vector2(Globals.SPEED_MAP[_cur_properties.speed] * 5 * direction, sin(lifetime)) * delta
	
	

