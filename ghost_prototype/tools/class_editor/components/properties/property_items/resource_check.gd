extends HBoxContainer


onready var _label: Label = $Label
onready var _icon: TextureRect = $Icon
onready var _check_box: CheckButton = $CheckBox



func set_resource(new_resource: String) -> void:
	_label.text = new_resource
	name = new_resource
	
	var lookup_file: GDScript = load("res://game_objects/game_classes.gd")
	var resource_sprite_sheets: Array = lookup_file.get_script_constant_map()[new_resource].get_script_constant_map().sprite_sheets
	
	if not resource_sprite_sheets.empty():
		_icon.texture = load(resource_sprite_sheets.front())
		_icon.visible = true
	else:
		_icon.visible = false


func get_resource() -> String:
	return _label.text


func set_value(new_value) -> void:
	if new_value == null:
		return
	
	_check_box.pressed = new_value


func get_value() -> bool:
	return _check_box.pressed
