class_name Stash, "res://editor_tools/class_icons/spatials/icon_wooden_crate.svg"
extends Area

export(Resource) var _item_to_store

export var _store_everything := false

onready var inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)


# Returns how many items were dropped because the inventory was full
func stash(item: ItemResource, count := 1) -> int:
	return inventory.add(item, count)

func stores(item: ItemResource) -> bool:
	return _store_everything or (not _item_to_store == null and item == _item_to_store)

func full() -> bool:
	return inventory.full(_item_to_store)
