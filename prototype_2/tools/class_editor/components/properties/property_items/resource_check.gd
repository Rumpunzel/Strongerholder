extends HBoxContainer


onready var _label: Label = $Label
onready var _icon: TextureRect = $Icon
onready var _check_box: CheckButton = $CheckBox



func set_resource(new_resource: String) -> void:
	_label.text = new_resource
	name = new_resource
	
	var lookup_file: GDScript = load("res://game_objects/game_classes.gd")
	var resource_sprite: String = lookup_file.get_script_constant_map()[new_resource].get_script_constant_map().sprite
	
	_icon.texture = load(resource_sprite)


func get_resource() -> String:
	return _label.text


func set_value(new_value) -> void:
	if new_value == null:
		return
	
	_check_box.pressed = new_value


func get_value() -> bool:
	return _check_box.pressed
