class_name BuildingPlacedEventChannelResource
extends EventChannelBaseResource

signal raised(structure, position, y_rotation)

func raise_event(node: Node, position: Vector3, y_rotation: float) -> void:
	if _has_connections(RAISED):
		emit_signal(RAISED, node, position, y_rotation)
	else:
		printerr("signal %s on %s not connected to anything, emission skipped" % [ RAISED, resource_name ])
