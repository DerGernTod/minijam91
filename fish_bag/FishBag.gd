extends Droppable


func _ready() -> void:
	connect("dropped", self, "_on_Pickable_dropped")
	connect("pulled", self, "_on_Pickable_pulled")
	var instance = SceneContainer.pop_pickable()
	if instance:
		fill_content(instance)
		instance.position = Vector2.ZERO
		instance.can_pick = true
	yield(get_parent(), "ready")
	if instance:
		SceneContainer.push_pickable(instance)

func _on_Pickable_dropped(node: Node) -> void:
	node.get_parent().remove_child(node)
	get_tree().get_root().add_child(node)
	SceneContainer.push_pickable(node)


func _on_Pickable_pulled(node: Node) -> void:
	SceneContainer.remove_pickable(node)
