class_name ObjectsLayer, "res://assets/icons/icon_objects_layer.svg"
extends YSort


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false

const PERSIST_PROPERTIES := ["name"]




func _enter_tree():
	ServiceLocator.register_as_objects_layer(self)


func _exit_tree():
	ServiceLocator.unregister_as_objects_layer(self)
