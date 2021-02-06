class_name StateInactive, "res://class_icons/states/icon_state.svg"
extends ObjectState



func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("active_state_set", false)


func exit(next_state: String, parameters: Array = [ ]) -> void:
	emit_signal("active_state_set", true)
	
	.exit(next_state, parameters)



func damage(_damage_points: float, _sender) -> float:
	return 0.0


func is_active() -> bool:
	return false
