class_name Stash, "res://editor_tools/class_icons/spatials/icon_wooden_crate.svg"
extends Area

export(Resource) var _item_to_store

onready var inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)


# Returns how many items were dropped because the inventory was full
func stash(item: ItemResource, count := 1) -> int:
	return inventory.add(item, count)

# Returns how many are left in the stack
func take(item: ItemResource) -> int:
	return inventory.remove(item)

func stores(item: ItemResource) -> bool:
	return item == _item_to_store

func contains(item: ItemResource) -> Inventory.ItemStack:
	return inventory.contains(item)

func full() -> bool:
	return inventory.full(_item_to_store)
