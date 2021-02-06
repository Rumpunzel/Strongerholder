class_name ToolStateInactive, "res://class_icons/states/icon_state.svg"
extends ToolState




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


func pick_up_item(_new_inventory) -> void:
	pass



func is_active() -> bool:
	return false
