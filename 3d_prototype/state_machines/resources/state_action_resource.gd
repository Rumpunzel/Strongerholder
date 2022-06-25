class_name StateActionResource, "res://editor_tools/class_icons/resources/icon_hand.svg"
extends Resource


func get_action(
		state_machine: Node,#: StateMachine,
		created_instances: Dictionary
) -> StateAction:
	
	var state_action: StateAction = created_instances.get(self)
	
	if state_action:
		return state_action
	
	state_action = _create_action()
	created_instances[self] = state_action
	state_action.origin_resource = self
	state_action.awake(state_machine)
	
	return state_action


func _create_action() -> StateAction:
	assert(false)
	return null
