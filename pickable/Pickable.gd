extends Area2D
class_name Pickable

signal picked
signal dropped
signal discarded
signal hover_start
signal hover_end

export(String) var pickable_name
export(bool) var can_pick = true

var _cur_cursor: Cursor = null
var _cur_droppables = []
var _cur_process = "_noop"
var _parent_droppable = null
var _old_parent = null
var is_picked: bool = false setget _set_picked, _is_picked
var offset: Vector2 = Vector2.ZERO

onready var _init_pos = global_position


func area_entered(area: Area2D) -> void:
	if not can_pick:
		return
	if area is Cursor and not _is_picked():
		_cur_cursor = area
		_cur_cursor.add_hover(self)
		emit_signal("hover_start")
		_cur_process = "_check_pick"
	if area.get_groups().has("droppables"):
		if _cur_droppables.size() > 0:
			_cur_droppables.back().pickable_left()
		_cur_droppables.push_back(area)
		if _is_picked():
			area.pickable_entered()


func area_exited(area: Area2D) -> void:
	if not can_pick:
		return
	if area is Cursor and not _is_picked():
		_cur_cursor.remove_hover(self)
		emit_signal("hover_end")
		_cur_cursor = null
		_cur_process = "_noop"
		_reset_color()
	if area.get_groups().has("droppables"):
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
		offset = global_position - _cur_cursor.global_position
		var tree_root = get_tree().get_root()
		_set_picked(true)
		_cur_process = "_follow_cursor"
		_cur_cursor.has_content = true
		_reset_color()
		if _parent_droppable:
			_parent_droppable.pull_pickable(self)
		_old_parent = get_parent()
		_init_pos = global_position
		_old_parent.remove_child(self)
		tree_root.add_child(self)
		global_position = _init_pos
		print("setting init_pos in checkpick to %s for %s" % [global_position, name])
		emit_signal("picked")


func _follow_cursor(_delta: float) -> void:
	global_position = offset + _cur_cursor.position
	if Input.is_action_just_released("left_mouse"):
		_set_picked(false)
		_cur_process = "_check_pick"
		_cur_cursor.has_content = false
		var droppable = null
		if _cur_droppables.size() > 0:
			droppable = _cur_droppables.back()
			
		if droppable and droppable.can_drop and droppable.drop_pickable(self):
			_parent_droppable = droppable
			_init_pos = global_position
			print("setting init_pos in follow cursor to %s for %s" % [global_position, name])
			get_parent().remove_child(self)
			_parent_droppable.pickables_container.add_child(self)
			global_position = _init_pos
			emit_signal("dropped", _parent_droppable)
		else:
			if _parent_droppable:
				_parent_droppable.drop_pickable(self)
				get_parent().remove_child(self)
				_parent_droppable.pickables_container.add_child(self)
			else:
				get_parent().remove_child(self)
				_old_parent.add_child(self)
			for dp in _cur_droppables:
				dp.update_state()
			global_position = _init_pos
			emit_signal("discarded")


func _physics_process(delta: float) -> void:
	call(_cur_process, delta)


func _set_picked(picked: bool) -> void:
	is_picked = picked


func _is_picked() -> bool:
	return is_picked
