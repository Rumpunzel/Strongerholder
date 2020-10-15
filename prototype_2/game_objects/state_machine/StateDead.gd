class_name StateDead, "res://assets/icons/icon_state_dead.svg"
extends ObjectState


func enter(_parameter: Array = [ ]):
	_game_object.die()


func exit(_next_state: String, _parameter: Array = [ ]):
	pass


func damage(_damage_points: float, _sender) -> float:
	return 0.0
