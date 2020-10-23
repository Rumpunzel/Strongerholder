class_name JobStateDeliver, "res://assets/icons/game_actors/states/icon_state_deliver.svg"
extends JobStateMoveTo


var _item: GameResource = null
var _delivery_target: Structure = null




func _process(_delta: float):
	yield(get_tree(), "idle_frame")
	
	if not employee.get_inventory_contents().has(_item):
		exit(IDLE)




func enter(parameters: Array = [ ]):
	_item = parameters[0]
	_item.assign_worker(employee)
	
	_delivery_target = parameters[1]
	
	.enter([_delivery_target.global_position])


func exit(next_state: String, parameters: Array = [ ]):
	_item.unassign_worker(employee)
	_item = null
	
	_delivery_target = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.GiveCommand.new(_item, _delivery_target)

func current_target() -> Node2D:
	return _delivery_target
