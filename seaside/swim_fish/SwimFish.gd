extends Fish

var velocity = Vector2.ZERO
var is_collected = false
var lifetime = 0
var direction = 1
var _swim_process = "_swim"

func _ready() -> void:
	lifetime += randf()


func collect() -> void:
	_swim_process = "_noop"
	is_collected = true


func _physics_process(delta: float) -> void:
	call(_swim_process, delta)


func _noop(_delta) -> void:
	pass


func _swim(delta) -> void:
	lifetime += delta
	position += Vector2(Globals.SPEED_MAP[_cur_properties.speed] * 5 * direction, sin(lifetime)) * delta
	
	

