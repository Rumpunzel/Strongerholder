class_name CollectableItem, "res://editor_tools/class_icons/spatials/icon_fire_bottle.svg"
extends RigidBody
tool

export(Resource) var item_resource

# warning-ignore:unused_class_variable
var called_dibs_by: Node = null setget call_dibs


func call_dibs(dibs: Node) -> void:
	called_dibs_by = dibs


func save_to_var(save_file: File) -> void:
	save_file.store_var(transform)
	save_file.store_var(linear_velocity)

func load_from_var(save_file: File) -> void:
	transform = save_file.get_var()
	linear_velocity = save_file.get_var()


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not item_resource:
		warning = "ItemResource is required"
	elif not item_resource is ItemResource:
		warning = "ItemResource is of the wrong type"
	
	return warning
