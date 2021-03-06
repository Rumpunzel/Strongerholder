extends RadiantContainer
class_name RadiantUI


signal button_pressed(text)
signal closed


const EXIT_BUTTON = "Exit"
const MENU_BUTTON = "Menu"

const BUILDINGS_DIRECTORY = "res://game_objects/structures/buildings/"


var _menu_buttons: Array = [ ]
var _menu_layers: Array = [ MENU_BUTTON ]

var _actor


var center_button = null setget set_center_button


onready var tween: Tween = Tween.new()




#func _init(new_menu_buttons: Array, new_actor) -> void:
#	_menu_buttons = new_menu_buttons
#	_be_a_retard = true
#
#	_actor = new_actor


func _ready() -> void:
	add_actual_child(tween)
	
	center_button = RadiantUIButton.new(EXIT_BUTTON)
	center_button.modulate.a = 0
	add_actual_child(center_button)
	
	center_button.grab_focus()
	
	if not "_button_pressed" in center_button.get_signal_list():
		center_button.connect("pressed", self, "_button_pressed", [center_button])
	
	place_buttons(_menu_buttons)
	
	if _menu_buttons.empty():
		_menu_buttons = get_children()
		
		for button in _menu_buttons:
			if not "_button_pressed" in button.get_signal_list():
				button.connect("pressed", self, "_button_pressed", [button])





func place_buttons(new_buttons: Array) -> void:
	for button_name in new_buttons:
		var new_button: RadiantUIButton
		
		if button_name is String and button_name == "Build":
			pass#new_button = RadiantUIButton.new(button_name, [Constants.Structures.STOCKPILE, Constants.Structures.WOODCUTTERS_HUT])
		else:
			new_button = RadiantUIButton.new(button_name)
		
		new_button.modulate.a = 0
		add_child(new_button)
		
		if not "_button_pressed" in new_button.get_signal_list():
			new_button.connect("pressed", self, "_button_pressed", [new_button])
	
	update_children()
	
	_animate_in_buttons()



func close(time: float = 0.3, pressed_button = null) -> void:
	var buttons: Array = get_children()
	var previous_button_position: Array = [ ]
	
	for button in buttons:
		previous_button_position.append(button.rect_position)
	
	
	tween.interpolate_property(center_button, "modulate:a", null, 0.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, time * 0.5)
	
	for button in buttons:
		tween.interpolate_property(button, "rect_position", null, -button.rect_size / 2.0, time, Tween.TRANS_BACK,Tween.EASE_IN)
		tween.interpolate_property(button, "modulate:a", null, 0.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	if pressed_button:
		tween.interpolate_property(pressed_button, "rect_scale", null, pressed_button.rect_scale * 3.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	emit_signal("closed")
	
	for i in buttons.size():
		buttons[i].rect_position = previous_button_position[i]



func display(parent) -> void:
	parent.add_child(self)



func _button_pressed(button: RadiantUIButton) -> void:
	print(button)
	if button.text == EXIT_BUTTON:
		close()
	elif not button == center_button and button.menu_buttons.empty():
		var new_scene = FileHelper.list_files_in_directory(BUILDINGS_DIRECTORY, true, ".tscn", true).get(button.text.replace(" ", "_").to_lower())
		var new_structure
		
		if new_scene:
			new_structure = load(new_scene).instance()
			_actor.placing_this_building = new_structure
		
		emit_signal("button_pressed", button.text)
		
		close(0.5, button)
	else:
		for child in get_children():
			remove_child(child)
			child.queue_free()
		
		set_center_button(button.text)
		
		if _menu_layers.size() > 1:
			place_buttons(button.menu_buttons)
		else:
			place_buttons(_menu_buttons)


func _animate_in_buttons() -> void:
	for button in get_children():
		button.modulate.a = 0
	
	
	tween.interpolate_property(center_button, "modulate:a", 0.0, 1.0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	for button in get_children():
		tween.interpolate_property(button, "rect_position", Vector2(), button.rect_position, 0.4, Tween.TRANS_BACK,Tween.EASE_OUT)
		tween.interpolate_property(button, "modulate:a", 0.0, 1.0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
	
	center_button.grab_focus()




func set_center_button(new_button: String) -> void:
	if _menu_layers.has(new_button):
		if new_button == MENU_BUTTON:
			_menu_layers.remove(0)
		else:
			_menu_layers.erase(new_button)
		center_button.text = _menu_layers.front() if not _menu_layers.empty() and not new_button == MENU_BUTTON else EXIT_BUTTON
	else:
		center_button.text = _menu_layers.front() if not _menu_layers.empty() else MENU_BUTTON
		_menu_layers.push_front(new_button)
	
	center_button.grab_focus()
