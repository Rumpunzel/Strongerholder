extends Node


var navigation: Navigation2D setget register_as_navigation
var objects_layer: YSort setget register_as_objects_layer
var quarter_master setget register_as_quarter_master




func register_as_navigation(new_node: Navigation2D):
	if not new_node:
		return
	
	navigation = new_node


func unregister_as_navigation(new_node: Navigation2D):
	if not (new_node and new_node == navigation):
		return
	
	navigation = null



func register_as_objects_layer(new_node: YSort):
	if not new_node:
		return
	
	objects_layer = new_node


func unregister_as_objects_layer(new_node: YSort):
	if not (new_node and new_node == objects_layer):
		return
	
	objects_layer = null



func register_as_quarter_master(new_node):
	if new_node:
		quarter_master = new_node


func unregister_as_quarter_master(new_node):
	if not (new_node and new_node == quarter_master):
		return
	
	quarter_master = null
