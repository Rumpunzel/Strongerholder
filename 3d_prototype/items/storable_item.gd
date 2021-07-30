class_name StorableItem, "res://editor_tools/class_icons/spatials/icon_wood_beam.svg"
extends Spatial
tool

export(Resource) var item_resource


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not item_resource:
		warning = "ItemResource is required"
	elif not item_resource is ItemResource:
		warning = "ItemResource is of the wrong type"
	
	return warning
