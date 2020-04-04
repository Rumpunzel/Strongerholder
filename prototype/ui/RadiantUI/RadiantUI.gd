extends RadiantContainer


export(PackedScene) var button_scene
var number_of_buttons = 5


var menu_layers:Array = [ ]
var center_button = null setget set_center_button, get_center_button




func _ready():
	set_center_button(button_scene.instance())
	
	if not "_button_pressed" in center_button.get_signal_list():
		center_button.connect("pressed", self, "_button_pressed", [center_button])
	
	var test_buttons:Array = [ ]
	
	for _i in range(number_of_buttons):
		test_buttons.append(button_scene.instance())
	
	place_buttons(test_buttons)



#Repositions the buttons
func place_buttons(new_buttons:Array):
	for button in new_buttons:
		add_child(button)
		
		if not "_button_pressed" in button.get_signal_list():
			button.connect("pressed", self, "_button_pressed", [button])
	
	update_children()


func _button_pressed(button):
	for child in get_children():
		remove_child(child)
	
	set_center_button(button)
	
	
	var test_buttons:Array = [ ]
	
	if menu_layers.size() > 1:
		for _i in range(int(ceil(number_of_buttons / 2.0))):
			test_buttons.append(button_scene.instance())
	else:
		for _i in range(number_of_buttons):
			test_buttons.append(button_scene.instance())
	
	
	place_buttons(test_buttons)


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
