class_name NodeSpawnedEventChannelResource
extends EventChannelBaseResource

signal raised(node, position, random_rotation)

func raise_event(node: Node, position: Vector3, random_rotation: bool) -> void:
	if _has_connections(RAISED):
		emit_signal(RAISED, node, position, random_rotation)
	else:
		printerr("signal %s on %s not connected to anything, emission skipped" % [ RAISED, resource_name ])
