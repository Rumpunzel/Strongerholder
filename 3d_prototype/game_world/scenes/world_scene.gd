class_name WorldScene
extends Spatial

func _ready() -> void:
	Events.emit_signal("scene_loaded")
