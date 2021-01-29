class_name ToolStateMachine, "res://assets/icons/icon_tool_state_machine.svg"
extends ResourceStateMachine



func _setup_states(state_classes: Array = [ ]):
	if state_classes.empty():
		state_classes = [
			ToolStateInactive,
			ToolState,
			ToolStateAttack,
			ToolStateDead,
		]
	
	._setup_states(state_classes)




func start_attack(game_actor: Node2D):
	current_state.start_attack(game_actor)


func end_attack():
	current_state.end_attack()
