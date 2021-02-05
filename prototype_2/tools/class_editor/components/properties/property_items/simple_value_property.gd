extends ClassProperty



func set_value(new_value) -> void:
	if not new_value:
		return
	
	property.value = new_value


func get_value() -> int:
	return int(property.value)
