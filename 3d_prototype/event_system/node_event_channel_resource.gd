class_name NodeEventChannelResource
extends EventChannelBaseResource

signal raised(node)

func raise(node: Node) -> void:
	if _has_connections("raised"):
		emit_signal("raised", node)
