class_name Stash, "res://editor_tools/class_icons/spatials/icon_wooden_crate.svg"
extends Area

signal items_stashed(item, count)
signal items_taken(item, count)

export(Resource) var _item_to_store

onready var inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)


# Returns how many items were dropped because the inventory was full
func stash(item: ItemResource, count: int) -> int:
	var items_dropped := inventory.add(item, count)
	emit_signal("items_stashed", item, count - items_dropped)
	return items_dropped

# Returns how many were removed
func take(item: ItemResource, count: int) -> int:
	var items_removed := inventory.remove_many(item, count)
	emit_signal("items_taken", item, items_removed)
	return items_removed

func stores(item: ItemResource) -> bool:
	return item == _item_to_store

func contains(item: ItemResource) -> Inventory.ItemStack:
	return inventory.contains(item)

func count(item: ItemResource) -> int:
	return inventory.count(item)

func full(item_to_check: ItemResource) -> bool:
	if item_to_check != _item_to_store:
		return true
	
	return inventory.full(_item_to_store)

func empty_space(item_to_check: ItemResource) -> int:
	if item_to_check != _item_to_store:
		return 0
	
	return inventory.space_for(_item_to_store)
