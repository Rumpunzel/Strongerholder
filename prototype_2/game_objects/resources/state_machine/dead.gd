class_name ResourceStateDead, "res://class_icons/states/icon_state_dead.svg"
extends ResourceStateInactive




func _ready() -> void:
	name = DEAD




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("died")


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass



func drop_item(_position_to_drop: Vector2) -> void:
	pass


func transfer_item(_new_inventory: Inventory) -> void:
	pass
