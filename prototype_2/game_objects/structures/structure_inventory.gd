class_name StructureInventory, "res://assets/icons/structures/icon_structure_inventory.svg"
extends Inventory







func _ready():
	connect("received_item", self, "register_item")
	
	for item in get_children():
		pick_up_item(item)




func register_item(item):
	owner.owner.add_to_group(Constants.enum_name(Constants.Resources, item.type))
