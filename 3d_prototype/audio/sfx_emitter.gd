class_name SFXEmitter
extends Spatial

export(PackedScene) var _sound_scene
export(Resource) var _sfx_emitted_channel

func emit() -> void:
	_sfx_emitted_channel.raise(_sound_scene.instance(), global_transform.origin)
