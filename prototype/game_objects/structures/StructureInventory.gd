class_name StructureInventory
extends Inventory


export(Array, Constants.Resources) var requests



func initialize():
	connect("received_item", self, "register_item")
	connect("sent_item", self, "unregister_item")
	
	.initialize()
	
	if requests.has(Constants.Resources.EVERYTHING):
		requests = Constants.Resources.values()
	
	for request in requests:
		RingMap.register_resource(request + Constants.REQUEST, owner)


func register_item(new_item):
	RingMap.register_resource(new_item, owner)


func unregister_item(new_item):
	RingMap.unregister_resource(new_item, owner)
