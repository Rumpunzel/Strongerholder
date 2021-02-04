class_name ClassProperty
extends PanelContainer


onready var label: Label = $PropContainer/Label
onready var property = $PropContainer/Property

onready var property_name: String = label.text



func set_value(_new_value):
	assert(false)
