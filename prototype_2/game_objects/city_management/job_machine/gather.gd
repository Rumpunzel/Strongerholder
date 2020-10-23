class_name JobStateGather, "res://assets/icons/game_actors/states/icon_state_gather.svg"
extends JobStateMoveTo


var _item_type = null
var _structure_to_gather_from: Structure = null
var _delivery_target: PilotMaster = null




func _process(_delta: float):
	if not _structure_to_gather_from.is_active():
		var nearest_item: GameResource = _get_nearest_item_of_type(_item_type)
		
		if nearest_item:
			exit(PICK_UP, [nearest_item, _delivery_target])




func enter(parameters: Array = [ ]):
	assert(parameters.size() == 3)
	
	_item_type = parameters[0]
	
	_structure_to_gather_from = parameters[1]
	_structure_to_gather_from.assign_worker(employee)
	
	_delivery_target = parameters[2]
	
	.enter([_structure_to_gather_from.global_position])


func exit(next_state: String, parameters: Array = [ ]):
	_item_type = null
	
	_structure_to_gather_from.unassign_worker(employee)
	_structure_to_gather_from = null
	
	_delivery_target = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.AttackCommand.new(dedicated_tool)

func current_target() -> Node2D:
	return _structure_to_gather_from
