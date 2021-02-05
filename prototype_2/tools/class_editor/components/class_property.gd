class_name ClassProperty
extends PanelContainer


onready var label: Label = $PropContainer/TopDivider/Label
# warning-ignore-all:unused_class_variable
onready var property = $PropContainer/Property

# warning-ignore-all:unused_class_variable
onready var property_name: String = label.text



func set_value(_new_value):
	assert(false)


func get_value():
	assert(false)
