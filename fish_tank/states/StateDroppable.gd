extends FishTankState
class_name StateDroppable


func enter():
	self._sprite.modulate = Color.green


func leave():
	self._sprite.modulate = Color.white


func physics_process(_delta: float) -> void:
	pass
