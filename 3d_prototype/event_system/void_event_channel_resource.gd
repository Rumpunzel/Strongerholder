class_name VoidEventChannelResource
extends EventChannelBaseResource

signal raised()

func raise() -> void:
	if _has_connections(RAISED):
		emit_signal(RAISED)
	else:
		printerr("signal %s on %s not connected to anything, emission skipped" % [ RAISED, resource_path ])
