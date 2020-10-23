class_name JobStatePickUp, "res://assets/icons/game_actors/states/icon_state_pick_up.svg"
extends JobStateMoveTo


var _item: GameResource = null
var _delivery_target: PilotMaster = null




func _process(_delta: float):
	if not _item.is_active():
		print(_delivery_target)
		if _delivery_target:
			_job_items.append(_item)
			
			exit(IDLE, [_job_items, _delivery_target])
			#exit(DELIVER, [_job_items, _delivery_target])
		else:
			exit(IDLE)




func enter(parameters: Array = [ ]):
	assert(parameters.size() == 3)
	
	_item = parameters[0]
	_item.assign_worker(employee)
	
	_delivery_target = parameters[1]
	_job_items = parameters[2]
	
	.enter([_item.global_position])


func exit(next_state: String, parameters: Array = [ ]):
	_item.unassign_worker(employee)
	_item = null
	
	_delivery_target = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.TakeCommand.new(_item)

func current_target() -> Node2D:
	return _item
