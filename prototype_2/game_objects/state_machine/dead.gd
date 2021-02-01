class_name StateDead, "res://class_icons/icon_state_dead.svg"
extends StateInactive


func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	game_object.die()


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass
