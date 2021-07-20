class_name ReferenceEventChannelResource
extends EventChannelBaseResource

signal raised(reference)

func raise(reference: Reference) -> void:
	if _has_connections("raised"):
		emit_signal("raised", reference)
