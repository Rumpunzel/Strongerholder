class_name Stash, "res://editor_tools/class_icons/spatials/icon_wooden_crate.svg"
extends Area

export(Resource) var _item_to_store

onready var inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)


# Returns how many items were dropped because the inventory was full
func stash(item: ItemResource, count: int) -> int:
	return inventory.add(item, count)

# Returns how many were not removed
func take(item: ItemResource, count: int) -> int:
	return inventory.remove_many(item, count)

func stores(item: ItemResource) -> bool:
	return item == _item_to_store

func contains(item: ItemResource) -> Inventory.ItemStack:
	return inventory.contains(item)

func count(item: ItemResource) -> int:
	return inventory.count(item)

func full() -> bool:
	return inventory.full(_item_to_store)
