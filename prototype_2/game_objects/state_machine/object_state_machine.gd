class_name ObjectStateMachine, "res://class_icons/states/icon_state_machine.svg"
extends StateMachine


signal active_state_set
signal died



func damage(damage_points: float, sender) -> float:
	return current_state.damage(damage_points, sender)


func die() -> void:
	change_to(ObjectState.DEAD)




func _setup_states(state_classes: Array = [ ]) -> void:
	._setup_states(state_classes)
	
	for state in get_children():
		state.connect("state_exited", self, "_change_to")
		state.connect("died", self, "_on_died")



func _on_died() -> void:
	emit_signal("died")
