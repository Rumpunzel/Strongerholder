class_name ResourceStateDead, "res://assets/icons/icon_state_dead.svg"
extends ResourceStateInactive



func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	_game_object.die()


func exit(_next_state: String, _parameters: Array = [ ]):
	pass



func drop_item(_objects_layer: YSort, _position_to_drop: Vector2):
	pass