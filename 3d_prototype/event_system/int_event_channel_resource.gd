class_name IntEventChannelResource
extends EventChannelBaseResource

signal raised(integer)

func raise(integer: int) -> void:
	if _has_connections("raised"):
		emit_signal("raised", integer)
