class_name StructureInventory, "res://assets/icons/structures/icon_structure_inventory.svg"
extends Inventory


export(Array, String) var requests: Array = [ ]
export var request_everything: bool = false



func initialize():
	connect("received_item", self, "register_item")
	connect("sent_item", self, "unregister_item")
	
	.initialize()
	
	if request_everything:
		requests.clear()
		
		for value in  GameResource.RESOURCES:
			requests.append(value)
	
	for request in requests:
		RingMap.register_resource("%s%s" % [GameResource.REQUEST, request], owner)


func register_item(new_item: GameResource):
	RingMap.register_resource(new_item.type, owner)


func unregister_item(new_item: GameResource):
	RingMap.unregister_resource(new_item.type, owner)
