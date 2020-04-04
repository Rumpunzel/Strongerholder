extends Button
class_name RadiantUIButton


var menu_buttons:Array



func _init(new_name:String, new_buttons:Array = [ ]):
	name = new_name
	text = new_name.capitalize()
	
	menu_buttons = new_buttons
