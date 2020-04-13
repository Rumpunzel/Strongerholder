class_name CityStructure
extends StaticBody


export(Material) var highlight_material

export var object_width: int = 1 setget , get_object_width


onready var structure = $structure setget , get_structure
onready var area = $area setget , get_area



func _enter_tree():
	rotation.y = atan2(transform.origin.x, transform.origin.z)



func handle_highlighted(highlighted: bool):
	if highlighted and highlight_material:
		structure.material_override = highlight_material
	else:
		structure.material_override = null



func get_object_width() -> int:
	return object_width

func get_structure():
	return structure

func get_area() -> Area:
	return area
