extends ClassItemProperties



func setup(class_constants: Dictionary):
	for child in get_children():
		child.set_value(class_constants[child.property_name])
		class_constants.erase(child.property_name)
	
	.setup(class_constants)
