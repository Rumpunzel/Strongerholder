extends GraphNode
tool

var highlighted := false setget set_highlighted

func set_highlighted(new_status: bool) -> void:
	highlighted = new_status
	var new_alpha := 1.0 if highlighted else 0.25
	modulate.a = new_alpha
	var new_left_slot_color := get_slot_color_left(0)
	new_left_slot_color.a = new_alpha
	set_slot_color_left(0, new_left_slot_color)
	var new_right_slot_color := get_slot_color_right(0)
	new_left_slot_color.a = new_alpha
	set_slot_color_right(0, new_right_slot_color)
