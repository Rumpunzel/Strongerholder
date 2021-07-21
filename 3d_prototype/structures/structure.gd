class_name Structure, "res://editor_tools/class_icons/spatials/icon_stone_tower.svg"
extends StaticBody
tool

# warning-ignore:unused_class_variable
export(Resource) var structure_resource

export var _mesh_index := 0 setget _set_index


func save_to_var(save_file: File) -> void:
	save_file.store_var(transform)

func load_from_var(save_file: File) -> void:
	transform = save_file.get_var()


func _set_index(new_index: int) -> void:
	_mesh_index = new_index
#	var mesh := $Mesh as ArrayMeshInstance
#	if mesh:
#		mesh.set_index(_mesh_index)
