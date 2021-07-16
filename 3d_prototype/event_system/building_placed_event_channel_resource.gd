class_name BuildingPlacedEventChannelResource
extends EventChannelBaseResource

signal raised(structure, position, y_rotation)

func raise(node: Node, position: Vector3, y_rotation: float) -> void:
	if _has_connections("raised"):
		emit_signal("raised", node, position, y_rotation)
