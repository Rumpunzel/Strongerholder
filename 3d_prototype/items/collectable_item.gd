class_name CollectableItem, "res://editor_tools/class_icons/spatials/icon_fire_bottle.svg"
extends RigidBody
tool

export(Resource) var item_resource

# warning-ignore:unused_class_variable
var _called_dibs_by: Node = null


func call_dibs(dibs: Node, dibbing: bool) -> void:
	_called_dibs_by = dibs if dibbing else null

func is_dibbable(dibs: Node) -> bool:
	return _called_dibs_by == null or _called_dibs_by == dibs


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
