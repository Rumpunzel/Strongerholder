class_name Stash, "res://editor_tools/class_icons/spatials/icon_wooden_crate.svg"
extends Area

export(Resource) var item_to_store

onready var _inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)


# Returns how many items were dropped because the inventory was full
func stash(item: ItemResource, count := 1) -> int:
	print("%s stashed" % item.name)
	return _inventory.add(item, count)

func full() -> bool:
	return _inventory.full(item_to_store)
