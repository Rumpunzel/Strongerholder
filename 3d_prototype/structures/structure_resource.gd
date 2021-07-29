class_name StructureResource, "res://editor_tools/class_icons/resources/icon_stone_tower.svg"
extends ObjectResource

# warning-ignore:unused_class_variable
export(PackedScene) var model: PackedScene
# warning-ignore:unused_class_variable
export(BoxShape) var shape: BoxShape

export(Resource) var _building_placed_channel


func place_at(position: Vector3, y_rotation := 0.0) -> Spatial:
	var spawned_node := spawn()
	print(spawned_node.name + " placed")
	_building_placed_channel.raise(spawned_node, position, y_rotation)
	
	return spawned_node
