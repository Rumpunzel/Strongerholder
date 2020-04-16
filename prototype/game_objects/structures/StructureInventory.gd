class_name StructureInventory, "res://assets/icons/structures/icon_structure_inventory.svg"
extends Inventory


export(Array, Constants.Resources) var requests: Array = [ ] setget set_requests, get_requests



func initialize():
	connect("received_item", self, "register_item")
	connect("sent_item", self, "unregister_item")
	
	.initialize()
	
	if requests.has(Constants.Resources.EVERYTHING):
		requests.clear()
		
		for value in Constants.Resources.values():
			if value > Constants.Resources.EVERYTHING:
				requests.append(value)
	
	for request in requests:
		RingMap.register_resource(request + Constants.REQUEST, owner)


func register_item(new_item: int):
	RingMap.register_resource(new_item, owner)


func unregister_item(new_item: int):
	RingMap.unregister_resource(new_item, owner)




func set_requests(new_requests: Array):
	requests = new_requests


func get_requests() -> Array:
	return requests
