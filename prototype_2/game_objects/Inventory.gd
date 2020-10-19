class_name Inventory, "res://assets/icons/icon_inventory.svg"
extends Node2D


signal received_item(item)




func pick_up_item(item: Node2D):
	item.pick_up_item(self)
	emit_signal("received_item", item)



func drop_all_items(position_to_drop: Vector2):
	while get_child_count() > 0:
		drop_item(get_child(0), position_to_drop)


func drop_item(item: Node2D, position_to_drop: Vector2):
	item.drop_item(position_to_drop)



func empty() -> bool:
	return get_child_count() == 0


func has(object_type) -> bool:
	for item in get_children():
		if item.type == object_type:
			return true
	
	return false


func get_contents() -> Array:
	return get_children()
