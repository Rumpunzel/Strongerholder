class_name RadiantUIButton
extends Button


var menu_buttons: Array = [ ]




func _init(new_name, new_buttons: Array = [ ], new_icon: Texture = null):
#	if new_name is int:
#		new_name = Constants.enum_name(Constants.Structures, new_name).capitalize()
	
	name = new_name
	text = new_name
	
	icon = new_icon
	
	menu_buttons = new_buttons




func _pressed():
	get_tree().set_input_as_handled()
