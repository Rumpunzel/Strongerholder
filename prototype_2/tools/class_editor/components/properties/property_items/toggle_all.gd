extends CheckBox


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", self, "_toggle")




func _toggle() -> void:
	owner.set_all_values_to(pressed)
