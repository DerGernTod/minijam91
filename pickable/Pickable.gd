extends Area2D
class_name Pickable

signal picked
signal dropped
signal discarded
signal hover_start
signal hover_end

export(String) var pickable_name

var _cur_cursor: Cursor = null
var _cur_droppables = []
var _cur_process = "_noop"
var _parent_droppable = null
var is_picked: bool = false setget _set_picked, _is_picked
var can_pick: bool = true setget _set_pickable, _can_pick
var offset: Vector2 = Vector2.ZERO

onready var _init_pos = position


func area_entered(area: Area2D) -> void:
	if not _can_pick():
		return
	if area is Cursor:
		_cur_cursor = area
		_cur_cursor.add_hover(self)
		emit_signal("hover_start")
		_cur_process = "_check_pick"
	if area is Droppable:
		if _cur_droppables.size() > 0:
			_cur_droppables.back().pickable_left()
		_cur_droppables.push_back(area)
		if _is_picked():
			area.pickable_entered()


func area_exited(area: Area2D) -> void:
	if not _can_pick():
		return
	if area is Cursor:
		_cur_cursor.remove_hover(self)
		emit_signal("hover_end")
		_cur_cursor = null
		_cur_process = "_noop"
		_reset_color()
	if area is Droppable:
		_cur_droppables.erase(area)
		area.pickable_left()
		if _is_picked() and _cur_droppables.size() > 0:
			_cur_droppables.back().pickable_entered()


func _reset_color() -> void:
	modulate = Color.white


func _highlight_color() -> void:
	modulate = Color.cyan


func _ready() -> void:
	connect("area_entered", self, "area_entered")
	connect("area_exited", self, "area_exited")


func _noop(_delta: float) -> void:
	pass


func _check_pick(_delta: float) -> void:
	if _cur_cursor.is_active_hover(self) and not _cur_cursor.has_content:
		_highlight_color()
	else:
		_reset_color()
	if Input.is_action_just_pressed("left_mouse")\
			and not _cur_cursor.has_content\
			and _cur_cursor.is_active_hover(self):
		offset = position - _cur_cursor.position
		_set_picked(true)
		_cur_process = "_follow_cursor"
		_cur_cursor.has_content = true
		_reset_color()
		if _parent_droppable:
			_parent_droppable.pull_pickable(self)
		
		emit_signal("picked")


func _follow_cursor(_delta: float) -> void:
	position = offset + _cur_cursor.position
	if Input.is_action_just_released("left_mouse"):
		_set_picked(false)
		_cur_process = "_check_pick"
		_cur_cursor.has_content = false
		var droppable = null
		if _cur_droppables.size() > 0:
			droppable = _cur_droppables.back()
			
		if droppable and droppable.can_drop and droppable.drop_pickable(self):
			_parent_droppable = droppable
			_init_pos = position
			emit_signal("dropped", _parent_droppable)
		else:
			position = _init_pos
			if _parent_droppable:
				_parent_droppable.drop_pickable(self)
			for dp in _cur_droppables:
				dp.update_state()
			emit_signal("discarded")


func _physics_process(delta: float) -> void:
	call(_cur_process, delta)


func _set_picked(picked: bool) -> void:
	is_picked = picked


func _is_picked() -> bool:
	return is_picked


func _set_pickable(pickable: bool) -> void:
	can_pick = pickable


func _can_pick() -> bool:
	return can_pick
