extends HBoxContainer


onready var _label: Label = $Label
onready var _check_box: CheckBox = $CheckBox



func set_resource(new_resource: String) -> void:
	_label.text = new_resource
	name = new_resource


func get_resource() -> String:
	return _label.text


func set_value(new_value) -> void:
	if not new_value:
		return
	
	_check_box.pressed = new_value


func get_value() -> bool:
	return _check_box.pressed
