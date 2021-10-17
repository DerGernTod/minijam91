extends Pickable

onready var _init_radius = $CollisionShape2D.shape.radius
onready var _col_shape = CircleShape2D.new()


func _ready() -> void:
	_col_shape.radius = _init_radius
	$CollisionShape2D.shape = _col_shape
	connect("picked", self, "_on_egg_picked")
	connect("dropped", self, "_on_egg_dropped")
	connect("discarded", self, "_on_egg_discarded")


func _on_egg_picked() -> void:
	_col_shape.radius = 4


func _on_egg_discarded() -> void:
	_col_shape.radius = _init_radius


func _on_egg_dropped(_droppable: Area2D) -> void:
	disconnect("dropped", self, "_on_egg_dropped")
	disconnect("picked", self, "_on_egg_picked")
	disconnect("discarded", self, "_on_egg_discarded")
