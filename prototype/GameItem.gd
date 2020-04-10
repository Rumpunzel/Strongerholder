class_name GameItem
extends Resource


var type: int setget set_type, get_type



func _init(new_type: int):
	set_type(new_type)



func set_type(new_type: int):
	type = new_type


func get_type() -> int:
	return type
