extends RadiantContainer
class_name RadiantUI


const EXIT_BUTTON = "Exit"


var menu_buttons:Array

var menu_layers:Array = [ ]
var center_button = null setget set_center_button, get_center_button


signal button_pressed



func _init(new_menu_buttons:Array):
	menu_buttons = new_menu_buttons


func _ready():
	set_center_button(RadiantUIButton.new(EXIT_BUTTON))
	
	if not "_button_pressed" in center_button.get_signal_list():
		center_button.connect("pressed", self, "_button_pressed", [center_button])
	
	place_buttons(menu_buttons)



#Repositions the buttons
func place_buttons(new_buttons:Array):
	for button_name in new_buttons:
		var new_button
		
		if button_name == "Build":
			new_button = RadiantUIButton.new(button_name, [CityLayout.STOCKPILE, CityLayout.STOCKPILE, CityLayout.STOCKPILE, CityLayout.STOCKPILE, CityLayout.STOCKPILE])
		else:
			new_button = RadiantUIButton.new(button_name)
		
		add_child(new_button)
		
		if not "_button_pressed" in new_button.get_signal_list():
			new_button.connect("pressed", self, "_button_pressed", [new_button])
	
	update_children()


func _button_pressed(button):
	for child in get_children():
		remove_child(child)
	
	set_center_button(button)
	
	if menu_layers.size() > 1:
		if not button.menu_buttons.empty():
			place_buttons(button.menu_buttons)
		else:
			emit_signal("button_pressed", button.text)
			close()
	else:
		place_buttons(menu_buttons)


func close():
	queue_free()




func set_center_button(new_button):
	if center_button:
		remove_actual_child(center_button)
	
	if menu_layers.has(new_button):
		menu_layers.erase(new_button)
		center_button = menu_layers.front() if not menu_layers.empty() else null
	else:
		center_button = new_button
		menu_layers.push_front(center_button)
	
	if center_button:
		add_actual_child(center_button)
	else:
		close()



func get_center_button():
	return center_button
