extends Droppable


func _ready() -> void:
	connect("dropped", self, "_on_pickable_dropped")


func _on_pickable_dropped(_pickable: Area2D) -> void:
	pass
