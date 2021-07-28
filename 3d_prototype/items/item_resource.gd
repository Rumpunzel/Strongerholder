class_name ItemResource, "res://editor_tools/class_icons/resources/icon_fire_bottle.svg"
extends ObjectResource

# warning-ignore-all:unused_class_variable
export(int, 0, 63) var stack_size = 1

export(String, FILE, "*.tscn") var _equipped_scene
export(String, FILE, "*.tscn") var _stockpiled_scene

export(Resource) var stockpile_stack_attributes

export(Resource) var _node_spawned_channel


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
	_node_spawned_channel.raise(spawned_node, position, random_rotation)
	
	return spawned_node



func _to_string() -> String:
	return "%s, Stack Size: %d" % [ ._to_string(), stack_size ]
