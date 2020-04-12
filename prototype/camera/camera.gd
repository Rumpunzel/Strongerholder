extends Camera


onready var ui = $ui_layer/control/margin_container
onready var control_layer = $ui_layer/control



func add_ui_element(new_element: Control, center_ui: bool = true):
	var new_parent = ui if center_ui else control_layer
	
	new_parent.add_child(new_element)
