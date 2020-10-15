class_name StructureInventory, "res://assets/icons/structures/icon_structure_inventory.svg"
extends Inventory


export(Array, String) var requests: Array = [ ]
export var request_everything: bool = false




func _ready():
	connect("received_item", self, "register_item")



func initialize():
	.initialize()
	
	var dic: Array = [ ]
	
	dic = requests.duplicate()
	
	if request_everything:
		dic.clear()
		
		for value in Constants.Resources.keys():
			dic.append(value)
	
	for request in dic:
		owner.add_to_group("%s%s" % [Constants.REQUEST, request])




func register_item(item):
	owner.add_to_group(item.type)
