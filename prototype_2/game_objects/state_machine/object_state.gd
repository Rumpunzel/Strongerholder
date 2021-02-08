class_name ObjectState, "res://class_icons/states/icon_state_idle.svg"
extends State


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := [ "_animation_cancellable" ]


signal active_state_set
# warning-ignore:unused_signal
signal died

# warning-ignore:unused_signal
signal animation_changed


const IDLE := "Idle"
const INACTIVE := "Inactive"
const DEAD := "Dead"


var _animation_cancellable: bool = true




func damage(damage_points: float) -> float:
	return damage_points



func _toggle_active_state(new_state: bool) -> void:
	emit_signal("active_state_set", new_state)
