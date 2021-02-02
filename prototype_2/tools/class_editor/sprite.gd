extends TextureRect


signal new_image


var current_image_path: String = "res://ui/game_gui/resource_icons/icon_wood.png"


onready var _image_dialog: FileDialog = $ImageDialog




func _ready() -> void:
	_image_dialog.connect("file_selected", self, "confirm_dialog")


# Called when the node enters the scene tree for the first time.
func _gui_input(event: InputEvent) -> void:
	if not _image_dialog.visible and event is InputEventMouseButton:
		_image_dialog.popup_centered_ratio(0.6)




func confirm_dialog(selected_image: String):
	current_image_path = selected_image
	texture = load(current_image_path)
	emit_signal("new_image", current_image_path)
