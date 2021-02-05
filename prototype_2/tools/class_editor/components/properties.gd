class_name ClassItemProperties
extends GridContainer



func setup(class_constants: Dictionary):
	assert(class_constants.empty())


func get_properties() -> Dictionary:
	var props_dict := { }
	
	for child in get_children():
		props_dict[child.property_name] = child.get_value()
	
	return props_dict
