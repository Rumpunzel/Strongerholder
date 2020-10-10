class_name PlayerCamera
extends Camera2D


export(NodePath) var ui_layer


onready var _ui_layer = get_node(ui_layer)
onready var _ui = _ui_layer.get_node("control/margin_container")
onready var _control_layer = _ui_layer.get_node("control")




func add_ui_element(new_element: Control, center_ui: bool = true):
	var new_parent = _ui if center_ui else _control_layer
	
	new_parent.add_child(new_element)
