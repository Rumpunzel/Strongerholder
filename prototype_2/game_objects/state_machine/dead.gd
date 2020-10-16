class_name StateDead, "res://assets/icons/icon_state_dead.svg"
extends StateInactive


func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	_game_object.die()


func exit(_next_state: String, _parameters: Array = [ ]):
	pass
