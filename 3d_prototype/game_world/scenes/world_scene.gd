class_name WorldScene, "res://editor_tools/class_icons/spatials/icon_treasure_map.svg"
extends Navigation

var _world_grid: WorldGrid


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.gameplay.connect("node_spawned", self, "_on_node_spawned")
	# warning-ignore:return_value_discarded
	Events.gameplay.connect("building_placed", self, "_on_building_placed")
	
	_world_grid = $NavigationMeshInstance/WorldGrid

func _exit_tree() -> void:
	Events.gameplay.disconnect("node_spawned", self, "_on_node_spawned")
	Events.gameplay.disconnect("building_placed", self, "_on_building_placed")
	
	Events.gameplay.emit_signal("scene_unloaded", self)



func _on_node_spawned(node: Spatial, position: Vector3, random_rotation: bool) -> void:
	add_child(node, true)
	node.translation = position
	
	if random_rotation:
		node.rotate_x(randf() * TAU)
		node.rotate_y(randf() * TAU)
		node.rotate_z(randf() * TAU)


func _on_building_placed(structure: Structure, position: Vector3, y_rotation: float) -> void:
	_world_grid.add_child(structure, true)
	structure.translation = position
	structure.rotate_y(y_rotation)
