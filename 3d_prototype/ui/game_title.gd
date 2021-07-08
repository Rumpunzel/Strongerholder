class_name GameTitle
extends Label
tool

func _ready():
	var cl_nm := "GameTitle"
	set("custom_fonts/font", get_font("font", cl_nm))
	set("custom_colors/font_color", get_color("font_color", cl_nm))
	set("custom_colors/font_color_shadow", get_color("font_color_shadow", cl_nm))
	set("constants/shadow_offset_x", get_constant("shadow_offset_x", cl_nm))
	set("constants/shadow_offset_y", get_constant("shadow_offset_y", cl_nm))
	
	text = ProjectSettings.get("application/config/name")
