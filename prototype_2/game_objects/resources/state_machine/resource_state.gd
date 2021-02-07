class_name ResourceState, "res://class_icons/states/icon_state_idle.svg"
extends ObjectState


signal item_picked_up
signal item_transferred
signal item_dropped



func pick_up_item() -> void:
	exit(INACTIVE)
	
	emit_signal("item_picked_up")


func transfer_item() -> void:
	emit_signal("item_transferred")


func drop_item(position_to_drop: Vector2) -> void:
	emit_signal("item_dropped", position_to_drop)
	
	exit(IDLE)
