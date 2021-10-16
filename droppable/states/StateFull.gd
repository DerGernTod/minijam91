extends DroppableState
class_name StateFull


func enter():
	self._sprite.modulate = Color.red


func leave():
	self._sprite.modulate = Color.white


func physics_process(_delta: float) -> void:
	pass
