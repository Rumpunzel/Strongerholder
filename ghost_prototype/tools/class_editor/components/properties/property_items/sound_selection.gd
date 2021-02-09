extends ClassProperty


onready var _sounds_dialog: FileDialog = $PropContainer/Property/FileDialog




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	property.connect("pressed", _sounds_dialog, "popup_centered_ratio", [0.6])
	_sounds_dialog.connect("dir_selected", self, "set_value")




func set_value(new_value: String) -> void:
	if not new_value:
		return
	
	property.text = new_value
	_sounds_dialog.current_dir = new_value


func get_value() -> String:
	return property.text
