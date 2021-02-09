class_name State
extends Node


signal state_entered
signal state_exited



func enter(_parameters: Array = [ ]) -> void:
	emit_signal("state_entered")

func exit(next_state: String, parameters: Array = [ ]) -> void:
	emit_signal("state_exited", next_state, parameters)



func is_active() -> bool:
	return true
