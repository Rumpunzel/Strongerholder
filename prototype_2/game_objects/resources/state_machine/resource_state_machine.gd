class_name ResourceStateMachine, "res://class_icons/states/icon_resource_state_machine.svg"
extends ObjectStateMachine


signal item_picked_up
signal item_transferred
signal item_dropped



func drop_item(position_to_drop: Vector2) -> void:
	current_state.drop_item(position_to_drop)


func pick_up_item(new_invetory) -> void:
	current_state.pick_up_item(new_invetory)


func transfer_item(new_inventory) -> void:
	current_state.transfer_item(new_inventory)




func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			ResourceStateInactive,
			ResourceStateIdle,
			ResourceStateDead,
		]
	
	._setup_states(state_classes)


func _connect_states() -> void:
	._connect_states()
	
	for state in get_children():
		state.connect("active_state_set", self, "_on_active_state_set")
		
		state.connect("item_picked_up", self, "_on_item_picked_up")
		state.connect("item_transferred", self, "_on_item_transferred")
		state.connect("item_dropped", self, "_on_item_dropped")



func _on_active_state_set(new_state: bool) -> void:
	emit_signal("active_state_set", new_state)

func _on_item_picked_up(new_inventory) -> void:
	emit_signal("item_picked_up", new_inventory)

func _on_item_transferred(new_inventory) -> void:
	emit_signal("item_transferred", new_inventory)

func _on_item_dropped(position_to_drop: Vector2) -> void:
	emit_signal("item_dropped", position_to_drop)
