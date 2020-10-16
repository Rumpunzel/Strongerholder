class_name StateInactive, "res://assets/icons/game_actors/states/icon_state.svg"
extends ObjectState



func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	_toggle_active_state(_game_object, false)


func exit(next_state: String, parameters: Array = [ ]):
	_toggle_active_state(_game_object, true)
	
	.exit(next_state, parameters)



func damage(_damage_points: float, _sender) -> float:
	return 0.0


func is_active() -> bool:
	return false
