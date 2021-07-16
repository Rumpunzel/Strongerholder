class_name GameWorld, "res://editor_tools/class_icons/nodes/icon_world.svg"
extends Node

export(Resource) var _scene_loaded_channel


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_scene_loaded_channel.connect("raised", self, "_on_scene_loaded")

func _exit_tree() -> void:
	_scene_loaded_channel.disconnect("raised", self, "_on_scene_loaded")


func _on_scene_loaded(scene: WorldScene) -> void:
	add_child(scene)
