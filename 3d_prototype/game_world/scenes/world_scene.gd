class_name WorldScene
extends Navigation

func _ready() -> void:
	Events.emit_signal("scene_loaded")
