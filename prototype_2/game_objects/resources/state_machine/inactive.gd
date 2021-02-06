class_name ResourceStateInactive, "res://class_icons/states/icon_state.svg"
extends ResourceState




func _ready() -> void:
	name = INACTIVE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("active_state_set", false)



func damage(_damage_points: float, _sender) -> float:
	return 0.0


func pick_up_item(_new_inventory: Inventory) -> void:
	pass



func is_active() -> bool:
	return false
