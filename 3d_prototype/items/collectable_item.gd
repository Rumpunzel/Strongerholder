class_name CollectableItem
extends RigidBody

export(Resource) var item_resource


func disable_collision(with_handle_offsetue) -> void:
	mode = RigidBody.MODE_KINEMATIC
	($CollisionShape as CollisionShape).disabled = true
	
	if with_handle_offsetue:
		translation = -($HandlePosition as Spatial).translation


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not item_resource:
		warning = "ItemResource is required"
	elif not item_resource is ItemResource:
		warning = "ItemResource is of the wrong type"
	
	return warning
