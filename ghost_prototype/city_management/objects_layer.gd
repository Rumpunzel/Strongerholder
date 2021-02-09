class_name ObjectsLayer, "res://class_icons/game_objects/icon_objects_layer.svg"
extends YSort


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false


signal object_selected




func _enter_tree() -> void:
	ServiceLocator.register_as_objects_layer(self)

func _ready() -> void:
	name = "ObjectsLayer"

func _exit_tree() -> void:
	ServiceLocator.unregister_as_objects_layer(self)



func add_child(new_node: Node, legible_unique_name: bool = false) -> void:
	.add_child(new_node, legible_unique_name)
	
	if new_node is GameObject:
		(new_node as GameObject).connect("selected", self, "_on_object_selected")


func remove_child(new_node: Node) -> void:
	.remove_child(new_node)
	
	if new_node is GameObject:
		(new_node as GameObject).disconnect("selected", self, "_on_object_selected")



func _on_object_selected(new_node: GameObject) -> void:
	emit_signal("object_selected", new_node)
