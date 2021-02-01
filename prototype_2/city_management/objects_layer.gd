class_name ObjectsLayer, "res://class_icons/game_objects/icon_objects_layer.svg"
extends YSort


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false

const PERSIST_PROPERTIES := ["name"]




func _enter_tree() -> void:
	ServiceLocator.register_as_objects_layer(self)


func _exit_tree() -> void:
	ServiceLocator.unregister_as_objects_layer(self)
