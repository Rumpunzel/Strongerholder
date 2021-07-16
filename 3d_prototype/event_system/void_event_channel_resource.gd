class_name VoidEventChannelResource
extends EventChannelBaseResource

signal raised()

func raise_event() -> void:
	if _has_connections(RAISED):
		emit_signal(RAISED)
	else:
		printerr("signal %s on %s not connected to anything, emission skipped" % [ RAISED, resource_name ])
