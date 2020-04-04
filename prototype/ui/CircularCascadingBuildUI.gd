tool
extends Container

export var button_radius = 100 


func _ready():
	place_buttons()

#Repositions the buttons
func place_buttons():
	var buttons = get_children()
	if buttons.size() == 0:
		return

	#Amount to change the angle for each button
	var angle_offset = (2*PI)/buttons.size() #in degrees

	var angle = 1.5*PI #in radians
	for btn in buttons:
		if not "_button_pressed" in btn.get_signal_list():
			btn.connect("pressed", self, "_button_pressed", [btn])
		btn.visible = true
		btn.rect_position = Vector2(button_radius, 0).rotated(angle)
		btn.rect_rotation = angle * 180 / PI + 90
		angle += angle_offset


func _button_pressed(button):
	var children = button.get_children()
	if children.size() == 0:
		return
		
	#Amount to change the angle for each button
	var angle_offset = (PI)/(children.size()+1) #in degrees
	
	var angle = PI + angle_offset #in radians
	for btn in children:
		btn.connect("pressed", self, "_button_pressed", [btn])
		btn.visible = true
		btn.rect_position = Vector2(button_radius, 0).rotated(angle)
		btn.rect_rotation = angle * 180 / PI + 90
		
		angle += angle_offset
