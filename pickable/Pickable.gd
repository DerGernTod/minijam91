extends Area2D
class_name Pickable

signal picked
signal dropped
signal discarded

var _cur_cursor: Cursor = null
var _cur_droppable: Droppable = null
var _cur_process = "_noop"
var is_picked: bool = false setget _set_picked, _is_picked
var can_pick: bool = true setget _set_pickable, _can_pick
var offset: Vector2 = Vector2.ZERO

onready var _init_pos = position


func area_entered(area: Area2D) -> void:
	if area is Cursor and not area.has_content:
		_cur_cursor = area
		if can_pick:
			_cur_process = "_check_pick"
			_highlight_color()
	if area is Droppable and area.can_drop:
		_cur_droppable = area


func area_exited(area: Area2D) -> void:
	if area is Cursor:
		_cur_cursor = null
		_reset_color()
	if area is Droppable:
		_cur_droppable = null


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
	if Input.is_action_just_pressed("left_mouse"):
		offset = position - _cur_cursor.position
		is_picked = true
		_cur_process = "_follow_cursor"
		_cur_cursor.has_content = true
		_reset_color()
		if _cur_droppable:
			_cur_droppable.pickable_pulled()
		emit_signal("picked")


func _follow_cursor(_delta: float) -> void:
	position = offset + _cur_cursor.position
	if Input.is_action_just_released("left_mouse"):
		is_picked = false
		_cur_process = "_check_pick"
		_cur_cursor.has_content = false
		if _cur_droppable:
			_init_pos = position
			_cur_droppable.pickable_dropped()
			emit_signal("dropped")
		else:
			position = _init_pos
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
