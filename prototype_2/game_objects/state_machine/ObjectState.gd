class_name ObjectState, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false

const PERSIST_PROPERTIES := ["name", "_animation_cancellable"]
const PERSIST_OBJ_PROPERTIES := ["_state_machine", "_game_object"]


const IDLE = "idle"
const INACTIVE = "inactive"
const DEAD = "dead"


var _state_machine = null
# warning-ignore-all:unused_class_variable
var _game_object = null

var _animation_cancellable: bool = true




func _ready():
	if not _state_machine:
		_state_machine = get_parent()
	
	if not _game_object:
		_game_object = owner



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
