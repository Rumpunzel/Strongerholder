class_name StructureInventory, "res://assets/icons/structures/icon_structure_inventory.svg"
extends Inventory


export(Array, Constants.Resources) var _requests: Array



func initialize():
	connect("received_item", self, "register_item")
	connect("sent_item", self, "unregister_item")
	
	.initialize()
	
	if _requests.has(Constants.Resources.EVERYTHING):
		_requests.clear()
		
		for value in Constants.Resources.values():
			if value > Constants.Resources.EVERYTHING:
				_requests.append(value)
	
	for request in _requests:
		RingMap.register_resource(request + Constants.REQUEST, owner)


func register_item(new_item: int):
	RingMap.register_resource(new_item, owner)


func unregister_item(new_item: int):
	RingMap.unregister_resource(new_item, owner)
