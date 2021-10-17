extends Area2D
class_name Droppable

signal dropped
signal pulled

export var capacity: int = 1

var _states = {
	"droppable": StateDroppable.new(),
	"full": StateFull.new(),
	"none": StateNone.new(),
}
var _cur_state = _states.none
var can_drop = false setget , _get_can_drop
var _content = []
var _cur_cursor: Cursor = null
var _pickable_hovering = false

onready var _sprite = $Sprite


func area_entered(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = area 


func area_exited(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = null


func pickable_entered() -> void:
	_pickable_hovering = true
	update_state()


func pickable_left() -> void:
	_pickable_hovering = false
	update_state()


func fill_content(instance: Pickable) -> void:
	if instance.is_inside_tree():
		instance.get_parent().remove_child(instance)
	get_tree().get_root().call_deferred("add_child", instance)
	instance.position = position
	instance._parent_droppable = self
	_content.push_back(instance)


func drop_pickable(pickable: Area2D) -> bool:
	_pickable_hovering = false
	if not _get_can_drop():
		return false
	_content.push_back(pickable)
	update_state()
	emit_signal("dropped", pickable)
	return true


func pull_pickable(pickable: Area2D) -> bool:
	if not _content.has(pickable):
		return false
	_pickable_hovering = true
	_content.erase(pickable)
	update_state()
	emit_signal("pulled", pickable)
	return true


func update_state() -> void:
	match [_get_can_drop(), _pickable_hovering]:
		[false, true]: _enter_state("full")
		[true, true]: _enter_state("droppable")
		[..]: _enter_state("none")


func _ready() -> void:
	connect("area_entered", self, "area_entered")
	connect("area_exited", self, "area_exited")
	var states = _states.values();
	for state in states:
		state.setup(_sprite)



func _get_can_drop() -> bool:
	return _content.size() < capacity or capacity == -1


func _enter_state(state: String) -> void:
	print("switching %s to state %s" % [name, state])
	_cur_state.leave()
	_states[state].enter()
	_cur_state = _states[state]
	

func _physics_process(delta: float) -> void:
	_cur_state.physics_process(delta)
