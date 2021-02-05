class_name ToolStateMachine, "res://class_icons/states/icon_tool_state_machine.svg"
extends ResourceStateMachine



func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			ToolStateInactive,
			ToolState,
			ToolStateAttack,
			ToolStateDead,
		]
	
	._setup_states(state_classes)




func start_attack(game_actor: Node2D) -> void:
	current_state.start_attack(game_actor)


func end_attack() -> void:
	current_state.end_attack()
