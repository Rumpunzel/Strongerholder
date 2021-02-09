class_name ResourceState, "res://class_icons/states/icon_state_idle.svg"
extends ObjectState


signal item_picked_up
signal item_transferred
signal item_dropped



func pick_up_item() -> bool:
	exit(INACTIVE)
	
	emit_signal("item_picked_up")
	return true


func transfer_item() -> bool:
	emit_signal("item_transferred")
	return true


func drop_item(position_to_drop: Vector2) -> bool:
	exit(IDLE)
	
	emit_signal("item_dropped", position_to_drop)
	return true
