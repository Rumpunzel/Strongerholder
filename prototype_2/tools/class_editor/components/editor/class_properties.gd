class_name ClassProperties
extends HBoxContainer



func setup(class_constants: Dictionary):
	class_constants = _setup_node(self, class_constants)
	
	assert(class_constants.empty())


func get_properties() -> Dictionary:
	var props_dict := { }
	
	_get_properties_from_node(self, props_dict)
	
	return props_dict



func _setup_node(node: Control, class_constants: Dictionary) -> Dictionary:
	for child in node.get_children():
		if child is GridContainer or child is HBoxContainer or child is VBoxContainer:
			class_constants = _setup_node(child, class_constants)
		else:
			var property_name: String = child.property_name
			assert(not property_name == "prop_name")
			
			child.set_value(class_constants.get(property_name, null))
			class_constants.erase(property_name)
	
	return class_constants


func _get_properties_from_node(node: Control, props_dict: Dictionary) -> Dictionary:
	for child in node.get_children():
		if child is GridContainer or child is HBoxContainer or child is VBoxContainer:
			props_dict = _get_properties_from_node(child, props_dict)
		else:
			props_dict[child.property_name] = child.get_value()
	
	return props_dict
