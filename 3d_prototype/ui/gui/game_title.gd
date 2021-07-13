class_name GameTitle
extends Label
tool


func _ready():
	_set_font("font")
	_set_color("font_color")
	_set_color("font_color_shadow")
	_set_constant("shadow_offset_x")
	_set_constant("shadow_offset_y")
	
	text = ProjectSettings.get("application/config/name")


func _set_font(font_name: String) -> void:
	set("custom_fonts/%s" % font_name, _get_font(font_name))

func _set_color(color_name: String) -> void:
	set("custom_colors/%s" % color_name, _get_color(color_name))

func _set_constant(constant_name: String) -> void:
	set("constants/%s" % constant_name, _get_constant(constant_name))


func _get_font(font_name: String) -> Font:
	return get_font(font_name, "GameTitle")

func _get_color(color_name: String) -> Color:
	return get_color(color_name, "GameTitle")

func _get_constant(constant_name: String):
	return get_color(constant_name, "GameTitle")
