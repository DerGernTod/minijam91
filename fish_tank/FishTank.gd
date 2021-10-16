extends Area2D

export var capacity: int = 5

var _cur_cursor: Cursor = null
var _content = []
var _states = {
	"droppable": StateDroppable.new(),
	"empty": StateEmpty.new(),
	"full": StateFull.new(),
	"none": StateNone.new(),
	"pickable": StateNone.new(),
}
var _cur_state = _states.none

onready var _sprite = $Sprite


func _ready() -> void:
	var states = _states.values();
	for state in states:
		state.setup(_sprite)
	connect("area_entered", self, "area_entered")
	connect("area_exited", self, "area_exited")


func _noop() -> void:
	pass


func _process_full() -> void:
	pass


func _process_empty() -> void:
	pass


func _process_droppable() -> void:
	pass


func _process_pickable() -> void:
	pass


func _physics_process(delta: float) -> void:
	_cur_state.physics_process(delta)


func _enter_state(state: String) -> void:
	_cur_state.leave()
	_states[state].enter()
	_cur_state = _states[state]


func area_entered(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = area
		var cursor_has_content = area.content != null
		var tank_is_empty = _content.size() == 0
		var tank_is_full = _content.size() == capacity
		match [tank_is_full, tank_is_empty, cursor_has_content]:
			[true, _, true]: _enter_state("full")
			[false, _, true]: _enter_state("droppable")
			[_, true, false]: _enter_state("empty")
			[_, false, false]: _enter_state("pickable")


func area_exited(area: Area2D) -> void:
	if area is Cursor:
		_enter_state("none")
		_cur_cursor = null
