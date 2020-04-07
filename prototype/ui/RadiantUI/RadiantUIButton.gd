class_name RadiantUIButton
extends Button


var menu_buttons: Array




func _init(new_name: String, new_buttons: Array = [ ]):
	name = new_name
	text = new_name
	
	menu_buttons = new_buttons




func _pressed():
	get_tree().set_input_as_handled()
