class_name ToolStateDead, "res://assets/icons/icon_state_dead.svg"
extends ToolStateInactive



func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	_game_object.die()


func exit(_next_state: String, _parameters: Array = [ ]):
	pass



func drop_item(_objects_layer: YSort, _position_to_drop: Vector2):
	pass


func start_attack(_game_actor: Node2D):
	pass
