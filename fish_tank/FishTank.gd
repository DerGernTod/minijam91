extends Droppable

var _states = {
	"droppable": StateDroppable.new(),
	"empty": StateEmpty.new(),
	"full": StateFull.new(),
	"none": StateNone.new(),
	"pickable": StateNone.new(),
}
var _cur_state = _states.none

onready var _sprite = $Sprite


func area_entered_tank(area: Area2D) -> void:
	if area is Cursor:
		_update_state(area)


func area_exited_tank(area: Area2D) -> void:
	if area is Cursor:
		_enter_state("none")


func cursor_state_changed() -> void:
	_update_state(_cur_cursor)


func _update_state(cursor: Cursor) -> void:
	var cursor_has_content = cursor.has_content
	var tank_is_empty = _content == 0
	var tank_is_full = _content == capacity
	match [tank_is_full, tank_is_empty, cursor_has_content]:
		[true, _, true]: _enter_state("full")
		[false, _, true]: _enter_state("droppable")
		[_, true, false]: _enter_state("empty")
		[_, false, false]: _enter_state("pickable")
	

func _ready() -> void:
	var states = _states.values();
	for state in states:
		state.setup(_sprite)
	connect("area_entered", self, "area_entered_tank")
	connect("area_exited", self, "area_exited_tank")
	connect("dropped", self, "cursor_state_changed")
	connect("pulled", self, "cursor_state_changed")


func _physics_process(delta: float) -> void:
	_cur_state.physics_process(delta)


func _enter_state(state: String) -> void:
	_cur_state.leave()
	_states[state].enter()
	_cur_state = _states[state]
