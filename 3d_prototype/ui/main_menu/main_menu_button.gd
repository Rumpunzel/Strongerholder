class_name MainMenuButton
extends Button
tool

export var _background_fade_time := 0.05

onready var _label: Label = $Label
onready var _background: Panel = $Panel
onready var _tween: Tween = $Tween



func _enter_tree() -> void:
	# warning-ignore-all:return_value_discarded
	connect("focus_entered", self, "_set_hover")
	connect("focus_exited", self, "_set_default")
	connect("mouse_entered", self, "_set_hover")
	connect("mouse_exited", self, "_set_default")
	connect("button_down", self, "_set_pressed")
	connect("button_up", self, "_set_default")

func _exit_tree() -> void:
	disconnect("focus_entered", self, "_set_hover")
	disconnect("focus_exited", self, "_set_default")
	disconnect("mouse_entered", self, "_set_hover")
	disconnect("mouse_exited", self, "_set_default")
	disconnect("button_down", self, "_set_pressed")
	disconnect("button_up", self, "_set_default")


func _ready() -> void:
	set_text(text)
	set_disabled(disabled)



func set_text(new_text: String) -> void:
	_label.text = new_text

func get_text() -> String:
	return _label.text

func set_disabled(is_disabled: bool) -> void:
	.set_disabled(is_disabled)
	if disabled:
		_set_disabled()
	else:
		_set_default()


func _set_default() -> void:
	if disabled:
		return
	_label.add_color_override("font_color", get_color("font_color"))
	_tween.interpolate_property(_background, "modulate:a", 1.0, 0.0, _background_fade_time)
	_tween.start()

func _set_hover() -> void:
	if disabled:
		return
	_label.add_color_override("font_color", get_color("font_color_hover"))
	_tween.interpolate_property(_background, "modulate:a", 0.0, 1.0, _background_fade_time)
	_tween.start()

func _set_pressed() -> void:
	if disabled:
		return
	_label.add_color_override("font_color", get_color("font_color_pressed"))

func _set_disabled() -> void:
	_label.add_color_override("font_color", get_color("font_color_disabled"))
	_tween.interpolate_property(_background, "modulate:a", 1.0, 0.0, _background_fade_time)
	_tween.start()
