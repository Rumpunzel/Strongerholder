extends ClassProperty


export(PackedScene) var list_item = null




func _ready() -> void:
	for resource in GameClasses.CLASSES[GameClasses._GAME_RESOURCE_SCENE]:
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


func get_value() -> Dictionary:
	var resource_list := { }
	
	for item in property.get_children():
		resource_list[item.get_resource()] = item.get_value()
	
	return resource_list
