class_name ToolsMenu
extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$radiant_container.connect("closed", self, "hide")


func _unhandled_input(event: InputEvent):
	if not visible and event.is_action_released("open_menu"):
		get_tree().set_input_as_handled()
		
		$radiant_container._animate_in_buttons()
		
		yield(get_tree(), "idle_frame")
		
		show()
	elif visible and event.is_action_released("ui_cancel"):
		get_tree().set_input_as_handled()
		
		$radiant_container.close()
