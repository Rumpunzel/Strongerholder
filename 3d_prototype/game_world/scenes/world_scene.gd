class_name WorldScene, "res://editor_tools/class_icons/spatials/icon_treasure_map.svg"
extends Navigation

export(Resource) var _node_spawned_channel
export(Resource) var _building_placed_channel
export(Resource) var _scene_unloaded_channel


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_node_spawned_channel.connect("raised", self, "_on_node_spawned")
	# warning-ignore:return_value_discarded
	_building_placed_channel.connect("raised", self, "_on_building_placed")

func _exit_tree() -> void:
	_node_spawned_channel.disconnect("raised", self, "_on_node_spawned")
	_building_placed_channel.disconnect("raised", self, "_on_building_placed")
	
	_scene_unloaded_channel.raise(self)



func _on_node_spawned(node: Spatial, position: Vector3, random_rotation: bool) -> void:
	add_child(node, true)
	node.translation = position
	
	if random_rotation:
		node.rotate_x(randf() * TAU)
		node.rotate_y(randf() * TAU)
		node.rotate_z(randf() * TAU)


func _on_building_placed(structure: Structure, position: Vector3, y_rotation: float) -> void:
	add_child(structure, true)
	structure.translation = position
	structure.rotate_y(y_rotation)
