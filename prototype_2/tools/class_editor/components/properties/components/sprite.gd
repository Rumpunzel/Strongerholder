extends MarginContainer

# warning-ignore-all:unsafe_property_access
# warning-ignore-all:unsafe_method_access


var _current_sprite_sheets: Array setget set_sprite_sheets, get_sprite_sheets


onready var _image_dialog: FileDialog = $ImageDialog
onready var _change_sheets: Button = $ButtonDivider/ChangeSheets
onready var _sprite_sheets: TabContainer = $ButtonDivider/SpriteSheets




func _ready() -> void:
	_change_sheets.connect("pressed", _image_dialog, "popup_centered_ratio", [ 0.6 ])
	_image_dialog.connect("files_selected", self, "set_sprite_sheets")




func set_sprite_sheets(new_sheets: Array):
	_current_sprite_sheets = new_sheets
	_sprite_sheets.add_sheets(_current_sprite_sheets)


func get_sprite_sheets() -> Array:
	return _current_sprite_sheets
