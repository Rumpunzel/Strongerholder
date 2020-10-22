class_name JobStateDeliver, "res://assets/icons/game_actors/states/icon_state_deliver.svg"
extends JobStateMoveTo


var _item: Node2D = null
var _delivery_target: CityStructure = null




func _process(_delta: float):
	if not game_actor.has_item(_item):
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
	return InputMaster.GiveCommand.new(_item, _delivery_target)
