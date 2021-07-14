class_name WorldScene, "res://editor_tools/class_icons/spatials/icon_treasure_map.svg"
extends Navigation


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.gameplay.connect("node_spawned", self, "_on_node_spawned")

func _exit_tree() -> void:
	Events.gameplay.disconnect("node_spawned", self, "_on_node_spawned")
	Events.gameplay.emit_signal("scene_unloaded", self)



func _on_node_spawned(node: Spatial, position: Vector3, random_rotation: bool) -> void:
	add_child(node, true)
	node.translation = position
	
	if random_rotation:
		node.rotate_x(randf() * TAU)
		node.rotate_y(randf() * TAU)
		node.rotate_z(randf() * TAU)
