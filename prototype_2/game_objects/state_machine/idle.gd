class_name ObjectState, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends Node


const IDLE = "idle"
const INACTIVE = "inactive"
const DEAD = "dead"


onready var _state_machine = get_parent()
onready var _game_object = owner



func enter(_parameter: Array = [ ]):
	pass


func exit(next_state: String, parameter: Array = [ ]):
	_state_machine._change_to(next_state, parameter)



func damage(damage_points: float, _sender) -> float:
	return damage_points



func is_active() -> bool:
	return true
