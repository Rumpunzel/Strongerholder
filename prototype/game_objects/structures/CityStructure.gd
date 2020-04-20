class_name CityStructure, "res://assets/icons/structures/icon_city_structure.svg"
extends GameObject


signal activate


var type: int setget set_type, get_type




func _ready():
	pass

func _setup(new_ring_vector: RingVector):
	._setup(new_ring_vector)
	activate_structure()




func activate_structure():
	emit_signal("activate")




func set_type(new_type: int):
	$hit_box.type = new_type
	type = new_type



func is_blocked() -> bool:
	return $hit_box.is_blocked()

func get_type() -> int:
	return $hit_box.type
