class_name JobStateDeliver, "res://assets/icons/game_actors/states/icon_state_deliver.svg"
extends JobStateMoveTo


var _delivery_target: PilotMaster = null
var _target_structure: Structure = null



func _process(_delta: float):
	if not _job_items().empty() and not employee.get_inventory_contents().has(_job_items().front()):
		var item: GameResource = _job_items().pop_front()
		
		item.unassign_worker(employee)
	
	if _job_items().empty():
		exit(IDLE)




func enter(parameters: Array = [ ]):
	assert(parameters.size() == 1)
	
	_delivery_target = parameters[0]
	_target_structure = _delivery_target.owner
	
	.enter([_delivery_target.global_position])


func exit(next_state: String, parameters: Array = [ ]):
	_delivery_target = null
	_target_structure = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.GiveCommand.new(_job_items().front(), _target_structure)


func current_target() -> Node2D:
	return _target_structure
