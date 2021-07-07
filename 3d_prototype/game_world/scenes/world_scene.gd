class_name WorldScene
extends Navigation

func _ready() -> void:
	Events.gameplay.emit_signal("scene_loaded")
