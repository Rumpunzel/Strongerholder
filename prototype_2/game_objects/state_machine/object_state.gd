class_name ObjectState, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name", "_animation_cancellable"]
const PERSIST_OBJ_PROPERTIES := ["state_machine", "game_object"]


const IDLE = "idle"
const INACTIVE = "inactive"
const DEAD = "dead"


var state_machine = null
# warning-ignore-all:unused_class_variable
var game_object = null


var _animation_cancellable: bool = true



func enter(_parameters: Array = [ ]) -> void:
	assert(game_object)
	pass


func exit(next_state: String, parameters: Array = [ ]) -> void:
	state_machine._change_to(next_state, parameters)




func damage(damage_points: float, _sender) -> float:
	return damage_points



func is_active() -> bool:
	return true



func _toggle_active_state(object: Node, new_state: bool) -> void:
	object.visible = new_state
	object.enable_collision(new_state)
	
	object.set_process(new_state)
	object.set_physics_process(new_state)
