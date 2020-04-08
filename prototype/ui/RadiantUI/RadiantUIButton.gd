class_name RadiantUIButton
extends Button


var menu_buttons: Array




func _init(new_name, new_buttons: Array = [ ]):
	if new_name is int:
		new_name = CityLayout.enum_name(CityLayout.Objects, new_name).capitalize()
	
	name = new_name
	text = new_name
	
	menu_buttons = new_buttons




func _pressed():
	get_tree().set_input_as_handled()
