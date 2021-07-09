class_name RadialMenuItem
extends TextureRect

var submenu
var disabled := false setget _set_disabled



func _set_disabled(is_disabled: bool) -> void:
	disabled = is_disabled
	# TODO: find out why this does not work
	#modulate = _get_color("icon_modulation") if not disabled else _get_color("icon_modulation_disabled")


func _set_font(font_name: String) -> void:
	set("custom_fonts/%s" % font_name, _get_font(font_name))

func _set_color(color_name: String) -> void:
	set("custom_colors/%s" % color_name, _get_color(color_name))

func _set_constant(constant_name: String) -> void:
	set("constants/%s" % constant_name, _get_constant(constant_name))


func _get_font(font_name: String) -> Font:
	return get_font(font_name, "RadialMenu2")

func _get_color(color_name: String) -> Color:
	return get_color(color_name, "RadialMenu2")

func _get_constant(constant_name: String):
	return get_constant(constant_name, "RadialMenu2")
