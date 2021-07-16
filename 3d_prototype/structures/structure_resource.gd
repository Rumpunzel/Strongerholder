class_name StructureResource
extends ObjectResource

export(PackedScene) var model: PackedScene
export(BoxShape) var shape: BoxShape = preload("res://structures/resources/dimensions/1_1_1_dimension.tres")

export(Resource) var _building_placed_channel


func place_at(position: Vector3, y_rotation := 0.0) -> Spatial:
	var spawned_node := spawn()
	print(spawned_node.name + " placed")
	_building_placed_channel.raise(spawned_node, position, y_rotation)
	
	return spawned_node
