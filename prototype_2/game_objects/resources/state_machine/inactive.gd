class_name ResourceStateInactive, "res://class_icons/states/icon_state.svg"
extends ResourceState




func _ready() -> void:
	name = INACTIVE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("active_state_set", false)


func exit(next_state: String, parameters: Array = [ ]) -> void:
	emit_signal("active_state_set", true)
	
	.exit(next_state, parameters)



func damage(_damage_points: float) -> float:
	return 0.0


func pick_up_item() -> bool:
	return false



func is_active() -> bool:
	return false
