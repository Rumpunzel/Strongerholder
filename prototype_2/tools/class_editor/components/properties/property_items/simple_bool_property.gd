extends ClassProperty



func set_value(new_value) -> void:
	if not new_value:
		return
	
	property.pressed = new_value


func get_value() -> bool:
	return property.pressed
