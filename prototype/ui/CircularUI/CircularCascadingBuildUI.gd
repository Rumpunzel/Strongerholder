extends RadiantContainer


export(PackedScene) var button_scene
export var number_of_buttons = 5



func _ready():
	place_buttons()



#Repositions the buttons
func place_buttons():
	for _i in range(number_of_buttons):
		var new_button = button_scene.instance()
		add_child(new_button)
		new_button.connect("pressed", self, "_button_pressed", [new_button])


func _button_pressed(button):
	var buttons = button.get_children()
	
#	if not buttons.empty():
#		#Amount to change the angle for each button
#		var angle_offset = PI / (buttons.size() + 1) #in degrees
#		var angle = (PI * 1.5) + angle_offset #in radians
#
#		for btn in buttons:
#			if not "_button_pressed" in btn.get_signal_list():
#				btn.connect("pressed", self, "_button_pressed", [btn])
#
#			btn.visible = true
#			btn.rect_position = Vector2(0, -button_radius).rotated(angle)
#			btn.rect_rotation = 0
#
#			angle += angle_offset

