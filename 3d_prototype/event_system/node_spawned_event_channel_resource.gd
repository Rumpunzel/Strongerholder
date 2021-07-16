class_name NodeSpawnedEventChannelResource
extends EventChannelBaseResource

signal raised(node, position, random_rotation)

func raise(node: Node, position: Vector3, random_rotation: bool) -> void:
	if _has_connections("raised"):
		emit_signal("raised", node, position, random_rotation)
