extends TextureRect

# warning-ignore-all:unsafe_property_access
# warning-ignore-all:unsafe_method_access

signal new_image


var _image_path: String
var _random_sprite := false


onready var _image_dialog: FileDialog = $ImageDialog
onready var _toggle_dir: CheckBox = get_node("../ToggleDir")




func _ready() -> void:
	_image_dialog.connect("file_selected", self, "_confirm_dialog")
	_image_dialog.connect("dir_selected", self, "_confirm_dialog")
	
	call_deferred("set_custom_minimum_size", Vector2(max(rect_size.x, rect_size.y), rect_min_size.y))


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
		_show_file_dialog()




func set_current_image_path(new_path: String):
	var directory := Directory.new()
	
	_image_path = new_path
	
	if directory.dir_exists(_image_path):
		var images: Array = FileHelper.list_files_in_directory(_image_path, false, ".png")
		
		texture = load(images.front())
		
		_toggle_dir.pressed = true
		_toogle_random_sprite()
	else:
		texture = load(_image_path)
		_toggle_dir.pressed = false
		_toogle_random_sprite()
	
	_image_dialog.current_path = _image_path
	call_deferred("set_custom_minimum_size", Vector2(max(rect_size.x, rect_size.y), rect_min_size.y))


func get_current_image_path() -> String:
	return _image_path


func _show_file_dialog() -> void:
	_image_dialog.popup_centered_ratio(0.6)


func _confirm_dialog(selected_image: String):
	set_current_image_path(selected_image)
	emit_signal("new_image", selected_image)


func _toogle_random_sprite() -> void:
	_random_sprite = _toggle_dir.pressed
	_image_dialog.mode = FileDialog.MODE_OPEN_DIR if _random_sprite else FileDialog.MODE_OPEN_FILE
