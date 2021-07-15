class_name GroundCheck
extends Spatial


func set_shape(new_shape: BoxShape) -> void:
	# warning-ignore-all:unsafe_property_access
	$pXnZ.translation = Vector3(new_shape.extents.x, 0.0, -new_shape.extents.z)
	# warning-ignore-all:unsafe_property_access
	$pXpZ.translation = Vector3(new_shape.extents.x, 0.0, new_shape.extents.z)
	# warning-ignore-all:unsafe_property_access
	$nXpZ.translation = Vector3(-new_shape.extents.x, 0.0, new_shape.extents.z)
	# warning-ignore-all:unsafe_property_access
	$nXnZ.translation = Vector3(-new_shape.extents.x, 0.0, -new_shape.extents.z)

func is_valid() -> bool:
	for child in get_children():
		if not child.is_colliding():
			return false
	
	return true
