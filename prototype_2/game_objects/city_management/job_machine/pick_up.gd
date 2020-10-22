class_name JobStatePickUp, "res://assets/icons/game_actors/states/icon_state_pick_up.svg"
extends JobStateMoveTo


var _item: Node2D = null
var _delivery_target: CityStructure = null




func _process(_delta: float):
	if not _item.is_active():
		if _delivery_target and game_actor.has_item(_item):
			exit(DELIVER, [_item, _delivery_target])
		else:
			exit(IDLE)




func enter(parameters: Array = [ ]):
	_item = parameters[0]
	_delivery_target = parameters[1]
	
	.enter([_delivery_target.global_position])


func exit(next_state: String, parameters: Array = [ ]):
	_item = null
	_delivery_target = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.TakeCommand.new(_item)
