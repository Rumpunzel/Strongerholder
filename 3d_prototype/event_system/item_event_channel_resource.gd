class_name ItemEventChannelResource
extends EventChannelBaseResource

signal raised(item)

func raise(item: ItemResource) -> void:
	if _has_connections("raised"):
		emit_signal("raised", item)
