extends ClassProperty


export(Array, String) var options = [ ]


var _button_dictionary := { }




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in options.size():
		property.add_item(options[i], i)
		_button_dictionary[options[i]] = i




func set_value(new_value):
	if not new_value:
		property.select(0)
		return
	
	property.select(_button_dictionary[new_value])


func get_value():
	return options[property.get_selected_id()]
