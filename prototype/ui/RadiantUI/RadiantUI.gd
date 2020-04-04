extends RadiantContainer
class_name RadiantUI


const EXIT_BUTTON = "Exit"
const MENU_BUTTON = "Menu"


var menu_buttons:Array

var menu_layers:Array = [ MENU_BUTTON ]

var center_button = null setget set_center_button, get_center_button

var interaction_object
var interaction


signal button_pressed



func _init(new_menu_buttons:Array, new_interaction_object = null, new_interaction = null):
	menu_buttons = new_menu_buttons
	interaction_object = new_interaction_object
	interaction = new_interaction
	
	be_a_retard = true


func _ready():
	center_button = RadiantUIButton.new(EXIT_BUTTON)
	add_actual_child(center_button)
	
	center_button.grab_focus()
	
	if not "_button_pressed" in center_button.get_signal_list():
		center_button.connect("pressed", self, "_button_pressed", [center_button])
	
	place_buttons(menu_buttons)


func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		close()
		get_tree().set_input_as_handled()



func place_buttons(new_buttons:Array):
	for button_name in new_buttons:
		var new_button:RadiantUIButton
		
		if button_name == "Build":
			new_button = RadiantUIButton.new(button_name, [CityLayout.STOCKPILE, CityLayout.STOCKPILE, CityLayout.STOCKPILE, CityLayout.STOCKPILE, CityLayout.STOCKPILE])
		else:
			new_button = RadiantUIButton.new(button_name)
		
		new_button.modulate.a = 0
		add_child(new_button)
		
		if not "_button_pressed" in new_button.get_signal_list():
			new_button.connect("pressed", self, "_button_pressed", [new_button])
	
	update_children()
	
	animate_in_buttons()


func _button_pressed(button:RadiantUIButton):
	if button.text == EXIT_BUTTON:
		close()
	elif not button == center_button and button.menu_buttons.empty():
		if interaction_object and interaction:
			interaction_object.call(interaction, button.text)
			interaction_object = null
			interaction = null
		
		emit_signal("button_pressed", button.text)
		
		close(0.5, button)
	else:
		for child in get_children():
			remove_child(child)
			child.queue_free()
		
		set_center_button(button.text)
		print(menu_layers)
		if menu_layers.size() > 1:
			place_buttons(button.menu_buttons)
		else:
			place_buttons(menu_buttons)
		
		


func animate_in_buttons():
	var tween:Tween = Tween.new()
	add_actual_child(tween)
	
	yield(get_tree(), "idle_frame")
	
	for button in get_children():
		tween.interpolate_property(button, "rect_position", Vector2(), button.rect_position, 0.3, Tween.TRANS_BACK,Tween.EASE_OUT)
		tween.interpolate_property(button, "modulate:a", 0.0, 1.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()


func close(time:float = 0.3, pressed_button = null):
	var tween:Tween = Tween.new()
	add_actual_child(tween)
	
	tween.interpolate_property(center_button, "modulate:a", 1.0, 0.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	for button in get_children():
		tween.interpolate_property(button, "rect_position", button.rect_position, -button.rect_size / 2.0, time, Tween.TRANS_BACK,Tween.EASE_IN)
		tween.interpolate_property(button, "modulate:a", 1.0, 0.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	if pressed_button:
		tween.interpolate_property(pressed_button, "rect_scale", pressed_button.rect_scale, pressed_button.rect_scale * 3.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	queue_free()




func set_center_button(new_button):
	if menu_layers.has(new_button):
		if new_button == MENU_BUTTON:
			menu_layers.remove(0)
		else:
			menu_layers.erase(new_button)
		center_button.text = menu_layers.front() if not menu_layers.empty() and not new_button == MENU_BUTTON else EXIT_BUTTON
	else:
		center_button.text = menu_layers.front() if not menu_layers.empty() else MENU_BUTTON
		menu_layers.push_front(new_button)
	
	center_button.grab_focus()



func get_center_button():
	return center_button
