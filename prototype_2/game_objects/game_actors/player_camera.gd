class_name PlayerCamera
extends Camera2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true
const PERSIST_PROPERTIES := [ "name", "current", "zoom", "smoothing_enabled", "smoothing_speed" ]




func _ready() -> void:
	current = true
	zoom = Vector2(0.5, 0.5)
