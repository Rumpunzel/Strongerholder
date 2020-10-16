extends Node


var navigation: Navigation2D setget register_as_navigation
var objects_layer: YSort setget register_as_objects_layer
var work_queue setget register_as_work_queue




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



func register_as_work_queue(new_node):
	if new_node:
		work_queue = new_node


func unregister_as_work_queue(new_node):
	if not (new_node and new_node == work_queue):
		return
	
	work_queue = null
