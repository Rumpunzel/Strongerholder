extends CheckBox


# warning-ignore-all:unsafe_method_access




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", self, "_toggle")




func _toggle() -> void:
	owner.set_all_values_to(pressed)
