class_name SFXEventChannelResource
extends EventChannelBaseResource

signal raised(audio_player, position)

func raise(audio_player: RandomAudioPlayer, position: Vector3) -> void:
	if _has_connections("raised"):
		emit_signal("raised", audio_player, position)
