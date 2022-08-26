extends EditorProperty
tool

signal property_updated(new_value)

var toggle_button := Button.new()

func _init() -> void:
	toggle_button.text = "Open Editor"
	toggle_button.toggle_mode = true
	toggle_button.pressed = true
	add_child(toggle_button)
	add_focusable(toggle_button)

func update_property() -> void:
	emit_signal("property_updated", get_edited_object()[get_edited_property()])
