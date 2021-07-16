class_name VoidEventChannelResource
extends EventChannelBaseResource

signal raised()

func raise() -> void:
	if _has_connections("raised"):
		emit_signal("raised")
