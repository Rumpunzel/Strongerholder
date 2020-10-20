class_name CityStructure, "res://assets/icons/structures/icon_city_structure.svg"
extends Structure



func request_item(request, receiver: Node2D):
	var requested_item: Node2D = _pilot_master.has_item(request)
	
	_state_machine.give_item(requested_item, receiver)
