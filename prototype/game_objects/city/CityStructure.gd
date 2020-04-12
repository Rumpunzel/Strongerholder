class_name CityStructure
extends Spatial

export var can_be_highlighted: bool = false

export var object_width: int = 1 setget , get_object_width


onready var structure = $structure setget , get_structure
onready var area = $area setget , get_area



func handle_highlighted(new_material: Material):
	if can_be_highlighted:
		structure.material_override = new_material



func get_object_width() -> int:
	return object_width

func get_structure():
	return structure

func get_area() -> Area:
	return area
