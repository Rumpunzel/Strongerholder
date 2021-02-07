class_name ObjectStateMachine, "res://class_icons/states/icon_state_machine.svg"
extends StateMachine


# warning-ignore:unused_signal
signal active_state_set
signal died

signal animation_changed



func damage(damage_points: float) -> float:
	return (current_state as ObjectState).damage(damage_points)


func die() -> void:
	change_to(ObjectState.DEAD)




func _setup_states(state_classes: Array = [ ]) -> void:
	._setup_states(state_classes)


func _connect_states() -> void:
	._connect_states()
	
	for state in get_children():
		state.connect("state_exited", self, "_change_to")
		state.connect("died", self, "_on_died")
		state.connect("animation_changed", self, "_on_animation_changed")



func _on_died() -> void:
	emit_signal("died")


func _on_animation_changed(new_animation: String, new_direction: Vector2 = Vector2()) -> void:
	emit_signal("animation_changed", new_animation, new_direction)
