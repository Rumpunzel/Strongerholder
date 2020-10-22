class_name Inventory, "res://assets/icons/icon_inventory.svg"
extends Node2D


signal received_item(item)




func pick_up_item(item: Node2D):
	item.pick_up_item(self)



func drop_all_items(position_to_drop: Vector2):
	while get_child_count() > 0:
		drop_item(get_child(0), position_to_drop)


func drop_item(item: Node2D, position_to_drop: Vector2) -> bool:
	if get_children().has(item):
		item.drop_item(position_to_drop)
		return true
	
	return false



func empty() -> bool:
	return get_child_count() == 0


func has(object_type) -> Node2D:
	for item in get_children():
		if item.type == object_type:
			return item
	
	return null


func get_contents() -> Array:
	return get_children()



func _add_item(item: Node2D):
	add_child(item)
	emit_signal("received_item", item)
