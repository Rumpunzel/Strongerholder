class_name Navigator, "res://class_icons/city_management/icon_navigator.svg"
extends Navigation2D



func _enter_tree() -> void:
	ServiceLocator.register_as_navigator(self)


func _exit_tree() -> void:
	ServiceLocator.unregister_as_navigator(self)




#func nearest_in_group(start_position: Vector2, group_name, groups_to_exclude: Array = [ ], objects_to_exclude: Array = [ ]) -> Node2D:
#	if Constants.is_structure(group_name) or Constants.is_thing(group_name):
#		group_name = Constants.enum_name(Constants.Structures, group_name)
#	elif Constants.is_resource(group_name):
#		group_name = Constants.enum_name(Constants.Resources, group_name)
#
#	var group: Array = get_tree().get_nodes_in_group(group_name)
#
#	return nearest_from_array(start_position, group, groups_to_exclude, objects_to_exclude)



func nearest_from_array(start_position: Vector2, group: Array, groups_to_exclude: Array = [ ], objects_to_exclude: Array = [ ]) -> Node2D:
	var nearest_object: Node2D = null
	var shortest_distance: float = INF
	
	# Check that the potential target's type is actually requested
	for object in group:
		if not object.is_active() or objects_to_exclude.has(object):
			continue
		
		var valid_object: bool = true
		var object_groups: Array = object.get_groups()
		
		for ex_group in groups_to_exclude:
			if object_groups.has(ex_group):
				valid_object = false
				break
		
		if not valid_object:
			continue
		
		# Check if the potential target is the nearest one
		var simple_path: PoolVector2Array = get_simple_path(start_position, object.global_position)
		var distance_to_body: float = 0.0
		var path_index: int = 0
		
		while path_index < simple_path.size() - 1:
			distance_to_body += simple_path[path_index].distance_to(simple_path[path_index + 1])
			path_index += 1
		
		if distance_to_body < shortest_distance:
			shortest_distance = distance_to_body
			nearest_object = object
	
	return nearest_object
