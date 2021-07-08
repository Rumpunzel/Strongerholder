class_name ItemResource
extends ObjectResource

# warning-ignore-all:unused_class_variable
export(String, FILE, "*.tscn") var _equipped_scene
export(int, 0, 64) var stack_size = 1


func use() -> void:
	# TODO: implement use function
	print("Used %s" % name)


func attach_to(node: Spatial) -> Spatial:
	var loaded_scene := load(_equipped_scene) as PackedScene
	var spawned_node := loaded_scene.instance() as Spatial
	
	node.add_child(spawned_node)
	return spawned_node


func drop_at(position: Vector3, random_rotation := true) -> Spatial:
	var spawned_node := spawn()
	print(spawned_node.name + " spawned")
	Events.gameplay.emit_signal("node_spawned", spawned_node, position, random_rotation)
	return spawned_node



func _to_string() -> String:
	return "%s, Stack Size: %d" % [ ._to_string(), stack_size ]
