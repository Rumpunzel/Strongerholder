class_name ResourceState, "res://class_icons/states/icon_state_idle.svg"
extends ObjectState


signal item_picked_up
signal item_transferred
signal item_dropped



func pick_up_item(new_inventory: Inventory) -> void:
	exit(INACTIVE)
	
	emit_signal("item_picked_up", new_inventory)


func transfer_item(new_inventory: Inventory) -> void:
	emit_signal("item_transferred", new_inventory)


func drop_item(objects_layer: YSort, position_to_drop: Vector2) -> void:
	emit_signal("item_dropped", position_to_drop)
	
	exit(IDLE)
