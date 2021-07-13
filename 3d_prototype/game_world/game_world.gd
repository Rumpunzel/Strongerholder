class_name GameWorld
extends Node


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.gameplay.connect("scene_loaded", self, "_on_scene_loaded")

func _exit_tree() -> void:
	Events.gameplay.disconnect("scene_loaded", self, "_on_scene_loaded")


func _on_scene_loaded(scene: WorldScene) -> void:
	add_child(scene)
