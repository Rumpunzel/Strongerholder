class_name ArrayMeshInstance
extends MeshInstance
tool

export(Array, Mesh) var meshes := [ ]


func set_index(index: int) -> void:
	if not meshes.empty() and index >= 0 and index < meshes.size():
		mesh = meshes[index]
