extends MarginContainer


onready var _sub_classes: TabContainer = $InfoDivider/SubClasses



func get_class_interfaces() -> Dictionary:
	var class_interfaces := { }
	
	for sub_class in _sub_classes.get_children():
		var dict: Dictionary = sub_class.get_class_interfaces()
		for key in dict.keys():
			class_interfaces[key] = dict[key]
	
	return class_interfaces


func update_all_data() -> void:
	_sub_classes.update_all_data()



func _save_data(_id: int) -> void:
	if get_parent():
		get_parent().save_data()
