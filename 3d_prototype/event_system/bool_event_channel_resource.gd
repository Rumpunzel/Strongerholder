class_name BoolEventChannelResource
extends EventChannelBaseResource

signal raised(boolean)

func raise(boolean: bool) -> void:
	if _has_connections("raised"):
		emit_signal("raised", boolean)
