class_name JobStatePickUp, "res://assets/icons/game_actors/states/icon_state_pick_up.svg"
extends JobStateMoveTo


var _item: GameResource = null
var _delivery_target: PilotMaster = null




func _process(_delta: float):
	yield(get_tree(), "idle_frame")
	
	if not _item.is_active():
		if _delivery_target and _item.worker_assigned(employee):
			exit(DELIVER, [_item, _delivery_target.owner])
		else:
			exit(IDLE)




func enter(parameters: Array = [ ]):
	_item = parameters[0]
	_item.assign_worker(employee)
	
	_delivery_target = parameters[1]
	
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
