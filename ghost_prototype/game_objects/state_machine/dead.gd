class_name StateDead, "res://class_icons/states/icon_state_dead.svg"
extends StateInactive


func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("died")


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass
