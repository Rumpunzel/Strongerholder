class_name BuildHUDItem
extends RadialMenuItem

var structure_resource: StructureResource setget _set_structure_resource


func _set_structure_resource(new_structure: StructureResource) -> void:
	structure_resource = new_structure
	
	if structure_resource:
		# WAITFORUPDATE: remove this unnecessary thing after 4.0
		# warning-ignore:unsafe_property_access
		set_texture(structure_resource.icon)
	else:
		set_texture(null)

