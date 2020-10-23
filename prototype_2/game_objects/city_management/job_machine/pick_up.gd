class_name JobStatePickUp, "res://assets/icons/game_actors/states/icon_state_pick_up.svg"
extends JobStateMoveTo


var _item: GameResource = null
var _delivery_target: PilotMaster = null




func _process(_delta: float):
	print("processing for some reason")
	if not _item.is_active():
		if _delivery_target and _item.worker_assigned(employee):
			_job_items.append(_item)
			print(_delivery_target.owner.name)
			exit(IDLE, [_job_items, _delivery_target])
			#exit(DELIVER, [_job_items, _delivery_target])
		else:
			exit(IDLE)




func enter(parameters: Array = [ ]):
	assert(parameters.size() == 3)
	print("ENTERING HERE FOR SOME REASON")
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
