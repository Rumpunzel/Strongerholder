class_name GameWorld, "res://editor_tools/class_icons/nodes/icon_world.svg"
extends Node

export(Resource) var _scene_loaded_channel
export(Resource) var _scene_atmosphere_started_channel

var _scene_atmosphere: SceneAtmosphere


func _enter_tree() -> void:
	_scene_atmosphere = $SceneAtmosphere
	
	# warning-ignore:return_value_discarded
	_scene_loaded_channel.connect("raised", self, "_on_scene_loaded")
	# warning-ignore:return_value_discarded
	_scene_atmosphere_started_channel.connect("raised", self, "_on_scene_atmosphere_started")

func _exit_tree() -> void:
	_scene_loaded_channel.disconnect("raised", self, "_on_scene_loaded")
	_scene_atmosphere_started_channel.disconnect("raised", self, "_on_scene_atmosphere_started")


func _on_scene_loaded(scene: WorldScene) -> void:
	add_child(scene)


func _on_scene_atmosphere_started(stream: AudioStream) -> void:
	assert(stream)
	yield(get_tree(), "idle_frame")
	_scene_atmosphere.play_atmosphere(stream)
