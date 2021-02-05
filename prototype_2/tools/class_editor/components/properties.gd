class_name ClassProperties
extends GridContainer



func setup(class_constants: Dictionary):
	for child in get_children():
		child.set_value(class_constants.get(child.property_name, null))
		class_constants.erase(child.property_name)
	
	assert(class_constants.empty())


func get_properties() -> Dictionary:
	var props_dict := { }
	
	for child in get_children():
		props_dict[child.property_name] = child.get_value()
	
	return props_dict
