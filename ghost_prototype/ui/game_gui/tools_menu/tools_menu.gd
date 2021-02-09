class_name ToolsMenu
extends Popup


onready var _radiant_container: RadiantUI = $radiant_container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_radiant_container.connect("closed", self, "hide")


func _unhandled_input(event: InputEvent) -> void:
	if not visible and event.is_action_released("open_menu"):
		get_tree().set_input_as_handled()
		
		_radiant_container._animate_in_buttons()
		
		show()
	elif visible and event.is_action_released("ui_cancel"):
		get_tree().set_input_as_handled()
		
		_radiant_container.close()
