class_name RadiantUIButton
extends Button


var menu_buttons: Array setget set_menu_buttons, get_menu_buttons




func _init(new_name, new_buttons: Array = [ ]):
	if new_name is int:
		new_name = Constants.enum_name(Constants.Structures, new_name).capitalize()
	
	name = new_name
	text = new_name
	
	menu_buttons = new_buttons




func _pressed():
	get_tree().set_input_as_handled()




func set_menu_buttons(new_buttons: Array):
	menu_buttons = new_buttons


func get_menu_buttons() -> Array:
	return menu_buttons
