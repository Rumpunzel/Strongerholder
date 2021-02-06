class_name ObjectState, "res://class_icons/states/icon_state_idle.svg"
extends Node


signal state_exited
signal active_state_set
signal died


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name", "_animation_cancellable"]


const IDLE = "idle"
const INACTIVE = "inactive"
const DEAD = "dead"


var _animation_cancellable: bool = true




func exit(next_state: String, parameters: Array = [ ]) -> void:
	emit_signal("state_exited", next_state, parameters)



func damage(damage_points: float, _sender) -> float:
	return damage_points



func is_active() -> bool:
	return true



func _toggle_active_state(object: Node, new_state: bool) -> void:
	emit_signal("active_state_set", new_state)
