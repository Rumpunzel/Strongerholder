class_name ResourceStateDead, "res://assets/icons/icon_state_dead.svg"
extends ResourceStateInactive




func _ready() -> void:
	name = DEAD




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	_game_object.die()


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass



func drop_item(_objects_layer: YSort, _position_to_drop: Vector2) -> void:
	pass


func transer_item(_new_inventory: Inventory) -> void:
	pass
