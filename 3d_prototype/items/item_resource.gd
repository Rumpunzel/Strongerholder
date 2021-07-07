class_name ItemResource
extends ObjectResource

# warning-ignore-all:unused_class_variable
export(String, FILE, "*.tscn") var _equipped_scene
export(int, 0, 64) var stack_size = 1


func attach_to(node: Spatial) -> Spatial:
	var loaded_scene := load(_equipped_scene) as PackedScene
	var spawned_node := loaded_scene.instance() as Spatial
	
	node.add_child(spawned_node)
	return spawned_node


func drop_at(position: Vector3) -> void:
	var spawned_node := spawn()
	# TODO: actually add the item to the scene tree



func _to_string() -> String:
	return "%s, Stack Size: %d" % [ ._to_string(), stack_size ]
