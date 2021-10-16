extends Sprite

onready var Egg = preload("res://egg/Egg.tscn")
onready var _cur_egg = $Egg;


func _ready() -> void:
	_connect_cur_egg()


func _connect_cur_egg() -> void:
	_cur_egg.connect("dropped", self, "_on_egg_dropped")


func _on_egg_dropped(_parent: Area2D) -> void:
	_cur_egg.disconnect("dropped", self, "_on_egg_dropped")
	_cur_egg = Egg.instance()
	add_child(_cur_egg)
	_cur_egg.position = Vector2.ZERO
	_connect_cur_egg()
