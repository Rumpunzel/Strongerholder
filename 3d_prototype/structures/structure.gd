class_name Structure
extends StaticBody
tool

export var _mesh_index := 0 setget _set_index


func _set_index(new_index: int) -> void:
	_mesh_index = new_index
	($Mesh as ArrayMeshInstance).set_index(_mesh_index)
