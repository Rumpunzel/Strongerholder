class_name ToolStateAttack, "res://assets/icons/game_actors/states/icon_state_attack.svg"
extends ToolStateInactive



func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	_game_object._enable_hurtbox(parameters[0])


func exit(next_state: String, parameters: Array = [ ]):
	_game_object._disable_hurtbox()
	
	.exit(next_state, parameters)



func end_attack():
	exit(INACTIVE)
