class_name ObjectState, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends Node


const IDLE = "idle"
const INACTIVE = "inactive"
const DEAD = "dead"


onready var _state_machine = get_parent()
# warning-ignore-all:unused_class_variable
onready var _game_object = owner



func enter(_parameters: Array = [ ]):
	pass


func exit(next_state: String, parameters: Array = [ ]):
	_state_machine._change_to(next_state, parameters)



func damage(damage_points: float, _sender) -> float:
	return damage_points



func is_active() -> bool:
	return true




func _toggle_active_state(object: Node, new_state: bool):
	object.visible = new_state
	object.enable_collision(new_state)
	
	object.set_process(new_state)
	object.set_physics_process(new_state)
