extends EditorProperty
tool

# The main control for editing the property.
var property_control := Button.new()
# An internal value of the property.
var current_value := [ ]
# A guard against internal changes when the property is updated.
var updating := false


func _init() -> void:
	# Add the control as a direct child of EditorProperty node.
	add_child(property_control)
	# Make sure the control is able to retain the focus.
	add_focusable(property_control)
	# Setup the initial state and connect to the signal to track changes.
	refresh_control_text()
	property_control.connect("pressed", self, "_on_button_pressed")


func _on_button_pressed() -> void:
	# Ignore the signal if the property is currently being updated.
	if (updating):
		return
	
	refresh_control_text()
	emit_changed(get_edited_property(), current_value)


func update_property() -> void:
	# Read the current value from the property.
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == current_value):
		return
	
	# Update the control with the new value.
	updating = true
	current_value = new_value
	refresh_control_text()
	updating = false

func refresh_control_text() -> void:
	property_control.text = "Value: " + str(current_value)
