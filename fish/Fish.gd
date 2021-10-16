extends Pickable
class_name Fish

func _ready() -> void:
	connect("dropped", self, "_on_dropped")


func _on_dropped(droppable: Area2D) -> void:
	print("%s dropped into %s" % [name, droppable.name])
