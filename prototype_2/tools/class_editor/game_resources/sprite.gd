extends TextureRect


signal new_image


onready var _image_dialog: FileDialog = $ImageDialog




func _ready() -> void:
	_image_dialog.connect("file_selected", self, "_confirm_dialog")
	call_deferred("set_custom_minimum_size", Vector2(max(rect_size.x, rect_size.y), rect_min_size.y))


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
		_show_file_dialog()




func set_current_image_path(new_path: String):
	_image_dialog.current_path = new_path
	texture = load(new_path)
	call_deferred("set_custom_minimum_size", Vector2(max(rect_size.x, rect_size.y), rect_min_size.y))


func get_current_image_path() -> String:
	return _image_dialog.current_path


func _show_file_dialog() -> void:
	_image_dialog.popup_centered_ratio(0.6)


func _confirm_dialog(selected_image: String):
	set_current_image_path(selected_image)
	emit_signal("new_image", selected_image)
