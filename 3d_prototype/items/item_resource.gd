class_name ItemResource
extends ObjectResource

# warning-ignore-all:unused_class_variable
export(int, 0, 64) var stack_size = 1


func attach_to(node: Spatial) -> Spatial:
	var handle := Spatial.new()
	var spawned_node := spawn()
	
	handle.add_child(spawned_node)
	spawned_node.disable_collision(true)
	node.add_child(handle)
	
	return handle


func drop_at(position: Vector3) -> void:
	var spawned_node := spawn()
	# TODO: actually add the item to the scene tree



func _to_string() -> String:
	return "%s, Stack Size: %d" % [ ._to_string(), stack_size ]
