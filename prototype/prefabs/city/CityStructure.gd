class_name CityStructure
extends Spatial


export(NodePath) var structure_node
export(NodePath) var area_node

export var can_be_highlighted: bool = false


onready var structure = get_node(structure_node) setget , get_structure
onready var area = get_node(area_node) setget , get_area



func handle_highlighted(new_material: Material):
	if can_be_highlighted:
		structure.material_override = new_material



func get_structure():
	return structure


func get_area() -> Area:
	return area
