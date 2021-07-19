class_name AudioEventChannelResource
extends EventChannelBaseResource

signal raised(stream)

func raise(stream: AudioStream) -> void:
	if _has_connections("raised"):
		emit_signal("raised", stream)
