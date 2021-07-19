class_name SFXLayer
extends Node

export(Resource) var _sfx_emitted_channel


func _enter_tree() -> void:
	_sfx_emitted_channel.connect("raised", self, "_on_sfx_emitted")

func _exit_tree() -> void:
	_sfx_emitted_channel.disconnect("raised", self, "_on_sfx_emitted")


func _on_sfx_emitted(audio_player: RandomAudioPlayer, position: Vector3) -> void:
	add_child(audio_player)
	audio_player.translation = position
	audio_player.play_random()
