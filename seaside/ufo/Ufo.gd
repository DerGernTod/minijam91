extends Pickable

var slot_index = -1
var lifetime = 0

onready var fish_slots = [
	$FishSlot,
	$FishSlot2,
	$FishSlot3,
]


func _ready() -> void:
	connect("area_entered", self, "_on_ufo_area_entered")
	slot_index = 0
	for pickable in SceneContainer.get_pickables():
		print("got pickable %s" % pickable.name)
		fish_slots[slot_index].add_child(pickable)
		pickable.position = Vector2.ZERO
		pickable.can_pick = false
		slot_index += 1


func _physics_process(delta: float) -> void:
	lifetime += delta
	if not _is_picked():
		position.y += sin(lifetime) * delta


func _on_ufo_area_entered(area: Area2D) -> void:
	if area.get_groups().has("SwimFish") and slot_index < fish_slots.size() and not area.is_collected:
		area.collect()
		area.get_parent().remove_child(area)
		fish_slots[slot_index].call_deferred("add_child", area)
		area.position = Vector2.ZERO
		slot_index += 1
		SceneContainer.push_pickable(area)
