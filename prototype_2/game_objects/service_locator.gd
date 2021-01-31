extends Node


var navigator: Navigation2D setget register_as_navigator
var objects_layer: YSort setget register_as_objects_layer
var quarter_master: Node setget register_as_quarter_master




func register_as_navigator(new_node: Navigation2D) -> void:
	assert(new_node)
	navigator = new_node


func unregister_as_navigator(new_node: Navigation2D) -> void:
	assert(new_node and new_node == navigator)
	navigator = null



func register_as_objects_layer(new_node: YSort) -> void:
	assert(new_node)
	objects_layer = new_node


func unregister_as_objects_layer(new_node: YSort) -> void:
	assert(new_node and new_node == objects_layer)
	objects_layer = null



func register_as_quarter_master(new_node: Node) -> void:
	assert(new_node)
	quarter_master = new_node


func unregister_as_quarter_master(new_node: Node) -> void:
	assert(new_node and new_node == quarter_master)
	quarter_master = null
