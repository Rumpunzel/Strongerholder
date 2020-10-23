class_name JobStateOperate, "res://assets/icons/game_actors/states/icon_state_operate.svg"
extends JobStateMoveTo


var _structure_to_operate: CityStructure = null




func _process(_delta: float):
	if not _structure_to_operate.can_be_operated():
		exit(IDLE)




func enter(parameters: Array = [ ]):
	assert(parameters.size() == 2)
	
	_structure_to_operate = parameters[0]
	_structure_to_operate.assign_worker(employee)
	
	_job_items = parameters[1]
	
	.enter([_structure_to_operate.global_position])


func exit(next_state: String, parameters: Array = [ ]):
	_structure_to_operate.unassign_worker(employee)
	_structure_to_operate = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.InteractCommand.new(_structure_to_operate)


func current_target() -> Node2D:
	return _structure_to_operate
