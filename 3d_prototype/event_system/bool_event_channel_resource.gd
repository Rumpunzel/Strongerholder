class_name BoolEventChannelResource
extends EventChannelBaseResource

signal raised(boolean)

func raise(boolean: bool) -> void:
	if _has_connections(RAISED):
		emit_signal(RAISED, boolean)
	else:
		printerr("signal %s on %s not connected to anything, emission skipped" % [ RAISED, resource_path ])
