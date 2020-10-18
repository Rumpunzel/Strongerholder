class_name ToolStateMachine, "res://assets/icons/icon_tool_state_machine.svg"
extends ResourceStateMachine



func start_attack():
	current_state.start_attack()


func end_attack():
	current_state.end_attack()
