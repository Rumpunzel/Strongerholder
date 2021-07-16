class_name NodeEventChannelResource
extends EventChannelBaseResource

signal raised(node)

func raise_event(node: Node) -> void:
	if _has_connections(RAISED):
		emit_signal(RAISED, node)
	else:
		printerr("signal %s on %s not connected to anything, emission skipped" % [ RAISED, resource_name ])
