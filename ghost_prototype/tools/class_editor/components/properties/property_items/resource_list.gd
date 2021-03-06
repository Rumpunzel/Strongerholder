extends ClassProperty

# warning-ignore-all:unsafe_property_access

export(PackedScene) var list_item = null




func _ready() -> void:
	update_list()




func update_list() -> void:
	var lookup_file: GDScript = load("res://game_objects/game_classes.gd")
	var resources_to_list: Array = lookup_file.CLASSES.get(lookup_file.GAME_RESOURCE_SCENE, [ ]) + lookup_file.CLASSES.get(lookup_file.SPYGLASS_SCENE, [ ]) + lookup_file.CLASSES.get(lookup_file.CRAFT_TOOL_SCENE, [ ])
	
	for resource in resources_to_list:
		var new_item = list_item.instance()
		
		property.add_child(new_item)
		new_item.set_resource(resource)


func set_value(resource_list) -> void:
	if not resource_list:
		return
	
	for resource in resource_list.keys():
		var value = resource_list[resource]
		var resource_item = property.get_node_or_null(resource)
		
		if resource_item:
			resource_item.set_value(value)


func set_all_values_to(new_value) -> void:
	for resource_item in property.get_children():
		resource_item.set_value(new_value)


func get_value() -> Dictionary:
	var resource_list := { }
	
	for item in property.get_children():
		resource_list[item.get_resource()] = item.get_value()
	
	return resource_list
