class_name ResourceStateMachine, "res://class_icons/states/icon_resource_state_machine.svg"
extends ObjectStateMachine




func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			ResourceStateInactive,
			ResourceStateIdle,
			ResourceStateDead,
		]
	
	._setup_states(state_classes)




func drop_item(objects_layer: YSort, position_to_drop: Vector2) -> void:
	current_state.drop_item(objects_layer, position_to_drop)


func pick_up_item(new_invetory: Inventory) -> void:
	current_state.pick_up_item(new_invetory)


func transfer_item(new_inventory) -> void:
	current_state.transfer_item(new_inventory)
